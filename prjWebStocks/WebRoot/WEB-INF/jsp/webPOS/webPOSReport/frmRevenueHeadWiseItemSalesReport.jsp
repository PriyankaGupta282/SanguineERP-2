<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="s"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>


<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>GROUP MASTER</title>
<style>
.ui-autocomplete {
    max-height: 200px;
    overflow-y: auto;
    /* prevent horizontal scrollbar */
    overflow-x: hidden;
    /* add padding to account for vertical scrollbar */
    padding-right: 20px;
}
/* IE 6 doesn't support max-height
 * we use height instead, but this forces the menu to always be this tall
 */
* html .ui-autocomplete {
    height: 200px;
}
</style>
<script type="text/javascript">

/*On form Load It Reset form :Ritesh 22 Nov 2014*/
 $(function() 
    			{		
    				$("#txtFromDate").datepicker({ dateFormat: 'dd-mm-yy' });
    				$("#txtFromDate" ).datepicker('setDate', 'today');
    				$("#txtToDate").datepicker({ dateFormat: 'dd-mm-yy' });
    				$("#txtToDate" ).datepicker('setDate', 'today');
    				
    			}); 

 $("form").submit(function(event){
	 var fromDate = $("#txtFromDate").val();
		var toDate = $("#txtToDate").val();

	 var frmDate= fromDate.split('-');
	    var fDate = new Date(frmDate[2],frmDate[1],frmDate[0]);
	    
	    var tDate= toDate.split('-');
	    var t1Date = new Date(tDate[2],tDate[1],tDate[0]);

 	var dateDiff=t1Date-fDate;
		 if (dateDiff >= 0 ) 
		 {
      	return true;
      }else{
     	 alert("Please Check From Date And To Date");
     	 return false
      }
	});
	/**
	* Reset The Group Name TextField
	**/
	function funSetDate()
	{
		
		var searchurl=getContextPath()+"/getPOSDate.html";
		 $.ajax({
			        type: "GET",
			        url: searchurl,
			        dataType: "json",
			        success: function(response)
			        {
			        	/* var dateTime=response.POSDate;
			        	var date=dateTime.split(" ");
			        	$("#txtFromDate").val(date[0]);
			        	$("#txtToDate").val(date[0]); */
			        	
			        	var date = new Date(response.POSDate);
			        var	dateTime=date.getDate()  + '-' + (date.getMonth() + 1)+ '-' +  date.getFullYear();
			        var posDate=dateTime.split(" ");
			        $("#txtFromDate").val(posDate[0]);
		        	$("#txtToDate").val(posDate[0]);
		        	
			        },
			        error: function(jqXHR, exception)
			        {
			            if (jqXHR.status === 0) {
			                alert('Not connect.n Verify Network.');
			            } else if (jqXHR.status == 404) {
			                alert('Requested page not found. [404]');
			            } else if (jqXHR.status == 500) {
			                alert('Internal Server Error [500].');
			            } else if (exception === 'parsererror') {
			                alert('Requested JSON parse failed.');
			            } else if (exception === 'timeout') {
			                alert('Time out error.');
			            } else if (exception === 'abort') {
			                alert('Ajax request aborted.');
			            } else {
			                alert('Uncaught Error.n' + jqXHR.responseText);
			            }		            
			        }
		 });
		 
	}
	
</script>


</head>

<body onload="funSetDate()">
	<div id="formHeading">
		<label>Revenue Head Wise Sales Report</label>
	</div>
	<s:form name="POSRevenueHeadWiseItemSalesReportForm" method="POST" action="rptPOSRevenueHeadWiseItemSalesReport.html?saddr=${urlHits}" target="_blank">

		<br />
		<br />
		<table class="masterTable">

			<tr>
				<td width="140px">POS Name</td>
				<td colspan="3"><s:select id="cmbPOSName" name="cmbPOSName" path="strPOSName" cssClass="BoxW124px" items="${posList}" >
					
				 </s:select></td>
			</tr>
			<tr>
				<td><label>From Date</label></td>
				<td><s:input id="txtFromDate" required="required" path="fromDate" pattern="\d{1,2}-\d{1,2}-\d{4}" cssClass="calenderTextBox"/></td>
			</tr>
			<tr>
				<td><label>To Date</label></td>
				<td><s:input id="txtToDate" required="required" path="toDate" pattern="\d{1,2}-\d{1,2}-\d{4}" cssClass="calenderTextBox"/></td>
			
			</tr>
			<tr>
			<td><label>Report Type</label></td>
					<td >
						<s:select id="cmbDocType" path="strDocType" cssClass="BoxW124px">
				    		<s:option value="PDF">PDF</s:option>
				    		<s:option value="XLS">EXCEL</s:option>
				    		
				    	</s:select>
					</td>
			</tr>
			
			<tr>
			<td><label>Revenue Head</label></td>
					<td >
						<s:select id="cmbRevenueHead" name="cmbRevenueHead" path="strRevenueHead" cssClass="BoxW124px" items="${revenueHeadList}">
				    		
				    	</s:select>
					</td>
			</tr>
			
			<tr>
			<td><label>Report Type</label></td>
					<td >
						<s:select id="cmbReportType" path="strReportType" cssClass="BoxW124px">
				    		<s:option value="Summary">Summary</s:option>
				    		<s:option value="Details">Details</s:option>
				    		
				    	</s:select>
					</td>
			</tr>
			
		</table>
		<br />
		<br />
		<p align="center">
			<input type="submit" value="Submit" tabindex="3" class="form_button"/> 
			<input type="reset" value="Reset" class="form_button" onclick="funResetFields()"/>
		</p>
	</s:form>

</body>
</html>