GO
IF OBJECT_ID ('book', 'U') IS NOT NULL
   DROP table borrow,book;
GO
CREATE TABLE Book (
book_ID   CHAR(10)          PRIMARY KEY,   
                                   --book_ID为主码
name      VARCHAR(30)     NOT NULL,  
                                   --非空约束
author     VARCHAR(10) ,
publish     VARCHAR(20),
price       DECIMAL(6,2)     CHECK(price>0)    
                                    --CHECK约束，price大于0
) 
go
insert into book values('A32DT00001','计算机文化基础','周文波','清华大学出版社','28.0')
insert into book values('A32DT00002','数据库原理','岳海健','电子工业出版社','25.0')
insert into book values('B32DT00001','高等数学','李丹','同济大学出版社','42.0')
insert into book values('B32DT00002','离散数学',null,'高等教育出版社','31.0')
insert into book values('C32DT00001','毛泽东思想','刘琳','机械工业出版社','18.0')
insert into book values('D32DT00001','大学语文','赵阳','机械工业出版社','22.0')
insert into book values('A32DT00003','操作系统',null,'清华大学出版社','24.0')
insert into book values('A32DT00004','C语言','谭浩强','清华大学出版社','20.0')
insert into book values('B32DT00003','线形代数','李俐','高等教育出版社','12.0')
insert into book values('B32DT00004','概率论与数理统计',null,'机械工业出版社','22.0')




GO
IF OBJECT_ID ('reader', 'U') IS NOT NULL
   DROP table borrow,reader;
GO

CREATE TABLE Reader (
Reader_ID    CHAR(10)      PRIMARY KEY,
name        VARCHAR(8) ,
sex          VARCHAR(2),
birthdate     DATETIME
)

insert into reader values('021B310003','于海颖','男','1977-01-26')
insert into reader values('021B310004','胡晓丽','女','1977-01-26')
insert into reader values('021B310005','宋玮','女',null)
insert into reader values('021B310006','施秋乐',null,'1976-09-20')
insert into reader values('021B310007','张巍',null,null)
insert into reader values('021B310008','王金娟',null,'1977-07-13')
insert into reader values('021B310009','王旭','女','1977-07-13')

GO
IF OBJECT_ID ('borrow', 'U') IS NOT NULL
   DROP table borrow;
GO

CREATE TABLE Borrow(
book_ID     CHAR(10),
Reader_ID    CHAR(10),
Borrowdate   DATETIME,
PRIMARY KEY(book_ID,Reader_ID), 
FOREIGN KEY(book_ID) REFERENCES Book(book_ID),  
FOREIGN KEY(Reader_ID) REFERENCES Reader(Reader_ID) 
)

insert into borrow values('A32DT00002','021B310003','2005-01-20 00:00:00.000')
insert into borrow values('A32DT00001','021B310006','2005-01-20 00:00:00.000')
insert into borrow values('B32DT00001','021B310004','2005-02-01 00:00:00.000')
insert into borrow values('B32DT00002','021B310004','2005-02-01 00:00:00.000')
insert into borrow values('C32DT00001','021B310006','2005-02-03 00:00:00.000')
insert into borrow values('A32DT00004','021B310009','2005-06-07 00:00:00.000')
insert into borrow values('B32DT00003','021B310009','2005-06-07 00:00:00.000')
insert into borrow values('B32DT00004','021B310009','2005-06-07 00:00:00.000')
