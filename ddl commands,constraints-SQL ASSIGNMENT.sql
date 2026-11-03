create database employee;
use employee;

create table Department(
department_id int,
department_name varchar(100)
);



create table location(
location_id int,
location varchar(30)
);



create table employees(
employee_id int,
employee_name varchar(50),
gender enum ('f','m'),
age int,
hire_date date,
designation varchar(100),
department_id int,
location_id int,
salary decimal(10,2)
);



alter table employees add email varchar(100);
alter table employees modify designation text;
alter table employees drop column age;
alter table employees change column hire_date date_of_joining date;




rename table department to department_info;
rename table location to locations;



truncate table employees;
drop table employees;
drop database employee;





create database employee;
use employee;



create table Department(
department_id int primary key,
department_name varchar(100) unique not null
); 



create table location(
location_id int  primary key  auto_increment,
location varchar(30) not null unique);


create table employees(
employee_id int unique not null,
employee_name varchar(50) not null,
gender enum ('f','m'),
age int,
check(age>=18),
hire_date date default(current_date),
designation varchar(100),
department_id int,
location_id int,
salary decimal(10,2)
);




alter table employees add foreign key(department_id) references department(department_id);
alter table employees add foreign key(location_id) references location(location_id);


desc employees;
desc department;
desc location;