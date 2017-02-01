@isTest

public with sharing class TestSoapCrudWebServiceProvider {
// Test case for Insert [POSITIVE]
    static testMethod void testSoapWebServicePositiveInsert() {

        test.startTest();

        SoapCrudWebServiceProvider.insertLead(
            'Dummy',
            'Record',
            'dummy@email.com',
            '123654789'
        );

        test.stopTest();

        System.assertEquals(2,[SELECT Id FROM Lead WHERE LastName = 'Record'].size());
    }

// Test case for Insert [NEGATIVE]
    static testMethod void testSoapWebServiceNegativeInsert() {

        test.startTest();

        SoapCrudWebServiceProvider.insertLead(
            'Dummy',
            'Record',
            'dummy.com',
            '123654789abc'
        );

        test.stopTest();

        System.assertEquals(0,[SELECT Id FROM Lead WHERE LastName = 'Record'].size());
    }

// Test case for Update [POSITIVE]
    static testMethod void testSoapWebServicePositiveUpdate() {

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

        SoapCrudWebServiceProvider.updateLeads(
            'FirstName0',
            'LastName',
            'dummy@email.com',
            '123456798'
        );

        test.stopTest();

        System.assertEquals(2,[SELECT Id FROM Lead WHERE Email = 'dummy@email.com'].size());
    }

// Test case for Update [NEGATIVE]
    static testMethod void testSoapWebServiceNegativeUpdate() {

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

        SoapCrudWebServiceProvider.updateLeads(
            'FirstName0',
            'LastName',
            'dummy.com',
            '123654789'
        );

        test.stopTest();

        System.assertEquals(0,[SELECT Id FROM Lead WHERE LastName = 'Record'].size());
    }

// Test case for Delete [POSITIVE]
    static testMethod void testSoapWebServicePositiveDelete() {

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

        SoapCrudWebServiceProvider.deleteLeads(
            'FirstName0',
            'LastName',
            'firstname0@email.com',
            '123564789'
        );

        test.stopTest();

        System.assertEquals(8,[SELECT Id FROM Lead].size());
    }

// Test case for Delete [NEGATIVE]
    static testMethod void testSoapWebServiceNegativeDelete() {

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

        SoapCrudWebServiceProvider.deleteLeads(
            'FirstName',
            'LastName',
            'firstname@email.com',
            '123654789'
        );

        test.stopTest();

        System.assertEquals(10,[SELECT Id FROM Lead].size());
    }
}