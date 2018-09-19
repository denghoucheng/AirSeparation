package cn.edu.hdu.Utils;

import cn.edu.hdu.Service.MenuService;
import cn.edu.hdu.Service.RoleService;
import cn.edu.hdu.Service.UserService;

public final class ServiceHelper {
	public static Object getService(String serviceName) {
		return Const.WEB_APP_CONTEXT.getBean(serviceName);
	}

	public static UserService getUserService() {
		return (UserService) getService("userService");
	}

	public static RoleService getRoleService() {
		return (RoleService) getService("roleService");
	}

	public static MenuService getMenuService() {
		return (MenuService) getService("menuMappper");
	}
}
