-- DROP TABLES IF ALREADY EXIST
DROP TABLE IF EXISTS titles CASCADE;
DROP TABLE IF EXISTS departments CASCADE;
DROP TABLE IF EXISTS employees CASCADE;
DROP TABLE IF EXISTS salaries CASCADE;
DROP TABLE IF EXISTS dept_managers CASCADE;
DROP TABLE IF EXISTS dept_employees CASCADE;


-- CREATE TABLES
CREATE TABLE titles (
	title_id VARCHAR(10) NOT NULL,
	title VARCHAR(20) NOT NULL,
	PRIMARY KEY (title_id)
);

CREATE TABLE employees (
	emp_no INTEGER NOT NULL,
	emp_title_id VARCHAR(10) NOT NULL,
	birth_date DATE NOT NULL,
	first_name VARCHAR (20) NOT NULL,
	last_name VARCHAR (20) NOT NULL,
	sex VARCHAR (20) NOT NULL,
	hire_date DATE NOT NULL,
	PRIMARY KEY (emp_no),
	FOREIGN KEY (emp_title_id) REFERENCES titles (title_id)
);

CREATE TABLE departments (
	dept_no VARCHAR(10) NOT NULL,
	dept_name VARCHAR (30) NOT NULL,
	PRIMARY KEY (dept_no)
);

CREATE TABLE salaries (
	emp_no INTEGER NOT NULL,
	salary INTEGER NOT NULL,
	PRIMARY KEY (emp_no),
	FOREIGN KEY (emp_no) REFERENCES employees (emp_no)
);

CREATE TABLE dept_employees (
	emp_no INTEGER NOT NULL,
	dept_no VARCHAR(10) NOT NULL,
	PRIMARY KEY (emp_no, dept_no),
	FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
	FOREIGN KEY (dept_no) REFERENCES departments (dept_no)
);
	
CREATE TABLE dept_managers (
	dept_no VARCHAR(10) NOT NULL,
	emp_no INTEGER NOT NULL,
	PRIMARY KEY (dept_no, emp_no),
	FOREIGN KEY (dept_no) REFERENCES departments (dept_no),
	FOREIGN KEY (emp_no) REFERENCES employees (emp_no)
);

-- CHECK DATA
SELECT * FROM titles;
SELECT * FROM employees;
SELECT * FROM departments;
SELECT * FROM salaries;
SELECT * FROM dept_employees;
SELECT * FROM dept_managers;


--1. List employee number, last name, first name, sex, and salary of each employee.
SELECT employees.emp_no, 
	employees.first_name, 
	employees.last_name, 
	employees.sex,
	salaries.salary
FROM employees
JOIN salaries ON
	employees.emp_no = salaries.emp_no;

--2.List first name, last name, and hire date for the employees, hired in 1986.
SELECT first_name,
	last_name,
	hire_date
FROM employees
WHERE hire_date between '1986-01-01' and '1986-01-31';


--3.List each manager's department number, department name, employee number, last name, and first name 
SELECT dept_managers.dept_no,
	departments.dept_name,
	dept_managers.emp_no,
	employees.first_name, 
	employees.last_name
FROM dept_managers
INNER JOIN departments ON
	dept_managers.dept_no = departments.dept_no
INNER JOIN employees ON
	dept_managers.emp_no = employees.emp_no;
	
--4. List each employee's department number, employee number, last name, first name, and department name.
SELECT dept_employees.dept_no,
	dept_employees.emp_no,
	employees.first_name, 
	employees.last_name,
	departments.dept_name
FROM dept_employees
INNER JOIN employees ON
	dept_employees.emp_no = employees.emp_no
INNER JOIN departments ON
	dept_employees.dept_no = departments.dept_no;


--5. List first name, last name, and sex of each employee 
--whose first name is Hercules 
--and whose last name begins with the letter B.

SELECT first_name,
	last_name,
	sex
FROM employees
WHERE first_name = 'Hercules' 
AND last_name LIKE 'B%';


--6.List each employee in the Sales department, including their employee number, last name, and first name.
SELECT dept_employees.emp_no,
	employees.first_name, 
	employees.last_name,
	departments.dept_name
FROM dept_employees
INNER JOIN employees ON
	dept_employees.emp_no = employees.emp_no
INNER JOIN departments ON
	dept_employees.dept_no = departments.dept_no
WHERE dept_name = 'Sales';

--7.List each employee in the Sales and Development departments, including their employee number, last name, first name, and department name.
SELECT dept_employees.emp_no,
	employees.first_name, 
	employees.last_name,
	departments.dept_name
FROM dept_employees
INNER JOIN employees ON
	dept_employees.emp_no = employees.emp_no
INNER JOIN departments ON
	dept_employees.dept_no = departments.dept_no
WHERE dept_name = 'Sales' 
OR dept_name ='Development';


--8.List the frequency counts, in descending order, of all the employee last names
--how many employees share each last name.
SELECT last_name,
COUNT(last_name) AS "name count"
FROM employees
GROUP BY last_name
ORDER BY "name count" DESC;