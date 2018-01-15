package cn.edu.hdu.Controller;

import cn.edu.hdu.Entity.Analysis;
import cn.edu.hdu.Entity.Factory;
import cn.edu.hdu.Service.FactoryService;
import cn.edu.hdu.Utils.DateFilter;
import cn.edu.hdu.Utils.DateJsonValueProcessor;
import cn.edu.hdu.Utils.FactoryUtil;
import cn.edu.hdu.Utils.ResponseUtil;
import cn.edu.hdu.Utils.Tools;

import java.io.UnsupportedEncodingException;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import net.sf.json.JsonConfig;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;


@Controller
public class FactoryController {

	private static final Logger log = Logger.getLogger(FactoryController.class);

	@Autowired
	private FactoryService factoryService;

	@RequestMapping("/current")
	public String factoryCur(@RequestParam Integer factoryId, Model model) {
		List<Factory> factoryInfoList = factoryService.listAllInfoByFactoryId(factoryId);
		model.addAttribute("factoryInfoList", factoryInfoList);
		return "current";
	}

	@RequestMapping(value = "/systemCurrent", method = RequestMethod.GET)
	public String SystemCurrentGet(@RequestParam Integer modelId, @RequestParam String modelName,
			@RequestParam String systemName, Model model) throws UnsupportedEncodingException {
		// systemName = new String(systemName.getBytes("ISO-8859-1"), "UTF-8");
		model.addAttribute("modelId", modelId);
		model.addAttribute("modelName", modelName);
		model.addAttribute("systemName", systemName);
		return "systemCurrent";
	}

	@RequestMapping(value = "/systemCurrent", method = RequestMethod.POST)
	public String SystemCurrentPost(@RequestParam Integer modelId, @RequestParam String modelName,
			@RequestParam String systemName, HttpServletResponse response, Model model)
			throws UnsupportedEncodingException {
		systemName = new String(systemName.getBytes("ISO-8859-1"), "UTF-8");
		Map<String, Object> paraMap = this.factoryService.getParasByModelNameAndId(modelName, modelId);
		String KFTable = (String) paraMap.get("para_url");

		StringBuilder KFFields = new StringBuilder();
		for (Map.Entry<String, Object> str : paraMap.entrySet()) {
			String key = (String) str.getKey();
			if ((!"".equals(str.getValue())) && (str.getValue() != null) && (!"image_name".equals(key))
					&& (key.contains("name"))) {
				String value = (String) str.getValue();
				KFFields.append(value + ",");
			}
		}
		String SqlFields = KFFields.substring(0, KFFields.toString().lastIndexOf(","));
		log.info("KFTable:" + KFTable);
		log.info("SqlFields:" + SqlFields);

		Object dataMap = this.factoryService.getData(KFTable, SqlFields);

		JSONObject json = new JSONObject();
		json.put("paraMap", paraMap);
		json.put("dataMap", dataMap);

		model.addAttribute("systemName", systemName);
		ResponseUtil.write(response, json);
		return "systemCurrent";
	}

	@RequestMapping(value = "/alarm", method = RequestMethod.GET)
	public ModelAndView alarSysGet(@RequestParam Integer factoryId) {
		System.out.println(factoryId);
		ModelAndView mv = new ModelAndView();
		mv.addObject("factoryId", factoryId);
		mv.setViewName("alarm");
		return mv;
	}

	@RequestMapping(value = "/alarm", method = RequestMethod.POST)
	public void alarmSystem(@RequestParam Integer factoryId, HttpServletResponse response, Model model) {
		System.out.println("当前报警属于工厂：" + factoryId);
		int alarmId = 0;
		List<Factory> fatories = this.factoryService.listAllInfoByFactoryId(factoryId);
		for (Factory factory : fatories) {
			if ("报警系统".equals(factory.getSystemName())) {
				alarmId = factory.getModelId().intValue();
				System.out.println(alarmId);
			}
		}
		Map<String, Object> alarmMap = this.factoryService.getAlarmInfoByAlarmId(Integer.valueOf(alarmId));
		System.out.println(alarmMap);
		String KFTable = (String) alarmMap.get("alarm_url");
		alarmMap.remove("alarm_id");
		alarmMap.remove("alarm_url");

		StringBuilder KFFields = new StringBuilder("TIME,");
		for (Map.Entry<String, Object> str : alarmMap.entrySet()) {
			String key = (String) str.getKey();
			String value = (String) str.getValue();
			if ((value != null) && (key.contains("name"))) {
				KFFields.append(value + ",");
			}
		}
		String SqlFields = KFFields.substring(0, KFFields.toString().lastIndexOf(","));
		log.info("AlarmTable:" + KFTable);
		log.info("SqlFields:" + SqlFields);

		Object dataMap = this.factoryService.getData(KFTable, SqlFields);

		JSONObject json = new JSONObject();
		json.put("alarmMap", alarmMap);
		json.put("dataMap", dataMap);

		model.addAttribute("factoryId", factoryId);
		ResponseUtil.write(response, json);
	}

	@RequestMapping("/history")
	public String factoryHis(@RequestParam Integer factoryId, Model model) {
		List<Factory> factoryInfoList = this.factoryService.listAllInfoByFactoryId(factoryId);
		model.addAttribute("factoryInfoList", factoryInfoList);
		return "history";
	}

	@RequestMapping(value = "/systemHistory", method = RequestMethod.GET)
	public String systemHistoryGET(@RequestParam Integer modelId, @RequestParam String modelName, Model model) {
		model.addAttribute("modelId", modelId);
		model.addAttribute("modelName", modelName);
		return "systemHistory";
	}

	@RequestMapping(value = "/systemHistory", method = RequestMethod.POST)
	public void systemHistoryPOST(@RequestParam String dateStart, @RequestParam String dateEnd,
			@RequestParam Integer modelId, @RequestParam String modelName, HttpServletRequest request,
			HttpServletResponse response) throws Exception {
//		从dateStart:2017-11-15 15:00:00  中取出2017-11传入sql，用来动态选择指定月份某一表（如 KF0001_201711）
		System.err.println("dateStart:"+dateStart);
		String year = dateStart.substring(0, dateStart.indexOf("-"));
		String month = dateStart.substring(dateStart.indexOf("-")+1, dateStart.lastIndexOf("-"));
		if(month.length()==1) {
			month = "0"+month;
		}
		System.out.println(year+","+month);
		
		int paraNum = this.factoryService.getParaNum(modelName, modelId);
		String ModelFields = FactoryUtil.assemblyModelField(paraNum, "para_url,para_num,");
		log.info("paraNum:" + paraNum + ",ModelFields:" + ModelFields);

		Map<String, Object> paraMap = this.factoryService.getParaValues(modelName, modelId, ModelFields);
		String KFFields = FactoryUtil.assemblyKfField(paraMap, "TIME,");
		log.info("KFFields:" + KFFields);

		Map<String, Object> dateMap = DateFilter.dateFilter(dateStart, dateEnd);
		String tableName = (String) paraMap.get("para_url");
		
		Calendar now = Calendar.getInstance();//实现分月查询
		int nowyear = now.get(Calendar.YEAR);
		int nowmonth = now.get(Calendar.MONTH)+1;
		System.out.println("当下年月："+nowyear+","+month);
		if(Integer.valueOf(year)!=nowyear && Integer.valueOf(month)!=nowmonth) {
			tableName = tableName + "_"+year+month;
		}
		System.out.println("查询的表："+tableName);
		List<Object> hisDataList = new ArrayList<>();
		try {//数据库没有当月的表，会报错，捕获异常，返回页面空值
			hisDataList = this.factoryService.getHistoryDatasByDate(dateMap, tableName, KFFields);
		} catch (Exception e) {
			hisDataList = null;
		}
		JSONObject jsonObject = new JSONObject();
		jsonObject.put("paraMap", paraMap);
		JSONArray.fromObject(hisDataList);
		jsonObject.put("hisDataList", hisDataList);
		ResponseUtil.write(response, jsonObject);
	}

	/**
	 * 数据分析处理
	 * 
	 * @param factoryId
	 * @param model
	 * @return
	 */
	@RequestMapping("/analysis")
	public @ResponseBody ModelAndView analysis(@RequestParam Integer factoryId) {
		JSONObject jsonObject = new JSONObject();
		jsonObject.put("factoryId", factoryId);
		jsonObject.put("json1", "每日报表");
		jsonObject.put("json2", "分析数据图");
		ModelAndView modelAndView = new ModelAndView();
		modelAndView.addObject("jsonObject", jsonObject);
		modelAndView.setViewName("analysis");
		return modelAndView;
	}

	
	/**
	 * 页面跳转，传递factoryId
	 * @param factoryId
	 * @return
	 */
	@RequestMapping(value="/dailyReport",method=RequestMethod.GET)
	public @ResponseBody ModelAndView dailyReportGET(@RequestParam Integer factoryId) {
		ModelAndView modelAndView = new ModelAndView();
		modelAndView.addObject("factoryId", factoryId);
		modelAndView.setViewName("dailyReport");
		return modelAndView;
	}
	/**
	 * 每日数据分析
	 * 1、表前面的日期：日报表(日期：2017-12-7)
	 * 2、表格
	 * 3、每日曲线（凌晨-凌晨）
	 * 4、班组下显示时间
	 * @param factoryId
	 * @return
	 */
	@RequestMapping(value="/dailyReport",method=RequestMethod.POST)
	public @ResponseBody JSONObject dailyReportPost(@RequestBody Analysis analysis,HttpServletResponse response) {
		System.out.println("analysis:"+analysis);
		// 0 初始化数据
		Integer factoryId = analysis.getFactoryId();
		String dateFrist = analysis.getDateFrist();
		String dateStart = analysis.getDateStart();
		String dateEnd = analysis.getDateEnd();
		System.out.println("dateStart:"+dateStart);
		System.out.println("dateEnd:"+dateEnd);
		System.out.println("dateFrist:"+dateFrist);
		// 1 根据factoryId 获取para_ana1表的数据
		Map<String, Object> paraAnalysisData = factoryService.getParaAnalysisData(factoryId);
		System.out.println("paraAnalysisData:"+paraAnalysisData);
		// 2 根据班组编号查询数据，并传入动态表名
		String out_day_tableName = String.valueOf(paraAnalysisData.get("out_table_day"));
		String field = "TIME,kind,state,out01,out02,out03,out04,out05,out06,out07,out08,out09";
//			将日期间隔置为null
		Map<String, Object> dateFilter = new LinkedHashMap<>();
		try {
			dateFilter = DateFilter.dateFilter(dateEnd,dateFrist);
		} catch (Exception e2) {
			e2.printStackTrace();
		}
		dateFilter.put("interval", null);
		System.out.println(dateFilter);
		List<Object> dailyData = factoryService.getHistoryDatasByDate(dateFilter, out_day_tableName, field);//存放dailyData的json数组
		System.out.println("dailyData:"+dailyData);
		// 3 获取画昨日曲线的数据
		Map<String, Object> yDataPreHeadler = Tools.yesterdayDataPreHeadler(paraAnalysisData);
		String tableName = (String) yDataPreHeadler.get("tableName");
		String KFFields = (String) yDataPreHeadler.get("KFFields");

		List<Object> yDataList = new ArrayList<>();
		Map<String, Object> dateFilter2 = new LinkedHashMap<>();
		try {
			dateFilter2 = DateFilter.dateFilter(dateStart,dateEnd);
		} catch (Exception e2) {
			e2.printStackTrace();
		}
		dateFilter2.put("interval", 72);
		try {
			yDataList = factoryService.getHistoryDatasByDate(dateFilter2, tableName,
					KFFields);
		} catch (Exception e) {
			e.printStackTrace();
		}
		Map<String, Object> lineNumMap = new HashMap<>();// 将lineNum传入页面，便于动态创建曲线条数
		lineNumMap.put("lineNum", paraAnalysisData.get("line_num"));
		String[] split = KFFields.split(",");
		for (int i = 0; i < split.length; i++) {
			lineNumMap.put("para" + i, split[i]);
		}

		yDataList.add(lineNumMap);
		System.out.println("yDataList:"+yDataList);
		// 转json传给页面
//		System.out.println(((Map<String, Object>)dailyData.get(1)).get("TIME").getClass());//测试从数据库得到得time类型：class java.sql.Timestamp
//		System.out.println(paraAnalysisData.get("team_01").getClass());//测试输出班组时间格式:class java.sql.Time
		Map<String, Object> result = new HashMap<>();
		String team1 = paraAnalysisData.get("team_01").toString();
		String team2 = paraAnalysisData.get("team_02").toString();
		String team3 = paraAnalysisData.get("team_03").toString();
		result.put("team_01", team1.substring(0,team1.length()-3));//17:00:00->17:00
		result.put("team_02", team2.substring(0,team2.length()-3));
		result.put("team_03", team3.substring(0,team3.length()-3));
		result.put("team_num", paraAnalysisData.get("team_num"));
		result.put("dailyData", dailyData);
		result.put("yDataList", yDataList);
		
		JsonConfig jsonConfig = new JsonConfig();
		jsonConfig.registerJsonValueProcessor(java.sql.Timestamp.class, new DateJsonValueProcessor("dd日HH:mm:ss"));
		JSONObject jsonObject = JSONObject.fromObject(result,jsonConfig);
		System.out.println(jsonObject);
		
		return jsonObject;
	}

	@RequestMapping(value = "/analysisHistory", method = RequestMethod.GET)
	public @ResponseBody ModelAndView analysisHistory(@RequestParam Integer factoryId) {
		JSONObject jsonObject = new JSONObject();
		jsonObject.put("factoryId", factoryId);
		ModelAndView modelAndView = new ModelAndView();
		modelAndView.addObject("jsonObject", jsonObject);
		modelAndView.setViewName("analysisHistory");
		return modelAndView;
	}

	@RequestMapping(value = "/analysisHistory", method = RequestMethod.POST)
	public void analysisHistoryPost(@RequestBody Analysis analysis,HttpServletResponse response) {
		Integer factoryId = analysis.getFactoryId();
		String dateStart = analysis.getDateStart();
		String dateEnd = analysis.getDateEnd();
		System.err.println(dateStart);
		System.err.println(dateEnd);
		// 1 根据factoryId 获取para_ana1表的数据
		Map<String, Object> paraAnalysisData = factoryService.getParaAnalysisData(factoryId);
		System.out.println(paraAnalysisData);
		String tableName = String.valueOf(paraAnalysisData.get("out_table_short"));//KF0001_ana_short
		System.err.println(tableName);
		String KFFields = "TIME,out01,out02,out03,out04,out05,out06,out07";
		// 2 根据时间区间从数据库获取数据
		List<Object> hisDataList = new ArrayList<>();
		try {
			Map<String, Object> dateFilter = DateFilter.dateFilter(dateStart, dateEnd);
			dateFilter.put("interval", null);//强制把时间间隔设为null
			System.out.println(dateFilter);
			hisDataList = factoryService.getHistoryDatasByDate(dateFilter, tableName, KFFields);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		System.out.println(hisDataList);
		
		// 3 json
		JSONArray jsonArray = JSONArray.fromObject(hisDataList);
		System.out.println(jsonArray);
		ResponseUtil.write(response, jsonArray);
	}
}
