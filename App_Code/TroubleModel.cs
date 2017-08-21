using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

/// <summary>
/// Summary description for TroubleModel
/// </summary>
public class TroubleModel
{
    public string ID
    {
        get;
        set;
    }

    public string CapturePhoto
    {
        get;
        set;
    }

   public  bool IsNew
    {
        get;
        set;
    }

    public string TroublePosition
    {
        get;
        set;
    }

    public string TroubleDescribe
    {
        get;
        set;
    }



    public TroubleModel()
    {
        //
        // TODO: Add constructor logic here
        //
    }
}