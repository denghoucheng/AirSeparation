<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>保存结果</title>
</head>
<body>
	<script type="text/javascript">
		var msg = '${msg}';
		console.log(msg);
		if(msg=="success" || msg==""){
			//window.parent.document.location.reload();
			window.parent.success();//window.parent:返回当前窗口的父窗口（user_info弹窗）对象(如果当前窗口是一个 <iframe>,则它的父窗口是嵌入它的那个窗口)
		}else{
			window.parent.failed();
		}
	</script>
</body>
</html>