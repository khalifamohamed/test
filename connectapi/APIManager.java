/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package connectapi;

import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.URL;
import javax.swing.JOptionPane;
import org.apache.http.HttpResponse;
import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.CloseableHttpResponse;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.entity.StringEntity;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.HttpClientBuilder;
import org.apache.http.impl.client.HttpClients;
import org.apache.http.util.EntityUtils;






/**
 *
 * @author Mohamed Khalifa
 */
public class APIManager {
            /*
                Creates a public connection with the API and a buffered Reader Object to get the response
            */
        public static String sendRequest(String requestType, String body) {
        HttpClient httpClient = HttpClientBuilder.create().build(); 

        try {
            HttpPost request = new HttpPost("http://localhost:8080/" + requestType);
            StringEntity params = new StringEntity(body);
            request.addHeader("content-type", "application/json");
            request.setEntity(params);
            HttpResponse response = httpClient.execute(request);
            InputStream inputStream = response.getEntity().getContent();
            InputStreamReader inputStreamReader = new InputStreamReader(inputStream);
            BufferedReader bufferedReader = new BufferedReader(inputStreamReader);
            StringBuilder stringBuilder = new StringBuilder();
            String bufferedStrChunk = null;
            while((bufferedStrChunk = bufferedReader.readLine()) != null){
            stringBuilder.append(bufferedStrChunk);
            }
            request.abort();
            return stringBuilder.toString();
            //handle response here...
        } catch (Exception ex) {

            //handle exception here
            JOptionPane.showMessageDialog(null, "Couldn't find connection");
        }
        return "";
    }
        public static String getResponse(String responseType)throws Exception
        {
            String result = "";
            try{
                CloseableHttpClient httpclient = HttpClients.createDefault();
		HttpGet response = new HttpGet("http://localhost:8080/" + responseType);
		CloseableHttpResponse jsonResponse = httpclient.execute(response);
                try {
			result = EntityUtils.toString(jsonResponse.getEntity());
		} finally {
			jsonResponse.close();
		}
            }
            catch(Exception e){
                JOptionPane.showMessageDialog(null, "Couldn't Get Response");
            }
            return result;
        }
}
