<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="dao.DatabaseConnection" %>
<!DOCTYPE html>
<html>
<head>
    <title>Danh Sách Người Dùng</title>
    <meta charset="UTF-8">
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css">
    <style>
        table {
            width: 100%;
            border-collapse: collapse;
        }
        th, td {
            border: 1px solid #ddd;
            padding: 8px;
            text-align: center;
        }
        th {
            background-color: #f2f2f2;
            font-weight: bold;
        }
        tr:hover {
            background-color: #f1f1f1;
        }
        .back-home-btn {
            margin-top: 20px;
            display: flex;
            justify-content: center;
        }
    </style>
</head>
<body>
<%
    if (session == null || session.getAttribute("username") == null) {
        response.sendRedirect("Login.jsp"); // Nếu không có session, quay về đăng nhập
        return; // Dừng xử lý tiếp trong trang này
    }
%>
    <div class="container">
        <h1 class="text-center">Danh Sách Người Dùng</h1>
        <table class="table table-bordered">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Tên Đăng Nhập</th>
                    <th>Tên</th>
                    <th>Số Điện Thoại</th>
                    <th>Email</th>
                    <th>Địa Chỉ</th>
                    <th>Vai Trò</th>
                    <th>Số Tiền</th>
                    <th>Hành Động</th>
                </tr>
            </thead>
            <tbody>
                <%
                Connection conn = null;
                PreparedStatement stmt = null;
                ResultSet rs = null;

                try {
                    conn = DatabaseConnection.getConnection();
                    String sql = "SELECT AccountID, Username, Name, Phone, Email, Address, Role, SoTien FROM ACCOUNT";
                    stmt = conn.prepareStatement(sql);
                    rs = stmt.executeQuery();

                    while (rs.next()) {
                        int accountId = rs.getInt("AccountID");
                        String username = rs.getString("Username");
                        String name = rs.getString("Name");
                        String phone = rs.getString("Phone");
                        String email = rs.getString("Email");
                        String address = rs.getString("Address");
                        String role = rs.getString("Role");
                        double sotien = rs.getDouble("SoTien");
                %>
                <tr>
                    <td><%= accountId %></td>
                    <td><%= username %></td>
                    <td><%= name %></td>
                    <td><%= phone != null ? phone : "N/A" %></td>
                    <td><%= email != null ? email : "N/A" %></td>
                    <td><%= address != null ? address : "N/A" %></td>
                    <td><%= role %></td>
                    <td><%= sotien %></td>
                    <td>
                        <!-- Nút Sửa -->
                        <form action="EditUsers.jsp" method="post" style="display: inline;">
                            <input type="hidden" name="action" value="edit">
                            <input type="hidden" name="accountId" value="<%= accountId %>">
                            <button type="submit" class="btn btn-warning btn-sm">Sửa</button>
                        </form>
                        <!-- Nút Xóa -->
                        <form action="EditDeleteUserServlet" method="post" style="display: inline;">
                            <input type="hidden" name="action" value="delete">
                            <input type="hidden" name="accountId" value="<%= accountId %>">
                            <button type="submit" class="btn btn-danger btn-sm" onclick="return confirm('Bạn có chắc chắn muốn xóa người dùng này?');">Xóa</button>
                        </form>
                    </td>
                </tr>
                <%
                    }
                } catch (Exception e) {
                    out.println("<tr><td colspan='8'>Lỗi: " + e.getMessage() + "</td></tr>");
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
            </tbody>
        </table><br><br><br>
        <div class="back-home-btn">
             <a href="TrangChu.jsp" class="btn btn-primary btn-lg">Quay về Trang chủ</a>
        </div>
        
    </div>
</body>
</html>
