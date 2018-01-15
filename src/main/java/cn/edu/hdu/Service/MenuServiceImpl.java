package cn.edu.hdu.Service;

import cn.edu.hdu.Dao.MenuMapper;
import cn.edu.hdu.Entity.Menu;
import java.util.List;
import javax.annotation.Resource;
import org.springframework.stereotype.Service;

@Service
public class MenuServiceImpl implements MenuService {
	@Resource
	private MenuMapper menuMapper;

	public void deleteMenuById(Integer menuId) {
		this.menuMapper.deleteMenuById(menuId);
	}

	public Menu getMenuById(Integer menuId) {
		return this.menuMapper.getMenuById(menuId);
	}

	public List<Menu> listAllParentMenu() {
		return this.menuMapper.listAllParentMenu();
	}

	public void saveMenu(Menu menu) {
		if ((menu.getMenuId() != null) && (menu.getMenuId().intValue() > 0)) {
			this.menuMapper.updateMenu(menu);
		} else {
			this.menuMapper.insertMenu(menu);
		}
	}

	public List<Menu> listSubMenuByParentId(Integer parentId) {
		return this.menuMapper.listSubMenuByParentId(parentId);
	}

	public List<Menu> listAllMenu() {
		List<Menu> rl = listAllParentMenu();
		for (Menu menu : rl) {
			List<Menu> fistSubList = listSubMenuByParentId(menu.getMenuId());
			for (Menu menu1 : fistSubList) {
				if ("".equals(menu1.getMenuUrl())) {
					List<Menu> secondSubList = listSubMenuByParentId(menu1.getMenuId());
					menu1.setSubMenu(secondSubList);
				}
			}
			menu.setSubMenu(fistSubList);
		}
		return rl;
	}

	public List<Menu> listAllSubMenu() {
		return this.menuMapper.listAllSubMenu();
	}
}
