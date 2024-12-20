package servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import dao.DatabaseConnection;

@WebServlet("/ThueSachServlet")
public class ThueSachServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
    	request.setCharacterEncoding("UTF-8");
    	response.setContentType("text/html; charset=UTF-8");
        response.setCharacterEncoding("UTF-8");
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            // Lấy thông tin từ session
            HttpSession session = request.getSession(false);
            if (session == null || session.getAttribute("username") == null) {
                response.sendRedirect("Login.jsp"); // Chưa đăng nhập, chuyển về trang login
                return;
            }

            int accountID = (int) session.getAttribute("accountid");
            String name = (String) session.getAttribute("name");

            // Lấy thông tin từ request
            String maSach = request.getParameter("MaSach");
            String timeDKTra = request.getParameter("TimeDKTra");

            // Kết nối DB
            conn = DatabaseConnection.getConnection();

            // Lấy tên sách từ bảng SACH
            String tenSach = null;
            String trangThai = null;
            String tt = "Dang Muon";
            String getSachSQL = "SELECT TenSach, TrangThai FROM SACH WHERE MaSach = ?";
            stmt = conn.prepareStatement(getSachSQL);
            stmt.setString(1, maSach);
            rs = stmt.executeQuery();
            if (rs.next()) {
                tenSach = rs.getString("TenSach");
                trangThai = rs.getString("TrangThai");
            } else {
                response.getWriter().write("Không tìm thấy sách với mã: " + maSach);
                return;
            }
            rs.close();
            stmt.close();
            
            if ("DaThue".equalsIgnoreCase(trangThai)) {
                response.getWriter().write("Sách '" + tenSach + "' đã được thuê. Vui lòng chọn sách khác.");
                return;
            }

            // Chèn thông tin vào bảng MUON
            String insertMuonSQL = "INSERT INTO MUON (AccountID, Name, MaSach, TenSach, TimeDKTra, TrangThai) VALUES (?, ?, ?, ?, ?, ?)";
            stmt = conn.prepareStatement(insertMuonSQL);
            stmt.setInt(1, accountID);
            stmt.setString(2, name);
            stmt.setString(3, maSach);
            stmt.setString(4, tenSach);
            stmt.setString(5, timeDKTra);
            stmt.setString(6, tt);
            stmt.executeUpdate();

            // Cập nhật trạng thái sách thành "Đã Thuê"
            String updateSachSQL = "UPDATE SACH SET TrangThai = 'DaThue' WHERE MaSach = ?";
            stmt = conn.prepareStatement(updateSachSQL);
            stmt.setString(1, maSach);
            stmt.executeUpdate();

            // Chuyển hướng về trang danh sách sách
            response.sendRedirect("TrangChu.jsp");
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write("Lỗi: " + e.getMessage());
        } finally {
            // Đóng kết nối
            try {
                if (rs != null) rs.close();
                if (stmt != null) stmt.close();
                if (conn != null) conn.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }
}
