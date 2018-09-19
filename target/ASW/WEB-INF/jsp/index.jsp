<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
<meta name="viewport" content="width=device-width, initial-scale=1">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>生产数据远程管理系统</title>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/js/jquery-easyui-1.5.3/themes/default/easyui.css">
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/js/jquery-easyui-1.5.3/themes/icon.css">
<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery-3.2.1/jquery-3.2.1.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery-easyui-1.5.3/jquery.easyui.min.js"></script>
<script type="text/javascript">

$(document).ready(function(){
	
	checkLogin();
	window.setInterval(checkLogin, 1000*60*1);//1分钟检查一下账户

	getTime();
    window.setInterval(getTime, 1000);    //定时器1m更新一次
    
    if(window.parent != window){//在被嵌套时就刷新上级窗口
        window.parent.location.reload(true);
    }
    
    
 });
   
 function checkLogin(){
  
    $.get("${pageContext.request.contextPath}/checkLogin.html", function(data){
    	if("nologin" == data){
       		$.messager.confirm("系统提示","该账户已在其他客户端登录，请重新登录！",function(r){
   		        if(r){
   		            window.location.href='${pageContext.request.contextPath}/login.html';
   		        } 
       		});
       	}
      });
	}


var url;
/**
 * js对函数参数要求不严格
 */
function openTab(menuid,menuName,menuUrl,factoryId,iconCls){
  	/* console.log('当前菜单id是：'+menuid);
	console.log("当前菜单名："+menuName);
	console.log("菜单url为："+menuUrl);
	console.log('工厂id为：'+factoryId); */ 
    if($("#tabs").tabs("exists",menuName)){
        $("#tabs").tabs("select",menuName);
    }
    else{
    	var content;
    	if((menuUrl=='user.html')||(menuUrl=='role.html')||(menuUrl=='menu.html')){
    		var user = ${user.userId};
    		content="<iframe frameborder=0 scrolling='auto' style='width:100%;height:100%' src='${pageContext.request.contextPath}/"+menuUrl+"?userId="+user+"'></iframe>";
    	}
    	else{
       		content="<iframe frameborder=0 scrolling='auto' style='width:100%;height:100%' src='${pageContext.request.contextPath}/"+menuUrl+"?factoryId="+factoryId+"'></iframe>";
    	}
        console.log(content);
        $("#tabs").tabs("add",{
            title:menuName,
            iconCls:iconCls,
            closable:true,
            content:content
        });
    }
}

//获取系统时间
function getTime(){
	var date = new Date();
	var y = date.getFullYear();
	var m = date.getMonth()+1;
	var d = date.getDate();
	var h = date.getHours();
	var i = date.getMinutes();
	var s = date.getSeconds();
	$("#sysTime").html(y+"年"+(m>9?m:("0"+m))+"月"+(d>9?d:("0"+d))+"日 "+(h>9?h:("0"+h))+":"+(i>9?i:("0"+i))+":"+(s>9?s:("0"+s)));
}
//退出系统
function logout(){
	if(confirm("确定要退出吗？")){
		document.location = "logout.html";
	}
}

function openPasswordModifyDialog(){
    $("#dlg").dialog("open").dialog("setTitle","修改密码");
    url="${pageContext.request.contextPath}/user/modifyPassword.html";
}

function modifyPassword(){
    $("#fm").form("submit",{
        url:url,
        onSubmit:function(){
            var username=$("#username").val();
            var oldPassword= hex_md5($("#oldPassword").val());
            var newPassword=$("#newPassword").val();
            var newPassword2=$("#newPassword2").val();
            if(!$(this).form("validate")){
                return false;
            }
            if(username == null){
                $.messager.alert("系统提示","用户名不能为空！");
                return false;
            }
            if(oldPassword.trim()!='${user.password}'){
                $.messager.alert("系统提示","用户原密码输入错误！");
                return false;
            }
            if(newPassword!=newPassword2){
                $.messager.alert("系统提示","确认密码输入错误！");
                return false;
            }
            
            return true;
        },
        success:function(result){
            var result=eval('('+result+')');
            if(result.success){
                $.messager.alert("系统提示","密码修改成功，下一次登录生效！");
                resetValue();
                $("#dlg").dialog("close");
            }else{
                $.messager.alert("系统提示","密码修改失败！");
                return;
            }
        }
     });
}

function closePasswordModifyDialog(){
    resetValue();
    $("#dlg").dialog("close");
}

function resetValue(){
	$("#username").val("");
    $("#oldPassword").val("");
    $("#newPassword").val("");
    $("#newPassword2").val("");
}

function logout(){
    $.messager.confirm("系统提示","您确定要退出系统吗？",function(r){
        if(r){
            window.location.href='${pageContext.request.contextPath}/logout.html';
        } 
     });
}
</script>
</head>

<body class="easyui-layout">
<div region="north" style="height:50px;background-color: #E0ECFF" style="overflow:false;">
    <table style="padding: 5px; width:95%">
        <tr>
            <td width="50%">
                <div style="float: left;width: 290px;height:25px;color: #0000EE;font-size: 25px;font-weight: bolder; margin-top: 5px; padding-left:15px;">生产数据远程管理系统</div>
            </td>
            <td valign="bottom" align="right" width="50%">
                <a href="#" class="easyui-linkbutton" data-options="plain:true" style="width:180px;"><span id="sysTime" style="margin: auto;"></span></a>
                <a href="#" class="easyui-linkbutton" data-options="plain:true" style="width:180px;"><font size="2">欢迎您：${user.username }</font></a>
                <a href="javascript:openPasswordModifyDialog()" class="easyui-linkbutton" data-options="plain:true" style="width:80px;">修改密码</a>
                <a href="javascript:logout()" class="easyui-linkbutton" data-options="plain:true" style="width: 80px;">安全退出</a>
            </td>
        </tr>
    </table>
</div>
<div region="center">
    <div class="easyui-tabs" fit="true" border="false" id="tabs" >
        <div title="首页" data-options="iconCls:'icon-home'">
            <div align="center" style="padding-top: 1px;">
                <img style="display: block;height:100%;width:100%;" src="images/background.jpg"/>
            </div>
        </div>
    </div>
</div>
<div region="west" style="width: 200px;min-width:200px" title="导航菜单" split="true">
    <div class="easyui-accordion" data-options="fit:true,border:false">
      <c:forEach items="${menuList}" var="menu">
        <c:if test="${menu.hasMenu}">
            <div title="${menu.menuName }" data-options="selected:true, iconCls:'icon-jcsjgl'" style="padding:10px">
                <c:forEach items="${menu.subMenu}" var="sub">
                	 <c:if test="${sub.hasMenu}">
	                	<div style="margin:10px 0">
		                   	 <c:if test="${sub.hasMenu}">
	                	 	 	<c:choose>
	                	 	 		<c:when test="${not empty sub.menuUrl}">
	                         			<div style="margin:2px 12px">
	                         				<a href="javascript:openTab('${sub.menuId }','${sub.menuName }','${sub.menuUrl}','${sub.factoryId }')" class="easyui-linkbutton" data-options="plain:true" style="width: 150px;">${sub.menuName }</a>
	                               		</div>
	                    			</c:when> 
	                    			<c:otherwise>
	                    				<a href="#" class="easyui-linkbutton c1" >${sub.menuName}</a>
	                         			<c:forEach items="${sub.subMenu}" var="minSub">
		                              			 <div style="margin:2px 12px">
		                        						 <a href="javascript:openTab('${minSub.menuId }','${minSub.menuName }','${minSub.menuUrl}','${minSub.factoryId}')" class="easyui-linkbutton c1" data-options="plain:true" style="width: 150px;">${minSub.menuName }</a>
		                               			 </div> 
	                     				</c:forEach> 
	                    			</c:otherwise>
	                	 	 	</c:choose>
		                     </c:if>
	                    </div> 
                    </c:if>
                 </c:forEach>
            </div>
          </c:if>
        </c:forEach>
      </div>       
</div>   
<div region="south" style="height: 25px;padding: 5px" align="center">
   杭州电子科技大学</div>

<div id="dlg" class="easyui-dialog" style="width:400px;height:250px;padding: 10px 20px" closed="true" buttons="#dlg-buttons">
   
   <form id="fm" method="post">
    <table cellspacing="8px">
        <tr>
            <td>登录名：</td>
            <td><input type="text" id="loginname" name="loginname" value="${user.loginname }" readonly="readonly" style="width: 200px"/></td>
        </tr>
        <tr>
            <td>用户名：</td>
            <td><input type="text" id="username" name="username" value="${user.username }" style="width: 200px"/></td>
        </tr>
       <tr>
            <td>原密码：</td>
            <td><input type="password" id="oldPassword" name="oldPassword" value="" class="easyui-validatebox" required="true" style="width: 200px"/></td>
        </tr>
        <tr>
            <td>新密码：</td>
            <td>
            <input type="hidden" name="roleId" value="${sessionScope.sessionUser.roleId}">
            <input type="password" id="newPassword" name="password" class="easyui-validatebox" required="true" style="width: 200px"/></td>
        </tr>
        <tr>
            <td>确认新密码：</td>
            <td>
            <input type="hidden" name="userId" value="${user.userId}">
            <input type="password" id="newPassword2" name="password2" class="easyui-validatebox" required="true" style="width: 200px"/></td>
        </tr>
    </table>
   </form>
 </div>
 
 <div id="dlg-buttons">
    <a href="javascript:modifyPassword()" class="easyui-linkbutton" iconCls="icon-ok">保存</a>
    <a href="javascript:closePasswordModifyDialog()" class="easyui-linkbutton" iconCls="icon-cancel">关闭</a>
 </div>
 
</body>
</html>