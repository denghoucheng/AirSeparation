package cn.edu.hdu.Utils;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.io.UnsupportedEncodingException;
import java.security.MessageDigest;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.LinkedHashMap;
import java.util.Map;

public class Tools {
	public static String encodeStr(String str) {
		try {
			return new String(str.getBytes("ISO-8859-1"), "UTF-8");
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		}
		return null;
	}

	public static boolean notEmpty(String s) {
		return (s != null) && (!"".equals(s)) && (!"null".equals(s));
	}

	public static boolean isEmpty(String s) {
		return (s == null) || ("".equals(s)) || ("null".equals(s));
	}

	public static String[] str2StrArray(String str, String splitRegex) {
		if (isEmpty(str)) {
			return null;
		}
		return str.split(splitRegex);
	}

	public static String[] str2StrArray(String str) {
		return str2StrArray(str, ",\\s*");
	}

	public static String date2Str(Date date) {
		return date2Str(date, "yyyy-MM-dd HH:mm:ss");
	}

	public static Date str2Date(String date) {
		if (notEmpty(date)) {
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			try {
				return sdf.parse(date);
			} catch (ParseException e) {
				e.printStackTrace();

				return new Date();
			}
		}
		return null;
	}

	public static String date2Str(Date date, String format) {
		if (date != null) {
			SimpleDateFormat sdf = new SimpleDateFormat(format);
			return sdf.format(date);
		}
		return "";
	}

	public static void writeFile(String fileP, String content) {
		String filePath = String.valueOf(Thread.currentThread().getContextClassLoader().getResource("")) + "../../";
		filePath = (filePath.trim() + fileP.trim()).substring(6).trim();
		if (filePath.indexOf(":") != 1) {
			filePath = File.separator + filePath;
		}
		try {
			OutputStreamWriter write = new OutputStreamWriter(new FileOutputStream(filePath), "utf-8");
			BufferedWriter writer = new BufferedWriter(write);
			writer.write(content);
			writer.close();
		} catch (IOException e) {
			e.printStackTrace();
		}
	}

	public static String readTxtFile(String fileP) {
		try {
			String filePath = String.valueOf(Thread.currentThread().getContextClassLoader().getResource("")) + "../../";
			filePath = filePath.replaceAll("file:/", "");
			filePath = filePath.replaceAll("%20", " ");
			filePath = filePath.trim() + fileP.trim();
			if (filePath.indexOf(":") != 1) {
				filePath = File.separator + filePath;
			}
			String encoding = "utf-8";
			File file = new File(filePath);
			if ((file.isFile()) && (file.exists())) {
				InputStreamReader read = new InputStreamReader(new FileInputStream(file), encoding);
				BufferedReader bufferedReader = new BufferedReader(read);
				String lineTxt = null;
				if ((lineTxt = bufferedReader.readLine()) != null) {
					bufferedReader.close();
					return lineTxt;
				}
				read.close();
				bufferedReader.close();
			} else {
				System.out.println(filePath);
			}
		} catch (Exception e) {
			System.out.println("error");
		}
		return "";
	}

	public static String md5(String str) {
		try {
			MessageDigest md = MessageDigest.getInstance("MD5");
			md.update(str.getBytes());
			byte[] b = md.digest();

			StringBuffer buf = new StringBuffer("");
			for (int offset = 0; offset < b.length; offset++) {
				int i = b[offset];
				if (i < 0) {
					i += 256;
				}
				if (i < 16) {
					buf.append("0");
				}
				buf.append(Integer.toHexString(i));
			}
			str = buf.toString();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return str;
	}
	
	/**
	 * 将time类型的日期转化成字符串再放进map里
	 * @param paraAnalysisData
	 * @return
	 */
	public static Map<String, Object> dateHeadler(Map<String, Object> paraAnalysisData) {
		String team_01 = String.valueOf(paraAnalysisData.get("team_01"));
		String team_02 = String.valueOf(paraAnalysisData.get("team_02"));
		String team_03 = String.valueOf(paraAnalysisData.get("team_03"));
		System.out.println(team_01);
		System.out.println(team_02);
		System.out.println(team_03);
		paraAnalysisData.put("team_01", team_01);
		paraAnalysisData.put("team_02", team_02);
		paraAnalysisData.put("team_03", team_03);
		return paraAnalysisData;
	}
	public static Map<String, Object> yesterdayDataPreHeadler(Map<String, Object> paraAnalysisData) {
		Integer lineNum = Integer.valueOf(String.valueOf(paraAnalysisData.get("line_num")));
		String line_index=null;
//		String key = "team_0"+lineNum;
//		String teamTime = String.valueOf(paraAnalysisData.get(key));//01:00:00
//		String time1 = Tools.date2Str(new Date(new Date().getTime()-24*60*60*1000));//今日时间 2017-11-22 13:34:03
//		String time2 = Tools.date2Str(new Date());//今日时间 2017-11-23 13:34:03
//		String date1 = time1.substring(0,time1.indexOf(" "));//2017-11-23
//		String date2 = time2.substring(0,time2.indexOf(" "));//2017-11-23
//		String startTime = date1+" "+teamTime;//2017-11-23 01:00:00
//		String endTime = date2+" "+teamTime;//2017-11-23 01:00:00
		//拼接字段名 ,获取表名
		String tableName = null;
		String KFFields = "TIME,";
		for (int i = 1; i <= lineNum; i++) {
			line_index = "line_0"+i; 
			System.out.println(line_index);
			tableName = String.valueOf(paraAnalysisData.get("in_table"));
			KFFields += String.valueOf(paraAnalysisData.get(line_index))+",";
		}
//		System.out.println(KFFields);
		KFFields = KFFields.substring(0, KFFields.length()-1);
//		System.out.println(KFFields);
		
		Map<String, Object> map = new LinkedHashMap<>();//startTime,endTime,tableName,KFField
		map.put("tableName", tableName);
		map.put("KFFields", KFFields);
		System.err.println(map);
		return map;
	}
}
