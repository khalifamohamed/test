/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package connectapi;

/**
 *
 * @author Mohamed Khalifa
 */
import com.sun.corba.se.impl.orbutil.ObjectWriter;
import java.io.StringWriter;
import com.google.gson.*;

/**
 *
 * @author Mohamed Khalifa
 */
public class Offer {
    
    /*
        The Offer Class that handles the data of the Offer
    */
    public String tenantName;
    public String tenantEmail;
    public int amount;

    public Offer(String tenantName, String tenantEmail, int amount) {
        this.tenantName = tenantName;
        this.amount = amount;
        this.tenantEmail = tenantEmail;

    }


    /*Converts the Attributes to JSON*/
    public String SendRequestToBlockchain() {
        Gson gson = new Gson();
        String s = gson.toJson(this);
        return s;
    }
    
}

