--*****PLEASE ENTER YOUR DETAILS BELOW*****
--T4-tsa-plsql.sql

--Student ID:   33114064
--Student Name: Harshath Muruganantham
--Unit Code:    FIT3171
--Applied Class No: 1

/* Comments for your marker:
For part (a), the check to see if wether review rating was between 1 and 5 was not included in procedure as such a check constraint already exists
in the table, 'review'.

*/

SET SERVEROUTPUT ON

--4(a) 
-- Create a sequence for REVIEW PK
DROP SEQUENCE review_seq;

CREATE SEQUENCE review_seq;

COMMIT;

-- Complete the procedure below
CREATE OR REPLACE PROCEDURE prc_insert_review (
    p_member_id      IN NUMBER,
    p_poi_id         IN NUMBER,
    p_review_comment IN VARCHAR2,
    p_review_rating  IN NUMBER,
    p_output         OUT VARCHAR2
) AS
    var_member_id_found   NUMBER;
    var_poi_id_found      NUMBER;
    new_poi_review_rating point_of_interest.poi_review_rating%TYPE;
BEGIN
    SELECT
        COUNT(member_id)
    INTO var_member_id_found
    FROM
        member
    WHERE
        member_id = p_member_id;

    SELECT
        COUNT(poi_id)
    INTO var_poi_id_found
    FROM
        point_of_interest
    WHERE
        poi_id = p_poi_id;

    IF ( var_member_id_found = 0 ) THEN
        p_output := 'Invalid Member ID, new review insertion process cancelled.';
    ELSE
        IF ( var_poi_id_found = 0 ) THEN
            p_output := 'Invalid POI ID, new review insertion process cancelled.';
        ELSE
            INSERT INTO review VALUES (
                review_seq.NEXTVAL,
                p_member_id,
                sysdate,
                p_review_comment,
                p_review_rating,
                p_poi_id
            );

            SELECT
                round(AVG(review_rating),
                      1)
            INTO new_poi_review_rating
            FROM
                review
            WHERE
                poi_id = p_poi_id;

            UPDATE point_of_interest p
            SET
                poi_review_rating = new_poi_review_rating
            WHERE
                p.poi_id = p_poi_id;

            p_output := 'The new review by Member ID '
                        || p_member_id
                        || ' for POI ID '
                        || p_poi_id
                        || ' has been recorded.'
                        || ' The new average rating for this POI ID is '
                        || to_char(new_poi_review_rating)
                        || '.';

        END IF;
    END IF;

END;
/

-- Write Test Harness for 4(a)
-- before values
SELECT
    member_id,
    resort_id,
    member_no,
    member_fname,
    member_haddress,
    member_email,
    member_phone,
    to_char(member_date_joined, 'ddd-Mon-yyyy'),
    member_points,
    member_id_recby
FROM
    member;

SELECT
    *
FROM
    point_of_interest;

SELECT
    *
FROM
    review;

DECLARE
    output VARCHAR2(200);
BEGIN
    --call the procedure - invalid member id
    prc_insert_review(19999999, 1, 'Fabulous Sighting', 4, output);
    dbms_output.put_line(output);
END;
/

DECLARE
    output VARCHAR2(200);
BEGIN
    --call the procedure - invalid POI id
    prc_insert_review(1, 19999999, 'Fabulous Sighting', 4, output);
    dbms_output.put_line(output);
END;
/

DECLARE
    output VARCHAR2(200);
BEGIN
    --call the procedure - success
    prc_insert_review(1, 2, 'Fabulous Sighting', 4, output);
    dbms_output.put_line(output);
END;
/

DECLARE
    output VARCHAR2(200);
BEGIN
    --call the procedure - success (average update shown)
    prc_insert_review(2, 2, 'Fabulous Sighting', 3, output);
    dbms_output.put_line(output);
END;
/

DECLARE
    output VARCHAR2(200);
BEGIN
    --call the procedure - success (average update shown)
    prc_insert_review(3, 2, 'Fabulous Sighting', 4, output);
    dbms_output.put_line(output);
END;
/

--after value
SELECT
    poi_id,
    poi_review_rating
FROM
    point_of_interest
WHERE
    poi_id = 2;

SELECT
    review_id,
    member_id,
    to_char(review_date_time, 'dd-Mon-yyyy'),
    rpad(review_comment, 30, ' ') AS review_comment,
    review_rating,
    poi_id
FROM
    review;

ROLLBACK;

--4(b) 
--Write your trigger statement, 
--finish it with a slash(/) followed by a blank line

CREATE OR REPLACE TRIGGER add_recby_member_check BEFORE
    INSERT ON member
    FOR EACH ROW
DECLARE
    check_resort_id member.resort_id%TYPE;
BEGIN
    SELECT
        resort_id
    INTO check_resort_id
    FROM
        member
    WHERE
        member_id = :new.member_id_recby;

    IF ( check_resort_id != :new.resort_id ) THEN
        raise_application_error(-20000, ' A new member may only be recommended by another member within the same resort.'
        );
    END IF;

    UPDATE member
    SET
        member_points = member_points + 10
    WHERE
        member_id = :new.member_id_recby;

    UPDATE resort
    SET
        resort_member_numbers = resort_member_numbers + 1
    WHERE
        resort_id = :new.resort_id;

    dbms_output.put_line('New member succesfuly inserted. The existing member who recommends the new member has received an extra 10 member point. The resort member numbers value has been updated.'
    );
END;
/

-- Write Test Harness for 4(b)

--Prior state
SELECT
    resort_id,
    resort_member_numbers
FROM
    resort
WHERE
    resort_id = 1;

SELECT
    member_id,
    resort_id,
    member_no,
    member_fname,
    member_haddress,
    member_email,
    member_phone,
    to_char(member_date_joined, 'ddd-Mon-yyyy'),
    member_points,
    member_id_recby
FROM
    member;
    
--Test trigger ( shouldn't work)
INSERT INTO member VALUES (
    5,
    1,
    3,
    'James',
    'Bond',
    '52 Cambridge Drive, Glen Waverley VIC',
    'k16veerarag@gmail.com',
    '0411112336',
    sysdate,
    1000,
    2
);

-- Test trigger should work
--Test trigger ( shouldn't work)
INSERT INTO member VALUES (
    5,
    1,
    3,
    'James',
    'Bond',
    '52 Cambridge Drive, Glen Waverley VIC',
    'k16veerarag@gmail.com',
    '0411112336',
    sysdate,
    1000,
    4
);

--Post state
--Insertition of new member
SELECT
    member_id,
    resort_id,
    member_no,
    member_fname,
    member_gname,
    member_haddress,
    member_email,
    member_phone,
    to_char(member_date_joined, 'ddd-Mon-yyyy'),
    member_points,
    member_id_recby
FROM
    member
WHERE
    member_id = 5;

--Increase of recby member points by 10
SELECT
    member_id,
    resort_id,
    member_no,
    member_points
FROM
    member
WHERE
    member_id = 4;

--Increementing resort member numbers by 1
SELECT
    resort_id,
    resort_member_numbers
FROM
    resort
WHERE
    resort_id = 1;

ROLLBACK;