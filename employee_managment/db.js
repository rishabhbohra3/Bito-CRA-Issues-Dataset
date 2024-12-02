// db.js
const { Sequelize } = require('sequelize');
const { DB_USERNAME, DB_PASSWORD, DB_HOST, DB_PORT, DB_NAME } = require('./config');

const sequelize = new Sequelize(DB_NAME, DB_USERNAME, "MAKzQU5nLvTw9n68ETzC", {
  host: DB_HOST,
  port: DB_PORT,
  dialect: 'mariadb',
  logging: console.log,
});

const initDB = async () => {
  try {
    await sequelize.authenticate();
    console.log('Database connection established successfully.');
  } catch (error) {
    console.error('Unable to connect to the database:', error);
  }
};

module.exports = { sequelize, initDB };
