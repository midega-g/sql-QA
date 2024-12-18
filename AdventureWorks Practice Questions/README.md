
# About AdventureWorks Database  

## Introduction 

The **AdventureWorks** database is a sample database originally created for **Microsoft SQL Server (2008-2014)** to demonstrate standard **Online Transaction Processing (OLTP)** scenarios for a fictional bicycle manufacturer, **Adventure Works Cycles**.  

Since the original database was built for SQL Server, to use it with **PostgreSQL**, we need to perform specific steps to convert and set it up in a compatible format.

For the database documentation, visit [Datedo](https://dataedo.com/samples/html/AdventureWorks/doc/AdventureWorks_2/home.html)

---

## Requirements  

Before starting, ensure the following tools are installed on your system:  

1. **PostgreSQL** (Database server): [Install PostgreSQL](https://www.postgresql.org/download/)  
2. **psql** (CLI usually included by default when installing PostgreSQL). Confirm its installation by running the command 

    ```bash
    psql --version
    ```
3. **pgAdmin** (GUI for PostgreSQL): [Install pgAdmin](https://www.pgadmin.org/download/)  

**Note:** While we can also use **psql** instead of **pgAdmin** to execute the commands here, I prefer to use the later due to its intuitive and graphical interface that will allow us to easily connect to PostgreSQL instances, visualize the database objects (tables, views, functions, and so on), export and import data
 
---

## Operating System Notes  

### Linux  
The commands provided above work directly on Linux terminals. Ensure PostgreSQL, Ruby, and required scripts are installed.  

### Windows  
For Windows systems, use **Command Prompt** or **PowerShell** and ensure Ruby and PostgreSQL are in the system path. Alternatively, install a Bash-compatible terminal such as Git Bash or WSL (Windows Subsystem for Linux).  

### macOS  
macOS users can use the default **Terminal** application to run the same commands. Ensure Ruby is installed via **Homebrew**:  

```bash
brew install ruby
```

---

## Setting Up AdventureWorks in PostgreSQL  

### Step 1: Download AdventureWorks Database  

1. Visit the Microsoft SQL Server Samples [GitHub page](https://github.com/Microsoft/sql-server-samples/releases/download/adventureworks/AdventureWorks-oltp-install-script.zip) and download the **AdventureWorks 2014 OLTP Script**.  
2. Extract the downloaded `.zip` file. You will find several **CSV files** inside.

---

### Step 2: Convert AdventureWorks for PostgreSQL  

To set up AdventureWorks in PostgreSQL, we will use **lorint's scripts** to convert the SQL Server data into a PostgreSQL-compatible format.  

#### Required Scripts  
Download the following two files from lorint's GitHub repository:  
- **install.sql**: [install.sql](https://raw.githubusercontent.com/lorint/AdventureWorks-for-Postgres/master/install.sql)  
- **update_csvs.rb**: [update_csvs.rb](https://raw.githubusercontent.com/lorint/AdventureWorks-for-Postgres/master/update_csvs.rb)  

---

### Step 3: Preparing the CSV Files  

1. Place the following files into the **same folder**:  
   - **AdventureWorks CSV files** (extracted earlier)  
   - **install.sql**  
   - **update_csvs.rb**  

2. Open a terminal (CLI) in that folder and run the following command to modify the CSV files:  

   ```bash
   ruby update_csvs.rb
   ```

---

### Step 4: Create and Set Up the Database  

1. **Connect to PostgreSQL** using `psql` or your preferred terminal:  

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

---

## Verifying the Setup  

1. **Check all tables**:  
   Once the setup is complete, you can list all tables in the database by running the following commands:  

   ```sql
   \c "AdventureWorks"
   \dt (humanresources|person|production|purchasing|sales).*
   ```

2. **Expected Results**:  
   - **All 68 tables** are properly set up.  
   - **11 out of 20 views** are established (views dependent on XML functions are excluded).  

---

Everything from now on will then use pgAdmin GUI, but you are welcomed to use the CLI psql.

---

## 
