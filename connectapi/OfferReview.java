/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package connectapi;

import com.google.gson.Gson;

/**
 *
 * @author Mohamed Khalifa
 */
public class OfferReview {
    
    /*
        This Class handles the Offer Review Attributes
    */
    public OfferReview(String tenantEmail, boolean verifyState) {
        this.tenantEmail = tenantEmail;
        this.approved = verifyState;
    }
    
    public String tenantEmail;
    public boolean approved;
    
    /*
        Converts the Attributes to JSON
    */
    public String SendRequestToBlockchain() {
        Gson gson = new Gson();
        String s = gson.toJson(this);
        return s;
    }
}
