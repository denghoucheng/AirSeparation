package cn.edu.hdu.Dao;

import cn.edu.hdu.Entity.User;
import java.util.List;
import java.util.Map;

public  interface UserMapper{
	
  public abstract List<User> listAllUser();
  
  public abstract User getUserById(Integer paramInteger);
  
  public abstract void insertUser(User paramUser);
  
  public abstract void updateUser(User paramUser);
  
  public abstract User getUserByNameAndPwd(Map<String, String> paramMap);
  
  public abstract void updateUserBaseInfo(User paramUser);
  
  public abstract void updateUserRights(User paramUser);
  
  public abstract void updateUserLoginStatus(User user);
  
  public abstract int getCountByName(String paramString);
  
  public abstract void deleteUser(int paramInt);
  
  public abstract int getCount(User paramUser);
  
  public abstract List<User> listPageUser(User paramUser);
  
  public abstract User getUserAndRoleById(Integer paramInteger);
  
  public abstract void updateLastLogin(User paramUser);
  
  public abstract User getUserByOpenId(String paramString);
  
  public abstract List<String> listAllOpenId();
}
