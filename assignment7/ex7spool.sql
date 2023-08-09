SQL> @ C:\sql_sums\ex7\ex7.sql
SQL> set echo on;
SQL> set serveroutput on;
SQL> 
SQL>   REM CUSTOMERS (cid, fname, lname)
SQL>   REM PRODUCTS (pid, flavor, food, price)
SQL>   REM RECEIPTS (rno, rdate, cid)
SQL>   REM ITEM_LIST (rno, ordiNAl, item)
SQL> 
SQL>  REM * Write a PL/SQL Trigger for the following: *
SQL>  REM *** 1. The combination of Flavor and Food determines the product id. Hence, while
SQL>  REM     inserting a new instance into the Products relation, ensure that the same combination
SQL>  REM     of Flavor and Food is not already available.***
SQL> 
SQL> REM *Check whether Tart food in Vanilla or Almond flavor is available or not*
SQL>   select * from products where food='Tart' and flavor='Almond';

PID                  FLAVOR               FOOD                      PRICE       
-------------------- -------------------- -------------------- ----------       
90-ALM-I             Almond               Tart                       3.75       

SQL> 
SQL> REM *TRIGGER TO RESTRICT ADDING PRODUCTS WITH FOOD AND FLAVOR COMBINATION ALREADY AVAILABLE*
SQL>   create or replace trigger check_combo
  2  	 BEFORE
  3  	   INSERT
  4  	 ON Products
  5  	 FOR EACH ROW
  6  	 declare
  7  	   flag number:=0;
  8  	   cursor c1 is select * from products where food=:NEW.food and flavor=:NEW.flavor;
  9  	   record c1%rowtype;
 10  	begin
 11  	  open c1;
 12  	  fetch c1 into record;
 13  	  if c1%NOTFOUND then
 14  	      flag:=1;
 15  	  end if;
 16  	  close c1;
 17  	  if (flag=0) then
 18  	      raise_application_error(-20000,'Combination already available');
 19  	  end if;
 20  	END;
 21  	/

Trigger created.

SQL> 
SQL> 
SQL> 
SQL> 
SQL>   REM * SAVEPOINT *
SQL>   SAVEPOINT P1;

Savepoint created.

SQL> 
SQL> 
SQL> 
SQL> REM * TRYING TO INSERT FOOD AND FLAVOR COMBINATION ALREADY AVAILABLE *
SQL>   insert into products values (0,'Almond','Tart',1);
  insert into products values (0,'Almond','Tart',1)
              *
ERROR at line 1:
ORA-20000: Combination already available 
ORA-06512: at "SYSTEM.CHECK_COMBO", line 13 
ORA-04088: error during execution of trigger 'SYSTEM.CHECK_COMBO' 


SQL> 
SQL> 
SQL> REM * TRYING TO INSERT FOOD AND FLAVOR COMBINATION THAT IS NOT AVAILABLE *
SQL>   insert into products values (0,'Vanilla','Tart',1);

1 row created.

SQL> 
SQL> REM * ROLLBACK *
SQL> ROLLBACK TO P1;

Rollback complete.

SQL> 
SQL> 
SQL> 
SQL>   REM *2. ADDING AMT COLUMN TO RECEIPTS RELATION*
SQL>   alter table receipts add amt number(5,2);

Table altered.

SQL> 
SQL> 
SQL> 
SQL> REM *** 2. While entering an item into the item_list relation, update the amount in Receipts with
SQL> REM     the total amount for that receipt number.***
SQL> 
SQL>   REM *TRIGGER TO UPDATE AMOUNT IN THE RECEIPT DURING PURCHASE*
SQL>   create or replace trigger update_amt
  2  	 BEFORE
  3  	   INSERT
  4  	 ON item_list
  5  	 FOR EACH ROW
  6  	 declare
  7  	   total number;
  8  	  price_ products.price%type;
  9  	begin
 10  	  select price into price_ from products where pid=:NEW.item;
 11  	  select sum(price) into total from item_list,products where item=pid and rno=:NEW.rno;
 12  	  total:=total+price_;
 13  	  update receipts
 14  	  set amt=total
 15  	  where rno=:NEW.rno;
 16  	end;
 17  	/

Trigger created.

SQL> 
SQL> 
SQL> 
SQL>  REM *CHECKING DETAILS OF ALREADY EXISTING ITEMS FOR RNO 11548*
SQL>  select rno,ordinal,pid,price from item_list,products where item=pid and rno=11548;

       RNO    ORDINAL PID                       PRICE                           
---------- ---------- -------------------- ----------                           
     11548          1 45-CO                       3.5                           
     11548          2 90-APIE-10                 5.25                           

SQL> 
SQL> 
SQL> REM *CHECKING CURRENT AMT VALUE IN RECEIPTS FOR RNO 11548*
SQL> select * from receipts where rno=11548;

       RNO RDATE            CID        AMT                                      
---------- --------- ---------- ----------                                      
     11548 21-OCT-07         13                                                 

SQL> 
SQL> 
SQL> REM *INSERT AN ITEM TO ITEM_LIST*
SQL> insert into item_list values(11548,3,'51-BLU');

1 row created.

SQL> 
SQL> 
SQL> REM *CHECKING IF DETAILS FOR RNO 11548 ARE UPDATED*
SQL> select rno,ordinal,pid,price from item_list,products where item=pid and rno=11548;

       RNO    ORDINAL PID                       PRICE                           
---------- ---------- -------------------- ----------                           
     11548          1 45-CO                       3.5                           
     11548          2 90-APIE-10                 5.25                           
     11548          3 51-BLU                     1.15                           

SQL> 
SQL> select * from receipts where rno=11548;

       RNO RDATE            CID        AMT                                      
---------- --------- ---------- ----------                                      
     11548 21-OCT-07         13        9.9                                      

SQL> 
SQL>   REM *** 3. Implement the following constraints for Item_list relation:
SQL>   REM     a. A receipt can contain a maximum of five items only.
SQL>   REM     b. A receipt should not allow an item to be purchased more than thrice.***
SQL> 
SQL>   REM *TRIGGER TO CHECK CONSTRAINTS BEFORE PURCHASING ANOTHER ITEM*
SQL>   create or replace trigger check_receipts
  2  	 BEFORE
  3  	   INSERT
  4  	 ON item_list
  5  	 FOR EACH ROW
  6  	 declare
  7  	   cursor c1 is  select count(*) as cnt1 from item_list where rno=:NEW.rno;
  8  	   cursor c2 is  select count(*) as cnt2 from item_list where rno=:NEW.rno and item=:NEW.item;
  9  	  record1 c1%rowtype;
 10  	  record2 c2%rowtype;
 11  	begin
 12  	  open c1;
 13  	  open c2;
 14  	  fetch c1 into record1;
 15  	  fetch c2 into record2;
 16  	  if record1.cnt1>=5 and record2.cnt2>=3 then
 17  	      raise_application_error(-20000,'The receipt already has five items, also the item to be purchased is already purchased thrice.');
 18  	  elsif record1.cnt1>=5 then
 19  	      raise_application_error(-20001,'The receipt already has five items.');
 20  	  elsif record2.cnt2>=3 then
 21  	      raise_application_error(-20002,'The item to be purchased is already purchased thrice.');
 22  	  end if;
 23  	  close c2;
 24  	  close c1;
 25  	END;
 26  	/

Trigger created.

SQL> 
SQL> 
SQL> 
SQL> 
SQL> 
SQL>   REM *SAVEPOINT*
SQL>   savepoint p2;

Savepoint created.

SQL> 
SQL> 
SQL>   REM * CHECK IF RNO = 86162 ALREADY HAS 5 items *
SQL>   select count(*) from item_list where rno=86162;

  COUNT(*)                                                                      
----------                                                                      
         5                                                                      

SQL> 
SQL> 
SQL> 
SQL>   REM * INSERTING IN ITEM_LIST FOR RNO=86162 - CONSTRAINT A*
SQL>   insert into item_list values (86162,6,'50-ALM');
  insert into item_list values (86162,6,'50-ALM')
              *
ERROR at line 1:
ORA-20001: The receipt already has five items. 
ORA-06512: at "SYSTEM.CHECK_RECEIPTS", line 14 
ORA-04088: error during execution of trigger 'SYSTEM.CHECK_RECEIPTS' 


SQL> 
SQL>   REM * CHECK IF RNO = 31874 ALREADY HAS 5 items *
SQL>   select * from item_list where rno=31874;

       RNO    ORDINAL ITEM                                                      
---------- ---------- --------------------                                      
     31874          1 70-MAR                                                    
     31874          2 70-MAR                                                    
     31874          3 90-LEM-11                                                 

SQL> 
SQL>   REM * INSERTING IN ITEM_LIST FOR RNO=31874 - CONSTRAINT B*
SQL>   insert into item_list values (31874,4,'70-MAR');

1 row created.

SQL> 
SQL>   REM *CHECK INSERTION*
SQL>   select * from item_list where rno=31874;

       RNO    ORDINAL ITEM                                                      
---------- ---------- --------------------                                      
     31874          1 70-MAR                                                    
     31874          2 70-MAR                                                    
     31874          3 90-LEM-11                                                 
     31874          4 70-MAR                                                    

SQL> 
SQL> 
SQL>   REM *ADD ANOTHER 70-MAR ITEM TO THE RNO=31874*
SQL>   insert into item_list values (31874,5,'70-MAR');
  insert into item_list values (31874,5,'70-MAR')
              *
ERROR at line 1:
ORA-20002: The item to be purchased is already purchased thrice. 
ORA-06512: at "SYSTEM.CHECK_RECEIPTS", line 16 
ORA-04088: error during execution of trigger 'SYSTEM.CHECK_RECEIPTS' 


SQL> 
SQL> 
SQL> 
SQL>   REM *ADD AN ITEM TO THE RNO=31874*
SQL>   insert into item_list values (31874,5,'50-ALM');

1 row created.

SQL> 
SQL> 
SQL>   REM * ITEMS IN RNO=31874*
SQL>   select * from item_list where rno=31874;

       RNO    ORDINAL ITEM                                                      
---------- ---------- --------------------                                      
     31874          1 70-MAR                                                    
     31874          2 70-MAR                                                    
     31874          3 90-LEM-11                                                 
     31874          4 70-MAR                                                    
     31874          5 50-ALM                                                    

SQL> 
SQL> 
SQL> 
SQL>   REM * INSERTING IN ITEM_LIST FOR RNO=31874 - CONSTRAINT A AND B*
SQL>   insert into item_list values (31874,6,'70-MAR');
  insert into item_list values (31874,6,'70-MAR')
              *
ERROR at line 1:
ORA-20000: The receipt already has five items, also the item to be purchased is 
already purchased thrice. 
ORA-06512: at "SYSTEM.CHECK_RECEIPTS", line 12 
ORA-04088: error during execution of trigger 'SYSTEM.CHECK_RECEIPTS' 


SQL> 
SQL> 
SQL>   REM *ROLLBACK*
SQL>   rollback to p2;

Rollback complete.

SQL> 
SQL> 
SQL> 
SQL> spool off;
