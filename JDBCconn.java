package assignment;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class JDBCconn {
	public static Connection connectDB() {

        // 1. Oracle JDBC 드라이버를 로드합니다.
        Connection conn = null;

        // 2. 데이터베이스에 연결합니다.
        try {
            Class.forName("oracle.jdbc.driver.OracleDriver"); // 로딩하는 코드. 오라클의 JDBC 드라이버 이름 (JDBC
                                                              // 드라이버는 ojdbc11.jar)
            String url = "jdbc:oracle:thin:@192.168.119.119:1521:dink16"; // DBMS 연결을 위한 식별 값,jdbc:oracle:thin:@HOST:PORT:NAME
            String user = "C##scott";
            String passwd = "tiger";
            conn = DriverManager.getConnection(url, user, passwd); // DriverManager를 이용해서 Connection 생성
            return conn;

        } catch (ClassNotFoundException e) {
            // 드라이버 로드 중 예외가 발생한 경우 처리합니다.
            e.printStackTrace();
        } catch (SQLException e) {
            // 데이터베이스 연결 및 쿼리 실행 중 예외가 발생한 경우 처리합니다.
            e.printStackTrace();
        }
        return conn;
    }

}