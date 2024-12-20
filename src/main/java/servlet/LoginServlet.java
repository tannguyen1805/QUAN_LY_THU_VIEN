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
import javax.servlet.http.HttpSession;

import dao.DatabaseConnection;

/**
 * Servlet implementation class LoginServlet
 */
@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    	request.setCharacterEncoding("UTF-8");
    	response.setContentType("text/html; charset=UTF-8");
        response.setCharacterEncoding("UTF-8");
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        // Kết nối tới cơ sở dữ liệu
        Connection connection = DatabaseConnection.getConnection();

        if (connection != null) {
            try {
                // Truy vấn thông tin tài khoản từ cơ sở dữ liệu
                String query = "SELECT AccountID, Role, Name, SoTien FROM ACCOUNT WHERE Username = ? AND Password = ?";
                PreparedStatement preparedStatement = connection.prepareStatement(query);
                preparedStatement.setString(1, username);
                preparedStatement.setString(2, password);
                ResultSet resultSet = preparedStatement.executeQuery();

                // Kiểm tra kết quả truy vấn
                if (resultSet.next()) {
                    String role = resultSet.getString("Role");
                    String name = resultSet.getString("Name");
                    Double sotien = resultSet.getDouble("SoTien");
                    int accountid = resultSet.getInt("AccountID");

                    HttpSession session = request.getSession(false);
                    if (session != null) {
                        session.invalidate();
                    }
                    session = request.getSession(true);
                    session.setAttribute("accountid", accountid);
                    session.setAttribute("username", username);
                    session.setAttribute("role", role);
                    session.setAttribute("name", name);
                    session.setAttribute("sotien", sotien);

                    // Chuyển hướng dựa trên vai trò
                    if ("Admin".equalsIgnoreCase(role)) {
                        response.sendRedirect("TrangChu.jsp");
                    } else if ("User".equalsIgnoreCase(role)) {
                        response.sendRedirect("TrangChu2.jsp");
                    } else {
                        response.sendRedirect("Login.jsp?error=invalidRole"); // Vai trò không hợp lệ
                    }
                } else {
                    response.sendRedirect("Login.jsp?error=invalid"); // Thông tin đăng nhập không hợp lệ
                }

                resultSet.close();
                preparedStatement.close(); // Đảm bảo đóng PreparedStatement

            } catch (SQLException e) {
                e.printStackTrace();
                response.getWriter().write("Lỗi khi kết nối đến cơ sở dữ liệu!"); // Xử lý lỗi
            }
        } else {
            response.getWriter().write("Không thể kết nối đến cơ sở dữ liệu!"); // Xử lý lỗi kết nối
        }
    }
}
