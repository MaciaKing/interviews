package com.example.demo;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.sql.*;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;

public class DataBaseFinal {

    private String url;
    private String usuario;
    private String password;
    private Connection conn;

    public DataBaseFinal(String url, String usuario, String password) {
        try {
            conn = DriverManager.getConnection(url, usuario, password);
            this.url = url;// = "jdbc:postgresql://localhost:5432/video";
            this.usuario = usuario;// = "macia";
            this.password = password;// = "macia";
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    /* 
     * This method is used to make a query to the database
     * 
     * The query is made with the connection that was created in the constructor.
     * The final result is a JSON string with the result of the query.
     * 
     * @param query The query to be made
     * @return A JSON string with the result of the query
     */
    public String makeQuery(String query) {
        List<Map<String, Object>> rows = new ArrayList<>(); // Final result
        try {
            java.sql.Statement st = conn.createStatement();
            ResultSet rs = st.executeQuery(query);
            while (rs.next()) {
                ResultSetMetaData metaData = rs.getMetaData();
                int columnCount = metaData.getColumnCount();
                while (rs.next()) {
                    Map<String, Object> row = new HashMap<>();
                    for (int i = 1; i <= columnCount; i++) {
                        String columnName = metaData.getColumnLabel(i);
                        Object value = rs.getObject(i);
                        row.put(columnName, value);
                    }
                    rows.add(row);
                }
            }
            ObjectMapper mapper = new ObjectMapper();
            return mapper.writeValueAsString(rows);

        } catch (SQLException e) {
            e.printStackTrace();
            return "Error";
        } catch (JsonProcessingException e) {
            e.printStackTrace();
            return "Error";
        }
    }


}
