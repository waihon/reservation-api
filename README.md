# README

This README documents the software, tools, and steps that are necessary to get the Reservation API up and running.

Since GitHub doesn't support opening a link in a new tab, you may command+click (on macOS) or ctrl+click (on Windows and Linux) a link in this README to get the same behavior.

## Ruby
* Ruby [2.7.5](https://www.ruby-lang.org/en/news/2021/11/24/ruby-2-7-5-released/)
* Ruby version manager: [rbenv](https://github.com/rbenv/rbenv)
* Ruby gem management: [rbenv-gemset](https://github.com/jf/rbenv-gemset)

## System dependencies
* Rails [6.1.4](https://rubyonrails.org/2021/6/24/Rails-6-1-4-has-been-released)
* SQLite [3](https://sqlite.org/version3.html)

## Installation
* Go to [macOS](#macos) section
* Go to [Windows 10](#windows-10) section
* Go to [Linux](#linux) section

### <a name="macos">*macOS*</a>
1. Open a new Terminal session (Application -> Utilities):
#### Homebrew
2. Install [Homebrew](https://brew.sh/), a package manager for macOS:
   ```
   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
   ```
   If you're asked about installing Apple's Command Line Tools for Xcode, go ahead and answer "yes".
#### rbenv
3. Install rbenv, a Ruby version manager:
   ```
   brew install rbenv
   ```
4. Set up rbenv by running the following command:
   ```
   rbenv init
   ```
   Follow the printed instructions.
5. Close your Terminal session and open a fresh new Terminal session so that the changes take effect.
#### Ruby
6. Install Ruby 2.7.5:
   ```
   rbenv install 2.7.5
   ```
7. Set Ruby 2.7.5 as the default version to be used whenever you open any new Terminal sessions:
   ```
   rbenv global 2.7.5
   ```
8. Verify that Ruby 2.7.5 is the current Ruby version:
   ```
   ruby -v
   ```
   You should see something like the following, though your exact patch number, date, and revision may be slightly different:
   ```
   ruby 2.7.5p203 (2021-11-24 revision f69aeb8314) [x86_64-darwin18]
   ```
#### rbenv-gemset
10. Install rbenv-gemset, a gem management plugin for rbenv:
    ```
    brew install rbenv-gemset
    ```
11. Create a gemset for the reservation-api project:
    ```
    rbenv gemset create 2.7.5 reservation-api
    ```
#### Rails
12. Install Rails 6.1.4 to the project gemset:
    ```
    RBENV_GEMSETS="reservation-api" gem install rails -v 6.1.4 --no-document
    ```
13. Make the rails executable available to Terminal sessions:
    ```
    rbenv rehash
    ```
#### SQLite
14. SQLite is included in macOS by default. It is located in the `/usr/bin` directory and called `sqlite3`. To access a command line interface for SQLite:
    ```
    sqlite3
    ```
15. If you need a more recent version of SQLite than that provided by macOS:
    ```
    brew install sqlite
    ```

16. Proceed to the [next section](#remaining-sections).

### <a name="windows-10">*Windows 10*</a>
#### Ruby
1. Navigate to Ruby installer [downloads page](https://rubyinstaller.org/downloads/) and click the "Ruby+Devkit 2.7.5-1 (x64)" executable installer.
2. Save the installer to the Downloads folder, for example, and then run the installer once it has finished downloading.
3. Read the License Agreement, make sure "I accept the License" is selected, and click "Next".
4. Accept the default installation folder and make sure all optional tasks are checked, and then click "Install".
5. On the "Select Components" screen, make sure the following are checked:
   * Ruby-2.7.5 base files
   * Ruby RI and HTML documentation
   * MSYS2 development toollchain 2021-11-27
6. Click "Next" and Ruby will be installed into `C:\Ruby27-x64` directory and MSYS2 will be installed into `C:\Ruby27-x64\msys64` directory.
7. On the "Completing the Ruby 2.7.5-1-x64 with MSYS2 Setup Wizard" screen, make sure "Run 'ridk install' to setup MSYS2 and development toolchain" is checked.
8. When you click "Finish", a new Command Prompt window will open asking you which components of MSYS2 you want to install. Choose "1" which is the base MSYS2 installation.
9. It will proceed to install a bunch of stuff, and then return back to the prompt asking which components you want to install. You should see the message "MSYS2 seems to be properly installed. Go ahead and close that command window.
10.  Open a new Command Prompt window by selecting the Start menu, type `cmd` into the search box, and press Enter.
11. Verify that Ruby 2.7.5 was successfully installed by typing:
    ```
    ruby -v
    ```
    You should see something like the following, though your exact patch number, date, and revision may be slight different:
    ```
    ruby 2.7.5p203 (2021-11-24 revision f69aeb8314) [x64-mingw32]
    ```
    If instead you see "Command not found", then you either need to open a _new_ command prompt and try again, or check that your `PATH` environmenti variable includes the `C:\Ruby27-x64\bin` directory.
#### Rails
12. Install Rails 6.1.4 by typing:
    ```
    gem install rails -v 6.1.4 --no-document
    ```
13. Verity that Rails 6.1.4 was successfully installed by typing:
    ```
    rails -v
    ```
    You should see something like the following, though your exact path number may be slightly different:
    ```
    Rails 6.1.4.4
    ```
#### SQLite
14. SQLite is not included in Windows 10 by default. To install, navigate to SQLite installer [downloads page](https://sqlite.org/download.html) and click "sqlite-tools-win32-x86-3370100.zip" under "Precompiled Binaries for Windows" section.
15. Create a folder called `C:\sqlite`.
17. Copy the files from the downloaded zip into `C:\sqlite`.
18. Add `C:\sqlite` to the PATH on Windows 10.
19. To access a command line interface for SQLite, enter the following in a Command Prompt window:
    ```
    sqlite3
    ```

20.  Proceed to the [next section](#remaining-sections).

### <a name="linux">*Linux*</a>
1. Start by updating `apt-get` and installing the dependencies required for rbenv and Ruby:
   ```
   sudo apt-get update
   ```
   ```
   sudo apt-get install git-core curl zlib1g-dev build-essential libssl-dev libreadline-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt1-dev libcurl4-openssl-dev software-properties-common libffi-dev
   ```
#### rbenv
2. Install rbenv, a Ruby version manager:
   ```
   sudo apt install rbenv
   ```
#### Ruby
3. Install Ruby 2.7.5:
   ```
   rbenv install 2.7.5
   ```
4. Set Ruby 2.7.5 as the default version to be used whenever you open any new Terminal sessions:
   ```
   rbenv global 2.7.5
   ```
5. Verify that Ruby 2.7.5 is the current Ruby version:
   ```
   ruby -v
   ```
   You should see something like this, though your exact patch number, date, and revision may be slight different:
   ```
   ruby 2.7.5p203 (2021-11-24 revision f69aeb8314) [x86_64-linux]
   ```
#### rbenv-gemset
6. Install rbenv-gemset, a gem management plugin for rbenv:
   ```
   sudo apt install rbenv-gemset
   ```
7. Create a gemset for reservation-api project:
   ```
   rbenv gemset create 2.7.5 reservation-api
   ```
#### Rails
8. Install Rails 6.1.4 to the project gemset:
   ```
   RBENV_GEMSETS="reservation-api" gem install rails -v 6.1.4 --no-document
   ```
9. Make the rails executable available to Terminal sessions:
   ```
   rbenv rehash
   ```
#### SQLite
11. SQLite command line interface has been installed as part of step 1.

<a name="remaining-sections">After</a> installing the necessary software and tools for your operationg system, you may proceed to the remaining sections of the document.

## <a name="application-setup">Application Setup</a>
1. Get the application source code using one of the following options:
   * Download a [ZIP file](https://github.com/waihon/reservation-api/archive/refs/heads/main.zip) from GitHub, and rename the extracted folder from `reservation-api-main`, for example, to `reservation-api`.
   * Clone the source code repository via SSH:
     ```
     git clone git@github.com:waihon/reservation-api.git
     ```
   * Clone the source code repository via HTTPS:
     ```
     git clone https://github.com/waihon/reservation-api.git
     ```
2. Open a Terminal/command prompt/shell session and navigate to `reservation-api` folder:
   ```
   cd reservation-api
   ```
3. Install the gems and dependencies specified in the Gemfile:
   ```
   bundle install
   ```
4. Verify that Rails 6.1.4 was successfully installed by typing:
    ```
    rails -v
    ```
    You` should see something like the following, though your exact path number may be slightly different:
    ```
    Rails 6.1.4.4
    ```

## Database creation
1. Enter the following command to create development and test databases with database migration automatically ran:
   ```
   rails db:setup
   ```

## Running test suite
1. Enter one of the following commands to run the test suite:
   ```
   bundle exec rspec
   ```
   ```
   bundle exec rspec --format progress
   ```
   ```
   bundle exec rspec --format documentation
   ```

## Running the application
1. Open a Terminal/Command Prompt/shell session.
2. Bring up the application server:
   ```
   rails s
   ```
3. Open a web browser and enter the following URL:
   ```
   http://localhost:3000/
   ```
   You should see something like the following:
   ```
   {"status":"ok"}
   ```

## Making API requests
We can make or test API requests using API clients such as one of the following:
* [cURL](https://curl.se/download.html) (a command line tool for testing API)
* [Postman](https://www.postman.com/downloads/) (an app for testing API)
* [HTTPie](https://httpie.io/cli) (a command line tool for testing API)

### Examples of API requests made using cURL
1. Check the status of the API: <br />
   ```
   curl http://localhost:3000
   ```
2. Create or update a reservation using payload #1: <br />
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
   When a new reservation is created, the API endpoint returns HTTP status 201 (Created) while HTTP status 200 (OK) is returned when an existing reservation is updated.
3. Create or update a reservation using payload #2: <br />
   ```
   curl -i -X POST -H "Content-Type: application/json" -d '
     {
       "reservation": {
         "code": "XXX12345678",
         "start_date": "2021-03-12",
         "end_date": "2021-03-16",
         "expected_payout_amount": "3800.00",
         "guest_details": {
           "localized_description": "4 guests",
           "number_of_adults": 2,
           "number_of_children": 2,
           "number_of_infants": 0
         },
         "guest_email": "maryjane@example.com",
         "guest_first_name": "Mary",
         "guest_last_name": "Jane",
         "guest_phone_numbers": [
           "639123456789",
           "639123456789"
         ],
         "listing_security_price_accurate": "500.00",
         "host_currency": "AUD",
         "nights": 4,
         "number_of_guests": 4,
         "status_type": "accepted",
         "total_paid_amount_accurate": "4300.00"
       }
     }' http://localhost:3000/reservations
   ```
   When a new reservation is created, the API endpoint returns HTTP status 201 (Created) while HTTP status 200 (OK) is returned when an existing reservation is updated.
