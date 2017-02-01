/**
 *  Title       : Test class for handler class of CaseUpdateTrigger
 *  Class       : caseUpdationTest
 *  Author      : Dnyanesh Chandratre
 *  Created On  :  7/20/2015
 */

@isTest
public class caseUpdationTest {

    /*Testing Both Email Match Case*/
    static testMethod void matchBothEmails() {
        Account objAccount = new Account(
            Name = 'Foo',
            PersonEmail__c='a@b.com',
            Email_Address__c = 'a@b.com'
        );

        insert objAccount;
        insert new Contact(LastName = 'TriggerTest',AccountId = objAccount.Id);

        Case objCase = new Case();
        objCase.Origin = 'Web';
        objCase.Status = 'New';
        objCase.Supplied_Mail__c = 'a@b.com';

        test.startTest();
        insert objCase;
        test.stopTest();

        objCase = [SELECT AccountId FROM Case];
        System.assertEquals(objAccount.Id, objCase.AccountId);
    }
    
    /*Testing Single Email Match Case [1]*/
    static testMethod void matchEmailAddress() {
        Account objAccount = new Account(
            Name = 'Foo',
            PersonEmail__c='x@y.com',
            Email_Address__c = 'a@b.com'
        );

        insert objAccount;
        insert new Contact(LastName = 'TriggerTest', AccountId = objAccount.Id);

        Case objCase = new Case();
        objCase.Origin = 'Email';
        objCase.Status = 'New';
        objCase.Supplied_Mail__c = 'a@b.com';

        test.startTest();
        insert objCase;
        test.stopTest();

        objCase = [SELECT AccountId FROM Case];
        System.assertEquals(objAccount.Id, objCase.AccountId);
    }
    
    /*Testing Single Email Match Case [2]*/
    static testMethod void matchPersonEmail() {
        Account objAccount = new Account(
            Name = 'Foo',
            PersonEmail__c='a@b.com',
            Email_Address__c = 'x@y.com'
        );

        insert objAccount;
        insert new Contact(LastName = 'TriggerTest',AccountId = objAccount.Id);

        Case objCase = new Case();
        objCase.Origin = 'Phone';
        objCase.Status = 'New';
        objCase.Supplied_Mail__c = 'a@b.com';

        test.startTest();
        insert objCase;
        test.stopTest();

        objCase = [SELECT AccountId FROM Case];
        System.assertEquals(objAccount.Id,objCase.AccountId);
    }

    /*Testing No Email Match Case [2]*/
    static testMethod void matchNoEmails() {
        Account objAccount = new Account(
            Name = 'Foo',
            PersonEmail__c='x@y.com',
            Email_Address__c = 'c@d.com'
        );

        insert objAccount;
        insert new Contact(LastName = 'TriggerTest',AccountId = objAccount.Id);

        Case objCase = new Case();
        objCase.Origin = 'Web';
        objCase.Status = 'New';
        objCase.Supplied_Mail__c = 'a@b.com';

        test.startTest();
        insert objCase;
        test.stopTest();

        objCase = [SELECT AccountId FROM Case];
        System.assertEquals(NULL,objCase.AccountId);
    }
}