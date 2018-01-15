package cn.edu.hdu.Utils;

import java.util.Map;

public class FactoryUtil {
	public static String assemblyModelField(int paraNum, String initField) {
		StringBuilder sb = new StringBuilder(initField);
		for (int i = 1; i <= paraNum; i++) {
			String paraName = "para" + i + "_name";
			String paraSuffix = "para" + i + "_suffix";
			sb.append(paraName + ",");
			sb.append(paraSuffix + ",");
		}
		String fields = sb.substring(0, sb.toString().lastIndexOf(","));
		return fields;
	}

	public static String assemblyKfField(Map<String, Object> paraMap, String initField) {
		StringBuilder KFFields = new StringBuilder(initField);
		for (Map.Entry<String, Object> str : paraMap.entrySet()) {
			String key = (String) str.getKey();
			if (key.contains("name")) {
				String value = (String) str.getValue();
				KFFields.append(value + ",");
			}
		}
		String SqlFields = KFFields.substring(0, KFFields.toString().lastIndexOf(","));
		System.out.println(SqlFields);
		return SqlFields;
	}
}
