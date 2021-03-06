<!DOCTYPE html>

<%@ include file="includes.jsp" %>

<%@ include file="navbar.jsp" %>

<html>
  <%@ page import="com.ReportModule" %>
  <% 
     boolean valid_date_format = true;
     boolean success = false;

	 String start_date = "yyyy/mm/dd";
	 String end_date = "yyyy/mm/dd";
	 String diagnosis = "diagnosis";

     ReportModule report = new ReportModule();		

     if(request.getParameter("Submit") != null)
     	{

     		/* Check the users privilege level. For this module, the user must be a system administrator. */
     		Character privilege = (Character) session.getAttribute("privileges");

     		/* Retrieve the user input from the report module page. */

     		diagnosis = (request.getParameter("DIAGNOSIS")).trim();
     		start_date = (request.getParameter("STARTDATE")).trim();
     		end_date = (request.getParameter("ENDDATE")).trim();
	
     		/* Ensure that the date input precisely matches the format YYYY/MM/DD
     		before executing the query. */

     		if(!start_date.matches("^[0-9]{4}/[0-9]{2}/[0-9]{2}$"))
     			{
     				valid_date_format = false;
     			}
     		if(!end_date.matches("^[0-9]{4}/[0-9]{2}/[0-9]{2}$"))
     			{
     				valid_date_format = false;
     			}

     		/* If the dates have a valid format, execute the query. */

     		if(valid_date_format)
     			{
     				String s_start_date = start_date.replace("/", "");
     				String s_end_date = end_date.replace("/", "");
				try {
     					report.generateReport(diagnosis, s_start_date, s_end_date);
					success = true;
				    }
				catch(Exception ex)
				    {
					/* Redirect to error page */
				    }     				
     			}
     	}
     %>
  <HEAD>
    <TITLE>Report Module</TITLE>
		<style>
		table, td {
    	border: 2px solid black;
    	border-collapse: collapse;
		}
		td {
    	padding: 15px;
		}
		</style>
  </HEAD>


<!-- An alert is presented if the date format is incorrect. -->
<% if(!valid_date_format) { %>
  <BODY onload = "badDateAlert()">
<% } else { %>
  <BODY>
<% } %>

    <!--This is the report module page-->

    <H1>Radiology Information System</H1>

    <% 
       if((Character) session.getAttribute("privileges") != 'a') 
       		{
    %>
	<H2>This page requires system administrator privileges.</H2>
    <%
       		}
       		else
			{ 
	%>

    <FORM NAME="ReportForm" ACTION="reportGen.jsp" METHOD="post" >

      <P>Patients with Diagnosis:</P>
      <INPUT TYPE="text" NAME="DIAGNOSIS" placeholder="diagnosis" size="25">
      <br>
      <P>Tested Between Dates:</P>
      <INPUT TYPE="text" NAME="STARTDATE" placeholder="yyyy/mm/dd" size="10">

      <P>and</P>
      <INPUT TYPE="text" NAME="ENDDATE" placeholder="yyyy/mm/dd" size="10">

      <br>
      <INPUT TYPE="submit" NAME="Submit" VALUE="Generate Report">

    </FORM>

	<br>

    <% } %>

    <% if(success && report.found) { %>

<P>Records found matching "<% out.println(diagnosis); %>" between <% out.println(start_date); %> and <% out.println(end_date); %>:</P>

<table>
	<tr>
		<td>Name</td>
		<td>Address</td>
		<td>Phone Number</td>
		<td>Date Tested</td>
	</tr>

	<tr>
		<td><% out.println(report.first_name + " " + report.last_name); %></td>
		<td><% out.println(report.address); %></td>
		<td><% out.println(report.phone); %></td>
		<td><% out.println(report.test_date); %></td>
	</tr>
</table>

	<%   } else if(success && !report.found) { %>

<P>No records with the given diagnosis were found in this time period.</P>

	<% } %>

  </BODY>

<script>
	function badDateAlert()
		{
			alert("Please use the format yyyy/mm/dd (including forward slashes) when entering dates.");
		}
</script>
</HTML>
