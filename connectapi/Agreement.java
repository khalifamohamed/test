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
public class Agreement {
    
    /*
        The Agreement Class that handles the data of the Agreement
    */
    public String tenantEmail;
    public String landlordName;
    public String agreementTenantName;
    public String agreementTenantEmail;
    public long leaseStart;
    public long handoverDate;
    public int leasePeriod;
    public String otherTerms;
    public String hash;

    public Agreement(String tenantEmail, String landlordName, String agreementTenantName, String agreementTenantEmail, Long leaseStart, Long handoverDate, int leasePeriod, String otherTerms, String hash) {
        this.tenantEmail = tenantEmail;
        this.landlordName = landlordName;
        this.agreementTenantName = agreementTenantName;
        this.agreementTenantEmail = agreementTenantEmail;
        this.leaseStart = leaseStart;
        this.handoverDate = handoverDate;
        this.leasePeriod = leasePeriod;
        this.otherTerms = otherTerms;
        this.hash = hash;
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
