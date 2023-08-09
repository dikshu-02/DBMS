SQL> @ C:\sql_sums\ex8\ex8.sql
SQL> REM #1. For the given receipt number, if there are no rows then display as No order with the
SQL> REM given receipt <number> . If the receipt contains more than one item, display as
SQL> REM The given receipt <number> contains more than one item . If the receipt contains
SQL> REM single item, display as The given receipt <number> contains exactly one item. Use
SQL> REM predefined exception handling
SQL> 
SQL> alter table receipts drop column amt;

Table altered.

SQL> 
SQL>  create or replace procedure excep1(rec_in IN receipts.rno%type) is
  2   count_ int;
  3   countG exception;
  4   count1 exception;
  5   count0 exception;
  6   begin
  7   select count(*) into count_ from item_list where rno=rec_in;
  8   if count_>1 then
  9    raise countG;
 10   elsif count_=1 then
 11  	raise count1;
 12   else
 13  	raise count0;
 14   end if;
 15   EXCEPTION
 16   WHEN countG then
 17  	 raise_application_error(-20000,'The given receipt '||rec_in||' contains more than one item');
 18   WHEN count1 then
 19  	 raise_application_error(-20001,'The given receipt '||rec_in||' contains exactly one item');
 20   WHEN count0 then
 21  	 raise_application_error(-20002,'No order with the The given receipt '||rec_in);
 22   end;
 23   /

Procedure created.

SQL> 
SQL> insert into Receipts VALUES(12345,'12-JAN-05',12);

1 row created.

SQL> 
SQL> 
SQL> begin
  2  excep1(12345);
  3  end;
  4  /
begin
*
ERROR at line 1:
ORA-20002: No order with the The given receipt 12345 
ORA-06512: at "SYSTEM.EXCEP1", line 21 
ORA-06512: at line 2 


SQL> 
SQL> begin
  2  excep1(10013);
  3  end;
  4  /
begin
*
ERROR at line 1:
ORA-20001: The given receipt 10013 contains exactly one item 
ORA-06512: at "SYSTEM.EXCEP1", line 19 
ORA-06512: at line 2 


SQL> 
SQL> 
SQL> REM #2. While inserting the receipt details, raise an exception when the receipt date is greater
SQL> REM than the current date.
SQL> 
SQL> 
SQL> REM #2. While inserting the receipt details, raise an exception when the receipt date is greater
SQL> REM than the current date.
SQL> create or replace procedure excep2(rec_no IN receipts.rno%type, rdate_ receipts.rdate%type, cusno receipts.cid%type) is
  2  insertion_error EXCEPTION;
  3  curr date;
  4  begin
  5  select SYSDATE into curr from Dual;
  6    if (curr < rdate_) then
  7  	 raise insertion_error;
  8    else
  9  	 insert into receipts VALUES(rec_no,rdate_,cusNo);
 10    end if;
 11    EXCEPTION
 12    WHEN insertion_error then
 13  	  raise_application_error(-20003,'Receipt date is greater than current date');
 14  end;
 15  /

Procedure created.

SQL> 
SQL> 
SQL> begin
  2  excep2(12567,'29-MAY-2022',2);
  3  end;
  4  /
begin
*
ERROR at line 1:
ORA-20003: Receipt date is greater than current date 
ORA-06512: at "SYSTEM.EXCEP2", line 13 
ORA-06512: at line 2 


SQL> 
SQL> spool off;
