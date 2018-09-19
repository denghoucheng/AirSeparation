<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>用户列表</title>
<link type="text/css" rel="stylesheet" href="css/main.css"/>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery-1.5.2/jquery.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/My97DatePicker/WdatePicker.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/lhgdialog3.5.2/lhgdialog/lhgdialog.min.js?t=self&s=chrome"></script>
<script type="text/javascript">
	$(document).ready(function(){
		$(".main_info:even").addClass("main_table_even");
	});
	
	function sltAllUser(){
		if($("#sltAll").attr("checked")){
			$("input[name='userIds']").attr("checked",true);
		}else{
			$("input[name='userIds']").attr("checked",false);
		}
	}
	
	function addUser(){
		//$(".shadow").show();
		var dg = new $.dialog({
			title:'新增用户',
			id:'user_new',
			width:330,
			height:300,
			iconTitle:false,
			cover:true,
			maxBtn:false,
			xButton:true,
			resize:false,
			page:'${pageContext.request.contextPath}/user/add.html'
			});
		dg.ShowDialog();
	}
	
	function editUser(userId){
		var dg = new $.dialog({
			title:'修改用户',
			id:'user_edit',
			width:330,
			height:300,
			iconTitle:false,
			cover:true,
			maxBtn:false,
			resize:false,
			page:'${pageContext.request.contextPath}/user/edit.html?userId='+userId
			});
		dg.ShowDialog();
	}
	
	function delUser(userId){
		var flag= false;
		if(confirm("确定要删除该记录？")){
			flag=true;
		}
		if(flag){
			var url = "user/delete.html?userId="+userId;
			$.get(url,function(data){
				document.location.reload();
			});
		}
	}
	
	function editRights(userId){
		var dg = new $.dialog({
			title:'用户授权',
			id:'auth',
			width:280,
			height:370,
			iconTitle:false,
			cover:true,
			maxBtn:false,
			resize:false,
			page:'${pageContext.request.contextPath}/user/auth.html?userId='+userId
		});
   		dg.ShowDialog();
	}
	
	function search(){
		$("#userForm").submit();
	}
</script>
</head>
<body>
	<form action="user.html" method="post" name="userForm" id="userForm">
	<div class="search_div">
		登录名：<input type="text" name="loginname" value="${user.loginname }"/>
		<c:if test="${sessionScope.sessionUser.userId == 1}">
			角色：<select name="roleId" id="roleId" style="vertical-align: middle;">
				<option value="">请选择</option>
				<c:forEach items="${roleList}" var="role">
					<option value="${role.roleId }" <c:if test="${user.roleId==role.roleId}">selected</c:if>>${role.roleName }</option>
				</c:forEach>
			</select>
		</c:if>
		<input type="hidden" name="userId" value="${sessionScope.sessionUser.userId}" />
		登录日期：<input type="text" name="lastLoginStart" value="<fmt:formatDate value="${user.lastLoginStart}" pattern="yyyy-MM-dd"/>" onclick="WdatePicker()" readonly="readonly" style="width:70px;"/> -
		<input type="text" name="lastLoginEnd" value="<fmt:formatDate value="${user.lastLoginEnd}" pattern="yyyy-MM-dd"/>" onclick="WdatePicker()" readonly="readonly" style="width:70px;"/>
		<a href="javascript:search();" class="myBtn"><em>查询</em></a>
	</div>
	<table width="100%" border="0" cellpadding="0" cellspacing="0" class="main_table">
		<tr class="main_head">
			<th><input type="checkbox" name="sltAll" id="sltAll" onclick="sltAllUser()"/></th>
			<th>序号</th>
			<th>登录名</th>
			<th>用户名</th>
			<c:if test="${sessionScope.sessionUser.userId == 1}">
				<th>角色</th>
			</c:if>
			<th width="160">最近登录</th>
			<th>操作</th>
		</tr>
		<c:choose>
			<c:when test="${not empty userList}">
				<c:forEach items="${userList}" var="user" varStatus="vs">
					<tr class="main_info">
					<td><input type="checkbox" name="userIds" id="userIds${user.userId }" value="${user.userId }"/></td>
					<td class='center' style="width: 30px;">${vs.index +1}</td>
					<td>${user.loginname }</td>
					<td>${user.username }</td>
					<c:if test="${sessionScope.sessionUser.userId == 1}">
						<td>${user.role.roleName }</td>
					</c:if>
					<td><fmt:formatDate value="${user.lastLogin}" pattern="yyyy-MM-dd HH:mm:ss"/></td>
					<td><a href="javascript:editUser(${user.userId });">修改</a>
							<c:if test="${sessionScope.sessionUser.userId != user.userId }">
								| <a href="javascript:delUser(${user.userId });">删除</a> 
							</c:if>
						<c:if test="${sessionScope.sessionUser.userId !=1 }">
							<c:if test="${sessionScope.sessionUser.userId != user.userId }">
								| <a href="javascript:editRights(${user.userId });">权限</a>
							</c:if>
						</c:if>
					</td>
					<%-- <td><a href="javascript:editUser(${user.userId });">修改</a> | <a href="javascript:delUser(${user.userId });">删除</a></td> --%>
					</tr>
				</c:forEach>
			</c:when>
			<c:otherwise>
				<tr class="main_info">
					<td colspan="7">没有相关数据</td>
				</tr>
			</c:otherwise>
		</c:choose>
	</table>
	<div class="page_and_btn">
		<div>
			<a href="javascript:addUser();" class="myBtn"><em>新增</em></a>
			<a href="javascript:exportUser();" class="myBtn"><em>导出</em></a>
		</div>
		${user.page.pageStr}
	</div>
		
	</form>	
</body>
</html>