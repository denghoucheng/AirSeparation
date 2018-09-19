package cn.edu.hdu.Entity;

import java.util.List;

public class Menu
{
  private Integer menuId;
  private Integer parentId;
  private String menuName;
  private String menuUrl;
  private Integer factoryId;
  private Menu parentMenu;
  private List<Menu> subMenu;
  private boolean hasMenu = false;
  
  public Integer getMenuId()
  {
    return this.menuId;
  }
  
  public void setMenuId(Integer menuId)
  {
    this.menuId = menuId;
  }
  
  public String getMenuName()
  {
    return this.menuName;
  }
  
  public void setMenuName(String menuName)
  {
    this.menuName = menuName;
  }
  
  public String getMenuUrl()
  {
    return this.menuUrl;
  }
  
  public void setMenuUrl(String menuUrl)
  {
    this.menuUrl = menuUrl;
  }
  
  public Integer getFactoryId()
  {
    return this.factoryId;
  }
  
  public void setFactoryId(Integer factoryId)
  {
    this.factoryId = factoryId;
  }
  
  public Integer getParentId()
  {
    return this.parentId;
  }
  
  public void setParentId(Integer parentId)
  {
    this.parentId = parentId;
  }
  
  public Menu getParentMenu()
  {
    return this.parentMenu;
  }
  
  public void setParentMenu(Menu parentMenu)
  {
    this.parentMenu = parentMenu;
  }
  
  public List<Menu> getSubMenu()
  {
    return this.subMenu;
  }
  
  public void setSubMenu(List<Menu> subMenu)
  {
    this.subMenu = subMenu;
  }
  
  public boolean isHasMenu()
  {
    return this.hasMenu;
  }
  
  public void setHasMenu(boolean hasMenu)
  {
    this.hasMenu = hasMenu;
  }
}
