import os
import csv
import psycopg2

database = "mytestdb"
username = os.environ.get("USER_NAME_PSQL")
password = os.environ.get('PASSWORD_PSQL')
hostname = "192.168.1.14"
port = "5432"

try:
    #For connecting to the database
    conn = psycopg2.connect(user=username,
                                      password=password,
                                      host=hostname,
                                      port=port,
                                      database=database)
    cur = conn.cursor()

    #importing csv file
    with open('PySpark/employe.csv', 'r') as f:
        reader = csv.reader(f)
        next(reader)

        for row in reader:
            cur.execute("INSERT INTO mobile VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s)",
                    row
                    )
            conn.commit()

except (Exception, Error) as error:
    print("Error :", error)

finally:
    
    if connection:
        cursor.close()
        connection.close()
        print("PostgreSQL connection is closed")
