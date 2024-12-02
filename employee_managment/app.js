// app.js
const express = require('express');
const bodyParser = require('body-parser');
const EmployeeService = require('./service');
const { initDB } = require('./db');
const { syncModels } = require('./models');

const app = express();
app.use(bodyParser.json());

const employeeService = new EmployeeService();

(async () => {
  await initDB();
  await syncModels();
})();

// Routes
app.post('/employees', async (req, res) => {
  const requiredFields = ['firstName', 'lastName', 'salary', 'departmentName', 'hireDate'];
  const data = req.body;
  if (!requiredFields.every((field) => field in data)) {
    return res.status(400).json({ error: 'Missing fields' });
  }
  try {
    const employee = await employeeService.addEmployee(data);
    res.status(201).json({ message: 'Employee added', employeeId: employee.id });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

app.put('/employees/:employeeId', async (req, res) => {
  const { employeeId } = req.params;
  const data = req.body;
  try {
    await employeeService.updateEmployee(employeeId, data);
    res.status(200).json({ message: 'Employee updated' });
  } catch (error) {
    res.status(error.message.includes('does not exist') ? 404 : 500).json({ error: error.message });
  }
});

app.delete('/employees/:employeeId', async (req, res) => {
  const { employeeId } = req.params;
  try {
    await employeeService.deleteEmployee(employeeId);
    res.status(200).json({ message: 'Employee deleted' });
  } catch (error) {
    res.status(error.message.includes('does not exist') ? 404 : 500).json({ error: error.message });
  }
});

app.get('/employees/:employeeId/salary', async (req, res) => {
  const { employeeId } = req.params;
  try {
    const salary = await employeeService.fetchSalary(employeeId);
    res.status(200).json({ employeeId, salary });
  } catch (error) {
    res.status(error.message.includes('does not exist') ? 404 : 500).json({ error: error.message });
  }
});

app.get('/employees/:employeeId/department', async (req, res) => {
  const { employeeId } = req.params;
  try {
    const department = await employeeService.fetchDepartmentDetails(employeeId);
    res.status(200).json({ employeeId, department: department.name });
  } catch (error) {
    res.status(error.message.includes('not found') ? 404 : 500).json({ error: error.message });
  }
});

app.get('/employees/:employeeId', async (req, res) => {
  const { employeeId } = req.params;
  const employee = await employeeService.getEmployee(employeeId);
  if (employee) {
    res.status(200).json({
      id: employee.id,
      firstName: employee.firstName,
      lastName: employee.lastName,
      salary: employee.salary,
      department: employee.department ? employee.department.name : null,
      hireDate: employee.hireDate,
    });
  } else {
    res.status(404).json({ error: 'Employee not found' });
  }
});

app.get('/employees', async (req, res) => {
  const employees = await employeeService.getAllEmployees();
  res.status(200).json(
    employees.map((e) => ({
      id: e.id,
      firstName: e.firstName,
      lastName: e.lastName,
      salary: e.salary,
      department: e.department ? e.department.name : null,
      hireDate: e.hireDate,
    }))
  );
});

// Start the server
const PORT = process.env.PORT || 5000;
app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});
