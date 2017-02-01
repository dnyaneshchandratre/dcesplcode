/**
 *  Title   : Handler class for demonstrating use of trigger on Account.
 *  Class   : AbstractClass
 *  Author  : Dnyanesh Chandratre
 *  Created On: 7/15/2015
 */
public with sharing class AccountTriggerHandler {

    // METHOD NAME ARE BEST IF THEY ARE IN THE FORM OF VERB
    // debugTriggerNew
    public static void debugTriggerNew(List<Account> accountList) {
        for(Account accountInstance : accountList) {
            System.debug('***The record has values*** :\n' + accountInstance);
        }
    }

    // UPDATE METHOD NAME
    // KEEP SPACE BETWEEN COMMA SEPARATED VALUES
    public static void debugTriggerNewMap(Map<Id, Account> accountMap) {

        // BLANK SPACE AFTER ITERATOR
        for(Id accountId : accountMap.keySet()) {
            System.debug('***The record has id*** :\n' + accountId);
            System.debug('***The record is*** :\n' + accountMap.get(accountId));
        }
    }
}