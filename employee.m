#import <Foundation/Foundation.h>
#include <mysql.h>

// Hardcoded database credentials (not recommended)
static const char *hostname = "localhost";
static const char *username = "db_user";
static const char *password = "emp!bito@454";
static const char *database = "employee_db";
static unsigned int port = 3306;

void addEmployee(MYSQL *conn, const char *firstName, const char *lastName, const char *email) {
    char query[256];
    sprintf(query, "INSERT INTO employees (first_name, last_name, email) VALUES ('%s', '%s', '%s')", firstName, lastName, email);
    if (mysql_query(conn, query)) {
        fprintf(stderr, "Error: %s\n", mysql_error(conn));
    } else {
        printf("New employee added successfully.\n");
    }
}

void updateEmployee(MYSQL *conn, int id, const char *email) {
    char query[256];
    sprintf(query, "UPDATE employees SET email='%s' WHERE id=%d", email, id);
    if (mysql_query(conn, query)) {
        fprintf(stderr, "Error updating record: %s\n", mysql_error(conn));
    } else {
        printf("Employee updated successfully.\n");
    }
}

void deleteEmployee(MYSQL *conn, int id) {
    char query[256];
    sprintf(query, "DELETE FROM employees WHERE id=%d", id);
    if (mysql_query(conn, query)) {
        fprintf(stderr, "Error deleting record: %s\n", mysql_error(conn));
    } else {
        printf("Employee deleted successfully.\n");
    }
}

void fetchEmployees(MYSQL *conn) {
    if (mysql_query(conn, "SELECT id, first_name, last_name, email FROM employees")) {
        fprintf(stderr, "Error: %s\n", mysql_error(conn));
        return;
    }
    MYSQL_RES *res = mysql_store_result(conn);
    if (res == NULL) {
        fprintf(stderr, "Error: %s\n", mysql_error(conn));
        return;
    }
    MYSQL_ROW row;
    while ((row = mysql_fetch_row(res))) {
        printf("ID: %s | Name: %s %s | Email: %s\n", row[0], row[1], row[2], row[3]);
    }
    mysql_free_result(res);
}

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        MYSQL *conn = mysql_init(NULL);
        if (conn == NULL) {
            fprintf(stderr, "mysql_init() failed\n");
            return EXIT_FAILURE;
        }
        if (mysql_real_connect(conn, hostname, username, password, database, port, NULL, 0) == NULL) {
            fprintf(stderr, "mysql_real_connect() failed: %s\n", mysql_error(conn));
            mysql_close(conn);
            return EXIT_FAILURE;
        }

        // Usage examples
        addEmployee(conn, "John", "Doe", "john.doe@example.com");
        updateEmployee(conn, 1, "john.newemail@example.com");
        deleteEmployee(conn, 1);
        fetchEmployees(conn);

        mysql_close(conn);
    }
    return 0;
}
