from flask import Flask, jsonify, request
from service import EmployeeService
from models import Employee, Department
from db import init_db
from sqlalchemy.orm.exc import NoResultFound
from datetime import datetime

app = Flask(__name__)
init_db()
employee_service = EmployeeService()

@app.route('/employees', methods=['POST'])
def add_employee():
    data = request.get_json()
    required_fields = ['first_name', 'last_name', 'salary', 'department_name', 'hire_date']
    if not all(field in data for field in required_fields):
        return jsonify({'error': 'Missing fields'}), 400
    try:
        hire_date = datetime.strptime(data['hire_date'], '%Y-%m-%d').date()
        employee = employee_service.add_employee(
            first_name=data['first_name'],
            last_name=data['last_name'],
            salary=data['salary'],
            department_name=data['department_name'],
            hire_date=hire_date
        )
        return jsonify({'message': 'Employee added', 'employee_id': employee.id}), 201
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/employees/<int:employee_id>', methods=['PUT'])
def update_employee(employee_id):
    data = request.get_json()
    try:
        employee = employee_service.update_employee(employee_id, **data)
        return jsonify({'message': 'Employee updated'}), 200
    except NoResultFound as e:
        return jsonify({'error': str(e)}), 404
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/employees/<int:employee_id>', methods=['DELETE'])
def delete_employee(employee_id):
    try:
        employee_service.delete_employee(employee_id)
        return jsonify({'message': 'Employee deleted'}), 200
    except NoResultFound as e:
        return jsonify({'error': str(e)}), 404
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/employees/<int:employee_id>/salary', methods=['GET'])
def fetch_salary(employee_id):
    try:
        salary = employee_service.fetch_salary(employee_id)
        return jsonify({'employee_id': employee_id, 'salary': salary}), 200
    except NoResultFound as e:
        return jsonify({'error': str(e)}), 404

@app.route('/employees/<int:employee_id>/department', methods=['GET'])
def fetch_department_details(employee_id):
    try:
        department = employee_service.fetch_department_details(employee_id)
        return jsonify({'employee_id': employee_id, 'department': department.name}), 200
    except NoResultFound as e:
        return jsonify({'error': str(e)}), 404

@app.route('/employees/<int:employee_id>', methods=['GET'])
def get_employee(employee_id):
    employee = employee_service.get_employee(employee_id)
    if employee:
        return jsonify({
            'id': employee.id,
            'first_name': employee.first_name,
            'last_name': employee.last_name,
            'salary': employee.salary,
            'department': employee.department.name if employee.department else None,
            'hire_date': employee.hire_date.isoformat() if employee.hire_date else None
        }), 200
    else:
        return jsonify({'error': 'Employee not found'}), 404

@app.route('/employees', methods=['GET'])
def get_all_employees():
    employees = employee_service.get_all_employees()
    return jsonify([
        {
            'id': e.id,
            'first_name': e.first_name,
            'last_name': e.last_name,
            'salary': e.salary,
            'department': e.department.name if e.department else None,
            'hire_date': e.hire_date.isoformat() if e.hire_date else None
        } for e in employees
    ]), 200

if __name__ == '__main__':
    app.run(debug=True)
