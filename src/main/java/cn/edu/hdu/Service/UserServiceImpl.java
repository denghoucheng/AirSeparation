package cn.edu.hdu.Service;

import cn.edu.hdu.Dao.UserMapper;
import cn.edu.hdu.Entity.User;
import cn.edu.hdu.Utils.Tools;
import java.util.List;
import java.util.Map;
import javax.annotation.Resource;
import org.springframework.stereotype.Service;

@Service
public class UserServiceImpl implements UserService {
	@Resource
	private UserMapper userMapper;

	public User getUserById(Integer userId) {
		return this.userMapper.getUserById(userId);
	}

	public boolean insertUser(User user) {
		int count = this.userMapper.getCountByName(user.getLoginname());
		if (count > 0) {
			return false;
		}
		user.setPassword(Tools.md5(user.getPassword()));
		this.userMapper.insertUser(user);
		return true;
	}

	public List<User> listPageUser(User user) {
		return this.userMapper.listPageUser(user);
	}

	public void updateUser(User user) {
		this.userMapper.updateUser(user);
	}

	public void updateUserBaseInfo(User user) {
		user.setPassword(Tools.md5(user.getPassword()));
		this.userMapper.updateUserBaseInfo(user);
	}

	public void updateUserRights(User user) {
		this.userMapper.updateUserRights(user);
	}
	
	public void updateUserLoginStatus(User user) {
		this.userMapper.updateUserLoginStatus(user);
	}

	public User getUserByNameAndPwd(Map<String, String> map) {
		User userInfo = this.userMapper.getUserByNameAndPwd(map);

		return userInfo;
	}

	public void deleteUser(int userId) {
		this.userMapper.deleteUser(userId);
	}

	public User getUserAndRoleById(Integer userId) {
		return this.userMapper.getUserAndRoleById(userId);
	}

	public void updateLastLogin(User user) {
		this.userMapper.updateLastLogin(user);
	}

	public List<User> listAllUser() {
		return this.userMapper.listAllUser();
	}

	public User getUserByOpenId(String openId) {
		return this.userMapper.getUserByOpenId(openId);
	}

	public List<String> listAllOpenId() {
		return this.userMapper.listAllOpenId();
	}
}
