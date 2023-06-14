-- Keep a log of any SQL queries you execute as you solve the mystery.

-- GOAL is to find Stole DUCK
-- Theif NAME?
-- City Theif Escaped?
-- Who Helped Theif to Escape?

-- Database fiftyville
-- From secret source most of the crime are tacking place on Humphrey Street
-- So lets first check crime scene report to identify date and location
-- used .tables and .schema to get information about table and coloums

    .tables
    airports                        crime_scene_reports
    people                          atm_transactions
    flights                         phone_calls
    bakery_security_logs            interviews
    bank_accounts                   passengers

-- .schema crime_scene_reports
    CREATE TABLE crime_scene_reports (
        id INTEGER,
        year INTEGER,
        month INTEGER,
        day INTEGER,
        street TEXT,
        description TEXT,
        PRIMARY KEY(id)
);
-- Run this get all information from table and find the decription that match out case
    SELECT * FROM crime_scene_reports;

-- SQL query to filter by street name
    SELECT *  FROM crime_scene_reports WHERE street = "Humphrey Street";

-- Decription from Crime Scene Report
    --Theft of the CS50 duck took place at 10:15am at the Humphrey Street bakery.
    --Interviews were conducted today with three witnesses who were present at the,
    --time – each of their interview transcripts mentions the bakery.
    -- Day = 28 / Month = 7 / Year = 2021

-- lets check activity happened on 28 / 7 / 2021 at 10:15AM at bakery from Bakery Logs
.schema backery_security_logs
    CREATE TABLE bakery_security_logs (
        id INTEGER,
        year INTEGER,
        month INTEGER,
        day INTEGER,
        hour INTEGER,
        minute INTEGER,
        activity TEXT,
        license_plate TEXT,
        PRIMARY KEY(id)
);

-- from bakery security logs we find car license plate number
-- let look what interview are presented
.schema interviews
    CREATE TABLE interviews (
        id INTEGER,
        name TEXT,
        year INTEGER,
        month INTEGER,
        day INTEGER,
        transcript TEXT,
        PRIMARY KEY(id)
);
-- lets look out for transcript on crime day
    SELECT * FROM interviews WHERE day = "28" AND month = "7" AND year = "2021";
-- On that day 7 interviews are recorded and 3 are mentioning about crime happened at bakery
-- Name: Ruth, Eugene, Raymond
-- Hints : Ruth indicating checked bakery security logs ten minutes from theft happened 10:15AM
-- Hints : Eugene saying checked ATM transcation on Leggett Street
-- Hints : Raymond observation theifs going to take earliest flight and ask to purchase ticket
-- lets look ATM table
.schema atm_transactions
    CREATE TABLE atm_transactions (
        id INTEGER,
        account_number INTEGER,
        year INTEGER,
        month INTEGER,
        day INTEGER,
        atm_location TEXT,
        transaction_type TEXT,
        amount INTEGER,
        PRIMARY KEY(id)
);
SELECT *  FROM atm_transactions WHERE atm_location = "Leggett Street"
AND  year = "2021" AND month = "7" AND day = "28";

--used people table and bank to match account and transaction happened at Leggett street
SELECT DISTINCT name FROM people JOIN bank_accounts ON people.id = bank_accounts.person_id
JOIN atm_transactions ON bank_accounts.account_number
WHERE day = "28" AND month = "7" AND year = "2021" AND
transaction_type = "withdraw" AND atm_location = "Leggett Street";
-- name:LUCA, KENNY, TAYLOR, BRUCE, BROOKE, IMAN, BENISTA, DIANA

-- lets check bakery security logs from 10:15 - 10:25 license plate and name of people
SELECT name FROM people JOIN bakery_security_logs ON
people.license_plate = bakery_security_logs.license_plate
WHERE day = "28" AND month = "7" AND year = "2021"
AND hour = "10" AND minute >= "15" AND minute < "25";
-- Name:VANESSA, BRUCE, BARRY, LUCA, SOFIA, IMAN, DIANA, KELSEY

-- From last interview lets see who bought first flight ticket
SELECT name FROM people JOIN passengers ON
people.passport_number = passengers.passport_number
WHERE flight_id = (SELECT id FROM flights WHERE
day = "29" AND month = "7" AND year = "2021" ORDER BY hour;
-- Name: DORIS, SOFIA, BRUCE, EDWARD, KELSEY, TAYLOR, KENNY, LUCA

--Therefore checking all name from three intereview we came to know Bruce is theif
-- From flight ticket we can find destination where theif (Bruce) escaped
SELECT city FROM airports WHERE id = (SELECT destination_airport_id FROM flights WHERE day = "29" AND month = "7" AND year = "2021" ORDER BY hour);
-- Theif went to New York City by LGA airport
-- Last thing to find person with theif
SELECT caller,receiver FROM phone_calls WHERE day = 28 AND month = 7 AND year = 2021 and duration < 60 AND caller = (SELECT phone_number FROM people WHERE name = "Bruce");
-- we get theif and his partner cell number from there we can find name by phone_number
SELECT name FROM people WHERE phone_number = '(375) 555-8161';
--Hence Robin is accompaning Bruce

