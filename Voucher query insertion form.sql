DECLARE
    V_VOUCHER_COUNT  NUMBER := 0;
    V_VOUCHER_NAME   VARCHAR2(200);
    V_VOUCHER_TYPE   VARCHAR2(100);
BEGIN
    -- Get Voucher Type Name
    SELECT DESCRIPTION
      INTO V_VOUCHER_TYPE
      FROM AB_LOOKUP_DETAIL
     WHERE STATUS = 'Y'
       AND MAST_ID = 39
       AND DET_ID  = :P998_VOUCHER_TYPE_ID;

    -- Get next sequence number for current year & type
    SELECT  NVL(COUNT(*),0)+1
      INTO V_VOUCHER_COUNT
      FROM AB_FIN_TRANSACTION TR
     WHERE TR.TR_TYPE        = 635
       AND TR.ORG_ID         = :GV_ORG_ID
       AND TR.VOUCHER_TYPE_ID= :P998_VOUCHER_TYPE_ID
       AND TR.STATUS         = 'Y'
       AND TR.CREATED_ON    >= TRUNC(SYSDATE, 'YYYY');

    -- Generate Voucher Name: e.g. "GENERAL VOUCHER - 25 - 7"
    V_VOUCHER_NAME := V_VOUCHER_TYPE 
                      || ' - ' 
                      || TO_CHAR(SYSDATE, 'YY') 
                      || ' - ' 
                      || CASE WHEN V_VOUCHER_COUNT=0 THEN 1 ELSE V_VOUCHER_COUNT END ;

    -- Insert Voucher
    INSERT INTO AB_FIN_TRANSACTION
           (TR_TYPE,
            TR_DATE,
            STATUS,
            VOUCHER_NAME,
            VOUCHER_TYPE_ID)
    VALUES (635,
            TO_DATE(:P998_TR_DATE, 'DD-MON-YYYY'),
            'Y',
            V_VOUCHER_NAME,
            :P998_VOUCHER_TYPE_ID
           );

    COMMIT;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20001, 'Invalid Voucher Type selected.');
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20002, 'Error while creating voucher: ' || SQLERRM);
END;
