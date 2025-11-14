DECLARE
    V_SO_ID   NUMBER;
    V_SOD_ID  NUMBER; 
    
BEGIN
     
    SELECT AB_SO_ORDER_HEAD_SEQ.CURRVAL
      INTO V_SO_ID
      FROM DUAL;

    CASE :APEX$ROW_STATUS
        WHEN 'C' THEN
           
            INSERT INTO AB_SO_ORDER_DET (
                SO_ID, SOD_TYPE, NO_BAGS, BAG_RATE, TOTAL_AMOUNT,
                REMARKS, STATUS, PRODUCT_CATEGORY_ID
            )
            VALUES (
                :P90_SO_ID,
                '840',
                :NO_BAGS,
                :BAG_RATE,
                :TOTAL_AMOUNT,
                :REMAKRS,
                'Y',
                :PRODUCT_CATEGORY_ID
            )
            RETURNING SOD_ID INTO V_SOD_ID;

            --ADD ITEM ID IN DIFFERENT ROW------
            FOR i IN (
                SELECT TRIM(REGEXP_SUBSTR(:ITEM_ID, '[^:]+', 1, LEVEL)) AS V_LEVEL_1
                  FROM DUAL
                CONNECT BY LEVEL <= REGEXP_COUNT(:ITEM_ID, ':') + 1
            )
            LOOP
                IF i.V_LEVEL_1 IS NOT NULL THEN
                    INSERT INTO AB_SO_ORDER_DET (
                        SOD_IDS,
                        ITEM_ID,
                        SOD_TYPE,
                        STATUS
                    )
                    VALUES (
                        V_SOD_ID,        
                        i.V_LEVEL_1,        
                        '840',
                        'Y'
                    );
                END IF;
            END LOOP;
    END CASE;
END;

