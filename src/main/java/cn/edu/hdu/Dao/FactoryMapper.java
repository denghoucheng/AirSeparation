package cn.edu.hdu.Dao;

import cn.edu.hdu.Entity.Factory;
import java.util.List;
import java.util.Map;
import org.apache.ibatis.annotations.Param;

public interface FactoryMapper{
	
  public abstract List<Factory> listAllInfoByFactoryId(Integer paramInteger);
  
  public abstract int getAlarmIdByFactoryId(Integer paramInteger);
  
  public abstract List<String> listAllSystemNameByFactoryId(Integer paramInteger);
  
  public abstract Map<String, Object> getData(@Param("KFTable") String paramString1, @Param("SqlFields") String paramString2);
  
  public abstract Map<String, Object> getAlarmInfoByAlarmId(Integer paramInteger);
  
  public abstract Map<String, Object> getAlarmData(@Param("AlarmTable") String paramString);
  
  public abstract Map<String, Object> getParasByModelNameAndId(Map<String, Object> paramMap);
  
  public abstract int getParaNum(Map<String, Object> paramMap);
  
  public abstract Map<String, Object> getParaValues(Map<String, Object> paramMap);
  
  public abstract List<Object> getHistoryDatasByDate(Map<String, Object> paramMap);
  
  public abstract List<Object> getHistoryDatasByDate2(Map<String, Object> paramMap);
  
  public abstract void insertData();
  
  public abstract Map<String, Object> getParaAnalysisData(Integer factoryId);
  
  public abstract Map<String, Object> getDailyData(Map<String, Object> paramMap);
  
}
