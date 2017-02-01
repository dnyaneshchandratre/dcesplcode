/**
 *  Title       : Class to demonstrate use of Abstract methods and Inheritance
 *  Class       : OopsConcepts
 *  Author      : Dnyanesh Chandratre
 *  Created On  : 7/12/2015
 */

public virtual class OopsConcepts extends AbstractClass implements Numbers {

    public static Integer number1,number2;
    public OopsConcepts() {
        number1=21;
        number2=12;
    }

    public OopsConcepts(Integer num1,Integer num2) {
        number1=num1;
        number2=num2;
        addNumbers(number1,number2);
    }

    public void addNumbers(Integer num1,Integer num2) {
        System.debug(num1+num2);
    }

    public override virtual void show() {
        System.debug(DateTime.now());
    }
}