
# MVC
model-view-controller
![在这里插入图片描述](https://i-blog.csdnimg.cn/direct/26ab2d83e1d742c589aa8f032d6543ef.png)
# Controller和RestController
## Controller
+ 适合**前后端不分离**
+ 返回**数据+视图(html)**
![在这里插入图片描述](https://i-blog.csdnimg.cn/direct/780e5993385a404da27c4a1d9ec65271.png)
## RestController
![在这里插入图片描述](https://i-blog.csdnimg.cn/direct/5c0cadb9d5c744b783c0fc9212172479.png)

##  RequestMapping
![在这里插入图片描述](https://i-blog.csdnimg.cn/direct/8660039f8db449ef9874cbb6f11b0ecd.png)
![在这里插入图片描述](https://i-blog.csdnimg.cn/direct/315fe83b74d34212ad07d2fe789c23ba.png)


![在这里插入图片描述](https://i-blog.csdnimg.cn/direct/4ea5ca12145c422cb241d11ae22c3ca6.png)
+ 可以直接传入自定义类,但是**参数名称和顺序必须完全一致**

```java
	@RequestMapping(value="/test1",method= RequestMethod.GET)
    public String test1(User user){
        System.out.println(user.getUsername());
        System.out.println(user.getPassword());
        return "hello world!";
    }
```
+ 支持传入的参数与控制器接受的参数名称不一致，但需要RequestParam注解
```java 
    @RequestMapping(value="/test2",method= RequestMethod.GET)
    public String test2(@RequestParam(value="username",required = false) String nickname,
                        @RequestParam(value="password",required = false)String ciphertext){
        System.out.println(nickname);
        System.out.println(ciphertext);
        return "Get请求!";
    }
```
+ 两个通配符表示/之后所有内容都能识别
```java
@RequestMapping(value="/test3/**",method= RequestMethod.GET)
    public String test3(String username,String password){
        System.out.println(username);
        System.out.println(password);
        return "Get请求!";
    }
```
+ **放在url里面还是body里面都能识别参数**
```java
@RequestMapping(value="/test4",method= RequestMethod.POST)
    public String test4(String username,String password){
        System.out.println(username);
        System.out.println(password);
        return "Get请求!";
    }
```
+ json格式的POST请求,**使用RequestBody注解包裹**
```java
    @RequestMapping(value="/test5",method= RequestMethod.POST)
    public String test5(@RequestBody  User user){
        System.out.println(user.getUsername());
        System.out.println(user.getPassword());
        return "Get请求!";
    }
```


![在这里插入图片描述](https://i-blog.csdnimg.cn/direct/fb2e2367b8824bba959dfaa346f6202b.png)


![在这里插入图片描述](https://i-blog.csdnimg.cn/direct/1022818aaac44056a37f14f8f8966cb7.png)
+ 配置文件:继承WebMvcConfigurer ，使用Configuration注释
`src/java/config/WebConfig.java`
```java
@Configuration
public class WebConfig implements WebMvcConfigurer {
    @Override
    public void addInterceptors(InterceptorRegistry registry) {
        registry.addInterceptor(new LoginInterceptor());
    }
}
```

+ 配置拦截器，继承HandlerInterceptor。
```java
public class LoginInterceptor implements HandlerInterceptor {
    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        System.out.println("拦截成功!");
        return true;
    }

}
```


# RESTful API
![在这里插入图片描述](https://i-blog.csdnimg.cn/direct/d518dd59a25f4d0e9037a227f75cea37.png)

![在这里插入图片描述](https://i-blog.csdnimg.cn/direct/b9ab6671e12e4e9696112782769e511f.png)



![在这里插入图片描述](https://i-blog.csdnimg.cn/direct/df5436be022a4cf28c633aaa8d4b4904.png)
![在这里插入图片描述](https://i-blog.csdnimg.cn/direct/657586bc15e94f919b51501e901245af.png)

