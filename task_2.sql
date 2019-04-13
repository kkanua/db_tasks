-- CREATE TYPE departments AS ENUM ('Производство', 'Поддержка пользователей', 'Бухгалтерия', 'Администрация');
-- CREATE TYPE conds AS ENUM ('Новая', 'Переоткрыта', 'Выполняется', 'Закрыта');
drop table if exists users, projects, tasks, tasks2, test_char cascade;

create table if not exists users (
  uname varchar(20) not null,
  login varchar(20) primary key,
  email varchar(30) not null,
  department departments not null
                                 );

create table if not exists projects (
  prj_name varchar(50) primary key,
  description text,
  start_date date not null,
  end_date date
                                    );

create table if not exists tasks(
  id serial primary key,
  header varchar(50),
  priority int not null,
  description text,
  condition conds not null,
  estimate int not null,
  elaps_time int not null,
  project_name varchar(50),
  creator_name varchar(20) not null,
  exec_name varchar(20),
  start_date date not null,
  foreign key (project_name) references projects(prj_name),
  foreign key (creator_name) references users(login),
  foreign key (exec_name) references users(login)
                                 );



insert into users(uname, login, email, department) values
                         ('Kasatkin Artem', 'a.kasatkin', 'a.kasatkin@gmail.com', 'Администрация'),
                         ('Petrova Sofia', 's.petrova', 's.petrova@gmail.com', 'Бухгалтерия'),
                         ('Drozdov Fedor', 'f.drozdov', 'f.drozdov@gmail.com', 'Администрация'),
                         ('Ivanova Vasilina', 'v.ivanova', 'v.ivanova@gmail.com', 'Бухгалтерия'),
                         ('Berkut Alexey', 'a.berkut', 'a.berkut@gmail.com', 'Поддержка пользователей'),
                         ('Belova Vera', 'v.belova', 'v.belova@gmail.com', 'Поддержка пользователей'),
                         ('Makenroy Alexey', 'a.makenroy', 'a.makenroy@gmail.com', 'Производство'),
                         ('Markar Palexa', 'p.markar', 'p.markar@gmail.com', 'Производство');


insert into projects(prj_name, description, start_date, end_date) values
                            ('RTK', 'YA SDELAL', '2016/01/1', '2017/01/31'),
                            ('CC.Connect', NULL, '2015/02/23', '2016/12/31'),
                            ('Demo-Siberia', NULL, '2015/01/11', '2015/01/31'),
                            ('MVD-Online', NULL, '2015/05/22', '2016/01/31'),
                            ('Support', NULL, '2016/01/02', NULL);


insert into tasks(header, priority, description, condition, estimate, elaps_time, project_name, creator_name, exec_name, start_date) values
                 ('TEST0', 0, NULL,'Выполняется', 3, 1, 'MVD-Online', 'a.kasatkin', 's.petrova', '2015/01/25'),
                 ('TEST1', 112, 'Connect users', 'Закрыта', 6, 8, 'CC.Connect', 'a.kasatkin', 'v.ivanova', '2016/02/23'),
                 ('TEST2', 140, 'something not so important', 'Новая', 3, 0, 'Demo-Siberia', 'v.ivanova', 'a.berkut', '2015/10/12'),
                 ('TEST3', 3, NULL, 'Переоткрыта', 20, 0, 'Support', 'a.makenroy', NULL, '2016/12/23'),
                 ('TEST4', 2, NULL, 'Новая', 20, 0, 'MVD-Online', 'a.kasatkin', NULL, '2015/01/01'),
                 ('TEST5', 1, 'done', 'Закрыта', 10, 9, 'Support', 'v.ivanova', 'f.drozdov', '2016/02/23'),
                 ('TEST6', 15, 'done', 'Закрыта', 10, 1, 'Support', 'f.drozdov', 'a.kasatkin', '2016/11/14'),
                 ('TEST7', 23, NULL, 'Новая', 10, 0, 'Support', 'f.drozdov', 'a.makenroy', '2015/12/25'),
                 ('TEST8', 54, 'some description', 'Выполняется', 110, 5, 'RTK', 'a.berkut', 'a.berkut', '2016/06/01'),
                 ('TEST9', 143, NULL, 'Переоткрыта', 12, 0, 'Demo-Siberia', 'v.belova', NULL, '2015/04/13'),
                 ('TEST10', 24, NULL, 'Новая', 1, 0, 'RTK', 'v.ivanova', 'a.kasatkin', '2016/02/23');


-- 2.1 +
select exec_name, avg(priority) as average_prior from tasks
where exec_name is not null
group by exec_name order by average_prior
desc limit 3;

-- 2.2 +
select count(creator_name), Extract(MONTH from start_date) as month, creator_name from tasks
where start_date between '2015/01/01' and '2015/12/31'
group by creator_name, month;

-- 2.3 3 times
select distinct exec_name, overdo, underdo from tasks --2 обращения
left join (select exec_name as executor1, (sum(elaps_time) - sum(estimate)) as overdo from tasks where exec_name notnull and elaps_time > estimate group by exec_name) as smth1 on executor1 = exec_name
left join (select exec_name as executor2, (sum(estimate) - sum(elaps_time)) as underdo from tasks where exec_name notnull and estimate > elaps_time group by exec_name) as smth2 on executor2 = exec_name where exec_name notnull;

-- 2 times
select a.exec_name, sum(a.estimate - a.elaps_time) as "-" , sum(b.elaps_time - b.estimate) as "+" from Tasks a, Tasks b
where a.exec_name notnull and a.exec_name = b.exec_name and a.estimate >= a.elaps_time and b.estimate >= b.elaps_time group by a.exec_name;



-- select exec_name, SUM(estimate - elaps_time) AS flow , excess FROM Tasks
-- LEFT JOIN (SELECT exec_name AS login2, SUM(elaps_time - estimate) AS excess FROM Tasks WHERE (estimate <= elaps_time) GROUP BY exec_name) AS sample2 ON login2 = exec_name
-- WHERE exec_name NOTNULL AND Tasks.estimate >= Tasks.elaps_time GROUP BY exec_name, excess;

-- select exec_name, (sum(elaps_time) - sum(estimate)) as overdo, (sum(estimate) - sum(elaps_time)) as underdo from tasks
-- where exec_name notnull group by exec_name;

-- 2.4 +
select distinct least(creator_name, exec_name), greatest(creator_name, exec_name) from tasks
where exec_name is not null;

-- 2.5 +
select login, length(login) as symbols from users order by length(login)
desc limit 1;
-- 2.6 +
drop table if exists test_char;

create table if not exists test_char(
  a char(100),
  b varchar(100)
);

insert into test_char (a, b) values('12345', '12345');

select sum(pg_column_size(a)), sum(pg_column_size(b)) from test_char;
-- 2.7 +
select distinct exec_name, max(priority) from tasks
where exec_name is not null
group by exec_name order by max(priority)
desc;
-- 2.8 +
select exec_name, sum(estimate) from tasks
where exec_name is not null and priority > (select avg(priority) from tasks)
group by exec_name;
-- 2.9 +
drop materialized view if exists statistic;

create materialized view statistic as ( --materialized
  select distinct exec_name, done, tasks_amount, on_time, late, closed, opened, processing, work_time, overdo, underdo from tasks
  left join (select exec_name as perf1, count(exec_name) as tasks_amount from tasks where exec_name notnull group by exec_name) as smth1 on perf1 = exec_name
  left join (select exec_name as perf2, count(condition) as done from tasks where exec_name notnull and condition = 'Закрыта' group by exec_name) as smth2 on perf2 = exec_name
  left join (select exec_name as perf3, count(condition) as on_time from tasks where exec_name notnull and estimate >= elaps_time and condition = 'Закрыта' group by exec_name) as smth3 on perf3 = exec_name
  left join (select exec_name as perf4, count(condition) as late from tasks where exec_name notnull and estimate < elaps_time and condition = 'Закрыта' group by exec_name) as smth4 on perf4 = exec_name
  left join (select exec_name as perf5, count(condition) as closed from tasks where exec_name notnull and condition = 'Закрыта' group by exec_name) as smth5 on perf5 = exec_name
  left join (select exec_name as perf6, count(condition) as opened from tasks where exec_name notnull and (condition = 'Новая' or condition = 'Переоткрыта' ) group by exec_name) as smth6 on perf6 = exec_name
  left join (select exec_name as perf7, count(condition) as processing from tasks where exec_name notnull and condition = 'Выполняется' group by exec_name) as smth7 on perf7 = exec_name
  left join (select exec_name as perf8, sum(elaps_time) as work_time, (sum(elaps_time) - sum(estimate)) as overdo from tasks where exec_name notnull and elaps_time > estimate group by exec_name) as smth8 on perf8 = exec_name
  left join (select exec_name as perf9, (sum(estimate) - sum(elaps_time)) as underdo from tasks where exec_name notnull and estimate > elaps_time group by exec_name)as smth9 on perf9 = exec_name
  where exec_name notnull
);

insert into tasks(header, priority, description, condition, estimate, elaps_time, project_name, creator_name, exec_name, start_date) values
                 ('TEST0', 0, NULL,'Закрыта', 2, 1, 'MVD-Online', 'a.kasatkin', 'v.ivanova', '2015/02/25');


select * from statistic;


-- 2.10

select login, COUNT(header) from users, tasks where login = exec_name group by login;

select login, work_left from users, (select exec_name, sum(estimate - elaps_time) as work_left from tasks group by exec_name) as sample where login = sample.exec_name;

select * from users where '02' in (select Extract(MONTH from start_date) from tasks where users.login = tasks.exec_name);