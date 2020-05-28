package postgres;

import java.io.IOException;
import java.sql.*;
import java.util.Properties;

public class App {
	
	public Connection connect() {
		Connection conn = null;
		Properties prop = new Properties();
		String url;
		String user;
		String pass;
		
		try {
			prop.load(new java.io.FileInputStream(System.getProperty("user.home") + "/config.cfg"));
			url = prop.getProperty("url").toString();
			user = prop.getProperty("user").toString();
			pass = prop.getProperty("password").toString();
			Class.forName("org.postgresql.Driver");
			conn = DriverManager.getConnection(url, user, pass);
			
			//System.out.println("Success");
		} catch (SQLException | ClassNotFoundException | IOException e) {
			e.printStackTrace();
			System.err.println(e.getClass().getName()+": "+e.getMessage());
		}
		
		return conn;
	}
	
	public void getTable(String name) {
		String query = "SELECT * FROM " + name;
		try (Connection conn = this.connect()) {
			
			PreparedStatement pstmt = conn.prepareStatement(query);
			ResultSet res = pstmt.executeQuery();
			ResultSetMetaData rsmd = res.getMetaData();
			int colsNum = rsmd.getColumnCount();
			
			for (int i = 1; i <= colsNum; i ++) {
				System.out.print(padRight(25, rsmd.getColumnName(i)));
			}
			System.out.println();
			
			while (res.next()) {
				for (int i = 1; i <= colsNum; i++) {
					System.out.print(padRight(25, res.getString(i).trim()));
				}
				System.out.println();
			}
			
		} catch (SQLException e) {
			System.out.println(e.getMessage());
		}
	}
	
	public static String padRight(int n, String s) {
	     return String.format("%-" + n + "s", s);  
	}
	
	public static void main(String[] args) {
		App postgresql = new App();
		postgresql.getTable("books");
	}
}
