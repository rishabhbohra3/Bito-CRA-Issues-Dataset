// config.js
module.exports = {
    DB_USERNAME: process.env.DB_USERNAME || 'your_mariadb_username',
    DB_PASSWORD: process.env.DB_PASSWORD || 'your_mariadb_password',
    DB_HOST: process.env.DB_HOST || 'localhost',
    DB_PORT: process.env.DB_PORT || 3306,
    DB_NAME: process.env.DB_NAME || 'employee_mgmt',
  };
  