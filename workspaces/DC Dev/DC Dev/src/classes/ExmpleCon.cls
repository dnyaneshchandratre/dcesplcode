/**
 *  Title       : Controller class for ExamplePage.page [DEMO OF JS]
 *  Class       : ExmpleCon
 *  Author      : Dnyanesh Chandratre
 *  Created On  : 7/22/2015
 */

public with sharing class ExmpleCon {

    String uname;

    public String getUsername() {
        return uname;
    }

    public PageReference sayHello() {
        uname = UserInfo.getName();
        return null;
    }

    public void setState(String n) {
        state = n;
    }

    public String getState() {
        return state;
    }

    public PageReference methodOne() {
        return null;
    }

    private String state = 'no';
}