<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>首页</title>
<link rel="stylesheet" href="https://cdn.bootcss.com/bootstrap/3.3.7/css/bootstrap.min.css" integrity="sha384-BVYiiSIFeK1dGmJRAkycuHAHRg32OmUcww7on3RYdg4Va+PmSTsz/K68vbdEjh4u" crossorigin="anonymous">
<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery-3.2.1/jquery-3.2.1.min.js"></script>
<script src="https://cdn.bootcss.com/bootstrap/3.3.7/js/bootstrap.min.js" integrity="sha384-Tc5IQib027qvyjSMfHjOMaLkfuWVxZxUPnCJA7l2mCWNIpG9mGCD8wGNIcPD7Txa" crossorigin="anonymous"></script>
<script type="text/javascript">
/**
 * 发送ajax请求，跳转到指定的jsp页面
 */
function getSystemMenu(Id){
    
    var jsonObj = {"factoryId":Id};//Json对象 {"factoryId":3}
    
   	$.ajax({
    	type:"POST",
    	url: "/ASW/wxcurrent.html",
    	data:JSON.stringify(jsonObj),//JSON.stringify(obj) json字符串
    	dataType: "json",
    	contentType:"application/json",
    	success:function(result){
    		console.log(result);
    		openModal(result)//启动模态框，并在模态体中添加系统选项
    	},
    	error:function(){
    		alert("error");
    	}
   	})
}
/**
 * 模态框中展示系统菜单
 */
function openModal(result){
	$('.modal-body').empty();
	for(var i=0;i<result.length;i++){
		var modelId=result[i].modelId;
		var modelName='tb_model'+result[i].modelNum;
		//alert(modelId+','+modelName);
		if("报警系统"==result[i].systemName){
			var btn ='<a href="${pageContext.request.contextPath}/alarm.html?factoryId='+result[i].modelNum+'" class="btn btn-link" style="width:300px;height:50px">'+result[i].systemName+'</a>';
		} 
		else{
			var btn ='<a href="${pageContext.request.contextPath}/wxsystemCurrent.html?modelId='+modelId+'&modelName=tb2_model'+result[i].modelNum+'" class="btn btn-link" style="width:300px;height:50px">'+result[i].systemName+'</a>';
		}
		$('.modal-body').append(btn);
	}
	$("#myModal").modal('show')
}
</script>
</head>
<body>
	<!--微信首页仅展示实时数据-->
	<div class="container">
		<c:set var="AuthFlag" scope="session" value="0"/>
     	 <c:forEach items="${menuList}" var="menu">
	        <c:if test="${menu.hasMenu}">
	        		<c:set var="AuthFlag" value="1"/>
		        	<c:choose>
		        		<c:when test="${menu.menuName=='系统管理'}"/>
			        	<c:otherwise>
			        		<div style="margin:30px 0;font-size:20px">
			        			<ul class="nav nav-pills nav-stacked">
						     		<li role="presentation" class="active">
					        			<a href="javascript:getSystemMenu(${menu.factoryId })">${menu.menuName }</a>
									</li>
					     		</ul>
					     	</div>
				     		<c:forEach items="${menu.subMenu}" var="sub">
				                   	 <c:if test="${sub.hasMenu}">
				                   	 	<c:choose>
				                   	 		<c:when test="${sub.menuUrl=='history.html' }"/>
				                   	 		<c:otherwise>
				                   	 			<c:choose>
				                   	 				<c:when test="${ empty sub.menuUrl}">
						                   	 			<c:out value="menuUrl is null"></c:out>
					                   	 			</c:when>
					                   	 			<c:otherwise>
					                   	 				<div style="margin:2px 6px;font-size:18px">
					                    					<ul class="nav nav-pills nav-stacked">
													     		<li role="presentation" ><a href="javascript:getSystemMenu(${sub.factoryId })">${sub.menuName}</a></li>
												     		</ul>
												     	</div>
					                    			</c:otherwise> 
				                   	 			</c:choose>
				                   	 		</c:otherwise>
				                   	 	</c:choose>
			                    			
				                     </c:if>
			                 </c:forEach>
			        	</c:otherwise>
		        	</c:choose>
	        	</c:if>
        </c:forEach>
        <c:choose>
			<c:when test="${AuthFlag==0}">
				<div>对不起，您对该资源没有访问权限！</div>
			</c:when>
		</c:choose>
     </div>
     <!-- 模态框 ：最好作为body的直接子元素-->
	<div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
	  <div class="modal-dialog" role="document">
	    <div class="modal-content">
	      <div class="modal-header">
	        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
	        <h4 class="modal-title" id="myModalLabel">点击查看系统信息</h4>
	      </div>
	      <div class="modal-body" >
	       	
	      </div>
	       <div class="modal-footer">
	        <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
	       </div>
	    </div>
	  </div>
	</div>
</body>
</html>