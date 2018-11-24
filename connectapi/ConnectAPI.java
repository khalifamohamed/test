/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package connectapi;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.net.MalformedURLException;
import java.net.URL;
import java.net.URLConnection;
/**
 *
 * @author Mohamed Khalifa
 */
public class ConnectAPI {

 /**
  * show the GUI Menu
  */
 public static void main(String[] args) throws Exception {
        home h = new home();
        h.setVisible(true);
    }
}