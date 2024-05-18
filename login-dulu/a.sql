USE rumah_makan;

CREATE TABLE
    Meja (
        number INT AUTO_INCREMENT PRIMARY KEY,
        capacity INT NOT NULL
    );

CREATE TABLE
    Employee (
        id INT AUTO_INCREMENT PRIMARY KEY,
        name VARCHAR(64) NOT NULL,
        position VARCHAR(16) NOT NULL,
        salary DOUBLE (16, 4) NOT NULL
    );

Query OK,
0 rows affected (0.018 sec)
CREATE TABLE
    Customer (
        id INT AUTO_INCREMENT PRIMARY KEY,
        name VARCHAR(64) NOT NULL,
        phone VARCHAR(32) NOT NULL
    );

Query OK,
0 rows affected (0.026 sec)
CREATE TABLE
    Pesanan (
        id INT AUTO_INCREMENT PRIMARY KEY,
        date DATETIME,
        status ENUM ('SEDANG PROSES', 'SELESAI') DEFAULT 'SEDANG PROSES',
        Total DOUBLE (16, 4) NOT NULL,
        Meja_number INT NOT NULL,
        Customer_id INT NOT NULL,
        FOREIGN KEY (Meja_number) REFERENCES Meja (number),
        FOREIGN KEY (Customer_id) REFERENCES Customer (id)
    );

Query OK,
0 rows affected (0.029 sec)
CREATE TABLE
    Employee_Pesanan (
        id INT AUTO_INCREMENT PRIMARY KEY,
        Employee_id INT NOT NULL,
        Pesanan_id INT NOT NULL,
        FOREIGN KEY (Employee_id) REFERENCES Employee (id),
        FOREIGN KEY (Pesanan_id) REFERENCES Pesanan (id)
    );

Query OK,
0 rows affected (0.032 sec)
CREATE TABLE
    Menu (
        id INT AUTO_INCREMENT PRIMARY KEY,
        name VARCHAR(64) NOT NULL,
        price DOUBLE (16, 4) NOT NULL
    );

CREATE TABLE
    Pesanan_Menu (
        id INT AUTO_INCREMENT PRIMARY KEY,
        Pesanan_id INT NOT NULL,
        Menu_id INT NOT NULL,
        quantity INT NOT NULL,
        subtotal DOUBLE (16, 4) NOT NULL,
        FOREIGN KEY (Pesanan_id) REFERENCES Pesanan (id),
        FOREIGN KEY (Menu_id) REFERENCES Menu (id)
    );

Query OK,
0 rows affected (0.035 sec)
INSERT INTO
    Meja (capacity)
VALUES
    (2),
    (4),
    (8),
    (10),
    (12);

INSERT INTO
    Customer (name, phone)
VALUES
    ('Budi Santoso', '081234567890'),
    ('Siti Rahayu', '085678912345'),
    ('Hadi Prasetyo', '081112233445'),
    ('Ani Wijaya', '087778899001'),
    ('Joko Susanto', '089876543210');

INSERT INTO
    Employee (name, position, salary)
VALUES
    ('Anita Putri', 'waiter', 2000000),
    ('Citra Permata', 'waiter', 2000000),
    ('Dewi Lestari', 'chef', 4000000),
    ('Eka Prasetyo', 'manager', 5000000),
    ('Fandi Gunawan', 'waiter', 2000000);

INSERT INTO
    Menu (name, price)
VALUES
    ('Nasi Goreng', 25000),
    ('Sate Ayam', 20000),
    ('Gado-Gado', 15000),
    ('Es Teh Manis', 5000),
    ('Es Campur', 10000);

INSERT INTO
    Pesanan (date, status, Meja_number, Customer_id)
VALUES
    ('2024-05-02 12:00:00', 'SEDANG PROSES', 1, 1),
    ('2024-05-02 12:15:00', 'SELESAI', 2, 2),
    ('2024-05-02 12:30:00', 'SEDANG PROSES', 3, 3),
    ('2024-05-02 12:45:00', 'SELESAI', 4, 4),
    ('2024-05-02 13:00:00', 'SEDANG PROSES', 5, 5);

INSERT INTO
    Employee_Pesanan (Employee_id, Pesanan_id)
VALUES
    (1, 1),
    (2, 2),
    (5, 3),
    (5, 4),
    (1, 5);

INSERT INTO
    Pesanan_Menu (Pesanan_id, Menu_id, quantity)
VALUES
    (1, 1, 1),
    (2, 2, 2),
    (3, 3, 3),
    (4, 4, 4),
    (5, 5, 5);

SELECT
    *
FROM
    Employee
WHERE
    position = 'waiter';

SELECT
    position,
    SUM(salary) AS total_gaji
FROM
    Employee
GROUP BY
    position;

SELECT
    position,
    SUM(salary) AS total_gaji
FROM
    Employee
WHERE
    salary > 2100000
GROUP BY
    position;

SELECT
    COUNT(*) AS total_employee
FROM
    Employee;

SELECT
    *
FROM
    Employee
ORDER BY
    salary DESC;

SELECT
    name,
    (
        SELECT
            COUNT(*)
        FROM
            Employee_Pesanan
        WHERE
            Employee_Pesanan.Employee_id = Employee.id
    ) AS jumlah_pesanan
FROM
    Employee;

SELECT
    name,
    phone,
    (
        SELECT
            status
        FROM
            Pesanan
        WHERE
            Pesanan.Customer_id = Customer.id
    ) AS status_pesanan
FROM
    Customer;

SELECT
    (
        SELECT
            SUM(Menu.price * Pesanan_Menu.quantity)
        FROM
            Pesanan_Menu,
            Menu
        WHERE
            Pesanan_Menu.Menu_id = Menu.id
            AND Menu.name = 'Nasi Goreng'
    ) AS total_pendapatan_nasi_goreng;

SELECT
    name,
    (
        SELECT
            SUM(quantity)
        FROM
            Pesanan_Menu
        WHERE
            Pesanan_Menu.Menu_id = Menu.id
    ) AS total_quantitas
FROM
    Menu;

SELECT
    SUM(Menu.price * Pesanan_Menu.quantity) AS total_pendapatan
FROM
    Menu,
    Pesanan_Menu
WHERE
    Menu.id = Pesanan_Menu.Menu_id;

SELECT
    Employee.name,
    COUNT(Employee_Pesanan.Employee_id) AS jumlah_pesanan
FROM
    Employee
    JOIN Employee_Pesanan ON Employee.id = Employee_Pesanan.Employee_id
WHERE
    Employee.position = 'waiter'
GROUP BY
    Employee.id;

SELECT
    Customer.name AS nama_customer,
    Customer.phone AS nomor_telepon,
    Pesanan.id AS nomor_pesanan
FROM
    Customer
    JOIN Pesanan ON Customer.id = Pesanan.Customer_id;

SELECT
    Meja.number
FROM
    Meja
    JOIN Pesanan ON Meja.number = Pesanan.Meja_number
WHERE
    Pesanan.status = 'SEDANG PROSES';

SELECT
    SUM(Menu.price * Pesanan_Menu.quantity) AS total_pendapatan_gado_gado
FROM
    Pesanan_Menu
    JOIN Menu ON Pesanan_Menu.Menu_id = Menu.id
WHERE
    Menu.name = 'Gado-Gado';

SELECT
    Employee.name AS nama_employee,
    COUNT(Employee_Pesanan.Pesanan_id) AS jumlah_pesanan
FROM
    Employee
    JOIN Employee_Pesanan ON Employee.id = Employee_Pesanan.Employee_id
WHERE
    Employee.position = 'waiter'
GROUP BY
    Employee.id
HAVING
    COUNT(Employee_Pesanan.Pesanan_id) > 1;