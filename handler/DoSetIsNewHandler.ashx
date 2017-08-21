<%@ WebHandler Language="C#" Class="DoSetIsNewHandler" %>

using System;
using System.Web;

/// <summary>
/// 更新消息已经阅读的标记
/// </summary>
public class DoSetIsNewHandler : IHttpHandler
{

    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "text/plain";

        string id = context.Request.Params["ID"];

        TroubleBiz biz = new TroubleBiz();
        biz.SetIsNew(false, id);

        context.Response.Write("success");
    }

    public bool IsReusable
    {
        get
        {
            return false;
        }
    }

}