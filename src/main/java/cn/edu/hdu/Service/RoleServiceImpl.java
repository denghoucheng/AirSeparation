package cn.edu.hdu.Service;

import cn.edu.hdu.Dao.RoleMapper;
import cn.edu.hdu.Entity.Role;
import java.util.List;
import javax.annotation.Resource;
import org.springframework.stereotype.Service;

@Service
public class RoleServiceImpl
  implements RoleService
{
  @Resource
  private RoleMapper roleMapper;
  
  public List<Role> listAllRoles()
  {
    return this.roleMapper.listAllRoles();
  }
  
  public void deleteRoleById(int roleId)
  {
    this.roleMapper.deleteRoleById(roleId);
  }
  
  public Role getRoleById(int roleId)
  {
    return this.roleMapper.getRoleById(roleId);
  }
  
  public boolean insertRole(Role role)
  {
    if (this.roleMapper.getCountByName(role) > 0) {
      return false;
    }
    this.roleMapper.insertRole(role);
    return true;
  }
  
  public boolean updateRoleBaseInfo(Role role)
  {
    if (this.roleMapper.getCountByName(role) > 0) {
      return false;
    }
    this.roleMapper.updateRoleBaseInfo(role);
    return true;
  }
  
  public void updateRoleRights(Role role)
  {
    this.roleMapper.updateRoleRights(role);
  }
  
  public String getRoleByUserId(Integer userId)
  {
    return this.roleMapper.getRoleByUserId(userId);
  }
  
  public Integer getRoleIdByRoleName(String roleName)
  {
    return this.roleMapper.getRoleIdByRoleName(roleName);
  }
}
