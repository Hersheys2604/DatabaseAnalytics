--*****PLEASE ENTER YOUR DETAILS BELOW*****
--T3-tsa-dm.sql

--Student ID:   33114064
--Student Name: Harshath Muruganantham
--Unit Code:    FIT3171
--Applied Class No: 1

/* Comments for your marker:


*/

---**This command shows the outputs of triggers**---
---**Run the command before running the insert statements.**---
---**Do not remove**---
SET SERVEROUTPUT ON
---**end**---

--3(a)
DROP SEQUENCE booking_seq;

CREATE SEQUENCE booking_seq START WITH 100 INCREMENT BY 10;

COMMIT;


--3(b)
INSERT INTO cabin VALUES (
    (
        SELECT
            resort_id
        FROM
                 resort r
            JOIN town t
            ON r.town_id = t.town_id
        WHERE
                upper(resort_name) = upper('Awesome Resort')
            AND town_lat = - 17.9644
            AND town_long = 122.2304
    ),
    4,
    4,
    10,
    'I',
    220,
    'Ultimate Newly Built Cabin'
);

COMMIT;


--3(c)
INSERT INTO booking VALUES (
    booking_seq.NEXTVAL,
    (
        SELECT
            resort_id
        FROM
                 resort r
            JOIN town t
            ON r.town_id = t.town_id
        WHERE
                upper(resort_name) = upper('Awesome Resort')
            AND town_lat = - 17.9644
            AND town_long = 122.2304
    ),
    4,
    TO_DATE('26/May/2023', 'dd/Mon/yyyy'),
    TO_DATE('28/May/2023', 'dd/Mon/yyyy'),
    4,
    4,
    (
        SELECT
            cabin_points_cost_day
        FROM
            cabin
        WHERE
                (
                    SELECT
                        resort_id
                    FROM
                             resort r
                        JOIN town t
                        ON r.town_id = t.town_id
                    WHERE
                            upper(resort_name) = upper('Awesome Resort')
                        AND town_lat = - 17.9644
                        AND town_long = 122.2304
                ) = resort_id
            AND cabin_no = 4
    ) * ( TO_DATE('28/May/2023', 'dd/Mon/yyyy') - TO_DATE('26/May/2023', 'dd/Mon/yyyy'
    ) ),
    (
        SELECT
            member_id
        FROM
            member
        WHERE
                member_no = 2
            AND resort_id = 9
            AND upper(member_gname) = upper('Noah')
            AND upper(member_fname) = upper('Garrard')
    ),
    (
        SELECT
            staff_id
        FROM
            staff
        WHERE
                staff_phone = '0493427245'
            AND upper(staff_gname) = upper('Reeba')
            AND upper(staff_fname) = upper('Wildman')
    )
);


COMMIT;


--3(d)
UPDATE booking
SET
    booking_to = TO_DATE('29/May/2023', 'dd/Mon/yyyy'),
    booking_total_points_cost = booking_total_points_cost + (
        SELECT
            cabin_points_cost_day
        FROM
            cabin
        WHERE
                (
                    SELECT
                        resort_id
                    FROM
                             resort r
                        JOIN town t
                        ON r.town_id = t.town_id
                    WHERE
                            upper(resort_name) = upper('Awesome Resort')
                        AND town_lat = - 17.9644
                        AND town_long = 122.2304
                ) = resort_id
            AND cabin_no = 4
    ) * 1
WHERE
        member_id = (
            SELECT
                member_id
            FROM
                member
            WHERE
                    member_no = 2
                AND resort_id = 9
                AND upper(member_gname) = upper('Noah')
                AND upper(member_fname) = upper('Garrard')
        )
    AND resort_id = (
        SELECT
            resort_id
        FROM
                 resort r
            JOIN town t
            ON r.town_id = t.town_id
        WHERE
                upper(resort_name) = upper('Awesome Resort')
            AND town_lat = - 17.9644
            AND town_long = 122.2304
    )
    AND cabin_no = 4
    AND booking_from = TO_DATE('26/May/2023', 'dd/Mon/yyyy');


COMMIT;


--3(e)
DELETE FROM booking
WHERE
        resort_id = (
            SELECT
                resort_id
            FROM
                     resort r
                JOIN town t
                ON r.town_id = t.town_id
            WHERE
                    upper(resort_name) = upper('Awesome Resort')
                AND town_lat = - 17.9644
                AND town_long = 122.2304
        )
    AND cabin_no = 4;
    
DELETE FROM cabin
WHERE
        resort_id = (
            SELECT
                resort_id
            FROM
                     resort r
                JOIN town t
                ON r.town_id = t.town_id
            WHERE
                    upper(resort_name) = upper('Awesome Resort')
                AND town_lat = - 17.9644
                AND town_long = 122.2304
        )
    AND cabin_no = 4;


COMMIT;





