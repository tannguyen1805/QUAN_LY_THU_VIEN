package servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import dao.DatabaseConnection;

@WebServlet("/ReturnMuonServlet")
public class ReturnMuonServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    	request.setCharacterEncoding("UTF-8");
    	response.setContentType("text/html; charset=UTF-8");
        response.setCharacterEncoding("UTF-8");
    	// Lấy ID mượn sách từ request
        String muonID = request.getParameter("muonID");

        if (muonID == null || muonID.isEmpty()) {
            response.sendRedirect("error.jsp?message=Thiếu mã mượn sách");
            return;
        }

        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            // Kết nối đến cơ sở dữ liệu
            conn = DatabaseConnection.getConnection();

            // Câu lệnh SQL để cập nhật trạng thái sách
            String sql = "UPDATE MUON SET TrangThai = 'Da Tra' WHERE MuonID = ?";
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, Integer.parseInt(muonID)); // Truyền tham số vào SQL

            int rowsUpdated = stmt.executeUpdate();
            if (rowsUpdated > 0) {
            	//Chèn dữ liệu vào Bảng TRA
            	String sqlSelect = "SELECT AccountID, Name, MaSach, TenSach, TimeMuon FROM MUON WHERE MuonID = ?";
                stmt = conn.prepareStatement(sqlSelect);
                stmt.setInt(1, Integer.parseInt(muonID));
                rs = stmt.executeQuery();

                if (rs.next()) {
                    int accountID = rs.getInt("AccountID");
                    String name = rs.getString("Name");
                    int maSach = rs.getInt("MaSach");
                    String tenSach = rs.getString("TenSach");
                    java.sql.Timestamp timeMuon = rs.getTimestamp("TimeMuon");

                    // Chèn dữ liệu vào Bảng TRA
                    String sqlInsert = "INSERT INTO TRA (MuonID, AccountID, Name, MaSach, TenSach, TimeMuon, TimeTra) "
                            + "VALUES (?, ?, ?, ?, ?, ?, ?)";
                    stmt = conn.prepareStatement(sqlInsert);
                    stmt.setInt(1, Integer.parseInt(muonID));
                    stmt.setInt(2, accountID);
                    stmt.setString(3, name);
                    stmt.setInt(4, maSach);
                    stmt.setString(5, tenSach);
                    stmt.setTimestamp(6, timeMuon);
                    stmt.setTimestamp(7, new java.sql.Timestamp(System.currentTimeMillis())); // TimeTra is the current time

                    stmt.executeUpdate();
                }
                // Trả về danh sách đã mượn nếu cập nhật thành công
                response.sendRedirect("DSMuon.jsp");
            } else {
                // Nếu không tìm thấy mã mượn sách
                response.sendRedirect("error.jsp?message=Không tìm thấy mã mượn sách");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("error.jsp?message=Lỗi khi cập nhật trạng thái");
        } finally {
            // Đóng kết nối
            try {
                if (stmt != null) stmt.close();
                if (conn != null) conn.close();
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
        }
    }
}
