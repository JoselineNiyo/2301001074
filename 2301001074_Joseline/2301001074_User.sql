-- 2301001075_Joseline 
-- creation of user
create  database Smart_Automation_System;
create user 'JoselineNiyo'@'127.0.0.1'
identified by 'Project';
/*grant the permission to the user
on the created database*/
grant  all privileges on Smart_Automation_System.* to 'JoselineNiyo'@'127.0.0.1';
/*allow the permission*/
flush privileges;