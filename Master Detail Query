begin
     case :APEX$ROW_STATUS
     when 'C' then -- Note: In EA2 this has been changed from I to C for consistency with Tabular Forms
         insert into EMPLOYEES ( EMPLOYEES_NAME, DEPT_ID, JOB_id, CITY )
         values ( :EMPLOYEES_NAME, :P11_DEPT_ID,	:JOB_id,	:CITY)
         returning EMP_ID into :EMP_ID;
     when 'U' then
         update EMPLOYEES SET 
          EMPLOYEES_NAME =  :EMPLOYEES_NAME, 
          DEPT_ID = :P11_DEPT_ID,
          JOB_id  =  :JOB_id,
          CITY = :CITY
          where EMP_ID  = :EMP_ID;
     when 'D' then
         delete EMPLOYEES
         where EMP_ID = :EMP_ID;
     end case;
end;
