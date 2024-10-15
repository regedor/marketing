# pi-ww

# Requirements
 - PostgreSQL *15 or later (check installation guide [here](https://www.postgresql.org/download/))
 - Ruby ^3.3.5 or later (check installation guide [here](https://www.ruby-lang.org/en/documentation/installation/))
 - Rails ^7.2.1 or later (check installation guide [here](https://guides.rubyonrails.org/getting_started.html))

# Installation
To set up the project on your local machine:

1. Clone the repository
```bash
git clone https://github.com/regedor/pi-ww.git
cd pi-ww
```

2. Install the dependencies
```bash
bundle install
```

3. Create a .env file in the root directory and add the following environment variables (change as your needs):
```bash
SUPER_ADMIN_EMAIL=admin@example.com
SUPER_ADMIN_PASSWORD=your_super_admin_password

DATABASE_USERNAME=your_database_username
DATABASE_PASSWORD=your_database_password
DATABASE_HOSTNAME=localhost
DATABASE_PORT=5432
```

4. Create the database
```bash
rails db:create
rails db:migrate
rails db:seed
```

# Usage
To start the server, run:
```bash
rails server
```
Then, visit `http://localhost:3000` in your browser.

# Authors
 ...
