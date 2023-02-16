# interviews
For this mini project, I used Spring-boot and postgres database.
Java version used: java version "19".
For connect the java and the postgrees I have used JDBC driver.

For this interview I have only solved the problems 
  - 1.- Have an Inventory of Films.
  - 2.- Calculate the price for rentals.

## Database
The UML model is this. 

![DatabaseUML](https://user-images.githubusercontent.com/51322831/219332450-63564cc6-989b-46ff-980e-2901ed0a4b99.png)

Inside the "DatabaseCreation" directory, a file will be located that will execute a script to initialize the database, load test data and create a user with access to the database for use in the application.
In addition, in the same directory you will find a stored procedure and an event in PostgreSQL. The event will be programmed to automatically update the days of delay in the rental of a movie.

## Java
The classes that I have made are in this directory "demo/src/main/java/com/example/demo/".
  - 1. Controller.java. This class is used for control the petitions of the API.
  - 2. DataBaseFinal.java. This class if for connect the postgrees with Java.
  - 3. Functions.java. This class contains all the functions necessary to calculate the price of a rent.

## Results
View the response of the API.

View the inventory: 
<img width="1507" alt="Demostacion_Funcionamiento" src="https://user-images.githubusercontent.com/51322831/219338842-68037f7d-d6a8-4cee-872f-66ea1610baa4.png">

View the prices:
<img width="1497" alt="Demostracion_Funcionamiento_2" src="https://user-images.githubusercontent.com/51322831/219342545-8f536b46-69ea-4844-9972-6ea05b0f8a7d.png">

The prices don't work at all.

