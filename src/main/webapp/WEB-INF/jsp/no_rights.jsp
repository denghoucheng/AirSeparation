<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"> 
<html xmlns="http://www.w3.org/1999/xhtml" lang="UTF-8"> 
<head>
	<title>拒绝访问此页面 (403)</title> 
    <style type="text/css"> 
        body { background-color: #fff; color: #666; text-align: center; font-family: arial, sans-serif; }
        div.dialog {
            width: 30em;
            padding: 1em 4em;
            margin: 4em auto 0 auto;
            border: 1px solid #ccc;
            border-right-color: #999;
            border-bottom-color: #999;
        }
        h1 { font-size: 100%; color: #f00; line-height: 1.5em; }
    </style> 
</head> 
<body> 
  <div class="dialog"> 
    <h1>拒绝访问此页面</h1> 
    <p>请确定有访问此页面的权限，或者管理员限制了此页面的访问。</p> 
    <p> 
		<a href="<%=request.getContextPath() %>/login.html">重新登录</a>&nbsp;&nbsp;
		<a href="javascript:history.back(-1)">返 回</a> 
    </p> 
  </div> 
</body> 
</html>
