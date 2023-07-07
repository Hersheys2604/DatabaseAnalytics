/*****PLEASE ENTER YOUR DETAILS BELOW*****/
--T2-tsa-insert.sql

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

--------------------------------------
--INSERT INTO cabin
--------------------------------------
INSERT INTO cabin VALUES (
    1,
    1,
    1,
    2,
    'C',
    101,
    'Studio Cabin'
);

INSERT INTO cabin VALUES (
    1,
    2,
    2,
    4,
    'I',
    116,
    'Two Bedroom Suite'
);

INSERT INTO cabin VALUES (
    1,
    3,
    3,
    6,
    'I',
    123,
    'Family Suite '
);

INSERT INTO cabin VALUES (
    1,
    4,
    4,
    8,
    'C',
    150,
    'Luxury Cabin'
);

INSERT INTO cabin VALUES (
    2,
    1,
    1,
    2,
    'C',
    102,
    'Studio Cabin'
);

INSERT INTO cabin VALUES (
    2,
    2,
    2,
    4,
    'C',
    119,
    'Two Bedroom Suite'
);

INSERT INTO cabin VALUES (
    2,
    3,
    3,
    6,
    'I',
    125,
    'Family Suite '
);

INSERT INTO cabin VALUES (
    2,
    4,
    4,
    8,
    'I',
    147,
    'Luxury Cabin'
);

INSERT INTO cabin VALUES (
    3,
    1,
    1,
    2,
    'I',
    107,
    'Studio Cabin'
);

INSERT INTO cabin VALUES (
    3,
    2,
    2,
    4,
    'C',
    119,
    'Two Bedroom Suite'
);

INSERT INTO cabin VALUES (
    3,
    3,
    3,
    6,
    'I',
    124,
    'Family Suite '
);

INSERT INTO cabin VALUES (
    3,
    4,
    4,
    8,
    'C',
    133,
    'Luxury Cabin'
);

INSERT INTO cabin VALUES (
    4,
    1,
    1,
    2,
    'C',
    105,
    'Studio Cabin'
);

INSERT INTO cabin VALUES (
    4,
    2,
    2,
    4,
    'I',
    114,
    'Two Bedroom Suite'
);

INSERT INTO cabin VALUES (
    5,
    1,
    2,
    4,
    'C',
    147,
    'Two Bedroom Suite'
);

INSERT INTO cabin VALUES (
    6,
    1,
    2,
    4,
    'C',
    132,
    'Two Bedroom Suite'
);

INSERT INTO cabin VALUES (
    7,
    1,
    2,
    4,
    'I',
    101,
    'Two Bedroom Suite'
);

INSERT INTO cabin VALUES (
    8,
    1,
    2,
    4,
    'I',
    114,
    'Two Bedroom Suite'
);

INSERT INTO cabin VALUES (
    9,
    1,
    2,
    4,
    'I',
    125,
    'Two Bedroom Suite'
);

INSERT INTO cabin VALUES (
    10,
    1,
    2,
    4,
    'C',
    140,
    'Two Bedroom Suite'
);

COMMIT;
--------------------------------------
--INSERT INTO booking
--------------------------------------
INSERT INTO booking VALUES (
    1,
    1,
    3,
    TO_DATE('5/03/2023', 'dd/mm/yyyy'),
    TO_DATE('9/03/2023', 'dd/mm/yyyy'),
    4,
    0,
    492,
    2,
    1
);

INSERT INTO booking VALUES (
    2,
    1,
    3,
    TO_DATE('1/03/2023', 'dd/mm/yyyy'),
    TO_DATE('4/04/2023', 'dd/mm/yyyy'),
    1,
    3,
    369,
    2,
    1
);

INSERT INTO booking VALUES (
    3,
    1,
    3,
    TO_DATE('16/04/2023', 'dd/mm/yyyy'),
    TO_DATE('23/04/2023', 'dd/mm/yyyy'),
    3,
    3,
    861,
    2,
    2
);

INSERT INTO booking VALUES (
    4,
    1,
    4,
    TO_DATE('17/03/2023', 'dd/mm/yyyy'),
    TO_DATE('23/04/2023', 'dd/mm/yyyy'),
    5,
    1,
    900,
    9,
    2
);

INSERT INTO booking VALUES (
    5,
    2,
    4,
    TO_DATE('6/03/2023', 'dd/mm/yyyy'),
    TO_DATE('9/03/2023', 'dd/mm/yyyy'),
    6,
    1,
    441,
    4,
    3
);

INSERT INTO booking VALUES (
    6,
    2,
    4,
    TO_DATE('1/04/2023', 'dd/mm/yyyy'),
    TO_DATE('3/04/2023', 'dd/mm/yyyy'),
    8,
    0,
    294,
    4,
    3
);

INSERT INTO booking VALUES (
    7,
    2,
    4,
    TO_DATE('28/04/2023', 'dd/mm/yyyy'),
    TO_DATE('29/04/2023', 'dd/mm/yyyy'),
    7,
    0,
    147,
    4,
    4
);

INSERT INTO booking VALUES (
    8,
    2,
    3,
    TO_DATE('6/03/2023', 'dd/mm/yyyy'),
    TO_DATE('13/03/2023', 'dd/mm/yyyy'),
    1,
    5,
    875,
    7,
    4
);

INSERT INTO booking VALUES (
    9,
    3,
    2,
    TO_DATE('6/03/2023', 'dd/mm/yyyy'),
    TO_DATE('8/03/2023', 'dd/mm/yyyy'),
    4,
    0,
    238,
    22,
    5
);

INSERT INTO booking VALUES (
    10,
    3,
    2,
    TO_DATE('7/04/2023', 'dd/mm/yyyy'),
    TO_DATE('12/04/2023', 'dd/mm/yyyy'),
    1,
    0,
    595,
    22,
    6
);

INSERT INTO booking VALUES (
    11,
    3,
    2,
    TO_DATE('23/04/2023', 'dd/mm/yyyy'),
    TO_DATE('24/04/2023', 'dd/mm/yyyy'),
    1,
    2,
    119,
    22,
    7
);

INSERT INTO booking VALUES (
    12,
    3,
    3,
    TO_DATE('16/04/2023', 'dd/mm/yyyy'),
    TO_DATE('19/04/2023', 'dd/mm/yyyy'),
    4,
    1,
    372,
    10,
    5
);

INSERT INTO booking VALUES (
    13,
    4,
    1,
    TO_DATE('6/03/2023', 'dd/mm/yyyy'),
    TO_DATE('11/03/2023', 'dd/mm/yyyy'),
    1,
    0,
    525,
    12,
    8
);

INSERT INTO booking VALUES (
    14,
    4,
    1,
    TO_DATE('16/03/2023', 'dd/mm/yyyy'),
    TO_DATE('21/03/2023', 'dd/mm/yyyy'),
    1,
    0,
    525,
    3,
    9
);

INSERT INTO booking VALUES (
    15,
    4,
    1,
    TO_DATE('21/04/2023', 'dd/mm/yyyy'),
    TO_DATE('24/04/2023', 'dd/mm/yyyy'),
    1,
    0,
    420,
    12,
    8
);

INSERT INTO booking VALUES (
    16,
    4,
    2,
    TO_DATE('6/03/2023', 'dd/mm/yyyy'),
    TO_DATE('11/03/2023', 'dd/mm/yyyy'),
    2,
    1,
    420,
    3,
    9
);

INSERT INTO booking VALUES (
    17,
    5,
    1,
    TO_DATE('15/03/2023', 'dd/mm/yyyy'),
    TO_DATE('20/04/2023', 'dd/mm/yyyy'),
    3,
    1,
    735,
    24,
    10
);

INSERT INTO booking VALUES (
    18,
    6,
    1,
    TO_DATE('5/03/2023', 'dd/mm/yyyy'),
    TO_DATE('12/03/2023', 'dd/mm/yyyy'),
    4,
    0,
    924,
    21,
    11
);

INSERT INTO booking VALUES (
    19,
    7,
    1,
    TO_DATE('13/03/2023', 'dd/mm/yyyy'),
    TO_DATE('22/03/2023', 'dd/mm/yyyy'),
    1,
    0,
    909,
    5,
    14
);

INSERT INTO booking VALUES (
    20,
    8,
    1,
    TO_DATE('16/03/2023', 'dd/mm/yyyy'),
    TO_DATE('23/03/2023', 'dd/mm/yyyy'),
    2,
    1,
    798,
    15,
    15
);

COMMIT;