import psycopg2
from pprint import pprint


def create_db(conn):
    conn.execute("""
    CREATE TABLE IF NOT EXISTS clients(
        id SERIAL PRIMARY KEY,
        name VARCHAR(20),
        lastname VARCHAR(30),
        email VARCHAR(254)
        );
    """)
    conn.execute("""
    CREATE TABLE IF NOT EXISTS phonenumbers(
        phone VARCHAR(11) PRIMARY KEY,
        client_id INTEGER REFERENCES clients(id)
        );
    """)
    return


def delete_db(conn):
    conn.execute("""
        DROP TABLE clients, phonenumbers CASCADE;
        """)


def add_client(conn, first_name, last_name, email, phones=None):
    conn.execute("""
        INSERT INTO clients(first_name, last_name, email)
        VALUES (%s, %s, %s)
        """, (first_name, last_name, email))
    conn.execute("""
        SELECT id from clients
        ORDER BY id DESC
        LIMIT 1
        """)
    id = conn.fetchone()[0]
    if phones is None:
        return id
    else:
        add_phone(conn, id, phones)
        return id


def add_phone(conn, client_id, phone):
    conn.execute("""
        INSERT INTO phonenumbers(phone, client_id)
        VALUES (%s, %s)
        """, (phone, client_id))
    return client_id


def change_client(conn, client_id, first_name=None, last_name=None, email=None):
    conn.execute("""
        SELECT * from clients
        WHERE id = %s
        """, (client_id,))
    info = conn.fetchone()
    if first_name is None:
        first_name = info[1]
    if last_name is None:
        last_name = info[2]
    if email is None:
        email = info[3]
    conn.execute("""
        UPDATE clients
        SET first_name = %s, last_name = %s, email =%s 
        where id = %s
        """, (first_name, last_name, email, client_id))
    return client_id


def delete_phone(conn, phone):
    conn.execute("""
        DELETE FROM phonenumbers 
        WHERE phone = %s
        """, (phone,))
    return phone


def delete_client(conn, client_id):
    conn.execute("""
        DELETE FROM phonenumbers
        WHERE client_id = %s
        """, (client_id,))
    conn.execute("""
        DELETE FROM clients 
        WHERE id = %s
       """, (client_id,))
    return client_id


def find_client(conn, first_name=None, last_name=None, email=None, phone=None):
    if first_name is None:
        first_name = '%'
    else:
        first_name = '%' + first_name + '%'
    if last_name is None:
        last_name = '%'
    else:
        last_name = '%' + last_name + '%'
    if email is None:
        email = '%'
    else:
        email = '%' + email + '%'
    if phone is None:
        conn.execute("""
            SELECT c.id, c.first_name, c.last_name, c.email, p.phone FROM clients c
            LEFT JOIN phonenumbers p ON c.id = p.client_id
            WHERE c.first_name LIKE %s AND c.last_name LIKE %s
            AND c.email LIKE %s
            """, (first_name, last_name, email))
    else:
        conn.execute("""
            SELECT c.id, c.first_name, c.last_name, c.email, p.phone FROM clients c
            LEFT JOIN phonenumbers p ON c.id = p.client_id
            WHERE c.first_name LIKE %s AND c.last_name LIKE %s
            AND c.email LIKE %s AND p.phone like %s
            """, (first_name, last_name, email, phone))
    return conn.fetchall()


if __name__ == '__main__':
    with psycopg2.connect(database="clients_db", user="postgres", password="postgres") as conn:
        with conn.cursor() as curs:
            # Удаление таблиц перед запуском
            delete_db(curs)
            # 1. Cоздание таблиц
            create_db(curs)
            print("БД создана")
            # 2. Добавляем 5 клиентов
            print("Добавлен клиент id: ",
                  add_client(curs, "Михаил", "Шабалин", "715qy08@gmail.com"))
            print("Добавлен клиент id: ",
                  add_client(curs, "Константин", "Дементьев", "vubx0t@mail.ru", 79993318644))
            print("Добавлен клиент id: ",
                  add_client(curs, "Гордей", "Виноградов", "c0pu@outlook.com", 79933314644))
            print("Добавлен клиент id: ",
                  add_client(curs, "Емельян", "Юнусов", "k8sjebg1y@mail.ru", 79913312643))
            print("Добавлена клиент id: ",
                  add_client(curs, "Карл", "Евдокимов", "19dn@outlook.com"))
            print("Данные в таблицах")
            curs.execute("""
                SELECT c.id, c.first_name, c.last_name, c.email, p.phone FROM clients c
                LEFT JOIN phonenumbers p ON c.id = p.client_id
                ORDER by c.id
                """)
            pprint(curs.fetchall())
            # 3. Добавляем клиенту номер телефона(одному первый, одному второй)
            print("Телефон добавлен клиенту id: ",
                  add_phone(curs, 2, 79877876543))
            print("Телефон добавлен клиенту id: ",
                  add_phone(curs, 1, 79621994802))

            print("Данные в таблицах")
            curs.execute("""
                SELECT c.id, c.first_name, c.last_name, c.email, p.phone FROM clients c
                LEFT JOIN phonenumbers p ON c.id = p.client_id
                ORDER by c.id
                """)
            pprint(curs.fetchall())
            # 4. Изменим данные клиента
            print("Изменены данные клиента id: ",
                  change_client(curs, 4, "Иван", None, '123@outlook.com'))
            # 5. Удаляем клиенту номер телефона
            print("Телефон удалён c номером: ",
                  delete_phone(curs, '79621994802'))
            print("Данные в таблицах")
            curs.execute("""
                SELECT c.id, c.first_name, c.last_name, c.email, p.phone FROM clients c
                LEFT JOIN phonenumbers p ON c.id = p.client_id
                ORDER by c.id
                """)
            pprint(curs.fetchall())
            # 6. Удалим клиента номер 2
            print("Клиент удалён с id: ",
                  delete_client(curs, 2))
            curs.execute("""
                            SELECT c.id, c.first_name, c.last_name, c.email, p.phone FROM clients c
                            LEFT JOIN phonenumbers p ON c.id = p.client_id
                            ORDER by c.id
                            """)
            pprint(curs.fetchall())
            # 7. Найдём клиента
            print('Найденный клиент по имени:')
            pprint(find_client(curs, 'Гордей'))

            print('Найденный клиент по email:')
            pprint(find_client(curs, None, None, '19dn@outlook.com'))

            print('Найденный клиент по имени, фамилии и email:')
            pprint(find_client(curs, 'Гордей', 'Виноградов',
                               'c0pu@outlook.com'))

            print('Найденный клиент по имени, фамилии, телефону и email:')
            pprint(find_client(curs, 'Иван', 'Юнусов',
                               '123@outlook.com', '79913312643'))

            print('Найденный клиент по имени, фамилии, телефону:')
            pprint(find_client(curs, None, None, None, '79913312643'))

conn.close()
