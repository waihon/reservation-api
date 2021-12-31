# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

## Ruby
* Ruby 2.7.5
* Ruby version manager: rbenv
* Gem management: rbenv-gemset

## System dependencies
* Rails 6.1.4
* SQLite 3

## Installation
### macOS
1. Open a new Terminal session (Application -> Utilities):
2. Install Homebrew, a package manager for macOS: <br />
   `/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"` <br />
   If you're asked about installing Apple's Command Line Tools for Xcode, go ahead and answer "yes".
3. Install rbenv, a Ruby version manager: <br />
   `brew install rbenv`
4. Set up rbenv by running the following command: <br />
   `rbenv init` <br />
   Follow the printed instructions.
5. Close your Terminal session and open a fresh new Terminal session so that the changes take effect.
6. Install Ruby 2.7.5: <br />
   `rbenv install 2.7.5`
7. Set Ruby 2.7.5 as the default version to be used whenever you open any new Terminal sessions: <br />
   `rbenv global 2.7.5`
8. Verify that Ruby 2.7.5 is the current Ruby version: <br />
   `ruby -v` <br />
   You should see something like this, though your exact patch number, date, and revision may be slight different: <br />
   `ruby 2.7.5p203 (2021-11-24 revision f69aeb8314) [x86_64-darwin18]`
10. Install rbenv-gemset, a gem management plugin for rbenv: <br />
    `brew install rbenv-gemset`
11. Create a specific gemset for reservation-api project: <br />
    `rbenv gemset create 2.7.5 reservation-api`
12. Install Rails 6.1.4: <br />
    `RBENV_GEMSETS="reservation-api" gem install rails -v 6.1.4 --no-document`
13. Make the rails executable available to Terminal sessions: <br />
    `rbenv rehash`
14. Verify that Rails 6.1.4 was successfully installed by typing: <br />
    `rails -v` <br />
    You should see something like the following, though your exact path number may be slightly different: <br />
    `Rails 6.1.4.4`
15. Navigate to SQLite installer [downloads page](https://sqlite.org/download.html) and click the installer below "Precompiled Binaries for Mac OS X".
16. Save the installer to your Desktop, for example, and then run the installer once it has finished downloading.

### Windows 10
1. Navigate to Ruby installer [downloads page](https://rubyinstaller.org/downloads/) and click the "Ruby+Devkit 2.7.5-1 (x64)" executable installer.
2. Save the installer to your Desktop, for example, and then run the installer once it has finished downloading.
3. Read the License Agreement, make sure "I accept the License" is selected, and click "Next".
4. Accept the default installation folder and make sure all optional tasks are checked, and then click "Install".
5. On the "Select Components" screen, make sure "Ruby-2.7.5 base files" and "MSYS2 development toollchain" are checked, click "Next" and Ruby will be installed in the `C:\Ruby27-x64` directory.
6. On the "Completing the Ruby 2.7.5-1-x64 with MSYS2 Setup Wizard" screen, make sure "Run 'ridk install' to setup MSYS2" is checked.
7. When you click "Finish", a new command window will open asking you which components of MSYS2 you want to install. Choose "1" which is the base MSYS2 installation.
8. It will proceed to install a bunch of stuff, and then return back to the prompt asking which components you want to install. You should see the message "MSYS2 seems to be properly installed. Go ahead and close that command window.
9. Open a new command prompt by selecting the Start menu, type `cmd` into the search box, and press Enter.
10. Verify that Ruby 2.7.5 was successfully installed by typing: <br />
    `ruby -v` <br />
    You should see something like this, though your exact patch number, date, and revision may be slight different: <br />
    `ruby 2.7.5p203 (2021-11-24 revision f69aeb8314) [x64-mingw32]` <br />
    If instead you see "Command not found", then you either need to open a _new_ command prompt and try again, or check that your `PATH` environmenti variable includes the `C:\Ruby27-x64\bin` directory.
13. Install Rails 6.1.4 by typing: <br />
    `gem install rails -v 6.1.4 --no-document`
14. Verity that Rails 6.1.4 was successfully installed by typing: <br />
    `rails -v` <br />
    You should see something like the following, though your exact path number may be slightly different: <br />
    `Rails 6.1.4.4`
15. Navigate to SQLite installer [downloads page](https://sqlite.org/download.html) and click an appropriate installer below "Precompiled Binaries for Windows".
16. Save the installer to your Desktop, for example, and then run the installer once it has finished downloading.

### Linux
1. Start by updating `apt-get` and installing the dependencies required for rbenv and Ruby: <br />
   `sudo apt-get update` <br >
   `sudo apt-get install git-core curl zlib1g-dev build-essential libssl-dev libreadline-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt1-dev libcurl4-openssl-dev software-properties-common libffi-dev`
2. Install rbenv:
  `sudo apt install rbenv`
3. Install Ruby 2.7.5: <br />
   `rbenv install 2.7.5`
4. Set Ruby 2.7.5 as the default version to be used whenever you open any new Terminal sessions: <br />
   `rbenv global 2.7.5`
5. Verify that Ruby 2.7.5 is the current Ruby version: <br />
   `ruby -v` <br />
   You should see something like this, though your exact patch number, date, and revision may be slight different: <br />
   `ruby 2.7.5p203 (2021-11-24 revision f69aeb8314) [x86_64-darwin18]`
6. Install rbenv-gemset, a gem management plugin for rbenv: <br />
   `sudo apt install rbenv-gemset`
7. Create a specific gemset for reservation-api project: <br />
   `rbenv gemset create 2.7.5 reservation-api`
8. Install Rails 6.1.4: <br />
   `RBENV_GEMSETS="reservation-api" gem install rails -v 6.1.4 --no-document`
9. Make the rails executable available to Terminal sessions: <br />
   `rbenv rehash`
10. Verify that Rails 6.1.4 was successfully installed by typing: <br />
    `rails -v` <br />
    You should see something like the following, though your exact path number may be slightly different: <br />
    `Rails 6.1.4.4`
11. Navigate to SQLite installer [downloads page](https://sqlite.org/download.html) and click the installer below "Precompiled Binaries for Linux".
12. Save the installer to your Desktop, for example, and then run the installer once it has finished downloading.

## Application Setup
1. Get the application source code using one of the following options:
   * Download a [ZIP file](https://github.com/waihon/reservation-api/archive/refs/heads/main.zip) from GitHub
   * Clone the source code repository via SSH: <br />
     `git clone git@github.com:waihon/reservation-api.git`
   * Clone the source code repository via HTTPS: <br />
     `git@github.com:waihon/reservation-api.git`
2. Open a Terminal/command prompt/shell session and navigate to `reservation-api` folder: <br />
   `cd reservation-api`
3. Install the gems and dependencies specified in the Gemfile:
   `bundle install`
4. Verify that the application is set up correctly:
   `bin/rails s`

## Database creation
1. Enter the following command to create development and test databases with database migration ran: <br />
   `bin/rails db:setup`

## Running test suite
1. Enter the following command to run the test suite:
   `bundle exec rspec`

### Running the application
1. Bring up the application server:
   `bin/rails s`

### Make API requests using CURL
1. Check the status of the API: <br />
   `curl http://localhost:3000`
2. Create or update a reservation using payload #1 <br />
   ```
   curl -i -X POST -H "Content-Type: application/json" -d '
    {
      "reservation_code": "YYY12345679",
      "start_date": "2021-04-20",
      "end_date": "2021-04-23",
      "nights": "3",
      "guests": 5,
      "adults": 3,
      "children": 1,
      "infants": 1,
      "status": "accepted",
      "guest": {
        "first_name": "Joe",
        "last_name": "Doe",
        "phone": "639123456789",
        "email": "joedoe@example.com"
      },
      "currency": "AUD",
      "payout_price": "4200.00",
      "security_price": "500",
      "total_price": "4700.00"
    }' http://localhost:3000/reservations
   ```
3. Create or update a reservation using payload #2 <br />

## Commands Ran During Development

### Project Setup

* `rails new reservation-api --api --skip-test`
* `rvm use 2.7.4@rails6.1 --ruby-version`

### Models

* `bin/rails g model guest`
* `bin/rails g model reservation`
* `bin/rails db:migrate`
* `bin/rails g controller reservations`
* `bin/rails g migration rename_fields_of_guests`
* `bin/rails g migration rename_fields_of_reservations`
* `bin/rails db:migrate`
* `bin/rails g migration rename_phone_of_guests`
* `bin/rails g migration add_localized_description_to_reservations`
* `bin/rails db:migrate`

### Testing

* `bin/rails g rspec:install`
* `mkdir spec/factories`
