<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="dao.DatabaseConnection" %>
<!DOCTYPE html>
<html>
<head>
    <title>Sửa Sách</title>
    <meta charset="UTF-8">
    <!-- Import font Roboto hỗ trợ tiếng Việt -->
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;500&display=swap&subset=vietnamese" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.5.0/dist/css/bootstrap.min.css">
    <style>
        body {
            font-family: 'Roboto', 'Arial', sans-serif; /* Font chữ hỗ trợ tiếng Việt */
            font-size: 16px;
        }
        .form-group label {
            font-weight: 500;
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
        <h1 class="text-center">Sửa Thông Tin Sách</h1>
        
        <%
            response.setContentType("text/html; charset=UTF-8");
            response.setCharacterEncoding("UTF-8");
            String maSach = request.getParameter("maSach");
            Connection conn = null;
            PreparedStatement stmt = null;
            ResultSet rs = null;

            String tenSach = "";
            String tacGia = "";
            double gia = 0;
            String hinhAnh = "";

            try {
                conn = DatabaseConnection.getConnection();
                String sql = "SELECT * FROM SACH WHERE MaSach = ?";
                stmt = conn.prepareStatement(sql);
                stmt.setString(1, maSach);
                rs = stmt.executeQuery();

                if (rs.next()) {
                    tenSach = rs.getString("TenSach");
                    tacGia = rs.getString("TacGia");
                    gia = rs.getDouble("Gia");
                    hinhAnh = rs.getString("HinhAnh");
                }
            } catch (Exception e) {
                e.printStackTrace();
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

        <form action="EditDeleteBookServlet" method="post">
            <input type="hidden" name="maSach" value="<%= maSach %>">
            <input type="hidden" name="action" value="edit">
            
            <div class="form-group">
                <label for="tenSach">Tên Sách:</label>
                <input type="text" class="form-control" id="tenSach" name="tenSach" value="<%= tenSach %>" required>
            </div>

            <div class="form-group">
                <label for="tacGia">Tác Giả:</label>
                <input type="text" class="form-control" id="tacGia" name="tacGia" value="<%= tacGia %>" required>
            </div>

            <div class="form-group">
                <label for="gia">Giá:</label>
                <input type="number" class="form-control" id="gia" name="gia" value="<%= gia %>" required>
            </div>

            <div class="form-group">
                <label for="hinhAnh">Ảnh Bìa (URL):</label>
                <input type="text" class="form-control" id="hinhAnh" name="hinhAnh" value="<%= hinhAnh %>" required>
            </div>

            <button type="submit" class="btn btn-success">Cập Nhật</button>
        </form>
    </div>
</body>
</html>
