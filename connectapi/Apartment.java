/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package connectapi;

import com.sun.corba.se.impl.orbutil.ObjectWriter;
import java.io.StringWriter;
import com.google.gson.*;
import com.google.gson.annotations.JsonAdapter;

/**
 *
 * @author Mohamed Khalifa
 */
public class Apartment {

    /*
        The Apartment Class that handles the data of the Apartment
    */
  public String name;
    public String landlordName;
    public String streetName;
    public String floor;
    public String apartment;
    public String house;
    public String zipCode;
    public String latitude;
    public String longitude;

    public Apartment(String landlordName, String streetName, String floor, String apartment, String house, String zipCode, String latitude, String longitude) {
        this.landlordName = landlordName;
        this.streetName = streetName;
        this.floor = floor;
        this.apartment = apartment;
        this.house = house;
        this.zipCode = zipCode;
        this.latitude = latitude;
        this.longitude = longitude;
    }
        /*
            Converts the Attributes to JSON
        */
    public String SendRequestToBlockchain() {
        Gson gson = new Gson();
        String s = gson.toJson(this);
        return s;
    }
    
}
