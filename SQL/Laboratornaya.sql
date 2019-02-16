--Создание таблицы 1
CREATE TABLE
Department (
    id integer PRIMARY KEY, -- имя поля, тип данных, ограничение
    name VARCHAR (355) NOT NULL
);
--заполнение таблица 1
INSERT INTO Department VALUES
('1', 'Therapy'),
('2', 'Neurology'),
('3', 'Cardiology'),
('4', 'Gastroenterology'),
('5', 'Hematology'),
('6', 'Oncology');

----Создание таблицы 2
CREATE TABLE
Employee (
    id integer PRIMARY KEY, -- имя поля, тип данных, ограничение
  	department_id integer REFERENCES Department,
  	chief_doc_id integer,
    name VARCHAR (355) NOT NULL,
  	num_public integer
);
--заполнение таблица2
INSERT INTO Employee VALUES
('1', '1', '1', 'Kate', 4),
('2', '1', '1', 'Lidia', 2),
('3', '1', '1', 'Alexey', 1),
('4', '1', '2', 'Pier', 7),
('5', '1', '2', 'Aurel', 6),
('6', '1', '2', 'Klaudia', 1),
('7', '2', '3', 'Klaus', 12),
('8', '2', '3', 'Maria', 11),
('9', '2', '4', 'Kate', 10),
('10', '3', '5', 'Peter', 8),
('11', '3', '5', 'Sergey', 9),
('12', '3', '6', 'Olga', 12),
('13', '3', '6', 'Maria', 14),
('14', '4', '7', 'Irina', 2),
('15', '4', '7', 'Grit', 10),
('16', '4', '7', 'Vanessa', 16),
('17', '5', '8', 'Sascha', 21),
('18', '5', '8', 'Ben', 22),
('19', '6', '9', 'Jessy', 19),
('20', '6', '9', 'Ann', 18);

--2.1
--Вывести список названий департаментов и количество главных врачей в каждом из этих департаментов
SELECT
Department.name,
COUNT (DISTINCT chief_doc_id)  AS chief_doc
FROM Employee
JOIN Department
       ON Department.ID=Employee.department_id
GROUP BY Department.name, department_id;

--2.2
--Вывести список департаментов, в которых работают 3 и более сотрудников (id и название департамента, количество сотрудников)
SELECT
Department.id,
Department.name,
COUNT (Employee.name) AS Employee_count
FROM Department
JOIN Employee
       ON Employee.department_id=Department.ID
GROUP BY  Department.id, Department.name
HAVING COUNT (Employee.name) > 3;

--2.3
--Вывести список департаментов с максимальным количеством публикаций  (id и название департамента, количество публикаций)
with dep_public as
(SELECT
Department.id,
Department.name,
SUM(num_public) as public
FROM Department
JOIN Employee
       ON Employee.department_id=Department.ID
GROUP BY  Department.id, Department.name
order by public DESC
)
SELECT *
FROM dep_public
WHERE public = (SELECT max(public) FROM dep_public);

--2.4
--Вывести список сотрудников с минимальным количеством публикаций в своем департаменте (id и название департамента, имя сотрудника, количество публикаций)
WITH Employee_public_min
as (
  SELECT
	department_id,
	MIN(num_public) as min_public
	FROM Employee
	GROUP BY  department_id
)
SELECT
Employee_public_min.department_id,
Department.name,
Employee.id,
Employee.name,
Employee_public_min.min_public
FROM Employee_public_min
JOIN Employee
	ON Employee.num_public=Employee_public_min.min_public
JOIN Department
	ON Department.id=Employee_public_min.department_id
ORDER BY Employee_public_min.department_id;

--2.5
--Вывести список департаментов и среднее количество публикаций для тех департаментов, в которых работает более одного главного врача (id и название департамента, среднее количество публикаций)
SELECT
department_id,
Department.name,
round (AVG(num_public)) AS AVG_public
FROM Employee
JOIN Department
    ON Department.id=Employee.department_id
GROUP BY  department_id, Department.name
HAVING COUNT(DISTINCT chief_doc_id) > 1;