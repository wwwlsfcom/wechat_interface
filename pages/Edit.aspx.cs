using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Edit : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        string downLoadUrl = "https://api.weixin.qq.com/cgi-bin/media/get?access_token={0}&media_id={1}";
        string accessToken = GenericWebUtil.GetAccessToken();
        var pmediaId = Request.Params["media_id"];
        downLoadUrl = string.Format(downLoadUrl, accessToken, pmediaId);
        photo_url.Value = downLoadUrl;
       // DownLoadImage(downLoadUrl);
        capture_photo1.Style.Add("background-image", downLoadUrl);

        //mediaId.Value = pmediaId;
    }


}