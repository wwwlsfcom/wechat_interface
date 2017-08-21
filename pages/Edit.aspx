<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Edit.aspx.cs" Inherits="Edit" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width,initial-scale=1,user-scalable=0">
    <title>中交联盟路BIM平台</title>
    <link href="../weui/style/weui.css" rel="stylesheet" />
    <script src="../jquery/js/jquery-3.2.1.js"></script>
</head>
<body>

    <input type="hidden" id="photo_url" runat="server" />

    <div class="weui-cells__title">
        <p>
            安全质量问题填报
        </p>
    </div>
    <div class="weui-cells weui-cells_form">
        <div class="weui-cell">
            <div class="weui-cell__bd">
                <ul class="weui-uploader__files" id="uploaderFiles">
                    <li class="weui-uploader__file" id="capture_photo1" runat="server"></li>
                </ul>
            </div>
        </div>
        <div class="weui-cell">
            <div class="weui-cell__bd">
                <textarea class="weui-textarea js-inputbox" id="trouble_position" placeholder="请填写具体位置" rows="3"></textarea>
                <div class="weui-textarea-counter"><span>0</span>/200</div>
            </div>
        </div>

        <div class="weui-cell">
            <div class="weui-cell__bd">
                <textarea class="weui-textarea js-inputbox" id="trouble_describe" placeholder="请描述问题内容" rows="3"></textarea>
                <div class="weui-textarea-counter"><span>0</span>/200</div>
            </div>
        </div>
        <div class="weui-cell">
            <div class="weui-cell__bd">
                <a id="btn_submit" href="javascript:;" class="weui-btn weui-btn_primary">提交</a>
            </div>
        </div>
    </div>

    <!--BEGIN dialog-->
    <div class="js_dialog" id="iosDialog" style="display: none;">
        <div class="weui-mask"></div>
        <div class="weui-dialog">
            <div class="weui-dialog__bd">安全质量问题已提交</div>
            <div class="weui-dialog__ft">
                <a href="javascript:;" class="weui-dialog__btn weui-dialog__btn_primary">知道了</a>
            </div>
        </div>
    </div>
    <!--END dialog-->

    <div class="weui-footer weui-footer_fixed-bottom">
        <p class="weui-footer__text">Copyright &copy; 2017 中交（厦门）信息有限公司</p>
    </div>

    <script type="text/javascript">

        //初始化对话框操作
        $(function () {
            $('#iosDialog').on('click', '.weui-dialog__btn', function () {
                $(this).parents('.js_dialog').fadeOut(200);
            });
        });

        //初始化文本编辑操作
        $(function () {
            $(".js-inputbox").on("keyup", function (e) {
                //统计用户当前输入的字数
                var charCount = ($(this).val() + "").length;
                var d = $(this).next();
                var s = d.find("span");
                s.html(charCount);
            });

        });

        //初始化表单提交操作 
        $(function () {

            function success() {
                $('#iosDialog').fadeIn(200);
            }

            function formSumbit(e) {

                var data = {
                    photo_url: $("#photo_url").val(),
                    trouble_position: $("#trouble_position").val(),
                    trouble_describe: $("#trouble_describe").val()
                };

                $.ajax({
                    type: "POST",
                    url: "../handler/SaveTroubleHandler.ashx",
                    data: data,
                    success: success,
                    dataType: "text"
                });
                e.preventDefault();
            }
                       

            $("#btn_submit").on("click", formSumbit); 
        });
    </script>

</body>
</html>
