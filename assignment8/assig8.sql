set serveroutput on;
set echo on;
REM #1. For the given receipt number, if there are no rows then display as No order with the
REM given receipt <number> . If the receipt contains more than one item, display as
REM The given receipt <number> contains more than one item . If the receipt contains
REM single item, display as The given receipt <number> contains exactly one item. Use
REM predefined exception handling

alter table receipts drop column amt;

 create or replace procedure excep1(rec_in IN receipts.rno%type) is
 count_ int;
 countG exception;
 count1 exception;
 count0 exception;
 begin
 select count(*) into count_ from item_list where rno=rec_in;
 if count_>1 then
  raise countG;
 elsif count_=1 then
   raise count1;
 else
   raise count0;
 end if;
 EXCEPTION 
 WHEN countG then 
    raise_application_error(-20000,'The given receipt '||rec_in||' contains more than one item');
 WHEN count1 then
    raise_application_error(-20001,'The given receipt '||rec_in||' contains exactly one item');
 WHEN count0 then
    raise_application_error(-20002,'No order with the The given receipt '||rec_in);
 end;
 /

insert into Receipts VALUES(12345,'12-JAN-05',12);


begin
excep1(12345);
end;
/

begin
excep1(10013);
end;
/


REM #2. While inserting the receipt details, raise an exception when the receipt date is greater
REM than the current date. 

REM #2. While inserting the receipt details, raise an exception when the receipt date is greater
REM than the current date. 
create or replace procedure excep2(rec_no IN receipts.rno%type, rdate_ receipts.rdate%type, cusno receipts.cid%type) is
insertion_error EXCEPTION;
curr date;
begin
select SYSDATE into curr from Dual;
  if (curr < rdate_) then
    raise insertion_error;
  else
    insert into receipts VALUES(rec_no,rdate_,cusNo);
  end if;
  EXCEPTION
  WHEN insertion_error then
     raise_application_error(-20003,'Receipt date is greater than current date');
end;
/


begin
excep2(12567,'29-MAY-2022',2);
end;
/


