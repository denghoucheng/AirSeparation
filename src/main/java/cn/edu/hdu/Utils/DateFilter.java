package cn.edu.hdu.Utils;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;
import org.apache.log4j.Logger;

public class DateFilter {
	public static Logger log = Logger.getLogger(DateFilter.class);

	public static Map<String, Object> dateFilter(String dateStart, String dateEnd) throws Exception {
		SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		Date dStart = null;
		Date dEnd = null;
		Map<String, Object> map = new HashMap<>();
		Calendar date = Calendar.getInstance();
		if ((dateStart == "") && (dateEnd == "")) {
			dEnd = new Date();
			date.setTime(dEnd);
			date.set(10, date.get(10) - 1);
			dStart = date.getTime();
		} else if ((dateStart == "") && (dateEnd != "")) {
			dEnd = simpleDateFormat.parse(dateEnd);
			date.setTime(dEnd);
			date.set(10, date.get(10) - 1);
			dStart = date.getTime();
		} else if ((dateStart != "") && (dateEnd == "")) {
			dStart = simpleDateFormat.parse(dateStart);
			date.setTime(dStart);
			date.set(10, date.get(10) + 1);
			dEnd = date.getTime();
		} else {
			dStart = simpleDateFormat.parse(dateStart);
			dEnd = simpleDateFormat.parse(dateEnd);
		}
		int hourNum = (int) (dEnd.getTime() / 3600000L - dStart.getTime() / 3600000L);
		if (hourNum <= 1) {
			map.put("interval", null);
			log.info("interval:null");
		} else {
			map.put("interval", Integer.valueOf(hourNum * 3));
			log.info("interval:" + hourNum * 3);
		}
		map.put("dStart", dStart);
		map.put("dEnd", dEnd);
		System.out.println(map);
		return map;
	}
}
