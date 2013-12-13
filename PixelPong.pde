import java.io.*;
import java.net.*;
class PixelPong extends LXPattern {
    private NetworkThread thread;

    public PixelPong(HeronLX lx) {
        super(lx);
        thread = new NetworkThread();
        thread.start();
    }

    public void run(int deltaMs) {
        clearColors();
        color c = this.thread.getLastPixelPongState().getColor();
        for (int i = 0; i < lx.total; ++i) {
            addColor(i, c);
        }
    }

    private class PixelPongState {
        private int[] colors;
        private int index;

        public PixelPongState() {
            this.colors = new int[]{0, 0, 0};
            this.index = 0;
        }

        public void addColorPart(int colorPart) {
            this.colors[index++] = colorPart;
        }

        public color getColor() {
            return color(this.colors[0], this.colors[1], this.colors[2]);
        }
    }

    private class NetworkThread extends Thread {
        private final String URL = "http://www.elancaster.sb.facebook.com/pixelpong/state?gross_response=1";
        private volatile PixelPongState lastPixelPongState = new PixelPongState();

        public void run() {
            while (true) {
                this.lastPixelPongState = this.getFromServer();
            }
        }

        public synchronized PixelPongState getLastPixelPongState() {
            return lastPixelPongState;
        }

        private PixelPongState getFromServer() {
            URL url;
            HttpURLConnection connection = null;  
            PixelPongState state = new PixelPongState();
            try {
                // TODO: Parse this!
                url = new URL(URL);
                connection = (HttpURLConnection)url.openConnection();
                connection.setRequestMethod("GET");

                InputStream is = connection.getInputStream();
                BufferedReader rd = new BufferedReader(new InputStreamReader(is));
                String line;
                StringBuilder sb = new StringBuilder(); 
                while((line = rd.readLine()) != null) {
                    int colorPart = Integer.parseInt(line);
                    state.addColorPart(colorPart);
                }
                rd.close();
            } catch (Exception e) {
                e.printStackTrace();
            } finally {
                if (connection != null) {
                    connection.disconnect();
                }
            }
            return state;
        }
    }
}