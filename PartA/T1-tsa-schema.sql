--*****PLEASE ENTER YOUR DETAILS BELOW*****
--T1-tsa-schema.sql

--Student ID:   33114064
--Student Name: Harshath Muruganantham
--Unit Code:    FIT3171
--Applied Class No: 1

/* Comments for your marker:

*/

-- Task 1 Add Create table statements for the white TABLES below
-- Ensure all column comments, and constraints (other than FK's)
-- are included. FK constraints are to be added at the end of this script

-- BOOKING
CREATE TABLE booking (
    booking_id                NUMBER(8) NOT NULL,
    resort_id                 NUMBER(4) NOT NULL,
    cabin_no                  NUMBER(3) NOT NULL,
    booking_from              DATE NOT NULL,
    booking_to                DATE NOT NULL,
    booking_noadults          NUMBER(2) NOT NULL,
    booking_nochildren        NUMBER(2) NOT NULL,
    booking_total_points_cost NUMBER(4) NOT NULL,
    member_id                 NUMBER(6) NOT NULL,
    staff_id                  NUMBER(5) NOT NULL
);

COMMENT ON COLUMN booking.booking_id IS
    'Booking ID';

COMMENT ON COLUMN booking.resort_id IS
    'Resort ID';

COMMENT ON COLUMN booking.cabin_no IS
    'Cabin Number';

COMMENT ON COLUMN booking.booking_from IS
    'Booking Start Date';

COMMENT ON COLUMN booking.booking_to IS
    'Booking End Date';

COMMENT ON COLUMN booking.booking_noadults IS
    'Number of adults';

COMMENT ON COLUMN booking.booking_nochildren IS
    'Numberr of Children';

COMMENT ON COLUMN booking.booking_total_points_cost IS
    'Booking Total Points Cost';

COMMENT ON COLUMN booking.member_id IS
    'Member ID';

COMMENT ON COLUMN booking.staff_id IS
    'Staff ID';

ALTER TABLE booking
    ADD CONSTRAINT booking_uq UNIQUE ( resort_id,
                                       cabin_no,
                                       booking_from );

ALTER TABLE booking ADD CONSTRAINT booking_pk PRIMARY KEY ( booking_id );



COMMIT;

-- CABIN
CREATE TABLE cabin (
    resort_id               NUMBER(4) NOT NULL,
    cabin_no                NUMBER(3) NOT NULL,
    cabin_nobedrooms        NUMBER(1) NOT NULL,
    cabin_sleeping_capacity NUMBER(2) NOT NULL,
    cabin_bathroom_type     CHAR(1) NOT NULL,
    cabin_points_cost_day   NUMBER(4) NOT NULL,
    cabin_description       VARCHAR(250) NOT NULL
);

COMMENT ON COLUMN cabin.resort_id IS
    'Resort ID';

COMMENT ON COLUMN cabin.cabin_no IS
    'Cabin Number';

COMMENT ON COLUMN cabin.cabin_nobedrooms IS
    'Number of Bedrooms in Cabin';

COMMENT ON COLUMN cabin.cabin_sleeping_capacity IS
    'Cabin Sleeping Capacity';

COMMENT ON COLUMN cabin.cabin_bathroom_type IS
    'Cabin Bathroom Type';

COMMENT ON COLUMN cabin.cabin_points_cost_day IS
    'Cabin Points Cost per Day ';

COMMENT ON COLUMN cabin.cabin_description IS
    'Cabin Description';

ALTER TABLE cabin ADD CONSTRAINT cabin_pk PRIMARY KEY ( resort_id,
                                                        cabin_no );

ALTER TABLE cabin
    ADD CONSTRAINT cabin_nobedrooms_ck CHECK ( cabin_nobedrooms BETWEEN 1 AND 4 );

ALTER TABLE cabin
    ADD CONSTRAINT cabin_bathroom_type_ck CHECK ( cabin_bathroom_type IN ( 'I', 'C' )
    );

COMMIT;

-- Add all missing FK Constraints below here

ALTER TABLE booking
    ADD CONSTRAINT member_booking_fk FOREIGN KEY ( member_id )
        REFERENCES member ( member_id );

ALTER TABLE booking
    ADD CONSTRAINT staff_booking_fk FOREIGN KEY ( staff_id )
        REFERENCES staff ( staff_id );

ALTER TABLE cabin
    ADD CONSTRAINT resort_cabin_fk FOREIGN KEY ( resort_id )
        REFERENCES resort ( resort_id );

ALTER TABLE booking
    ADD CONSTRAINT booking_cabin_fk FOREIGN KEY ( resort_id,
                                                  cabin_no )
        REFERENCES cabin ( resort_id,
                           cabin_no );

COMMIT;

--**Trigger for checking and updating member.member_points for each booking.**--
--**Run this code before attempting Task 2 and Task 3**--
--**DO NOT REMOVE. DO NOT MODIFY**--
CREATE OR REPLACE TRIGGER check_member_points BEFORE
    INSERT OR DELETE OR UPDATE OF booking_total_points_cost ON booking
    FOR EACH ROW
DECLARE
    var_mem_points NUMBER;
BEGIN
    IF inserting THEN
        SELECT
            member_points
        INTO var_mem_points
        FROM
            member
        WHERE
            member_id = :new.member_id;

        IF var_mem_points < :new.booking_total_points_cost THEN
            raise_application_error(-20001, 'Not enough member points for this booking'
            );
        ELSE
            var_mem_points := var_mem_points - :new.booking_total_points_cost;
            UPDATE member
            SET
                member_points = var_mem_points
            WHERE
                member_id = :new.member_id;

        END IF;

        dbms_output.put_line('New booking added for member '
                             || :new.member_id
                             || '. Remaining points for this member: '
                             || var_mem_points);

    END IF;

    IF deleting THEN
        SELECT
            member_points
        INTO var_mem_points
        FROM
            member
        WHERE
            member_id = :old.member_id;

        var_mem_points := var_mem_points + :old.booking_total_points_cost;
        UPDATE member
        SET
            member_points = var_mem_points
        WHERE
            member_id = :old.member_id;

        dbms_output.put_line('Booking '
                             || :old.booking_id
                             || ' for member '
                             || :old.member_id
                             || ' was deleted. Remaining points for this member: '
                             || var_mem_points);

    END IF;

    IF updating THEN
        SELECT
            member_points
        INTO var_mem_points
        FROM
            member
        WHERE
            member_id = :new.member_id;

        var_mem_points := var_mem_points + :old.booking_total_points_cost;
        IF var_mem_points < :new.booking_total_points_cost THEN
            raise_application_error(-20001, 'Not enough member points for this booking'
            );
        ELSE
            var_mem_points := var_mem_points - :new.booking_total_points_cost;
            UPDATE member
            SET
                member_points = var_mem_points
            WHERE
                member_id = :new.member_id;

            dbms_output.put_line('Booking '
                                 || :old.booking_id
                                 || ' for member '
                                 || :new.member_id
                                 || ' was updated. Remaining points for this member: '
                                 || var_mem_points);

        END IF;

    END IF;

END;
/
--**End of trigger**--