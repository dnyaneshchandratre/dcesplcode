public with sharing class MapAccountsContactsOpportunities {
    /*public static void getMap() {
        Map<Account, Map<Contact, List<Opportunity>>> aSmallMap = 
            new Map<Account, Map<Contact, List<Opportunity>>>();
        List<Account> accountList = [
            SELECT Name,
                   (SELECT Name,
                           StageName,
                           Amount
                      FROM Opportunities
                     WHERE AccountId <> NULL),
                   (SELECT Name
                      FROM Contacts
                     WHERE AccountId <> NULL
                     LIMIT 1)
              FROM Account
        ];

        for(Account accountIterator : accountList) {
            if(!aSmallMap.containsKey(accountIterator)) {
                aSmallMap.put(
                    accountIterator,
                    new Map<Contact, List<Opportunity>> {
                        accountIterator.Contacts[0] => accountIterator.Opportunities
                    }
                );
            } else {
                aSmallMap.get(accountIterator).put(
                    accountIterator.Contacts[0],
                    accountIterator.Opportunities
                );
            }
        }
        for(Account key : aSmallMap.keySet()) {
            System.debug('********* MAP IS : ' + Key + '\n' + aSmallMap.get(key));
        }
    }*/
}