-- 1. Find users who have never made a payment.
select * from users where user_id not in (select user_id from payments where status = 'SUCCESS' or status='PENDING');

-- 2. Retrieve all content (movies and TV shows) that has never been watched.
select * from content where content_id not in (select content_id from watch_history);

-- 3. Find users who have made at least one payment greater than ₹200.
Select * from users where user_id in (select user_id from payments where amount > 200 and status = 'SUCCESS');

-- 4. Get users who have an active subscription but have never watched anything.
select * from user_subscriptions u where status = 'ACTIVE' and not exists (select 1 from watch_history w where w.user_id = u.user_id);

-- 5. Find the most expensive subscription plan.
select * from subscription_plans where price = (select max(price) from subscription_plans);

-- 6. List all users who are subscribed to the most popular plan.
select * from users where user_id in (select user_id from user_subscriptions where plan_id = (select plan_id from user_subscriptions group by plan_id order by count(plan_id) desc limit 1));

-- 7. Retrieve movies that have been watched at least 5 times.
select * from content where content_id in (select content_id from watch_history group by content_id HAVING count(content_id) >= 5);

-- 8. Find users whose total payments exceed the average total payments of all users.
select * from users where user_id in (select user_id from payments group by user_id having sum(amount) > (
select avg(sumofall) from (select sum(amount) as sumofall from payments group by user_id) as math1));

-- 9. List all actors who appeared in the most-watched movie.
select name, role from casts where cast_id in (select cast_id from content_cast where content_id = ( select content_id from watch_history where content_id in (select content_id from content_cast)  group by content_id order by count(content_id) desc limit 1));

-- 10. Retrieve users who have only watched content from recommendations.
select user_id from watch_history wh1 group by user_id having count(content_id) = (select count(content_id) from watch_history wh2 where wh2. user_id = wh1.user_id and wh2.content_id in (select content_id from recommendations rs where rs.user_id = wh2.user_id));

-- 11. Find users who have subscribed to a plan but never watched anything.
select user_id from user_subscriptions where status = 'ACTIVE' and  user_id not in (select user_id from watch_history);

-- 12. Get the names of users who have an expired subscription.
select * from users where user_id in (select user_id from user_subscriptions where status = 'EXPIRED');

-- 13. Find content that belongs to genres with less than 5 total movies or shows.
select * from genres where genre_id in (select genre_id from content_genres group by genre_id having count(content_id) < 5);

-- 14. Retrieve users who have watched the most-watched movie.
select * from users where user_id in (select user_id from watch_history where content_id = (select content_id from watch_history group by content_id having count(content_id) order by count(content_id) desc limit 1));

-- 15. Find users with an active subscription to the most expensive plan.
select * from users where user_id in (select user_id from user_subscriptions where plan_id = (select plan_id from subscription_plans order by price desc limit 1) and status = 'ACTIVE');

-- 16. Find users who have watched content that was recommended to them.
select * from users where user_id in (select distinct user_id from watch_history wh where user_id in (select user_id from recommendations rs where rs.user_id = wh.user_id and rs.content_id = wh.content_id and rs.recommended_on < wh.watched_on));

-- 17. Find all movies in the most popular genre.
select * from content where content_id in ( select content_id from content_genres where genre_id = (select genre_id from content_genres group by genre_id having count(content_id) order by count(content_id) desc limit 1));

-- 18. Find the most recent payment made by each user.
select user_id, payment_date from payments p where payment_date = (select max(payment_date) from payments s where s.user_id = p.user_id);

-- 19. Find the most recent payment made by each user along with their name.
select first_name, last_name, (select max(payment_date)  from payments p where p.user_id = u.user_id ) as 'Latest_Payment' from users u;

-- 20. Retrieve the latest released TV Show.
select content_id, title, release_year, content_type from content where release_year = ( Select max(release_year) from content where content_type = 'TV Show') and content_type = 'TV Show';