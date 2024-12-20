<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
<%
    if (session == null || session.getAttribute("username") == null) {
        response.sendRedirect("Login.jsp"); // Nếu không có session, quay về đăng nhập
        return; // Dừng xử lý tiếp trong trang này
    }
%>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản Lý Sách</title>

    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;500&display=swap&subset=vietnamese" rel="stylesheet">

    <!-- Bootstrap CSS -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.5.0/dist/css/bootstrap.min.css">

    <style>
        body {
            font-family: 'Roboto', 'Arial', sans-serif; /* Hỗ trợ tiếng Việt */
            font-size: 16px;
        }

        .container {
            margin-top: 50px;
        }

        .form-container {
            max-width: 600px;
            margin: 0 auto;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1 class="text-center">Thêm Sách Mới</h1>

        <div class="form-container mt-5">
            <form action="AddBookServlet" method="post">
                <div class="form-group">
                    <label for="maSach">Mã Sách:</label>
                    <input type="text" class="form-control" id="maSach" name="maSach" placeholder="Nhập mã sách" required>
                </div>
                <div class="form-group">
                    <label for="tenSach">Tên Sách:</label>
                    <input type="text" class="form-control" id="tenSach" name="tenSach" placeholder="Nhập tên sách" required>
                </div>
                <div class="form-group">
                    <label for="tacGia">Tác Giả:</label>
                    <input type="text" class="form-control" id="tacGia" name="tacGia" placeholder="Nhập tên tác giả" required>
                </div>
                <div class="form-group">
                    <label for="gia">Giá:</label>
                    <input type="number" class="form-control" id="gia" name="gia" placeholder="Nhập giá sách" required>
                </div>
                <div class="form-group">
                    <label for="hinhAnh">Ảnh Bìa (URL):</label>
                    <input type="text" class="form-control" id="hinhAnh" name="hinhAnh" placeholder="Nhập URL ảnh bìa" required>
                </div>
                <div class="text-center">
                    <button type="submit" class="btn btn-success">Thêm Sách</button>
                    <a href="TrangChu.jsp" class="btn btn-secondary">Hủy</a>
                </div>
            </form>
        </div>
    </div>

    <!-- Bootstrap JS -->
    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.5.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
