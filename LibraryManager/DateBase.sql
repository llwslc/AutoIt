GO
IF OBJECT_ID ('book', 'U') IS NOT NULL
   DROP table borrow,book;
GO
CREATE TABLE Book (
book_ID   CHAR(10)          PRIMARY KEY,   
                                   --book_IDΪ����
name      VARCHAR(30)     NOT NULL,  
                                   --�ǿ�Լ��
author     VARCHAR(10) ,
publish     VARCHAR(20),
price       DECIMAL(6,2)     CHECK(price>0)    
                                    --CHECKԼ����price����0
) 
go
insert into book values('A32DT00001','������Ļ�����','���Ĳ�','�廪��ѧ������','28.0')
insert into book values('A32DT00002','���ݿ�ԭ��','������','���ӹ�ҵ������','25.0')
insert into book values('B32DT00001','�ߵ���ѧ','�','ͬ�ô�ѧ������','42.0')
insert into book values('B32DT00002','��ɢ��ѧ',null,'�ߵȽ���������','31.0')
insert into book values('C32DT00001','ë��˼��','����','��е��ҵ������','18.0')
insert into book values('D32DT00001','��ѧ����','����','��е��ҵ������','22.0')
insert into book values('A32DT00003','����ϵͳ',null,'�廪��ѧ������','24.0')
insert into book values('A32DT00004','C����','̷��ǿ','�廪��ѧ������','20.0')
insert into book values('B32DT00003','���δ���','����','�ߵȽ���������','12.0')
insert into book values('B32DT00004','������������ͳ��',null,'��е��ҵ������','22.0')




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

insert into reader values('021B310003','�ں�ӱ','��','1977-01-26')
insert into reader values('021B310004','������','Ů','1977-01-26')
insert into reader values('021B310005','����','Ů',null)
insert into reader values('021B310006','ʩ����',null,'1976-09-20')
insert into reader values('021B310007','��Ρ',null,null)
insert into reader values('021B310008','�����',null,'1977-07-13')
insert into reader values('021B310009','����','Ů','1977-07-13')

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
