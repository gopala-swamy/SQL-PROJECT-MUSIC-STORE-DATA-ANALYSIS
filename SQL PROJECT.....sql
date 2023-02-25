create database dataset;
use dataset;

drop table employee;


create table employee(
employee_id int  NOT NULL auto_increment primary key,
last_name varchar(50),
first_name varchar(50),
title varchar(100),
reports_to INT ,
levels varchar(20),
birthdate varchar(50),
hire_date varchar(50),
address varchar(100),
city varchar(50),
state varchar(20),
country varchar(50),
postal_code varchar (50),
phone varchar(50) ,
fax varchar(50),
email varchar(100));

update employee
set reports_to = Null 
where employee_id = 9;

alter table employee
add constraint fk_reports_to
foreign key (reports_to)
references employee(employee_id);


select* from employee;
desc employee;



select count(*) from employee;

create table customer(
customer_id int auto_increment primary key,
first_name varchar(50),
last_name varchar(50),
company varchar(100),
address varchar(100),
city varchar(50),
state varchar(30),
country varchar(30),
postal_code varchar(50),
phone varchar(50),
fax varchar(50),
email varchar(100),
support_rep_id int,
foreign key (support_rep_id)
references employee(employee_id));

desc employee;


select * from employee;


select count(*) from customer;

create table invoice(
invoice_id int  NOT NULL auto_increment primary key,
customer_id int,
invoice_date varchar(200),
billing_address varchar(200),
billing_city varchar(200),
billing_state varchar(200),
billing_country varchar(200),
billing_postal_code varchar(200),
total int,
foreign key(customer_id)
references customer(customer_id));

select count(*) from invoice;

create table invoice_line(
invoice_line_id int  NOT NULL auto_increment primary key,
invoice_id int,
track_id int,
unit_price float,
quantity int,
foreign key(invoice_id)
references invoice(invoice_id),
foreign key(track_id)
references track(track_id));

select count(*) from invoice_line;

create table track(
track_id int  NOT NULL auto_increment primary key,
name varchar(200),
album_id int,
media_type_id int,
genre_id int,
composer varchar(1000) default null,
milliseconds varchar(100),
bytes varchar(100),
unit_price varchar(100),
foreign key (album_id)
references album(album_id),
foreign key (media_type_id)
references media_type(media_type_id),
foreign key (genre_id)
references genre(genre_id));


select count(*) from track;

 

create table playlist(
playlist_id int primary key,
name varchar(50));

select count(*) from playlist;

create table playlist_track(
playlist_id int ,
track_id int,
foreign key (playlist_id)
references playlist(playlist_id),
foreign key (track_id)
references track(track_id));

select count(*) from playlist_track;


create table media_type(
media_type_id int  NOT NULL auto_increment primary key,
Name varchar(100));

select count(*) from media_type;

create table genre(
genre_id int  NOT NULL auto_increment primary key,
Name varchar(100));

select count(*) from genre;
 
 create table album(
album_id int primary key,
title varchar(100),
artist_id int,
foreign key(artist_id)
references artist(artist_id));

select count(*) from album;


create table artist(
artist_id int primary key,
name varchar(200));
select count(*) from artist;

#                              Question Set 1 - Easy
# Who is the senior most employee based on job title?
SELECT * FROM employee;

SELECT MAX(title) AS max_title, CONCAT(first_name, ' ', last_name) AS employee_name
FROM employee
WHERE title = (SELECT MAX(title) FROM employee)
GROUP BY employee_name;


# Which countries have the most Invoices?
SELECT * FROM customer;

SELECT sum(total),billing_country 
FROM invoice
group by billing_country;


# What are top 3 values of total invoice?
SELECT total,billing_country 
FROM invoice 
ORDER BY total DESC 
LIMIT 3;

/*Which city has the best customers?
We would like to throw a promotional Music Festival in the city we made the most money. 
Write a query that returns one city that has the highest sum of invoice totals. 
Return both the city name & sum of all invoice totals*/
SELECT city, sum(total) as sum_total
FROM customer
JOIN invoice ON customer.customer_id = invoice.customer_id
GROUP BY city
ORDER BY sum_total DESC
LIMIT 1;


/* Who is the best customer? The customer who has spent the most money will be declared the best customer. 
Write a query that returns the person who has spent the most money*/

select * from customer;
SELECT invoice.customer_id,concat(customer.first_name," ",customer.last_name)as customer_name, 
count(invoice.total) AS total_invoice,sum(il.unit_price*il.quantity) as total_amount
FROM invoice
JOIN customer ON customer.customer_id = invoice.customer_id
join invoice_line as il on invoice.invoice_id= il.invoice_id
GROUP BY invoice.customer_id
ORDER BY total_amount DESC,total_invoice desc
LIMIT 1;


  
  #                            Question Set 2 – Moderate
/*Write query to return the email, first name, last name, & Genre of all Rock Music listeners.
 Return your list ordered alphabetically by email starting with A.*/
 SELECT * FROM genre;
 SELECT DISTINCT email,concat(customer.first_name," ",customer.last_name) as customer_name,genre.name
 FROM customer
 JOIN invoice ON customer.customer_id = invoice.customer_id
 JOIN invoice_line ON invoice_line.invoice_id=invoice.invoice_id
 JOIN track ON invoice_line.track_id= track.track_id
 JOIN genre ON track.genre_id= genre.genre_id
 WHERE genre.name="rock" and customer.email like "a%"
 ORDER BY email ASC;
 
 
 
 select * from artist;
/*Let's invite the artists who have written the most rock music in our dataset. 
Write a query that returns the Artist name and total track count of the top 10 rock bands*/
SELECT artist.name AS artist_name, COUNT(*) AS track_count,genre.name
FROM artist
JOIN album ON artist.artist_id = album.artist_id
JOIN track ON album.album_id = track.album_id
JOIN genre ON track.genre_id = genre.genre_id
WHERE genre.name = 'Rock'
GROUP BY artist.artist_id
ORDER BY track_count DESC
LIMIT 10;



/*Return all the track names that have a song length longer than the average song length.
 Return the Name and Milliseconds for each track. 
 Order by the song length with the longest songs listed first*/
 
SELECT name,milliseconds
FROM track
WHERE track.milliseconds > (
    SELECT AVG(milliseconds)
    FROM track
)
ORDER BY track.milliseconds DESC;







#                                    Question Set 3 – Advance
/*Find how much amount spent by each customer on artists? 
Write a query to return customer name, artist name and total spent*/



SELECT DISTINCT CONCAT(customer.first_name ," ",customer.last_name) AS customer_name,artist.name AS artist_name,SUM(invoice_line.unit_price*invoice_line.quantity) AS total_spent
FROM customer
JOIN invoice ON customer.customer_id=invoice.customer_id
JOIN invoice_line ON invoice.invoice_id=invoice_line.invoice_id
JOIN track ON invoice_line.track_id =track.track_id
JOIN album ON track.album_id=album.album_id
JOIN artist ON album.artist_id=artist.artist_id
GROUP BY customer.customer_id, artist.artist_id
ORDER BY customer_name,artist_name,total_spent DESC;

select * from customer;
/*We want to find out the most popular music Genre for each country.
 We determine the most popular genre as the genre with the highest amount of purchases.
 Write a query that returns each country along with the top Genre. 
 For countries where the maximum number of purchases is shared return all Genres*/
WITH top_genre_cte AS (
    SELECT cu.country, g.name AS top_genre, SUM(il.quantity) AS total_quantity
    FROM customer cu
    JOIN invoice AS i ON cu.customer_id = i.customer_id
    JOIN invoice_line AS il ON i.invoice_id = il.invoice_id
    JOIN track AS t ON il.track_id = t.track_id
    JOIN genre AS g ON t.genre_id = g.genre_id
    GROUP BY cu.country, g.name
    ORDER BY cu.country, total_quantity DESC)
SELECT country, COALESCE(MAX(top_genre), 'Unknown') AS top_genre
FROM top_genre_cte
GROUP BY country;

   

 
 select * from track;
/*Write a query that determines the customer that has spent the most on music for each country. 
Write a query that returns the country along with the top customer and how much they spent. 
For countries where the top amount spent is shared, provide all customers who spent this amount*/



WITH customer_spending AS (
    SELECT c.country,CONCAT(c.first_name, ' ', c.last_name) AS top_customer,
        SUM(il.unit_price * il.quantity) AS total_spent
    FROM customer AS c
        JOIN invoice AS i ON c.customer_id = i.customer_id
        JOIN invoice_line AS il ON i.invoice_id = il.invoice_id
    GROUP BY c.customer_id)
SELECT country,top_customer,total_spent
FROM customer_spending
WHERE (country, total_spent) IN (
        SELECT country, MAX(total_spent) AS total_spent
        FROM customer_spending
        GROUP BY country)
ORDER BY country;


