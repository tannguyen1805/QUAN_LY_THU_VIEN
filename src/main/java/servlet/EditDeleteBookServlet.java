package servlet;

import java.io.*;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import dao.DatabaseConnection;
import java.sql.*;

@WebServlet("/EditDeleteBookServlet")
public class EditDeleteBookServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    	request.setCharacterEncoding("UTF-8");
    	response.setContentType("text/html; charset=UTF-8");
        response.setCharacterEncoding("UTF-8");
    	String action = request.getParameter("action");
        String maSach = request.getParameter("maSach");

        // Kiểm tra nếu action hoặc maSach là null, trả về lỗi
        if (action == null || maSach == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing required parameters");
            return;
        }

        try (Connection conn = DatabaseConnection.getConnection()) {
            if (action.equals("edit")) {
                // Lấy thông tin từ form
                String tenSach = request.getParameter("tenSach");
                String tacGia = request.getParameter("tacGia");
                double gia = Double.parseDouble(request.getParameter("gia"));
                String hinhAnh = request.getParameter("hinhAnh");

                // Kiểm tra dữ liệu
                if (tenSach == null || tacGia == null || gia <= 0 || hinhAnh == null) {
                    response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing book details");
                    return;
                }

                // Cập nhật sách trong cơ sở dữ liệu
                String sql = "UPDATE SACH SET TenSach = ?, TacGia = ?, Gia = ?, HinhAnh = ? WHERE MaSach = ?";
                try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                    stmt.setString(1, tenSach);
                    stmt.setString(2, tacGia);
                    stmt.setDouble(3, gia);
                    stmt.setString(4, hinhAnh);
                    stmt.setString(5, maSach);
                    stmt.executeUpdate();
                }

                // Quay lại trang danh sách sách
                response.sendRedirect("Book.jsp");

            } else if (action.equals("delete")) {
                // Xóa sách khỏi cơ sở dữ liệu
                String sql = "DELETE FROM SACH WHERE MaSach = ?";
                try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                    stmt.setString(1, maSach);
                    stmt.executeUpdate();
                }

                // Quay lại trang danh sách sách
                response.sendRedirect("Book.jsp");
            } else {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid action parameter");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Database error occurred");
        }
    }
}
