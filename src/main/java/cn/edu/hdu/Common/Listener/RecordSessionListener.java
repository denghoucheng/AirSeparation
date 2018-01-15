package cn.edu.hdu.Common.Listener;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

import javax.servlet.http.HttpSession;
import javax.servlet.http.HttpSessionAttributeListener;
import javax.servlet.http.HttpSessionBindingEvent;
import javax.servlet.http.HttpSessionEvent;
import javax.servlet.http.HttpSessionListener;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationContext;
import org.springframework.web.context.support.WebApplicationContextUtils;

import cn.edu.hdu.Entity.SessionAndUser;
import cn.edu.hdu.Entity.User;
import cn.edu.hdu.Service.UserService;
import cn.edu.hdu.Utils.Const;
import cn.edu.hdu.Utils.changUser;

public class RecordSessionListener implements HttpSessionAttributeListener, HttpSessionListener {

	private final static Logger log = Logger.getLogger(RecordSessionListener.class);

	@Autowired
	private ApplicationContext appContext;

	private UserService userService;

	private static List<SessionAndUser> sessions;

	public static String loginFlag = Const.SESSION_USER;

	static {
		if (sessions == null) {
			sessions = Collections.synchronizedList(new ArrayList<SessionAndUser>());
		}
	}

	/**
	 * 添加session会执行此方法
	 */
	public void attributeAdded(HttpSessionBindingEvent e) {
		HttpSession session = e.getSession();
		String attrName = e.getName();
		log.info("* 为session添加属性: " + attrName);
		// 登录
		if (attrName.equals(loginFlag)) {
			User nowUser = (User) e.getValue();
			User sUser = (User) session.getAttribute(loginFlag);
			System.out.println("nowUser:" + nowUser + " sUser:" + sUser.getLoginname());
			// 遍历所有session
			for (int i = sessions.size() - 1; i >= 0; i--) {
				SessionAndUser tem = sessions.get(i);
				if (tem.getUserID().equals(nowUser.getLoginname())) {
					// System.out.println("Add:invalidate 1!" + tem.getSid());
					// tem.getSession().invalidate();// 自动调用remove
					break;
				}
			}

			SessionAndUser sau = new SessionAndUser();
			sau.setUserID(nowUser.getLoginname());
			sau.setSession(session);
			sau.setSid(session.getId());
			sessions.add(sau);

			for (int i = 0; i < sessions.size(); i++) {
				SessionAndUser tem = sessions.get(i);
				System.out.println(i + ":" + tem.getUserID());
			}
		}
		log.info("添加SessionID:" + session.getId() + "(" + e.getName() + "," + e.getValue() + ") " + sessions.size());
	}

	/**
	 * 移除session会执行此方法
	 */
	public void attributeRemoved(HttpSessionBindingEvent e) {
		HttpSession session = e.getSession();
		log.info("* 执行attributeRemoved，移除session属性");
		String attrName = e.getName();
		// 登录
		if (attrName.equals(loginFlag)) {
			User nowUser = (User) e.getValue();
			log.info("* 当前用户nowUser:" + nowUser);
			// 遍历所有session
			for (int i = sessions.size() - 1; i >= 0; i--) {
				SessionAndUser tem = sessions.get(i);

				if (tem.getUserID().equals(nowUser.getLoginname())) {
					sessions.remove(i);
					break;
				}
			}

			for (int i = 0; i < sessions.size(); i++) {
				SessionAndUser tem = sessions.get(i);
			}
		}
		log.info("* 移除SessionID:" + session.getId() + "(" + e.getName() + "," + e.getValue() + ")" + sessions.size());
	}

	/**
	 * session值变化值，会执行此方法
	 */
	public void attributeReplaced(HttpSessionBindingEvent e) {
		HttpSession session = e.getSession();
		log.info("* 执行attributeReplaced方法，重置session属性");
		String attrName = e.getName();
		int delS = -1;
		// 登录
		if (attrName.equals(loginFlag)) {
			// User nowUser = (User) e.getValue();//old value
			User nowUser = (User) session.getAttribute(loginFlag);// 当前session中的user
			System.out.println("nowUser:" + nowUser);
			// 遍历所有session
			for (int i = sessions.size() - 1; i >= 0; i--) {
				SessionAndUser tem = sessions.get(i);
				if (tem.getUserID().equals(nowUser.getLoginname()) && !tem.getSid().equals(session.getId())) {
					System.out.println("Remove:invalidate 1!");
					delS = i;
				} else if (tem.getSid().equals(session.getId())) {
					tem.setUserID(nowUser.getLoginname());
				}
			}

			if (delS != -1) {
				sessions.get(delS).getSession().invalidate();// 失效时自动调用了remove方法。也就会把它从sessions中移除了
			}

			for (int i = 0; i < sessions.size(); i++) {
				SessionAndUser tem = sessions.get(i);
				System.out.println(i + ":" + tem.getUserID());
			}
		}
		log.info(
				"* 重置session的ID:" + session.getId() + " (" + e.getName() + "," + e.getValue() + ") " + sessions.size());
	}

	/**
	 * 创建session
	 */
	public void sessionCreated(HttpSessionEvent e) {
		log.info("* 为当前用户创建Session，SID:" + e.getSession().getId());
		e.getSession().setMaxInactiveInterval(60*30);
	}

	/**
	 * 销毁session
	 */
	public void sessionDestroyed(HttpSessionEvent e) {
		System.err.println("* 销毁SessionID:" + e.getSession().getId());
		// 用户退出，将登陆状态置为0
		User user = (User) e.getSession().getAttribute(Const.SESSION_USER);
		System.err.println("* 退出用户的的信息：" + user);
		if (user != null) {
			changUser.LoginStatus(user.getUserId());
		}
	}

}
