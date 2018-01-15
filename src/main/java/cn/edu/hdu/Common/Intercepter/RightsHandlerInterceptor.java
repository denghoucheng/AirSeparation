package cn.edu.hdu.Common.Intercepter;

import cn.edu.hdu.Entity.Menu;
import cn.edu.hdu.Entity.User;
import cn.edu.hdu.Utils.RightsHelper;
import cn.edu.hdu.Utils.ServiceHelper;
import cn.edu.hdu.Utils.Tools;
import java.util.List;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.ModelAndViewDefiningException;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

public class RightsHandlerInterceptor extends HandlerInterceptorAdapter{
  
  public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)throws Exception {
    String path = request.getServletPath();
    if (path.matches(".*/((login)|(index)|(logout)|(code)|(modifyPassword)|(checkLogin)|(analysis)).*")) {
      return true;
    }
    HttpSession session = request.getSession();
    User user = (User)session.getAttribute("sessionUser");
    Integer menuId = null;
    List<Menu> subList = ServiceHelper.getMenuService().listAllSubMenu();
    for (Menu m : subList){
      String menuUrl = m.getMenuUrl();
      if (Tools.notEmpty(menuUrl)){
        if (path.contains(menuUrl)){
          menuId = m.getMenuId();
          break;
        }
        String[] arr = menuUrl.split("\\.");
        String regex = "";
        if (arr.length == 2) {
          regex = "/?" + arr[0] + "(/.*)?." + arr[1];
        } else {
          regex = "/?" + menuUrl + "(/.*)?.html";
        }
        if (path.matches(regex)){
          menuId = m.getMenuId();
          break;
        }
      }
    }
    System.out.println(path + "===" + menuId);
    if (menuId != null){
      user = ServiceHelper.getUserService().getUserAndRoleById(user.getUserId());
      String userRights = (String)session.getAttribute("sessionUserRights");
      String roleRights = (String)session.getAttribute("sessionRoleRights");
      if ((RightsHelper.testRights(userRights, menuId.intValue())) || (RightsHelper.testRights(roleRights, menuId.intValue()))) {
        return true;
      }
      ModelAndView mv = new ModelAndView();
      mv.setViewName("no_rights");
      throw new ModelAndViewDefiningException(mv);
    }
    return super.preHandle(request, response, handler);
  }
}
