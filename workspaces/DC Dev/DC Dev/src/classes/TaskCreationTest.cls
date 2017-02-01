/**
 *  Title       : Test class for createTaskHandler
 *  Class       : TaskCreationTest
 *  Author      : Dnyanesh Chandratre
 *  Created On  : 7/20/2015
 */

@isTest

// Change this method "USE MEETING_WITH"
public class TaskCreationTest {

    static testMethod void testCreateTaskPositive() {
        Account objAccount = new Account();
        objAccount.Name = 'Foo';

        test.startTest();
        insert objAccount;
        test.stopTest();

        String TaskSubject = createTaskHandler.MEETING_WITH + objAccount.Name;

        List<Task> taskList= [SELECT Subject FROM Task WHERE Subject = :TaskSubject];
        System.assertEquals(1,taskList.size());
    }
}