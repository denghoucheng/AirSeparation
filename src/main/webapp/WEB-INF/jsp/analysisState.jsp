<%@ page import="java.lang.String"%>
<%@ page import="java.lang.Integer"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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
<link rel="stylesheet" type="text/css"
	href="${pageContext.request.contextPath}/js/bootstrap/css/bootstrap.min.css">
<script type="text/javascript"
	src="${pageContext.request.contextPath}/js/jquery-3.2.1/jquery-3.2.1.min.js"></script>
<script type="text/javascript"
	src="${pageContext.request.contextPath}/js/bootstrap/js/bootstrap.min.js"></script>
<script type="text/javascript"
	src="${pageContext.request.contextPath}/js/My97DatePicker/WdatePicker.js"></script>
<script type="text/javascript"
	src="${pageContext.request.contextPath}/js/Highstock-5.0.14/code/highstock.js"></script>
<script type="text/javascript"
	src="${pageContext.request.contextPath}/js/jquery-easyui-1.5.3/jquery.easyui.min.js"></script>

<style type="text/css">
	body {
		background-color: #E0ECFF;
	}
	
	#container {
		margin: 0 auto
	}
	
	.modal-dialog {
		margin: 2px auto;
	}
	
	.glyphicon-remove-circle {
		color: cerulean;
	}
</style>

<script type="text/javascript">
	$(function() {
		var dateStart;
		var dateEnd;
		printCharts(dateStart, dateEnd);
	});
	
	//点击日期控件按钮，选择日期
	function display() {
		WdatePicker({
			skin : 'whyGreen',
			startDate : '%y-%M-%d %H:00:00',
			dateFmt : 'yyyy-MM-dd HH:mm:ss'
		});
	}
	
	//点击‘开始查询’，执行此方法，获取控件的开始，结束时间
	function search() {
		var dateStart = document.getElementById("dateStart").value;
		var dateEnd = document.getElementById("dateEnd").value;
		if (dateEnd == "" || dateStart <= dateEnd) {
			printCharts(dateStart, dateEnd);//什么都不说了，千言万语都在这个方法里了！
		}else {
			alert("开始时间不能大于结束时间！");
		}
	}
	
	/* 
	 *	使用Highcharts，绘制表格
	 */
	var pointnum;//全局变量
	function printCharts(dateStart, dateEnd) {
		if (dateStart == undefined || dateEnd == undefined) {//初始化开始和结束时间
			start_stamp = new Date(new Date() - 10*365*24 * 60 * 60 * 1000).getTime();
			end_stamp = new Date().getTime();
			dateStart = date2String(start_stamp);
			dateEnd = date2String(end_stamp);
			console.log('查询起止时间分别为：'+dateStart+','+dateEnd)
			var factoryId = ${jsonObject}.factoryId;
			var jsonObj = {"dateStart":dateStart,"dateEnd":dateEnd,"factoryId":factoryId};
			var url = "${pageContext.request.contextPath}/analysisState.html";//http://localhost:8080/ASW/analysisHistory
			$.ajax({//404?
				url : url,
				type : "POST",
				dataType : "json",
				data : JSON.stringify(jsonObj),
				contentType : "application/json",
				success : function(data) {
					pointnum = 0;
					$("#table").empty();
					//console.log(data);
					var currentState = data[0].currentState;
					var hisDataList = data[0].hisDataList;
					var systemData = data[0].systemData;
					var parameters = data[0].parameters;
					//获取参数长度
					var num = 10;
					for(var systemName in parameters){
			 			num += parameters[systemName].length;
					}
					//动态创建数组 并赋值（全局变量）
					createArraysAndgetValue(num,parameters,hisDataList);
					//初始化表格
					var obj = inintTable(systemData,currentState,parameters,hisDataList);
					var arrSystemName = obj.arrSystemName;
					var arrParam = obj.arrParam;
					//开始画表格了
					var charts ={
						chart: {
							renderTo: 'container',
				            zoomType: 'xy',
				            type: 'scatter',
				            width: 600,
				        },	
				        title: {
				        	 text:'工况分析图',
				        },
				        xAxis: {
				            title: {
				            	text:'出塔氮气流量（Nm3/h）',
				            }
				        },
				        yAxis: {
				            title: {
				            	text:'出塔氮气单位能耗（KW.h/Nm3）',
				            }
				        },
				        tooltip: {
				            shared: true,
				            useHTML:true,
				            formatter: function () {
				            	var keyvalue = this.point.index;
				            	var time,x,y,out01,out02,out03,out04,out05,out06,out07;
				            	if(this.point.color=='#CD2626'){//将红色点的数据索引改为蓝色点索引最大值
				            		time  = timeStamp2String(currentState[0].TIME.time);
					            	x 	  = currentState[0].out10;
					            	y 	  = currentState[0].out11;
					            	out01 = currentState[0].out01;
					            	out02 = currentState[0].out02;
					            	out03 = currentState[0].out03;
					            	out04 = currentState[0].out04;
					            	out05 = currentState[0].out05;
					            	out06 = currentState[0].out06;
					            	out07 = currentState[0].out07;
				            	}else{
				            		time  = arr0[keyvalue];
					            	x 	  = arr1[keyvalue];
					            	y 	  = arr2[keyvalue];
					            	out01 = arr3[keyvalue];
					            	out02 = arr4[keyvalue];
					            	out03 = arr5[keyvalue];
					            	out04 = arr6[keyvalue];
					            	out05 = arr7[keyvalue];
					            	out06 = arr8[keyvalue];
					            	out07 = arr9[keyvalue];
				            	}
				            	 var mytooltip = '<div>日期：<strong>'+time+'</strong></div><div>氮气产品合格率(%):<strong>' +out01+'</strong></div><div>氮气出塔量(Nm3):<strong>' +out02+'</strong></div><div>氮气放散量(Nm3,预估):<strong>' +out03+'</strong></div><div>氮气放散率(%，预估):<strong>' +out04+'</strong></div><div>氮气利用量(Nm3，预估):<strong>' +out05+'</strong></div><div>能源消耗量(KW.h，预估):<strong>' +out06+'</strong></div><div>单位能耗(KW.h/Nm3，预估):<strong>' +out07+'</strong></div><div>点击加入对比行列['+x+','+ y+']</div>';
				                return mytooltip;

				            }

				        },
				        credits: {
				            enabled: false  //去掉hightchats水印
				        },
				        plotOptions: {
				            scatter: {
				                marker: {
				                    states: {
				                        hover: {
				                            enabled: false,
				                            lineWidth: 0
				                        }
				                    }
				                }
				            },
				            series: {
				                cursor: 'pointer',
				                point: {
				                    events: {
				                        click: function () {//1、最多允许比较4个散点。2、点击当前工况点(红色点)，不新建一列
				                        	if(pointnum<4 && this.color!='#CD2626'){
				                        		comparePoint(this.index,arrSystemName,arrParam,hisDataList);
				                        	}
							            	$('#myModal').modal('show'); 
				                        }
				                    }
				                }
				            }
				        },
				        series: [],
					};//charts ends
				 	var Obj = createSeriesObj(hisDataList.length,currentState);
					charts.series.push(Obj.seriesObj);
					charts.series.push(Obj.currentSeriesObj);
					var options=new Highcharts.Chart(charts);
				}
			}); // ajax ends
		}
	}// printCharts ends
	
	function inintTable(systemData,currentState,parameters,hisDataList){
		//添加当前状态列、currentOut01->currentOut07,currentZB01、currentZB02是KF000X_ana_short中的最新值
		var th = '<td>时间</td><td>'+'当前状态'+timeStamp2String(currentState[0].TIME.time)+'</td>';
		var economyTr = '<tr><td><a  data-toggle="collapse" href="#economy" aria-expanded="false" aria-controls="economy"><strong>经济指标</strong></a></td><td></td></tr>';
		var tr1 = '<tr><td>工况</td><td>'+currentState[0].out10+'</td></tr>';
		var tr2 = '<tr><td>出塔单位能耗</td><td>'+currentState[0].out11+'</td></tr>';
		var tr3 = '<tr><td>氮气合格率</td><td>'+currentState[0].out01+'</td></tr>';
		var tr4 = '<tr><td>氮气出塔量</td><td>'+currentState[0].out02+'</td></tr>';
		var tr5 = '<tr><td>氮气放散量</td><td>'+currentState[0].out03+'</td></tr>';
		var tr6 = '<tr><td>氮气放散率</td><td>'+currentState[0].out04+'</td></tr>';
		var tr7 = '<tr><td>氮气利用量</td><td>'+currentState[0].out05+'</td></tr>';
		var tr8 = '<tr><td>能源消耗量</td><td>'+currentState[0].out06+'</td></tr>';
		var tr9 = '<tr><td>单位能耗 </td><td>'+currentState[0].out07+'</td></tr>';
		var thead = '<tbody><tr>'+th+tr1+tr2+'</tr></tbody>';
		var ecoTbody = '<tbody>'+economyTr+'</tbody>';
		var tbody = '<tbody class="collapse" id="economy">'+tr3+tr4+tr5+tr6+tr7+tr8+tr9+'</tbody>';
		$('#table').append(thead);
		$('#table').append(ecoTbody);
		$('#table').append(tbody);
		//动态创建parameterTr
	 	var arrSysTr = [];
	 	var arrSysTd = [];
	 	var arrParam = [];
	 	//先将各个字段数组数据取出来,存在arrParam数组中
	 	for(var systemName in parameters){
 			var fileds = parameters[systemName];
 			arrSysTd.push('<td><a data-toggle="collapse" href="#'+systemName+'" aria-expanded="false" aria-controls="economy"><strong>'+systemName+'</strong></a></td><td></td>');
 			arrParam.push(fileds);
		} 
	 	//console.log(arrParam)
	 	var arrSystemName=[];
 		for(var systemName in parameters){
 			arrSystemName.push(systemName);
		}
 		//console.log(arrSystemName)
 		//console.log(arrSysTd)
	 	var arrSysBody = [];
	 	for(var i=0;i<arrSysTd.length;i++){
        	var systemBody = '<tbody class="'+arrSystemName[i]+'"><tr>'+arrSysTd[i]+'</tr></tbody>';
        	arrSysBody.push(systemBody);
    	}
	 	for(var i=0;i<arrSysBody.length;i++){
	 		$("tbody:last").after(arrSysBody[i]);
    	} 
		//拿出单个系统对应的所有参数
	 	for(var i=0; i< arrParam.length;i++){
	 		var arrTr = [];
 			for(var j=0; j< arrParam[i].length;j++){
 				var tr = '<tr><td>'+arrParam[i][j]+'</td><td>'+systemData[0][arrParam[i][j]] +'</td></tr>';
 				arrTr.push(tr);
 				//console.log(arrParam[i][j]+'锛?'+systemData[0][arrParam[i][j]])
 			}
 			arrSysTr.push(arrTr);
	 	}
	 	//console.log(arrSysTr)

 	 	for(var m=0;m<arrSysTr.length;m++){//系统每行赋值
 	 		//console.log(arrSysTr[m])
		 	var sysTr = '';
 	 		for(var n=0;n<arrSysTr[m].length;n++){//n表示系统参数个数
 	 			sysTr += arrSysTr[m][n];
 	 		}
	 		var sysInitTbody = '<tbody id="'+arrSystemName[m]+'" class="collapse">'+sysTr+'</tbody>';
	 		$("."+arrSystemName[m]).after(sysInitTbody);
	 	}
	 	return {'arrSystemName':arrSystemName,'arrParam':arrParam};
	}
	
	function deletePoint(event){
		pointnum--;//记录比较的散点数
		var rows = document.getElementById('table').rows; 
		var col = event.path[2].cellIndex;
		for(var i = 0; i<rows.length; i++ ){// 清空每个tr指定td的内容
			rows[i].deleteCell(col);  
		} 
	}

	function comparePoint(keyvalue,arrSystemName,arrParam,hisDataList){
		pointnum++;
		//点击对应点，加入对比
		var time  = '<td>'+arr0[keyvalue]+'<a onclick="deletePoint(event)"><span class="glyphicon glyphicon-remove-circle" aria-hidden="true"></span></a></td>';
		var ZB01  = '<td>'+ arr1[keyvalue] +'</td>';
		var ZB02  = '<td>'+ arr2[keyvalue] +'</td>';
		var economy = '<td></td>';
		var out01 = '<td>'+ arr3[keyvalue] +'</td>';
		var out02 = '<td>'+ arr4[keyvalue] +'</td>';
		var out03 = '<td>'+ arr5[keyvalue] +'</td>';
		var out04 = '<td>'+ arr6[keyvalue] +'</td>';
		var out05 = '<td>'+ arr7[keyvalue] +'</td>';
		var out06 = '<td>'+ arr8[keyvalue] +'</td>';
		var out07 = '<td>'+ arr9[keyvalue] +'</td>';
		var system = '<td></td>';
		//获取第一个tr，添加td
		$("tr:first").append(time);
		$("tr:eq(1)").append(ZB01);//eq从0开始
		$("tr:eq(2)").append(ZB02);
		$("tr:eq(3)").append(economy);
		$("#economy tr:eq(0)").append( out01);
		$("#economy tr:eq(1)").append(out02);
		$("#economy tr:eq(2)").append(out03);
		$("#economy tr:eq(3)").append(out04);
		$("#economy tr:eq(4)").append(out05);
		$("#economy tr:eq(5)").append(out06);
		$("#economy tr:eq(6)").append(out07);
	
		for(var i=0;i<arrSystemName.length;i++){
			$("."+arrSystemName[i]+" tr:last").append(system);
			for(var j=0;j<arrParam[i].length;j++){
	    		$("#"+arrSystemName[i] +" tr:eq("+j+")").append('<td>'+hisDataList[keyvalue][arrParam[i][j]] +'</td>');
			}
		}
	
	}
	
	function createSeriesObj(num,currentState){//横坐标ZB01、纵坐标ZB02
		var dataArray= new Array();//dataArray[a]=(arr1[a],arr2[a]);
		for(var a=0;a<num;a++){
			dataArray[a] = [arr1[a],arr2[a]];
		}
		var seriesObj={
			"data":dataArray,
			"name": '历史稳态工况点',
			"color": 'rgba(119, 152, 191, .6)'
		}; 
		var out10 = currentState[0].out10;
		var out11 = currentState[0].out11;
		var currentSeriesObj={
			"data":[[out10,out11]],
			"marker": {symbol: 'text:\uf182'},
			"name": '当前稳态工况点',
			"index":dataArray.length-1,
			"color": '#CD2626'
		};
		return {'seriesObj':seriesObj,'currentSeriesObj':currentSeriesObj};
	}

	function createArraysAndgetValue(num,parameters,hisDataList){
		for(var i=0;i<num;i++){
			window['arr'+i]=[];
		}
		//给前十个数组赋值（ZB01、ZB01、和7个经济指标）
		for(var i=0; i<hisDataList.length;i++){
			arr0.push(timeStamp2String(hisDataList[i].TIME.time));
			arr1.push(hisDataList[i]['ZB01']);
			arr2.push(hisDataList[i]['ZB02']);
			arr3.push(hisDataList[i].out01);
			arr4.push(hisDataList[i].out02);
			arr5.push(hisDataList[i].out03);
			arr6.push(hisDataList[i].out04);
			arr7.push(hisDataList[i].out05);
			arr8.push(hisDataList[i].out06);
			arr9.push(hisDataList[i].out07);
		}
		//给对应的参数名并赋值（系统指标）
		var filedsNum = 10;
		for(var systemName in parameters){
			var fileds = parameters[systemName];
			for(var i= 0;i<fileds.length;i++){
				for(var j= 0; j<hisDataList.length;j++){
					window['arr'+(filedsNum+i)].push(hisDataList[j][fileds[i]]);
				}
			}
			filedsNum += fileds.length;
		}
	}

	function activeModal(){
		 $('#myModal').modal('show');
	}
	
	// timestamp转datetime
	function timeStamp2String (time){// timestamp转datetime
	    var datetime = new Date();
	    datetime.setTime(time);
	    var year = datetime.getFullYear();
	    var month = datetime.getMonth() + 1;
	    var date = datetime.getDate();
	    var hour = datetime.getHours();
	    var minute = datetime.getMinutes();
	    var second = datetime.getSeconds();
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
	     return year+'年'+month+'月'+ date+'日 '+hour+":"+minute+":"+second;
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
<title>asss</title>
</head>
<body id="body">

	<div class="search_div">

		日期区间：<input type="text" id="dateStart" name="dateStart"
			onclick="display()" readonly="readonly"
			style="width: 140px; height: 20px" /> - <input type="text"
			id="dateEnd" name="dateEnd" onclick="display()" readonly="readonly"
			style="width: 140px; height: 20px" /> <a href="javascript:search();"
			class="myBtn"><em>开始查询</em></a> <span
			style="float: right; width: 23px; height: 5px;"></span>

		<button id="activeModal" onclick="activeModal()"
			class="btn btn-primary btn-sm"
			style="float: right; width: 80px; margin: 3px auto;">

			<p>对比分析</p>

		</button>

	</div>



	<div id="container" style="width: 600px; height: 400px;"></div>



	<div class="modal fade" id="myModal" tabindex="-1" role="dialog"
		aria-labelledby="myModalLabel" aria-hidden="true">

		<div class="modal-dialog">

			<div class="modal-content">

				<!-- <div class="modal-header">

	                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">xx</button>

	                <h6 class="modal-title" id="myModalLabel">xx</h6>

	            </div> -->

				<div class="modal-body">

					<table id="table" class="table table-hover"></table>

				</div>

				<div class="modal-footer">

					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>

				</div>

			</div>
			<!-- /.modal-content -->

		</div>
		<!-- /.modal-dialog -->

	</div>

</body>
</html>