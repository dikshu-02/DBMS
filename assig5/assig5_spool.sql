SQL> @ Z:\csea_a_1032\assig5\assig6.sql
SQL> REM ** Write PL/SQL block for the following: **
SQL> 
SQL> REM ** 1.Check whether the given combination of food and flavor is available. If any one or
SQL> REM     both are not available, display the relevant message. **
SQL> 
SQL> REM * Given combination of food and flavor is available in the table *
SQL> 
SQL> declare
  2  	 record products%rowtype;
  3  	 given_food products.food%type;
  4  	 given_flavor products.flavor%type;
  5  	 counting int;
  6  begin
  7  	 given_food:='&food_to_search';
  8  	 given_flavor:='&flavor_to_search';
  9  
 10  	 select count(*) into counting from products where food=given_food and flavor=given_flavor;
 11  	 if counting != 0 then
 12  	     dbms_output.put_line('Given '|| given_food||' and '||given_flavor||' combination is available!!');
 13  	     select * into record from products where food=given_food and flavor=given_flavor;
 14  	     dbms_output.put_line('Product id: '||record.pid);
 15  	 else
 16  	     dbms_output.put_line('Given combination is not found !');
 17  	     select count(*) into counting from (select * from products where given_food = food);
 18  	     if counting != 0 then
 19  		 dbms_output.put_line(given_food||' found but does not contain '||given_flavor);
 20  	     else
 21  		  dbms_output.put_line(given_food||' not found');
 22  	     end if;
 23  	     select count(*) into counting from (select * from products where given_flavor = flavor);
 24  	     if counting != 0 then
 25  		 dbms_output.put_line(given_flavor||' found but not containted in '||given_food);
 26  	     else
 27  		 dbms_output.put_line(given_flavor||' not found');
 28  	     end if;
 29  	 end if;
 30  end;
 31  /
Enter value for food_to_search: Cake
old   7:     given_food:='&food_to_search';
new   7:     given_food:='Cake';
Enter value for flavor_to_search: Chocolate
old   8:     given_flavor:='&flavor_to_search';
new   8:     given_flavor:='Chocolate';
Given Cake and Chocolate combination is available!!                             
Product id: 20-BC-C-10                                                          

PL/SQL procedure successfully completed.

SQL> /
Enter value for food_to_search: Chocolate
old   7:     given_food:='&food_to_search';
new   7:     given_food:='Chocolate';
Enter value for flavor_to_search: Chocolate
old   8:     given_flavor:='&flavor_to_search';
new   8:     given_flavor:='Chocolate';
Given combination is not found !                                                
Chocolate not found                                                             
Chocolate found but not containted in Chocolate                                 

PL/SQL procedure successfully completed.

SQL> /
Enter value for food_to_search: Tart
old   7:     given_food:='&food_to_search';
new   7:     given_food:='Tart';
Enter value for flavor_to_search: Strawberry
old   8:     given_flavor:='&flavor_to_search';
new   8:     given_flavor:='Strawberry';
Given combination is not found !                                                
Tart found but does not contain Strawberry                                      
Strawberry found but not containted in Tart                                     

PL/SQL procedure successfully completed.

SQL> /
Enter value for food_to_search: Cake
old   7:     given_food:='&food_to_search';
new   7:     given_food:='Cake';
Enter value for flavor_to_search: Vanilla
old   8:     given_flavor:='&flavor_to_search';
new   8:     given_flavor:='Vanilla';
Given combination is not found !                                                
Cake found but does not contain Vanilla                                         
Vanilla found but not containted in Cake                                        

PL/SQL procedure successfully completed.


SQL> REM ** 2. On a given date, find the number of items sold (Use Implicit cursor). **
SQL>   declare
  2    counting int;
  3    date_search Receipts.rdate%type;
  4    record products%rowtype;
  5    begin
  6    date_search:='&date_search';
  7    select count(item) into counting from item_list i join receipts r on i.rno=r.rno where rdate=date_search;
  8   dbms_output.put_line(chr(9));
  9  	 dbms_output.put_line('Number of items sold on '||date_search||' is '||counting);
 10   exception
 11   WHEN NO_DATA_FOUND then
 12   dbms_output.put_line('Given date has no items bought on the particular date');
 13   end;
 14   /
Enter value for date_search: 17-OCT-2007
old   6:   date_search:='&date_search';
new   6:   date_search:='17-OCT-2007';
	                                                                               
Number of items sold on 17-OCT-07 is 11                                         

PL/SQL procedure successfully completed.


SQL> REM ** 3 .An user desired to buy the product with the specific price. Ask the user for a price, find the food item(s) that is equal or closest to the desired price.
REM  Print the product number, food type, flavor and price. Also print the number of items that is equal or closest to the desired price. **

SQL> declare
  2  price_search products.price%type;
  3  record products%rowtype;
  4  cursor c_products is select * from products where abs(price-price_search) = (
  5  select min(abs(price-price_search)) from products);
  6  begin
  7  	 price_search:='&price_search';
  8  	 open c_products;
  9  	 dbms_output.put_line(chr(9));
 10  	 dbms_output.put_line('PRODUCT_ID    FOOD	     FLAVOR	     PRICE');
 11  	 dbms_output.put_line('-------------------------------------------------');
 12  	 loop
 13  	     fetch c_products into record;
 14  	     if c_products%NOTFOUND THEN
 15  		 dbms_output.put_line('-------------------------------------------------');
 16  		 exit;
 17  	      else
 18  		 dbms_output.put_line(record.pid||'	     '||record.food||'		     '||record.flavor||'	     '||record.price);
 19  	     end if;
 20  	 end loop;
 21  	 dbms_output.put_line(c_products%rowcount||' product(s) found EQUAL/CLOSEST to given price.');
 22  	 close c_products;
 23  end;
 24  /
Enter value for price_search: 0.8
old   7:     price_search:='&price_search';
new   7:     price_search:='0.8';
	                                                                               
PRODUCT_ID	FOOD		FLAVOR		PRICE                                                  
-------------------------------------------------                               
70-LEM		Cookie		Lemon		.79                                                      
70-W		Cookie		Walnut		.79                                                       
-------------------------------------------------                               
2 product(s) found EQUAL/CLOSEST to given price.                                

PL/SQL procedure successfully completed.

 
SQL> 
SQL> REM ** 4 Display the customer name along with the details of item and its quantity ordered for the given order number. Also calculate the total quantity ordered 
REM as shown below: **

SQL> 	 declare
  2  	 order_number item_list.rno%type;
  3  	 cust_fname customers.fname%type;
  4  	 cust_lname customers.lname%type;
  5  	 total_qty number(3):=0;
  6  	 cursor details is select food,flavor,count(*) as qty from item_list,products where rno=order_number and pid=item group by food,flavor;
  7  	 record details%rowtype;
  8  begin
  9  	 order_number:='&order_number_to_search';
 10  	 select fname,lname into cust_fname,cust_lname from customers inner join receipts using(cid) where rno=order_number;
 11  	 dbms_output.put_line(chr(9));
 12  	 dbms_output.put_line('Customer name: '||cust_fname||' '||cust_lname);
 13  	 dbms_output.put_line(chr(9));
 14  	 open details;
 15  	 dbms_output.put_line('FOOD'||chr(9)||chr(9)||'FLAVOR'||chr(9)||chr(9)||'QUANTITY');
 16  	 dbms_output.put_line('-------------------------------------------');
 17  	 loop
 18  	     fetch details into record;
 19  	     if details%NOTFOUND THEN
 20  		 exit;
 21  	     else
 22  		 if length(record.flavor) < 8 then
 23  		     dbms_output.put_line(record.food||chr(9)||chr(9)||record.flavor||chr(9)||chr(9)||record.qty);
 24  		 else
 25  		     dbms_output.put_line(record.food||chr(9)||chr(9)||record.flavor||chr(9)||record.qty);
 26  		 end if;
 27  		 total_qty:=total_qty+record.qty;
 28  	     end if;
 29  	 end loop;
 30  	 dbms_output.put_line('-------------------------------------------');
 31  	 dbms_output.put_line('TOTAL QUANTITY			   '||total_qty);
 32  	 close details;
 33  exception
 34  	 when NO_DATA_FOUND THEN
 35  	     dbms_output.put_line(chr(9));
 36  	     dbms_output.put_line('Invalid order number!');
 37  end;
 38  /
Enter value for order_number_to_search: 51991
old   9:     order_number:='&order_number_to_search';
new   9:     order_number:='51991';
	                                                                               
Customer name: SOPKO RAYFORD                                                    
	                                                                               
FOOD		FLAVOR		QUANTITY                                                          
-------------------------------------------                                     
Pie		Apple		1                                                                   
Cake		Truffle		1                                                                
Tart		Apple		1                                                                  
Tart		Chocolate	1                                                               
-------------------------------------------                                     
TOTAL QUANTITY                      4                                           

PL/SQL procedure successfully completed.


SQL> spool off;
