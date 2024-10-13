<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.Base64" %>
<%@ page import="java.net.URLEncoder" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.net.URLEncoder" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Cart Page</title>
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
            margin-bottom: 20px; /* Add margin bottom for spacing between items */
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
            background-color: white;
            color: black;
            font-weight: bold;
            text-decoration: none;
            border-radius: 4px;
            transition: background-color 0.3s ease;
        }

        .delete-link:hover {
            background-color: #0056b3;
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

        .item-total {
            position: absolute;
            bottom: 10px;
            right: 10px;
            padding: 6px;
            background-color: rgba(0, 0, 0, 0.7);
            color: #fff;
            border-radius: 4px;
            font-size: 14px;
        }

        .quantity-controls {
            display: flex;
            justify-content: center;
            align-items: center;
            margin-top: 10px;
        }

        .quantity-controls .minus-icon {
            padding: 5px;
            margin-right: 5px;
            background-color: #007bff;
            color: #fff;
            border: none;
            border-radius: 4px;
            cursor: pointer;
        }

        .quantity-controls .minus-icon:hover {
            background-color: #0056b3;
        }

        .quantity-display {
            padding: 5px 10px;
            border: 1px solid #ccc;
            border-radius: 4px;
            font-size: 14px;
        }

        .buy-now-link {
            position: absolute;
            top: -5px;
            right: 220px;
            display: inline;
            margin-top: 15px; /* Adjust margin as needed */
            padding: 8px 12px;
            background-color: #007bff;
            color: #fff;
            text-decoration: none;
            border-radius: 4px;
            transition: background-color 0.3s ease;
        }

        .buy-now-link:hover {
            background-color: #0056b3;
        }

        .buy-all-link {
            position: fixed;
            bottom: 20px;
            right: 20px;
            padding: 10px 20px;
            background-color: #007bff;
            color: #fff;
            text-decoration: none;
            border-radius: 4px;
            transition: background-color 0.3s ease;
            z-index: 999;
        }

        .buy-all-link:hover {
            background-color: #0056b3;
        }
    </style>
</head>
<body>
    <h2 style="text-align: center;">Cart Page</h2>
    <div class="image-container">
        <% 
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        double totalAmount = 0.0;

        try {
            // Establish database connection (adjust URL, username, and password)
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            
            conn = DriverManager.getConnection("jdbc:sqlserver://SRI\\SQLExpress;encrypt=false;databaseName=connection;integratedSecurity=true;portNumber=1433;");

            // SQL statement to retrieve imageSrc, price, quantity, and total amount from images2 table
            String sql = "SELECT image_source, price, quantity FROM images2";
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();

            // Loop through result set and store each product's details
            while (rs.next()) {
                String imageUrl = rs.getString("image_source");
                double price = rs.getDouble("price");
                int quantity = rs.getInt("quantity");

                // Calculate total amount for each product
                double productTotal = price * quantity;
                totalAmount += productTotal;
        %>
        <div class="image-item" id="image_<%= imageUrl %>" style="<%= quantity <= 0 ? "display: none;" : "" %>">
            <img src="<%= imageUrl %>" alt="Image">
            <span class="image-price">₹ <%= price %> × <%= quantity %></span>
            <span class="item-total">Total: ₹ <%= productTotal %></span>
           
             <a href="updateQuantity.jsp?imageSrc=<%= URLEncoder.encode(imageUrl, "UTF-8") %>" class="delete-link" onclick="return confirm('Are you sure you want to delete this image?')">-</a>
        	<br> <!-- Add a line break for separation -->
            <a href="Payment.jsp?imageSrc=<%= URLEncoder.encode(imageUrl, "UTF-8") %>&quantity=<%= quantity %>&totalAmount=<%= productTotal %>" class="buy-now-link">Buy Now</a>
        	
        </div>
        
        <% 
            }
        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
            out.println("Error retrieving images from database: " + e.getMessage());
        } catch (UnsupportedEncodingException e) {
            e.printStackTrace();
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

    <!-- Display total amount -->
    <div class="total-amount">
        Total Amount: ₹ <%= totalAmount %>
    </div>

    <!-- Link to buy all items -->
    <a href="Payment.jsp?totalAmount=<%= totalAmount %>" class="buy-all-link">Buy All</a>

    <script>
        function decrementQuantity(imageUrl) {
            var quantityElement = document.getElementById("quantity_" + imageUrl);
            var currentQuantity = parseInt(quantityElement.textContent);
            if (currentQuantity > 0) {
                currentQuantity--;
                quantityElement.textContent = currentQuantity;

                // Optionally, update the hidden input field quantity
                var hiddenInput = document.querySelector('input[name="imageSrc"][value="' + encodeURIComponent(imageUrl) + '"]');
                if (hiddenInput) {
                    hiddenInput.value = encodeURIComponent(imageUrl) + "&quantity=" + currentQuantity;
                }

                // Update visibility of image-item based on quantity
                var imageItem = document.getElementById("image_" + imageUrl);
                if (currentQuantity <= 0) {
                    imageItem.style.display = "none";
                }
            }
        }
    </script>
</body>
</html>
