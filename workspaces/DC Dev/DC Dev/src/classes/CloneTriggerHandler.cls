/**
 *  Title       : Handler class for LeadTrigger
 *  Class       : caseUpdationTest
 *  Author      : Dnyanesh Chandratre
 *  Created On  : 7/16/2015
 */

public with sharing class CloneTriggerHandler {

    public static boolean IS_EXECUTED = false;

    public static void cloneLead(list<Lead> leadList) {
        Lead leadInstance;
        list<Lead> leadsToInsertList = new list<Lead>();

        for(Lead leadIterator : leadList) {
            leadInstance = leadIterator.clone();
            leadsToInsertList.add(leadInstance);
        }

        if(IS_EXECUTED == false) {
            IS_EXECUTED = true;

            try {
                insert leadsToInsertList;

            } catch(DmlException exceptionInstance) {
                System.debug(exceptionInstance.getMessage());
            }

        }
    }
}