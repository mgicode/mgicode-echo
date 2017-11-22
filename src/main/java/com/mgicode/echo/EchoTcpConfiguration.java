package com.mgicode.echo;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.cloud.client.ServiceInstance;
import org.springframework.cloud.client.loadbalancer.LoadBalanced;
import org.springframework.cloud.client.loadbalancer.LoadBalancerClient;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.client.RestTemplate;

import javax.annotation.PostConstruct;
import java.io.*;
import java.net.ServerSocket;
import java.net.Socket;
import java.net.SocketTimeoutException;
import java.net.URI;

/**
 * @author 彭仁夔
 * @email 546711211@qq.com
 * @time 2017/11/15 21:40
 */
@Configuration
public class EchoTcpConfiguration {

    @Value("${tcp.port=:8081}")
    int tcpPort;


    @Autowired
    private LoadBalancerClient loadBalancer;

    @PostConstruct
    public void init() throws IOException {

        new Thread((Runnable) () -> {
            try {
                ServerSocket ss = new ServerSocket(tcpPort);
                System.out.println("监听" + tcpPort + "端口...");
                Socket socket = null;
                BufferedReader in;
                PrintWriter out;

                while (true) {
                    socket = ss.accept();
                    in = new BufferedReader(new InputStreamReader(socket.getInputStream()));
                    out = new PrintWriter(socket.getOutputStream(), true);
                    String line = in.readLine();
                    if (line != null && line.startsWith("consul")) {
                        String name = line.substring(7);
                        out.println("you input is :" + name + "," + consulReq(name));
                    }
                    out.println("you input is :" + line);
                    out.close();
                    in.close();
                    socket.close();
                }
            } catch (Exception e) {
                e.printStackTrace();
                System.out.println(e.getMessage());
            }
        }).start();


    }


    public String consulReq(String serviceName) {
        try {

            ServiceInstance instance = loadBalancer.choose(serviceName);
            //URI storesUri = URI.create(String.format("http://%s:%s", instance.getHost(), instance.getPort()));

           // Socket client = new Socket(instance.getHost(), instance.getPort());

            Socket client = new Socket(instance.getHost(),tcpPort);
            client.setSoTimeout(10000);
            //获取键盘输入
            //BufferedReader input = new BufferedReader(new InputStreamReader(System.in));
            //获取Socket的输出流，用来发送数据到服务端
            PrintStream out = new PrintStream(client.getOutputStream());
            //获取Socket的输入流，用来接收从服务端发送过来的数据
            BufferedReader buf = new BufferedReader(new InputStreamReader(client.getInputStream()));
            boolean flag = true;
            while (flag) {
                System.out.print("输入信息：");
                String str = serviceName + " request";//input.readLine();
                //发送数据到服务端
                out.println(str);
                try {
                    //从服务器端接收数据有个时间限制（系统自设，也可以自己设置），超过了这个时间，便会抛出该异常
                    String echo = buf.readLine();
                    System.out.println(echo);
                    return echo;
                } catch (SocketTimeoutException e) {
                    System.out.println("Time out, No response");
                }

                return str;
            }

            //  input.close();

            if (client != null) {
                //如果构造函数建立起了连接，则关闭套接字，如果没有建立起连接，自然不用关闭
                client.close(); //只关闭socket，其关联的输入输出流也会被关闭
            }
        } catch (IOException e) {
            e.printStackTrace();
        }

        return null;
    }

    @Bean
    @LoadBalanced
    public RestTemplate restTemplate() {
        return new RestTemplate();
    }

}








