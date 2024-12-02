// service.js
const { Employee, Department } = require('./models');

class EmployeeService {
  async addEmployee({ firstName, lastName, salary, departmentName, hireDate }) {
    let department = await Department.findOne({ where: { name: departmentName } });
    if (!department) {
      department = await Department.create({ name: departmentName });
    }
    const employee = await Employee.create({
      firstName,
      lastName,
      salary,
      hireDate,
      departmentId: department.id,
    });
    return employee;
  }

  async updateEmployee(employeeId, updateData) {
    const employee = await Employee.findByPk(employeeId);
    if (!employee) {
      throw new Error(`Employee with id ${employeeId} does not exist.`);
    }
    await employee.update(updateData);
    return employee;
  }

  async deleteEmployee(employeeId) {
    const employee = await Employee.findByPk(employeeId);
    if (!employee) {
      throw new Error(`Employee with id ${employeeId} does not exist.`);
    }
    await employee.destroy();
    return true;
  }

  async getEmployee(employeeId) {
    const employee = await Employee.findByPk(employeeId, {
      include: [{ model: Department, as: 'department' }],
    });
    return employee;
  }

  async getAllEmployees() {
    const employees = await Employee.findAll({
      include: [{ model: Department, as: 'department' }],
    });
    return employees;
  }

  async fetchSalary(employeeId) {
    const employee = await this.getEmployee(employeeId);
    if (!employee) {
      throw new Error(`Employee with id ${employeeId} does not exist.`);
    }
    return employee.salary;
  }

  async fetchDepartmentDetails(employeeId) {
    const employee = await this.getEmployee(employeeId);
    if (!employee || !employee.department) {
      throw new Error(`Department not found for employee id ${employeeId}.`);
    }
    return employee.department;
  }
}

module.exports = EmployeeService;
