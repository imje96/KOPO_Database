package assignment;

import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class BonusCal {
//	private static final String PRESIDENT = "PRESIDENT";
//	private static final String ANALYST = "ANALYST";

	public static void main(String[] args) throws SQLException {
		Connection conn = null;
		try {
			conn = JDBCconn.connectDB();
			// 처리 시작 시간 측정
			double startTime = System.currentTimeMillis();
			calculateBonus(conn);
			// 처리 종료 시간 측정
			double endTime = System.currentTimeMillis();

			// 처리 시간 출력 (처리 종료 시간 - 처리 시작 시간)
			double elapsedTime = (endTime - startTime) / 1000.0;
			System.out.println("처리에 걸린 시간: " + elapsedTime + "초");
		} finally {
			if (conn != null) {
				try {
					conn.close();
				} catch (SQLException e) {
					e.printStackTrace();
				}
			}
		}
	}

	public static void calculateBonus(Connection conn) {
		// EMP 테이블에서 EMPNO, ENAME, JOB, SAL, COMM 컬럼 가져오기
//		ResultSet rs1 = stmt.executeQuery("SELECT ENAME, EMPNO, JOB, SAL, COMM FROM EMP");
		String empSql = "SELECT ENAME, EMPNO, JOB, SAL, COMM FROM EMP";
		List<Map<String, Object>> empInfoList = new ArrayList<>();
		try (Statement stmt = conn.createStatement(); ResultSet rs = stmt.executeQuery(empSql)) {
			while (rs.next()) {
				Map<String, Object> empInfo = new HashMap<>();
				empInfo.put("empno", rs.getInt("empno"));
				empInfo.put("job", rs.getString("job"));
				empInfo.put("comm", rs.getDouble("comm"));
				empInfoList.add(empInfo);
			}
		} catch (SQLException e) {
			e.printStackTrace();
			return;
		}

		System.out.println(empInfoList);

		// CUSTOMER 테이블에서 필요한 컬럼만 가져오기
		String customerSql = "SELECT MGR_EMPNO, COUNT(*) AS CNT FROM CUSTOMER GROUP BY MGR_EMPNO";
		Map<Integer, Integer> accountMgrMap = new HashMap<>();
		try (Statement stmt = conn.createStatement(); 
				ResultSet rs = stmt.executeQuery(customerSql)) {
			while (rs.next()) {
				int m_empno = rs.getInt("MGR_EMPNO");
				int cnt = rs.getInt("CNT");
				accountMgrMap.put(m_empno, cnt);
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}

		System.out.println(accountMgrMap);

		// accountMgrMap에서 값이 100000보다 큰 키와 작은 키를 나눠서 리스트에 저장
		List<Integer> higherKeys = new ArrayList<>();
		List<Integer> lowerKeys = new ArrayList<>();
		// Map을 돌면서 accountMrgMap의 값이 100000보다 큰 경우와 작은 경우를 저장
		for (Map.Entry<Integer, Integer> entry : accountMgrMap.entrySet()) {
			if (entry.getValue() > 100000) {
				higherKeys.add(entry.getKey());
			} else {
				lowerKeys.add(entry.getKey());
			}
		}

//		String ename = "";
//			pstmt.setString(1, ename);

		for (Map<String, Object> empInfo : empInfoList) {

			int empno = (int) empInfo.get("empno");
			String job = (String) empInfo.get("job");
			double comm = (double) empInfo.get("comm");

			int bonus = 0;
			// job이 president 혹은 analyst인 경우 bonus=0 
			if (job.equals("PRESIDENT") || job.equals("ANALYST")) {
				bonus = 0;
			} else if (higherKeys.contains(empno)) {
				bonus = 2000;
			} else if (lowerKeys.contains(empno)) {
				bonus = 1000;
			}
			// 보너스 테이블에 삽입
			try {
				int result = conn.createStatement().executeUpdate("INSERT INTO BONUS(YYYYMM,EMPNO,BONUS_SAL) VALUES('"
						+ "202306" + "','" + empno + "','" + (comm + bonus) + "')");

			} catch (SQLException e) {
				// result 행의 개수가 0보다 크지 않거나 그 이외의 경우 실패
				e.printStackTrace();
			}
		}

	}

}
