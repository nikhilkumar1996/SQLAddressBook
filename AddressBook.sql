-----UC 1:Create DataBase
create database AddressBookServiceDB;

------ UC 2: Create Table ------
create table Address_Book_Table
(FirstName varchar(100),
SecondName varchar(100),
Address varchar(250),
City varchar(100),
State varchar(100),
zip BigInt,
PhoneNumber BigInt,
Email varchar(200)
)

------ UC 3: Insert Values to Table ------
Insert into Address_Book_Table(FirstName,SecondName,Address,City,State,zip,PhoneNumber,Email) 
values('Nikhil','Kumar','bir bhagera,sujanpur tira','Shimla','Himachal Pradesh',663001,9842905050,'Nikhil@gmail.com'),
('Rohini','Kuchapaali','golkunda fort Rd','Hyderabad','Telangana',884002,98402000,'Rohini@gmail.com'),
('Shilpa','Yadav','saharanpur 345 NH ,gt road','Lucknow','Uttar Pradesh',443201,87210505053,'Shilpa@gmail.com');
select * from Address_Book_Table

------ UC 4: Ability to Edit Contact Person Based on their Name ------
--Edit Email based on Name--
Update Address_Book_Table set Email='ShilpaYadav@gmail.com' where FirstName='Shilpa'
--Edit Address based on Name--
Update Address_Book_Table set Address='836 Heritage Road' where FirstName='Rohini'

------ UC 5: Ability to Delete Contact Person Based on their Name ------
delete from Address_Book_Table where FirstName='Shilpa' and SecondName='Yadav'

------ UC 6: Ability to Retrieve Person belonging to a City or State ------
select * from Address_Book_Table where City='Shimla' or State='Himachal Pradesh'

------ UC 7: Ability to Retrieve Count of Person belonging to a City or State ------
Insert into Address_Book_Table values('Rajat','Verma','Sector 32,square plaza','Patiala','Punjab',6845001,957575050,'Rajat@gmail.com')
Insert into Address_Book_Table values('Sahil','Bhatiya','kori village,nandigaon','Kathua','Himachal Pradesh',846303,9783678276,'Sahil@gmail.com')
select Count(*) as state,City from Address_Book_Table Group by state,City

------ UC 8: Ability to retrieve entries sorted alphabetically ------
select * from Address_Book_Table where State='Himachal Pradesh' order by(FirstName)

------ UC 9: Identify each Address Book with name andType ------
alter table Address_Book_Table add AddressBookName varchar(100),Type varchar(100)
--Update values for Type=Friends--
update Address_Book_Table set AddressBookName='Close Circle',Type='Friends' where FirstName='Nikhil' or FirstName='Rohini'
--Update values for Type=Family--
update Address_Book_Table set AddressBookName='Cousin',Type='Family' where FirstName='Sahil'
--Update values for Type=Profession--
update Address_Book_Table set AddressBookName='Manager',Type='Profession' where FirstName='Rajat'

------ UC 10: Ability to get number of contact persons by Type------
select Count(*) as NumberOfContacts,Type from Address_Book_Table Group by Type

-------- Creating Tables Based on ER Diagrams  --------
create table Address_Book(
Address_BookID int identity(1,1) primary key,
Address_BookName varchar(200)
)
insert into Address_Book values ('AddrBook1'),('AddrBook2')
select * from Address_Book

create table Contact_Records(
AddressBook_ID int,
Contact_ID int identity(1,1) primary key,
FirstName varchar(100),
SecondName varchar(100),
Address varchar(250),
City varchar(100),
State varchar(100),
zip BigInt,
PhoneNumber BigInt,
Email varchar(200),
foreign key (AddressBook_ID) references Address_Book(Address_BookID))

insert into Contact_Records values
(1,'Nikhil','Kumar','bir bhagera,sujanpur tira','Shimla','Himachal Pradesh',663001,9842905050,'Nikhil@gmail.com'),
(2,'Rohini','Kuchapaali','golkunda fort Rd','Hyderabad','Telangana',884002,98402000,'Rohini@gmail.com'),
(2,'Shilpa','Yadav','saharanpur 345 NH ,gt road','Lucknow','Uttar Pradesh',443201,87210505053,'Shilpa@gmail.com'),
(1,'Rajat','Verma','Sector 32,square plaza','Patiala','Punjab',6845001,957575050,'Rajat@gmail.com'),
(1,'Sahil','Bhatiya','kori village,nandigaon','Kathua','Himachal Pradesh',846303,9783678276,'Sahil@gmail.com')
select * from Contact_Records

create table ContactType
(ContactType_ID int identity(1,1) primary key,
ContactType_Name varchar(200)
)
insert into ContactType values
('Family'),('Friends'),('Profession')
select * from ContactType

create Table TypeOccupation(
ContactType_Occ int,
Contact_IdNo int,
foreign key (ContactType_Occ) references ContactType(ContactType_ID),
foreign key (Contact_IdNo) references Contact_Records(Contact_ID)
)
insert into TypeOccupation values
(1,1),
(2,2),
(3,3),
(1,4),
(2,5)
select * from TypeOccupation
truncate table TypeOccupation

------ UseCase 11: Create Contact for both Family and Friends Type ------ 
select Address_BookName,Concat(FirstName,SecondName) as Name,Concat(Address,City,State,zip) as Address,PhoneNumber,Email,ContactType_Name from Address_Book 
Full JOIN Contact_Records on Address_Book.Address_BookID=AddressBook_ID 
Full JOIN TypeOccupation on TypeOccupation.Contact_IdNo=Contact_ID
Full JOIN ContactType on TypeOccupation.ContactType_Occ=ContactType_ID

------  UseCase 12------  

-- 1: Ability to Retrieve Person belonging to a City or State --

select Address_BookName,Concat(FirstName,' ',SecondName) as Name,Concat(Address,' ,',City,' ,',State,' ,',zip) as Address,PhoneNumber,Email,ContactType_Name from Contact_Records 
INNER JOIN  Address_Book on Address_Book.Address_BookID=AddressBook_ID 
INNER JOIN TypeOccupation on TypeOccupation.Contact_IdNo=Contact_ID and (City='Shimla' or State='Himachal Pradesh')
INNER JOIN ContactType on TypeOccupation.ContactType_Occ=ContactType_ID


------ 2: Ability to Retrieve Count of Person belonging to a City or State ------
select Count(*)as noOfstates,state,City from Contact_Records 
INNER JOIN  Address_Book on Address_Book.Address_BookID=AddressBook_ID 
Group by state,City

------ 3: Ability to retrieve entries sorted alphabetically ------
select Address_BookName,(FirstName+' '+SecondName) as Name,Concat(Address,' ,',City,' ,',State,' ,',zip) as Address,PhoneNumber,Email,ContactType_Name
from Contact_Records 
INNER JOIN  Address_Book on Address_Book.Address_BookID=AddressBook_ID and (City='Patiala')
INNER JOIN TypeOccupation on TypeOccupation.Contact_IdNo=Contact_ID
INNER JOIN ContactType on TypeOccupation.ContactType_Occ=ContactType_ID
order by(FirstName)

------ 4: Ability to get number of contact persons by Type------
select Count(*) as NumberOfContacts,ContactType.ContactType_Name from Contact_Records 
INNER JOIN  Address_Book on Address_Book.Address_BookID=AddressBook_ID
INNER JOIN TypeOccupation on TypeOccupation.Contact_IdNo=Contact_ID
INNER JOIN ContactType on TypeOccupation.ContactType_Occ=ContactType_ID
Group by ContactType_Name