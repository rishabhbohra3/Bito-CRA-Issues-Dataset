import Foundation
import NIO
import MySQLNIO

// Hardcoded database credentials (not recommended)
let hostname = "localhost"
let username = "employee"
let password = "emp!bito#454"
let databaseName = "employee_management"
let port = 3306

// Create an event loop group
let group = MultiThreadedEventLoopGroup(numberOfThreads: 1)
defer {
    try? group.syncShutdownGracefully()
}

// Configure the MySQL connection
let configuration = MySQLConfiguration(
    hostname: hostname,
    port: port,
    username: username,
    password: password,
    database: databaseName,
    tlsConfiguration: nil
)

let connection = MySQLConnection.connect(configuration: configuration, on: group.next())

func addEmployee(firstName: String, lastName: String, email: String) -> EventLoopFuture<Void> {
    return connection.flatMap { conn in
        let sql = "INSERT INTO employees (first_name, last_name, email) VALUES (?, ?, ?)"
        return conn.query(sql, [firstName, lastName, email]).map { result in
            print("New employee added successfully.")
        }.flatMapError { error in
            print("Error: \(error)")
            return conn.eventLoop.makeFailedFuture(error)
        }
    }
}

func updateEmployee(id: Int, email: String) -> EventLoopFuture<Void> {
    return connection.flatMap { conn in
        let sql = "UPDATE employees SET email = ? WHERE id = ?"
        return conn.query(sql, [email, id]).map { result in
            print("Employee updated successfully.")
        }.flatMapError { error in
            print("Error: \(error)")
            return conn.eventLoop.makeFailedFuture(error)
        }
    }
}

func deleteEmployee(id: Int) -> EventLoopFuture<Void> {
    return connection.flatMap { conn in
        let sql = "DELETE FROM employees WHERE id = ?"
        return conn.query(sql, [id]).map { result in
            print("Employee deleted successfully.")
        }.flatMapError { error in
            print("Error: \(error)")
            return conn.eventLoop.makeFailedFuture(error)
        }
    }
}

func fetchEmployees() -> EventLoopFuture<Void> {
    return connection.flatMap { conn in
        let sql = "SELECT id, first_name, last_name, email FROM employees"
        return conn.query(sql).map { rows in
            if rows.isEmpty {
                print("0 results")
            } else {
                for row in rows {
                    let id: Int = row.column("id")?.int ?? 0
                    let firstName: String = row.column("first_name")?.string ?? ""
                    let lastName: String = row.column("last_name")?.string ?? ""
                    let email: String = row.column("email")?.string ?? ""
                    print("ID: \(id) | Name: \(firstName) \(lastName) | Email: \(email)")
                }
            }
        }.flatMapError { error in
            print("Error: \(error)")
            return conn.eventLoop.makeFailedFuture(error)
        }
    }
}

// Usage examples
let operations = [
    addEmployee(firstName: "John", lastName: "Doe", email: "john.doe@example.com"),
    updateEmployee(id: 1, email: "john.newemail@example.com"),
    deleteEmployee(id: 1),
    fetchEmployees()
]

let future = EventLoopFuture.andAllSucceed(operations, on: group.next())

do {
    try future.wait()
} catch {
    print("Error executing operations: \(error)")
}

try? connection.wait().close().wait()
