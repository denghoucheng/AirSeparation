package cn.edu.hdu.Service;

import cn.edu.hdu.Entity.Menu;
import java.util.List;

public abstract interface MenuService
{
  public abstract List<Menu> listAllMenu();
  
  public abstract List<Menu> listAllParentMenu();
  
  public abstract List<Menu> listSubMenuByParentId(Integer paramInteger);
  
  public abstract List<Menu> listAllSubMenu();
  
  public abstract Menu getMenuById(Integer paramInteger);
  
  public abstract void saveMenu(Menu paramMenu);
  
  public abstract void deleteMenuById(Integer paramInteger);
}
