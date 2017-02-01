/**
 *  Title       : Handler class for ContactTrigger
 *  Class       : ContactTriggerHandler
 *  Author      : Dnyanesh Chandratre
 *  Created On  : 7/23/2015
 */

public with sharing class ContactTriggerHandler {

    public static void updateAccountLookup(List<Contact> newContacts) {

        System.debug('************ IN HANDLER');
        List<Account> accountList = [
            SELECT Website,
                   Id
              FROM Account
             WHERE Website <> NULL
          ORDER BY Name
        ];

        Map<String, Id> mapWebsites = new Map<String,Id>();

        for(Account accountIterator : AccountList) {

            System.debug('************' + accountIterator.Website);
            if(accountIterator.Website.indexOf('://') == -1) {
                accountIterator.Website = 'http://' + accountIterator.Website;
            }

            mapWebsites.put( new URL(accountIterator.Website).getHost().replace('www.',''),
                accountIterator.Id );
            System.debug(
                mapWebsites.get(
                    new URL(accountIterator.Website).getHost()
                                                    .replace('www.','')
                )
            );
        }

        System.debug(mapWebsites);

        for(Contact contactIterator : newContacts) {

            if(contactIterator.Email <> NULL) {

                if(mapWebsites.containsKey(contactIterator.Email.substringAfter('@'))) {

                    contactIterator.AccountId = 
                        mapWebsites.get(contactIterator.Email.substringAfter('@'));

                } else {

                    contactIterator.AccountId = NULL;

                }
            }
        }
    }

    public static void populatePrimaryContact(List<Contact> contactList) {

        Account accountInstance;
        List<Account> accountList = new List<Account>();

        for(Contact contactIterator : contactList) {

            if(    contactIterator.Primary__c <> true
                && String.isNotBlank(contactIterator.AccountId)
                && String.isNotBlank(contactIterator.Email) 
            ) {

                accountInstance = new Account(Id = contactIterator.AccountId);
                accountInstance.Primary_Contact__c = contactIterator.Email;
                accountList.add(accountInstance);

            }
        }

        if(accountList.isEmpty() <> true) {
            update accountList;
        }

    }
}