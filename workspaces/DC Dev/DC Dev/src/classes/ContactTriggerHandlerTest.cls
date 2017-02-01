/**
 *  Title       : Test class for handler class of ContactTrigger
 *  Class       : ContactTriggerHandlerTest
 *  Author      : Dnyanesh Chandratre
 *  Created On  : 7/29/2015
 */

@isTest
private class ContactTriggerHandlerTest {

    static testMethod void testValid() {

        Account accountInstance = new Account();
        accountInstance.Name = 'ABC Containers';
        accountInstance.website = 'www.abc.com';
        insert accountInstance;

        Contact contactInstance = new Contact();
        contactInstance.LastName ='foo';
        contactInstance.Email = 'foo@abc.com';

        test.startTest();
            insert contactInstance;
        test.stopTest();

        Contact resultContact = [SELECT AccountId FROM Contact WHERE LastName ='foo'];
        System.assertEquals(accountInstance.Id, resultContact.AccountId);
    }

    // Update this method
    static testMethod void testDifferentDomain() {

        Account AccountInstance = new Account();
        AccountInstance.Name = 'ABC Containers';
        AccountInstance.website = 'www.abc.com';
        insert AccountInstance;

        Contact contactInstance = new Contact();
        contactInstance.LastName ='foo';
        contactInstance.email = 'foo@xyz.com';

        test.startTest();
            insert contactInstance;
        test.stopTest();

        contactInstance = [SELECT AccountId FROM Contact];
        System.assertEquals(NULL,contactInstance.AccountId);
    }

    // Update this method
    static testMethod void testBlankEmail() {

        Account AccountInstance = new Account();
        AccountInstance.Name = 'ABC Containers';
        AccountInstance.website = 'www.abc.com';
        insert AccountInstance;

        Contact contactInstance = new Contact();
        contactInstance.LastName ='foo';

        test.startTest();
            insert contactInstance;
        test.stopTest();

        contactInstance = [SELECT AccountId FROM Contact];
        System.assertEquals(NULL,contactInstance.AccountId);
    }

    // Update this method
    static testMethod void testBlankWebsite() {

        Account accountInstance = new Account();
        accountInstance.Name = 'ABC Containers';
        insert accountInstance;

        Contact contactInstance = new Contact();
        contactInstance.LastName ='foo';
        contactInstance.email = 'foo@xyz.com';

        test.startTest();
            insert contactInstance;
        test.stopTest();

        contactInstance = [SELECT AccountId FROM Contact];
        System.assertEquals(NULL,contactInstance.AccountId);
    }

}