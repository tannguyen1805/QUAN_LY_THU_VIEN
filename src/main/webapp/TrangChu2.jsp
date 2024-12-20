<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="dao.DatabaseConnection" %>
<!DOCTYPE html>
<html>
<head>
  <title>Quản Lý Thư Viện</title>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css">
  <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
  <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js"></script>
  <style>
    /* Khung bao quanh menu */
    .menu {
      padding: 10px;
      border-radius: 8px; /* Bo tròn góc của khung */
      background-color: #AFEEEE; /* Màu nền nhẹ cho menu */
      border: 1px solid #ccc;
    }

    .menu ul {
      list-style-type: none;
      padding: 0;
      margin: 0;
      display: flex;
      justify-content: space-between;
    }

    .menu li {
      display: inline-block;
      margin-right: 20px; /* Khoảng cách giữa các nút */
    }

    .menu a {
      text-decoration: none; /* Bỏ gạch chân */
      color: #333; /* Màu chữ */
      font-weight: bold;
      padding: 8px 16px;
      border-radius: 4px; /* Bo tròn các góc của nút */
      transition: background-color 0.3s ease; /* Thêm hiệu ứng chuyển màu nền */
    }

    /* Hiệu ứng hover */
    .menu a:hover {
      background-color: #007bff; /* Màu nền khi hover */
      color: white; /* Màu chữ khi hover */
    }

    /* Bố trí tìm kiếm và các nút trên cùng một hàng */
    .row-nav {
      display: flex;
      justify-content: space-between;
      align-items: center;
    }

    .search input[type="search"] {
      padding: 5px 10px;
      width: 60%;
      font-size: 16px;
      border-radius: 4px;
      border: 1px solid #ccc;
      margin-right: 10px;
      text-align: left;
    }

    .search button {
      padding: 5px 16px;
      font-size: 16px;
      border: none;
      background-color: #007bff;
      color: white;
      border-radius: 4px;
      cursor: pointer;
      transition: background-color 0.3s;
    }

    .search button:hover {
      background-color: #0056b3;
    }

    .img-responsive {
      width: 500px;  /* Chiều rộng của ảnh */
      height: 300px; /* Chiều cao của ảnh */
    }

    .row {
      display: flex;
      justify-content: center; /* Căn giữa theo chiều ngang */
      align-items: center;     /* Căn giữa theo chiều dọc */
    }

    .row > .col-sm-4 {
      border: 1px solid #ccc; /* Khung xung quanh các cột */
      padding: 10px; /* Khoảng cách bên trong cột */
      margin: 10px; /* Khoảng cách giữa các cột */
      border-radius: 8px; /* Bo tròn các góc của khung */
      text-align: center; /* Căn giữa tất cả nội dung trong cột */
    }

    .row input[type="submit"] {
      padding: 10px 20px;  /* Thêm khoảng cách padding cho nút */
      width: 70%;         /* Đảm bảo nút chiếm hết chiều rộng */
      font-size: 16px;     /* Kích thước font chữ */
      border: none;
      border-radius: 4px;
      cursor: pointer;
      margin-top: 10px;    /* Khoảng cách từ nội dung phía trên */
    }

    .row {
      display: flex;
      flex-wrap: wrap; /* Cho phép các mục xuống dòng */
    }

    .col-sm-4 {
      flex: 0 0 30%; /* Chiếm 1/3 chiều rộng của container, 3 ô mỗi hàng */
      padding: 10px;
      box-sizing: border-box;
    }

    /* Tùy chọn: Để thêm tính phản hồi cho màn hình nhỏ */
    @media (max-width: 767px) {
      .col-sm-4 {
        flex: 0 0 30%; /* Giữ 3 ô mỗi hàng trên màn hình nhỏ */
      }
    }

    @media (max-width: 480px) {
      .col-sm-4 {
        flex: 0 0 100%; /* 1 mục mỗi hàng trên màn hình cực nhỏ */
      }
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


<div class="jumbotron text-center">
  <h1>Quản Lý Thư Viện - Users</h1>
  <!-- Hiển thị tên người dùng từ session -->
  <h2>Xin Chào, <strong>${sessionScope.name}</strong> !</h2> 
  <p>Số dư: <strong>${sessionScope.sotien}</strong> VND</p> 
  <p>Số dư: <strong>${sessionScope.accountID}</strong> VND</p> 
</div>
<div class="container">
  <nav>
    <div class="row-nav">
      <!-- Menu nút -->
      <div class="menu">
        <ul>
          <li><a href="DSMuon1.jsp">Lịch sử mượn sách</a></li>
          <li><a href="DSTra1.jsp">Lịch sử trả sách</a></li>
          <li><a href="DisplayUsers1.jsp">Chỉnh sửa thông tin</a></li>
          <li><a href="LogoutServlet">Đăng Xuất</a></li>
        </ul>
      </div>
      <!-- Thanh tìm kiếm -->
      <div class="search">
        <input type="search" placeholder="Tìm kiếm...">
        <button>Tìm Kiếm</button>
      </div>
    </div>
  </nav>
  <br><br>
  <h2>Danh Mục Các Sản Phẩm: </h2>
  <br><br>
  <div class="row">
    <% 
    Connection conn = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;

    try {
        conn = DatabaseConnection.getConnection();
        // Truy vấn từ bảng SACH
        String sql = "SELECT MaSach, TenSach, Gia, HinhAnh, TrangThai FROM SACH";
        stmt = conn.prepareStatement(sql);
        rs = stmt.executeQuery();

        // Hiển thị từng sách
        while (rs.next()) {
            String maSach = rs.getString("MaSach");
            String tenSach = rs.getString("TenSach");
            double gia = rs.getDouble("Gia");
            String hinhAnh = rs.getString("HinhAnh"); // Đường dẫn hình ảnh
            String trangThai = rs.getString("TrangThai");
    %>
    <div class="col-sm-4">
      <h2><%= tenSach %></h2>
      <img src="<%= hinhAnh %>" alt="<%= tenSach %>" class="img-responsive">
      <h3>Giá: <%= gia %> VND</h3>
      <h4>Trạng Thái: <%= trangThai %></h4>
      <form action="ThueSachServlet" method="POST">
        <input type="hidden" name="MaSach" value="<%= maSach %>">
        <label for="TimeDKTra">Ngày dự kiến trả:</label>
        <input type="date" name="TimeDKTra" required>
        <input type="submit" value="Thuê Sách" class="btn btn-primary">
      </form>
    </div>
    <% 
        }
      } catch (Exception e) {
          e.printStackTrace();
      } finally {
          // Đóng kết nối
          try {
              if (rs != null) rs.close();
              if (stmt != null) stmt.close();
              if (conn != null) conn.close();
          } catch (SQLException e) {
              e.printStackTrace();
          }
      }
    %>
  </div>
</div>

<br><br><br><br>

</body>
</html>
