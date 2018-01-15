<%@ page import="java.lang.String"%>
<%@ page import="java.lang.Integer"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/js/jquery-easyui-1.5.3/themes/default/easyui.css">
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/js/jquery-easyui-1.5.3/themes/icon.css">
<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery-3.2.1/jquery-3.2.1.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery-easyui-1.5.3/jquery.easyui.min.js"></script>
<style type="text/css">
body{
	margin:5px 5px;
	font-family: 'trebuchet MS', 'Lucida sans', Arial;
	font-size: 10px;
	color:#ffc20e ;
	text-align: center;
}
img{
	display: block;
	margin:0 auto;
}
</style>
<script type="text/javascript">
	$(function() {
		var systemName = '${systemName}';
		var url = 'systemCurrent.html?modelId=${modelId}&modelName=${modelName}'+'&systemName='+systemName;
		refresh(url);//打开页面立即执行
		setInterval(function(){refresh(url)},5000);//以后每隔5s发一次请求
	});
	
	function refresh(url){
		$.ajax({
			url : "${pageContext.request.contextPath}/"+url,
			type : 'post',
			dataType : 'json', //预期服务器返回的数据类型
			contentType : 'application/json',// 告诉服务器提交的数据格式，默认 “application/x-www-form-urlencoded”
			success : function(data) {
				var paraMap = data.paraMap;
				var dataMap = data.dataMap;
				var imageUrl = 'images/'+paraMap.image_name;
				//显示图片
				$("#img").attr("src",imageUrl);
				//显示数据
				$("#div1").empty();
				var paraNum = paraMap.para_num;
				for(var i=1;i<=paraNum;i++){
					//得到参数名和参数坐标名
					var para_name = 'para'+i+'_name';
					var para_coordinate = 'para'+i+'_coordinate';
					//创建div2，并添加属性
					//<div style="position:absolute;top:88px;left:515px;width:33px;height;">55.8</div>
					var div2 = document.createElement("div"); 
					div2.setAttribute("style", 'position:absolute;'+paraMap[para_coordinate]+'border:1px dashed red;');
					div2.innerHTML = dataMap[paraMap[para_name]];
					var div1 = document.getElementById("div1");
					div1.appendChild(div2);
				} 
			},
			error: function() {console.log('请求失败！')}
		})
	} 
</script>
<title>系统动态页面</title>
</head>
<body>
	 <div style="position:relative; width: 1024px;height: 768px;border: 2px solid red;margin: 0 auto;">
	  	<img id="img"/>
	  	<div id="div1"></div>
	 	<%-- <img id="img" src="images/${paraMap['image_name']}" alt="图像正在努力加载中.."></img> --%>
		<!-- <div id="div1" style="position:absolute;top:558px;left:840px;width:32px;height:13px; border:1px dashed red;"></div>
		<div id="div1" style="position:absolute;  top:72.3%; left:14.4%;width:34px;height:15px;  border:2px dashed red;"></div> -->
		<%-- <div>
			<c:if test="${paraMap['para_num']>0}">
			<c:forEach var="i" begin="1" end="${paraMap['para_num']}">
				<c:set var="para_name" value="para${i}_name"/> 
				<c:set var="data_name" value="${paraMap[para_name]}"/> 
				<c:set var="para_coordinate" value="para${i}_coordinate"/> 
				<c:out value="${dataMap[data_name]}"/>
				<div id="div${i}" style="position:absolute;${paraMap[para_coordinate]} border:1px dashed red;">${dataMap[data_name]}</div>
			</c:forEach>
			</c:if>
		</div> --%>
    </div> 
</body>
</html>