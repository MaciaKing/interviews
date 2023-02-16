package com.example.demo;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class Controller {

    private DataBaseFinal db;

    @Autowired
    public Controller() {
        db = new DataBaseFinal("jdbc:postgresql://localhost:5432/video", "macia", "macia");
    }

    /*
     * View all the films on the database.
     *  
     * @return A JSON string with all the films on the database.
     */
    @RequestMapping("/invent")
    public String viewInvent() {
        return db.makeQuery("SELECT * FROM Film");
    }

    /*
     * Make a query to the database and return the prices of the rentals.
     * 
     * @return A JSON string with the prices of the rentals.
     */
    @RequestMapping("/price_rental")
    public String price_rental() {
        String string_result_json = db.makeQuery(
                "SELECT Film.name, Film.name_type, Time.n_rented_days, Time.n_extra_days, Type_of_film.normal_price, Type_of_film.price_extra_day FROM Rent JOIN TIME ON Rent.idRent=Time.idRent JOIN Film ON Time.idFilm=Film.idFilm JOIN Type_of_film ON Film.name_type=Type_of_film.name_type ORDER BY Time.n_rented_days DESC;");
        Functions f = new Functions();
        return f.calculatePrice(string_result_json);
    }

}
