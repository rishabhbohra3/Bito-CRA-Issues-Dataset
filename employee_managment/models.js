// models.js
const { DataTypes } = require('sequelize');
const { sequelize } = require('./db');

const Department = sequelize.define('Department', {
  name: {
    type: DataTypes.STRING(100),
    allowNull: false,
  },
});

const Employee = sequelize.define('Employee', {
  firstName: {
    type: DataTypes.STRING(100),
    allowNull: false,
  },
  lastName: {
    type: DataTypes.STRING(100),
    allowNull: false,
  },
  salary: {
    type: DataTypes.FLOAT,
    allowNull: false,
  },
  hireDate: {
    type: DataTypes.DATEONLY,
  },
});

// Associations
Department.hasMany(Employee, { foreignKey: 'departmentId', as: 'employees' });
Employee.belongsTo(Department, { foreignKey: 'departmentId', as: 'department' });

const syncModels = async () => {
  await sequelize.sync({ alter: true });
  console.log('All models were synchronized successfully.');
};

module.exports = { Employee, Department, syncModels };
