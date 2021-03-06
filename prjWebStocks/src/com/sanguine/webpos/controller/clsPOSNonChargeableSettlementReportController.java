package com.sanguine.webpos.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletContext;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.jasperreports.engine.JRExporter;
import net.sf.jasperreports.engine.JasperCompileManager;
import net.sf.jasperreports.engine.JasperFillManager;
import net.sf.jasperreports.engine.JasperPrint;
import net.sf.jasperreports.engine.JasperReport;
import net.sf.jasperreports.engine.data.JRBeanCollectionDataSource;
import net.sf.jasperreports.engine.design.JasperDesign;
import net.sf.jasperreports.engine.export.JRPdfExporter;
import net.sf.jasperreports.engine.export.JRPdfExporterParameter;
import net.sf.jasperreports.engine.export.JRXlsExporter;
import net.sf.jasperreports.engine.export.JRXlsExporterParameter;
import net.sf.jasperreports.engine.xml.JRXmlLoader;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

import com.sanguine.controller.clsGlobalFunctions;
import com.sanguine.webpos.bean.clsPOSNonChargableKOTReportBean;
import com.sanguine.webpos.bean.clsWebPOSReportBean;

@Controller
public class clsPOSNonChargeableSettlementReportController {

	@Autowired
	private clsGlobalFunctions objGlobalFunctions;
	@Autowired
	private clsPOSGlobalFunctionsController objPOSGlobalFunctionsController;
	@Autowired
	private ServletContext servletContext;

	Map<String, String> hmPOSData;
	Map<String, String> hmReasonData;

	@RequestMapping(value = "/frmPOSNonChargableSettlementReport", method = RequestMethod.GET)
	public ModelAndView funOpenForm(Map<String, Object> model, HttpServletRequest request) {
		String strClientCode = request.getSession().getAttribute("clientCode").toString();
		String urlHits = "1";
		try {
			urlHits = request.getParameter("saddr").toString();
		} catch (NullPointerException e) {
			urlHits = "1";
		}
		model.put("urlHits", urlHits);
		List poslist = new ArrayList();
		poslist.add("ALL");

		hmPOSData = new HashMap<String, String>();
		JSONArray jArryPosList = objPOSGlobalFunctionsController.funGetAllPOSForMaster(strClientCode);
		for (int i = 0; i < jArryPosList.size(); i++) {
			JSONObject josnObjRet = (JSONObject) jArryPosList.get(i);
			poslist.add(josnObjRet.get("strPosName"));
			hmPOSData.put(josnObjRet.get("strPosName").toString(), josnObjRet.get("strPosCode").toString());
		}
		model.put("posList", poslist);

		List Reasonlist = new ArrayList();
		Reasonlist.add("ALL");
		hmReasonData = new HashMap<String, String>();
		JSONArray jArryReasonList = objPOSGlobalFunctionsController.funGetAllReasonMaster(strClientCode);
		for (int i = 0; i < jArryReasonList.size(); i++) {
			JSONObject josnObjRet = (JSONObject) jArryReasonList.get(i);
			Reasonlist.add(josnObjRet.get("strReasonName"));
			hmReasonData.put(josnObjRet.get("strReasonCode").toString(), josnObjRet.get("strReasonName").toString());
		}
		model.put("ReasonMasterList", Reasonlist);

		if ("2".equalsIgnoreCase(urlHits)) {
			return new ModelAndView("frmPOSNonChargeableSettlementReport_1", "command", new clsWebPOSReportBean());
		} else if ("1".equalsIgnoreCase(urlHits)) {
			return new ModelAndView("frmPOSNonChargeableSettlementReport", "command", new clsWebPOSReportBean());
		} else {
			return null;
		}

	}

	@SuppressWarnings("rawtypes")
	@RequestMapping(value = "/rptNonChargeableSettlementReport", method = RequestMethod.POST)
	private void funReport(@ModelAttribute("command") clsWebPOSReportBean objBean, HttpServletResponse resp, HttpServletRequest req) {
		// objGlobal=new clsGlobalFunctions();
		String clientCode = req.getSession().getAttribute("clientCode").toString();
		String userCode = req.getSession().getAttribute("usercode").toString();
		String companyName = req.getSession().getAttribute("companyName").toString();
		// String posCode=req.getSession().getAttribute("loginPOS").toString();

		try {
			String reportName = servletContext.getRealPath("/WEB-INF/reports/webpos/rptNonChargableKOTReport.jrxml");
			String imagePath = servletContext.getRealPath("/resources/images/company_Logo.png");//

			List<JasperPrint> jprintlist = new ArrayList<JasperPrint>();

			String strFromdate = objBean.getFromDate().split("-")[2] + "-" + objBean.getFromDate().split("-")[1] + "-" + objBean.getFromDate().split("-")[0];

			String strToDate = objBean.getToDate().split("-")[2] + "-" + objBean.getToDate().split("-")[1] + "-" + objBean.getToDate().split("-")[0];

			String type = objBean.getStrDocType();

			String strPOSName = objBean.getStrPOSName();
			String strReasonMaster = objBean.getStrReasonMaster();
			String posCode = "ALL";
			String strReasonCode = "ALL";
			if (!strPOSName.equalsIgnoreCase("ALL")) {
				posCode = hmPOSData.get(strPOSName);
			}
			if (!strReasonMaster.equalsIgnoreCase("ALL")) {
				strReasonCode = hmReasonData.get(strReasonMaster);
			}

			JSONObject jObjFillter = new JSONObject();
			jObjFillter.put("strFromdate", strFromdate);
			jObjFillter.put("strToDate", strToDate);
			jObjFillter.put("posCode", posCode);
			jObjFillter.put("strShiftNo", "1");
			jObjFillter.put("userCode", userCode);
			jObjFillter.put("strReasonCode", strReasonCode);

			// clsPOSNonChargableKOTReportBean
			JSONObject jObj = objGlobalFunctions.funPOSTMethodUrlJosnObjectData("http://localhost:8080/prjSanguineWebService/WebPOSReport/funNCKotReport", jObjFillter);
			List<clsPOSNonChargableKOTReportBean> list = new ArrayList<clsPOSNonChargableKOTReportBean>();
			JSONArray jarr = (JSONArray) jObj.get("jArr");
			for (int i = 0; i < jarr.size(); i++) {
				JSONObject jObjtemp = (JSONObject) jarr.get(i);

				clsPOSNonChargableKOTReportBean objPOSNonChargableKOTReportBean = new clsPOSNonChargableKOTReportBean();

				objPOSNonChargableKOTReportBean.setStrKOTNo(jObjtemp.get("strKOTNo").toString());
				objPOSNonChargableKOTReportBean.setDteNCKOTDate(jObjtemp.get("dteNCKOTDate").toString());
				objPOSNonChargableKOTReportBean.setStrTableNo(jObjtemp.get("strTableNo").toString());
				objPOSNonChargableKOTReportBean.setStrReasonName(jObjtemp.get("strReasonName").toString());
				objPOSNonChargableKOTReportBean.setStrPosName(jObjtemp.get("strPosName").toString());
				objPOSNonChargableKOTReportBean.setStrRemarks(jObjtemp.get("strRemark").toString());
				objPOSNonChargableKOTReportBean.setStrItemCode(jObjtemp.get("strItemCode").toString());
				objPOSNonChargableKOTReportBean.setStrItemName(jObjtemp.get("strItemName").toString());

				objPOSNonChargableKOTReportBean.setDblQuantity(Double.parseDouble(jObjtemp.get("dblQuantity").toString()));
				;
				objPOSNonChargableKOTReportBean.setDblRate(Double.parseDouble(jObjtemp.get("dblRate").toString()));
				;
				objPOSNonChargableKOTReportBean.setDblAmount(Double.parseDouble(jObjtemp.get("Amount").toString()));
				objPOSNonChargableKOTReportBean.setStrTableName(jObjtemp.get("strTableName").toString());

				list.add(objPOSNonChargableKOTReportBean);
			}

			/*
			 * Comparator<clsPOSItemWiseSalesReportBean> itemComparator = new
			 * Comparator<clsPOSItemWiseSalesReportBean>() {
			 * 
			 * @Override public int compare(clsGroupWaiseSalesBean o1,
			 * clsGroupWaiseSalesBean o2) { return
			 * o1.getGroupName().compareToIgnoreCase(o2.getGroupName()); } };
			 * 
			 * Collections.sort(list, new
			 * clsGroupWiseComparator(groupComparator) );
			 */

			HashMap hm = new HashMap();
			hm.put("posCode", posCode);
			hm.put("posName", strPOSName);
			hm.put("imagePath", imagePath);
			hm.put("clientName", companyName);
			hm.put("fromDateToDisplay", strFromdate);
			hm.put("toDateToDisplay", strToDate);
			hm.put("shiftCode", "1");
			hm.put("userName", userCode);

			JasperDesign jd = JRXmlLoader.load(reportName);
			JasperReport jr = JasperCompileManager.compileReport(jd);

			// jp = JasperFillManager.fillReport(jr, hm, new
			// JREmptyDataSource());

			JRBeanCollectionDataSource beanCollectionDataSource = new JRBeanCollectionDataSource(list);
			JasperPrint print = JasperFillManager.fillReport(jr, hm, beanCollectionDataSource);
			jprintlist.add(print);

			if (jprintlist.size() > 0) {
				ServletOutputStream servletOutputStream = resp.getOutputStream();
				if (objBean.getStrDocType().equals("PDF")) {
					JRExporter exporter = new JRPdfExporter();
					resp.setContentType("application/pdf");
					exporter.setParameter(JRPdfExporterParameter.JASPER_PRINT_LIST, jprintlist);
					exporter.setParameter(JRPdfExporterParameter.OUTPUT_STREAM, servletOutputStream);
					exporter.setParameter(JRPdfExporterParameter.IGNORE_PAGE_MARGINS, Boolean.TRUE);
					resp.setHeader("Content-Disposition", "inline;filename=NonChargeableKOTReport_" + strFromdate + "_To_" + strToDate + "_" + userCode + ".pdf");
					exporter.exportReport();
					servletOutputStream.flush();
					servletOutputStream.close();
				} else {
					JRExporter exporter = new JRXlsExporter();
					resp.setContentType("application/xlsx");
					exporter.setParameter(JRXlsExporterParameter.JASPER_PRINT_LIST, jprintlist);
					exporter.setParameter(JRXlsExporterParameter.OUTPUT_STREAM, servletOutputStream);
					exporter.setParameter(JRXlsExporterParameter.IGNORE_PAGE_MARGINS, Boolean.TRUE);
					resp.setHeader("Content-Disposition", "inline;filename=NonChargeableKOTReport_" + strFromdate + "_To_" + strToDate + "_" + userCode + ".xls");
					exporter.exportReport();
					servletOutputStream.flush();
					servletOutputStream.close();
				}
			} else {
				resp.setStatus(HttpServletResponse.SC_NOT_FOUND);
				resp.getWriter().append("No Record Found");

			}
		} catch (Exception ex) {
			ex.printStackTrace();
		}

		System.out.println("Hi");

	}

}
