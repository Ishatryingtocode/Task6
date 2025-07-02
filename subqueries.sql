USE library_db;

-- 1.Subquery in SELECT: Get the title of each book along with one of its authors (using scalar subquery in SELECT)
SELECT 
    b.title,
    (SELECT a.name 
     FROM book_author ba 
     JOIN author a ON ba.author_id = a.author_id 
     WHERE ba.book_id = b.book_id 
     LIMIT 1) AS author_name
FROM book b;

-- 2. Subquery in WHERE: List all books that belong to the same category as the book titled '1984'
SELECT title
FROM book 
WHERE category_id = (
	SELECT category_id 
    FROM book 
    WHERE title = '1984'
);

-- 3. Show total number of books in each category (using subquery in FROM)
SELECT c.category_name, bc.total_books
FROM (
	SELECT category_id, COUNT(*) AS total_books
    FROM book
    GROUP BY category_id
) AS bc
JOIN category c ON bc.category_id = c.category_id;

-- 4. List members who currently have borrowed books (using correlated subquery in EXISTS)
SELECT m.first_name, m.last_name
FROM member m
WHERE EXISTS (
	SELECT 1 
    FROM loan l 
	WHERE l.member_id = m.member_id 
    AND l.return_date is NULL
);

-- 5. List all books that were written by authors who have no bio (using subquery with IN)
SELECT b.title 
FROM book b 
WHERE b.book_id IN (
	SELECT ba.book_id 
    FROM book_author ba
    JOIN author a ON ba.author_id = a.author_id
    WHERE a.bio is NULL
);

-- 6. List all categories that have no books
SELECT c.category_name FROM category c
WHERE NOT EXISTS (
	SELECT 1 
    FROM book b
    WHERE b.category_id = c.category_id
);

--  7. Show the most recently published book
SELECT title, publication_year FROM book b
WHERE publication_year = (
	SELECT MAX(publication_year)
    FROM book
);

-- 8. Show authors and how many books they’ve written
SELECT a.name,
	( SELECT COUNT(*)
    FROM book_author ba
    WHERE ba.author_id = a.author_id) AS book_count
FROM author	a;


    