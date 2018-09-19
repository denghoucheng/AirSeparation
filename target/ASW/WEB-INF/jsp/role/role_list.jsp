<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>角色管理</title>
<link type="text/css" rel="stylesheet" href="css/main.css"/>

<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery-1.5.2/jquery.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/lhgdialog3.5.2/lhgdialog/lhgdialog.min.js?t=self&s=chrome"></script>

<script type="text/javascript">
	$(document).ready(function(){
		$(".main_info:even").addClass("main_table_even");
	});
	
	function addRole(){
		var dg = new $.dialog({
			title:'新增角色',
			id:'role_new',
			width:300,
			height:130,
			iconTitle:false,
			cover:true,
			maxBtn:false,
			xButton:true,
			resize:false,
			//page:'role/add.html',
			html:'<div style="width:100%;height:40px;line-height:40px;text-align:center;"><span style="color: #4f4f4f;font-size: 13px;font-weight: bolder;display:inline-block;vertical-align:middle;">角色名称：</span><input type="text" name="roleName" id="roleName" style="vertical-align: middle;"/></div>'
			});
   		dg.ShowDialog();
   		dg.addBtn('ok','保存',function(){
            var url = "role/save.html";
            var postData = {"roleName":$("#roleName").val()};
            $.get(url,postData,function(data){
                if(data=='success'){
                    dg.curWin.location.reload();
                    dg.cancel();
                }
                else if(data=='failed'){
                    alert('角色名重复，保存失败！');
                    $("#roleName").focus();
                    $("#roleName").select();
                }
            });
        });
	}
	
	function editRole(roleId){
		var roleName = $("#roleNameTd"+roleId).text();
		var dg = new $.dialog({
			title:'修改角色',
			id:'role_edit',
			width:300,
			height:130,
			iconTitle:false,
			cover:true,
			maxBtn:false,
			xButton:true,
			resize:false,
			html:'<div style="height:40px;line-height:40px;text-align:center;"><span style="color: #4f4f4f;font-size: 13px;font-weight: bold;display:inline-block;vertical-align:middle;">角色名称：</span><input type="text" name="roleName" id="roleName" value="'+roleName+'" style="vertical-align: middle;"/></div>'
			});
   		dg.ShowDialog();
   		dg.addBtn('ok','保存',function(){
            var url = "role/save.html";
            var postData = {"roleName":$("#roleName").val(),"rights":roleName};
            $.get(url,postData,function(data){
                 console.log(data);
                if(data=='success'){
                    dg.curWin.location.reload();
                    dg.cancel();
                }else if(data=='failed'){
                    alert('角色名重复,修改失败!');
                    $("#roleName").focus();
                    $("#roleName").select();
                }
            });
        });
	}
	
	function editRights(roleId){
		var dg = new $.dialog({
			title:'角色授权',
			id:'auth',
			width:280,
			height:370,
			iconTitle:false,
			cover:true,
			maxBtn:false,
			resize:false,
			page:'role/auth.html?roleId='+roleId
			});
   		dg.ShowDialog();
	}
	
	function delUser(roleId){
		var flag = false;
		if(confirm("确定要删除该记录？")){
			flag=true;
		}
		if(flag){
			var url = "role/delete.html?roleId="+roleId;
			$.get(url,function(data){
				document.location.reload();
			});
		}
	}
</script>
</head>

<body>
	<table width="100%" border="0" cellpadding="0" cellspacing="0" class="main_table">
		<tr class="main_head">
			<th>序号</th>
			<th>角色名称</th>
			<th>操作</th>
		</tr>
		<c:choose>
			<c:when test="${not empty roleList}">
				<c:forEach items="${roleList}" var="role" varStatus="vs">
				<tr class="main_info">
				<td>${vs.index+1}</td>
				<td id="roleNameTd${role.roleId }">${role.roleName }</td>
				<td><a href="javascript:editRole('${role.roleId }');">修改</a> | <a href="javascript:delUser('${role.roleId }');">删除</a> | <a href="javascript:editRights('${role.roleId }');">权限</a></td>
				</tr>
				</c:forEach>
			</c:when>
			<c:otherwise>
				<tr class="main_info">
				<td colspan="3">没有相关数据</td>
				</tr>
			</c:otherwise>
		</c:choose>
	</table>
	<div class="page_and_btn">
		<div>
			<a href="javascript:addRole();" class="myBtn"><em>新增</em></a>
		</div>
	</div>
	
</body>
</html>