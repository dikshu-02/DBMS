
set echo on;
set serveroutput on;

  REM CUSTOMERS (cid, fname, lname)
  REM PRODUCTS (pid, flavor, food, price)
  REM RECEIPTS (rno, rdate, cid)
  REM ITEM_LIST (rno, ordiNAl, item)
  
 REM * Write a PL/SQL Trigger for the following: *
 REM *** 1. The combination of Flavor and Food determines the product id. Hence, while
 REM     inserting a new instance into the Products relation, ensure that the same combination
 REM     of Flavor and Food is not already available.***
  
REM *Check whether Tart food in Vanilla or Almond flavor is available or not*
  select * from products where food='Tart' and flavor='Almond';

REM *TRIGGER TO RESTRICT ADDING PRODUCTS WITH FOOD AND FLAVOR COMBINATION ALREADY AVAILABLE*
  create or replace trigger check_combo
    BEFORE
      INSERT
    ON Products
    FOR EACH ROW
    declare
      flag number:=0;
      cursor c1 is select * from products where food=:NEW.food and flavor=:NEW.flavor;
      record c1%rowtype;
   begin
     open c1;
     fetch c1 into record;
     if c1%NOTFOUND then
   	 flag:=1;
     end if;
     close c1;
     if (flag=0) then
   	 raise_application_error(-20000,'Combination already available');
     end if;
   END;
   /



  
  REM * SAVEPOINT *
  SAVEPOINT P1;



REM * TRYING TO INSERT FOOD AND FLAVOR COMBINATION ALREADY AVAILABLE *
  insert into products values (0,'Almond','Tart',1);


REM * TRYING TO INSERT FOOD AND FLAVOR COMBINATION THAT IS NOT AVAILABLE *
  insert into products values (0,'Vanilla','Tart',1);
        
REM * ROLLBACK *
ROLLBACK TO P1;



  REM *2. ADDING AMT COLUMN TO RECEIPTS RELATION*
  alter table receipts add amt number(5,2);


  
REM *** 2. While entering an item into the item_list relation, update the amount in Receipts with
REM     the total amount for that receipt number.***
  
  REM *TRIGGER TO UPDATE AMOUNT IN THE RECEIPT DURING PURCHASE*
  create or replace trigger update_amt
    BEFORE
      INSERT
    ON item_list
    FOR EACH ROW
    declare
      total number;
     price_ products.price%type;
   begin
     select price into price_ from products where pid=:NEW.item;
     select sum(price) into total from item_list,products where item=pid and rno=:NEW.rno;
     total:=total+price_;
     update receipts
     set amt=total
     where rno=:NEW.rno;
   end;
   /



 REM *CHECKING DETAILS OF ALREADY EXISTING ITEMS FOR RNO 11548*
 select rno,ordinal,pid,price from item_list,products where item=pid and rno=11548;
                            

REM *CHECKING CURRENT AMT VALUE IN RECEIPTS FOR RNO 11548*
select * from receipts where rno=11548;
                                           

REM *INSERT AN ITEM TO ITEM_LIST*
insert into item_list values(11548,3,'51-BLU');


REM *CHECKING IF DETAILS FOR RNO 11548 ARE UPDATED*
select rno,ordinal,pid,price from item_list,products where item=pid and rno=11548;
                            
select * from receipts where rno=11548;

  REM *** 3. Implement the following constraints for Item_list relation:
  REM     a. A receipt can contain a maximum of five items only.
  REM     b. A receipt should not allow an item to be purchased more than thrice.***
  
  REM *TRIGGER TO CHECK CONSTRAINTS BEFORE PURCHASING ANOTHER ITEM*
  create or replace trigger check_receipts
    BEFORE
      INSERT
    ON item_list
    FOR EACH ROW
    declare
      cursor c1 is  select count(*) as cnt1 from item_list where rno=:NEW.rno;
      cursor c2 is  select count(*) as cnt2 from item_list where rno=:NEW.rno and item=:NEW.item;
     record1 c1%rowtype;
     record2 c2%rowtype;
   begin
     open c1;
     open c2;
     fetch c1 into record1;
     fetch c2 into record2;
     if record1.cnt1>=5 and record2.cnt2>=3 then
   	 raise_application_error(-20000,'The receipt already has five items, also the item to be purchased is already purchased thrice.');
     elsif record1.cnt1>=5 then
   	 raise_application_error(-20001,'The receipt already has five items.');
     elsif record2.cnt2>=3 then
   	 raise_application_error(-20002,'The item to be purchased is already purchased thrice.');
     end if;
     close c2;
     close c1;
   END;
   /



  
  
  REM *SAVEPOINT*
  savepoint p2;


  REM * CHECK IF RNO = 86162 ALREADY HAS 5 items *
  select count(*) from item_list where rno=86162;

                                                                                                                         

  REM * INSERTING IN ITEM_LIST FOR RNO=86162 - CONSTRAINT A*
  insert into item_list values (86162,6,'50-ALM');

  REM * CHECK IF RNO = 31874 ALREADY HAS 5 items *
  select * from item_list where rno=31874;

  REM * INSERTING IN ITEM_LIST FOR RNO=31874 - CONSTRAINT B*
  insert into item_list values (31874,4,'70-MAR');

  REM *CHECK INSERTION*
  select * from item_list where rno=31874;
                                        

  REM *ADD ANOTHER 70-MAR ITEM TO THE RNO=31874*
  insert into item_list values (31874,5,'70-MAR');
            


  REM *ADD AN ITEM TO THE RNO=31874*
  insert into item_list values (31874,5,'50-ALM');


  REM * ITEMS IN RNO=31874*
  select * from item_list where rno=31874;

                                                    

  REM * INSERTING IN ITEM_LIST FOR RNO=31874 - CONSTRAINT A AND B*
  insert into item_list values (31874,6,'70-MAR');


  REM *ROLLBACK*
  rollback to p2;




