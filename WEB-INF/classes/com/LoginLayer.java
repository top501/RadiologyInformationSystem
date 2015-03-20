package com;
import java.lang.*;
import java.io.*;
import java.sql.*;


public class LoginLayer {
    private char user_privilege_level;
    private boolean logged_in;
    private boolean failure;
    public String error_printout;

    public LoginLayer()
    {		
	user_privilege_level = '0';
	logged_in = false;
	failure = false;
    }

    public char getPrivs()
    {
	return user_privilege_level;
    }
    
    public boolean isLoggedIn()
    {
	return logged_in;
    }

    public boolean failedWithError()
    {
	return failure;
    }

    public boolean validateLogin(String username, String password)
    {
	/*  Establish connectionn to DB.*/
        Connection conn = null;	
	String driverName = "oracle.jdbc.driver.OracleDriver";
        String dbstring = "jdbc:oracle:thin:@gwynne.cs.ualberta.ca:1521:CRS";
	try{
	    //load and register the driver
	    Class drvClass = Class.forName(driverName); 
	    DriverManager.registerDriver((Driver) drvClass.newInstance());
	}
	catch(Exception ex){
	    error_printout = "<hr>" + ex.getMessage() + "<hr>";
	    failure = true;
	    return false;
	}
	
	try{
	    //establish the connection 
	    conn = DriverManager.getConnection(dbstring,"USERNAME","PASSWORD"); /* Oracle login info here */
	    conn.setAutoCommit(false);
	}
	catch(Exception ex){
	        
	    error_printout = "<hr>" + ex.getMessage() + "<hr>";
	    failure = true;
	    return false;
	}

	Statement stmt = null;
	ResultSet rset = null;
	String select_data = "select password, class from users where user_name =" + "'" + username + "'";

	/* Query the user table to determine if a vaid username/password combination has been entered. */
	try{
	    stmt = conn.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
	    rset = stmt.executeQuery(select_data);
	}	
	catch(Exception ex){
	    error_printout = "<hr>" + ex.getMessage() + "<hr>";
	    failure = true;
	    return false;
	}

	/* Check if password entered is correct. */
	String truepwd = "";
	String user_class = "";
	
	try
	    {
		while(rset != null && rset.next())
		    {
			truepwd = (rset.getString("password")).trim();
			user_class = (rset.getString("class")).trim();
		    }
	    }
	catch(Exception ex)
	    {
		error_printout = "<hr>" + ex.getMessage() + "<hr>";
		failure = true;
		return false;
	    }
	    
	
	/* If valid, log the user in with the appropriate priviliges. */

	if(truepwd.length() > 0 && password.equals(truepwd))
	    {
		logged_in = true;
		user_privilege_level = user_class.charAt(0);
	    }

	try
	    {
		conn.close();
	    }

	catch(Exception ex)
	    {
		error_printout = "<hr>" + ex.getMessage() + "<hr>";
		failure = true;
		return false;
	    }

	return logged_in;
    }
}
