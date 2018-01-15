package cn.edu.hdu.Controller;

import cn.edu.hdu.Entity.Menu;
import cn.edu.hdu.Entity.Role;
import cn.edu.hdu.Service.MenuService;
import cn.edu.hdu.Service.RoleService;
import cn.edu.hdu.Utils.RightsHelper;
import cn.edu.hdu.Utils.Tools;
import java.io.PrintWriter;
import java.math.BigInteger;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;

import net.sf.json.JSONArray;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
@RequestMapping("/role")
public class RoleController{
	@Autowired
	private RoleService roleService;
	@Autowired
	private MenuService menuService;
	public static Logger log = Logger.getLogger(RoleController.class);
  
	@RequestMapping
	public String list(Map<String, Object> map){
		System.out.println("/role");
		for(Entry<String, Object> m:map.entrySet()) {
			System.err.println(m.getKey()+","+m.getValue());
		}
		List<Role> roleList = this.roleService.listAllRoles();
		System.err.println(roleList);
		map.put("roleList", roleList);
		return "role/role_list";
	}
  
	@RequestMapping("/add")
	public String toAdd(Model model){
		List<Role> roleList = this.roleService.listAllRoles();
		model.addAttribute("roleList", roleList);
		return "role/role_info";
	}
  
	@RequestMapping("/save")
	@ResponseBody
	public String save(Role role){
		log.info(role);
		String oldRoleName = role.getRights();
		role.setRoleId(this.roleService.getRoleIdByRoleName(oldRoleName));
		log.info(role);
    
		boolean flag = true;
		String flagString = "success";
		if (role.getRoleId() == null) {
			flag = this.roleService.insertRole(role);
		} else {
			flag = this.roleService.updateRoleBaseInfo(role);
		}
		if (role.getRoleName().equals(oldRoleName)) {
			flag = false;
		}
	    if (flag) {
	      flagString = "success";
	    } else {
	      flagString = "failed";
	    }
	    return flagString;
	}
  
	@RequestMapping("/delete")
	public void deleteRole(@RequestParam int roleId, PrintWriter out){
	    this.roleService.deleteRoleById(roleId);
	    out.write("success");
	    out.flush();
	    out.close();
	}
  
	@RequestMapping("/auth")
	public String auth(@RequestParam int roleId, Model model){
	    List<Menu> menuList = this.menuService.listAllMenu();
	    Role role = this.roleService.getRoleById(roleId);
	    String roleRights = role.getRights();
	    if (Tools.notEmpty(roleRights)) {
	      for (Menu menu : menuList)
	      {
	        menu.setHasMenu(RightsHelper.testRights(roleRights, menu.getMenuId().intValue()));
	        if (menu.isHasMenu())
	        {
	          List<Menu> subMenuList = menu.getSubMenu();
	          for (Menu sub : subMenuList) {
	            sub.setHasMenu(RightsHelper.testRights(roleRights, sub.getMenuId().intValue()));
	          }
	        }
	      }
	    }
	    JSONArray arr = JSONArray.fromObject(menuList);
	    String json = arr.toString();
	    json = json.replaceAll("menuId", "id").replaceAll("menuName", "name").replaceAll("subMenu", "nodes").replaceAll("hasMenu", "checked");
	    log.info("zTreeNodes:" + json);
	    log.info("roleId:" + roleId);
	    model.addAttribute("zTreeNodes", json);
	    model.addAttribute("roleId", Integer.valueOf(roleId));
	    return "authorization";
	 }
	  
	 @RequestMapping("/auth/save")
	 @ResponseBody
	 public String saveAuth(@RequestParam int roleId, @RequestParam String menuIds){
	   Role role = this.roleService.getRoleById(roleId);
	   if (("".equals(menuIds)) || (menuIds == null) || (menuIds == "0"))
	    {
	      String rights = "0";
	      role.setRights(rights);
	    }
	    else
	    {
	      BigInteger rights = RightsHelper.sumRights(Tools.str2StrArray(menuIds));
	      role.setRights(rights.toString());
	    }
	    this.roleService.updateRoleRights(role);
	    String flag = "success";
	    return flag;
	 }
}
