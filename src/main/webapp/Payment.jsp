<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Payment Page</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f0f0f0;
            padding: 20px;
        }

        .payment-form {
            max-width: 500px;
            margin: 0 auto;
            background-color: #fff;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        }

        .form-group {
            margin-bottom: 15px;
        }

        .form-group label {
            display: block;
            margin-bottom: 5px;
            font-weight: bold;
        }

        .form-group input[type="text"], 
        .form-group input[type="email"], 
        .form-group input[type="number"],
        .form-group select {
            width: 100%;
            padding: 8px;
            font-size: 14px;
            border: 1px solid #ccc;
            border-radius: 4px;
        }

        .form-group button {
            padding: 10px 20px;
            font-size: 16px;
            background-color: #007bff;
            color: #fff;
            border: none;
            border-radius: 4px;
            cursor: pointer;
        }

        .form-group button:hover {
            background-color: #0056b3;
        }

        .error-message {
            color: red;
            font-size: 14px;
            margin-top: 5px;
        }

        .total-amount {
            font-size: 18px;
            font-weight: bold;
            margin-bottom: 15px;
        }
    </style>
</head>
<body>
    <h2 style="text-align: center;">Payment Details</h2>
    <div class="payment-form">
        <%-- Display total amount received from cart.jsp --%>
        <div class="total-amount">
            Total Amount: ₹ <%= request.getParameter("totalAmount") %>
        </div>

        <form action="process_payment.jsp" method="post" onsubmit="return validateForm()">
            <div class="form-group">
                <label for="name">Name on Card</label>
                <input type="text" id="name" name="name" required>
                <div id="nameError" class="error-message"></div>
            </div>
            <div class="form-group">
                <label for="cardNumber">Card Number</label>
                <input type="text" id="cardNumber" name="cardNumber" required>
                <div id="cardNumberError" class="error-message"></div>
            </div>
            <div class="form-group">
                <label for="expiry">Expiry Date</label>
                <input type="text" id="expiry" name="expiry" placeholder="MM/YYYY" required>
                <div id="expiryError" class="error-message"></div>
            </div>
            <div class="form-group">
                <label for="cvv">CVV</label>
                <input type="text" id="cvv" name="cvv" maxlength="3" required>
                <div id="cvvError" class="error-message"></div>
            </div>
            <div class="form-group">
                <label for="paymentMethod">Payment Method</label>
                <select id="paymentMethod" name="paymentMethod" required>
                    <option value="">Select Payment Method</option>
                    <option value="creditCard">Credit Card</option>
                    <option value="debitCard">Debit Card</option>
                </select>
                <div id="paymentMethodError" class="error-message"></div>
            </div>
            <div class="form-group">
                <button type="submit">Pay Now</button>
            </div>
        </form>
    </div>

    <script>
        function validateForm() {
            var name = document.getElementById("name").value.trim();
            var cardNumber = document.getElementById("cardNumber").value.trim();
            var expiry = document.getElementById("expiry").value.trim();
            var cvv = document.getElementById("cvv").value.trim();
            var paymentMethod = document.getElementById("paymentMethod").value.trim();

            var isValid = true;

            // Reset errors
            document.getElementById("nameError").innerHTML = "";
            document.getElementById("cardNumberError").innerHTML = "";
            document.getElementById("expiryError").innerHTML = "";
            document.getElementById("cvvError").innerHTML = "";
            document.getElementById("paymentMethodError").innerHTML = "";

            // Name validation
            if (name === "") {
                document.getElementById("nameError").innerHTML = "Name on card is required";
                isValid = false;
            }

            // Card number validation (basic example, validate as per your needs)
            if (cardNumber === "" || isNaN(cardNumber)) {
                document.getElementById("cardNumberError").innerHTML = "Please enter a valid card number";
                isValid = false;
            }

            // Expiry date validation (basic example, validate as per your needs)
            if (expiry === "" || !isValidExpiry(expiry)) {
                document.getElementById("expiryError").innerHTML = "Please enter a valid expiry date (MM/YYYY)";
                isValid = false;
            }

            // CVV validation (basic example, validate as per your needs)
            if (cvv === "" || isNaN(cvv) || cvv.length !== 3) {
                document.getElementById("cvvError").innerHTML = "Please enter a valid CVV";
                isValid = false;
            }

            // Payment method validation
            if (paymentMethod === "") {
                document.getElementById("paymentMethodError").innerHTML = "Please select a payment method";
                isValid = false;
            }

            return isValid;
        }

        function isValidExpiry(expiry) {
            var pattern = /^(0[1-9]|1[0-2])\/\d{4}$/;
            return pattern.test(expiry);
        }
        
       

    </script>
</body>
</html>
