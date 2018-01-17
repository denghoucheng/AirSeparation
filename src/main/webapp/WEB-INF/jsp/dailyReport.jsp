<%@ page import="java.lang.String"%>
<%@ page import="java.lang.Integer"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet" type="text/css"
	href="${pageContext.request.contextPath}/js/jquery-easyui-1.5.3/themes/default/easyui.css">
<link rel="stylesheet" type="text/css"
	href="${pageContext.request.contextPath}/js/jquery-easyui-1.5.3/themes/icon.css">
<link rel="stylesheet" type="text/css" media="screen"
	href="${pageContext.request.contextPath}/css/css-table.css" />
<link type="text/css" rel="stylesheet"
	href="${pageContext.request.contextPath}/css/main.css" />
<link type="text/css" rel="stylesheet"
	href="${pageContext.request.contextPath}/css/noprintstylesheet.css" />
<link type="text/css" rel="stylesheet"
	href="${pageContext.request.contextPath}/css/printstylesheet.css" media="print" />
<script type="text/javascript"
	src="${pageContext.request.contextPath}/js/jquery-3.2.1/jquery-3.2.1.min.js"></script>
<script type="text/javascript"
	src="${pageContext.request.contextPath}/js/PrintArea2.4.0/demo/jquery.PrintArea.js"></script>
<script type="text/javascript"
	src="${pageContext.request.contextPath}/js/Highstock-5.0.14/code/highstock.js"></script>
<script type="text/javascript"
	src="${pageContext.request.contextPath}/js/My97DatePicker/WdatePicker.js"></script>
<script type="text/javascript"
	src="${pageContext.request.contextPath}/js/jquery-easyui-1.5.3/jquery.easyui.min.js"></script>
<script type="text/javascript">
	/* 
		默认：时间为前一天，表格拿当天的数据，曲线那前一天的数据
	 */
	$(function() {
		/* //打印     
		$("#btnPrint").bind("click", function(event) {
			$("#myPrintArea").printArea();
		}); */

		var dateStart = getStartTime();//默认当天凌晨
		var dateEnd = getEndTime(dateStart);//默认第二天凌晨
		console.log(dateStart);
		console.log(dateEnd);
		sendAjax(dateStart, dateEnd);
	});

	/* 发送post请求，从服务器拿数据 */
	function sendAjax(dateStart, dateEnd) {
		var factoryId = ${factoryId};
		var dateFrist = addTime(dateEnd);
		console.log(dateFrist);
		var jsonObj = {
			"factoryId" : factoryId,
			"dateStart" : dateStart,
			"dateEnd" : dateEnd,
			"dateFrist" : dateFrist
		};
		console.log(JSON.stringify(jsonObj));
		var url = "${pageContext.request.contextPath}/dailyReport.html";
		$.ajax({
			url : url,
			type : "POST",
			dataType : "json",
			data : JSON.stringify(jsonObj),
			contentType : "application/json",
			success : function(result) {
				console.log(result);
				displayTime(result);//班组日期
				currentDate(dateStart);//表前日期
				dailyData(result.dailyData);//表格
				yDataList(result.yDataList);//曲线  
			},
			error : function() {
				alert('服务器正忙，请稍后再试...');
			}
		})
	}
	/*
	点击日期控件按钮，选择日期
	 */
	function display() {
		WdatePicker({
			skin : 'whyGreen',
			startDate : '%y-%M-%d',
			dateFmt : 'yyyy-MM-dd'
		});
	}

	/*
	点击‘开始查询’，执行此方法，获取控件的开始，结束时间
	 */
	function search() {
		var selectedDate = document.getElementById("selectedDate").value;
		if (selectedDate != "") {//输入正常，构造当天日期间隔，如2017-12-07 00:00:00到2017-12-08 00:00:00
			//字符串转日期 ：改日
			console.log(selectedDate);
			var startTime = selectedDate + ' 00:00:00';
			var endTime = getEndTime(selectedDate);
			console.log(startTime + ',' + endTime);
			sendAjax(startTime, endTime);
		} else {
			alert("日期选择有误!");
		}

	}

	/*
		在表上插入当前日期 （年月日）
	 */
	function currentDate(dateStart) {
		var myDate = new Date(dateStart);
		var year = myDate.getFullYear();
		var month = myDate.getMonth() + 1;
		var date = myDate.getDate();
		var str = "日报表(日期:" + year + "-" + month + "-" + date + ")";//日报表(日期：2017-11-22)
		$("#date").html(str);
	}
	/*
		显示班组时间
	 */
	function displayTime(result) {
		console.log(result)
		
		if (result.team_num == 3) {
			var time0 = '合计';
			var time1 = '班组一(' + result.team_03 + "-" + result.team_01 + ')';
			var time2 = '班组二(' + result.team_01 + "-" + result.team_02 + ')';
			var time3 = '班组三(' + result.team_02 + "-" + result.team_03 + ')';
			//默认显示表头，当数据库返回的数据为空时，也会显示表头
			$("#group0").html(time0);
			$("#group1").html(time1);
			$("#group2").html(time2);
			$("#group3").html(time3);
			//把out09拿出来
			for (var i = 0; i < result.dailyData.length; i++) {//interrup0 合计终端， interrup1班组一中端时间，。。
				var out09 = result.dailyData[i].out09;
				console.log('i='+i+',out09='+out09);
				if(out09>0){
					switch(i){
						case 0:
							time0 = '合计'+'<br/>'+'网络中断时间'+out09+'分钟'; //<br/>:换行
							break;
						case 1:
							time1 = time1+'<br/>'+'网络中断时间'+out09+'分钟';
							break;
						case 2:
							time2 =time2+ '<br/>'+'网络中断时间'+out09+'分钟';
							break;
						case 3:
							time3 =time3+ '<br/>'+'网络中断时间'+out09+'分钟';
							break;
					}
				}
				
				switch (i) {//正常情况下
				case 0:
					$("#group0").html(time0);
					break;
				case 1:
					$("#group1").html(time1);
					break;
				case 2:
					$("#group2").html(time2);
					break;
				case 3:
					$("#group3").html(time3);
					break;
				}
			} 
		} 
		
		if (result.team_num == 2) {
			var time0 = '合计';
			var time1 = '班组一(' + result.team_02 + "-" + result.team_01 + ')';
			var time2 = '班组二(' + result.team_01 + "-" + result.team_02 + ')';
			//默认显示表头，当数据库返回的数据为空时，也会显示表头
			$("#group0").html(time0);
			$("#group1").html(time1);
			$("#group2").html(time2);
			//把out09拿出来
			for (var i = 0; i < result.dailyData.length; i++) {//interrup0 合计终端， interrup1班组一中端时间，。。
				var out09 = result.dailyData[i].out09;
				console.log('i='+i+',out09='+out09);
				if(out09>0){
					switch(i){
						case 0:
							time0 = '合计'+'<br/>'+'网络中断时间'+out09+'分钟'; //<br/>:换行
							break;
						case 1:
							time1 = time1+'<br/>'+'网络中断时间'+out09+'分钟';
							break;
						case 2:
							time2 =time2+ '<br/>'+'网络中断时间'+out09+'分钟';
							break;
					}
				}
				//正常情况下
				switch (i) {
				case 0:
					$("#group0").html(time0);
					break;
				case 1:
					$("#group1").html(time1);
					break;
				case 2:
					$("#group2").html(time2);
					break;
				}
			}
		}
	}
	/*  
		每日表格
	 */
	function dailyData(dailyData) {
		console.log("班组0-3的数据（json数组）：");
		console.log(dailyData);
		for (var tdNum = 1; tdNum<5; tdNum++) {
			$("#tr1").find("td").eq(eval(tdNum)).html("");
			$("#tr2").find("td").eq(eval(tdNum)).html("");
			$("#tr3").find("td").eq(eval(tdNum)).html("");
			$("#tr4").find("td").eq(eval(tdNum)).html("");
			$("#tr5").find("td").eq(eval(tdNum)).html("");
			$("#tr6").find("td").eq(eval(tdNum)).html("");
			$("#tr7").find("td").eq(eval(tdNum)).html("");
			$("#tr8").find("td").eq(eval(tdNum)).html("");
			$("#tr9").find("td").eq(eval(tdNum)).html("");
		}
		for (var i = 0; i < dailyData.length; i++) {
			var kind = dailyData[i].kind;
			var state = dailyData[i].state;
			var out01 = dailyData[i].out01;
			var out02 = dailyData[i].out02;
			var out03 = dailyData[i].out03;
			var out04 = dailyData[i].out04;
			var out05 = dailyData[i].out05;
			var out06 = dailyData[i].out06;
			var out07 = dailyData[i].out07;
			var out08 = dailyData[i].out08;
			var out09 = dailyData[i].out09;
			console.log(kind);
			/*
				kind说明：
				0：合计
				1：班组一
				2：班组二
				3：班组三
			 */
			var tdNum = 0;
			if (i == 0) {
				tdNum = 4;
			} else {
				tdNum = i;
			}
			console.log("tdNum:" + tdNum);

			$("#tr1").find("td").eq(eval(tdNum)).html(out01);
			$("#tr2").find("td").eq(eval(tdNum)).html(out02);
			$("#tr3").find("td").eq(eval(tdNum)).html(out03);
			$("#tr4").find("td").eq(eval(tdNum)).html(out04);
			$("#tr5").find("td").eq(eval(tdNum)).html(out05);
			$("#tr6").find("td").eq(eval(tdNum)).html(out06);
			$("#tr7").find("td").eq(eval(tdNum)).html(out07);
			$("#tr8").find("td").eq(eval(tdNum)).html(out08);
			$("#tr9").find("td").eq(eval(tdNum)).html(out09);
		}

	}

	function yDataList(yDataList) {
		//console.log(yDataList);//240个点

		//为画表格准备数据
		var paraMap = yDataList[yDataList.length - 1];
		var paraNum = paraMap.lineNum;
		//console.log('paraNum:'+paraNum);//1

		for (var i = 0; i < paraNum + 3; i++) {//动态创建变量名.arr0,arr1.arr2..,其中arr0用来存放所有的参数名，arr1存单位,arr2用来存TIME，arr4开始存数据
			var varName = 'arr' + i;
			window[varName] = [];
			console.log('arr' + i);
		}

		//把字段存入arr0
		for ( var k in paraMap) {
			var regExp = new RegExp("lineNum");
			var regExp2 = new RegExp("0");
			if ((!regExp.test(k)) || (!regExp2.test(k))) {
				var paraName = paraMap[k];
				arr0.push(paraName);//TI1101
			}
		}

		//把时间存入arr2
		for (var j = 0; j < yDataList.length - 1; j++) {
			var TIME = yDataList[j]['TIME'];
			arr2.push(TIME); //将时间timestamp转Date再加到数组arr2里,因为数组是有序的，所以倒序后，第一个map的时间在最前面，依次索引+1
		}

		//将参数值放入对应数组
		for (var i = 0; i < paraNum; i++) {//动态添加数据到相应数组
			var varName = 'arr' + (i + 3);
			for (var j = 0; j < yDataList.length - 1; j++) {
				window[varName].push(yDataList[j][arr0[i + 2]]);
			}
		}
		console.log(arr0);
		console.log("arr1是单位，我还没传入");
		console.log(arr2.length);
		//console.log(arr3);

		//开始画表格了
		var charts = {// 图表初始化函数，其中 container 为图表的容器 div               
			chart : {
				renderTo : 'container',
				zoomType : 'xy'
			},
			title : {
				text : '昨日曲线图'
			},
			xAxis : {
				title : {
					text : '时间'
				},
				categories : [],
				crosshair : true,
			},
			yAxis : [], //动态生成多级y轴
			tooltip : {
				shared : true,
				valueDecimals : 2
			},
			legend : {
				align : 'left',
				x : 150,
				y : 15,
				verticalAlign : 'bottom',
				backgroundColor : (Highcharts.theme && Highcharts.theme.legendBackgroundColor)
						|| '#FFFFFF'
			},
			credits: {
	            enabled: false  //去掉hightchats水印
	        },
			series : []
		};//charts结束括号

		for (var i = 0; i < arr2.length; i++) {//将时间push到categories数组中，
			charts.xAxis.categories.push(arr2[i]);
		}

		for (var m = 0; m < paraNum; m++) {//0,1,2,3,多级Y轴---将yAxisObj对象push到charts.yAxis数组中，
			var yAxisObj = {
				"labels" : {
					"format" : '{value}',
					"style" : {
						"color" : "Highcharts.getOptions().colors[" + m + "]"
					}
				},
				"title" : {
					"text" : "",
					"style" : {
						"color" : "Highcharts.getOptions().colors[" + m + "]"
					}
				},
				"opposite" : false
			};
			if (m % 2 != 0) {
				yAxisObj.opposite = true;
			}
			charts.yAxis.push(yAxisObj);

			var dataArray = "arr" + (m + 3);
			var seriesObj = {
				"name" : arr0[m + 2],
				"type" : "spline",
				"yAxis" : m,
				"data" : eval(dataArray),
				"tooltip" : {
					"valueSuffix" : " "
				},
				"visible" : true
			};
			/* var seriesObj={"name":arr0[m],"type":"spline","yAxis":m,"data":eval(dataArray),"tooltip":{"valueSuffix":arr1[m]},"visible":false}; */
			/* if(m==0){//打开网页默认显示第一个字段
				seriesObj.visible=true;
			} */
			charts.series.push(seriesObj);
		}
		var options = new Highcharts.Chart(charts);
	}

	function timeStamp2String(time) {// timestamp转datetime
		var datetime = new Date();
		datetime.setTime(time);
		var year = datetime.getFullYear();
		var month = datetime.getMonth() + 1;
		var date = datetime.getDate();
		if (date < 10) {
			date = '0' + date;
		}
		var hour = datetime.getHours();
		if (hour < 10) {
			hour = '0' + hour;
		}
		var minute = datetime.getMinutes();
		if (minute < 10) {
			minute = '0' + minute;
		}
		var second = datetime.getSeconds();
		if (second < 10) {
			second = '0' + second;
		}
		return date + "日" + hour + ":" + minute + ":" + second;
	}

	/* 
		默认昨日的凌晨
	 */
	function getStartTime() {
		var datetime = new Date();
		datetime.setHours(0, 0, 0, 0);

		var year = datetime.getFullYear();
		var month = datetime.getMonth() + 1;
		var date = datetime.getDate();
		if((month==1)&&(date==1)){//规避掉跨年 2017-12-31到2018-01-01
			year-=1;
			month =12;
			date=31;
		}else{
			date -=1;//默认昨日
		}
		if (date < 10) {
			date = '0' + date;
		}
		var hour = datetime.getHours();
		if (hour < 10) {
			hour = '0' + hour;
		}
		var minute = datetime.getMinutes();
		if (minute < 10) {
			minute = '0' + minute;
		}
		var second = datetime.getSeconds();
		if (second < 10) {
			second = '0' + second;
		}
		var todayStartTime = year + "-" + month + "-" + date + " " + hour + ":"
				+ minute + ":" + second;
		return todayStartTime;
	}
	/* 
		昨日结束时间
	 */
	function getEndTime(startTime) {
		console.log(startTime);
		var datetime = new Date(startTime);
		console.log(datetime);
		datetime.setHours(0, 0, 0, 0);
		var year = datetime.getFullYear();
		var month = datetime.getMonth()+1;
		var date = datetime.getDate();//日期+1
		if(month==12 && date==31){
			year +=1;
			month =1;
			date  =1;
			console.log(year+','+month+','+date)
		}else{
			date +=1;
		}
		if (date < 10) {
			date = '0' + date;
		}
		var hour = datetime.getHours();
		if (hour < 10) {
			hour = '0' + hour;
		}
		var minute = datetime.getMinutes();
		if (minute < 10) {
			minute = '0' + minute;
		}
		var second = datetime.getSeconds();
		if (second < 10) {
			second = '0' + second;
		}
		var todayEndTime = year + "-" + month + "-" + date + " " + hour + ":"
				+ minute + ":" + second;
		return todayEndTime;
	}

	/*  
		时间减1天
	 */
	function subTime(time) {
		var datetime = new Date(time);
		datetime.setHours(0, 0, 0, 0);
		var year = datetime.getFullYear();
		var month = datetime.getMonth() + 1;
		var date = datetime.getDate() - 1;
		if (date < 10) {
			date = '0' + date;
		}
		var hour = datetime.getHours();
		if (hour < 10) {
			hour = '0' + hour;
		}
		var minute = datetime.getMinutes();
		if (minute < 10) {
			minute = '0' + minute;
		}
		var second = datetime.getSeconds();
		if (second < 10) {
			second = '0' + second;
		}
		return year + "-" + month + "-" + date + " " + hour + ":" + minute
				+ ":" + second;
	}

	/*  
	时间+1天
	 */
	function addTime(time) {
		var datetime = new Date(time);
		var year = datetime.getFullYear();
		var month = datetime.getMonth()+1;
		var date = datetime.getDate();
		if(month==12 && date==31){
			year +=1;
			month =1;
			date  =1;
			console.log(year+','+month+','+date)
		}else{
			date +=1;
		} 
		
		datetime.setHours(0, 0, 0, 0);
		
		
		if (date < 10) {
			date = '0' + date;
		}
		var hour = datetime.getHours();
		if (hour < 10) {
			hour = '0' + hour;
		}
		var minute = datetime.getMinutes();
		if (minute < 10) {
			minute = '0' + minute;
		}
		var second = datetime.getSeconds();
		if (second < 10) {
			second = '0' + second;
		}
		return year + "-" + month + "-" + date + " " + hour + ":" + minute
				+ ":" + second;
	}
</script>
<title>系统动态页面</title>
</head>
<body>
	<div class="search_div">
		日期选择： 
		<input type="text" id="selectedDate" name="dateStart"
			onclick="display()" readonly="readonly" style="width: 68px;" /> 
		<a href="javascript:search();" class="myBtn"><em>开始查询</em></a>
		<!-- <input id="btnPrint" type="button" value="打印"/> -->
	</div>
	<div id="myPrintArea" >
	<h2 id="date"
		style="font-family: 'trebuchet MS', 'Lucida sans', Arial; font-size: 25px; color: #444; text-align: center;"></h2>
		<div id="div1"
			style="float: chart; height: 400px; width: 100%; overflow-y: auto">
			<table id="chart">
				<thead>
					<tr>
						<th scope="col" colspan="5">日报表</th>
					</tr>
					<tr id=head>
						<th scope="col">指标名称</th>
						<th scope="col" id="group1"></th>
						<th scope="col" id="group2"></th>
						<th scope="col" id="group3"></th>
						<th scope="col" id="group0">合计</th>
					</tr>
				</thead>
				<tbody id="body">
					<tr id="tr1">
						<td>氮气产品合格率（%）</td>
						<td></td>
						<td></td>
						<td id="col3"></td>
						<td></td>
					</tr>
					<tr id="tr2">
						<td>氮气出塔量（Nm3）</td>
						<td></td>
						<td></td>
						<td id="col3"></td>
						<td></td>
					</tr>
					<tr id="tr3">
						<td>氮气放散量(Nm3,预估)</td>
						<td></td>
						<td></td>
						<td id="col3"></td>
						<td></td>
					</tr>
					<tr id="tr4">
						<td>氮气放散率(%，预估)</td>
						<td></td>
						<td></td>
						<td id="col3"></td>
						<td></td>
					</tr>
					<tr id="tr5">
						<td>氮气利用量(Nm3，预估)</td>
						<td></td>
						<td></td>
						<td id="col3"></td>
						<td></td>
					</tr>
					<tr id="tr6">
						<td>能源消耗量(KW.h，预估)</td>
						<td></td>
						<td></td>
						<td id="col3"></td>
						<td></td>
					</tr>
					<tr id="tr7">
						<td>单位能耗（KW.h/Nm3，预估）</td>
						<td></td>
						<td></td>
						<td id="col3"></td>
						<td></td>
					</tr>
					<tr id="tr8">
						<td>停气时间（分钟）</td>
						<td></td>
						<td></td>
						<td id="col3"></td>
						<td></td>
					</tr>
				</tbody>
			</table>
		</div>
		<h2
			style="font-family: 'trebuchet MS', 'Lucida sans', Arial; font-size: 25px; color: #444; text-align: center;"></h2>
		<div id="container"></div>
		</div>
</body>
</html>
