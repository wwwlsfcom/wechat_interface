<%@ WebHandler Language="C#" Class="SaveTroubleHandler" %>

using System;
using System.Web;
using System.IO;
using System.Text;

public class SaveTroubleHandler : IHttpHandler
{

    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "text/plain";
        TroubleModel trouble = create(context.Request);
        string photoUrl = context.Request.Params["photo_url"];
        if (!string.IsNullOrEmpty(photoUrl))
        {
            string photoFileName = DownLoadImage(photoUrl);
            trouble.CapturePhoto = photoFileName;
        }
        SaveTrouble(trouble);
        context.Response.Write("success");
    }


    private TroubleModel create(HttpRequest request)
    {
        if (request == null)
            return null;

        TroubleModel trouble = new TroubleModel();
        trouble.TroubleDescribe = request.Params["trouble_describe"];
        trouble.TroublePosition = request.Params["trouble_position"];
        return trouble;
    }

    private void SaveTrouble(TroubleModel trouble)
    {
        if (trouble == null) return;

        TroubleBiz biz = new TroubleBiz();
        biz.Save(trouble);
    }


    private string DownLoadImage(string requestUrl)
    {
        string path = System.Configuration.ConfigurationManager.AppSettings["PhotoSavePath"];
        string fileName = System.Guid.NewGuid().ToString();
        path = System.IO.Path.Combine(path, fileName);
        System.Net.Http.HttpClient httpClient = new System.Net.Http.HttpClient();
        byte[] reqData = httpClient.GetByteArrayAsync(requestUrl).Result;
        if (reqData == null || reqData.Length == 0)
            return "";
        FileStream fs = new FileStream(path, FileMode.Create);
        fs.Write(reqData, 0, reqData.Length);
        fs.Close();
        return fileName;
    }

    /// <summary>
    /// 保存微信用户发送的图片ID
    /// </summary>
    private void saveMediaId(string mediaId)
    {
        if (string.IsNullOrEmpty(mediaId)) return;
        string downLoadUrl = "https://api.weixin.qq.com/cgi-bin/media/get?access_token={0}&media_id={1}";
        string accessToken = GetNewAccessToken();
        downLoadUrl = string.Format(downLoadUrl, accessToken, mediaId);
        System.Net.Http.HttpClient httpClient = new System.Net.Http.HttpClient();
        System.Threading.Tasks.Task<byte[]> task = httpClient.GetByteArrayAsync(downLoadUrl);
        task.Wait();
        byte[] imgdata = task.Result;
        string imgFilePath = HttpContext.Current.Server.MapPath("~/ProblemImages/" + mediaId + ".jpg");
        FileInfo file = new FileInfo(imgFilePath);
        FileStream fs = file.OpenWrite();
        fs.Write(imgdata, 0, imgdata.Length);
        fs.Close();
    }

    /// <summary>
    /// 获取新令牌
    /// </summary>
    /// <returns></returns>
    private string GetNewAccessToken()
    {
        return "qNHIR7JWlUAUYyLq7VVxUn_HHVdu2Nv7KjO_wuemlMn99S4WKXk94JinwiH_x_hFthXm65sMAaL6YB5i1qASGQn8YwhNxyXVBrvNc4_ER0ZqvVsZ9bmGWpBJHLgExoaHTVKjAEAZBQ";
    }

    public bool IsReusable
    {
        get
        {
            return false;
        }
    }

}