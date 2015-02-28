<%@ page language="java" import="java.sql.*"%>
<%@ page language="java" import="java.security.MessageDigest"%>
<%@ page language="java" import="java.security.NoSuchAlgorithmException"%>
<%@ page import="pageNumber.*, java.util.*, java.io.*" %>
<%@ page import="org.apache.commons.codec.binary.Base64" %>

<%
	
		String	username = request.getParameter("username");
		String	password = request.getParameter("password");
		
		/*MessageDigest digest = MessageDigest.getInstance("SHA");
		byte[] hashBytes = digest.digest((password).getBytes("UTF-8"));
		
		//String	encryptedPassword = Base64.byteArrayToBase64(hashBytes);
		
		byte[] buf = new byte[] { 0x12, 0x23 };
		String s = new sun.misc.BASE64Encoder().encode(buf);
		
		out.println(s);
		out.println(hashBytes);
		//out.println(encryptedPassword);*/
		/*
		byte[] encoded = Base64.encodeBase64(password.getBytes());
		out.println(encoded);
		
		out.println(username);
		*/

		MessageDigest digest = MessageDigest.getInstance("SHA");
        byte[] hashBytes = digest.digest((password).getBytes("UTF-8"));
		String hashedPasswd = new String(Base64.encodeBase64(hashBytes));
		// out.println("Encrypted Password: " + hashedPasswd + "<br/><br/><br/>");

		String url = "jdbc:postgresql://localhost/pacsdatabase";
		Connection con;
		ResultSet rs;
		String s, szUsername, szPassword;
		// String sqlstr = "SELECT * FROM users WHERE user_id='" + username + "'";
		String sqlstr = "SELECT * FROM users";

		try 
		{
			Class.forName("org.postgresql.Driver");
		} 
		catch(java.lang.ClassNotFoundException e) 
		{
			System.err.print("ClassNotFoundException: ");
			System.err.println(e.getMessage());
		}

		try
		{
			con = DriverManager.getConnection(url,"postgres", "1");

			Statement st = con.createStatement();
			rs = st.executeQuery(sqlstr);
			int nSuccess = 0;
			while(rs.next())
			{
				szUsername = rs.getString(1);
				szPassword = rs.getString(2);
				// out.println("User: " + szUsername + "<br/>Password: " + szPassword + "<br/>");
				if (szPassword.equals(hashedPasswd) == true && szUsername.equals(username) == true){
					// out.println("Correct <br/><br/>");
					nSuccess++;
				}
				else{
					// out.println("Incorrect <br/><br/>");
				}
			}
			if (nSuccess == 1){
				out.print("1");
			}
			else{
				out.print("0");
			}
			
  			rs.close();
			st.close();
			con.close();
		} 
		catch(SQLException ex) 
		{
			System.err.println("SQLException: " + ex.getMessage());
		}

		/*
		out.println(hashedPasswd);
		out.println(username);
		out.println(password);

		String url = "jdbc:postgresql://localhost/pacsdatabase";
		Connection con;
		ResultSet rs;
		String s, szUsername, szPassword;
		//String sqlstr = "SELECT * FROM users WHERE `username`=" + username + " AND `password`=" + ;
		String sqlstr = "SELECT * FROM users";

		try 
		{
			Class.forName("org.postgresql.Driver");
		} 
		catch(java.lang.ClassNotFoundException e) 
		{
			System.err.print("ClassNotFoundException: ");
			System.err.println(e.getMessage());
		}

		try
		{
			con = DriverManager.getConnection(url,"postgres", "1");

			Statement st = con.createStatement();
			rs = st.executeQuery(sqlstr);

			System.out.println("Rows are :");
			while(rs.next())
			{
				szUsername = rs.getString(1);
				szPassword = rs.getString(2);
				out.println(szUsername);
				out.println(szPassword);
			}
			
  			rs.close();
			st.close();
			con.close();
		} 
		catch(SQLException ex) 
		{
			System.err.println("SQLException: " + ex.getMessage());
		}
		*/
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