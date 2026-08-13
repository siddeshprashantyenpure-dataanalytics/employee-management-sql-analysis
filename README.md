# Employee Management & Salary Analysis using MySQL

![MySQL](https://img.shields.io/badge/Database-MySQL-4479A1?style=for-the-badge&logo=mysql&logoColor=white)
![SQL](https://img.shields.io/badge/Language-SQL-CC2927?style=for-the-badge)
![Data Analytics](https://img.shields.io/badge/Field-Data%20Analytics-2E8B57?style=for-the-badge)
![MySQL Workbench](https://img.shields.io/badge/Tool-MySQL%20Workbench-00758F?style=for-the-badge)

---

## 📌 Project Overview

**Employee Management & Salary Analysis using MySQL** is a comprehensive SQL-based Data Analytics project developed to demonstrate practical knowledge of SQL, relational databases, data analysis, and advanced SQL techniques.

The project uses multiple related tables containing information about employees, departments, managers, projects, employee-project assignments, and salary history.

The project contains **80+ SQL queries**, starting from basic SQL operations and progressing to advanced SQL concepts such as:

- Joins
- Self Joins
- Subqueries
- CTEs
- Window Functions
- Salary Analysis
- Date and Time Analysis
- Conditional Logic
- Employee-Manager Analysis
- Project Analysis
- Salary History Analysis

The primary objective is to solve real-world business questions using SQL and generate a final employee-level analytical report.

---

# 🎯 Project Objectives

The main objectives of this project are:

- Analyze employee information.
- Analyze employee salaries.
- Analyze salary history.
- Calculate salary increments.
- Analyze employee-manager relationships.
- Identify employees without managers.
- Analyze employee project assignments.
- Identify employees without project assignments.
- Identify projects without employees.
- Analyze department-level salary information.
- Find employees earning above average salary.
- Find highest and second-highest salaries.
- Find top-paid employees in each department.
- Rank employees based on salary.
- Compare employee salaries with manager salaries.
- Identify duplicate salary values.
- Categorize employees based on salary.
- Analyze employee salary growth.
- Practice advanced SQL concepts.
- Create a comprehensive employee analytical report.

---

# 🏢 Business Problem

Organizations maintain large amounts of employee-related data.

However, raw employee data alone does not provide meaningful business insights.

SQL can be used to transform this data into useful information for management and decision-making.

This project answers business questions such as:

- Which employees earn more than the average salary?
- Which employee has the highest salary?
- What is the second-highest salary?
- Which department has the highest average salary?
- Who are the top 3 highest-paid employees in each department?
- Which employees earn more than their managers?
- Which employees have no manager?
- Which employees have no project assignment?
- Which projects have no employees?
- Which employees are assigned to multiple projects?
- Which employees work on projects belonging to another department?
- How much does each department spend on salaries?
- How has employee salary changed over time?
- Which employees received salary increases?
- Which employees consistently received salary increases?
- What is each employee's salary rank within their department?
- How can employees be categorized based on salary?

---

# 🗄️ Database Information

| Property | Details |
|---|---|
| Database | MySQL |
| Tool | MySQL Workbench |
| Language | SQL |
| Project Type | Data Analytics |
| Number of Queries | 80+ |
| Main Domain | Employee & Salary Analysis |

---

# 📊 Database Tables

The project consists of the following tables:

| Table | Description |
|---|---|
| `employees` | Stores employee information including salary, department and manager |
| `departments` | Stores department information |
| `projects` | Stores project information and project department |
| `employee_projects` | Stores employee-project assignments |
| `salary_history` | Stores historical salary information |

---

# 🧩 Database Schema

```text
                         ┌──────────────────┐
                         │   departments    │
                         └────────┬─────────┘
                                  │
                           department_id
                                  │
                                  ▼
                         ┌──────────────────┐
                         │    employees     │
                         └───────┬──────────┘
                              ┌──┼──┐
                              │  │  │
                              │  │  │
                              ▼  ▼  ▼
                  ┌─────────────────────┐
                  │ employee_projects   │
                  └──────────┬──────────┘
                             │
                         project_id
                             │
                             ▼
                    ┌────────────────┐
                    │    projects    │
                    └────────────────┘

                    employees
                       │
                    manager_id
                       │
                       ▼
                    employees
                    (Self JOIN)

                    employees
                       │
                  employee_id
                       │
                       ▼
                 salary_history
