package com.example.demo;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;

public class Functions {

    public Functions() {
    }
    
    /*
     * Calculate the price of the rental
     * 
     * @param string_result_json A JSON string with the result of the query.
     * @return A string with the price of the rental.
     */
    public String calculatePrice(String string_result_json) {
        try {
            ObjectMapper objectMapper = new ObjectMapper();
            JsonNode jsonNode = objectMapper.readTree(string_result_json);
            String sol = "";
            if (jsonNode.isArray()) {
                for (JsonNode film : jsonNode) {
                    // Extract the values for each film object
                    String name = film.get("name").asText();
                    String name_type = film.get("name_type").asText();
                    int n_rented_days = film.get("n_rented_days").asInt();
                    int n_extra_days = film.get("n_extra_days").asInt();
                    int normal_price = film.get("normal_price").asInt();
                    int price_extra_day = film.get("price_extra_day").asInt();
                    int price = -1;

                    // Calculate the price
                    if (name_type.equals("new release")) {
                        // Price is <premium price> * rented days
                        price = n_rented_days * n_extra_days * 40;
                    } else if (name_type.equals("regular films")) {
                        // Price is <basic price> for the first 3 days, and then (<basic price> *
                        // (n_extra_days + n_rented_days )) /3
                        if (n_extra_days == 0) {
                            // (<basic price> * (n_extra_days + n_rented_days )) /3
                            price = normal_price * n_rented_days;
                            price = price + (n_extra_days + n_rented_days) * normal_price / 3;
                        } else {
                            price = normal_price * n_rented_days;
                        }
                    } else if (name_type.equals("old film")) {
                        // Price is <basic price> for the first 5 days, and then (<basic price> *
                        // (n_extra_days + n_rented_days )) /5
                        if (n_extra_days == 0) {
                            // (<basic price> * (n_extra_days + n_rented_days )) /5
                            price = normal_price * n_rented_days;
                            price = (n_extra_days + n_rented_days) * normal_price / 5 + price;
                        } else {
                            price = normal_price * n_rented_days;
                        }
                    }
                    sol += name + " (" + name_type + ") " + (n_rented_days + n_extra_days) + " days: " + price
                            + " EUR -----\n ∫";
                }
                return sol;
            } else {
                System.out.println("El objeto JSON no es un array.");
                return "Error";
            }

        } catch (JsonProcessingException e) {
            e.printStackTrace();
            return "Error";
        }

    }
    
}
