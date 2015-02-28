<%@ page language="java" import="java.sql.*"%>
<%@ page import="pageNumber.*, java.util.*, java.io.*" %>

<%@ page import="org.json.simple.JSONObject" %>
<%@ page import="org.json.simple.JSONArray" %>

<%
		final String DB_CONNECTIONSTRING = "jdbc:postgresql://localhost/pacsdatabase";
		final String DB_USERNAME = "postgres";
		final String DB_PASSWORD = "1";

		String studyUID;
		String seriesUID;
		String objectUID;

		String szStudyId = request.getParameter("study_id");

		Connection conn;
		ResultSet rsStudy;
		ResultSet rsSeries;
		ResultSet rsObject;
		String szQuery;
		String szQueryWhere;
		Statement st;


		szQuery = "SELECT study.pk as study_pk, study.study_iuid as studyUID FROM study";
		szQueryWhere = "";
		if (szStudyId != null && szStudyId.length() > 0){
			szQueryWhere = szQueryWhere + "study.pk = '" + szStudyId + "'";
		}
		if (szQueryWhere.length() > 0){
			szQuery = szQuery + " where " + szQueryWhere;
		}

		conn = DriverManager.getConnection(DB_CONNECTIONSTRING, DB_USERNAME, DB_PASSWORD);
		st = conn.createStatement();
		rsStudy = st.executeQuery(szQuery);

		while(rsStudy.next())
		{
			JSONArray arrResult = new JSONArray();

			String studyPk = rsStudy.getString("study_pk");
			studyUID = rsStudy.getString("studyUID");

	//		out.println(studyPk);
	//		out.println(studyUID);
			
	
			szQuery = "SELECT series.pk as series_pk, series.series_iuid as seriesUID FROM series";
			szQueryWhere = "";		
			if (studyPk != null && studyPk.length() > 0){
				szQueryWhere = szQueryWhere + "series.study_fk = '" + studyPk + "'";
			}
			if (szQueryWhere.length() > 0){
				szQuery = szQuery + " where " + szQueryWhere;
			}
//			out.println(szQuery);

			st = conn.createStatement();
			rsSeries = st.executeQuery(szQuery);

			
			while(rsSeries.next())
			{
				String seriesPk = rsSeries.getString("series_pk");
				seriesUID = rsSeries.getString("seriesUID");

//				out.println(seriesPk);
//				out.println(seriesUID);
			
			
				szQuery = "SELECT instance.pk as instance_pk, instance.sop_iuid as ObjectUID FROM instance";
				szQueryWhere = "";		
				if (seriesPk != null && seriesPk.length() > 0){
					szQueryWhere = szQueryWhere + "instance.series_fk = '" + seriesPk + "'";
				}
				if (szQueryWhere.length() > 0){
					szQuery = szQuery + " where " + szQueryWhere;
				}
//				out.println(szQuery);

				st = conn.createStatement();
				rsObject = st.executeQuery(szQuery);

				while(rsObject.next())
				{
					objectUID = rsObject.getString("ObjectUID");

	//				out.println(objectUID);

					JSONObject item = new JSONObject();

					try{
						item.put("studyUID", studyUID);
						item.put("seriesUID", seriesUID);
						item.put("objectUID", objectUID);
					}
					catch (Exception exception){
					}

					arrResult.add(item);		

				}

			}   

			response.setContentType("application/json");
			response.getWriter().write(arrResult.toString());
			conn.close();
		}

		
		//out.println(arrResult.count());
%>

<%!
	/*public byte[] createPasswordHash(String password)
	{
		try
		{
			final MessageDigest digest = MessageDigest.getInstance("SHA");
			byte[] hashBytes = digest.digest((password).getBytes("UTF-8"));
			return hashBytes;
		} catch ( NoSuchAlgorithmException ex ) {
			return new byte[0];
		} catch ( UnsupportedEncodingException ex ) {
			return new byte[0];
		}
	}*/
%>