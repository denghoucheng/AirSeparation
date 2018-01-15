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
<link type="text/css" rel="stylesheet"
	href="${pageContext.request.contextPath}/css/main.css" />
<script type="text/javascript"
	src="${pageContext.request.contextPath}/js/jquery-3.2.1/jquery-3.2.1.min.js"></script>
<script type="text/javascript"
	src="${pageContext.request.contextPath}/js/My97DatePicker/WdatePicker.js"></script>
<script type="text/javascript"
	src="${pageContext.request.contextPath}/js/Highstock-5.0.14/code/highstock.js"></script>
<script type="text/javascript"
	src="${pageContext.request.contextPath}/js/jquery-easyui-1.5.3/jquery.easyui.min.js"></script>
<script type="text/javascript">
	$(function() {
		console.log("这里是数据分析历史曲线");
		var dateStart;
		var dateEnd;
		console.log('dateStart：' + dateStart + ',dateEnd：' + dateEnd);
		printCharts(dateStart, dateEnd);
	});

	/*
	点击日期控件按钮，选择日期
	 */
	function display() {
		WdatePicker({
			skin : 'whyGreen',
			startDate : '%y-%M-%d %H:00:00',
			dateFmt : 'yyyy-MM-dd HH:mm:ss'
		});
	}

	/*
	点击‘开始查询’，执行此方法，获取控件的开始，结束时间
	 */
	function search() {
		var dateStart = document.getElementById("dateStart").value;
		var dateEnd = document.getElementById("dateEnd").value;
		if (dateEnd == "" || dateStart <= dateEnd) {//输入正常，将输入的开始，结束时间传给服务器
			printCharts(dateStart, dateEnd);//什么都不说了，千言万语都在这个方法里了！
		} else {
			alert("开始时间不能大于结束时间！");
		}

	}

	/* 
	使用Highcharts，绘制表格
	 */
	function printCharts(dateStart, dateEnd) {
		if (dateStart == undefined || dateEnd == undefined) {//初始化开始和结束时间
			start_stamp = new Date(new Date() - 24 * 60 * 60 * 1000).getTime();
			end_stamp = new Date().getTime();
			console.log('默认开始时间=' + end_stamp + ',结束时间=' + end_stamp);
			dateStart = date2String(start_stamp);//一天前
			dateEnd = date2String(end_stamp);
		}
		console.log('dateStart：' + dateStart + ',dateEnd：' + dateEnd);
		var factoryId = ${jsonObject}.factoryId;
		var jsonObj = {"dateStart":dateStart,"dateEnd":dateEnd,"factoryId":factoryId};
		console.log(JSON.stringify(jsonObj));
		var url = "${pageContext.request.contextPath}/analysisHistory.html";//http://localhost:8080/ASW/analysisHistory
		$.ajax({//404?
			url : url,
			type : "POST",
			dataType : "json",
			data : JSON.stringify(jsonObj),
			contentType : "application/json",
			success : function(data) {
				var hisDataList = data;
				console.log(hisDataList);
				var arr0=[];//存参数名
				var arr1=[];//存数值1
				var arr2=[];//存数值2
				var arr3=[];//存数值3
				var arr4=[];//存数值4
				var arr5=[];//存数值5
				var arr6=[];//存数值6
				var arr7=[];//存数值7
				var arr8=[];//存时间
				arr0.push('氮气产品合格率（%）');
				arr0.push('氮气出塔量（Nm3）');
				arr0.push('氮气放散量(Nm3,预估)');
				arr0.push('氮气放散率(%，预估)');
				arr0.push('氮气利用量(Nm3，预估)');
				arr0.push('能源消耗量(KW.h，预估)');
				arr0.push('单位能耗（KW.h/Nm3，预估）');
				
				for(var i=0; i<hisDataList.length;i++){
					arr1.push(hisDataList[i].out01);
					arr2.push(hisDataList[i].out02);
					arr3.push(hisDataList[i].out03);
					arr4.push(hisDataList[i].out04);
					arr5.push(hisDataList[i].out05);
					arr6.push(hisDataList[i].out06);
					arr7.push(hisDataList[i].out07);
					arr8.push(timeStamp2String(hisDataList[i].TIME.time));
				}
				
				console.log(arr0);
				console.log(arr2);
				console.log(arr8[0]);
				
				//开始画表格了
				var charts ={// 图表初始化函数，其中 container 为图表的容器 div               
						chart: {
							renderTo: 'container',
				            zoomType: 'xy'
				        },
				        title: {
				            text: '昨日曲线图'
				        },
				        xAxis:{
				            title: {text: '时间'},
				            categories:[],
				            crosshair: true,
				        },
				        yAxis:[], //动态生成多级y轴
				        tooltip: {
				            shared: true,
				            valueDecimals: 2
				        },
				        credits: {
				            enabled: false  //去掉hightchats水印
				        },
				        legend: {
				            align: 'left',
				            x: 150,
				            y: 15,
				            verticalAlign: 'bottom',
				            backgroundColor: (Highcharts.theme && Highcharts.theme.legendBackgroundColor) || '#FFFFFF'
				        },
				        series:[]
				    };//charts结束括号
				    
					for(var i=0;i<arr8.length;i++){//将时间push到categories数组中，
						charts.xAxis.categories.push(arr8[i]);
					} 
				    
					for(var m = 0;m<7;m++){//0,1,2,3,多级Y轴---将yAxisObj对象push到charts.yAxis数组中，
		    		    var yAxisObj={"labels":{"format":'{value}',"style":{"color":"Highcharts.getOptions().colors["+m+"]"}},"title":{"text":"","style":{"color":"Highcharts.getOptions().colors["+m+"]"}},"opposite":false}	;
			    		    if(m%2!=0){
			    		    	yAxisObj.opposite=true;
			    		    }
		        		charts.yAxis.push(yAxisObj);	
		        		
		    			var dataArray = "arr"+(m+1);
		    			var seriesObj={"name":arr0[m],"type":"spline","yAxis":m,"data":eval(dataArray),"tooltip":{"valueSuffix":" "},"visible":false};
		    			/* var seriesObj={"name":arr0[m],"type":"spline","yAxis":m,"data":eval(dataArray),"tooltip":{"valueSuffix":arr1[m]},"visible":false}; */
		    			if(m==0){//打开网页默认显示第一个字段
		    				seriesObj.visible=true;
		    			}
		    			charts.series.push(seriesObj);
		    		}
					var options=new Highcharts.Chart(charts);
			},
			error : function() {
				console.log('请求失败！');
			}
		})
	}
	
	function timeStamp2String (time){// timestamp转datetime
        var datetime = new Date();
         datetime.setTime(time);
         var year = datetime.getFullYear();
         var month = datetime.getMonth() + 1;
         var date = datetime.getDate();
         var hour = datetime.getHours();
         var minute = datetime.getMinutes();
         var second = datetime.getSeconds();
        // var mseconds = datetime.getMilliseconds();
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
         return  date+"日"+hour+":"+minute+":"+second;
	}
	
	function date2String(time) {  
		 var datetime = new Date();
        datetime.setTime(time);
        var year = datetime.getFullYear();
        var month = datetime.getMonth() + 1;
        var date = datetime.getDate();
        var hour = datetime.getHours();
        var minute = datetime.getMinutes();
        var second = datetime.getSeconds();
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
       return year + '-' + month + '-' + date+' '+hour+':'+minute+':'+second;  
   }
</script>
<title>系统动态页面</title>
</head>
<body>
<body>
	<div class="search_div">
		日期区间： <input type="text" id="dateStart" name="dateStart"
			onclick="display()" readonly="readonly" style="width: 140px;" /> - <input
			type="text" id="dateEnd" name="dateEnd" onclick="display()"
			readonly="readonly" style="width: 140px;" /> <a
			href="javascript:search();" class="myBtn"><em>开始查询</em></a>
	</div>
	<div id="container" style="min-width: 800px; height: 400px"></div>
</body>
</body>

</html>