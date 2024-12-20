package servlet;

import dao.DatabaseConnection;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/RegisterServlet")
public class RegisterServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    	request.setCharacterEncoding("UTF-8");
    	response.setContentType("text/html; charset=UTF-8");
        response.setCharacterEncoding("UTF-8");
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String name = request.getParameter("name");
        String phone = request.getParameter("phone");
        String email = request.getParameter("email");
        String address = request.getParameter("address");
        String role = "User"; // Mặc định là User
        Double sotien = 0.0;

        Connection connection = null;
        PreparedStatement preparedStatement = null;

        try {
            // Kết nối tới cơ sở dữ liệu
            connection = DatabaseConnection.getConnection();
            if (connection == null) {
                response.getWriter().write("Không thể kết nối tới cơ sở dữ liệu!");
                return;
            }


            // Chuẩn bị câu lệnh SQL
            String query = "INSERT INTO ACCOUNT (Username, Password, Name, Phone, Email, Address, Role, SoTien) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
            preparedStatement = connection.prepareStatement(query);
            preparedStatement.setString(1, username);
            preparedStatement.setString(2, password);
            preparedStatement.setString(3, name);
            preparedStatement.setString(4, phone);
            preparedStatement.setString(5, email);
            preparedStatement.setString(6, address);
            preparedStatement.setString(7, role);
            preparedStatement.setDouble(8, sotien);

            // Thực thi câu lệnh
            int result = preparedStatement.executeUpdate();

            if (result > 0) {
                response.sendRedirect("Thank.jsp"); // Chuyển hướng tới trang cảm ơn
            } else {
                response.getWriter().write("Đăng ký không thành công!");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            response.getWriter().write("Lỗi khi thực thi truy vấn!");
        } finally {
            try {
                if (preparedStatement != null) preparedStatement.close();
                if (connection != null) connection.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}
