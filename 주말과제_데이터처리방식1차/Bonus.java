package assignment;

import java.sql.*;


public class Bonus  {
	public static void main (String[] args) throws SQLException {

		// Oracle JDBC 드라이버 로드
		Connection conn = JDBCconn.connectDB();
		Statement stmt = conn.createStatement();
		ResultSet rs = stmt.executeQuery("SELECT * FROM bonus");
		
		while (rs.next()) {
		    String empno = rs.getString("empno");
		    String ename = rs.getString("ename");
		    String job = rs.getString("job");
		    String mgr = rs.getString("mgr");
		    String hiredate = rs.getString("hiredate");
		    String sal = rs.getString("sal");
		    String comm = rs.getString("comm");
		    String deptno = rs.getString("deptno");
		    String bonus = rs.getString("bonus");

		    System.out.println(empno + ", " + ename + ", " + job + ", " + mgr + ", " + hiredate + ", " + sal + ", " + comm + ", " + deptno + ", " + bonus);
		}

		rs.close();
		stmt.close();

		
		if (conn != null) {
			System.out.println("DBMS와 연결되었습니다.");
		} else {
			System.out.println("DBMS와 연결되지 않았습니다.");
		}

	}

}
