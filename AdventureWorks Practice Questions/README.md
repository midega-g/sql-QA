
# About AdventureWorks Database  

## Introduction 

The **AdventureWorks** database is a sample database originally created for **Microsoft SQL Server (2008-2014)** to demonstrate standard **Online Transaction Processing (OLTP)** scenarios for a fictional bicycle manufacturer, **Adventure Works Cycles**.  

Since the original database was built for SQL Server, to use it with **PostgreSQL**, we need to perform specific steps to convert and set it up in a compatible format.

For the database documentation, visit [Datedo](https://dataedo.com/samples/html/AdventureWorks/doc/AdventureWorks_2/home.html)

## Requirements  

Before starting, ensure the following tools are installed on your system:  

1. **PostgreSQL** (Database server): [Install PostgreSQL](https://www.postgresql.org/download/)  
2. **psql** (CLI usually included by default when installing PostgreSQL). Confirm its installation by running the command 

    ```bash
    psql --version
    ```
3. **pgAdmin** (GUI for PostgreSQL): [Install pgAdmin](https://www.pgadmin.org/download/)  

**Note:** **psql** will be used to set up the database. However, to execute the queries that answer the questions, **pgAdmin** will be my preferred tool due to its intuitive and graphical interface as it will allow us to easily connect to PostgreSQL instances, visualize the database objects (tables, views, functions, and so on), export and import data. Anyway, you can still use **psql** if you wish to; it's your choice!
 

## Operating System Notes  

**Linux:** The commands provided above work directly on Linux terminals. Ensure PostgreSQL, Ruby, and required scripts are installed.  

**Windows:** For Windows systems, use **Command Prompt** or **PowerShell** and ensure Ruby and PostgreSQL are in the system path. Alternatively, install a Bash-compatible terminal such as Git Bash or WSL (Windows Subsystem for Linux).  

**macOS:** macOS users can use the default **Terminal** application to run the same commands. Ensure Ruby is installed via **Homebrew**:  

```bash
brew install ruby
```

## Setting Up AdventureWorks in PostgreSQL  

### Step 1: Download AdventureWorks Database  

1. Visit the Microsoft SQL Server Samples [GitHub page](https://github.com/Microsoft/sql-server-samples/releases/download/adventureworks/AdventureWorks-oltp-install-script.zip) and download the **AdventureWorks 2014 OLTP Script**.  
2. Extract the downloaded `.zip` file. You will find several **CSV files** inside.


### Step 2: Convert AdventureWorks for PostgreSQL  

To set up AdventureWorks in PostgreSQL, we will use **lorint's scripts** to convert the SQL Server data into a PostgreSQL-compatible format.  

#### Required Scripts  
Download the following two files from lorint's GitHub repository:  
- **install.sql**: [install.sql](https://raw.githubusercontent.com/lorint/AdventureWorks-for-Postgres/master/install.sql)  
- **update_csvs.rb**: [update_csvs.rb](https://raw.githubusercontent.com/lorint/AdventureWorks-for-Postgres/master/update_csvs.rb)  


### Step 3: Preparing the CSV Files  

1. Place the following files into the **same folder**:  
   - **AdventureWorks CSV files** (extracted earlier)  
   - **install.sql**  
   - **update_csvs.rb**  

2. Open a terminal (CLI) in that folder and run the following command to modify the CSV files:  

   ```bash
   ruby update_csvs.rb
   ```


### Step 4: Set Up a Server in pgAdmin4

1. Launch pgAdmin4 and under the "Quick Links" section click the "Add New Server" button
2. Under the "General" tab of the "Register - Server" pop up window, add a name of your liking to the "Name" input box. In my case I called it "SampleTest".
3. Go to the "Connection" tab and add the host name or address as "localhost" and input your password (toggle on the "Save password" button if you like). I'll leave other options with the default value and 
4. Click "Save" and this should lead you to a window like the one one below
5. Using the psql CLI we'll create a new database (as shown in the Step 5) in addition to the "postgres" database already available, which we'll leave untouched

### Step 5: Create and Set Up the Database  

**Note:**

1. Use the following command to **Connect to PostgreSQL** using `psql` on your preferred terminal to create the database and tables, import the data, and set up the views and keys:  

   ```bash
   psql "<YOUR-DATABASE-CONNECTION-SCRIPT>"
   ```

2. **Create the database**:  

   ```sql
   CREATE DATABASE "AdventureWorks";
   ```

3. **Connect to the newly created database**:  

   ```sql
   \c AdventureWorks
   ```

4. **Run the `install.sql` script** to create tables, views, and load data:  

   ```bash
   \i install.sql
   ```

   If you do not have a database created for your user account, you may need to add the `-U postgres` option to the above commands:  

   ```bash
   psql -U postgres -c "CREATE DATABASE \"AdventureWorks\";"
   psql -U postgres -d AdventureWorks -f install.sql
   ```

## Verifying the Setup  

1. **Check all tables**:  
   Once the setup is complete, you can list all tables in the database by running the following commands:  

   ```sql
   \c "AdventureWorks"
   \dt (humanresources|person|production|purchasing|sales).*
   ```

   Which should give you the following results:
   - **All 68 tables** are properly set up.  
   - **11 out of 20 views** are established (views dependent on XML functions are excluded). 

2. Alternatively, you can go to the pgAdmin4 interface and refresh the server by right clicking the "Servers" option to locate the "Refresh..." option and checking if the database is correctly set


## Using pgAmin4's Query Tool

1. With the `AdventureWorks` database and its relevant object's created, right click on it and select the "Query Tool" option where we will write our queries
   - To execute every command in the script, press the button `1` (shown in the image), or press `F5` in your keyboard
   - To execute just a single command, press button `2` (shown in the image), or press `alt + F5` in your keyboard
   - To save the script in the Query Tool, press button `3` (shown in the image), or press `ctrl + s` in your keyboard

Everything from now on will then use pgAdmin GUI, but you are welcomed to use the CLI psql.


## Source of Inspiration

- The questions solved in these exercises were taken from the book *Real SQL Queries: 50 Challenges* by Brian Cohen which can be accessed either from [Amazon](https://www.amazon.com/Real-SQL-Queries-50-Challenges/dp/1517290708) or [Scribd] (https://www.scribd.com/document/333677601/Real-SQL-Queries-50-Challenges-Brian-Cohen)


## Source of Inspiration

- The questions solved in these exercises were taken from the book *Real SQL Queries: 50 Challenges* by Brian Cohen, which can be accessed either from [Amazon](https://www.amazon.com/Real-SQL-Queries-50-Challenges/dp/1517290708) or [Scribd](https://www.scribd.com/document/333677601/Real-SQL-Queries-50-Challenges-Brian-Cohen)
- I chose the book because, unlike most SQL books, it comes with 50 practical problems and their solutions. The challenges are not overly simplistic, making them ideal for SQL enthusiasts looking to refine their skills.  
- While the book provides solutions, it does not explain the reasoning behind them, and the style can sometimes make it easy to lose track of the mechanics. This inspired me to not only adapt the challenges for **PostgreSQL** but also provide additional context for the questions and the reasoning behind each solution.  
- For those specifically looking for SQL Server solutions, I found this [GitHub repository](https://github.com/shrutichen86/SQL-Queries/blob/master/Real%20SQL%20Queries%2050%20Challenges.txt) to be a useful resource


