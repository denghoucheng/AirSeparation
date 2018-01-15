<%@ page import="java.util.List"%>
<%@ page import="cn.edu.hdu.Entity.Factory"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html" charset="utf-8">
	<meta name="keywords" content="关键词，关键字">
	<meta name="description" content="This is my page">
	<title>实时数据</title>
	<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/js/jquery-easyui-1.5.3/themes/default/easyui.css">
	<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/js/jquery-easyui-1.5.3/themes/icon.css">
	<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery-3.2.1/jquery-3.2.1.min.js"></script>
	<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery-easyui-1.5.3/jquery.easyui.min.js"></script>
	<style type="text/css">
		*{margin:0; padding: 0;}
		body{font-family: "微软雅黑";font-size: 12px;color:#666;background: #E6E6E6;}
        #btn{width: 90px;height:25px;display: block;background:#69F;margin: 10px 5px 5px;line-height: 25px;text-align: center;color: #fff;float:left;text-decoration: none;font-size: 16px;border-radius:5px; }
        #btn:hover{background: #63f;}
	</style>
</head>
<body>
	<script type="text/javascript">
		function openTab(systemName,url,iconCls){
			/* console.log('get请求：'+'${pageContext.request.contextPath}/'+url);//ok.把modelId或者factoryId传过去，根据modelI查询相应的图像等信息 */
		    if($("#tabs").tabs("exists",systemName)){
		        $("#tabs").tabs("select",systemName);
		    }else{
		        var content="<iframe frameborder=0 scrolling='auto' style='width:100%;height:98%' src='${pageContext.request.contextPath}/"+url+"'></iframe>";
		        $("#tabs").tabs("add",{
		            title:systemName,
		            iconCls:iconCls,
		            closable:true,
		            content:content
		        });
		    }
		}
	</script>
	<div class="easyui-tabs" fit="true" border="false" id="tabs">
		<c:forEach items="${factoryInfoList}" var="facCurInfo"><!-- 获取某工厂的系统 ：${facSystem.sysId}+${facSystem.sysName}+sysImageUrl?sysImageUrl=${facSystem.sysImageUrl}-->
			<c:choose>
				<c:when test="${facCurInfo.systemName == '报警系统'}">
				
				</c:when>
				<c:otherwise>
			 		<a href="javascript:openTab('${facCurInfo.systemName}','systemHistory.html?modelName=tb2_model${facCurInfo.modelNum}&modelId=${facCurInfo.modelId}')" class="easyui-linkbutton" data-options="plain:true" id="btn">${facCurInfo.systemName}</a>
				</c:otherwise>
			</c:choose>
		</c:forEach>
	</div>
</body>
</html>