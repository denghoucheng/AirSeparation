<%@ page import="java.lang.String"%>
<%@ page import="java.lang.Integer"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet" href="https://cdn.bootcss.com/bootstrap/3.3.7/css/bootstrap.min.css" integrity="sha384-BVYiiSIFeK1dGmJRAkycuHAHRg32OmUcww7on3RYdg4Va+PmSTsz/K68vbdEjh4u" crossorigin="anonymous">
<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery-3.2.1/jquery-3.2.1.min.js"></script>
<script src="https://cdn.bootcss.com/bootstrap/3.3.7/js/bootstrap.min.js" integrity="sha384-Tc5IQib027qvyjSMfHjOMaLkfuWVxZxUPnCJA7l2mCWNIpG9mGCD8wGNIcPD7Txa" crossorigin="anonymous"></script>
<title>系统数据</title>
<script type="text/javascript">
$(document).ready(function(){
	var modelId = $("#modelId").html();
	var modelName = $("#modelName").html();
	refresh(modelId,modelName);
	setInterval(function(){refresh(modelId,modelName)},10000);
	disappear();
})
	/**
	 * 上移
	 */
	 $(document).on('click', '.up', function(e) {
		 var tr = $(this).parents("tr"); 
		    if (tr.index() != 0) { 
		      tr.fadeOut().fadeIn(); 
		      tr.prev().before(tr); 
		      tr.css("color","#f60"); 
	    	} 
	});

	/**
	 * 下移
	 */
	 $(document).on('click', '.down', function(e) {
		  var down = $(".down"); 
		  var len = down.length; 
		  down.click(function() { 
		    var tr = $(this).parents("tr"); 
		    if (tr.index() != len - 1) { 
		      tr.fadeOut().fadeIn(); 
		      tr.next().after(tr); 
		      tr.css("color","#228B22"); 
		    } 
		  }); 
	});
	/**
	 * 置顶
	 */
	 $(document).on('click', '.stick', function(e) {
		 var top = $(".stick"); 
		  top.click(function(){ 
		    var tr = $(this).parents("tr"); 
		    tr.fadeOut().fadeIn(); 
		    $(".table").prepend(tr); 
		    tr.css("color","#00BFFF"); 
		  }); 
	});
	/**
	 * 消失
	 */
	 $(document).on('click', '.stick', function(e) {
		 var top = $(".stick"); 
		  top.click(function(){ 
		    var tr = $(this).parents("tr"); 
		    tr.fadeOut().fadeIn(); 
		    $(".table").prepend(tr); 
		    tr.css("color","#00BFFF"); 
		  }); 
	});

	/**
	 * 实时刷新数据
	 */
	function refresh(modelId,modelName){
		var jsonObj = {"modelId":modelId,"modelName":modelName};
		//alert(JSON.stringify(jsonObj));
		$.ajax({
			url : "/ASW/wxsystemCurrent.html",
			type : "POST",
			dataType:"json",
			data:JSON.stringify(jsonObj),
			contentType:"application/json",
			success : function(mFactory) {//mFactory是json对象
				var paraMap = mFactory.paraMap;
				var dataMap = mFactory.dataMap;
				var paraNum = paraMap.para_num;
				//alert("paraNum:"+paraNum);
				$("#tbody").empty();
				if(paraNum>0){
					for(var i=1;i<=paraNum;i++){
						//如何解决动态属性名问题?数组语法
						var para_name = "para"+i+"_name";//para1_name,para2_name,para3_name....
						//alert(para_name);
						var para_value = paraMap[para_name];
						//alert(para_value);
						var data_value = dataMap[para_value];
						//alert(data_name);
						
						var tr = document.createElement("tr"); 
						tr.setAttribute("id", 'tr'+i);
						console.log(tr);
						
						var td1 = document.createElement("td"); 
						td1.innerHTML = para_value;
						
						var td2 = document.createElement("td");
						td2.innerHTML = data_value;
						
						var td3 = document.createElement("td"); 
						var input = document.createElement("input"); 
						input.setAttribute("id", 'tr'+i);
						input.setAttribute("type", "checkbox");
						input.setAttribute("checked", "checked");
						td3.appendChild(input);
						
						var td4 = document.createElement("td"); 
						var a = document.createElement("a"); 
						a.setAttribute("href", "#");
						a.setAttribute("class", "up");
						a.innerHTML = "上";
						td4.appendChild(a);
						
						var td5 = document.createElement("td"); 
						var a = document.createElement("a"); 
						a.setAttribute("href", "#");
						a.setAttribute("class", "down");
						a.innerHTML = "下";
						td5.appendChild(a);
						
						var td6 = document.createElement("td"); 
						var a = document.createElement("a"); 
						a.setAttribute("href", "#");
						a.setAttribute("class", "stick");
						a.innerHTML = "顶";
						td6.appendChild(a);  
						
						tr.appendChild(td1); 
						tr.appendChild(td2);
						tr.appendChild(td3);
						tr.appendChild(td4);
						tr.appendChild(td5);
						tr.appendChild(td6);
						document.getElementById("tbody").appendChild(tr);
					}
				}  
			},
			error: function() {console.log('请求失败！')}
		})
	}
</script>
</head>
<body >
	<div id="modelId" hidden="hidden">${modelId}</div>
	<div id="modelName" hidden="hidden">${modelName}</div>
	<div class="container table-responsive">
		<table class="table">
		  <thead>
		  	<tr>
		  		<td>参数名</td>
		  		<td>数值</td>
		  		<td>可见性</td>
		  		<td>上移</td>
		  		<td>下移</td>
		  		<td>置顶</td>
	  		</tr>
		  </thead>
		  <tbody id="tbody">
		  	<%-- <c:if test="${paraMap['para_num']>0}">
				<c:forEach var="i" begin="1" end="${paraMap['para_num']}">
					<c:set var="para_name" value="para${i}_name"/> 
					<c:set var="data_name" value="${paraMap[para_name]}"/> 
					<tr id="tr${i}">
				  		<td>${paraMap[para_name]}</td>
				  		<td>${dataMap[data_name]}</td>
				  		<td> <input id="tr${i}" type="checkbox" checked="checked"></td>
				  		<td><a href="#" class="up">上</a></td>
				  		<td><a href="#" class="down">下</a></td>
				  		<td><a href="#" class="top">顶</a></td>
			  		</tr>
				</c:forEach>
			</c:if> --%>
		  </tbody >  
		</table>
	</div>
</body>
</html>