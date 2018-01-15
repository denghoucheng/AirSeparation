<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//Dtd HTML 4.01 Transitional//EN" "http://www.w3.org/tr/html4/loose.dtd">
<html >
<head >
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title >生产数据远程管理系统</title>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery-3.2.1/jquery-3.2.1.min.js"></script>
<style type="text/css">
    .errInfo {display:none;color:red;}
</style>
<style type=text/css>
BODY {
    TEXT-ALIGN: center;
    PADDING-BOTTOM: 0px;
    BACKGROUND-COLOR: #ddeef2;
    MARGIN: 0px;
    PADDING-LEFT: 0px;
    PADDING-RIGHT: 0px;
    PADDING-TOP: 0px
}

A:link {
    COLOR: #000000;
    TEXT-DECORATION: none
}

A:visited {
    COLOR: #000000;
    TEXT-DECORATION: none
}

A:hover {
    COLOR: #ff0000;
    TEXT-DECORATION: underline
}

A:active {
    TEXT-DECORATION: none
}

.input {
    BORDER-BOTTOM: #ccc 1px solid;
    BORDER-LEFT: #ccc 1px solid;
    BORDER-TOP: #ccc 1px solid;
    BORDER-RIGHT: #ccc 1px solid;
    LINE-HEIGHT: 20px;
    WIDTH: 182px;
    HEIGHT: 20px
}

.input1 {
    BORDER-BOTTOM: #ccc 1px solid;
    BORDER-LEFT: #ccc 1px solid;
    LINE-HEIGHT: 20px;
    WIDTH: 120px;
    HEIGHT: 20px;
    BORDER-TOP: #ccc 1px solid;
    BORDER-RIGHT: #ccc 1px solid;
}
</style>
<script type="text/javascript">
 	var errInfo = "${errInfo}";
	$(document).ready(function(){
	    changeCode();//随机产生验证码
	    $("#codeImg").bind("click",changeCode);
	    if(errInfo!=""){
	        if(errInfo.indexOf("验证码")>-1){
	            $("#codeerr").show();
	            $("#codeerr").html(errInfo);
	            $("#code").focus();
	        }else{
	            $("#nameerr").show();
	            $("#nameerr").html(errInfo);
	        }
	    }
	    $("#loginname").focus();
	    
	    if(window.parent != window){
	        window.parent.location.reload(true);
	    }
	    
	});
	
	function genTimestamp(){
        var time = new Date();
        return time.getTime();
    }

   	function changeCode(){
    	$("#codeImg").prop("src","code.html?t="+genTimestamp());
   	}
    
	function resetErr(){
        $("#nameerr").hide();
        $("#nameerr").html("");
        $("#pwderr").hide();
        $("#pwderr").html("");
        $("#codeerr").hide();
        $("#codeerr").html("");
    }
    
    function check(){
        resetErr();
        if($("#loginname").val()==""){
            $("#nameerr").show();
            $("#nameerr").html("用户名不为空！");
            $("#loginname").focus();
            return false;
        }
        if($("#password").val()==""){
            $("#pwderr").show();
            $("#pwderr").html("密码不为空！");
            $("#password").focus();
            return false;
        }
        if($("#code").val()==""){
            $("#codeerr").show();
            $("#codeerr").html("验证码不为空！");
            $("#code").focus();
            return false;
        }
        return true;
    }
</script>
</head>
<body>
<form id=adminlogin method=post name=adminlogin action="${pageContext.request.contextPath}/login.html" onsubmit="return check();">
<div></div>
<table style="MARGIN: auto; WIDTH: 100%; HEIGHT: 100%" border=0 cellSpacing=0 cellPadding=0>
    <tbody>
    <tr>
        <td height=150>&nbsp;</td>
    </tr>
    <tr style="HEIGHT: 254px">
        <td>
            <div style="MARGIN: 0px auto; WIDTH: 936px">
                <IMG style="DISPLAY: block" src="${pageContext.request.contextPath}/images/body_03_1.jpg">
            </div>
            <div style="BACKGROUND-COLOR: #278296">
           	 <div style="MARGIN: 0px auto; WIDTH: 936px">
                <div style="BACKGROUND: url(${pageContext.request.contextPath}/images/body_05_gai.jpg) no-repeat; HEIGHT: 155px">
                    <div style="TEXT-ALIGN: left; WIDTH: 265px; FLOAT: right; HEIGHT: 125px; _height: 95px">
                        <table border=0 cellSpacing=0 cellPadding=0 width="100%">
                         <tbody>
                         <tr>
                            <td style="HEIGHT: 45px">
                                <input style="height:18px;width:172px;vertical-align:middle;" type="text" name="loginname" id="loginname"  value="${loginname }"/>
                                 &nbsp;<span id="nameerr" class="errInfo"></span>
                            </td>
                          </tr>
                          <tr>
                                <td>
                                    <input style="height:18px;width:172px;vertical-align:middle;" type="password" name="password" id="password"  value="${password }"/>
                                     &nbsp;<span id="pwderr" class="errInfo"></span>
                                </td>
                           </tr>
                           <tr>
        						<td height=10></td>
    						</tr>
                           <tr>
                                <td>
                                  <div ><input  style="height:18px;width:86px;vertical-align:middle;"type="text" name="code" id="code" class="login_code"/> 
                                  <img style="height:25px;width:80px;vertical-align:middle;"id="codeImg"  alt="点击更换" title="点击更换" src=""/>
                                  </div>
                                </td>
                           </tr> 
                        </tbody>
                        </table>
                    </div>
                    <div style="HEIGHT: 1px; CLEAR: both"></div>
                    <div style="WIDTH: 35.45%; FLOAT: right; CLEAR: both">
                        <table border=0 cellSpacing=0 cellPadding=0 width=300>
                          <tbody>
                            <tr>
                                <td><input style="BORDER-RIGHT-WIDTH: 0px; BORDER-TOP-WIDTH: 0px; BORDER-BOTTOM-WIDTH: 0px; BORDER-LEFT-WIDTH: 0px"
                                        id=btnLogin src="${pageContext.request.contextPath}/images/btn1.jpg" 
                                        type=image name=btnLogin onclick="">
                                &nbsp;<input style="BORDER-RIGHT-WIDTH: 0px; BORDER-TOP-WIDTH: 0px; BORDER-BOTTOM-WIDTH: 0px; BORDER-LEFT-WIDTH: 0px"
                                        id=btnReset src="${pageContext.request.contextPath}/images/btn2.jpg"
                                        type=image name=btnReset onclick="javascript:adminlogin.reset();return false;">
                                </td>
                            </tr>
                          </tbody>
                        </table>
                    </div>
                   </div>
                </div>
              </div>
            <div style="MARGIN: 0px auto; WIDTH: 936px">
                <IMG src="${pageContext.request.contextPath}/images/body_06.jpg">
            </div>
            </td>
        </tr>
        <tr style="HEIGHT: 30%">
            <td>&nbsp;</td>
        </tr>
    </tbody>
</table>
</form>

</body>
</html>