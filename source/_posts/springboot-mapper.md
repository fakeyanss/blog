---
title: springboot的Mapper与数据库表字段映射
tags:
  - springboot
  - ResultMap
date: 2018-03-13 09:35:32
---
本文讲述Spring Boot如何通过mybatis-spring-boot-starter集成Mybatis，并且在Mapper中如何映射Model属性和表的字段。

<!-- more -->

---

下面给出一个简单的示例。

## pom.xml
首先要引入mybatis的依赖
```xml
<dependency>
    <groupId>org.mybatis.spring.boot</groupId>
    <artifactId>mybatis-spring-boot-starter</artifactId>
    <version>1.1.1</version>
</dependency>
```

## table_user
数据库建表
```sql
CREATE TABLE IF NOT EXISTS `tb_user`(
    `id` INT(11) NOT NULL,
    `name` VARCHAR(100) NOT NULL,
    `created_by` VARCHAR(100) NOT NULL,
    PRIMARY KEY ( `id` )
)ENGINE=InnoDB DEFAULT CHARSET=utf8;
```

## User
实体类
```java
public class User {

    private Integer id;
    private String name;
    private String createdBy;
    //省略了setters & getters

}
```

## UserMapper
Mapper接口中可以通过注解的形式直接写sql，比将sql分离到xml中的方式更方便
```java
@Mapper
public interface UserMapper {

    @Select("select * from tb_user where id = #{id}")
    User selectById(@Param("id") int id);

    @Select("select * from tb_user")
    List<User> selectAll();
    
    @Insert("insert into tb_user(id, name, created_by) values(#{id}, #{name}, #{createdBy})")
    @Results(id = "user", 
             value = {
                        @Result(column = "id",property = "id"),
                        @Result(column = "name",property = "name"),
                        @Result(column = "created_by",property = "createdBy")
             }
    )
    //@Options(useGeneratedKeys = true, keyProperty = "id", keyColumn = "id")
    void insertUser(User user);

    @Update("update tb_user set id = #{id}, name = #{name}, created_by = #{createdBy}")
    @ResultMap(value = "user")
    void updateUser(User user);

    @Delete("delete from tb_user where id = #{id}")
    void deleteById(@Param("id") int id);

}
```
* @Select, @Insert, @Update, @Delete显然就是sql语句的注解了.
* @Param是根据别名取参数的.
* @Results和@Result配合使用, 就可以将实体类属性和表字段进行一一映射.
    * @Results的参数id表示这个映射的别名, 可以配合@ResultMap使用.
    * @Result的参数column表示表字段名, property表示实体属性名.
* @Options可以在插入时返回主键值, 在这里没什么用. 一般用于在主键id自增的情况下, 插入操作不定义id, 可以在插入数据库表后返回该条插入信息的主键id.

## UserService
```java
@Service
public class ScriptService {

    @Autowired
    private UserMapper userMapper;

    public User selectById(int id) {
        User user = userMapper.selectById(id);
        return user;
    }

    public List<User> selectAll() {
        List<User> list = userMapper.selectAll();
        return list;
    }

    public int insertUser(User user) {
        userMapper.insertUser(user);
        retyrn user.getId();
    }

    public boolean updateUser(User user) {
        int id = user.getId();
        user check = userMapper.selectById(id);
        if (check == null) {
            return false;
        }
        userMapper.updateUser(user);
        return true;
    }

    public boolean deleteById(int id) {
        user check = userMapper.selectById(id);
        if (check == null) {
            return false;
        }
        userMapper.deleteById(id);
        return true;
    }

}
```

## UserController
```java
@Controller
@RequestMapping("/user")
public class UserController {

    @Autowired
    private UserService userService;

    @RequestMapping(value = "/selectById/{id}", method = RequestMethod.GET)
    @ResponseBody
    public User selectById(@PathVariable("id") int id) {
        return  userService.selectById(id);
    }

    @RequestMapping(value = "/selectAll", method = RequestMethod.GET)
    @ResponseBody
    public List<User> selectAll() {
        return  userService.selectAll();
    }

    @RequestMapping(value = "/insertUser", method = RequestMethod.POST)
    @ResponseBody
    public int insertUser(@RequestBody User user) {
        return userService.insertUser(user);
    }

    @RequestMapping(value = "/updateUser", method = RequestMethod.POST)
    @ResponseBody
    public boolean updateUser(@RequestBody User user) {
        return userService.updateUser(user);
    }

    @RequestMapping(value = "/deleteById/{id}", method = RequestMethod.POST)
    @ResponseBody
    public boolean deleteById(@PathVariable("id") int id) {
        return userService.deleteById(id);
    }

}
```


