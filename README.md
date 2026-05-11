# CirclO — Micro Social Platform

**CMPE 157A**  
**Team:** Dushan Siriwardana (014312454) · Bui Bao Tran Tran (017005482)  
**Submission Date:** May 11, 2026

---

## Project Overview

CirclO is a console-based micro-social platform where students can connect, share posts, comment, react, and find project collaborators. It is built with Java 11, JDBC, and MySQL 8. The application follows a three-tier architecture (Presentation → Business Logic → Database) and supports full CRUD operations across seven entities: Users, Posts, Comments, Reactions, Connections, Projects, and Applications.

---

## Project Directory Structure

```
CirclO-Micro-Social-Platform/
├── src/
│   └── main/
│       └── java/
│           └── database/
│               ├── DBConnection.java           # JDBC connection manager
│               ├── UserDAO.java                # User CRUD (register, login, update, delete)
│               ├── PostDAO.java                # Post CRUD + feed query
│               ├── CommentDAO.java             # Comment CRUD
│               ├── ReactionDAO.java            # Reaction CRUD (upsert)
│               ├── ConnectionDAO.java          # Connection CRUD (send, accept, reject)
│               ├── ProjectDAO.java             # Project CRUD (post, browse, update, delete)
│               ├── ApplicationDAO.java         # Application CRUD (apply, accept, withdraw)
│               ├── SocialDemoApp.java          # Interactive console application (main entry)
│               ├── ComprehensiveTestApp.java   # Automated test suite for all CRUD operations
│               └── TestApp.java                # Quick database connectivity test
├── database/
│   ├── create_schema.sql                       # DDL: all tables, indexes, and constraints
│   └── initialize_data.sql                     # Seed data (20+ rows per table, no NULLs)
├── pom.xml                                     # Maven build and dependencies
└── README.md
```

---

## Dependencies and Required Software

| Tool  | Version Used |
|-------|-------------|
| Java (OpenJDK) | 11.0.29 |
| Maven | 3.9.6 |
| MySQL | 8.0.46 |
| MySQL JDBC Connector | 8.2.0 |

Maven automatically downloads the MySQL JDBC connector on first build — no manual download needed.

```xml
<dependency>
    <groupId>com.mysql</groupId>
    <artifactId>mysql-connector-j</artifactId>
    <version>8.2.0</version>
</dependency>
```

---

## Setup Instructions

### Step 1 — Start MySQL

**Option A: MySQL GUI App (recommended on macOS)**  
Open the MySQL preference pane (System Preferences → MySQL) and click **Start MySQL Server**.

**Option B: Terminal**
```bash
# If installed via Homebrew:
brew services start mysql

# If installed via MySQL installer:
sudo /usr/local/mysql/support-files/mysql.server start
```

Then add MySQL to your PATH if needed:
```bash
export PATH="/usr/local/mysql/bin:$PATH"
```

To make it permanent:
```bash
echo 'export PATH="/usr/local/mysql/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc
```

---

### Step 2 — Create the Database Schema

```bash
mysql -u root -p < database/create_schema.sql
```

This script creates the `circlo_db` database and all tables with constraints and indexes.

---

### Step 3 — Load Sample Data

```bash
mysql -u root -p < database/initialize_data.sql
```

This populates each table with 20+ rows of sample data. All fields are filled — no NULL values.

---

### Step 4 — Configure Database Password

The default password is `123456789`. If your MySQL root password is different, update it in:

```
src/main/java/database/DBConnection.java — line 26
```

Change:
```java
private static final String DB_PASSWORD = "123456789";
```

---

## Running the Application

### Option A — Interactive App (recommended for demo)
```bash
mvn compile exec:java -Dexec.mainClass="database.SocialDemoApp"
```

### Option B — Automated Test Suite
```bash
mvn compile exec:java -Dexec.mainClass="database.ComprehensiveTestApp"
```

### Option C — Quick Connection Test
```bash
mvn compile exec:java -Dexec.mainClass="database.TestApp"
```

### Option D — VS Code
1. Open the project folder in VS Code
2. Install **Extension Pack for Java** if prompted
3. Open `SocialDemoApp.java` and click the **Run** button above `main()`

---

## Demo Login Credentials

All 20 sample users share the password `pass123`.

| Username | Password |
|----------|----------|
| alice    | pass123  |
| bob      | pass123  |
| charlie  | pass123  |

You can also register a new account from the login screen.

---

## Database Schema

```
Users        (user_id PK, username UNIQUE NOT NULL, email UNIQUE NOT NULL, password NOT NULL, created_at)
Posts        (post_id PK, user_id FK→Users CASCADE, content NOT NULL, created_at)
Comments     (comment_id PK, post_id FK→Posts CASCADE, user_id FK→Users CASCADE, content NOT NULL, created_at)
Reactions    (reaction_id PK, post_id FK→Posts CASCADE, user_id FK→Users CASCADE, reaction_type NOT NULL, created_at, UNIQUE(post_id, user_id))
Connections  (connection_id PK, requester_id FK→Users CASCADE, receiver_id FK→Users CASCADE, status DEFAULT 'pending', created_at, UNIQUE(requester_id, receiver_id))
Projects     (project_id PK, owner_id FK→Users CASCADE, title NOT NULL, description, category, status DEFAULT 'open', created_at)
Applications (application_id PK, project_id FK→Projects CASCADE, applicant_id FK→Users CASCADE, message, status DEFAULT 'pending', created_at)
```

---

## Features (CRUD Summary)

| Entity       | Create | Read | Update | Delete |
|-------------|--------|------|--------|--------|
| Users       | Register | Login / list / get by ID | Email + password | Cascade delete |
| Posts       | Create post | All posts / feed / by ID | Edit content | Owner only |
| Comments    | Add comment | By post | Edit content | Owner only |
| Reactions   | React to post | By post | Change type | Owner only |
| Connections | Send request | List connections | Accept / reject | Either party |
| Projects    | Post project idea | Browse all / by category / by ID | Edit details / status | Owner only |
| Applications| Apply to project | View sent / received | Accept / reject | Withdraw |

---

## Database Connection Details

- **URL:** `jdbc:mysql://localhost:3306/circlo_db`
- **User:** `root`
- **Password:** `123456789` (default)
- **Connection file:** `src/main/java/database/DBConnection.java`
- **Additional parameters:** `useSSL=false`, `serverTimezone=UTC`, `allowPublicKeyRetrieval=true`

To change host or port, edit `DB_URL` in `DBConnection.java`.

---

## Error Handling

All database operations use try-catch blocks to handle `SQLException`. Connection errors are caught at startup in `DBConnection.java` and print a clear message if the database is unreachable or credentials are wrong. All connections use try-with-resources to ensure they are properly closed after each operation.
