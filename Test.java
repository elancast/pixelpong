import java.io.*;
import java.net.*;

class Test {
    public static void main(String[] args) {
        URL url;
        HttpURLConnection connection = null;  
        try {
            url = new URL("http://www.timeapi.org/utc/now");
            connection = (HttpURLConnection)url.openConnection();
            connection.setRequestMethod("GET");

            InputStream is = connection.getInputStream();
            BufferedReader rd = new BufferedReader(new InputStreamReader(is));
            String line;
            StringBuilder sb = new StringBuilder(); 
            while((line = rd.readLine()) != null) {
                sb.append(line);
                sb.append('\n');
            }
            rd.close();
            System.out.println(sb.toString());
        } catch (Exception e) {
            e.printStackTrace();
        }


        System.out.println("test");
    }
}
