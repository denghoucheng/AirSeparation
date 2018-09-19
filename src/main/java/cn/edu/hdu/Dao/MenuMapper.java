package cn.edu.hdu.Dao;

import cn.edu.hdu.Entity.Menu;
import java.util.List;

public  interface MenuMapper{
	
  public abstract List<Menu> listAllParentMenu();
  
  public abstract List<Menu> listSubMenuByParentId(Integer paramInteger);
  
  public abstract Menu getMenuById(Integer paramInteger);
  
  public abstract List<Menu> listAllSubMenu();
  
  public abstract void insertMenu(Menu paramMenu);
  
  public abstract void updateMenu(Menu paramMenu);
  
  public abstract void deleteMenuById(Integer paramInteger);
}
