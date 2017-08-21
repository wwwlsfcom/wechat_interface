using System.Collections.Generic;
using System.IO;
using System.Linq;
/// <summary>
/// Summary description for Class1
/// </summary>
public class GenericWebUtil
{
    public GenericWebUtil()
    {

    }

    public static bool Director { get; private set; }

    /// <summary>
    /// 获取微信公众号新令牌
    /// </summary>
    /// <returns></returns>
    public static string GetAccessToken()
    {
        string appid = "wx09790c5d9d7b5edf";
        string secret = "0d48085faf6837690099e6c76d4d8427";

        string requestUrl = "https://api.weixin.qq.com/cgi-bin/token?grant_type=client_credential&appid={0}&secret={1}";
        requestUrl = string.Format(requestUrl, appid, secret);

        System.Net.Http.HttpClient httpClient = new System.Net.Http.HttpClient();
        System.Threading.Tasks.Task<string> task = httpClient.GetStringAsync(requestUrl);
        task.Wait();
        string jsonData = task.Result;
        Newtonsoft.Json.Linq.JObject o = (Newtonsoft.Json.Linq.JObject)Newtonsoft.Json.JsonConvert.DeserializeObject(jsonData);
        object v = o.GetValue("access_token");
        return v+"";
    }
}