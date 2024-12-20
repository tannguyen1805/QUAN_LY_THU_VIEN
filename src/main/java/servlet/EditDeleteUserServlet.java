package servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import dao.DatabaseConnection;

@WebServlet("/EditDeleteUserServlet")
public class EditDeleteUserServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    	request.setCharacterEncoding("UTF-8");
    	response.setContentType("text/html; charset=UTF-8");
        response.setCharacterEncoding("UTF-8");
    	String action = request.getParameter("action"); // "edit" hoặc "delete"
        int accountId = Integer.parseInt(request.getParameter("accountId"));
        
        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            conn = DatabaseConnection.getConnection();

            if ("edit".equals(action)) {
                // Lấy dữ liệu từ form sửa
                String username = request.getParameter("username");
                String name = request.getParameter("name");
                String phone = request.getParameter("phone");
                String email = request.getParameter("email");
                String address = request.getParameter("address");
                String role = request.getParameter("role");
                double sotien = Double.parseDouble(request.getParameter("sotien"));

                // Câu lệnh SQL cập nhật thông tin
                String sql = "UPDATE ACCOUNT SET Username = ?, Name = ?, Phone = ?, Email = ?, Address = ?, Role = ?, SoTien = ? WHERE AccountID = ?";
                stmt = conn.prepareStatement(sql);
                stmt.setString(1, username);
                stmt.setString(2, name);
                stmt.setString(3, phone);
                stmt.setString(4, email);
                stmt.setString(5, address);
                stmt.setString(6, role);
                stmt.setDouble(7, sotien);
                stmt.setInt(8, accountId);
                

                int rowsUpdated = stmt.executeUpdate();
                if (rowsUpdated > 0) {
                	HttpSession session = request.getSession();
                    session.setAttribute("username", username);
                    session.setAttribute("role", role);
                    session.setAttribute("name", name);
                    session.setAttribute("sotien", sotien);
                    response.sendRedirect("DisplayUsers.jsp?message=updated");
                }

            } else if ("delete".equals(action)) {
                // Truy vấn xóa
                String sql = "DELETE FROM ACCOUNT WHERE AccountID = ?";
                stmt = conn.prepareStatement(sql);
                stmt.setInt(1, accountId);

                int rowsDeleted = stmt.executeUpdate();
                if (rowsDeleted > 0) {
                    response.sendRedirect("DisplayUsers.jsp?message=deleted"); // Hiển thị danh sách người dùng sau khi xóa
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("DisplayUsers.jsp?error=operationFailed");
        } finally {
            try {
                if (stmt != null) stmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}
