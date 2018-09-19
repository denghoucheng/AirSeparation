package cn.edu.hdu.Service;

import cn.edu.hdu.Entity.User;
import java.util.List;
import java.util.Map;

public abstract interface UserService {
	public abstract User getUserById(Integer paramInteger);

	public abstract boolean insertUser(User paramUser);

	public abstract void updateUser(User paramUser);

	public abstract User getUserByNameAndPwd(Map<String, String> paramMap);

	public abstract void updateUserBaseInfo(User paramUser);

	public abstract void updateUserRights(User paramUser);
	
	public abstract void updateUserLoginStatus(User paramUser);

	public abstract void deleteUser(int paramInt);

	public abstract List<User> listPageUser(User paramUser);

	public abstract void updateLastLogin(User paramUser);

	public abstract User getUserAndRoleById(Integer paramInteger);

	public abstract List<User> listAllUser();

	public abstract User getUserByOpenId(String paramString);

	public abstract List<String> listAllOpenId();
}
