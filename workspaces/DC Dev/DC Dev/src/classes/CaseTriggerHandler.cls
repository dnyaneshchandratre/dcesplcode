/**
 *  Title   : Handler class for CaseUpdateTrigger
 *  Class   : caseUpdateHandler
 *  Author  : Dnyanesh Chandratre
 *  Created On: 7/16/2015
 */

public with sharing class CaseTriggerHandler {

    public static final String SEPERATOR = '&&';

    public static void updateCase(List<Case> caseList) {

        List<String> suppliedEmailList = new List<String>();

        for(Case caseIterator : caseList) {
            suppliedEmailList.add(caseIterator.Supplied_Mail__c);
        }

        List<Contact> contactList = [
            SELECT Email,
                   Account.PersonEmail__c,
                   Account.Email_Address__c,
                   Account.Id,
                   AccountId
              FROM Contact
             WHERE Account.PersonEmail__c IN :suppliedEmailList
                OR Account.Email_Address__c IN :suppliedEmailList
          ORDER BY CreatedDate DESC
             LIMIT 1
        ];

        if(contactList == NULL || contactList.isEmpty()) {
            return;
        }

        Map<String, String> personEmailToIdMap = new Map<String, String>();
        Map<String, String> emailAddressToIdMap = new Map<String, String>();

        for(Contact contactIterator : contactList) {
            personEmailToIdMap.put(contactIterator.Account.PersonEmail__c,
                                contactIterator.Id + SEPERATOR + contactIterator.AccountId);

            emailAddressToIdMap.put(contactIterator.Account.Email_Address__c,
                                 contactIterator.Id + SEPERATOR + contactIterator.AccountId);
        }

        for(Case caseIterator : caseList) {
            if(   caseIterator.Origin == 'Web' 
               || caseIterator.Origin == 'Email' 
               || caseIterator.Origin == 'Phone'
            ) {
                if(personEmailToIdMap.containsKey(caseIterator.Supplied_Mail__c)) {

                    caseIterator.ContactId = personEmailToIdMap.get(caseIterator.Supplied_Mail__c)
                                                               .substringBefore(SEPERATOR);
                    caseIterator.AccountId = personEmailToIdMap.get(caseIterator.Supplied_Mail__c)
                                                               .substringAfter(SEPERATOR);

                }

                if(emailAddressToIdMap.containsKey(caseIterator.Supplied_Mail__c)) {

                    caseIterator.ContactId = emailAddressToIdMap.get(caseIterator.Supplied_Mail__c)
                                                                .substringBefore(SEPERATOR);
                    caseIterator.AccountId = emailAddressToIdMap.get(caseIterator.Supplied_Mail__c)
                                                                .substringAfter(SEPERATOR);

                }

            }
        }
    }

}