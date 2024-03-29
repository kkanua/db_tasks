-- 4-1)
CREATE table creators(
  name  varchar(30) not null ,
  login varchar(50) primary key,
  tasks int not null
);

CREATE table executors
(
  name  varchar(30) not null ,
  login varchar(50) primary key,
  tasks int not null
);

insert into creators(name, login, tasks) values
                      ('name1', 'name1@gmail.com', 1),
                      ('name2', 'name2@gmail.com', 2),
                      ('name3', 'name3@gmail.com', 3),
                      ('name4', 'name4@gmail.com', 4),
                      ('name5', 'name5@gmail.com', 5),
                      ('name6', 'name6@gmail.com', 6),
                      ('name7', 'name7@gmail.com', 7);

insert into executors(name, login, tasks) values
                      ('name10', 'name10@gmail.com', 1),
                      ('name11', 'name11@gmail.com', 2),
                      ('name1', 'name1@gmail.com', 3),
                      ('name12', 'name12@gmail.com', 4),
                      ('name5', 'name5@gmail.com', 5),
                      ('name6', 'name6@gmail.com', 6),
                      ('name20', 'name20@gmail.com', 7);

-- 4-1 +
select cr.name from creators cr full outer join executors exe on cr.name = exe.name where cr.name is null or exe.name is null;
select cr.name from creators cr full outer join executors exe on cr.name = exe.name;
select cr.name from creators cr inner join executors exe on cr.name = exe.name;
select cr.name from creators cr left outer join executors exe on cr.name = exe.name;
select cr.name from creators cr left outer join executors exe on cr.name = exe.name where exe.name is null;
select exe.name from creators cr right join executors exe on cr.name = exe.name;
select exe.name from creators cr right outer join executors exe on cr.name = exe.name where cr.name is null;

-- 4-2 -
select id, header /*out.creator_name*/ from tasks as out where priority = (select max(priority) from tasks as int where int.creator_name = out.creator_name);

-- select id, /*max_pr.priority as max, creator_name*/ header from tasks
-- inner join (select max(priority) priority, creator_name from tasks t group by creator_name) as max_pr using(creator_name, priority);-- on creator_name = creat;

-- 4-3 +
select login from users where login not in (select exec_name from tasks where exec_name notnull);

select distinct login from users left outer join tasks t on users.login = t.exec_name where t.exec_name is null;

select distinct u.login from users u where (select distinct exec_name from tasks t where t.exec_name = u.login and exec_name notnull) is null;



-- 4-4 +
select exec_name, creator_name from tasks where exec_name notnull
union
select exec_name, creator_name from tasks where exec_name notnull;

-- 4-5 +
select p.prj_name, t.header from tasks t, projects p;

select prj_name, t.header from projects full outer join tasks t on null is null;

select p.prj_name, t.header from tasks as t cross join projects as p
