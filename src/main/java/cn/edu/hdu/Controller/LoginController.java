package cn.edu.hdu.Controller;

import cn.edu.hdu.Common.Listener.RecordSessionListener;
import cn.edu.hdu.Entity.Menu;
import cn.edu.hdu.Entity.Role;
import cn.edu.hdu.Entity.User;
import cn.edu.hdu.Service.MenuService;
import cn.edu.hdu.Service.UserService;
import cn.edu.hdu.Utils.RightsHelper;
import cn.edu.hdu.Utils.Tools;
import net.sf.json.JSONArray;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

/**
 * 管理用户登陆
 * 
 * @author Halo
 *
 */
@Controller
public class LoginController {

	@Autowired
	private UserService userService;
	@Autowired
	private MenuService menuService;

	@RequestMapping(value = "/login", method = RequestMethod.GET)
	public String loginGet() {
		return "login";
	}

	@RequestMapping(value = "/login", method = RequestMethod.POST)
	public ModelAndView loginPost(HttpServletRequest request, HttpServletResponse response, HttpSession session,
			@RequestParam String loginname, @RequestParam String password, @RequestParam String code) {
		String sessionCode = (String) session.getAttribute("sessionSecCode");
		ModelAndView mv = new ModelAndView();
		String errInfo = "";
		if ((Tools.notEmpty(sessionCode)) && (sessionCode.equalsIgnoreCase(code))) {
			Map<String, String> map = new HashMap<>();
			map.put("loginname", loginname);
			map.put("password", Tools.md5(password));
			User user = userService.getUserByNameAndPwd(map);
			if (user != null) {// 不是新用户
//				如果用户登陆成功后，记录当前用户的登陆状态status=1
				user.setStatus(1);
				userService.updateUserLoginStatus(user);
				System.out.println("用户登录状态："+user.getStatus());
				
				user.setLastLogin(new Date());
				userService.updateLastLogin(user);
				session.setAttribute("sessionUser", user);

				request.getSession().setAttribute(RecordSessionListener.loginFlag, user);
				session.removeAttribute("sessionSecCode");
			} else {
				errInfo = "新用户";
			}
		} else {
			errInfo = "验证码错误";
		}
		if (Tools.isEmpty(errInfo)) {
			mv.setViewName("redirect:index.html");
		} else {
			mv.addObject("errInfo", errInfo);
			mv.addObject("loginname", loginname);
			mv.addObject("password", Tools.md5(password));
			mv.setViewName("login");
		}
		return mv;
	}

	@RequestMapping("/checkLogin")
	@ResponseBody
	public String checkLogin(HttpServletRequest request) {
		String msg = "";
		if (request.getSession().getAttribute(RecordSessionListener.loginFlag) == null) {
			msg = "nologin";
			
		} else {
			msg = "logined";
		}
		return msg;
	}

	@RequestMapping("/index")
	public String index(HttpSession session, Model model) {
		User user = (User) session.getAttribute("sessionUser");
		user = userService.getUserAndRoleById(user.getUserId());
		Role role = user.getRole();
		String roleRights = role != null ? role.getRights() : "";
		String userRights = user.getRights();
		System.err.println("用户权限："+userRights+"，角色权限："+roleRights);
		session.setAttribute("sessionRoleRights", roleRights);
		session.setAttribute("sessionUserRights", userRights);
		List<Menu> menuList = menuService.listAllMenu();
		if ((Tools.notEmpty(userRights)) || (Tools.notEmpty(roleRights))) {
			for (Menu menu : menuList) {
				menu.setHasMenu((RightsHelper.testRights(userRights, menu.getMenuId().intValue()))
						|| (RightsHelper.testRights(roleRights, menu.getMenuId().intValue())));
				if (menu.isHasMenu()) {
					List<Menu> subMenuList = menu.getSubMenu();
					for (Menu sub : subMenuList) {
						sub.setHasMenu((RightsHelper.testRights(userRights, sub.getMenuId().intValue()))
								|| (RightsHelper.testRights(roleRights, sub.getMenuId().intValue())));
					}
				}
			}
		}
//		System.err.println("goto index.jsp，get sessionUser");
//		for (Menu menu : menuList) {
//			System.out.println("pc菜单列表：" + menu.getFactoryId() + "," + menu.getMenuName());
//		}
		JSONArray menuLists = JSONArray.fromObject(menuList);
//		System.out.println(menuLists);
		model.addAttribute("user", user);
		model.addAttribute("menuLists", menuLists);
		return "index";
	}

	@RequestMapping("/logout")
	public String logout(HttpSession session) {
		
//		用户退出，将登陆状态置为0
		User user = (User) session.getAttribute("sessionUser");
		user.setStatus(0);
		userService.updateUserLoginStatus(user);
		
		session.removeAttribute("sessionUser");
		session.removeAttribute("sessionRoleRights");
		session.removeAttribute("sessionUserRights");
		return "login";
	}
}
