<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="s"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title></title>

 <style type="text/css">
 .cell{
 	background: inherit;
    border: 0 solid #060006;
    font-family: Arial,Helvetica,sans-serif;
    font-size: 11px;
    font-weight: bold;
    outline: 0 none;
    padding-left: 0;
    width: 40px
 }
 
  .header{
 	background: inherit;
    border: 0 solid #060006;
    font-family: Arial,Helvetica,sans-serif;
    font-size: 11px;
    font-weight: bold;
    outline: 0 none;
    padding-left: 0;
    width: 60px
 }
 
 </style>
 
<script type="text/javascript">

	var fDate,tDate;

	$(document).ready(function() {
		var message='';
		<%if (session.getAttribute("success") != null) {
            if(session.getAttribute("successMessage") != null){%>
            message='<%=session.getAttribute("successMessage").toString()%>';
            <%
            	session.removeAttribute("successMessage");
            }
			boolean test = ((Boolean) session.getAttribute("success")).booleanValue();
			session.removeAttribute("success");
			if (test) {
			%>	
			alert(message);
		<%
		}}%>		

		$(document).ajaxStart(function() {
			$("#wait").css("display", "block");
		});
		$(document).ajaxComplete(function() {
			$("#wait").css("display", "none");
		});

		$("#txtFromDate").datepicker({
			dateFormat : 'dd-mm-yy'
		});
		$("#txtFromDate").datepicker('setDate', 'today');

		$("#txtToDate").datepicker({
			dateFormat : 'dd-mm-yy'
		});
		$("#txtToDate").datepicker('setDate', 'today');
		
		$("[type='reset']").click(function(){
			location.reload(true);
		});
		
		$("form").submit(function(event){
			var table = document.getElementById("tblExciseAbstractReport");
			var rowCount = table.rows.length;
			if (rowCount > 2){
				$("#txtFromDate").val(fDate);
				$("#txtToDate").val(tDate);
				return true;
			} else {
				alert("Data Not Available");
				return false;
			}
		});

		$("#btnSubmit").click(function(event) {
			var fromDate = $("#txtFromDate").val();
			var toDate = $("#txtToDate").val();

			if (fromDate.trim() == '' && fromDate.trim().length == 0) {
				alert("Please Enter From Date");
				return false;
			}
			if (toDate.trim() == '' && toDate.trim().length == 0) {
				alert("Please Enter To Date");
				return false;
			}
			if(funDeleteTableAllRows()){
				if(CalculateDateDiff(fromDate,toDate)){
					fDate=fromDate;
					tDate=toDate;
					funFetchColNames();
				}
			}
		});

	});
	
	function funDeleteTableAllRows()
	{
		$('#tblExciseAbstractReport tbody').empty();
		
		var table = document.getElementById("tblExciseAbstractReport");
		var rowCount1 = table.rows.length;
		if(rowCount1==0){
			return true;
		}else{
			return false;
		}
	}
	
	function CalculateDateDiff(fromDate,toDate) {

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
	}

	
	function funFetchColNames() {
		var licenceCode=$("#cmbLicenceCode").val();
		var gurl = getContextPath() + "/loadAbstractReportColumns.html";
		$.ajax({
			type : "GET",
			data:"fromDate="+fDate+"&toDate="+tDate+"&licenceCode="+licenceCode,
			url : gurl,
			dataType : "json",
			success : function(response) {
				if (response.Data == '' || response.Data == undefined) {
					alert("Data Not Found");
				} else {
					
					//Add Sub Category Headers
					funAddHeaderRow(response.Header,response.SubCatCode,response.CatSizeLenght);
					
					//Add Size Names And Headers
					funAddDataRows(response.SizeName);					
					funAddFullUnderLineRows(response.SizeName);
					
					 $.each(response.Data, function(i,item)
					{
						funAddDataRows(response.Data[i]);
					});
					
					 if(response.Total.length>0){
						funAddUnderLine(response.Total);
						funAddDataRows(response.Total);
					}
					 
					 
				}//Else block Of Response
					 
			},
			error : function(jqXHR, exception) {
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
	
	
	
 	function funAddHeaderRow(rowData,catCode,sizeList){
		var table = document.getElementById("tblExciseAbstractReport");
	    var rowCount = table.rows.length;
	    var row = table.insertRow(rowCount);
		    for(var i=0;i<rowData.length;i++){
		    	if(i==0){
		    		row.insertCell(i).innerHTML= "<input type=\"hidden\"readonly=\"readonly\" value='"+rowData[i]+"' />";	
		    	} else if(i==1){
		    		 if(rowData[i].trim()=="`"){
			 	   			row.insertCell(i).innerHTML = "<input type=\"hidden\" readonly=\"readonly\" class=\"header\" name=\"colRow["+(rowCount)+"].strCol"+i+"\"  value='"+rowData[i]+"' />";
			   			 }else{
			 	   			row.insertCell(i).innerHTML = "<input type=\"text\" readonly=\"readonly\" class=\"header\" name=\"colRow["+(rowCount)+"].strCol"+i+"\" value='"+rowData[i]+"' />";
		   			 }		    	
	    		 } else {
		    			row.insertCell(i).innerHTML= "<input type=\"text\" readonly=\"readonly\" class=\"header\" name=\"colRow["+(rowCount)+"].strCol"+i+"\" value='"+rowData[i]+"' />";
		    			var temp=catCode[i].trim();
	    				var colSpan=0;
	    				if(sizeList[temp]>0){
	    					colSpan=sizeList[temp];
    					}
			    		$('#tblExciseAbstractReport tr:eq('+rowCount+') td:eq('+i+')').attr('colspan',colSpan);
		    		}
				}
		} 
	
	
	function funAddDataRows(rowData) 
	{
		var table = document.getElementById("tblExciseAbstractReport");
	    var rowCount = table.rows.length;
	    var row = table.insertRow(rowCount);
	    
	    for(var i=0;i<rowData.length;i++){
	   		 if(i==0){
	   		    	row.insertCell(i).innerHTML= "<input type=\"hidden\" readonly=\"readonly\" value='"+rowData[0]+"' />";
	   		 } else if(i==1){
	   			 if(rowData[i].trim()=="`"){
	 	   			row.insertCell(i).innerHTML = "<input type=\"hidden\" readonly=\"readonly\" class=\"header\" name=\"rowList["+(rowCount)+"].strRow"+i+"\" value='"+rowData[i]+"' />";
	   			 }else{
	 	   			row.insertCell(i).innerHTML = "<input type=\"text\" readonly=\"readonly\" class=\"header\" name=\"rowList["+(rowCount)+"].strRow"+i+"\" value='"+rowData[i]+"' />";
	   			 }
	   		 } else {
	   				row.insertCell(i).innerHTML = "<input type=\"text\" readonly=\"readonly\" class=\"cell\" name=\"rowList["+(rowCount)+"].strRow"+i+"\" value='"+rowData[i]+"' />";
	   		 }
		}
	}
	
	function funAddUnderLine(rowData) 
	{
		var table = document.getElementById("tblExciseAbstractReport");
	    var rowCount = table.rows.length;
	    var row = table.insertRow(rowCount);
	    
	    for(var i=0;i<rowData.length;i++){
	   		 if(i==0){
	   		    	row.insertCell(i).innerHTML= "<input type=\"hidden\" readonly=\"readonly\" value='"+' '+"' />";
	   		 } else if(i==1){
	 	   			row.insertCell(i).innerHTML = "<input type=\"hidden\" readonly=\"readonly\" class=\"cell\" name=\"rowList["+(rowCount)+"].strRow"+i+"\" value='"+'`'+"' />";
	   		 } else {
	   			if(rowData[i].trim() !=""){
		    		row.insertCell(i).innerHTML= "<input type=\"text\" readonly=\"readonly\" class=\"cell\" name=\"rowList["+ (rowCount)+"].strRow"+i+"\" value='"+'----'+"' />";
	    		}else{
		    		row.insertCell(i).innerHTML= "<input type=\"text\" readonly=\"readonly\" class=\"cell\" name=\"rowList["+ (rowCount)+"].strRow"+i+"\" value='"+' '+"' />";
	    		}
	   		 }
		}
	    $('#tblExciseAbstractReport tr:eq('+rowCount+')').hide();
	}
	
	function funAddFullUnderLineRows(rowData) 
	{
		var table = document.getElementById("tblExciseAbstractReport");
	    var rowCount = table.rows.length;
	    var row = table.insertRow(rowCount);
	    
	    for(var i=0;i<rowData.length;i++){
	   		 if(i==0){
	   		    	row.insertCell(i).innerHTML= "<input type=\"hidden\" readonly=\"readonly\" value='"+ +"' />";
	   		 } else {
	   			row.insertCell(i).innerHTML = "<input type=\"text\" readonly=\"readonly\" class=\"cell\" name=\"rowList["+(rowCount)+"].strRow"+i+"\" value='"+'----'+"' />";
	   		 }
		}
	    
	    $('#tblExciseAbstractReport tr:eq('+rowCount+')').hide();
	}
	
	function funSetLicenceNo() {
		var code=$("#cmbLicenceCode").val();

		var gurl=getContextPath()+"/loadExciseLicenceMasterData.html?licenceCode=";
			$.ajax({
		        type: "GET",				        
		        url: gurl+code,
		        dataType: "json",
		        success: function(response)
		        {	
		        	if(response.strLicenceNo=='Invalid Code')
		        	{
		        		alert("Invalid Licence Code Please Select Again");
		        	
		        	}
		        	else
		        	{ 
		        	
		        		if(response.strLicenceNo==null)
		        			{
		        			$("#licenceNo").text('');
		        			}else{
		        		//$("#txtLicenceCode").val(response.strLicenceCode);
		        		$("#licenceNo").text(response.strLicenceNo);
					}}
				},
				error : function(jqXHR, exception) {
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
<body>
	<div id="formHeading">
	<label>Abstract Report</label>
	</div>

<br/>
<br/>

	<s:form name="AbstractReport" method="POST" action="saveAbstractReportData.html?saddr=${urlHits}" target="_blank">
	<div>
	<table class="masterTable">
			<tr>
				<td>
					<label>From Date</label>
				</td>
				<td>
					<s:input type="text" id="txtFromDate" class="calenderTextBox" path="strFromDate" required="required" />
				</td>
				
				<td>
					<label>To Date</label>
				</td>
				<td>
					<s:input type="text" id="txtToDate" class="calenderTextBox" path="strToDate" required="required"/>
				</td>
					<td>
					<label>Licence Number</label>
				</td>
<!-- 				<td> -->
<%-- 					<s:input id="txtLicenceCode" ondblclick="funHelp('LicenceCode')" type="text" path="strLicenceCode" cssClass="searchTextBox" value="${LicenceCode}" /> --%>
<!-- 				</td> -->
				<td ><s:select id="cmbLicenceCode" items="${listLicence}" path="strLicenceCode" cssClass="BoxW124px" onchange="funSetLicenceNo()">
			
					</s:select></td>
					
				<td><s:label id="licenceNo" path="strLicenceNo" >${LicenceNo}</s:label></td>			
			</tr>
		</table>		
		<br />
		<br />
		<div style="width:100%;overflow-x:auto !important ; overflow-y:auto !important;">
			<table id="tblExciseAbstractReport" class="transTablex" style="width:100%; text-align:center !important;">
			</table>
		</div>
		<br />
		<br />
		<p align="center">
			<input type="button" value="Display" class="form_button" id="btnSubmit"/>
			<input type="submit" value="Print" class="form_button" id="submit"/>
			<input type="reset" value="Reset" class="form_button" id="btnReset"/>
			
		</p>
		</div>
		<div id="wait"
			style="display: none; width: 60px; height: 60px; border: 0px solid black; position: absolute; top: 60%; left: 55%; padding: 2px;">
			<img
				src="../${pageContext.request.contextPath}/resources/images/ajax-loader-light.gif"
				width="60px" height="60px" />
		</div>

	</s:form>
</body>
</html>
