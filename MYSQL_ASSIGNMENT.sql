# ASSIGNMENT Q1 [a]

Use classicmodels;
select * from employees;
select  employeeNumber,firstname,lastname 
from employees;
select  employeeNumber,firstname,lastname 
from employees 
where jobTitle="Sales rep" and reportsTo= 1102;

#ASSIGNMENR Q1 [b]

select distinct productline
from products
where productline like '%cars';


# ASSIGNMENT Q2

Select * from customers;

select customernumber,
		customername,
			case
				When country = 'usa'  then 'North America'
                When country = 'Canada' then 'North America'
                When country= 'UK'  then 'Europe'
				When country= 'France' then 'Europe'
				When country= 'Germany' then 'Europe'
                else 'Others'
			end as CustomerSegment
From customers;


# ASSIGNMENT Q3 [a]

select * from orderdetails;
select 
    ProductCode, 
    sum(quantityOrdered) as Total_Ordered
from 
    OrderDetails
group by
    productCode
order by
   Total_Ordered desc
limit 10;

#ASSIGNMENT Q3 [b]


select * from payments;

select
    monthname(paymentDate) AS Payment_Month,
    count(*) AS Num_Payments
FROM 
    Payments
GROUP BY 
    MONTH(paymentDate), MONTHNAME(paymentDate)
HAVING 
    Num_Payments > 20
ORDER BY 
    Num_Payments DESC;
    
    
    
#ASSIGNMENT Q4 
    
create database Customers_Orders;
use customers_Orders;

#Q4 [a]
Create table Customers
(
	Customer_Id int primary key auto_increment,
    Frist_Name varchar(50) not null,
    Last_Name varchar(50) not null,
    Email varchar(225) unique,
    Phone_Number varchar(20)
);

desc customers;

#Q4 [b]

Create table Orders
(
	 Order_Id int primary key auto_increment,
     Customer_Id int,
     Order_Date Date,
     Total_Amount decimal(10,2),
  
   foreign key (customer_id) references Customers(customer_id),
    check (total_amount > 0)
);
 
 desc orders;
 
 #ASSIGNMENT Q5
 use classicmodels;
 
 select * from customers;
 select * from orders;
 # country in customers table comman column in both table is customernumber

SELECT 
    c.country,
    COUNT(o.customernumber) AS order_count
FROM 
    Customers c
JOIN 
    Orders o ON c.customernumber = o.customernumber
GROUP BY 
    c.country
ORDER BY 
    order_count DESC
LIMIT 5;

#ASSIGNMENT 6 [a]

create table Project
(
	EmployeeID int primary key auto_increment,
    FullName varchar(50) not null,
    Gender varchar(10) check (Gender in ('Male','Female')),
    ManagerID int
);
 desc project;
 
 Insert into Project (EmployeeID,FullName,Gender,ManagerID)
 values
 (1,"Pranaya","Male",3),
 (2,"Priyanka","Female",1),
 (3,"Preety","Female",null),
 (4,"Anurag","Male",1),
 (5,"Sambit","Male",1),
 (6,"Rajesh","Male",3),
 (7,"Hina","Female",3);
 
 Select * From Project;
 
select 
	f1.FullName as EmployeeName,
    f2.FullName as ManagerName
from
	project f1
left Join
	project f2
on 
f1.ManagerID=f2.EmployeeID
where f2.FullName is not null
order by  f2.FullName;



#ASSIGNMET Q7 
use  classicmodels;
Create table facility
(
	Facility_ID int,
    Name varchar(100),
    State varchar(100),
    Country varchar(100)
);
desc facility;

#Q7 [i]

alter table facility
modify Facility_ID int primary key auto_increment;

#Q7[ii]

alter table facility
add column city varchar(100) not null
after Name;


#Q8 
Create view product_category_sales as
select
    pl.productLine,
    sum(od.quantityOrdered * od.priceEach) as total_sales,
    count(distinct o.orderNumber) as number_of_orders
FROM 
    productlines pl
join
    products p on pl.productLine = p.productLine
join
    orderdetails od on p.productCode = od.productCode
join
    orders o on od.orderNumber = o.orderNumber
group by
    pl.productLine;
    
select *  from product_category_sales;


#Q9

DELIMITER //

Create procedure Get_country_payments(
    in p_year int,
    in p_country varchar(50)
)
begin
    select
        p_year as year,
        c.country as Country,
        CONCAT(ROUND(SUM(p.amount)/1000,0), 'K') as TotalAmount
    from Customers c
    join Payments p on c.customerNumber = p.customerNumber
    where year(p.paymentDate) = p_year
      and c.country = p_country
    group by c.country;
end //

call Get_country_payments(2003, 'france');


#Q10[a]


SELECT 
    c.customerName,
    COUNT(o.orderNumber) AS order_count,
    DENSE_RANK() OVER (ORDER BY COUNT(o.orderNumber) DESC) AS order_freq_rank
FROM 
    customers c
JOIN 
    orders o ON c.customerNumber = o.customerNumber
GROUP BY 
    c.customerNumber, c.customerName
ORDER BY 
Order_count DESC;

#Q10[b]

SELECT 
    YEAR(orderDate) AS Year,
    MONTHNAME(orderDate) AS Month,
    COUNT(orderNumber) AS Total_Orders,

    CONCAT(
        ROUND(
            (
                (COUNT(orderNumber) - LAG(COUNT(orderNumber)) OVER (
                    ORDER BY YEAR(orderDate), MONTH(orderDate)
                )) * 100.0
                / LAG(COUNT(orderNumber)) OVER (
                    ORDER BY YEAR(orderDate), MONTH(orderDate)
                )
            ), 0
        ), '%'
    ) AS `% YOY Change`

FROM orders
GROUP BY YEAR(orderDate), MONTH(orderDate), MONTHNAME(orderDate)
ORDER BY Year, MONTH(orderDate);


#Q11

SELECT 
    productLine,
    COUNT(*) AS product_count
FROM 
    products
WHERE 
    buyPrice > (SELECT AVG(buyPrice) FROM products)
GROUP BY 
    productLine;
    
    
    
#Q12


Create table emp_eh
(
	emp_id int Primary key,
    emp_name varchar(100) not null,
    emp_email varchar(150) not null
);
desc emp_eh;

delimiter //
create procedure Insert_in_emp_eh(in enter_emp_id int, enter_emp_name varchar(100),enter_emp_email varchar(150))
begin 
	declare exit handler for 1048 select "You cannot enter null Value!" as massage;
    declare exit handler for 1062 select "Enter Unique value No duplicate allow" as massage;
    declare exit handler for sqlexception  select "Error Occured" as massage;
    
    insert into emp_eh(emp_id,emp_name,emp_email) values(enter_emp_id,enter_emp_name,enter_emp_email);
    select * from emp_eh;
end //

call Insert_in_emp_eh(1,"shivani","shiu@gamil.com");
call Insert_in_emp_eh(1,"shivani","shiu@gamil.com");
call Insert_in_emp_eh(2,null,"shiu@gamil.com");
call Insert_in_emp_eh(2,"raj",null);
call Insert_in_emp_eh(2,"raj","R@gamil.com");


#Q13

CREATE TABLE Emp_BIT (
    Name VARCHAR(100),
    Occupation VARCHAR(100),
    Working_date DATE,
    Working_hours INT
);

INSERT INTO Emp_BIT VALUES
('Robin', 'Scientist', '2020-10-04', 12),  
('Warner', 'Engineer', '2020-10-04', 10),  
('Peter', 'Actor', '2020-10-04', 13),  
('Marco', 'Doctor', '2020-10-04', 14),  
('Brayden', 'Teacher', '2020-10-04', 12),  
('Antonio', 'Business', '2020-10-04', 11);

select * from emp_bit;

CREATE TRIGGER trg_before_insert_empbit
BEFORE INSERT ON Emp_BIT
FOR EACH ROW
  SET NEW.Working_hours = ABS(NEW.Working_hours);


INSERT INTO Emp_BIT VALUES ('Henry', 'Lawyer', '2020-10-05', -9);

SELECT * FROM Emp_BIT WHERE Name = 'Henry';


















 
 
 
 
 
 
 
 
 
 
 
 

    
    





        








































