package com.mgicode.echo;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

/**
 * @author 彭仁夔
 * @email 546711211@qq.com
 * @time 2017/11/7 15:01
 */

@Controller
public class EchoController {

    @ResponseBody
    @RequestMapping(value = "/")
    public String echo() {
        return "you have connect the server with http success!";
    }


}
