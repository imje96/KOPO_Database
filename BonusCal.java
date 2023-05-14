import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class BonusCal {

    private static final String PRESIDENT = "PRESIDENT";
    private static final String ANALYST = "ANALYST";

    private Connection conn;

    public BonusCal(Connection connection) {
        this.conn = connection;
    }

    Statement stmt = conn.createStatement();
    
    public void calculateBonus() {
        long startTime = System.currentTimeMillis();
        
        // EMP 테이블에서 필요한 컬럼만 가져오기
        String empSql = "SELECT empno, ename, job, mgr, hiredate, sal, comm, deptno FROM emp";
        List<Map<String, Object>> empInfoList = new ArrayList<>();
        try (Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(empSql)) {
            while (rs.next()) {
                Map<String, Object> empInfo = new HashMap<>();
                empInfo.put("empno", rs.getInt("empno"));
                empInfo.put("ename", rs.getString("ename"));
                empInfo.put("job", rs.getString("job"));
                empInfo.put("mgr", rs.getInt("mgr"));
                empInfo.put("hiredate", rs.getDate("hiredate"));
                empInfo.put("sal", rs.getDouble("sal"));
                empInfo.put("comm", rs.getDouble("comm"));
                empInfo.put("deptno", rs.getInt("deptno"));
                empInfoList.add(empInfo);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        // CUSTOMER 테이블에서 필요한 컬럼만 가져오기
        String customerSql = "SELECT account_mgr, COUNT(*) as cnt FROM customer GROUP BY account_mgr";
        Map<Integer, Integer> accountMgrMap = new HashMap<>();
        try (Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(customerSql)) {
            while (rs.next()) {
                int accountMgr = rs.getInt("account_mgr");
                int cnt = rs.getInt("cnt");
                accountMgrMap.put(accountMgr, cnt);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        // accountMgrMap에서 값이 100000보다 큰 키와 작은 키를 나눠서 리스트에 저장
        List<Integer> higherKeys = new ArrayList<>();
        List<Integer> lowerKeys = new ArrayList<>();
        for (Map.Entry<Integer, Integer> entry : accountMgrMap.entrySet()) {
            if (entry.getValue() > 100000) {
                higherKeys.add(entry.getKey());
            } else {
                lowerKeys.add(entry.getKey());
            }
        }
        
        // BONUS 테이블에 값을 넣기 위한 INSERT 문 실행
        String bonusSql = "INSERT INTO bonus (ename, job, sal, comm) VALUES (?, ?, ?, ?)";
        try (PreparedStatement pstmt = conn.prepareStatement(bonusSql)) {
            for (Map<String, Object> empInfo : empInfoList) {
                String job = (String) empInfo.get("job");
                double sal = (Double) empInfo.get("sal");
                double comm = (Double) empInfo.get("comm");
                
                // 보너스 계산
                int bonus = 0;
                Integer mgr = (Integer) empInfo.get("mgr");
                if (mgr != null && !job.equals(PRESIDENT) && !job.equals(ANALYST)) {
                    if (higherKeys.contains(mgr)) {
                        bonus = 2000;
} else if (lowerKeys.contains(mgr)) {
bonus = 1000;
}
}
             // 보너스 테이블 생성 쿼리
                String createBonusSql = "CREATE TABLE bonus ("
                    + "empno NUMBER(4) NOT NULL, "
                    + "ename VARCHAR2(10), "
                    + "job VARCHAR2(9), "
                    + "sal NUMBER(7, 2), "
                    + "comm NUMBER(7, 2), "
                    + "deptno NUMBER(2), "
                    + "bonus NUMBER(7, 2), "
                    + " CONSTRAINT bonus_empno_fk FOREIGN KEY (empno) REFERENCES emp (empno)"
                    + ")";
                // 보너스 테이블 생성
                stmt.execute(createBonusSql);

             // 보너스 테이블에 INSERT
                String insertSql = "INSERT INTO bonus (ename, job, sal, comm, bonus) VALUES (?, ?, ?, ?, ?)";
                PreparedStatement insertStmt = conn.prepareStatement(insertSql);
                insertStmt.setString(1, (String) empInfo.get("ename"));
                insertStmt.setString(2, job);
                insertStmt.setDouble(3, (Double) empInfo.get("sal"));
                insertStmt.setDouble(4, (Double) empInfo.get("comm"));
        
                if (empInfo.get("comm") != null) {
                    comm = (Double) empInfo.get("comm");
                }
                insertStmt.setDouble(4, comm);
                int bonus = 0;
                Integer mgr = (Integer) empInfo.get("mgr");
                if (mgr != null && !job.equals(PRESIDENT) && !job.equals(ANALYST)) {
                    if (higherKeys.contains(mgr)) {
                        bonus = 2000;
                    } else if (lowerKeys.contains(mgr)) {
                        bonus = 1000;
                    }
                }
                insertStmt.setDouble(5, bonus);
                insertStmt.executeUpdate();
                
                
             // 보너스 테이블에 INSERT
                String insertSql = "INSERT INTO bonus (ename, job, sal, comm) VALUES (?, ?, ?, ?)";
                PreparedStatement insertStmt = conn.prepareStatement(insertSql);
                insertStmt.setString(1, (String) empInfo.get("ename"));
                insertStmt.setString(2, job);
                insertStmt.setDouble(3, (Double) empInfo.get("sal"));
                double comm = 0.0;
                if (empInfo.get("comm") != null) {
                    comm = (Double) empInfo.get("comm");
                }
                insertStmt.setDouble(4, comm + bonus);
                insertStmt.executeUpdate();

                // 처리 시작 시간 측정
                long startTime = System.currentTimeMillis();

                int resultrows = stmt.executeUpdate(bonusSql);
                System.out.println("보너스 테이블 생성 완료, 총 " + resultrows+ "개의 row가 생성되었습니다.");

                // 처리 종료 시간 측정
                long endTime = System.currentTimeMillis();

                // 처리 시간 출력 (처리 종료 시간 - 처리 시작 시간)
                double elapsedTime = (endTime - startTime) / 1000.0;
                System.out.println("처리에 걸린 시간: " + elapsedTime + "초");

}
        }
    }
}