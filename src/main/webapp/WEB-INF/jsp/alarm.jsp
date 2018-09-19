<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html;  charset=UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<title>报警页面</title>
	<link rel="stylesheet" type="text/css" media="screen" href="${pageContext.request.contextPath}/css/css-table.css" />
	<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery-3.2.1/jquery-3.2.1.min.js"></script>
	<script type="text/javascript">
	
			$(function() {
				var factoryId = ${factoryId};
				refresh(factoryId);//页面加载就显示报警信息
				setInterval(function(){refresh(factoryId)},30000);//匿名函数中执行多参函数
			});
			
			function refresh(factoryId) {
				$.ajax({
					url : "${pageContext.request.contextPath}/alarm.html?factoryId="+factoryId,
					type : 'post',
					dataType : 'json', //预期服务器返回的数据类型
					contentType : 'application/json',// 告诉服务器提交的数据格式，默认 “application/x-www-form-urlencoded”
					success : function(data) {
						/* factoryId = data.alarmMap['factory_id']; *///实时修改全局变量factoryId
						factoryId = ${factoryId};
						var currRecorder = 0;
						$("#body").empty();
						var m=document.getElementById('chart').rows.length-1;//记录序号
						for ( var k in data.alarmMap) {//遍历报警Map中的所有字段，并且只处理报警字段
							/* if(k!='factory_id' && k!='alarm_url'){ */
								var regExp = new RegExp("name");
								if(regExp.test(k)){//如果字段名包含name
									//读取报警字段的电位
									var alarmField = data.alarmMap[k];
									var currRecorder = data.dataMap[alarmField];//从kf0001中取出报警字段的电位，值=0或1
									var alarmTime = new Date(data.dataMap['TIME'].time).toLocaleString().replace(/:\d{1,2}$/,' '); 
									var alarmContent = k.substring(0,k.indexOf('_'))+'_content';//截取k的前半部分，在拼上content，如alarm1_content
									if(currRecorder==1){//电位1，表示有问题，取出时间
										$('#body').append(
						        				 "<tr>"
						                         + "<td>" + m++ + "</td>"
						                         + "<td>" + alarmTime + "</td>"
						                         + "<td>" + data.alarmMap[alarmContent] + "</td>"
						                         + "</tr>"
						                 );
									}
								}
						}
					},
					error : function() {
						console.log("发送请求失败");
					}
				});
			}
	</script>
</head>
<body>
	<h2 style="font-family: 'trebuchet MS', 'Lucida sans', Arial; font-size: 25px; color: #444; text-align: center;">设备实时报警系统</h2>
	<div style="float: chart; height: 400px; width: 100%; overflow-y: scroll">
		<table id="chart">
			<thead>
				<tr>
					<th scope="col" colspan="3">Alarm</th>
				</tr>
				<tr>
					<th scope="col">序号</th>
					<th scope="col">最新报警时间</th>
					<th scope="col">报警内容</th>
				</tr>
			</thead>
			<tbody id="body">
				
			</tbody>
		</table>
	</div>
</body>
</html>