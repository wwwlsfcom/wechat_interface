<%@ WebHandler Language="C#" Class="DoLoadPhotoHandler" %>

using System;
using System.Web;
using System.IO;

public class DoLoadPhotoHandler : IHttpHandler
{

    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "image/*";

        string photoFileName = context.Request.Params["photo"];
        string path = System.Configuration.ConfigurationManager.AppSettings["PhotoSavePath"];
        path = System.IO.Path.Combine(path, photoFileName);
        //FileStream fs = new FileStream(path, FileMode.OpenOrCreate);
        //byte[] data = new byte[fs.Length];
        //fs.Read(data, 0, data.Length);
        //fs.Close();
        context.Response.WriteFile(path);
    }

    public bool IsReusable
    {
        get
        {
            return false;
        }
    }

}