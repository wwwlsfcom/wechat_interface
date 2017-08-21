<%@ WebHandler Language="C#" Class="WechatHandler" %>

using System;
using System.Web;
using System.IO;
using System.Text;


public class WechatHandler : IHttpHandler
{

    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "text/plain";
        if (context.Request.HttpMethod.ToLower() == "post")
        {
            //回复消息的时候也需要验证消息，这个很多开发者没有注意这个，存在安全隐患  
            //微信中 谁都可以获取信息 所以 关系不大 对于普通用户 但是对于某些涉及到验证信息的开发非常有必要
            if (CheckSignature())
            {
                //接收消息
                DoWechat(context);
            }
            else
            {
                HttpContext.Current.Response.Write("消息并非来自微信");
                HttpContext.Current.Response.End();
            }
        }
        else
        {
            CheckWechat();
        }
    }

    #region 处理消息收发

    private void DoWechat(HttpContext param_context)
    {
        using (Stream stream = HttpContext.Current.Request.InputStream)
        {
            Byte[] postBytes = new Byte[stream.Length];
            stream.Read(postBytes, 0, (Int32)stream.Length);
            string postString = Encoding.UTF8.GetString(postBytes);
            string msgType = ExtractMessageType(postString);
            if (msgType == "text")
            {
                string returnContent = TextHandle(postString);
                param_context.Response.Write(returnContent);
            }
            else if (msgType == "image")
            {

                System.Xml.XmlDocument xmldoc = new System.Xml.XmlDocument();
                xmldoc.InnerXml = postString;
                System.Xml.XmlNode MediaId = xmldoc.SelectSingleNode("/xml/MediaId");
                if (MediaId != null)
                {
                    //saveMediaIdAsync(MediaId.InnerText);
                }

                string returnContent = ImageHandle(postString);
                param_context.Response.Write(returnContent);
            }
            else if (msgType == "event")
            {
                string returnContent = EventHandle(postString);
                param_context.Response.Write(returnContent);
            }
            else
            {
                string returnContent = UnknowHandle(postString);
                param_context.Response.Write(returnContent);
            }
        }
    }

    /// <summary>
    /// 解析消息类型
    /// </summary>
    /// <param name="inputMessageXML"></param>
    /// <returns></returns>
    public string ExtractMessageType(string inputMessageXML)
    {
        System.Xml.XmlDocument xmldoc = new System.Xml.XmlDocument();
        xmldoc.InnerXml = inputMessageXML;

        System.Xml.XmlNode msgType = xmldoc.SelectSingleNode("/xml/MsgType");
        if (msgType == null)
            return "unknown";
        else
            return msgType.InnerText;
    }

    /// <summary>
    /// 处理事件类型信息并应答
    /// </summary>
    private string EventHandle(string inputMessageXML)
    {
        System.Xml.XmlDocument xmldoc = new System.Xml.XmlDocument();
        xmldoc.InnerXml = inputMessageXML;

        string responseContent = "";
        System.Xml.XmlNode ToUserName = xmldoc.SelectSingleNode("/xml/ToUserName");
        System.Xml.XmlNode FromUserName = xmldoc.SelectSingleNode("/xml/FromUserName");
        System.Xml.XmlNode mdeiaid = xmldoc.SelectSingleNode("/xml/SendPicsInfo/PicList/item/PicMd5Sum");
        if (mdeiaid != null)
        {
            responseContent = string.Format(Message_Text_Templ,
                FromUserName.InnerText,
                ToUserName.InnerText,
                DateTime.Now.Ticks,
                "你发送的图片 Md5码：" + mdeiaid.InnerText);
        }
        else
        {
            responseContent = string.Format(Message_Text_Templ,
                         FromUserName.InnerText,
                         ToUserName.InnerText,
                         DateTime.Now.Ticks,
                         "你发送的图片 Md5码：" + "null");
        }
        return responseContent;
    }

    /// <summary>
    /// 处理图片信息并应答
    /// </summary>
    private string ImageHandle(string inputMessageXML)
    {
        System.Xml.XmlDocument xmldoc = new System.Xml.XmlDocument();
        xmldoc.InnerXml = inputMessageXML;

        string responseContent = "";
        System.Xml.XmlNode ToUserName = xmldoc.SelectSingleNode("/xml/ToUserName");
        System.Xml.XmlNode FromUserName = xmldoc.SelectSingleNode("/xml/FromUserName");
        System.Xml.XmlNode MediaId = xmldoc.SelectSingleNode("/xml/MediaId");
        if (MediaId != null)
        {
            var mediaId = MediaId.InnerText;
            string hostname = HttpContext.Current.Request.Url.Authority;
            string jumpUrl = "http://{0}/pages/Edit.aspx?media_id={1}";
            jumpUrl = string.Format(jumpUrl, hostname, mediaId);

            string htmlBlock = " <a href='" + jumpUrl + "'>请填写安全质量问题详情, 下一步 >></a>";

            responseContent = string.Format(Message_Text_Templ,
               FromUserName.InnerText,
               ToUserName.InnerText,
               DateTime.Now.Ticks,
              htmlBlock);
        }
        return responseContent;
    }

    /// <summary>
    /// 保存微信用户发送的图片ID
    /// </summary>
    private async System.Threading.Tasks.Task saveMediaIdAsync(string mediaId)
    {
        if (string.IsNullOrEmpty(mediaId)) return;
        string downLoadUrl = "https://api.weixin.qq.com/cgi-bin/media/get?access_token={0}&media_id={1}";
        string accessToken = GenericWebUtil.GetAccessToken();
        downLoadUrl = string.Format(downLoadUrl, accessToken, mediaId);
        System.Net.Http.HttpClient httpClient = new System.Net.Http.HttpClient();
        System.Threading.Tasks.Task<byte[]> task = httpClient.GetByteArrayAsync(downLoadUrl);
        byte[] imgdata = await task;
        string imgFilePath = HttpContext.Current.Server.MapPath("~/ProblemImages/" + mediaId + ".jpg");
        FileInfo file = new FileInfo(imgFilePath);
        FileStream fs = file.OpenWrite();
        await fs.WriteAsync(imgdata, 0, imgdata.Length);
        fs.Close();

        //FileInfo file = new FileInfo(System.IO.Path.Combine("ProblemImages", mediaId));
        //FileStream fs = file.Create();
        //if (fs != null)
        //    fs.Close();
    }


    //接受文本消息
    public string UnknowHandle(string inputMessageXML)
    {
        System.Xml.XmlDocument xmldoc = new System.Xml.XmlDocument();
        xmldoc.InnerXml = inputMessageXML;

        string responseContent = "";
        System.Xml.XmlNode ToUserName = xmldoc.SelectSingleNode("/xml/ToUserName");
        System.Xml.XmlNode FromUserName = xmldoc.SelectSingleNode("/xml/FromUserName");
        System.Xml.XmlNode Content = xmldoc.SelectSingleNode("/xml/Content");
        if (Content != null)
        {
            responseContent = string.Format(Message_Text_Templ,
                FromUserName.InnerText,
                ToUserName.InnerText,
                DateTime.Now.Ticks,
                "未知消息");
        }
        return responseContent;
    }

    //接受文本消息
    public string TextHandle(string inputMessageXML)
    {
        System.Xml.XmlDocument xmldoc = new System.Xml.XmlDocument();
        xmldoc.InnerXml = inputMessageXML;

        string responseContent = "";
        System.Xml.XmlNode ToUserName = xmldoc.SelectSingleNode("/xml/ToUserName");
        System.Xml.XmlNode FromUserName = xmldoc.SelectSingleNode("/xml/FromUserName");
        System.Xml.XmlNode Content = xmldoc.SelectSingleNode("/xml/Content");
        if (Content != null)
        {
            responseContent = string.Format(Message_Text_Templ,
                FromUserName.InnerText,
                ToUserName.InnerText,
                DateTime.Now.Ticks,
                "欢迎使用微信公共账号，您输入的内容为：" + Content.InnerText + "\r\n<a href=\"http://www.cnblogs.com\">点击进入</a>");
        }
        return responseContent;
    }

    /// <summary>
    ///  普通文本消息
    /// </summary>
    public static string Message_Text_Templ
    {
        get { return @"<xml>
                            <ToUserName><![CDATA[{0}]]></ToUserName>
                            <FromUserName><![CDATA[{1}]]></FromUserName>
                            <CreateTime>{2}</CreateTime>
                            <MsgType><![CDATA[text]]></MsgType>
                            <Content><![CDATA[{3}]]></Content>
                            </xml>"; }
    }

    /// <summary>
    /// 图片消息
    /// </summary>
    public static string Message_Image_Templ
    {
        get { return @"<xml>
                            <ToUserName><![CDATA[{0}]]></ToUserName>
                            <FromUserName><![CDATA[{1}]]></FromUserName>
                            <CreateTime>{2}</CreateTime>
                            <MsgType><![CDATA[image]]></MsgType>
                            <Image>
                                <MediaId><![CDATA[{3}]]></MediaId>
                            </Image>
                        </xml>"; }
    }
    #endregion

    #region 验证微信签名
    /// <summary>
    /// 返回随机数表示验证成功
    /// </summary>
    private void CheckWechat()
    {
        if (string.IsNullOrEmpty(HttpContext.Current.Request.QueryString["echoStr"]))
        {
            HttpContext.Current.Response.Write("消息并非来自微信");
            HttpContext.Current.Response.End();
        }
        string echoStr = HttpContext.Current.Request.QueryString["echoStr"];
        if (CheckSignature())
        {
            HttpContext.Current.Response.Write(echoStr);
            HttpContext.Current.Response.End();
        }
    }

    /// <summary>
    /// 验证微信签名
    /// </summary>
    /// <returns></returns>
    /// * 将token、timestamp、nonce三个参数进行字典序排序
    /// * 将三个参数字符串拼接成一个字符串进行sha1加密
    /// * 开发者获得加密后的字符串可与signature对比，标识该请求来源于微信。
    private bool CheckSignature()
    {
        string access_token = "wwwlsfcn";

        string signature = HttpContext.Current.Request.QueryString["signature"].ToString();
        string timestamp = HttpContext.Current.Request.QueryString["timestamp"].ToString();
        string nonce = HttpContext.Current.Request.QueryString["nonce"].ToString();
        string[] ArrTmp = { access_token, timestamp, nonce };
        Array.Sort(ArrTmp);     //字典排序
        string tmpStr = string.Join("", ArrTmp);
        tmpStr = System.Web.Security.FormsAuthentication.HashPasswordForStoringInConfigFile(tmpStr, "SHA1");
        if (tmpStr.ToLower() == signature)
        {
            return true;
        }
        else
        {
            return false;
        }
    }
    #endregion

    public bool IsReusable
    {
        get
        {
            return false;
        }
    }

}