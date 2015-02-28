<%@ page language="java" import="java.sql.*"%>
<%@ page import="pageNumber.*, java.util.*, java.io.*" %>
<%@ page import="java.text.*" %>

<%@ page import="org.json.simple.JSONObject" %>
<%@ page import="org.json.simple.JSONArray" %>

<%
		final String DB_CONNECTIONSTRING = "jdbc:postgresql://localhost/pacsdatabase";
		final String DB_USERNAME = "postgres";
		final String DB_PASSWORD = "1";

		String szPatientId = request.getParameter("patient_id");
		String szPatientName = request.getParameter("patient_name");
		String szDateFrom = request.getParameter("date_from");
		String szDateTo = request.getParameter("date_to");
		String szDateType  = request.getParameter("date_type");
		String szModality = request.getParameter("modality");
	//	string szPatientPk = request.getParameter("patient_pk");
/*
		java.util.Date date = new java.util.Date();
		SimpleDateFormat df = new SimpleDateFormat("YYYY-MM-dd");
		String todayDate = df.format(date);
		out.println(todayDate);
	
		Calendar cal = Calendar.getInstance();
		cal.setTime (date);
		cal.add (Calendar.DATE, 1);
		java.util.Date tomorrowDate = cal.getTime();
		
		String strTomorrowDate = df.format(tomorrowDate);
		out.println(strTomorrowDate);
*/
		

	if (szDateType != null){
		if (szDateType.equals("Today")){

			java.util.Date date = new java.util.Date();
			SimpleDateFormat df = new SimpleDateFormat("YYYY-MM-dd");
			String todayDate = df.format(date);
	//		out.println(todayDate);
			szDateFrom = todayDate;
 
			Calendar cal = Calendar.getInstance();
			cal.setTime (date);
			cal.add (Calendar.DATE, 1);
			java.util.Date tomorrowDate = cal.getTime();
		
			String strTomorrowDate = df.format(tomorrowDate);
			szDateTo = strTomorrowDate;
	//		out.println(strTomorrowDate);


		}else if (szDateType.equals("This Week")){
			
			java.util.Date date = new java.util.Date();
			SimpleDateFormat df = new SimpleDateFormat("YYYY-MM-dd");
			String strTodayDate = df.format(date);
			szDateTo = strTodayDate;
	//		out.println(szDateTo);

			Calendar now = Calendar.getInstance();
			int weekOfDay = now.get(Calendar.DAY_OF_WEEK) - 1;
			now.add (Calendar.DATE, -weekOfDay);
			java.util.Date sundayDate = now.getTime();
			String strSundayDate = df.format(sundayDate);
			szDateFrom = strSundayDate;
	//		out.println(szDateFrom);

		}else if (szDateType.equals("This Month")){
			
			java.util.Date date = new java.util.Date();
			SimpleDateFormat df = new SimpleDateFormat("YYYY-MM-dd");
			String strTodayDate = df.format(date);
			szDateTo = strTodayDate;
	//		out.println(szDateTo);

			Calendar now = Calendar.getInstance();
			int dayOfMonth = now.get(Calendar.DAY_OF_MONTH);
			now.add (Calendar.DATE, -dayOfMonth);
			java.util.Date aMonthAgoDate = now.getTime();
			String straMonthAgoDate = df.format(aMonthAgoDate);
			szDateFrom = straMonthAgoDate;
	//		out.println(szDateFrom);

		}//else if (szDateType.equals("This Year")){
			
		//	java.util.Date date = new java.util.Date();
		//	SimpleDateFormat df = new SimpleDateFormat("YYYY-MM-dd");
		//	String strTodayDate = df.format(date);
		//	szDateTo = strTodayDate;
	//		out.println(szDateTo);

		//	Calendar now = Calendar.getInstance();
		//	int weekOfDay = now.get(Calendar.DAY_OF_WEEK) - 1;
		//	now.add (Calendar.DATE, -weekOfDay);
		//	java.util.Date sundayDate = now.getTime();
		//	String strSundayDate = df.format(sundayDate);
		//	szDateFrom = strSundayDate;
	//		out.println(szDateFrom);

		//}
		
		else if (szDateType.equals("Custom")){

	//		out.println(szDateFrom);
	//		out.println(szDateTo);

		}else if (szDateType == "Any Date"){

	//		out.println(szDateFrom);
	//		out.println(szDateTo);

		}else{
		
		}
	}


		Connection conn;
		ResultSet rs;
		String szQuery = "SELECT patient.pk as patient_pk, patient.pat_id as patient_id, patient.pat_name as patient_name, study.pk as study_pk, study.mods_in_study as study_mods, study.study_datetime as study_datetime FROM patient, study";

		String szQueryWhere = "";

		if (szPatientId != null && szPatientId.length() > 0){
			szQueryWhere = szQueryWhere + "patient.pat_id = '" + szPatientId + "' and ";
		}
		if (szPatientName != null && szPatientName.length() > 0){
			szQueryWhere = szQueryWhere + "patient.pat_name like '%" + szPatientName + "%' and ";
		}
		if (szModality != null && szModality.length() > 0){
			szQueryWhere = szQueryWhere + "study.mods_in_study = '" + szModality + "' and ";
		}
		if (szDateFrom != null && szDateFrom.length() > 0){
			szQueryWhere = szQueryWhere + "study.study_datetime >= '" + szDateFrom + "' and ";
		}
		if (szDateTo != null && szDateTo.length() > 0){
			szQueryWhere = szQueryWhere + "study.study_datetime <= '" + szDateTo + "' and ";
		}
		
		szQueryWhere = szQueryWhere + "study.patient_fk = patient.pk and ";
		if (szQueryWhere.length() > 0){
			szQueryWhere = " where " + szQueryWhere.substring(0, szQueryWhere.length() - 5);
		}
		szQuery = szQuery + szQueryWhere;


		conn = DriverManager.getConnection(DB_CONNECTIONSTRING, DB_USERNAME, DB_PASSWORD);

		Statement st = conn.createStatement();
		rs = st.executeQuery(szQuery);

		String szPk = "";
		JSONArray arrResult = new JSONArray();
		while(rs.next())
		{
			szPk = rs.getString("patient_pk");
			JSONObject item = new JSONObject();

			try{
				item.put("patient_pk", rs.getString("patient_pk"));
				item.put("patient_id", rs.getString("patient_id"));
				item.put("patient_name", rs.getString("patient_name"));
				item.put("study_pk", rs.getString("study_pk"));
				item.put("study_mods", rs.getString("study_mods"));
				item.put("study_datetime", rs.getString("study_datetime"));
			}
			catch (Exception exception){
			}
			arrResult.add(item);
		}

		response.setContentType("application/json");
		response.getWriter().write(arrResult.toString());

%>
