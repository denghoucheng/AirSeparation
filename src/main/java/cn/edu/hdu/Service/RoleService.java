package cn.edu.hdu.Service;

import cn.edu.hdu.Entity.Role;
import java.util.List;

public abstract interface RoleService
{
  public abstract List<Role> listAllRoles();
  
  public abstract Role getRoleById(int paramInt);
  
  public abstract Integer getRoleIdByRoleName(String paramString);
  
  public abstract boolean insertRole(Role paramRole);
  
  public abstract boolean updateRoleBaseInfo(Role paramRole);
  
  public abstract void deleteRoleById(int paramInt);
  
  public abstract void updateRoleRights(Role paramRole);
  
  public abstract String getRoleByUserId(Integer paramInteger);
}
