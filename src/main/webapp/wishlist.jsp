<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.net.URLEncoder" %> <!-- Ensure this import is present -->

<!DOCTYPE html>
<html lang="en">
<head>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">    
 <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
  
    <meta charset="UTF-8">
    <title>Wishlist Page</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f0f0f0;
            padding: 20px;
        }

        .image-container {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 20px;
            justify-items: center;
        }

        .image-item {
            text-align: center;
            border-radius: 8px;
            overflow: hidden;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            height: 250px; /* Set a fixed height for the image item */
            position: relative; /* Relative positioning for absolute delete link */
        }

        .image-item img {
            max-width: 100%; /* Ensure the image fills its container */
            max-height: 100%; /* Ensure the image maintains aspect ratio */
            object-fit: cover; /* Scale the image while preserving aspect ratio */
            border-radius: 8px; /* Rounded corners for the image */
            height: 100%; /* Ensure the image takes up full height of the container */
            width: auto; /* Ensure the image width adjusts based on height */
        }

        .delete-link {
            position: absolute;
            top: 10px;
            right: 10px;
            padding: 8px 12px;
            background-color: #007bff;
            color: #fff;
            text-decoration: none;
            border-radius: 4px;
            transition: background-color 0.3s ease;
        }

        .delete-link:hover {
            background-color: #0056b3;
        }

        .add-to-cart {
            position: absolute;
            bottom: 10px;
            right: 10px;
            padding: 8px 12px;
            background-color: #28a745;
            color: #fff;
            text-decoration: none;
            border-radius: 4px;
            transition: background-color 0.3s ease;
        }

        .add-to-cart:hover {
            background-color: #218838;
        }

        .image-price {
            position: absolute;
            bottom: 10px;
            left: 10px;
            padding: 6px;
            background-color: rgba(0, 0, 0, 0.7);
            color: #fff;
            border-radius: 4px;
            font-size: 14px;
        }
    </style>
</head>
<body>
    <h2 style="text-align: center;">Wishlist Page</h2>
    <div class="image-container">
        <% 
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            // Establish database connection (adjust URL, username, and password)
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
        
           conn = DriverManager.getConnection("jdbc:sqlserver://SRI\\SQLExpress;encrypt=false;databaseName=connection;integratedSecurity=true;portNumber=1433;");

            // SQL statement to retrieve image_source and price from images3 table
            String sql = "SELECT id, image_source, price FROM images3";
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();

            // Loop through result set and display each image and price
            while (rs.next()) {
                int imageId = rs.getInt("id");
                String imageUrl = rs.getString("image_source");
                double price = rs.getDouble("price");
        %>
        <div class="image-item">
            <img src="<%= imageUrl %>" alt="Image">
            <span class="image-price">₹ <%= price %></span>
            <a href="deleteWishlist.jsp?imageId=<%= imageId %>" class="delete-link" onclick="return confirm('Are you sure you want to delete this image?')">Delete</a>
        <a href="insertImage.jsp?imageIdwish=<%= imageId %>&imageSrc=<%= URLEncoder.encode(imageUrl, "UTF-8") %>&price=<%= price %>" class="add-to-cart" onclick="return confirm('Are you sure you want to Add this image to cart?')"> <i class="fa fa-shopping-cart"></i> </a>
        
        
        
        
        </div>
        <% 
            }
        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
            out.println("Error retrieving images from database: " + e.getMessage());
        } finally {
            // Close resources
            if (rs != null) {
                try {
                    rs.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
            if (pstmt != null) {
                try {
                    pstmt.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
            if (conn != null) {
                try {
                    conn.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
        %>
    </div>
</body>
</html>
