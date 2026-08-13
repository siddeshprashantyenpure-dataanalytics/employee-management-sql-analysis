-- Step 1: Database Creation 

create database Employee;
use Employee;

-- --------------------------------------------------------------------------------------------------------------------------------------
-- Step 2: Data Preprocessing

-- Check is any row has null or missing value since employee id, project id and role cannot be vacant 
describe employee_projects;
select * from employee_projects where employee_id is null or project_id is null or `role` is null or trim(employee_id) = '' or trim(project_id) = '' or trim(`role`) = '';

-- Check for duplicate attenadace id since every attendace should have unique id other features of table can be multiple
describe attendance;
select * from attendance group by attendance_id having count(attendance_id) > 1;

-- Every department should have unique id and name other features of table can be multiple
describe departments;
select * from departments group by department_id having count(department_id) > 1;
select * from departments group by department_id having count(department_name) > 1;

-- Every employee should have unique employee id other features of table can be multiple
describe employees;
select * from employees group by employee_id having count(employee_id) > 1;

-- Every project should have unique project id other features of table can be multiple
describe projects;
select * from projects;

-- -- Every salary should have unique salary id other features of table can be multiple
describe salary_history;
select * from salary_history;

-- ------------------------------------------------------------------------------------------------------------------------------------
-- A. Basic SELECT / WHERE

-- 1.Display all employees.
select * from employees;

-- 2.Display employee name and salary.
select first_name as Name,last_name as Surname,salary as Salary from employees;

-- 3.Find employees earning more than 60,000.
select * from employees where salary > 60000;

-- 4.Find employees from Pune.
select * from employees where city='Pune';

-- 5.Find employees hired after 2024-01-01.
select * from employees where hire_date > '2024-01-01';

-- 6.Find employees whose first name starts with 'A'.
select * from employees where first_name like 'A%';

-- 7.Display employees ordered by salary descending.
select * from employees order by salary desc;

-- 8.Find the top 5 highest-paid employees.
select * from employees order by salary desc limit 5;

-- 9.Find employees whose salary is between 40,000 and 80,000.
select * from employees where salary between 40000 and 80000;

-- 10.Count the total number of employees.
select count(employee_id) as `Total Employees` from employees;

-- ------------------------------------------------------------------------------------------------------------------------------------
-- B. GROUP BY / HAVING

-- 11.Count employees in each department.
select department_id as Department,count(employee_id) as Count from employees group by department_id;

-- 12.Find average salary by department.
select department_id as Department,round(avg(salary),2) as Avg_Dept_Sal from employees group by department_id;

-- 13.Find maximum salary in each department.
select department_id as Department,max(salary) as Max_Dept_Sal from employees group by department_id;

-- 14.Find departments having more than 4 employees.
select department_id as Department,count(employee_id) from employees group by department_id having count(employee_id) > 4;

-- 15.Find cities having more than 3 employees.
select city as City,count(employee_id) from employees group by city having count(employee_id) > 3;

-- 16.Find total salary expense by department.
select department_id as Department,sum(salary) as Total_Salary_Expense from employees group by department_id;

-- ------------------------------------------------------------------------------------------------------------------------------------
-- C. INNER JOIN

-- 17.Display each employee with their department name.
select e.first_name,e.last_name,d.department_name
from employees e
inner join departments d
on e.department_id = d.department_id;

-- 18.Display employee name, department name and location.
select e.first_name as Name,e.last_name as Surname,d.department_name as Department,d.location as Location
from employees e
inner join departments d
on e.department_id = d.department_id;

-- 19.Find employees working in the IT department.
select e.*,d.department_name
from employees e 
inner join departments  d
on d.department_name = 'IT' ;

-- 20.Find employees working in Pune departments.
select e.*,d.location
from employees e 
inner join departments  d
on d.location = 'Pune'
group by e.employee_id;

-- 21.Display employee name and manager ID.
select e.first_name as Name,e.last_name as Surname,d.manager_employee_id as Manager_ID
from employees e
inner join departments d
on e.department_id = d.department_id;

-- ------------------------------------------------------------------------------------------------------------------------------------
-- D. LEFT / RIGHT JOIN
-- 22.Display all employees including employees without a manager.
select e.employee_id,e.first_name,e.last_name,e.manager_id
from employees e
left join employees j
on e.manager_id = j.employee_id;

-- 23.Find departments that currently have no employees.
select d.department_name
from departments d
left join employees e
on d.department_id = e.department_id
where e.employee_id is null;

-- 24.Display all departments and their employee counts, including zero.
select d.department_name,count(e.employee_id) as Tally
from departments d
left join employees e
on d.department_id = e.department_id
group by e.department_id;

-- 25.Find employees who are not assigned to any project.
select e.first_name,e.last_name,p.project_name
from employees e
left join projects p
on e.department_id = p.department_id
where e.employee_id is null;

-- 26.Display all projects and assigned employees, including projects with no employees.
select p.*,ep.role,e.first_name,e.last_name
from projects p
right join employee_projects ep
on p.project_id = ep.project_id
right join employees e
on ep.employee_id = e.employee_id;

-- ------------------------------------------------------------------------------------------------------------------------------------
-- E. SELF JOIN
-- 27.Display each employee with their manager's name.
select e.employee_id,e.first_name as employee,m.manager_id,m.first_name as manager
from employees e
left join employees m
on e.manager_id = m.employee_id;

-- 28.Find employees who report to the same manager.
select e.first_name as Employee_Name,e.last_name as Employee_Surname,m.first_name as Manager_Name,m.last_name as Manager_Surname
from employees e
left join employees m
on e.manager_id = m.employee_id
where e.manager_id = 1;

-- 29.Find managers and the number of employees reporting to each manager.
select e.employee_id,e.first_name,count(m.employee_id) as Cnt
from employees e
left join employees m
on m.manager_id = e.employee_id
group by e.first_name,e.last_name,e.employee_id
having Cnt > 0 ;

-- 30.Display employee name, manager name and both salaries.
select e.first_name as Employee_Name,m.first_name as Manager_Name,e.salary as Employee_Salary,m.Salary as Manager_Salary
from employees e
left join employees m
on m.employee_id = e.manager_id
where m.first_name is not null;

-- ------------------------------------------------------------------------------------------------------------------------------------
-- F. MULTIPLE TABLE JOINS

-- 31.Display employee, department and project name.
select e.first_name as Emp_Name,d.department_name as Department,p.project_name as Project
from employees e 
left join departments d
on d.department_id = e.department_id
left join projects p
on d.department_id = p.department_id;

-- 32.Find employees working on projects belonging to their own department.
select e.first_name as Name,ep.project_id as Project_ID
from employees e
left join employee_projects ep
on e.employee_id = ep.employee_id
left join projects p
on ep.project_id = p.project_id
where e.department_id = p.department_id;

-- 33.Find the number of employees assigned to each project.
select p.project_name,count(e.employee_id) as Employee_Count
from projects p
left join employee_projects ep
on p.project_id = ep.project_id
left join employees e
on ep.employee_id = e.employee_id
group by p.project_id;

-- 34.Find departments with projects and employee counts.
select d.department_name as Department,p.project_id as ID,p.project_name as Project,count(e.employee_id) as Count
from departments d
left join projects p
on p.department_id = d.department_id
left join employee_projects ep
on p.project_id = ep.project_id
left join employees e 
on ep.employee_id = e.employee_id
group by p.project_id,d.department_name;

-- 35.Find employees working on more than one project.
select e.employee_id,count(ep.project_id)
from employees e
left join employee_projects ep
on e.employee_id = ep.employee_id
left join projects p
on p.project_id = ep.project_id
group by e.employee_id
having count(ep.project_id)  > 1;

-- ------------------------------------------------------------------------------------------------------------------------------------
-- G. SUBQUERIES

-- 36.Find employees earning more than the average salary.
select * from employees
where salary > (
	select avg(salary) from employees
);

-- 37.Find the highest-paid employee.
select * from employees
where salary = (
	select max(salary) from employees
);

-- 38.Find employees earning the maximum salary in their department.
select * from employees e
where e.salary = (
	select max(salary) from employees m 
    where m.department_id = e.department_id
)
order by e.department_id;

-- 39.Find employees working in the same department as 'Aarav'.
select * from employees
where department_id = (
	select department_id from employees where first_name = 'Aarav' group by first_name
);

-- 40.Find the second-highest salary.
select * from employees
where salary = (
	select max(salary) from employees 
    where salary < (
		select max(salary) from employees
    )
);

-- 41.Find departments whose average salary is above the company average.
select department_id from employees
group by department_id
having avg(salary) > (
	select avg(salary) from employees
);

-- ------------------------------------------------------------------------------------------------------------------------------------
-- H. CTEs
-- 42.Using a CTE, calculate average salary by department.
with average_salary as(
	select department_id,avg(salary) from employees group by department_id
)
select * from average_salary;

-- 43.Using a CTE, find the top 3 highest-paid employees in each department.
with top3 as(
	select first_name,last_name,salary,
    rank() over(partition by department_id order by salary desc) as salary_rank
	from employees
)
select * from top3 where salary_rank <= 3;

-- 44.Using a CTE, calculate department salary totals and rank departments.
with topdpt as(
	select department_id,sum(salary),
    rank() over(order by sum(salary) desc ) as Ranks
    from employees
    group by department_id
)
select * from topdpt order by Ranks;

-- 45.Using multiple CTEs, find departments with above-average salary and above-average headcount.

-- ------------------------------------------------------------------------------------------------------------------------------------
-- I. WINDOW FUNCTIONS
-- 46.Rank employees by salary using RANK().
select employee_id,first_name,last_name,salary,
rank() over(order by salary desc) as Rank_Emp
from employees;

-- 47.Rank employees by salary within each department.
select employee_id as ID,first_name as Name,last_name as Surname,salary as Salary,department_id as Department,
rank() over(partition by department_id order by salary desc) as Rank_Emp
from employees;

-- 48.Use DENSE_RANK() to find the top 3 salaries in each department.
with top3 as(
	select department_id as Department,salary as Salary,
	dense_rank() over(partition by department_id order by salary desc) as DenseRank
	from employees
)

select * from top3 where DenseRank <= 3;

-- 49.Use ROW_NUMBER() to number employees within each department.
select *,
row_number() over(partition by department_id order by employee_id)
from employees;

-- 50.Use LAG() to compare an employee's salary with the previous salary in their department.
select employee_id,
lag(salary) over(partition by employee_id order by salary) as Previous_Salary,
salary as Hiked_Salary,effective_date
from salary_history;

-- 51.Use LEAD() to compare an employee's salary with the next salary.
select employee_id,salary as Current_salary,
lead(salary) over(partition by employee_id order by effective_date) as Next_Salary,effective_date
from salary_history;

-- 52.Calculate a running total of salaries within each department.
select employee_id as ID,salary as Salary,department_id as Department,
sum(salary) over(partition by department_id order by employee_id) as Running_Total
from employees;

-- 53.Calculate each employee's percentage contribution to department salary.
select employee_id,salary,department_id as Department,
round((salary*100 / (sum(salary) over(partition by department_id)))) as Percent
from employees;

-- ------------------------------------------------------------------------------------------------------------------------------------
-- J. ADVANCED JOIN PRACTICE

-- 54.Find employees who are not assigned to any project using LEFT JOIN.
select e.employee_id,e.first_name as Name,e.last_name as Surname,ep.project_id,p.project_name
from employees e
left join employee_projects ep
on e.employee_id = ep.employee_id
left join projects p
on ep.project_id = p.project_id
where p.project_id is null
order by e.employee_id;

-- 55.Find projects with no employees using LEFT JOIN.
select p.project_name
from projects p
left join employee_projects ep
on p.project_id = ep.project_id
left join employees e
on ep.employee_id = e.employee_id
where e.employee_id is null;

-- 56.Find employees assigned to at least two projects.
select e.employee_id,count(ep.project_id) as Projects
from employees e
left join employee_projects ep
on e.employee_id = ep.employee_id
group by e.employee_id
having count(ep.project_id)  >= 2;

-- 57.Find departments with no projects.
select e.employee_id,count(ep.project_id) as Projects
from employees e
left join employee_projects ep
on e.employee_id = ep.employee_id
group by e.employee_id
having count(ep.project_id)  = 0;

-- 58.Find employees who have a project but the project belongs to another department.
select e.employee_id Employee_ID,e.department_id as Assigned_Department,p.department_id as Working_Department
from employees e
left join employee_projects ep
on e.employee_id = ep.employee_id
left join projects p
on ep.project_id = p.project_id
where e.department_id != p.department_id;

-- 59.Find the employee with the highest salary in every department.
with highest_salary as(
	select employee_id as ID,salary,department_id as Department,
    rank() over(partition by department_id order by salary desc) as Rank
    from employees
)
select ID,salary,Department from highest_salary where Rank = 1 group by Department

-- 60.Find the department with the highest average salary.
with highest_avg as(
	select department_id as Department,avg(salary) as Average_Salary
    from employees
    group by department_id
)
select Department,Average_Salary from highest_avg where Average_Salary = (select max(Average_Salary) from highest_avg);

-- ------------------------------------------------------------------------------------------------------------------------------------
-- K. DATE / CASE / BUSINESS QUESTIONS

-- 61.Categorize employees as Junior (<50K), Mid-level (50K–80K), or Senior (>80K).
select employee_id as ID,first_name as Name,last_name as Surname,salary as Salary,
case 
	when salary < 50000 then "Junior" 
    when salary between 50000 and 80000 then "Mid-Level" 
    when salary > 80000 then "Senior" 
end as Category
from employees;

-- 62.Calculate years of experience from hire_date.
select employee_id as ID,first_name as Name,last_name as Surname,salary as Salary,
timestampdiff(Year,hire_date,curdate()) as Experience
from employees;

-- 63.Count employees hired in each year.
select Year(hire_date) as Year,count(employee_id)
from employees
group by Year(hire_date);

-- 64.Find employees hired in the last 2 years.
select Year(hire_date) as Year,count(employee_id) as Total
from employees
where hire_date > date_sub(curdate(),interval 2 year)
group by Year(hire_date);

-- 65.Calculate total salary cost by employee salary category.
with sal as(
	select employee_id as ID,first_name as Name,last_name as Surname,salary as Salary,
    case 
		when salary < 50000 then 'Junior'
        when salary between 50000 and 80000 then 'Mid_Level'
        when salary > 80000 then 'Senior'
	end as Category
    from employees
)
select Category,sum(Salary) from sal group by Category;

-- 66.Find departments where the salary range (max-min) is greater than 40,000.
with dpt_range as(
	select department_id as Department,max(salary) - min(salary) as dp_range
    from employees
    group by department_id
)
select * from dpt_range where dp_range > 40000;

-- ------------------------------------------------------------------------------------------------------------------------------------
-- L. SALARY HISTORY + WINDOWS
-- 67.Show each employee's salary history ordered by effective date.
select employee_id,salary,effective_date
from salary_history
order by employee_id,effective_date;

-- 68.Use LAG() to calculate salary increment from the previous record.
select employee_id,
lag(salary) over(partition by employee_id order by effective_date) as Previous_Salary,
salary as Current_Salary,salary - (lag(salary) over(partition by employee_id order by effective_date)) as Increment,
effective_date as Effective_Date
from salary_history;

-- 69.Calculate salary growth percentage for each employee.
select employee_id,
lag(salary) over(partition by employee_id order by effective_date) as Previous_Salary,
salary as Current_Salary,salary - (lag(salary) over(partition by employee_id order by effective_date)) as Increment,
(salary - (lag(salary) over(partition by employee_id order by effective_date)))/(lag(salary) over(partition by employee_id order by effective_date))*100 as Growth_Percent,
effective_date as Effective_Date
from salary_history;

-- 70.Find employees whose salary increased in every recorded year.
with record as(
	select employee_id,
	lag(salary) over(partition by employee_id order by effective_date) as Previous_Increased,
	salary as Current_Salary,Year(effective_date) as Year,
    salary - (lag(salary) over(partition by employee_id order by effective_date)) as difference
	from salary_history
    
)

select employee_id
from record
group by employee_id
having min(difference) > 0;

-- ------------------------------------------------------------------------------------------------------------------------------------
-- M. INTERVIEW-LEVEL CHALLENGES
-- 71.Find the top 3 employees by salary in each department without using LIMIT.
with Top3 as(
	select employee_id as ID,first_name as Name,last_name as Surname,salary as Salary,department_id as Department,
    row_number() over(partition by department_id order by salary desc) as Rank
    from employees
)

select ID,Name,Surname,Salary,Department,Rank
from Top3
where Rank <= 3;

-- 72.Find the second-highest salary in each department.
with second_highest as(
	select employee_id as ID,first_name as Name,last_name as Surname,salary as Salary,department_id as Department,
	rank() over(partition by department_id order by salary) as Rank
	from employees
)
select  Salary as Second_Highest,Department
from second_highest
where Rank = 2

-- 73.Find employees whose salary is higher than their manager's salary.
select e.employee_id as Employee_ID,m.employee_id as Manager_ID,e.salary as Emp_Sal,m.salary as Man_Sal
from employees e
left join employees m
on  e.manager_id = m.employee_id
where m.salary < e.salary;

-- 74.Find departments where every employee earns above 40,000.
with M as(
	select employee_id,department_id,min(salary) as Minimum
	from employees
	group by department_id
)
select department_id from M where Minimum > 40000;

-- 75.Find the project with the highest number of employees.
with H as(
	select e.employee_id as Emp,ep.project_id as Project
	from employees e
	left join employee_projects ep
	on e.employee_id = ep.employee_id
),
N as(
	select Project,count(Emp) as Employee_Count from H as Employees
    group by Project
)
select * from N where Employee_Count = (select max(Employee_Count) from N);

-- 76.Find employees who work on projects but whose department has no project of its own.
select e.employee_id,p.project_name
from employees e
left join employee_projects ep
on ep.employee_id = e.employee_id
left join projects p
on p.project_id = ep.project_id
where not exists(
	select 1 from projects pr
    where pr.department_id = e.department_id
);

-- 77.Find the department with the highest total salary expense.
with highest as(
	select department_id as Department,sum(salary) as Salary
	from employees
	group by department
)
select * from highest where Salary = (select max(Salary) from highest);

-- 78.Find employees who have no project assignment and no manager.
select e.employee_id,ep.project_id,e.manager_id
from employees e 
left join employee_projects ep
on e.employee_id=ep.employee_id
where ep.project_id is null and (e.manager_id is null or e.manager_id = '');

-- 79.Find duplicate salary values and the employees receiving them.
with sal as(
	select employee_id,salary,count(salary) 
	from employees
	group by salary
    having count(salary) > 1
)
select e.employee_id,e.salary
from employees e
left join sal s
on s.salary = e.salary
order by e.salary;

-- 80.Produce a final report containing employee name, department, manager, salary, project count, salary rank within department and salary category.
select e.first_name as Name,e.last_name as Surname,e.department_id as Department_ID,
d.department_name as Department,m.first_name as Manager,e.salary as Salary,count(ep.project_id) as Projects,
rank() over(partition by e.department_id order by salary desc) as Salary_Rank,
case 
		when e.salary < 50000 then 'Junior'
        when e.salary between 50000 and 80000 then 'Mid_Level'
        when e.salary > 80000 then 'Senior'
end as Category
from employees e
inner join departments d
on e.department_id = d.department_id
left join employees m
on e.manager_id = m.employee_id 
left join employee_projects ep
on e.employee_id = ep.employee_id
group by e.employee_id

