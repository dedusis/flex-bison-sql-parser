CREATE TABLE users (
    id int,
    name varchar(20)
);

SELECT id, name
GROUP BY name
FROM users
WHERE id >= 5
ORDER BY name
LIMIT 10;

Input is syntactically correct.