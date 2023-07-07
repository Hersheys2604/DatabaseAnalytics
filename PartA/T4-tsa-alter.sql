--*****PLEASE ENTER YOUR DETAILS BELOW*****
--T4-tsa-alter.sql

--Student ID:   33114064
--Student Name: Harshath Muruganantham
--Unit Code:    FIT3171
--Applied Class No: 1

/* Comments for your marker:

For 4(b) a lookup table was used instead of check constraints as the TSA would also like to expand the list of roles in the future.
One Assumption for 4c is that the times that different staff can clean a cabin can be different in the same day. 
i.e. Staff A can clean cabin 1 from 2-3pm and Staff B can clean the same cabin from 3-4pm on the same day. This still counts as one clean, they
are just cleaning different parts of the room.
*/

--4(a)

ALTER TABLE cabin ADD cabin_total_bookings NUMBER(7) DEFAULT 0 NOT NULL;

COMMENT ON COLUMN cabin.cabin_total_bookings IS
    'Cabin Total No. of Bookings';

UPDATE cabin c
SET
    cabin_total_bookings = (
        SELECT
            COUNT(*)
        FROM
            booking
        WHERE
                resort_id = c.resort_id
            AND cabin_no = c.cabin_no
    );

SELECT
    resort_id,
    cabin_no,
    cabin_total_bookings
FROM
    cabin
ORDER BY
    resort_id,
    cabin_no;

desc cabin;

COMMIT;
--4(b)
DROP TABLE staff_role CASCADE CONSTRAINTS PURGE;

CREATE TABLE staff_role (
    sr_id   CHAR(1) NOT NULL,
    sr_name VARCHAR2(100) NOT NULL,
    sr_desc VARCHAR(100) NOT NULL
);

COMMENT ON COLUMN staff_role.sr_id IS
    'Staff Role ID';

COMMENT ON COLUMN staff_role.sr_name IS
    'Staff Role Name';

COMMENT ON COLUMN staff_role.sr_desc IS
    'Staff Role Description';

ALTER TABLE staff_role ADD CONSTRAINT staff_role_pk PRIMARY KEY ( sr_id );

INSERT INTO staff_role VALUES (
    'A',
    'Admin',
    'Take bookings, and reply to customer inquiries'
);

INSERT INTO staff_role VALUES (
    'C',
    'Cleaning',
    'Clean cabins and maintain resort''s public area'
);

INSERT INTO staff_role VALUES (
    'M',
    'Marketing',
    'Prepare and present marketing ideas and deliverables'
);

ALTER TABLE staff ADD sr_id CHAR(1);

COMMENT ON COLUMN staff.sr_id IS
    'Staff Role ID';

ALTER TABLE staff
    ADD CONSTRAINT staff_role_fk FOREIGN KEY ( sr_id )
        REFERENCES staff_role ( sr_id );

UPDATE staff s
SET
    sr_id = 'A';

ALTER TABLE staff MODIFY (
    sr_id NOT NULL
);

SELECT
    *
FROM
    staff_role;

SELECT
    staff_id,
    resort_id,
    staff_gname
    || ' '
    || staff_fname AS "Staff Name",
    s.sr_id,
    sr_name,
    sr_desc
FROM
         staff s
    JOIN staff_role sr
    ON s.sr_id = sr.sr_id
ORDER BY
    staff_id;

desc staff_role;
desc staff;

COMMIT;

        
--4(c)
DROP TABLE cabin_cleaning CASCADE CONSTRAINTS PURGE;

DROP TABLE staff_cleaning CASCADE CONSTRAINTS PURGE;

CREATE TABLE cabin_cleaning (
    cabin_cleaning_id   NUMBER(4) NOT NULL,
    resort_id           NUMBER(4) NOT NULL,
    cabin_no            NUMBER(3) NOT NULL,
    cabin_cleaning_date DATE NOT NULL
);

COMMENT ON COLUMN cabin_cleaning.cabin_cleaning_id IS
    'Cabin Cleaning ID';

COMMENT ON COLUMN cabin_cleaning.resort_id IS
    'Resort ID';

COMMENT ON COLUMN cabin_cleaning.cabin_no IS
    'Cabin Number';

COMMENT ON COLUMN cabin_cleaning.cabin_cleaning_date IS
    'Cabin Cleaning Date';

ALTER TABLE cabin_cleaning
    ADD CONSTRAINT cabin_cleaning_uq UNIQUE ( resort_id,
                                              cabin_no,
                                              cabin_cleaning_date );

ALTER TABLE cabin_cleaning ADD CONSTRAINT cabin_cleaning_pk PRIMARY KEY ( cabin_cleaning_id
);

ALTER TABLE cabin_cleaning
    ADD CONSTRAINT cabin_cabin_cleaning_fk FOREIGN KEY ( resort_id,
                                                         cabin_no )
        REFERENCES cabin ( resort_id,
                           cabin_no );

CREATE TABLE staff_cleaning (
    cabin_cleaning_id NUMBER(4) NOT NULL,
    staff_id          NUMBER(4) NOT NULL,
    sc_start_time     TIMESTAMP NOT NULL,
    sc_end_time       TIMESTAMP NOT NULL
);

COMMENT ON COLUMN staff_cleaning.cabin_cleaning_id IS
    'Cabin Cleaning ID';

COMMENT ON COLUMN staff_cleaning.staff_id IS
    'Staff ID';

COMMENT ON COLUMN staff_cleaning.sc_start_time IS
    'Staff Cleaning Start Time';

COMMENT ON COLUMN staff_cleaning.sc_end_time IS
    'Staff Cleaning End Time';

ALTER TABLE staff_cleaning ADD CONSTRAINT staff_cleaning_pk PRIMARY KEY ( cabin_cleaning_id
,
                                                                          staff_id );

ALTER TABLE staff_cleaning
    ADD CONSTRAINT staff_staff_cleaning_fk FOREIGN KEY ( staff_id )
        REFERENCES staff ( staff_id );

ALTER TABLE cabin_cleaning
    ADD CONSTRAINT cabin_cleaning_sf_fk FOREIGN KEY ( cabin_cleaning_id )
        REFERENCES cabin_cleaning ( cabin_cleaning_id );

desc cabin_cleaning;
desc staff_cleaning;

COMMIT;