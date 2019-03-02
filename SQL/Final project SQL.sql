--Создание таблицы 1
CREATE TABLE
Department (
    id integer PRIMARY KEY,
    name VARCHAR (50) NOT NULL
);

--заполнение таблица 1
INSERT INTO Department VALUES
('1', 'Therapy'),
('2', 'Neurology'),
('3', 'Cardiology'),
('4', 'Gastroenterology'),
('5', 'Hematology'),
('6', 'Oncology');

--Создание таблицы 2
CREATE TABLE
Chief_doc (
    chief_doc_id integer PRIMARY KEY,
    department_id integer REFERENCES Department(id),
    name VARCHAR (50) NOT NULL
);

--заполнение таблица 2
INSERT INTO Chief_doc VALUES
('1', '1', 'Anna'),
('2', '4', 'София'),
('3', '3', 'Марк'),
('4', '4', 'Елена'),
('5', '6', 'Платон'),
('6', '5', 'Изабелла');

--Создание таблицы 3
CREATE TABLE
Employee (
    id integer PRIMARY KEY,
  	department_id integer REFERENCES Department(id),
  	name VARCHAR (50) NOT NULL
);

--заполнение таблица 3
INSERT INTO Employee VALUES
('1', '1', 'Kate'),
('2', '1', 'Lidia'),
('3', '1', 'Alexey'),
('4', '1', 'Pier'),
('5', '1', 'Aurel'),
('6', '1', 'Klaudia'),
('7', '2', 'Klaus'),
('8', '2', 'Maria'),
('9', '2', 'Katrin'),
('10', '3', 'Peter'),
('11', '3', 'Sergey'),
('12', '3', 'Olga'),
('13', '3', 'Maria'),
('14', '4', 'Irina'),
('15', '4', 'Grit'),
('16', '4', 'Vanessa'),
('17', '5', 'Sascha'),
('18', '5', 'Ben'),
('19', '6', 'Jessy'),
('20', '6', 'Ann');

--Создание таблицы 4
CREATE TABLE
Publication (
    id integer PRIMARY KEY,
  	employee_id integer REFERENCES Employee(id),
    name VARCHAR (355) NOT NULL
);

--заполнение таблица 4
INSERT INTO Publication VALUES
('1', '1', '6 правил здорового сна'),
('2', '3', '4 продукта, способствующих появлению стресса'),
('3', '5', 'Как не заболеть во время отпуска'),
('4', '4', '5 опасностей горнолыжных курортов'),
('5', '1', 'Психосоматика: психологические причины болезней'),
('6', '7', 'Повышения иммунитета'),
('7', '9', 'Пищевые добавки'),
('8', '6', 'Отдых на юге, стоит ли рисковать?'),
('9', '7', 'Кому полезна ритмическая гимнастика'),
('10', '4', 'Как выжить на морозе?'),
('11', '12', 'Первая помощь при отравлении'),
('12', '4', 'Как избежать травм на скользких улицах?'),
('13', '15', 'Упражнения для осанки на рабочем месте'),
('14', '17', 'Расслабление с помощью прогрессивной мышечной релаксации'),
('15', '2', 'Как улучшить зрение в домашних условиях'),
('16', '5', 'Почему мы устаем после долгих каникул');

--запрос 1
SELECT
	Department.name as Department,
    Chief_doc.name as Chief
FROM Department
JOIN Chief_doc
       ON Department.ID=Chief_doc.department_id;

--запрос 2
SELECT
	Department.name as Department,
    COUNT (Employee.id) as Employee_count
FROM Department
JOIN Employee
       ON Department.ID=Employee.department_id
GROUP BY  Department.id;

--запрос 3
SELECT
	Employee.name as Employee,
    COUNT(Publication.employee_id) as Publication
FROM Employee
JOIN Publication
       ON Employee.ID=Publication.employee_id
GROUP BY  Employee
ORDER BY Publication DESC;

--запрос 4
SELECT
	Department.name,
	Employee.name as Employee,
    COUNT(Publication.employee_id) as Publication
FROM Employee
JOIN Publication
       ON Employee.ID=Publication.employee_id
JOIN Department
       ON Department.ID=Employee.department_id
GROUP BY  Employee, Department.name
HAVING COUNT(Publication) >= 2;

--запрос 5
WITH Employee_public_max as (
SELECT
	Employee.name as Employee,
    COUNT(Publication.employee_id) as Publication
FROM Employee
JOIN Publication
       ON Employee.ID=Publication.employee_id
GROUP BY  Employee
  )
SELECT *
FROM Employee_public_max
WHERE Publication = (
     SELECT max(Publication)
     FROM Employee_public_max);

--запрос 6
SELECT
	Employee.name,
    Publication.name AS public
FROM Employee
LEFT JOIN Publication
       ON Employee.ID=Publication.employee_id
WHERE Publication.employee_id IS NULL;

--запрос 7
SELECT
	Department.name,
    COUNT(Publication.employee_id) as count_public
FROM Publication
JOIN Employee
       ON Employee.ID=Publication.employee_id
JOIN Department
       ON Department.ID=Employee.department_id
GROUP BY Department.name
ORDER BY count_public DESC;

--запрос 8
WITH temp_count as
(
SELECT
	Publication.employee_id,
    COUNT(Publication.id)
FROM Publication
GROUP BY Publication.employee_id
)
SELECT

Department.NAME,
AVG (temp_count.COUNT)
FROM temp_count
JOIN Employee
       ON Employee.ID=temp_count.employee_id
JOIN Department
       ON Department.ID=Employee.department_id
GROUP BY Department.NAME;

--запрос 9
WITH temp_count as
(
SELECT
  	Department.name,
    COUNT(Publication.id) AS Public
FROM Publication
  JOIN Employee
       ON Employee.ID=Publication.employee_id
JOIN Department
       ON Department.ID=Employee.department_id
GROUP BY  Department.name
)
SELECT *
FROM temp_count
WHERE public = (SELECT max(public) FROM temp_count);

--запрос 10
SELECT
  	Department.name,
    COUNT(Publication.id) AS Public
FROM Publication
  JOIN Employee
       ON Employee.ID=Publication.employee_id
JOIN Department
       ON Department.ID=Employee.department_id
GROUP BY  Department.name
HAVING COUNT(Publication.id) < 2;

--просмотр таблиц
SELECT * FROM Department;
SELECT * FROM Employee;
SELECT * FROM Publication;
SELECT * FROM Chief_doc;

