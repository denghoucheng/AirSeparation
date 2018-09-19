package cn.edu.hdu.Controller;

import cn.edu.hdu.Entity.Analysis;
import cn.edu.hdu.Entity.Factory;
import cn.edu.hdu.Service.FactoryService;
import cn.edu.hdu.Utils.DateFilter;
import cn.edu.hdu.Utils.DateJsonValueProcessor;
import cn.edu.hdu.Utils.FactoryUtil;
import cn.edu.hdu.Utils.ResponseUtil;
import cn.edu.hdu.Utils.Tools;
import java.io.PrintStream;
import java.io.UnsupportedEncodingException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;
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
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

@Controller
public class FactoryController {
	private static final Logger log = Logger.getLogger(FactoryController.class);
	@Autowired
	private FactoryService factoryService;

	@RequestMapping({ "/current" })
	public String factoryCur(@RequestParam Integer factoryId, Model model) {
		List<Factory> factoryInfoList = this.factoryService.listAllInfoByFactoryId(factoryId);
		model.addAttribute("factoryInfoList", factoryInfoList);
		model.addAttribute("factoryNum", factoryInfoList.size());
		return "current";
	}

	@RequestMapping(value = { "/systemCurrent" }, method = {
			org.springframework.web.bind.annotation.RequestMethod.GET })
	public String SystemCurrentGet(@RequestParam Integer modelId, @RequestParam String modelName,
			@RequestParam String systemName, Model model) throws UnsupportedEncodingException {
		model.addAttribute("modelId", modelId);
		model.addAttribute("modelName", modelName);
		model.addAttribute("systemName", systemName);
		return "systemCurrent";
	}

	@RequestMapping(value = { "/systemCurrent" }, method = {
			org.springframework.web.bind.annotation.RequestMethod.POST })
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

	@RequestMapping(value = { "/alarm" }, method = { org.springframework.web.bind.annotation.RequestMethod.GET })
	public ModelAndView alarSysGet(@RequestParam Integer factoryId) {
		System.out.println(factoryId);
		ModelAndView mv = new ModelAndView();
		mv.addObject("factoryId", factoryId);
		mv.setViewName("alarm");
		return mv;
	}

	@RequestMapping(value = { "/alarm" }, method = { org.springframework.web.bind.annotation.RequestMethod.POST })
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

	@RequestMapping({ "/history" })
	public String factoryHis(@RequestParam Integer factoryId, Model model) {
		List<Factory> factoryInfoList = this.factoryService.listAllInfoByFactoryId(factoryId);
		model.addAttribute("factoryInfoList", factoryInfoList);
		return "history";
	}

	@RequestMapping(value = { "/systemHistory" }, method = {
			org.springframework.web.bind.annotation.RequestMethod.GET })
	public String systemHistoryGET(@RequestParam Integer modelId, @RequestParam String modelName, Model model) {
		model.addAttribute("modelId", modelId);
		model.addAttribute("modelName", modelName);
		return "systemHistory";
	}

	@RequestMapping(value = { "/systemHistory" }, method = {
			org.springframework.web.bind.annotation.RequestMethod.POST })
	public void systemHistoryPOST(@RequestParam String dateStart, @RequestParam String dateEnd,
			@RequestParam Integer modelId, @RequestParam String modelName, HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		System.err.println("dateStart:" + dateStart);
		String year = dateStart.substring(0, dateStart.indexOf("-"));
		String month = dateStart.substring(dateStart.indexOf("-") + 1, dateStart.lastIndexOf("-"));
		if (month.length() == 1) {
			month = "0" + month;
		}
		System.out.println(year + "," + month);

		int paraNum = this.factoryService.getParaNum(modelName, modelId);
		String ModelFields = FactoryUtil.assemblyModelField(paraNum, "para_url,para_num,");
		log.info("paraNum:" + paraNum + ",ModelFields:" + ModelFields);

		Map<String, Object> paraMap = this.factoryService.getParaValues(modelName, modelId, ModelFields);
		String KFFields = FactoryUtil.assemblyKfField(paraMap, "TIME,");
		log.info("KFFields:" + KFFields);

		Map<String, Object> dateMap = DateFilter.dateFilter(dateStart, dateEnd);
		String tableName = (String) paraMap.get("para_url");
		System.out.println("查询年月：" + year + "," + month);
		Calendar now = Calendar.getInstance();
		int nowyear = now.get(1);
		int nowmonth = now.get(2) + 1;
		System.out.println("当下年月：" + nowyear + "," + nowmonth);
		if ((Integer.valueOf(year).intValue() != nowyear) || (Integer.valueOf(month).intValue() != nowmonth)) {
			tableName = tableName + "_" + year + month;
		}
		System.out.println("查询的表：" + tableName);
		List<Object> hisDataList = new ArrayList();
		try {
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

	@RequestMapping({ "/analysis" })
	@ResponseBody
	public ModelAndView analysis(@RequestParam Integer factoryId) {
		JSONObject jsonObject = new JSONObject();
		jsonObject.put("factoryId", factoryId);
		jsonObject.put("json1", "每日报表");
		jsonObject.put("json2", "分析数据图");
		jsonObject.put("json3", "工况分析图");
		ModelAndView modelAndView = new ModelAndView();
		modelAndView.addObject("jsonObject", jsonObject);
		modelAndView.setViewName("analysis");
		return modelAndView;
	}

	@RequestMapping(value = { "/dailyReport" }, method = { org.springframework.web.bind.annotation.RequestMethod.GET })
	@ResponseBody
	public ModelAndView dailyReportGET(@RequestParam Integer factoryId) {
		ModelAndView modelAndView = new ModelAndView();
		modelAndView.addObject("factoryId", factoryId);
		modelAndView.setViewName("dailyReport");
		return modelAndView;
	}

	@RequestMapping(value = { "/dailyReport" }, method = { org.springframework.web.bind.annotation.RequestMethod.POST })
	@ResponseBody
	public JSONObject dailyReportPost(@RequestBody Analysis analysis, HttpServletResponse response) {
		System.out.println("analysis:" + analysis);

		Integer factoryId = analysis.getFactoryId();
		String dateFrist = analysis.getDateFrist();
		String dateStart = analysis.getDateStart();
		String dateEnd = analysis.getDateEnd();
		System.err.println("dateStart:" + dateStart);
		System.err.println("dateEnd:" + dateEnd);
		System.err.println("dateFrist:" + dateFrist);

		Map<String, Object> paraAnalysisData = this.factoryService.getParaAnalysisData(factoryId);
		System.err.println("paraAnalysisData:" + paraAnalysisData);

		String out_day_tableName = String.valueOf(paraAnalysisData.get("out_table_day"));
		String field = "TIME,kind,state,out01,out02,out03,out04,out05,out06,out07,out08,out09";

		Map<String, Object> dateFilter = new LinkedHashMap();
		try {
			dateFilter = DateFilter.dateFilter(dateEnd, dateFrist);
		} catch (Exception e2) {
			e2.printStackTrace();
		}
		dateFilter.put("interval", null);
		System.err.println(dateFilter);
		List<Object> dailyData = this.factoryService.getHistoryDatasByDate(dateFilter, out_day_tableName, field);
		System.out.println("dailyData:" + dailyData);

		Map<String, Object> yDataPreHeadler = Tools.yesterdayDataPreHeadler(paraAnalysisData);
		String tableName = (String) yDataPreHeadler.get("tableName");
		String KFFields = (String) yDataPreHeadler.get("KFFields");

		System.err.println("dateStart:" + dateStart);
		String year = dateStart.substring(0, dateStart.indexOf("-"));
		String month = dateStart.substring(dateStart.indexOf("-") + 1, dateStart.lastIndexOf("-"));
		if (month.length() == 1) {
			month = "0" + month;
		}
		System.out.println(year + "," + month);
		Calendar now = Calendar.getInstance();
		int nowyear = now.get(1);
		int nowmonth = now.get(2) + 1;
		System.out.println("当下年月：" + nowyear + "," + nowmonth);
		if ((Integer.valueOf(year).intValue() != nowyear) || (Integer.valueOf(month).intValue() != nowmonth)) {
			tableName = tableName + "_" + year + month;
		}
		System.out.println("查询的表：" + tableName);

		List<Object> yDataList = new ArrayList();
		Map<String, Object> dateFilter2 = new LinkedHashMap();
		try {
			dateFilter2 = DateFilter.dateFilter(dateStart, dateEnd);
		} catch (Exception e2) {
			e2.printStackTrace();
		}
		dateFilter2.put("interval", Integer.valueOf(72));
		System.err.println(dateFilter2);
		try {
			yDataList = this.factoryService.getHistoryDatasByDate(dateFilter2, tableName, KFFields);
		} catch (Exception e) {
			e.printStackTrace();
		}
		System.err.println("yDataList:" + yDataList);
		Map<String, Object> lineNumMap = new HashMap();
		lineNumMap.put("lineNum", paraAnalysisData.get("line_num"));
		String[] split = KFFields.split(",");
		for (int i = 0; i < split.length; i++) {
			lineNumMap.put("para" + i, split[i]);
		}
		yDataList.add(lineNumMap);
		System.out.println("yDataList:" + yDataList);

		Map<String, Object> result = new HashMap();
		String team1 = paraAnalysisData.get("team_01").toString();
		String team2 = paraAnalysisData.get("team_02").toString();
		String team3 = paraAnalysisData.get("team_03").toString();
		result.put("team_01", team1.substring(0, team1.length() - 3));
		result.put("team_02", team2.substring(0, team2.length() - 3));
		result.put("team_03", team3.substring(0, team3.length() - 3));
		result.put("team_num", paraAnalysisData.get("team_num"));
		result.put("dailyData", dailyData);
		result.put("yDataList", yDataList);

		JsonConfig jsonConfig = new JsonConfig();
		jsonConfig.registerJsonValueProcessor(Timestamp.class, new DateJsonValueProcessor("dd日HH:mm:ss"));
		JSONObject jsonObject = JSONObject.fromObject(result, jsonConfig);
		System.out.println(jsonObject);

		return jsonObject;
	}

	@RequestMapping(value = { "/analysisHistory" }, method = {
			org.springframework.web.bind.annotation.RequestMethod.GET })
	@ResponseBody
	public ModelAndView analysisHistory(@RequestParam Integer factoryId) {
		JSONObject jsonObject = new JSONObject();
		jsonObject.put("factoryId", factoryId);
		ModelAndView modelAndView = new ModelAndView();
		modelAndView.addObject("jsonObject", jsonObject);
		modelAndView.setViewName("analysisHistory");
		return modelAndView;
	}

	@RequestMapping(value = { "/analysisHistory" }, method = {
			org.springframework.web.bind.annotation.RequestMethod.POST })
	public void analysisHistoryPost(@RequestBody Analysis analysis, HttpServletResponse response) {
		Integer factoryId = analysis.getFactoryId();
		String dateStart = analysis.getDateStart();
		String dateEnd = analysis.getDateEnd();
		System.err.println(dateStart);
		System.err.println(dateEnd);

		Map<String, Object> paraAnalysisData = this.factoryService.getParaAnalysisData(factoryId);
		System.out.println(paraAnalysisData);
		String tableName = String.valueOf(paraAnalysisData.get("out_table_short"));
		System.err.println(tableName);
		String KFFields = "TIME,out01,out02,out03,out04,out05,out06,out07";

		List<Object> hisDataList = new ArrayList();
		try {
			Map<String, Object> dateFilter = DateFilter.dateFilter(dateStart, dateEnd);
			dateFilter.put("interval", null);
			System.out.println(dateFilter);
			hisDataList = this.factoryService.getHistoryDatasByDate(dateFilter, tableName, KFFields);
		} catch (Exception e) {
			e.printStackTrace();
		}
		System.out.println(hisDataList);

		JSONArray jsonArray = JSONArray.fromObject(hisDataList);
		System.out.println(jsonArray);
		ResponseUtil.write(response, jsonArray);
	}

	@RequestMapping(value = { "/analysisState" }, method = {
			org.springframework.web.bind.annotation.RequestMethod.GET })
	@ResponseBody
	public ModelAndView analysisHistoryGet(@RequestParam Integer factoryId) {
		JSONObject jsonObject = new JSONObject();
		jsonObject.put("factoryId", factoryId);
		ModelAndView modelAndView = new ModelAndView();
		modelAndView.addObject("jsonObject", jsonObject);
		modelAndView.setViewName("analysisState");
		return modelAndView;
	}

	@RequestMapping(value = { "/analysisState" }, method = {
			org.springframework.web.bind.annotation.RequestMethod.POST })
	public void analysisStatePost(@RequestBody Analysis analysis, HttpServletResponse response) {
		Integer factoryId = analysis.getFactoryId();
		String dateStart = analysis.getDateStart();
		String dateEnd = analysis.getDateEnd();

		Map<String, Object> paraAnalysisData = this.factoryService.getParaAnalysisData(factoryId);
		String tableName = String.valueOf(paraAnalysisData.get("in_table")) + "_state";

		String tableName_anaShort = String.valueOf(paraAnalysisData.get("in_table")) + "_ana_short";

		List<Object> NewestStateDates = this.factoryService.getNewestStateData(tableName_anaShort);

		List<Object> hisDataList = new ArrayList();
		try {
			Map<String, Object> dateFilter = DateFilter.dateFilter(dateStart, dateEnd);
			hisDataList = this.factoryService.getAllData(dateFilter, tableName);
		} catch (Exception e) {
			e.printStackTrace();
		}
		List<Factory> factories = this.factoryService.listAllInfoByFactoryId(factoryId);
		Map<String, Object> parameters = new LinkedHashMap();
		for (Factory factory : factories) {
			String systemName = factory.getSystemName();
			Integer modelNum = factory.getModelNum();
			Integer modelId = factory.getModelId();
			if (modelNum.intValue() == 1) {
				Map<String, Object> meta = this.factoryService
						.getParasByModelNameAndId(String.valueOf("tb2_model" + modelNum), modelId);

				List<Object> system = new ArrayList();
				for (Map.Entry<String, Object> entry : meta.entrySet()) {
					if ((((String) entry.getKey()).contains("name"))
							&& (!((String) entry.getKey()).contains("image"))) {
						system.add(entry.getValue());
					}
					parameters.put(systemName, system);
				}
			}
		}
		List<Object> systemData = this.factoryService
				.getNewestStateData(String.valueOf(paraAnalysisData.get("in_table")));

		Object result = new LinkedHashMap();
		((Map) result).put("currentState", NewestStateDates);
		((Map) result).put("hisDataList", hisDataList);
		((Map) result).put("systemData", systemData);
		((Map) result).put("parameters", parameters);
		JSONArray jsonArray = JSONArray.fromObject(result);
		ResponseUtil.write(response, jsonArray);
	}
}
