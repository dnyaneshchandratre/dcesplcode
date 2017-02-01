@isTest

public with sharing class TestRestCrudWebServiceProvider {
// Test case for Insert [POSITIVE]
    static testMethod void testRestWebServicePositiveInsert() {

        test.startTest();

        RestCrudWebServiceProvider.insertLead(
            'Dummy',
            'Record',
            'dummy@email.com',
            '123654789'
        );

        test.stopTest();

        System.assertEquals(2,[SELECT Id FROM Lead WHERE LastName = 'Record'].size());
    }

// Test case for Insert [NEGATIVE]
    static testMethod void testRestWebServiceNegativeInsert() {

        test.startTest();

        RestCrudWebServiceProvider.insertLead(
            'Dummy',
            'Record',
            'dummy.com',
            '123654789abc'
        );

        test.stopTest();

        System.assertEquals(0,[SELECT Id FROM Lead WHERE LastName = 'Record'].size());
    }

// Test case for Update [POSITIVE]
    static testMethod void testRestWebServicePositiveUpdate() {

        List<Lead> leadList = TestDataFactory.createLeads(5,false);
        Integer i = 0;

        for(Lead leadIterator : leadList) {

            leadIterator.FirstName = 'FirstName' + i;
            leadIterator.LastName = 'LastName';
            leadIterator.Email = 'firstname' + i + '@email.com';
            leadIterator.Phone = '123564789';
            i++;

        }

        insert leadList;

        test.startTest();

        RestCrudWebServiceProvider.updateLeads(
            'FirstName0',
            'LastName',
            'dummy@email.com',
            '123456798'
        );

        test.stopTest();

        System.assertEquals(2,[SELECT Id FROM Lead WHERE Email = 'dummy@email.com'].size());
    }

// Test case for Update [NEGATIVE]
    static testMethod void testRestWebServiceNegativeUpdate() {

        List<Lead> leadList = TestDataFactory.createLeads(5,false);
        Integer i = 0;

        for(Lead leadIterator : leadList) {

            leadIterator.FirstName = 'FirstName' + i;
            leadIterator.LastName = 'LastName';
            leadIterator.Email = 'firstname' + i + '@email.com';
            leadIterator.Phone = '123564789';
            i++;

        }

        insert leadList;

        test.startTest();

        RestCrudWebServiceProvider.updateLeads(
            'FirstName0',
            'LastName',
            'dummy.com',
            '123654789'
        );

        test.stopTest();

        System.assertEquals(0,[SELECT Id FROM Lead WHERE LastName = 'Record'].size());
    }

// Test case for Delete [POSITIVE]
    static testMethod void testRestWebServicePositiveDelete() {

        List<Lead> leadList = TestDataFactory.createLeads(5,false);
        Integer i = 0;

        for(Lead leadIterator : leadList) {

            leadIterator.FirstName = 'FirstName' + i;
            leadIterator.LastName = 'LastName';
            leadIterator.Email = 'firstname' + i + '@email.com';
            leadIterator.Phone = '123564789';
            i++;

        }

        insert leadList;

        RestContext.Request = new RestRequest();
        RestContext.Request.params.put('fn', 'FirstName0');
        RestContext.Request.params.put('ln', 'LastName');
        RestContext.Request.params.put('em', 'firstname0@email.com');
        RestContext.Request.params.put('ph', '123564789');

        test.startTest();

        RestCrudWebServiceProvider.deleteLeads();

        test.stopTest();

        System.assertEquals(8,[SELECT Id FROM Lead].size());
    }

// Test case for Delete [NEGATIVE]
    static testMethod void testRestWebServiceNegativeDelete() {

        List<Lead> leadList = TestDataFactory.createLeads(5,false);
        Integer i = 0;

        for(Lead leadIterator : leadList) {

            leadIterator.FirstName = 'FirstName' + i;
            leadIterator.LastName = 'LastName';
            leadIterator.Email = 'firstname' + i + '@email.com';
            leadIterator.Phone = '123564789';
            i++;

        }

        insert leadList;

        Campaign campaignInstance = new Campaign(Name = 'Test Campaign'); 
        insert campaignInstance;
        insert new CampaignMember(LeadId = leadList[0].Id, CampaignId = campaignInstance.Id);

        RestContext.Request = new RestRequest();
        RestContext.Request.params.put('fn', 'FirstName0');
        RestContext.Request.params.put('ln', 'LastName');
        RestContext.Request.params.put('em', 'firstname@email.com');
        RestContext.Request.params.put('ph', '123564789');

        test.startTest();

        RestCrudWebServiceProvider.deleteLeads();

        test.stopTest();

        System.assertEquals(10,[SELECT Id FROM Lead].size());
    }
}