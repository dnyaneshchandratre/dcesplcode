/**
 *  Title       : Test class for handler class of LeadCloneTrigger
 *  Class       : LeadCloneTest
 *  Author      : Dnyanesh Chandratre
 *  Created On  : 7/20/2015
 */

@isTest
public class LeadCloneTest {

    public static final Integer RECORD_COUNT = 100;

    static testMethod void testLeadClonePositive() {

        List<Lead> leadList = new List<Lead>();
        leadList = TestDataFactory.createLeads(RECORD_COUNT, false);

        for(Integer i = 0; i < leadList.size(); i++) {

            leadList[i].LastName = 'Foo' + i;
            leadList[i].Status = 'Open - Not Contacted';

        }

        Test.startTest();
        insert leadList;
        Test.stopTest();

        List<Lead> listLead = [SELECT ID FROM Lead];
        System.assertEquals(RECORD_COUNT * 2, listLead.size());
    }

    /*static testMethod void testLeadCloneNegative() {

        List<Lead> leadList = new List<Lead>();
        leadList = TestDataFactory.createLeads(RECORD_COUNT, false);

        for(Integer i = 0; i < leadList.size(); i++) {
            leadList[i].Status = 'Open - Not Contacted';
        }

        Test.startTest();
        insert leadList;
        Test.stopTest();

        List<Lead> listLead = [SELECT ID FROM Lead];
        System.assertEquals(0, listLead.size());
    }*/

}