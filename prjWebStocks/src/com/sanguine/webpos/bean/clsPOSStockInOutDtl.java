package com.sanguine.webpos.bean;

public class clsPOSStockInOutDtl {
	private String strItemName;
	private String strStkInCode;
	private String strStkOutCode;

	public String getStrStkOutCode() {
		return strStkOutCode;
	}

	public void setStrStkOutCode(String strStkOutCode) {
		this.strStkOutCode = strStkOutCode;
	}

	private String strItemCode;
	private double dblQuantity;
	private double dblAmount;
	private double dblPurchaseRate;
	private String strClientCode;
	private String strDataPostFlag;

	public String getStrItemName() {
		return strItemName;
	}

	public void setStrItemName(String strItemName) {
		this.strItemName = strItemName;
	}

	public String getStrStkInCode() {
		return strStkInCode;
	}

	public void setStrStkInCode(String strStkInCode) {
		this.strStkInCode = strStkInCode;
	}

	public String getStrItemCode() {
		return strItemCode;
	}

	public void setStrItemCode(String strItemCode) {
		this.strItemCode = strItemCode;
	}

	public double getDblQuantity() {
		return dblQuantity;
	}

	public void setDblQuantity(double dblQuantity) {
		this.dblQuantity = dblQuantity;
	}

	public double getDblAmount() {
		return dblAmount;
	}

	public void setDblAmount(double dblAmount) {
		this.dblAmount = dblAmount;
	}

	public double getDblPurchaseRate() {
		return dblPurchaseRate;
	}

	public void setDblPurchaseRate(double dblPurchaseRate) {
		this.dblPurchaseRate = dblPurchaseRate;
	}

	public String getStrClientCode() {
		return strClientCode;
	}

	public void setStrClientCode(String strClientCode) {
		this.strClientCode = strClientCode;
	}

	public String getStrDataPostFlag() {
		return strDataPostFlag;
	}

	public void setStrDataPostFlag(String strDataPostFlag) {
		this.strDataPostFlag = strDataPostFlag;
	}
}
