from db import Session
from models import Employee, Department
from sqlalchemy.orm.exc import NoResultFound

class EmployeeService:
    def __init__(self):
        self.session = Session()

    def add_employee(self, first_name, last_name, salary, department_name, hire_date):
        department = self.session.query(Department).filter_by(name=department_name).first()
        if not department:
            department = Department(name=department_name)
            self.session.add(department)
            self.session.commit()
        employee = Employee(first_name=first_name, last_name=last_name, salary=salary,
                            department=department, hire_date=hire_date)
        self.session.add(employee)
        self.session.commit()
        return employee

    def update_employee(self, employee_id, **kwargs):
        employee = self.session.query(Employee).filter_by(id=employee_id).first()
        if not employee:
            raise NoResultFound(f"Employee with id {employee_id} does not exist.")
        for key, value in kwargs.items():
            if hasattr(employee, key):
                setattr(employee, key, value)
        self.session.commit()
        return employee

    def delete_employee(self, employee_id):
        employee = self.session.query(Employee).filter_by(id=employee_id).first()
        if not employee:
            raise NoResultFound(f"Employee with id {employee_id} does not exist.")
        self.session.delete(employee)
        self.session.commit()
        return True

    def get_employee(self, employee_id):
        employee = self.session.query(Employee).filter_by(id=employee_id).first()
        return employee

    def get_all_employees(self):
        return self.session.query(Employee).all()

    def fetch_salary(self, employee_id):
        employee = self.get_employee(employee_id)
        if employee:
            return employee.salary
        else:
            raise NoResultFound(f"Employee with id {employee_id} does not exist.")

    def fetch_department_details(self, employee_id):
        employee = self.get_employee(employee_id)
        if employee and employee.department:
            return employee.department
        else:
            raise NoResultFound(f"Department not found for employee id {employee_id}.")
