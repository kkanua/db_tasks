-- CREATE TYPE departments AS ENUM ('Производство', 'Поддержка пользователей', 'Бухгалтерия', 'Администрация');
-- CREATE TYPE conds AS ENUM ('Новая', 'Переоткрыта', 'Выполняется', 'Закрыта');
drop table if exists users, projects, tasks, tasks2;

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
  foreign key (project_name) references projects(prj_name),
  foreign key (creator_name) references users(login),
  foreign key (exec_name) references users(login)
                                 );



insert into users values('Kasatkin Artem', 'a.kasatkin', 'a.kasatkin@gmail.com', 'Администрация');
insert into users values('Petrova Sofia', 's.petrova', 's.petrova@gmail.com', 'Бухгалтерия');
insert into users values('Drozdov Fedor', 'f.drozdov', 'f.drozdov@gmail.com', 'Администрация');
insert into users values('Ivanova Vasilina', 'v.ivanova', 'v.ivanova@gmail.com', 'Бухгалтерия');
insert into users values('Berkut Alexey', 'a.berkut', 'a.berkut@gmail.com', 'Поддержка пользователей');
insert into users values('Belova Vera', 'v.belova', 'v.belova@gmail.com', 'Поддержка пользователей');
insert into users values('Makenroy Alexey', 'a.makenroy', 'a.makenroy@gmail.com', 'Производство');
insert into users values('Markar Palexa', 'p.markar', 'p.markar@gmail.com', 'Производство');


insert into projects values('RTK', 'YA SDELAL', '2016/01/1', '2017/01/31');
insert into projects values('CC.Connect', NULL, '2015/02/23', '2016/12/31');
insert into projects values('Demo-Siberia', NULL, '2015/01/11', '2015/01/31');
insert into projects values('MVD-Online', NULL, '2015/05/22', '2016/01/31');
insert into projects values('Support', NULL, '2016/01/02', NULL);


insert into tasks(header, priority, description, condition, estimate, elaps_time, project_name, creator_name, exec_name) values
                 ('TEST0', 0, NULL,'Выполняется', 3, 1, 'MVD-Online', 'a.kasatkin', 's.petrova'),
                 ('TEST1', 112, 'Connect users', 'Закрыта', 6, 8, 'CC.Connect', 'a.kasatkin', 'v.ivanova'),
                 ('TEST2', 140, 'something not so important', 'Новая', 3, 0, 'Demo-Siberia', 'v.ivanova', 'a.berkut'),
                 ('TEST3', 3, NULL, 'Переоткрыта', 20, 0, 'Support', 'a.makenroy', NULL),
                 ('TEST4', 2, NULL, 'Новая', 20, 0, 'MVD-Online', 'a.kasatkin', NULL),
                 ('TEST5', 1, 'done', 'Закрыта', 10, 9, 'Support', 'v.ivanova', 'f.drozdov'),
                 ('TEST6', 15, 'done', 'Закрыта', 1, 1, 'Support', 'f.drozdov', 'a.kasatkin'),
                 ('TEST7', 23, NULL, 'Новая', 10, 0, 'Support', 'f.drozdov', 'a.makenroy'),
                 ('TEST8', 54, 'some description', 'Выполняется', 110, 5, 'RTK', 'a.berkut', 'a.berkut'),
                 ('TEST9', 143, NULL, 'Переоткрыта', 12, 0, 'Demo-Siberia', 'v.belova', NULL),
                 ('TEST10', 24, NULL, 'Новая', 1, 0, 'RTK', 'v.ivanova', 'a.kasatkin');
-- 1.3
-- a
select * from tasks;
-- b
select login, department from users;
-- c
select login, email from users;
-- d
select * from tasks where priority > 50;
-- e
select distinct exec_name from tasks where exec_name is not null;
-- f
(select creator_name from tasks where creator_name) union (select exec_name from tasks where exec_name is not null);
-- k
select header from tasks where creator_name!='s.petrova' and (exec_name='v.ivanova' or exec_name='a.berkut');
-- 1.4
select header from tasks where exec_name='a.kasatkin' and project_name in (select prj_name from projects where start_date between '2016/01/01' and'2016/01/03');
-- 1.5
select id, header from tasks where exec_name='s.petrova' and creator_name in (select login from users where department in ('Администрация', 'Бухгалтерия', 'Производство'));
-- 1.6
select id, header from tasks where exec_name is null;
update tasks set exec_name='s.petrova' where exec_name is null;
-- 1.7
create table tasks2 as table tasks;
select * from tasks2;
-- 1.8
select login from users where (uname not like '%a %a') and (login like 'p%r%');
