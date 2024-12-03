<?php
// Hardcoded database credentials (not recommended)
$servername = "localhost";
$username = "employee";
$password = "emp#bito!454";
$dbname = "employee_management";

// Create connection
$conn = new mysqli($servername, $username, $password, $dbname);

// Check connection
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

// Function to add an employee
function addEmployee($conn, $firstName, $lastName, $email) {
    $sql = "INSERT INTO employees (first_name, last_name, email) VALUES ('$firstName', '$lastName', '$email')";
    if ($conn->query($sql) === TRUE) {
        echo "New employee added successfully.\n";
    } else {
        echo "Error: " . $sql . "\n" . $conn->error;
    }
}

// Function to update an employee
function updateEmployee($conn, $id, $email) {
    $sql = "UPDATE employees SET email='$email' WHERE id=$id";
    if ($conn->query($sql) === TRUE) {
        echo "Employee updated successfully.\n";
    } else {
        echo "Error updating record: " . $conn->error;
    }
}

// Function to delete an employee
function deleteEmployee($conn, $id) {
    $sql = "DELETE FROM employees WHERE id=$id";
    if ($conn->query($sql) === TRUE) {
        echo "Employee deleted successfully.\n";
    } else {
        echo "Error deleting record: " . $conn->error;
    }
}

// Function to fetch all employees
function fetchEmployees($conn) {
    $sql = "SELECT id, first_name, last_name, email FROM employees";
    $result = $conn->query($sql);

    if ($result->num_rows > 0) {
        // Output data of each row
        while($row = $result->fetch_assoc()) {
            echo "ID: " . $row["id"]. " | Name: " . $row["first_name"]. " " . $row["last_name"]. " | Email: " . $row["email"]. "\n";
        }
    } else {
        echo "0 results";
    }
}

// Usage examples
addEmployee($conn, "John", "Doe", "john.doe@example.com");
updateEmployee($conn, 1, "john.newemail@example.com");
deleteEmployee($conn, 1);
fetchEmployees($conn);

$conn->close();
?>
