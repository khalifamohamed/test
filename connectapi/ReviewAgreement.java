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
public class ReviewAgreement {
    /*
        This Class handles the Review Agreement Attributes
    */
    public String tenantEmail;
    public boolean confirmed;

    public ReviewAgreement(String tenantEmail, boolean confirmed) {
        this.tenantEmail = tenantEmail;
        this.confirmed = confirmed;
    }
    /*
        Convert the Attributes to JSON
    */
    public String SendRequestToBlockchain() {
        Gson gson = new Gson();
        String s = gson.toJson(this);
        return s;
    }
    
}
