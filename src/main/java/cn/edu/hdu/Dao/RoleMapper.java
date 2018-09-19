package cn.edu.hdu.Dao;

import cn.edu.hdu.Entity.Role;
import java.util.List;

public  interface RoleMapper{
	
  public abstract List<Role> listAllRoles();
  
  public abstract Role getRoleById(int paramInt);
  
  public abstract Integer getRoleIdByRoleName(String paramString);
  
  public abstract void insertRole(Role paramRole);
  
  public abstract void updateRoleBaseInfo(Role paramRole);
  
  public abstract void deleteRoleById(int paramInt);
  
  public abstract int getCountByName(Role paramRole);
  
  public abstract void updateRoleRights(Role paramRole);
  
  public abstract String getRoleByUserId(Integer paramInteger);
}
