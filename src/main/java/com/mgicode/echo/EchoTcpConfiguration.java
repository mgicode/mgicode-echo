package com.mgicode.echo;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;

import javax.annotation.PostConstruct;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.net.ServerSocket;
import java.net.Socket;

/**
 * @author 彭仁夔
 * @email 546711211@qq.com
 * @time 2017/11/15 21:40
 */
@Configuration
public class EchoTcpConfiguration {

    @Value("${tcp.port=:8081}")
    int tcpPort;

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

}








