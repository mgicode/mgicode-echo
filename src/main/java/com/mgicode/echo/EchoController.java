package com.mgicode.echo;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.client.RestTemplate;

/**
 * @author 彭仁夔
 * @email 546711211@qq.com
 * @time 2017/11/7 15:01
 */

@Controller
public class EchoController {

    @Autowired
    RestTemplate restTemplate;

    @ResponseBody
    @RequestMapping(value = "/")
    public String echo() {
        return "you have connect the server with http success!";
    }

    @ResponseBody
    @RequestMapping(value = "/consul/{service}")
    public String echoConsul(@PathVariable("service") String service) {
        String url = "http://" + service.trim() + "/";
        String ret = service+":"+(String) restTemplate.getForObject(url, String.class);
        return ret;
    }
}
