package cn.edu.hdu.Service;

import cn.edu.hdu.Entity.Factory;
import java.util.List;
import java.util.Map;

public abstract interface FactoryService {
	
	public abstract List<Factory> listAllInfoByFactoryId(Integer paramInteger);

	public abstract int getAlarmIdByFactoryId(Integer paramInteger);

	public abstract List<String> listAllSystemNameByFactoryId(Integer paramInteger);

	public abstract Map<String, Object> getData(String paramString1, String paramString2);

	public abstract Map<String, Object> getAlarmInfoByAlarmId(Integer paramInteger);

	public abstract Map<String, Object> getAlarmData(String paramString);

	public abstract Map<String, Object> getParasByModelNameAndId(String paramString, Integer paramInteger);

	public abstract int getParaNum(String paramString, Integer paramInteger);

	public abstract Map<String, Object> getParaValues(String paramString1, Integer paramInteger, String paramString2);

	public abstract List<Object> getHistoryDatasByDate(Map<String, Object> paramMap, String paramString1,
			String paramString2);
	
	public abstract List<Object> getHistoryDatasByDate2(Map<String, Object> paramMap, String paramString1,
			String paramString2,String yearmonth);

	public abstract void insertData();
	
	public abstract Map<String, Object> getParaAnalysisData(Integer factoryId);
	
	public abstract Map<String, Object> getDailyData(Integer teamNum,String tableName);
	
}
