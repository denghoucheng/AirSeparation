<%@ page import="java.lang.String"%>
<%@ page import="java.lang.Integer"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<link type="text/css" rel="stylesheet" href="${pageContext.request.contextPath}/css/main.css"/>
	<script type="text/javascript" src="${pageContext.request.contextPath}/js/My97DatePicker/WdatePicker.js"></script><!-- 日期控件 -->
    <script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery-3.2.1/jquery-3.2.1.min.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/js/Highstock-5.0.14/code/highstock.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery-easyui-1.5.3/jquery.easyui.min.js"></script>
	<script type="text/javascript">
	/*
		点击日期控件按钮，选择日期
	*/
	function display(){   
  		 WdatePicker({skin:'whyGreen',startDate:'%y-%M-%d %H:00:00',dateFmt:'yyyy-MM-dd HH:mm:ss'});
   }
	/*
		点击‘开始查询’，执行此方法，获取控件的开始，结束时间
	*/
	function search(){
		var  dateStart = document.getElementById("dateStart").value;
		var  dateEnd = document.getElementById("dateEnd").value;
		if(dateEnd==""||dateStart <= dateEnd){//输入正常，将输入的开始，结束时间传给服务器
			/* 下面开始全自动化读取数据什么的了 */
			var modelName = '${modelName}';
			var modelId = ${modelId};
			printCharts(modelName,modelId,dateStart,dateEnd);//什么都不说了，千言万语都在这个方法里了！
		}else{
			alert("开始时间不能大于结束时间！");
		}
		
	}
	/* 
		使用Highcharts，绘制表格
	*/
	function printCharts(modelName,modelId,dateStart,dateEnd){
		/* console.log('dateStart='+dateStart+',dateEnd='+dateEnd); */
		if(dateStart==undefined ||dateEnd==undefined){//初始化开始和结束时间
			start_stamp=new Date(new Date()-60*60*1000).getTime();
			end_stamp=new Date().getTime();
			console.log('默认开始时间='+end_stamp+',结束时间='+end_stamp);
			dateStart=date2String(start_stamp);//一个月前
			dateEnd=date2String(end_stamp);
		}
		 $.ajax({
		    	url:"${pageContext.request.contextPath}/systemHistory.html?modelName="+modelName+"&modelId="+modelId+"&dateStart="+dateStart+"&dateEnd="+dateEnd,
		    	type:"post",
		    	dataType : 'json', 
		    	contentType:'application/json; charset=utf-8',
		    	success:function(result){
		    			//(1)初始化
			    		var paraMap = result.paraMap;
			    		var paraNum = paraMap.para_num;//获取当前系统的字段个数，有几个就创建（几+3）个数组
			    		console.log('paraNum='+paraNum);
			    		var historyData = result.hisDataList;
			    		/* for(var i=0;i<historyData.length;i++){//从list获取数据
			    			console.log(historyData[i]);
			    		} */
			    		for(var i=0;i<=paraNum+2;i++){//动态创建变量名.arr0,arr1.arr2..,其中arr0用来存放所有的参数名，arr1存单位,arr2用来存TIME
			    			var varName = 'arr'+i;
			    			window[varName]=[];
			    			console.log('arr'+i);
			    		}
			    		//(2)获取所有参数名，存arr0
			    		for(var k in paraMap){
		    				var regExp = new RegExp("name");
		    				if(regExp.test(k)){//如果字段中有name,对应的数据，存入arr0
		    					var paraName = paraMap[k]; 
		    					arr0.push(paraName);
		    				}
			    			var regExp2 = new RegExp("suffix");//如果字段中有suffix,取出单位值，存入arr1
		    				if(regExp2.test(k)){
		    					var paraName = paraMap[k]; 
		    					console.log(paraName);
		    					if(paraName=='C'){//用C代替摄氏度符号
		    						paraName='\u2103';
		    					}
		    					arr1.push(paraName);
		    				}
			    		}
			    		/* for(var i=0;i<arr0.length;i++){//测试，输出arr0
			    			console.log('arr0:'+arr0[i]);
			    		}
			    		for(var i=0;i<arr1.length;i++){//测试，输出arr1
			    			console.log('arr1:'+arr1[i]);
			    		} */
			    		//(3)获取对应参数的历史数据，存入对应数组
			    		var hisDataNum = historyData.length;
			    		/* console.log('hisDataNum='+hisDataNum); */
			    		var varTime = 'arr'+2;
			    		 for (var j = 0; j < hisDataNum; j++) {
			    			 var TIME = historyData[j]['TIME'];
				    		 window[varTime].push(timeStamp2String(TIME.time)); //将时间timestamp转Date再加到数组arr2里,因为数组是有序的，所以倒序后，第一个map的时间在最前面，依次索引+1
			    		 }
			    		 
			    		 for (var i = 0; i < paraNum; i++) {//动态添加数据到相应数组
			    			 var varName = 'arr'+(i+3);
			    			 for (var j = 0; j < hisDataNum; j++) {
					    		 window[varName].push(historyData[j][arr0[i]]); 
				    		 }
			    		 }
			    	 	console.log('arr0存参数:'+arr0);
			    		console.log('arr1存单位:'+arr1);
			    		console.log('arr2存时间:'+arr2);
			    		console.log('arr3存参数'+arr0[0]+':'+arr3);
			    		console.log('arr4存参数'+arr0[1]+':'+arr4);
			    		console.log('arr5存参数'+arr0[2]+':'+arr5);
			    		console.log('arr6存参数'+arr0[3]+':'+arr6); 
			    		//开始画表格了
			    		var charts ={// 图表初始化函数，其中 container 为图表的容器 div               
			    				chart: {
			    					renderTo: 'container',
			    		            zoomType: 'xy'
			    		        },
			    		        title: {
			    		            text: '历史曲线'
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
			    		        legend: {
			    		            align: 'left',
			    		            x: 150,
			    		            y: 15,
			    		            verticalAlign: 'bottom',
			    		            backgroundColor: (Highcharts.theme && Highcharts.theme.legendBackgroundColor) || '#FFFFFF'
			    		        },
			    		        series:[]
			    		    };
				    		/* console.log('charts.xAxis='+charts.xAxis);
				    		console.log('charts.xAxis.title='+charts.xAxis.title);
				    		console.log('charts.xAxis.title.text='+charts.xAxis.title.text);
				    		console.log('charts.xAxis.categories='+charts.xAxis.categories);
				    		console.log('charts.yAxis='+charts.yAxis);
				    		console.log('charts.series='+charts.series); */
			    		for(var i=0;i<arr2.length;i++){//将时间push到categories数组中，
			    			charts.xAxis.categories.push(arr2[i]);
			    		}
			    		
			    		for(var m = 0;m<paraNum;m++){//0,1,2,3,多级Y轴---将yAxisObj对象push到charts.yAxis数组中，
			    		    var yAxisObj={"labels":{"format":'{value}'+arr1[m],"style":{"color":"Highcharts.getOptions().colors["+m+"]"}},"title":{"text":"","style":{"color":"Highcharts.getOptions().colors["+m+"]"}},"opposite":false}	;
			    		 		/* console.log('************************************');
				    		    console.log('yAxisObj='+yAxisObj);
				    		    console.log('yAxisObj.labels='+yAxisObj.labels);
				    		    console.log('yAxisObj.labels.format='+yAxisObj.labels.format);
				    		    console.log('yAxisObj.labels.style='+yAxisObj.labels.style);
				    		    console.log('yAxisObj.labels.style.color='+yAxisObj.labels.style.color);
				    		    console.log('yAxisObj.title='+yAxisObj.title);
				    		    console.log('yAxisObj.title.text='+yAxisObj.title.text);
				    		    console.log('yAxisObj.title.style='+yAxisObj.title.style);
				    		    console.log('yAxisObj.title.style.color='+yAxisObj.title.style.color);
				    		    console.log('yAxisObj.opposite='+yAxisObj.opposite);
				    		    console.log('************************************'); */
				    		    if(m%2!=0){
				    		    	yAxisObj.opposite=true;
				    		    }
			        		charts.yAxis.push(yAxisObj);	
			        		
			    			var dataArray = "arr"+(m+3);
			    			/* console.log("dataArray="+dataArray); */
			    			var seriesObj={"name":arr0[m],"type":"spline","yAxis":m,"data":eval(dataArray),"tooltip":{"valueSuffix":arr1[m]},"visible":false};
			    			if(m==0){//打开网页默认显示第一个字段
			    				seriesObj.visible=true;
			    			}
			    			/* console.log('************************************');
			    			console.log('seriesObj='+seriesObj);
			    			console.log('seriesObj.name='+seriesObj.name);
			    			console.log('seriesObj.type='+seriesObj.type);
			    			console.log('seriesObj.yAxis='+seriesObj.yAxis);
			    			console.log('seriesObj.data='+seriesObj.data);
			    			console.log('seriesObj.tooltip='+seriesObj.tooltip);
			    			console.log('seriesObj.tooltip.valueSuffix='+seriesObj.tooltip.valueSuffix);
			    			console.log('seriesObj.visible='+seriesObj.visible);
			    			console.log('************************************'); */
			    			charts.series.push(seriesObj);
			    		}
			    	
			    		/* console.log('************************************');
			    		console.log('charts.yAxis='+charts.yAxis);
			    		for(var i=0;i<paraNum;i++){
			    			console.log('charts.yAxis['+i+'].labels='+charts.yAxis[i].labels);//预计undefined
				    		console.log('charts.yAxis['+i+'].labels.format='+charts.yAxis[i].labels.format);
				    		console.log('charts.yAxis['+i+'].title='+charts.yAxis[i].title);
				    		console.log('charts.yAxis['+i+'].title.text='+charts.yAxis[i].title.text);
			    		}
			    		
			    		console.log('charts.series='+charts.series);
			    		for(var i=0;i<paraNum;i++){
			    			console.log('charts.series['+i+'].yAxis='+charts.series[i].yAxis);//预计undefined
				    		console.log('charts.series['+i+'].name='+charts.series[i].name);
				    		console.log('charts.series['+i+'].data='+charts.series[i].data); 
			    		}
			    		console.log('************************************'); */
			    		
			    		var options=new Highcharts.Chart(charts); 
		    	},
		    	error:function(){
		    		alert('ajax请求失败');
		    	}
		    });
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
         return  date+"/"+hour+":"+minute+":"+second;
	};
	function date2String(time) {  
		 var datetime = new Date();
         datetime.setTime(time);
         var year = datetime.getFullYear();
         var month = datetime.getMonth() + 1;
         var date = datetime.getDate();
         var hour = datetime.getHours();
         var minute = datetime.getMinutes();
         var second = datetime.getSeconds();
        return year + '-' + month + '-' + date+' '+hour+':'+minute+':'+second;  
    };  
	</script>
</head>
<body  onload="printCharts('${modelName}',${modelId})">
	<div class="search_div">
		日期区间：
		<input type="text" id="dateStart" name="dateStart" onclick="display()" readonly="readonly" style="width:140px;"/> -
		<input type="text" id="dateEnd" name="dateEnd" onclick="display()" readonly="readonly" style="width:140px;"/>
		<a href="javascript:search();" class="myBtn"><em>开始查询</em></a>
	</div>
	<div id="container" style="min-width:800px;height:400px"></div>
</body>
</html>