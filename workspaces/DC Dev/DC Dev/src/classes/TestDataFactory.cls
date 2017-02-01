/**
 *
 */

// VERY GOOD.. !! :)

@isTest
public class TestDataFactory {

    public static final String FOO = 'Foo';
    public static final String BAR = 'Bar';
    public static final String ACCOUNT_NUMBER_PREFIX = 'ACCNO00';

    /**************** Case Creation ****************/
    public static List<Case> createCases(Integer countOfRecords, Boolean isInsert) {
        List<Case> caseList = new List<Case>();
        for(Integer i = 0; i < countOfRecords; i++) {
            caseList.add(
                new Case(
                    Status = 'New',
                    Origin = 'Phone'
                )
            );
        }

        if(isInsert == true) {
            insert caseList;
        }
        return caseList;

    }

    /**************** Account Creation ****************/
    public static List<Account> createAccounts(Integer countOfRecords, Boolean isInsert) {
        List<Account> AccountList = new List<Account>();
        for(Integer i = 0; i < countOfRecords; i++) {
            AccountList.add(
                new Account(
                    Name = FOO + ' ' + BAR + ' ' + i,
                    AccountNumber = ACCOUNT_NUMBER_PREFIX + i
                )
            );
        }

        if(isInsert == true) {
            insert AccountList;
        }
        return AccountList;

    }

    /**************** Contact Creation ****************/
    public static List<Contact> createContacts(Integer countOfRecords, Boolean isInsert) {
        List<Contact> contactList = new List<Contact>();
        for(Integer i = 0; i < countOfRecords; i++) {
            contactList.add(
                new Contact(
                    FirstName = FOO + i,
                    LastName = BAR
                )
            );
        }

        if(isInsert == true) {
            insert contactList;
        }
        return contactList;

    }

    /**************** Opportunity Creation ****************/
    public static List<Opportunity> createOpportunities(Integer countOfRecords, Boolean isInsert) {
        List<Opportunity> opportunityList = new List<Opportunity>();
        for(Integer i = 0; i < countOfRecords; i++) {
            opportunityList.add(
                new Opportunity(
                    Name = FOO + BAR + i,
                    StageName = 'Closed Won',
                    CloseDate = Date.newInstance(2015, 9, 6)
                )
            );
        }

        if(isInsert == true) {
            insert opportunityList;
        }
        return opportunityList;

    }

    /**************** Lead Creation ****************/
    public static List<Lead> createLeads(Integer countOfRecords, Boolean isInsert) {
        List<Lead> leadList = new List<Lead>();
        for(Integer i = 0; i < countOfRecords; i++) {
            LeadList.add(
                new Lead(
                    Company = 'Just Foo Ltd.'
                )
            );
        }

        if(isInsert == true) {
            insert leadList;
        }
        return leadList;

    }
}