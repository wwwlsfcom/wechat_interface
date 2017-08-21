<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Check.aspx.cs" Inherits="Check" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width,initial-scale=1,user-scalable=0">
    <meta name="format-detection" content="telephone=no">
    <title>中交联盟路BIM平台</title>
    <link href="../weui/style/weui.css" rel="stylesheet" />
    <script src="../jquery/js/jquery-3.2.1.js"></script>
</head>
<body>

    <div id="container">
        <div class="weui-cells" id="trouble_list" runat="server">
        </div>
    </div>
    <div id="bigImgView" class="weui-gallery">
        <span class="weui-gallery__img"></span>
        <div class="weui-gallery__opr">
            <a href="javascript:" class="weui-gallery__del">
                <i class="weui-icon-cancel weui-icon_gallery-delete"></i>
            </a>
        </div>
    </div>
    <div class="weui-footer weui-footer_fixed-bottom">
        <p class="weui-footer__text">Copyright &copy; 2017 中交（厦门）信息有限公司</p>
    </div>
    <script>
        $(function () {
            $(".weui-cell").on("click", function (e) {
                var photoUrl = "../handler/DoLoadPhotoHandler.ashx?photo=" + $(this).attr("data-photo");
                $(".weui-gallery__img").css("background-image", "url(" + photoUrl + ")");
                $("#bigImgView").fadeIn(200);
                e.preventDefault();


                var url = "../handler/DoSetIsNewHandler.ashx";
                var data = {
                    id: $(this).attr("data-id")
                };
                $.get(url, data);

                $(this).find(".weui-badge").hide();
            });
            $("#bigImgView").find("a").on("click", function (e) {
                $("#bigImgView").fadeOut(200);
            });
        });
    </script>
</body>
</html>
