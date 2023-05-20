/***** 05. SQL: Question Set 1 *****/

/* Question 1: Which countries have the most Invoices? */
SELECT 
	BillingCountry,
    COUNT(InvoiceId) AS num_invoice
FROM 
	Invoice
GROUP BY BillingCountry
ORDER BY num_invoice DESC;

/* Question 2: Which city has the best customers? 
We would like to throw a promotional Music Festival in the city we made the most money. 
Write a query that returns the 1 city that has the highest sum of invoice totals. 
Return both the city name and the sum of all invoice totals. */
SELECT
	BillingCountry,
    SUM(Total) AS total_amount
FROM 
	Invoice
GROUP BY BillingCountry
ORDER BY total_amount DESC;

/* Question 3: Who is the best customer?
The customer who has spent the most money will be declared the best customer. 
Build a query that returns the person who has spent the most money. */
SELECT
	i.CustomerID,
    c.FirstName,
    c.LastName,
    SUM(i.Total) AS total_spending
FROM 
	Invoice AS i
		INNER JOIN
	Customer AS c ON i.CustomerID = c.CustomerID
GROUP BY i.CustomerID 
ORDER BY total_spending DESC
LIMIT 1;

/***** 06. SQL: Question Set 2 *****/

/*Question 1:
Use your query to return the email, first name, last name, and Genre of all Rock Music listeners.
Return your list ordered alphabetically by email address starting with A. */
SELECT DISTINCT
	c.Email,
    c.FirstName,
    c.LastName,
    g.Name
FROM 
	Customer AS c
		LEFT JOIN
	Invoice AS i ON c.CustomerID = i.CustomerID
		LEFT JOIN
	InvoiceLine AS il ON i.InvoiceId = il.InvoiceId
		LEFT JOIN
	Track AS t ON il.TrackId = t.TrackId
		LEFT JOIN
	Genre as g ON t.GenreId = g.GenreId
WHERE g.Name LIKE 'Rock'
ORDER BY c.Email;

/* Question 2: Who is writing the rock music?
Now that we know that our customers love rock music, we can decide which musicians to invite to play at the concert.
Let's invite the artists who have written the most rock music in our dataset. 
Write a query that returns the Artist name and total track count of the top 10 rock bands. */
SELECT
	ar.ArtistId,
    ar.Name AS Artist_Name,
    g.Name AS Genre_Name,
    COUNT(t.TrackId) AS total_tracks
FROM 
	Artist AS ar
		LEFT JOIN
	Album AS al ON ar.artistId = al.ArtistId
		LEFT JOIN
	Track as t ON al.AlbumId = t.AlbumId
		LEFT JOIN
	Genre as g ON t.GenreId = g.GenreId
WHERE g.Name = 'Rock'
GROUP BY ArtistId
ORDER BY total_tracks DESC
LIMIT 10;

/* Question 3
First, find which artist has earned the most according to the InvoiceLines?
Now use this artist to find which customer spent the most on this artist.

---- Hint ----
For this query, you will need to use the Invoice, InvoiceLine, Track, Customer, Album, and Artist tables.
Notice, this one is tricky because the Total spent in the Invoice table might not be on a single product, 
so you need to use the InvoiceLine table to find out how many of each product was purchased, 
and then multiply this by the price for each artist. 
---- 
*/
WITH top_earn_artist AS (
SELECT 
	ar.ArtistId,
    ar.Name AS artist_name,
    SUM(il.UnitPrice * il.Quantity) AS total_amount
FROM 
	Artist AS ar
		LEFT JOIN
	Album AS al ON ar.ArtistId = al.ArtistId
		LEFT JOIN
	Track AS t ON al.AlbumID = t.AlbumId
		LEFT JOIN
	InvoiceLine AS il ON t.TrackId = il.TrackId
GROUP BY ar.ArtistId
ORDER BY total_amount DESC
)

SELECT 
	tea.ArtistId,
    tea.artist_name,
    tea.total_amount,
    c.CustomerId,
    c.FirstName AS customer_first_name,
    c.LastName AS customer_last_name,
    SUM(il.UnitPrice * il.Quantity) AS total_amount_by_customer
FROM 
	Customer AS c
		LEFT JOIN
	Invoice AS i ON c.CustomerId = i.CustomerId
		LEFT JOIN
	InvoiceLine AS il ON i.InvoiceId = il.InvoiceId
		LEFT JOIN
	Track AS t ON il.TrackId = t.TrackId
		LEFT JOIN
	Album AS a ON t.AlbumId = a.AlbumId
		LEFT JOIN
	top_earn_artist AS tea ON a.ArtistId = tea.ArtistId
    GROUP BY 
		tea.ArtistId,
        c.CustomerId
	ORDER BY
		tea.total_amount DESC,
        total_amount_by_customer DESC;
		

/**** 07. (Advanced) SQL: Question Set 3 *****/

/* Question 1:
We want to find out the most popular music Genre for each country. 
We determine the most popular genre as the genre with the highest amount of purchases. 
Write a query that returns each country along with the top Genre. 
For countries where the maximum number of purchases is shared return all Genres. */
WITH genre_popularity_by_country AS(
SELECT
	i.BillingCountry,
    g.GenreId,
    g.Name AS genre_name,
    SUM(il.UnitPrice * il.Quantity) AS total_purchases,
    RANK() OVER (PARTITION BY i.BillingCountry ORDER BY SUM(il.UnitPrice * il.Quantity) DESC) AS popularity_ranking
FROM 
	Invoice AS i
		LEFT JOIN
	InvoiceLine AS il ON i.InvoiceId = il.InvoiceId
		LEFT JOIN
	Track AS t ON il.TrackId = t.TrackId
		LEFT JOIN
	Genre AS g ON t.GenreId = g.GenreId
GROUP BY 
	i.BillingCountry,
    g.GenreId
ORDER BY
	i.BillingCountry,
    total_purchases DESC
)

SELECT
	BillingCountry,
    genre_name
FROM 
	genre_popularity_by_country
WHERE popularity_ranking = 1;

/* Question 2:
Return all the track names that have a song length longer than the average song length. 
Though you could perform this with two queries. 
Imagine you wanted your query to update based on when new data is put in the database. 
Therefore, you do not want to hard code the average into your query. You only need the Track table to complete this query.
Return the Name and Milliseconds for each track. Order by the song length with the longest songs listed first. */
SELECT
	Name,
    Milliseconds
FROM 
	Track
WHERE Milliseconds > (SELECT
						AVG(Milliseconds)
					FROM
						Track)
ORDER BY Milliseconds DESC;

/* Version 2, if you want to check the avg_miliseconds */
SELECT
	Name,
    Milliseconds,
    (SELECT
		AVG(Milliseconds)
	FROM
		Track) AS avg_milliseconds
FROM 
	Track
WHERE Milliseconds > (SELECT
						AVG(Milliseconds)
					FROM
						Track)
ORDER BY Milliseconds DESC;

/* Question 3:
Write a query that determines the customer that has spent the most on music for each country. 
Write a query that returns the country along with the top customer and how much they spent. 
For countries where the top amount spent is shared, provide all customers who spent this amount.
You should only need to use the Customer and Invoice tables. */
WITH ranking_customer_spend_by_country AS (
SELECT
	i.BillingCountry,
    c.CustomerId,
    c.FirstName AS customer_first_name,
    c.LastName AS customer_last_name,
    SUM(i.Total) AS total_spend_by_customer,
    RANK() OVER(PARTITION BY i.BillingCountry ORDER BY SUM(i.Total) DESC) AS ranking_spend_by_customer
FROM 
	Customer AS c
		LEFT JOIN
	Invoice as i ON c.CustomerId = i.CustomerId
GROUP BY
	i.BillingCountry,
    c.CustomerId
ORDER BY
	i.BillingCountry,
    total_spend_by_customer DESC
)

SELECT
	BillingCountry,
    customer_first_name,
    customer_last_name,
    total_spend_by_customer
FROM 
	ranking_customer_spend_by_country
WHERE ranking_spend_by_customer = 1;
