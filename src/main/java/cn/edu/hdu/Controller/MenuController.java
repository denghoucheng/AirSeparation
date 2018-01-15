package cn.edu.hdu.Controller;

import cn.edu.hdu.Entity.Menu;
import cn.edu.hdu.Service.MenuService;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import javax.servlet.http.HttpServletResponse;
import net.sf.json.JSONArray;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
@RequestMapping("/menu")
public class MenuController{
	
	public static Logger log = Logger.getLogger(MenuController.class);
  
	@Autowired
	private MenuService menuService;
  
	@RequestMapping
	public String list(Model model){
	    List<Menu> menuList = this.menuService.listAllParentMenu();
	    model.addAttribute("menuList", menuList);
	    return "menu/menu_list";
	}
  
	@RequestMapping("/add")
	public String toAdd(Model model){
	    List<Menu> menuList = this.menuService.listAllParentMenu();
	    model.addAttribute("menuList", menuList);
	    return "menu/menu_info";
	}
  
	@RequestMapping("/edit")
	public String toEdit(@RequestParam Integer menuId, Model model){
	    Menu menu = this.menuService.getMenuById(menuId);
	    model.addAttribute("menu", menu);
	    if ((menu.getParentId() != null) && (menu.getParentId().intValue() > 0))
	    {
	      List<Menu> menuList = this.menuService.listAllParentMenu();
	      model.addAttribute("menuList", menuList);
	    }
	    return "menu/menu_info";
	}
  
	@RequestMapping("/save")
	public String save(Menu menu, Model model){
	    this.menuService.saveMenu(menu);
	    model.addAttribute("msg", "success");
	    return "save_result";
	}
  
	@RequestMapping("/sub")
	public void getSub(@RequestParam Integer menuId, HttpServletResponse response){
	    List<Menu> subMenu = this.menuService.listSubMenuByParentId(menuId);
	    JSONArray arr = JSONArray.fromObject(subMenu);
	    try
	    {
	      response.setCharacterEncoding("utf-8");
	      PrintWriter out = response.getWriter();
	      String json = arr.toString();
	      out.write(json);
	      out.flush();
	      out.close();
	    }
	    catch (IOException e)
	    {
	      e.printStackTrace();
	    }
	}
  
	@RequestMapping("/del")
	public void delete(@RequestParam Integer menuId, PrintWriter out){
	    this.menuService.deleteMenuById(menuId);
	    out.write("success");
	    out.flush();
	    out.close();
	}
}
