<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="dao.DatabaseConnection" %>
<!DOCTYPE html>
<html>
<head>
    <title>Danh Sách Đã Mượn</title>
    <meta charset="UTF-8">
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;500&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.5.0/dist/css/bootstrap.min.css">
    <style>
        body {
        font-family: 'Arial', sans-serif;  /* Sử dụng font Arial */
        font-size: 16px;
        }
           .table {
           font-family: 'Arial', sans-serif;  /* Font chữ cho bảng */
        }
        
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
        <h1 class="text-center">Danh Sách Đã Mượn</h1>
        <table class="table table-bordered">
            <thead>
                <tr>
                    <th>ID mượn sách</th>
                    <th>Id Users</th>
                    <th>Tên Người Mượn</th>
                    <th>Mã Sách</th>
                    <th>Tên Sách</th>
                    <th>Thời Gian Mượn</th>
                    <th>Thời Gian Dự Kiến Trả</th>
                    <th>Trạng Thái</th>
                    <th>Thao Tác</th>
                </tr>
            </thead>
            <tbody>
                <%
                response.setContentType("text/html; charset=UTF-8");
                response.setCharacterEncoding("UTF-8");
                Connection conn = null;
                PreparedStatement stmt = null;
                ResultSet rs = null;

                try {
                    conn = DatabaseConnection.getConnection();
                    String sql = "SELECT MuonID, AccountID, Name, MaSach, TenSach, TimeMuon, TimeDKTra, TrangThai FROM MUON";
                    stmt = conn.prepareStatement(sql);
                    rs = stmt.executeQuery();

                    while (rs.next()) {
                    	int muonID = rs.getInt("MuonID");
                        int accountID = rs.getInt("AccountID");
                        String name = rs.getString("Name");
                        String maSach = rs.getString("MaSach");
                        String tenSach = rs.getString("TenSach");
                        Timestamp timeMuon = rs.getTimestamp("TimeMuon");
                        Timestamp timeDKTra = rs.getTimestamp("TimeDKTra");
                        String tt = rs.getString("TrangThai");
                %>
                <tr>
                    <td><%= muonID %></td>
                    <td><%= accountID %></td>
                    <td><%= name %></td>
                    <td><%= maSach %></td>
                    <td><%= tenSach %></td>
                    <td><%= timeMuon %></td>
                    <td><%= timeDKTra %></td>
                    <td><%= tt %></td>
                    <td>
                       <!-- Nút bổ sung nếu trạng thái là 'Dang Muon' -->
					    <%
					        if ("Dang Muon".equals(tt)) {
					    %>
					        <form action="ReturnMuonServlet" method="post" style="display: inline;">
					            <input type="hidden" name="muonID" value="<%= muonID %>">
					            <button type="submit" class="btn btn-success btn-sm" onclick="return confirm('Bạn có chắc chắn muốn trả sách này?');">Trả Sách</button>
					        </form>
					    <%
					        }
					    %>
                       <!-- Nút Xóa -->
                       <form action="DeleteMuonServlet" method="post" style="display: inline;">
                             <input type="hidden" name="muonID" value="<%= muonID %>">
                             <button type="submit" class="btn btn-danger btn-sm" onclick="return confirm('Bạn có chắc chắn muốn xóa sách này?');">Xóa</button>
                       </form>
                    </td>
                </tr>
                <%
                    }
                } catch (Exception e) {
                    out.println("<tr><td colspan='6'>Lỗi: " + e.getMessage() + "</td></tr>");
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
        </table>
     
        <div class="back-home-btn">
             <a href="TrangChu.jsp" class="btn btn-primary btn-lg">Quay về Trang chủ</a>
        </div>
        
    </div>
</body>
</html>
