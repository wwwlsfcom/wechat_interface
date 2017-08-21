using LiuShengFeng.Core;
using System.Collections.Generic;
using System.Data;

/// <summary>
/// Summary description for TroubleBiz
/// </summary>
public class TroubleBiz
{
    private SQLHelper _sqlHelper;

    public TroubleBiz()
    {
        _sqlHelper = new SQLHelper(System.Configuration.ConfigurationManager.AppSettings["SqlServerConnectionString"]); ;
    }

    public void Save(TroubleModel trouble)
    {
        if (trouble == null)
            return;

        if (_sqlHelper == null)
            return;

        string sql = "insert into T_troubles(id,photo, describe, position) values(@id,@photo, @describe, @position)";
        Dictionary<string, object> parameters = new Dictionary<string, object>();
        string id = System.Guid.NewGuid().ToString();
        parameters.Add("describe", trouble.TroubleDescribe);
        parameters.Add("position", trouble.TroublePosition);
        parameters.Add("id", id);
        parameters.Add("photo",trouble.CapturePhoto);
        _sqlHelper.ExecuteNotQuery(sql, parameters);
    }

    public void SetIsNew(bool isNew, string id)
    {
        if (string.IsNullOrEmpty(id))
            return;

        if (_sqlHelper == null)
            return;

        string sql = "update T_troubles set isNew=@isNew where id=@id";
        Dictionary<string, object> parameters = new Dictionary<string, object>();
       
        parameters.Add("isNew", isNew);
        parameters.Add("id", id);
        _sqlHelper.ExecuteNotQuery(sql, parameters);
    }


    public List<TroubleModel> List()
    {
        if (_sqlHelper == null)
            return null;

        string sql = "select id, photo, describe, position,isNew from T_troubles";

        DataTable dt = _sqlHelper.ExecuteQuery(sql);
        if (dt == null)
            return null;

        List<TroubleModel> troubles = new List<TroubleModel>();
        foreach (DataRow dr in dt.Rows)
        {
            TroubleModel trouble = new TroubleModel();
            trouble.TroubleDescribe = dr["describe"] + "";
            trouble.TroublePosition = dr["position"] + "";
            trouble.CapturePhoto = dr["photo"] + "";
            trouble.ID = dr["id"] + "";
            bool isNew = false;
            bool.TryParse(dr["isNew"] + "", out isNew);
            trouble.IsNew = isNew;
            troubles.Add(trouble);
        }

        return troubles;
    }
}