
drop table image_tbl;
drop table feedback_tbl;
drop table booking_tbl;
drop table customer_tbl;
drop table package_tbl;

drop SEQUENCE customr_id;
drop SEQUENCE Package_id;
drop SEQUENCE Image_id;
drop SEQUENCE Feedback_id;
drop SEQUENCE Booking_id;


CREATE SEQUENCE Customer_id INCREMENT BY 1;
CREATE SEQUENCE Package_id INCREMENT BY 1;
CREATE SEQUENCE Image_id INCREMENT BY 1;
CREATE SEQUENCE Feedback_id INCREMENT BY 1;
CREATE SEQUENCE Booking_id INCREMENT BY 1;
  
  create table Customer_tbl(
    Customer_id int primary key,
    Customer_name varchar2(30) not null,
    password varchar2(30) not null,
    email varchar2(30) not null,
    phoneno number(10,0) not null, -- CHECK (REGEXP_LIKE(phoneno,'^([1-9]{1}[0-9]{9})$')),
    type varchar2(8) DEFAULT 'user'
  );


create table Package_tbl(
  Package_id int primary key,
  Package_name varchar2(30) unique not null,
  Days number(2,0) not null,
  Amount NUMBER(8,2) not null
);
  
  
create table Image_tbl (
  Image_id int primary key,
  Package_id int references Package_tbl(Package_id),
  Image_path varchar2(20) not null
);
  
   
  create table Feedback_tbl(
    Feedback_id int primary key,
    Package_id int references Package_tbl(Package_id),
    rating int default '0' check (rating >= 0 and rating <6) 
  );
  
  
  
  create table Booking_tbl(
    Booking_id int primary key,
    Customer_id int REFERENCES Customer_tbl(Customer_id),
    Package_id int references Package_tbl(Package_id),
    Status_code varchar2(8) default 'pending',
    Members number(3,0) default '1',
    Total_cost number(5,0) not null,
    Booking_date DATE not null
  );
  
  
  -- customer & admin
  insert into CUSTOMER_TBL values(Customer_id.NEXTVAL,'denish','den@123','rdxgalaxy7@gmail.com','9913325859','admin');
  insert into CUSTOMER_TBL values(Customer_id.NEXTVAL,'temp','temp@123','temp@gmail.com','9133258590','user');
  insert into CUSTOMER_TBL values(Customer_id.NEXTVAL,'john','john@123','john@gmail.com','2513325859','user');
  
  -- package tbl
  insert into Package_tbl values(Package_id.NEXTVAL,'kerela',4,1500);
  insert into Package_tbl values(Package_id.NEXTVAL,'agra',7,2100);
  insert into Package_tbl values(Package_id.NEXTVAL,'kolkata',5,2500);
  
  -- Image tbl
  insert into Image_tbl values(Image_id.NEXTVAL,1,'kerela.jpg');
  insert into Image_tbl values(Image_id.NEXTVAL,2,'agra.jpg');
  insert into Image_tbl values(Image_id.NEXTVAL,3,'kolkata.jpg');
  
  -- booking tbl
  insert into booking_tbl values(Booking_id.NEXTVAL,22,1,'pending',3,3*1500,TO_DATE('01/12/2017', 'mm/dd//yyyy'));
  insert into booking_tbl values(Booking_id.NEXTVAL,22,2,'pending',5,5*2100,TO_DATE('03/12/2017', 'mm/dd//yyyy'));
  insert into booking_tbl values(Booking_id.NEXTVAL,23,3,'pending',10,10*2500,TO_DATE('01/15/2018', 'mm/dd//yyyy'));
  
  -- feedback_tbl
  insert into FEEDBACK_TBL values(feedback_id.NEXTVAL,1,3);
  insert into FEEDBACK_TBL values(feedback_id.NEXTVAL,2,5);
  select * from feedback_tbl;
  
 -- show all packages (general to all)

SELECT Package_name,Days,Amount,Image_path,rating from Package_tbl  
inner join Image_tbl on Package_tbl.Package_id = Image_tbl.Package_id  
inner join Feedback_tbl on Feedback_tbl.Package_id = Package_tbl.Package_id ;


-- show all packages Booked by a user 'pending'
select * from package_tbl;
SELECT  Package_name, Status_code, Members, Total_cost, Days, Booking_date FROM BOOKING_TBL inner join PACKAGE_TBL
ON Package_tbl.Package_id = Booking_tbl.Package_id 
WHERE status_code = 'pending' and Customer_id = (select Customer_id from Customer_tbl where Customer_name = 'temp');	
  select * from booking_tbl;

-- convert a pending package to fixed package ( i.e after you pay)
update Booking_tbl set Status_code='done' where Booking_id = '1' and Customer_id =(select Customer_id from Customer_tbl where Customer_name='temp');


-- Showing the Cart History

SELECT Package_name,Members,Total_cost,Days,Booking_date from Booking_tbl
INNER JOIN PACKAGE_TBL ON Package_tbl.Package_id = Booking_tbl.Package_id
WHERE Customer_id = (select Customer_id from Customer_tbl where Customer_name = 'temp') and status_code = 'done' ;					


						
-- delete a pending package

delete from Booking_tbl where Booking_id ='2';

-- calculate total cost

select sum(Total_cost) from Booking_tbl where Status_code='pending' and Customer_id = (select Customer_id from Customer_tbl where Customer_name = 'temp');


  
 commit;
  