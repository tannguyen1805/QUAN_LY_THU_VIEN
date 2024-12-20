<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="dao.DatabaseConnection" %>
<!DOCTYPE html>
<html>
<head>
    <title>Sửa Thông Tin Người Dùng</title>
    <meta charset="UTF-8">
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css">
</head>
<body>
<%
    if (session == null || session.getAttribute("username") == null) {
        response.sendRedirect("Login.jsp"); // Nếu không có session, quay về đăng nhập
        return; // Dừng xử lý tiếp trong trang này
    }
%>
    <div class="container">
        <h1 class="text-center">Sửa Thông Tin Người Dùng</h1>
        <%
        int accountId = Integer.parseInt(request.getParameter("accountId"));
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        String username = "", name = "", phone = "", email = "", address = "", role = "";
        double sotien = 0;
        
        try {
            conn = DatabaseConnection.getConnection();
            String sql = "SELECT Username, Name, Phone, Email, Address, Role, SoTien FROM ACCOUNT WHERE AccountID = ?";
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, accountId);
            rs = stmt.executeQuery();
            
            if (rs.next()) {
                username = rs.getString("Username");
                name = rs.getString("Name");
                phone = rs.getString("Phone");
                email = rs.getString("Email");
                address = rs.getString("Address");
                role = rs.getString("Role");
                sotien = rs.getDouble("SoTien");
            }
        } catch (Exception e) {
            out.println("<p>Lỗi: " + e.getMessage() + "</p>");
        } finally {
            try {
                if (rs != null) rs.close();
                if (stmt != null) stmt.close();
                if (conn != null) conn.close();
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
        }
        %>
        <form action="EditDeleteUserServlet" method="post">
            <input type="hidden" name="action" value="edit">
            <input type="hidden" name="accountId" value="<%= accountId %>">
            <div class="form-group">
                <label>Tên Đăng Nhập:</label>
                <input type="text" name="username" class="form-control" value="<%= username %>" required>
            </div>
            <div class="form-group">
                <label>Tên:</label>
                <input type="text" name="name" class="form-control" value="<%= name %>" required>
            </div>
            <div class="form-group">
                <label>Số Điện Thoại:</label>
                <input type="text" name="phone" class="form-control" value="<%= phone %>">
            </div>
            <div class="form-group">
                <label>Email:</label>
                <input type="email" name="email" class="form-control" value="<%= email %>">
            </div>
            <div class="form-group">
                <label>Địa Chỉ:</label>
                <input type="text" name="address" class="form-control" value="<%= address %>">
            </div>
            <div class="form-group">
                <label>Vai Trò:</label>
                <select name="role" class="form-control">
                    <option value="Admin" <%= "Admin".equals(role) ? "selected" : "" %>>Admin</option>
                    <option value="User" <%= "User".equals(role) ? "selected" : "" %>>User</option>
                </select>
            </div>
            <div class="form-group">
                <label for="sotien">Số Tiền:</label>
                <input type="number" class="form-control" name="sotien" value="<%= sotien %>">
            </div>
            <button type="submit" class="btn btn-primary">Lưu Thay Đổi</button>
        </form>
    </div>
</body>
</html>
