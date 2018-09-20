package cn.edu.hdu.Common.Intercepter;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

import cn.edu.hdu.Entity.User;
import cn.edu.hdu.Service.UserService;

/**
 * 鐧婚檰鎷︽埅
 */
public class LoginHandlerInterceptor extends HandlerInterceptorAdapter{
	
	@Autowired
	private UserService userService;
  
	/**
	 * 1锛氳矾寰勫尮閰嶈繑鍥瀟rue锛�
	 * 2锛氬惁鍒欒幏鍙栧綋鍓嶇敤鎴风殑涓殑sessionUser灞炴�у垽鏂鐢ㄦ埛鏄惁鐧婚檰杩囷紝濡傛灉娌℃湁灏辫繑鍥瀎alse锛屽苟璺宠浆鍒扮櫥褰曢〉闈�
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
