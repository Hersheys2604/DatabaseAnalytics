--*****PLEASE ENTER YOUR DETAILS BELOW*****
--T2-tsa-select.sql

--Student ID:   33114064
--Student Name: Harshath Muruganantham
--Unit Code:    FIT3171
--Applied Class No: 1

/* Comments for your marker:
For 2e, for teh member "Dalley", althhough her total charge is 1540, she hadn't paid anything to-date (as supported by the 
null entry in mc_paid_date), therefore her mc_total was set to 0 as she hasn't paid anything. This was the case for the otehr members
with similar storiess as well.
*/

/*2(a)*/
-- PLEASE PLACE REQUIRED SQL STATEMENT FOR THIS PART HERE
-- ENSURE that your query is formatted and has a semicolon
-- (;) at the end of this answer

SELECT
    t.town_id,
    town_name,
    p.poi_type_id,
    poi_type_descr,
    COUNT(p.poi_type_id) AS poi_count
FROM
         tsa.point_of_interest p
    JOIN tsa.town     t
    ON p.town_id = t.town_id
    JOIN tsa.poi_type pt
    ON p.poi_type_id = pt.poi_type_id
GROUP BY
    t.town_id,
    town_name,
    p.poi_type_id,
    poi_type_descr
HAVING
    COUNT(p.poi_type_id) > 1
ORDER BY
    t.town_id,
    poi_type_descr;


/*2(b)*/
-- PLEASE PLACE REQUIRED SQL STATEMENT FOR THIS PART HERE
-- ENSURE that your query is formatted and has a semicolon
-- (;) at the end of this answer
SELECT
    m.member_id,
    m.member_gname
    || ' '
    || m.member_fname         AS member_name,
    m.resort_id,
    resort_name,
    COUNT(mc.member_id_recby) AS number_of_recommendations
FROM
         tsa.member m
    JOIN tsa.member mc
    ON m.member_id = mc.member_id_recby
    JOIN tsa.resort r
    ON m.resort_id = r.resort_id
GROUP BY
    m.member_id,
    m.member_gname
    || ' '
    || m.member_fname,
    m.resort_id,
    resort_name
HAVING
    COUNT(mc.member_id_recby) = (
        SELECT
            MAX(COUNT(member_id_recby))
        FROM
            tsa.member
        GROUP BY
            member_id_recby
    )
ORDER BY
    resort_id,
    member_id;


/*2(c)*/
-- PLEASE PLACE REQUIRED SQL STATEMENT FOR THIS PART HERE
-- ENSURE that your query is formatted and has a semicolon
-- (;) at the end of this answer
SELECT
    p.poi_id,
    poi_name,
    rpad(decode(MAX(review_rating),
                NULL,
                'NR',
                lpad(MAX(review_rating),2,' ')),
         10,
         ' ')              AS max_rating,
    rpad(decode(MIN(review_rating),
                NULL,
                'NR',
                lpad(MIN(review_rating),2,' ')),
         10,
         ' ')              AS min_rating,
    rpad(decode(to_char(AVG(review_rating),
                   '9.9'),
           NULL,
           'NR',
           to_char(AVG(review_rating),
                   '9.9')),10,' ') AS avg_rating
FROM
    tsa.review            r
    RIGHT OUTER JOIN tsa.point_of_interest p
    ON r.poi_id = p.poi_id
GROUP BY
    p.poi_id,
    poi_name
ORDER BY
    p.poi_id;

/*2(d)*/
-- PLEASE PLACE REQUIRED SQL STATEMENT FOR THIS PART HERE
-- ENSURE that your query is formatted and has a semicolon
-- (;) at the end of this answer
SELECT
    poi_name,
    poi_type_descr,
    town_name,
    lpad('Lat: '
         || to_char(town_lat, '99.999999')
         || ' Long:'
         || to_char(town_long, '999.999999'),
         35,
         ' ')        AS town_location,
    COUNT(review_id) AS reviews_completed,
    decode(COUNT(review_id) /(
        SELECT
            COUNT(review_id)
        FROM
            tsa.review
    ) * 100,
           0,
           'No reviews completed',
           round(COUNT(review_id) /(
        SELECT
            COUNT(review_id)
        FROM
            tsa.review
    ) * 100,
                 2)
           || '%')          AS percent_of_reviews
FROM
    tsa.review            r
    RIGHT OUTER JOIN tsa.point_of_interest p
    ON r.poi_id = p.poi_id
    JOIN tsa.poi_type          pt
    ON p.poi_type_id = pt.poi_type_id
    JOIN tsa.town              t
    ON p.town_id = t.town_id
GROUP BY
    poi_name,
    poi_type_descr,
    town_name,
    lpad('Lat: '
         || to_char(town_lat, '99.999999')
         || ' Long:'
         || to_char(town_long, '999.999999'),
         35,
         ' ')
ORDER BY
    town_name,
    COUNT(review_id) DESC,
    poi_name;
    
/*2(e)*/
-- PLEASE PLACE REQUIRED SQL STATEMENT FOR THIS PART HERE
-- ENSURE that your query is formatted and has a semicolon
-- (;) at the end of this answer

SELECT
    mr.resort_id,
    resort_name,
    mr.member_no,
    decode(NULL, mr.member_gname, mr.member_fname, mr.member_fname, mr.member_gname,
           mr.member_gname
           || ' '
           || mr.member_fname)                           AS member_name,
    to_char(mr.member_date_joined, 'dd-Mon-yyyy') AS date_joined,
    decode(NULL, m.member_gname, m.member_no
                                 || ' '
                                 || m.member_fname, m.member_fname, m.member_no
                                                                    || ' '
                                                                    || m.member_gname
                                                                    ,
           m.member_no
           || ' '
           || m.member_gname
           || ' '
           || m.member_fname)                            AS recommended_by_details,
    lpad(to_char(total, '$9999'),
         13, ' ')                                      AS total_charges
FROM
         (
        SELECT
            m.member_id,
            m.member_fname,
            m.member_gname,
            total,
            average,
            m.member_id_recby,
            m.resort_id,
            m.member_date_joined,
            m.member_no
        FROM
                 tsa.member m
            JOIN (
                SELECT
                    resort_id,
                    SUM(mc_total) / COUNT(DISTINCT(mc.member_id)) AS average
                FROM
                         tsa.member_charge mc
                    JOIN tsa.member m
                    ON mc.member_id = m.member_id
                GROUP BY
                    resort_id
            ) x
            ON m.resort_id = x.resort_id
            JOIN (
                SELECT
                    member_id,
                    SUM(decode(mc_paid_date,null,0,mc_total)) AS total
                FROM
                    tsa.member_charge
                GROUP BY
                    member_id
            ) y
            ON m.member_id = y.member_id
        WHERE
            total < average
    ) mr
    JOIN tsa.member m
    ON m.member_id = mr.member_id_recby
    JOIN tsa.resort r
    ON mr.resort_id = r.resort_id
    JOIN tsa.town   t
    ON r.town_id = t.town_id
WHERE
    ( upper(town_name) != upper('Byron Bay')
      OR upper(town_state) != upper('NSW') )
ORDER BY
    resort_id,
    member_no;
    

/*2(f)*/
-- PLEASE PLACE REQUIRED SQL STATEMENT FOR THIS PART HERE
-- ENSURE that your query is formatted and has a semicolon
-- (;) at the end of this answer

SELECT
    resort_id,
    resort_name,
    poi_name,
    poi_town,
    poi_state,
    poi_opening_time,
    lpad(to_char(geodistance(x.town_lat, x.town_long, y.town_lat, y.town_long),
                 '990.9')
         || ' Kms',
         10,
         ' ') AS distance
FROM
         (
        SELECT
            resort_id,
            resort_name,
            town_lat,
            town_long
        FROM
                 tsa.resort r
            JOIN tsa.town t
            ON r.town_id = t.town_id
    ) x
    JOIN (
        SELECT
            poi_name,
            town_name                                    AS poi_town,
            town_state                                   AS poi_state,
            decode(poi_open_time,
                   NULL,
                   'Not Applicable',
                   rpad(to_char(poi_open_time, 'HH12:MI AM'),16,' ')) AS poi_opening_time,
            town_lat,
            town_long
        FROM
                 tsa.town t
            JOIN tsa.point_of_interest p
            ON p.town_id = t.town_id
    ) y
    ON geodistance(x.town_lat, x.town_long, y.town_lat, y.town_long) <= 100
ORDER BY
    resort_name,
    geodistance(x.town_lat, x.town_long, y.town_lat, y.town_long);
    
    
