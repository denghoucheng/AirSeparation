package cn.edu.hdu.Controller;

import cn.edu.hdu.Entity.Menu;
import cn.edu.hdu.Entity.Role;
import cn.edu.hdu.Entity.User;
import cn.edu.hdu.Service.MenuService;
import cn.edu.hdu.Service.RoleService;
import cn.edu.hdu.Service.UserService;
import cn.edu.hdu.Utils.Const;
import cn.edu.hdu.Utils.ResponseUtil;
import cn.edu.hdu.Utils.RightsHelper;
import cn.edu.hdu.Utils.Tools;
import java.io.PrintWriter;
import java.math.BigInteger;
import java.util.Iterator;
import java.util.List;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

@Controller
@RequestMapping("/user")
public class UserController{
	
	@Autowired
	private UserService userService;
	@Autowired
	private RoleService roleService;
	@Autowired
	private MenuService menuService;
  
	public static Logger log = Logger.getLogger(UserController.class);
  
	/**
	 * 
	 * @param session
	 * @param user
	 * @return
	 */
	@RequestMapping
	public ModelAndView listUser(HttpSession session, User user){
		user = userService.getUserById(user.getUserId());
	    List<User> userList = userService.listPageUser(user);
	    for (User user2 : userList) {
			System.out.println("用户表roleId关联角色表Id后,当前用户名下的所有子用户："+user2);
		}
	    List<Role> roleList = roleService.listAllRoles();
	    ModelAndView mv = new ModelAndView();
	    mv.setViewName("user/user_list");
	    mv.addObject("userList", userList);
	    mv.addObject("roleList", roleList);
	    mv.addObject("user", user);
	    return mv;
	}
  
	/**
	 * 
	 * @param model
	 * @return
	 */
	@RequestMapping("/add")
	public String toAdd(Model model){
		List<Role> roleList = this.roleService.listAllRoles();
		model.addAttribute("roleList", roleList);
		return "user/user_info";
	}
  
	/**
	 * 
	 * @param user
	 * @return
	 */
	@RequestMapping("/save")
	public ModelAndView saveUser(User user){
		System.out.println("/save");
	    ModelAndView mv = new ModelAndView();
	    System.out.println(user);
	    if ((user.getUserId() == null) || (user.getUserId().intValue() == 0)){
	      if (!this.userService.insertUser(user)) {
	        mv.addObject("msg", "failed");
	      } else {
	        mv.addObject("msg", "success");
	      }
	    }
	    else {
	      this.userService.updateUserBaseInfo(user);
	    }
	    mv.setViewName("save_result");
	    return mv;
	}
  
	@RequestMapping(value="/save",method=RequestMethod.POST)
	public ModelAndView saveUserPost(User user){
	    ModelAndView mv = new ModelAndView();
	    System.out.println(user);
	    if ((user.getUserId() == null) || (user.getUserId().intValue() == 0)){
	      if (!this.userService.insertUser(user)) {
	        mv.addObject("msg", "failed");
	      } else {
	        mv.addObject("msg", "success");
	      }
	    }
	    else {
	      this.userService.updateUserBaseInfo(user);
	    }
	    mv.setViewName("save_result");
	    return mv;
	}
  
	/**
	 * 
	 * @param user
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/modifyPassword")
	public String modifyPassword(User user, HttpServletResponse response)throws Exception{
	    JSONObject result = new JSONObject();
	    try{
	      this.userService.updateUserBaseInfo(user);
	      result.put("success", Boolean.valueOf(true));
	    }
	    catch (Exception e){
	      e.printStackTrace();
	      result.put("success", Boolean.valueOf(false));
	    }
	    System.out.println("修改密码信息："+result);
	    ResponseUtil.write(response, result);
	    return null;
	}
  
	/**
	 * 
	 * @param userId
	 * @return
	 */
	@RequestMapping("/edit")
	public ModelAndView toEdit(@RequestParam int userId){
	    ModelAndView mv = new ModelAndView();
	    User user = this.userService.getUserById(Integer.valueOf(userId));
	    List<Role> roleList = this.roleService.listAllRoles();
	    mv.addObject("user", user);
	    mv.addObject("roleList", roleList);
	    mv.setViewName("user/user_info");
	    return mv;
	}
	
	/**
	 * 
	 * @param userId
	 * @param out
	 */
	@RequestMapping("/delete")
	public void deleteUser(@RequestParam int userId, PrintWriter out){
	    this.userService.deleteUser(userId);
	    out.write("success");
	    out.close();
	    out.flush();
	}
	
	/**
	 * 
	 * @param session
	 * @param userId
	 * @param model
	 * @return
	 */
	@RequestMapping(value="/auth")
	public String auth(HttpSession session,@RequestParam int userId,Model model){
		User user = (User)session.getAttribute(Const.SESSION_USER);
		user = userService.getUserAndRoleById(user.getUserId());
	
		Role role = user.getRole();
		String roleRights = role!=null ? role.getRights() : "";
	
		List<Menu> menuList = menuService.listAllMenu();
		if(Tools.notEmpty(roleRights)){
			for(Menu menu : menuList){
				menu.setHasMenu(RightsHelper.testRights(roleRights, menu.getMenuId()));
				
				if(menu.isHasMenu()){
					List<Menu> subMenuList = menu.getSubMenu();
					for(Menu sub : subMenuList){
						sub.setHasMenu(RightsHelper.testRights(roleRights, sub.getMenuId()));
					}
				}
			}
			//移除不需要的菜单权限
			Iterator<Menu> it1 = menuList.iterator();
			while(it1.hasNext()) {
				Menu subMenuList1 = it1.next();
				if(!subMenuList1.isHasMenu()){
					it1.remove();
				}else{
					List<Menu> subMenu = subMenuList1.getSubMenu();
					Iterator<Menu> it2 = subMenu.iterator();
					while(it2.hasNext()){
						Menu subMenuList2 = it2.next();
						if(!subMenuList2.isHasMenu()){
							it2.remove();
						}
					}
				}
			}
			
			Iterator<Menu> it11 = menuList.iterator();
			while(it11.hasNext()) {
				Menu subMenuList1 = it11.next();
				if(subMenuList1.isHasMenu()){
					subMenuList1.setHasMenu(false);
					Iterator<Menu> it22 = subMenuList1.getSubMenu().iterator();
					while(it22.hasNext()){
						Menu subMenuList2 = it22.next();
						if(subMenuList2.isHasMenu()){
							subMenuList2.setHasMenu(false);
						}
					}
				}
			}
			
			user = userService.getUserAndRoleById(userId);
			String userRights = user.getRights();
			
			if(Tools.notEmpty(userRights)){
				for(Menu menu : menuList){
					menu.setHasMenu(RightsHelper.testRights(userRights, menu.getMenuId()));
					
					if(menu.isHasMenu()){
						List<Menu> subMenuList = menu.getSubMenu();
						for(Menu sub : subMenuList){
							sub.setHasMenu(RightsHelper.testRights(userRights, sub.getMenuId()));
						}
					}
				}
			}
			
		}
		
		JSONArray arr = JSONArray.fromObject(menuList);
		String json = arr.toString();
		json = json.replaceAll("menuId", "id").replaceAll("menuName", "name").replaceAll("subMenu", "nodes").replaceAll("hasMenu", "checked");
		model.addAttribute("zTreeNodes", json);
		model.addAttribute("userId", userId);
		return "authorization";
	}
	
	/**
	 * 保存用户权限
	 * @param userId
	 * @param menuIds
	 * @return
	 */
	@RequestMapping("/auth/save")
	@ResponseBody
	public String saveAuth(@RequestParam int userId, @RequestParam String menuIds){
		BigInteger rights = RightsHelper.sumRights(Tools.str2StrArray(menuIds));
	    User user = this.userService.getUserById(Integer.valueOf(userId));
	    user.setRights(rights.toString());
	    userService.updateUserRights(user);
	    String flag = "success";
	    return flag;
	}
}
