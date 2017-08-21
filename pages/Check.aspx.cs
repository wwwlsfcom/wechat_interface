using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Check : System.Web.UI.Page
{
    protected TroubleBiz biz = new TroubleBiz();

    protected void Page_Load(object sender, EventArgs e)
    {

        List<TroubleModel> troubles = biz.List();
        trouble_list.InnerHtml = "";
        if (troubles != null && troubles.Count > 0)
        {
            for (int i = 0, len = troubles.Count; i < len; i++)
            {
                int number = i + 1;
                TroubleModel trouble = troubles[i];
                string content = trouble.TroubleDescribe + ", " + trouble.TroublePosition;

                string newFlag = trouble.IsNew ? "" : "display:none";
                string id = trouble.ID;
                string htmlFragment = string.Format(TroublesViewTempl, number, content, trouble.CapturePhoto, newFlag, id);
                trouble_list.InnerHtml += htmlFragment;
            }
        }
    }

    private string TroublesViewTempl
    {
        get
        {
            return @"
            <a class='weui-cell weui-cell_access' href='javascript:; ' data-photo='{2}' data-id='{4}'>
                <div class='weui-cell__hd'>
                    <span style='margin-right: 15px; color:gray'>NO. {0}</span></div>
                <div class='weui-cell__bd'><p>{1}</p></div>
                <div class='weui-cell__ft'>   
                    <span>查看照片</span>
                    <span class='weui-badge weui-badge_dot' style='margin-left: 5px; margin-right: 5px;{3}'></span>
                </div>
            </a>";
        }
    }
}