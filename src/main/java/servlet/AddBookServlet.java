package servlet;

import java.io.*;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import dao.DatabaseConnection;
import java.sql.*;

@WebServlet("/AddBookServlet")
public class AddBookServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html; charset=UTF-8");
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        // Get form parameters
        String maSach = request.getParameter("maSach");
        String tenSach = request.getParameter("tenSach");
        String tacGia = request.getParameter("tacGia");
        String giaStr = request.getParameter("gia");
        String hinhAnh = request.getParameter("hinhAnh");
        String TrangThai = "Con";

        // Validation
        if (maSach == null || tenSach == null || tacGia == null || giaStr == null || hinhAnh == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing required fields.");
            return;
        }

        try {
            double gia = Double.parseDouble(giaStr);

            // Insert book into database
            try (Connection conn = DatabaseConnection.getConnection()) {
                String sql = "INSERT INTO SACH (MaSach, TenSach, TacGia, Gia, HinhAnh, TrangThai) VALUES (?, ?, ?, ?, ?, ?)";
                try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                    stmt.setString(1, maSach);
                    stmt.setString(2, tenSach);
                    stmt.setString(3, tacGia);
                    stmt.setDouble(4, gia);
                    stmt.setString(5, hinhAnh);
                    stmt.setString(6, TrangThai);

                    int rowsInserted = stmt.executeUpdate();
                    if (rowsInserted > 0) {
                        response.sendRedirect("Book.jsp?message=success");
                    } else {
                        response.sendRedirect("Book.jsp?message=failure");
                    }
                }
            }
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid number format for 'Gia'.");
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Database error occurred.");
        }
    }
}
