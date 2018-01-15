package cn.edu.hdu.Entity;

public class Role
{
  private Integer roleId;
  private String roleName;
  private String rights;
  
  public Integer getRoleId()
  {
    return this.roleId;
  }
  
  public void setRoleId(Integer roleId)
  {
    this.roleId = roleId;
  }
  
  public String getRoleName()
  {
    return this.roleName;
  }
  
  public void setRoleName(String roleName)
  {
    this.roleName = roleName;
  }
  
  public String getRights()
  {
    return this.rights;
  }
  
  public void setRights(String rights)
  {
    this.rights = rights;
  }
  
  public String toString()
  {
    return "Role [roleId=" + this.roleId + ", roleName=" + this.roleName + ", rights=" + this.rights + "]";
  }
}
