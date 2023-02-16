# interviews
For this mini project, I used Spring-boot and a postgres database.
Java version used: java version "19".

## Database
The UML model is this. 

![DatabaseUML](https://user-images.githubusercontent.com/51322831/219332450-63564cc6-989b-46ff-980e-2901ed0a4b99.png)

Inside the "DatabaseCreation" directory, a file will be located that will execute a script to initialize the database, load test data and create a user with access to the database for use in the application.
In addition, in the same directory you will find a stored procedure and an event in PostgreSQL. The event will be programmed to automatically update the days of delay in the rental of a movie.

