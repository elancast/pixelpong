import java.io.*;
import java.net.*;
class TestConnection extends LXPattern {

    public TestConnection(HeronLX lx) {
        super(lx);
    }

    private String getThings() {
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
            return sb.toString();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (connection != null) {
                connection.disconnect();
            }
        }
        return null;
    }

    public void run(int deltaMs) {
        String time = getThings();
        System.out.println(deltaMs + " " + time);
        int value = time.hashCode() % 256;

        clearColors();
        color c = color(random(0, 255), random(0, 255), random(0, 255));
        c = color(value, value, value);
        for (int i = 0; i < lx.total; ++i) {
            addColor(i, c);
        }
    }


}