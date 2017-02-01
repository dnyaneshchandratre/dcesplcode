@isTest
private class TestJsonToRecordCreator {

    static testMethod void TestPositive() {

        JsonToRecordCreator JtrcInstance = new JsonToRecordCreator();
        Event__c event = new Event__c(
            JSON__c = '{ "Name" : "Dnyanesh", "Email_Address__c" : "dnyanesh.chandratre@eternus.com", "Primary_Contact__c" : "dnyanesh@eternussolutions.com", "Active__c": "Yes", "Phone" : "546548975"}',
            Name = 'Account',
            Processed__c = false
        );
        insert event;

        Test.startTest();
        Database.executeBatch(JtrcInstance,5);
        Test.stopTest();

        list<Event__c> listEvent = [SELECT Id,Name,JSON__c,Processed__c FROM Event__c WHERE Processed__c = true];
        system.debug('******************ListEVENT***************'+listEvent);
        
        system.assertEquals(1,listEvent.size());
    }

    static testMethod void TestNegative() {

        JsonToRecordCreator JtrcInstance = new JsonToRecordCreator();
        Event__c event = new Event__c(
            JSON__c = '{ "Name" : "Dnyanesh", "Email_Address__c" : "dnyanesh.chandratre@eternus.com", "Primary_Contact__c" : "dnyanesh@eternussolutions.com", "Active__c": "Yes", "Phone" : "546548975"}',
            Name = 'Accounts',
            Processed__c = false
        );

        insert event;

        Test.startTest();
        Database.executeBatch(JtrcInstance,5);
        Test.stopTest();

        list<Event__c> listEvent = [SELECT Id,Name,JSON__c,Processed__c FROM Event__c WHERE Processed__c = true];
        system.debug('******************ListEVENT***************'+listEvent);
        
        system.assertNotEquals(1,listEvent.size());
    }
}