# SQL_Chinook_Music_Store_Project

## Overview
MySQL project that answer real business question and scenarios of Chinook, a digital media store.

## Schema

![Chinook_Schema](https://github.com/maxcruzq/SQL_Chinook_Music_Store_Project/assets/132103792/a0ad73ee-eb6d-4a1d-93d3-644980b92d4a)

## Real Business Questions
1. Which countries have the most Invoices?
2. Which city has the best customers?
  We would like to throw a promotional Music Festival in the city we made the most money. 
  Write a query that returns the 1 city that has the highest sum of invoice totals. 
  Return both the city name and the sum of all invoice totals.
3. Who is the best customer?
  The customer who has spent the most money will be declared the best customer. 
  Build a query that returns the person who has spent the most money.
4. Use your query to return the email, first name, last name, and Genre of all Rock Music listeners.
  Return your list ordered alphabetically by email address starting with A.
5. Who is writing the rock music?
  Now that we know that our customers love rock music, we can decide which musicians to invite to play at the concert.
  Let's invite the artists who have written the most rock music in our dataset. 
  Write a query that returns the Artist name and total track count of the top 10 rock bands.
6. First, find which artist has earned the most according to the InvoiceLines?
  Now use this artist to find which customer spent the most on this artist.
7. We want to find out the most popular music Genre for each country. 
  We determine the most popular genre as the genre with the highest amount of purchases. 
  Write a query that returns each country along with the top Genre. 
  For countries where the maximum number of purchases is shared return all Genres.
8. Return all the track names that have a song length longer than the average song length. 
  Though you could perform this with two queries. 
  Imagine you wanted your query to update based on when new data is put in the database. 
  Therefore, you do not want to hard code the average into your query. You only need the Track table to complete this query.
  Return the Name and Milliseconds for each track. Order by the song length with the longest songs listed first.
9. Write a query that determines the customer that has spent the most on music for each country. 
  Write a query that returns the country along with the top customer and how much they spent. 
  For countries where the top amount spent is shared, provide all customers who spent this amount.
  You should only need to use the Customer and Invoice tables.
  
