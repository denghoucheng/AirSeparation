package cn.edu.hdu.Utils;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;


public class changUser {
	
	public static void LoginStatus(Integer userId) {
		Connection conn = null;
		PreparedStatement ps = null;
		String url = "jdbc:mysql://114.55.143.24:3306/db_Opc?user=root&password=opc_123&useUnicode=true&characterEncoding=utf8&autoReconnect=true&failOverReadOnly=false";
		try {
			conn = DriverManager.getConnection(url);
			ps = conn.prepareStatement("update tb2_user set status=? where user_id=?");
			ps.setInt(1, 0);
			ps.setInt(2, userId);
			ps.executeUpdate();
		} catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
		}
	}
}
