package cn.edu.hdu.Entity;

public class Factory {
	private Integer factoryIndex;
	private Integer factoryId;
	private String systemName;
	private String pc_ph;
	private Integer modelNum;
	private Integer modelId;

	public Integer getFactoryIndex() {
		return this.factoryIndex;
	}

	public void setFactoryIndex(Integer factoryIndex) {
		this.factoryIndex = factoryIndex;
	}

	public Integer getFactoryId() {
		return this.factoryId;
	}

	public void setFactoryId(Integer factoryId) {
		this.factoryId = factoryId;
	}

	public String getSystemName() {
		return this.systemName;
	}

	public void setSystemName(String systemName) {
		this.systemName = systemName;
	}

	public String getPc_ph() {
		return this.pc_ph;
	}

	public void setPc_ph(String pc_ph) {
		this.pc_ph = pc_ph;
	}

	public Integer getModelNum() {
		return this.modelNum;
	}

	public void setModelNum(Integer modelNum) {
		this.modelNum = modelNum;
	}

	public Integer getModelId() {
		return this.modelId;
	}

	public void setModelId(Integer modelId) {
		this.modelId = modelId;
	}

	@Override
	public String toString() {
		return "Factory [factoryIndex=" + factoryIndex + ", factoryId=" + factoryId + ", systemName=" + systemName
				+ ", pc_ph=" + pc_ph + ", modelNum=" + modelNum + ", modelId=" + modelId + "]";
	}
	
}
