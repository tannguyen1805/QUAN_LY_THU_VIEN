<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Đăng Nhập</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            background: url('/QL_Thu_Vien/images/background.jpg');
            background-size: cover;
        }
        .overlay {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0, 0, 0, 0.5); /* Lớp phủ mờ */
            z-index: -1;
        }
        .container {
            background: rgba(255, 255, 255, 0.9);
            padding: 20px 40px;
            border-radius: 10px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.3);
            width: 350px;
            z-index: 1;
        }
        h1 {
            text-align: center;
            color: #333;
        }
        label {
            font-weight: bold;
            display: block;
            margin-top: 10px;
        }
        input[type="text"], input[type="password"] {
            width: 85%;
            padding: 10px;
            margin-top: 5px;
            border: 1px solid #ccc;
            border-radius: 5px;
            display: block;
            margin-left: auto; /* Căn giữa */
            margin-right: auto;
        }
        input[type="submit"] {
            background-color: #4CAF50;
            color: white;
            border: none;
            border-radius: 5px;
            padding: 15px 15px;
            cursor: pointer;
            width: 80%;
            margin-top: 20px;
            font-size: 16px;
            display: block;
            margin-left: auto; /* Căn giữa */
            margin-right: auto;
        }
        input[type="submit"]:hover {
            background-color: #45a049;
        }
        .register {
            text-align: center;
            margin-top: 10px;
        }
        .register a {
            color: #4CAF50;
            text-decoration: none;
            font-weight: bold;
        }
        .register a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>
    <div class="overlay"></div>
    <div class="container">
        <h1>Đăng Nhập</h1>
        <form action="LoginServlet" method="post">
            <label>Tài Khoản:</label>
            <input type="text" name="username" required/>
            <label>Mật Khẩu:</label>
            <input type="password" name="password" required/>
            <input type="submit" value="Đăng Nhập"/>
        </form>
        <div class="register">
            <p>Chưa có tài khoản? <a href="Dangky.jsp">Đăng ký</a></p>
        </div>
    </div>
</body>
</html>
