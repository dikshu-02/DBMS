SQL> set echo on;
SQL> @ Z:\csea_a_1032\assig4\checking.sql
SQL> REM ** 1. **
SQL> REM Create a view named Blue_Flavor, which display the product details (product id,
SQL> REM food, price) of Blueberry flavor. **
SQL> 
SQL> create or replace view Blue_flavor as select pid,food ,price from products where flavor='Blueberry';

View created.

SQL> select * from Blue_flavor;

PID                  FOOD                      PRICE                            
-------------------- -------------------- ----------                            
90-BLU-11            Tart                       3.25                            
51-BLU               Danish                     1.15                            

SQL> 
SQL> savepoint pt1;

Savepoint created.

SQL> 
SQL> insert into products values('P103','Blueberry','cupcake',1.5);

1 row created.

SQL> select * from Blue_Flavor;

PID                  FOOD                      PRICE                            
-------------------- -------------------- ----------                            
90-BLU-11            Tart                       3.25                            
51-BLU               Danish                     1.15                            
P103                 cupcake                     1.5                            

SQL> select * from products where food='cupcake';

PID                  FLAVOR               FOOD                      PRICE       
-------------------- -------------------- -------------------- ----------       
P103                 Blueberry            cupcake                     1.5       

SQL> 
SQL> insert into Blue_Flavor Values('Ptmp-100','vada',2);

1 row created.

SQL> select * from Blue_Flavor;

PID                  FOOD                      PRICE                            
-------------------- -------------------- ----------                            
90-BLU-11            Tart                       3.25                            
51-BLU               Danish                     1.15                            
P103                 cupcake                     1.5                            

SQL> select * from products where food='vada';

PID                  FLAVOR               FOOD                      PRICE       
-------------------- -------------------- -------------------- ----------       
Ptmp-100                                  vada                          2       

SQL> 
SQL> REM ** price column is updateable**
SQL> update Blue_flavor set price=1.4 where food='Tart';

1 row updated.

SQL> select * from Blue_flavor;

PID                  FOOD                      PRICE                            
-------------------- -------------------- ----------                            
90-BLU-11            Tart                        1.4                            
51-BLU               Danish                     1.15                            
P103                 cupcake                     1.5                            

SQL> select * from products where food='Tart' and flavor='Blueberry';

PID                  FLAVOR               FOOD                      PRICE       
-------------------- -------------------- -------------------- ----------       
90-BLU-11            Blueberry            Tart                        1.4       

SQL> 
SQL> REM ** food column is updateable**
SQL> update Blue_flavor set food='Dosa'  where food='Tart';

1 row updated.

SQL> select * from Blue_flavor;

PID                  FOOD                      PRICE                            
-------------------- -------------------- ----------                            
90-BLU-11            Dosa                        1.4                            
51-BLU               Danish                     1.15                            
P103                 cupcake                     1.5                            

SQL> select * from products where food='Dosa' and flavor='Blueberry';

PID                  FLAVOR               FOOD                      PRICE       
-------------------- -------------------- -------------------- ----------       
90-BLU-11            Blueberry            Dosa                        1.4       

SQL> 
SQL> REM ** pid column is updateable **
SQL> update Blue_Flavor set pid='P1003' where pid='P103';

1 row updated.

SQL> select pid,food from Blue_flavor;

PID                  FOOD                                                       
-------------------- --------------------                                       
90-BLU-11            Dosa                                                       
51-BLU               Danish                                                     
P1003                cupcake                                                    

SQL> select pid,food from products where pid='P1003';

PID                  FOOD                                                       
-------------------- --------------------                                       
P1003                cupcake                                                    

SQL> 
SQL> REM ** Deletion is possible for the newly created value **
SQL> delete from Blue_Flavor where food='cupcake';

1 row deleted.

SQL> select * from Blue_Flavor;

PID                  FOOD                      PRICE                            
-------------------- -------------------- ----------                            
90-BLU-11            Dosa                        1.4                            
51-BLU               Danish                     1.15                            

SQL> select * from products where food='cupcake';

no rows selected

SQL> 
SQL> rollback to pt1;

Rollback complete.

SQL> 
SQL> select COLUMN_NAME,UPDATABLE,INSERTABLE,DELETABLE FROM USER_UPDATABLE_COLUMNS WHERE TABLE_NAME='BLUE_FLAVOR';

COLUMN_NAME                    UPD INS DEL                                      
------------------------------ --- --- ---                                      
PID                            YES YES YES                                      
FOOD                           YES YES YES                                      
PRICE                          YES YES YES                                      

SQL> 
SQL> 
SQL> REM **2.**
SQL> REM Create a view named Cheap_Food, which display the details (product id, flavor,
SQL> REM food, price) of products with price lesser than $1. Ensure that, the price of these
SQL> REM food(s) should never rise above $1 through view.
SQL> 
SQL> create or replace view Cheap_Food as select * from products where price<1 with check option;

View created.

SQL> select* from Cheap_Food;

PID                  FLAVOR               FOOD                      PRICE       
-------------------- -------------------- -------------------- ----------       
70-LEM               Lemon                Cookie                      .79       
70-W                 Walnut               Cookie                      .79       

SQL> 
SQL> savepoint pt2;

Savepoint created.

SQL> 
SQL> Select * from Cheap_Food;

PID                  FLAVOR               FOOD                      PRICE       
-------------------- -------------------- -------------------- ----------       
70-LEM               Lemon                Cookie                      .79       
70-W                 Walnut               Cookie                      .79       

SQL> 
SQL> REM **INSERTION**
SQL> insert into Cheap_Food values('P1006','Strawberry','Candy',0.05);

1 row created.

SQL> Select * from Cheap_Food;

PID                  FLAVOR               FOOD                      PRICE       
-------------------- -------------------- -------------------- ----------       
70-LEM               Lemon                Cookie                      .79       
70-W                 Walnut               Cookie                      .79       
P1006                Strawberry           Candy                       .05       

SQL> Select * from products where food='Candy';

PID                  FLAVOR               FOOD                      PRICE       
-------------------- -------------------- -------------------- ----------       
P1006                Strawberry           Candy                       .05       

SQL> 
SQL> REM ** price column is updatable with check condition **
SQL> update Cheap_Food set price=0.45 where pid='P1006';

1 row updated.

SQL> select * from Cheap_Food ;

PID                  FLAVOR               FOOD                      PRICE       
-------------------- -------------------- -------------------- ----------       
70-LEM               Lemon                Cookie                      .79       
70-W                 Walnut               Cookie                      .79       
P1006                Strawberry           Candy                       .45       

SQL> select * from products where food='Candy';

PID                  FLAVOR               FOOD                      PRICE       
-------------------- -------------------- -------------------- ----------       
P1006                Strawberry           Candy                       .45       

SQL> 
SQL> REM ** price column is updatable with check condition **
SQL> update Cheap_Food set price=1.45 where pid='P1006';
update Cheap_Food set price=1.45 where pid='P1006'
       *
ERROR at line 1:
ORA-01402: view WITH CHECK OPTION where-clause violation 


SQL> select * from Cheap_Food ;

PID                  FLAVOR               FOOD                      PRICE       
-------------------- -------------------- -------------------- ----------       
70-LEM               Lemon                Cookie                      .79       
70-W                 Walnut               Cookie                      .79       
P1006                Strawberry           Candy                       .45       

SQL> select * from products where food='Candy';

PID                  FLAVOR               FOOD                      PRICE       
-------------------- -------------------- -------------------- ----------       
P1006                Strawberry           Candy                       .45       

SQL> 
SQL> 
SQL> REM ** food column is updateable**
SQL> update Cheap_Food set food='Tart'	where food='Dosa';

0 rows updated.

SQL> select * from Cheap_Food ;

PID                  FLAVOR               FOOD                      PRICE       
-------------------- -------------------- -------------------- ----------       
70-LEM               Lemon                Cookie                      .79       
70-W                 Walnut               Cookie                      .79       
P1006                Strawberry           Candy                       .45       

SQL> select * from products where food='Tart' ;

PID                  FLAVOR               FOOD                      PRICE       
-------------------- -------------------- -------------------- ----------       
90-ALM-I             Almond               Tart                       3.75       
90-APP-11            Apple                Tart                       3.25       
90-APR-PF            Apricot              Tart                       3.25       
90-BER-11            Berry                Tart                       3.25       
90-BLK-PF            Blackberry           Tart                       3.25       
90-BLU-11            Blueberry            Tart                       3.25       
90-CH-PF             Chocolate            Tart                       3.75       
90-CHR-11            Cherry               Tart                       3.25       
90-LEM-11            Lemon                Tart                       3.25       
90-PEC-11            Pecan                Tart                       3.75       

10 rows selected.

SQL> 
SQL> REM ** pid column is updateable **
SQL> update Cheap_Food set pid='new_P1006'  where pid='P1006';

1 row updated.

SQL> select * from Cheap_Food ;

PID                  FLAVOR               FOOD                      PRICE       
-------------------- -------------------- -------------------- ----------       
70-LEM               Lemon                Cookie                      .79       
70-W                 Walnut               Cookie                      .79       
new_P1006            Strawberry           Candy                       .45       

SQL> select * from products where food='Candy';

PID                  FLAVOR               FOOD                      PRICE       
-------------------- -------------------- -------------------- ----------       
new_P1006            Strawberry           Candy                       .45       

SQL> 
SQL> 
SQL> REM ** flavor column is updateable **
SQL> update Cheap_Food set flavor='chocolate'  where pid='new_P1006';

1 row updated.

SQL> select * from Cheap_Food ;

PID                  FLAVOR               FOOD                      PRICE       
-------------------- -------------------- -------------------- ----------       
70-LEM               Lemon                Cookie                      .79       
70-W                 Walnut               Cookie                      .79       
new_P1006            chocolate            Candy                       .45       

SQL> select * from products where food='Candy';

PID                  FLAVOR               FOOD                      PRICE       
-------------------- -------------------- -------------------- ----------       
new_P1006            chocolate            Candy                       .45       

SQL> 
SQL> 
SQL> REM ** DELETION **
SQL> Delete from Cheap_Food where pid='new_P1006';

1 row deleted.

SQL> select * from Cheap_Food ;

PID                  FLAVOR               FOOD                      PRICE       
-------------------- -------------------- -------------------- ----------       
70-LEM               Lemon                Cookie                      .79       
70-W                 Walnut               Cookie                      .79       

SQL> select * from products where food='Candy';

no rows selected

SQL> 
SQL> 
SQL> select COLUMN_NAME,UPDATABLE,INSERTABLE,DELETABLE FROM USER_UPDATABLE_COLUMNS WHERE TABLE_NAME='CHEAP_FOOD';

COLUMN_NAME                    UPD INS DEL                                      
------------------------------ --- --- ---                                      
PID                            YES YES YES                                      
FLAVOR                         YES YES YES                                      
FOOD                           YES YES YES                                      
PRICE                          YES YES YES                                      

SQL> 
SQL> 
SQL> rollback to pt2;

Rollback complete.

SQL> 
SQL> 
SQL> REM **3.**
SQL> REM Create a view called Hot_Food that show the product id and its quantity where the
SQL> REM same product is ordered more than once in the same receipt.
SQL> 
SQL> create or replace view Hot_Food (pid,quantity) as select item,count(*) from item_list group by(rno,item) having count(*)>1;

View created.

SQL> 
SQL> savepoint pt3;

Savepoint created.

SQL> 
SQL> REM **INSERTION**
SQL> Insert into Hot_Food values('P109',15);
Insert into Hot_Food values('P109',15)
*
ERROR at line 1:
ORA-01733: virtual column not allowed here 


SQL> 
SQL> REM **UPDATION**
SQL> Update Hot_Food set pid='new_value' where pid='90-APR-PF';
Update Hot_Food set pid='new_value' where pid='90-APR-PF'
       *
ERROR at line 1:
ORA-01732: data manipulation operation not legal on this view 


SQL> Update Hot_Food set quantity=100 where pid='90-APR-PF';
Update Hot_Food set quantity=100 where pid='90-APR-PF'
       *
ERROR at line 1:
ORA-01732: data manipulation operation not legal on this view 


SQL> 
SQL> REM **DELETION**
SQL> Delete from Hot_Food where pid='90-APR-PF';
Delete from Hot_Food where pid='90-APR-PF'
            *
ERROR at line 1:
ORA-01732: data manipulation operation not legal on this view 


SQL> 
SQL> 
SQL> select *from Hot_Food;

PID                    QUANTITY                                                 
-------------------- ----------                                                 
70-R                          2                                                 
90-APR-PF                     2                                                 
50-APP                        2                                                 
51-ATW                        2                                                 
90-ALM-I                      2                                                 
90-BER-11                     2                                                 
90-PEC-11                     2                                                 
70-M-CH-DZ                    2                                                 
46-11                         2                                                 
70-M-CH-DZ                    2                                                 
90-CHR-11                     2                                                 

PID                    QUANTITY                                                 
-------------------- ----------                                                 
90-BLU-11                     2                                                 
50-CHS                        2                                                 
70-M-CH-DZ                    2                                                 
70-R                          2                                                 
90-APP-11                     2                                                 
70-MAR                        2                                                 
50-APR                        2                                                 
51-BC                         2                                                 
50-ALM                        2                                                 

20 rows selected.

SQL> select COLUMN_NAME,UPDATABLE,INSERTABLE,DELETABLE FROM USER_UPDATABLE_COLUMNS WHERE TABLE_NAME='HOT_FOOD';

COLUMN_NAME                    UPD INS DEL                                      
------------------------------ --- --- ---                                      
PID                            NO  NO  NO                                       
QUANTITY                       NO  NO  NO                                       

SQL> 
SQL> rollback to pt3;

Rollback complete.

SQL> 
SQL> REM **4.**
SQL> REM Create a view named Pie_Food that will display the details (customer lname, flavor,
SQL> REM receipt number and date, ordinal) who had ordered the Pie food with receipt details.
SQL> 
SQL> 
SQL> create or replace view Pie_Food as select c.lname,p.flavor,i.rno,r.rdate,i.ordinal from Receipts r join item_list i on r.rno=i.rno join products p on p.pid=i.item join customers c on c.cid=r.cid where p.food='Pie';

View created.

SQL> select * from Pie_Food;

LNAME                FLAVOR                      RNO RDATE        ORDINAL       
-------------------- -------------------- ---------- --------- ----------       
JULIET               Apple                     39685 28-OCT-07          4       
JULIET               Apple                     66227 10-OCT-07          2       
TRAVIS               Apple                     48647 09-OCT-07          2       
JOSETTE              Apple                     87454 21-OCT-07          1       
JOSETTE              Apple                     47353 12-OCT-07          2       
RUPERT               Apple                     53376 30-OCT-07          3       
CUC                  Apple                     50660 18-OCT-07          2       
KIP                  Apple                     11548 21-OCT-07          2       
RAYFORD              Apple                     29226 26-OCT-07          2       
RAYFORD              Apple                     51991 17-OCT-07          1       
ARIANE               Apple                     39109 02-OCT-07          1       

LNAME                FLAVOR                      RNO RDATE        ORDINAL       
-------------------- -------------------- ---------- --------- ----------       
ARIANE               Apple                     44798 04-OCT-07          3       
CHARLENE             Apple                     98806 15-OCT-07          3       

13 rows selected.

SQL> 
SQL> REM ** Only attributes of key preserved table can be changed **
SQL> 
SQL> savepoint pt4;

Savepoint created.

SQL> 
SQL> REM ** INSERTION **
SQL> insert into Pie_Food values ('KIP','Strawberry',78179, '24-Oct-2007',1);
insert into Pie_Food values ('KIP','Strawberry',78179, '24-Oct-2007',1)
*
ERROR at line 1:
ORA-01779: cannot modify a column which maps to a non key-preserved table 


SQL> 
SQL> REM **UPDATION**
SQL> REM **updating rno and ordinal **
SQL> update Pie_Food set ordinal=5 where rdate='28-OCT-07';

1 row updated.

SQL> select * from Pie_Food where rdate='28-OCT-07';

LNAME                FLAVOR                      RNO RDATE        ORDINAL       
-------------------- -------------------- ---------- --------- ----------       
JULIET               Apple                     39685 28-OCT-07          5       

SQL> update Pie_Food set rno =66227 where rdate='28-OCT-07';

1 row updated.

SQL> select * from Pie_Food ;

LNAME                FLAVOR                      RNO RDATE        ORDINAL       
-------------------- -------------------- ---------- --------- ----------       
JULIET               Apple                     66227 10-OCT-07          2       
JULIET               Apple                     66227 10-OCT-07          5       
TRAVIS               Apple                     48647 09-OCT-07          2       
JOSETTE              Apple                     87454 21-OCT-07          1       
JOSETTE              Apple                     47353 12-OCT-07          2       
RUPERT               Apple                     53376 30-OCT-07          3       
CUC                  Apple                     50660 18-OCT-07          2       
KIP                  Apple                     11548 21-OCT-07          2       
RAYFORD              Apple                     29226 26-OCT-07          2       
RAYFORD              Apple                     51991 17-OCT-07          1       
ARIANE               Apple                     39109 02-OCT-07          1       

LNAME                FLAVOR                      RNO RDATE        ORDINAL       
-------------------- -------------------- ---------- --------- ----------       
ARIANE               Apple                     44798 04-OCT-07          3       
CHARLENE             Apple                     98806 15-OCT-07          3       

13 rows selected.

SQL> 
SQL> REM **updating lname or rdate or flavor **
SQL> update Pie_Food set flavor='Pineapple';
update Pie_Food set flavor='Pineapple'
                    *
ERROR at line 1:
ORA-01779: cannot modify a column which maps to a non key-preserved table 


SQL> update Pie_Food set lname='ROY';
update Pie_Food set lname='ROY'
                    *
ERROR at line 1:
ORA-01779: cannot modify a column which maps to a non key-preserved table 


SQL> update Pie_Food set rdate='28-OCT-07';
update Pie_Food set rdate='28-OCT-07'
                    *
ERROR at line 1:
ORA-01779: cannot modify a column which maps to a non key-preserved table 


SQL> 
SQL> REM ** Deletion **
SQL> delete from Pie_food where lname='RAYFORD';

2 rows deleted.

SQL> select rno,ordinal from item_list where rno='29226' and ordinal=2;

no rows selected

SQL> 
SQL> select COLUMN_NAME,UPDATABLE,INSERTABLE,DELETABLE FROM USER_UPDATABLE_COLUMNS WHERE TABLE_NAME='PIE_FOOD';

COLUMN_NAME                    UPD INS DEL                                      
------------------------------ --- --- ---                                      
LNAME                          NO  NO  NO                                       
FLAVOR                         NO  NO  NO                                       
RNO                            YES YES YES                                      
RDATE                          NO  NO  NO                                       
ORDINAL                        YES YES YES                                      

SQL> 
SQL> rollback to pt4;

Rollback complete.

SQL> 
SQL> REM **5.**
SQL> REM Create a view Cheap_View from Cheap_Food that shows only the product id, flavor and food.
SQL> 
SQL> create or replace view Cheap_View as select pid,food,flavor from Cheap_Food;

View created.

SQL> select * from Cheap_View;

PID                  FOOD                 FLAVOR                                
-------------------- -------------------- --------------------                  
70-LEM               Cookie               Lemon                                 
70-W                 Cookie               Walnut                                

SQL> 
SQL> savepoint pt5;

Savepoint created.

SQL> 
SQL> REM ** INSERTION **
SQL> REM ** INSERTION IS NOT POSSIBLE BECAUSE OF CHECK CONSTRAINT IN Cheap_Food view **
SQL> insert into Cheap_view Values('P1007','Vanilla','choco');
insert into Cheap_view Values('P1007','Vanilla','choco')
            *
ERROR at line 1:
ORA-01402: view WITH CHECK OPTION where-clause violation 


SQL> 
SQL> 
SQL> REM ** food column is updateable**
SQL> update Cheap_Food set food='Tart'	where food='Cookie';

2 rows updated.

SQL> select * from Cheap_view ;

PID                  FOOD                 FLAVOR                                
-------------------- -------------------- --------------------                  
70-LEM               Tart                 Lemon                                 
70-W                 Tart                 Walnut                                

SQL> select * from products where food='Tart' ;

PID                  FLAVOR               FOOD                      PRICE       
-------------------- -------------------- -------------------- ----------       
90-ALM-I             Almond               Tart                       3.75       
90-APP-11            Apple                Tart                       3.25       
90-APR-PF            Apricot              Tart                       3.25       
90-BER-11            Berry                Tart                       3.25       
90-BLK-PF            Blackberry           Tart                       3.25       
90-BLU-11            Blueberry            Tart                       3.25       
90-CH-PF             Chocolate            Tart                       3.75       
90-CHR-11            Cherry               Tart                       3.25       
90-LEM-11            Lemon                Tart                       3.25       
90-PEC-11            Pecan                Tart                       3.75       
70-LEM               Lemon                Tart                        .79       

PID                  FLAVOR               FOOD                      PRICE       
-------------------- -------------------- -------------------- ----------       
70-W                 Walnut               Tart                        .79       

12 rows selected.

SQL> 
SQL> 
SQL> REM ** flavor column is updateable **
SQL> update Cheap_view set flavor='chocolate'  where pid='new_P1007';

0 rows updated.

SQL> select * from Cheap_View;

PID                  FOOD                 FLAVOR                                
-------------------- -------------------- --------------------                  
70-LEM               Tart                 Lemon                                 
70-W                 Tart                 Walnut                                

SQL> select * from products where food='choco';

no rows selected

SQL> 
SQL> 
SQL> REM ** DELETION **
SQL> Delete from Cheap_view where pid='new_P1007';

0 rows deleted.

SQL> select * from Cheap_view ;

PID                  FOOD                 FLAVOR                                
-------------------- -------------------- --------------------                  
70-LEM               Tart                 Lemon                                 
70-W                 Tart                 Walnut                                

SQL> select * from products where food='choco';

no rows selected

SQL> 
SQL> select COLUMN_NAME,UPDATABLE,INSERTABLE,DELETABLE FROM USER_UPDATABLE_COLUMNS WHERE TABLE_NAME='CHEAP_VIEW';

COLUMN_NAME                    UPD INS DEL                                      
------------------------------ --- --- ---                                      
PID                            YES YES YES                                      
FOOD                           YES YES YES                                      
FLAVOR                         YES YES YES                                      

SQL> 
SQL> rollback to pt5;

Rollback complete.

SQL> 
SQL> REM **6.**
SQL> REM Drop the view Cheap_View
SQL> drop view Cheap_food;

View dropped.

SQL> select * from Cheap_view;
select * from Cheap_view
              *
ERROR at line 1:
ORA-04063: view "1032.CHEAP_VIEW" has errors 


SQL> drop view Cheap_View;

View dropped.

SQL> spool off;
