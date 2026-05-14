CREATE TABLE users (
    id int,
    name varchar(20)
);


SELECT id, name
FROM users
WHERE id >= 5
GROUP BY name
ORDER BY name
LIMIT 10;