package cn.edu.hdu.Common.Intercepter;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

import cn.edu.hdu.Entity.User;
import cn.edu.hdu.Service.UserService;

/**
 * 登陆拦截
 */
public class LoginHandlerInterceptor extends HandlerInterceptorAdapter{
	
	@Autowired
	private UserService userService;
  
	/**
	 * 1：路径匹配返回true，
	 * 2：否则获取当前用户的中的sessionUser属性判断该用户是否登陆过，如果没有就返回false，并跳转到登录页面
	 */
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)throws Exception{
	    String path = request.getServletPath();
	    if (path.matches(".*/((login)|(index)|(logout)|(code)|(modifyPassword)|(checkLogin)|(analysis)).*")) {
	      return true;
	    }
	    HttpSession session = request.getSession();
	    User user = (User)session.getAttribute("sessionUser");
	    if (user != null) {
	    	System.err.println("user:"+user);
	    	user.setStatus(1);
			userService.updateUserLoginStatus(user);
	      return true;
	    }
	    response.sendRedirect(request.getContextPath() + "/login.html");
	    return false;
	}
}
