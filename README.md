# SCU CourseAvail CLI
Created by Javier Ramirez, Gabby Quintana
## Getting Started
The two files must be in the same directory. Just run courses.sh to begin.
Dependencies include the following:
* Python 3.7+
  * Requests module (to request HTTP content)
  * Pandas module (to read, clean, export data to CSV)
  
## Introduction
### Need Statement
It’s the new school year and students are preparing to register for
classes for the next quarter. They want a bash application that will
allow them to search for courses that meet specific requirements with
ease through their own personal directory instead of using CourseAvail
online or scuclasses.com. The bash application should allow each student
to continuously search through the available classes (and associated
metadata, such as professor name, location, etc.) by inputting regular
expressions or matching certain criteria with the classes on file.

### Functionality
In this system, students enter the program and are prompted to enter a
search filter to find more information about the classes being offered.
They are able to search through all of the classes available for the
corresponding quarter and can search by department, course number, class
session, class title, time, class location, instructors, and the number
of seats available in the class.

## Functionalities Implemented
### Scraping Class Data with Python
In order to access the updated and extended list of class being offered
for the upcoming quarter, we utilized a Python script
(“get-classes.py”_)_ to scrape SCU’s website and output the data into a
CSV file. This script, which runs continually, uses the requests module
to access the Internet, the Pandas module to read, clean, and export the
data to a CSV, and the time module to allow for sleep. The Python script
runs every 20 seconds to keep the class data refreshed. Its process is
terminated when the user exits or issues a SIGINT signal by pressing
Ctrl+C.

### Working with a CSV
Since we were working with a CSV file, it was necessary to format the
columns more uniformly. In the original data, some column names are
enclosed in quotes. While at first, we encountered some difficulties in
parsing the file, changing the file delimiter (specified in the Python
script) from a comma to a tab helped us avoid these issues.

### Structure
To allow the user to input certain filters and regular expressions, we
implemented looping and conditional statements. First, the
implementation of the while loop allowed for the user to continuously
search through the file of classes by matching their inputs with the
filters. Within the while loop, we used conditional expressions to
perform certain actions. Through these constructs, the experience is
fairly seamless for the user because if they accidentally input
something that does not match the filter properly, it is likely that
their search will still be usable for a regular expression search, which
the final else statement allows for.

### Searching Data & User Output
Each time a user inputs a search filter, we pipe the output of cat into
a grep command. Inside of this command, we use the desired filter and
inputted text (stored in a variable) to search for lines that contain
the desired results. Finally, we pipe this output into a function that
uses awk to format the lines correctly from CSV format into standard
columns. We specify the length that seach column should be ahead of
time, which gives us predictable column output most of the time.

Initially, we used awk instead of grep to perform searches, but we don’t
believe the command was reading our columns correctly. For instance,
when we specified $3, we don’t believe awk was able to find the third
column; we believe this may have occured because we generated the
columns ourselves using printf and spaces.
