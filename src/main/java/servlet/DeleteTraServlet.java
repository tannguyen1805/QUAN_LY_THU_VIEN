package servlet;

import java.io.*;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import dao.DatabaseConnection;
import java.sql.*;

@WebServlet("/DeleteTraServlet")
public class DeleteTraServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");
        response.setCharacterEncoding("UTF-8");

        String traID = request.getParameter("traID");

        // Kiểm tra nếu muonID là null hoặc rỗng
        if (traID == null || traID.isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing required parameter: muonID");
            return;
        }

        try (Connection conn = DatabaseConnection.getConnection()) {
            // Xóa bản ghi mượn sách từ cơ sở dữ liệu
            String sql = "DELETE FROM TRA WHERE TraID = ?";
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setString(1, traID);

                int rowsAffected = stmt.executeUpdate();

                if (rowsAffected > 0) {
                    // Xóa thành công, quay lại danh sách mượn
                    response.sendRedirect("DSTra.jsp");
                } else {
                    // Không tìm thấy bản ghi để xóa
                    response.sendError(HttpServletResponse.SC_NOT_FOUND, "Record not found for TraID: " + traID);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Database error occurred");
        }
    }
}
