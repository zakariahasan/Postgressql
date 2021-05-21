Users, groups, and roles
 user groups and roles are synonyms.

  Create user = create role+ login permission 

To create a PostgreSQL user
 postgres=# create user appuser1 with password 'password';
or
 postgres=# create role appuser_role2 with login password 'password';
  Note :All new users and roles inherit permissions from the public role.

WHAT IS PUBLIC SCHEMA AND PUBLIC ROLE
 When a new database is created, PostgreSQL by default creates a schema named public.
 All new users and roles are by default granted this public role, and can create object in public schema.

SEARCH PATH
 The search path is a list of schema names that PostgreSQL checks when you don’t use a qualified name of the database object.
 For example, when you select from a table named testtable, PostgreSQL looks for this table in the schemas listed in the search path.
  postgres=# show search_path;
      search_path   
   -----------------
    "$user", public
   (1 row)

    The first name “$user” resolves to the name of the currently logged in user. 
    By default, no schema with the same name as the user name exists. So the public schema becomes the default 
    schema whenever an unqualified object name is used. 

     by default, all users have access to create objects in the public schema, and therefore the table is created successfully.

      you should revoke the default create permission on the public schema from the public role using the following SQL statement:

`      REVOKE CREATE ON SCHEMA public FROM PUBLIC;
       
       Below revokes the public role’s ability to connect to the database:

       REVOKE ALL ON DATABASE testdb FROM PUBLIC;

CREATING DATABASE ROLES

 let's create a Read-only role
  The first step is to create a new role named app_readonly1 using the following SQL statement:
   CREATE ROLE app_readonly1;
   Note :This is a base role with no permissions and no password. It cannot be used to log in to the database.

Grant this role permission to connect to your target database named “dvdrental”:

GRANT CONNECT ON DATABASE dvdrental TO app_readonly1;

GRANT USAGE ON SCHEMA app_schema TO app_readonly1;

The next step is to grant the app_readonly1 role access to run select on the required tables.

GRANT SELECT ON TABLE mytable1, mytable2 TO app_readonly1;

GRANT SELECT ON ALL TABLES IN SCHEMA app_schema TO app_readonly1;

ALTER DEFAULT PRIVILEGES IN SCHEMA app_schema GRANT SELECT ON TABLES TO app_readonly1;


How to Create database users

CREATE USER appuser WITH PASSWORD 'password';
GRANT app_readonly1 TO appuser;



-- Revoke privileges from 'public' role
REVOKE CREATE ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON DATABASE dvdrental FROM PUBLIC;

-- Read-only role
CREATE ROLE app_readonly1;
GRANT CONNECT ON DATABASE dvdrental TO app_readonly1;
create schema app_schema;
GRANT USAGE ON SCHEMA app_schema TO app_readonly1;
GRANT SELECT ON ALL TABLES IN SCHEMA app_schema TO app_readonly1;
ALTER DEFAULT PRIVILEGES IN SCHEMA app_schema GRANT SELECT ON TABLES TO app_readonly1;

-- Read/write role
CREATE ROLE app_readwrite1;
GRANT CONNECT ON DATABASE dvdrental TO app_readwrite1;
GRANT USAGE, CREATE ON SCHEMA app_schema TO app_readwrite1;
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA app_schema TO app_readwrite1;
ALTER DEFAULT PRIVILEGES IN SCHEMA app_schema GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO app_readwrite1;
GRANT USAGE ON ALL SEQUENCES IN SCHEMA app_schema TO app_readwrite1;
ALTER DEFAULT PRIVILEGES IN SCHEMA app_schema GRANT USAGE ON SEQUENCES TO app_readwrite1;

-- Users creation
CREATE USER appreporting_user1 WITH PASSWORD 'some_password';
CREATE USER app_reporting_user2 WITH PASSWORD 'some_password';
CREATE USER app_user1 WITH PASSWORD 'some_password';
CREATE USER app_user2 WITH PASSWORD 'some_password';

-- Grant privileges to users
GRANT app_readonly1 TO appreporting_user1;
GRANT app_readonly1 TO app_reporting_user2;
GRANT app_readwrite1 TO app_user1;
GRANT app_readwrite1 TO app_user2;
