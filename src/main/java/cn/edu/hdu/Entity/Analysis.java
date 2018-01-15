package cn.edu.hdu.Entity;

public class Analysis {
	private Integer factoryId;
	private String dateFrist;
	private String dateStart;
	private String dateEnd;

	public Integer getFactoryId() {
		return factoryId;
	}

	public void setFactoryId(Integer factoryId) {
		this.factoryId = factoryId;
	}

	public String getDateStart() {
		return dateStart;
	}

	public void setDateStart(String dateStart) {
		this.dateStart = dateStart;
	}

	public String getDateEnd() {
		return dateEnd;
	}

	public void setDateEnd(String dateEnd) {
		this.dateEnd = dateEnd;
	}

	public String getDateFrist() {
		return dateFrist;
	}

	public void setDateFrist(String dateFrist) {
		this.dateFrist = dateFrist;
	}

	@Override
	public String toString() {
		return "Analysis [factoryId=" + factoryId + ", dateFrist=" + dateFrist + ", dateStart=" + dateStart
				+ ", dateEnd=" + dateEnd + "]";
	}

}
