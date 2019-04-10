drop table if exists a, b, a_onetoone, b_onetoone, a_onetomany, b_onetomany, a_manytomany, b_manytomany, a_b_manytomany cascade;

-- 3.1 trigger should be created in this task
create table if not exists a(
  id serial primary key,
  data varchar(200)
);

CREATE TABLE if not exists b(
  id serial primary key,
  data varchar(200),
  aid int,
  foreign key (aid) references a(id) on update cascade -- on delete cascade
);

insert into a (data) values
              ('one'),
              ('two'),
              ('three'),
              ('four'),
              ('five'),
              ('six'),
              ('seven'),
              ('eight'),
              ('nine');

insert into b (data, aid) values
              ('ten', 1),
              ('eleven', 2),
              ('twelve', 3),
              ('thirteen', 4),
              ('fourteen', 5),
              ('fiveteen', 6),
              ('sixteen', 7),
              ('seventeen', 8),
              ('eighteen', 9);

insert into b (data, aid) values ('smth', 2);

drop function delfromb() cascade;


create or replace function delfromb() returns trigger as
$$
begin
  if TG_OP = 'DELETE' then
   delete from b where aid = old.id;
   return old;

   elseif TG_OP = 'INSERT' then
    insert into b(data, aid) values (null, new.id);
    return new;
   end if;
end;
$$
language plpgsql;


create trigger my_tg
  before delete
  on a
  for each row
  execute procedure delfromb();

create trigger my_tg_up
  after insert
  on a
  for each row
  execute procedure delfromb();




delete from a where data = 'three';
update a set id = 132 where id = 5;
insert into a (data) values ('AAAA');

select * from a;
select * from b;


-- 3.2

-- one to one
create table a_onetoone(
  id serial primary key
);

create table b_onetoone(
  id int primary key,
  foreign key (id) references a(id)
);

-- one to many
create table a_onetomany(
  id serial primary key
);

create table b_onetomany(
  id serial primary key,
  a_id int,
  foreign key (a_id) references a(id)
);


-- many to many
create table a_manytomany(
  id serial primary key
);
-- --
create table b_manytomany(
  id serial primary key
);
-- --
create table a_b_manytomany(
  a_id int,
  b_id int,
  foreign key (a_id) references a(id),
  foreign key (b_id) references b(id),
  primary key (a_id, b_id)
);

-- 3.3

create table if not exists cow_farm(
  tag_id int primary key,
  name varchar(30) not null,
  owner varchar(30) not null,
  herdsman varchar(30) not null,
  milk_amount double precision,
  owner_address varchar(50) unique not null,
  phone int not null
);

insert into cow_farm (tag_id, name, owner, herdsman, milk_amount, owner_address, phone) values
(12345, 'Buryona', 'Andrey', 'Ahmed', 5.5, 'st. Lenin 1', 1234),
(98765, 'Muryona', 'Vasya', 'Nursultan', 6.5, 'st. Pupkin 2', 4521),
(12598, 'Duryona', 'Vasya', 'Nursultan', 7, 'st. Pushkin 2', 4521),
(75432, 'Kuryona', 'Kolya', 'Magomed', 5, 'st. Lermontov 4', 6893),
(98248, 'Zuryona', 'Olya', 'Petya', 9, 'st. Lenin 5', 9060),
(32910, 'Nuryona', 'Olya', 'Petya', 4.5, 'st. Lenin 6', 9060);

delete from cow_farm where tag_id = 12345; -- herdsman can be lost after this query
update cow_farm set owner_address = 'st. Unknown 1' where tag_id = 12598; -- same Vasya will have other address where tag_id = 98765
select * from cow_farm where tag_id = 12598; -- ???
insert into cow_farm (tag_id, name, owner, herdsman, milk_amount, owner_address) values (32910, 'Nuryona', 'Olya', 'Petya', 4.5, 'st. Lenin 6'); -- ???