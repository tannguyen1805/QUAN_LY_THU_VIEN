package servlet;

import java.io.*;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.sql.*;
import dao.DatabaseConnection;
@WebServlet("/EditUserServlet")
public class EditUserServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Lấy các tham số từ biểu mẫu
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("accountid") == null) {
            response.sendRedirect("Login.jsp");
            return;
        }
        
        int accountId = (Integer) session.getAttribute("accountid");
        String username = request.getParameter("username");
        String name = request.getParameter("name");
        String phone = request.getParameter("phone");
        String email = request.getParameter("email");
        String address = request.getParameter("address");
        
        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            conn = DatabaseConnection.getConnection();
            
            String sql = "UPDATE ACCOUNT SET Username = ?, Name = ?, Phone = ?, Email = ?, Address = ? WHERE AccountID = ?";
            stmt = conn.prepareStatement(sql);
            
            stmt.setString(1, username);
            stmt.setString(2, name);
            stmt.setString(3, phone);
            stmt.setString(4, email);
            stmt.setString(5, address);
            stmt.setInt(6, accountId);
            
            int rowsUpdated = stmt.executeUpdate();
            
            if (rowsUpdated > 0) {
                // Nếu cập nhật thành công, chuyển hướng về trang thông báo thành công
                response.sendRedirect("Edit1.jsp");
            } else {
                // Nếu không có thay đổi, thông báo lỗi
                request.setAttribute("errorMessage", "Cập nhật không thành công. Vui lòng thử lại.");
                request.getRequestDispatcher("EditUser1.jsp").forward(request, response);  // Stay on same page
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Có lỗi xảy ra: " + e.getMessage());
            request.getRequestDispatcher("EditUser1.jsp").forward(request, response);
        } finally {
            try {
                if (stmt != null) stmt.close();
                if (conn != null) conn.close();
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
        }
    }
}
