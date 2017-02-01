@isTest
private class TestDailyOpportunityStatus {

    public static final Integer RECORD_COUNT = 10;

    static testMethod void testOpportunityMail() {

        List<Account> accountList = TestDataFactory.createAccounts(RECORD_COUNT, false);

        for(Integer i = 0; i < accountList.size(); i++) {
            accountList[i].Email_Address__c = 'foo' + i + '@bar.com';
        }

        insert accountList;

        List<Opportunity> opportunityList = TestDataFactory.createOpportunities(RECORD_COUNT * 5, false);
        Integer j = -1;

        for(Integer i = 0; i < opportunityList.size() && j < accountList.size(); i++ ) {

            if( Math.mod(i, 5) == 0) {
                j++;
            }

            opportunityList[i].AccountId = accountList[j].Id;
            opportunityList[i].Amount = 1000;

        }

        System.debug('*/*/*/*/*/*//**/*/*/*/\n\n\n\n' + opportunityList);

        insert opportunityList;

        Test.startTest();

        DailyOpportunityStatus dos = new DailyOpportunityStatus();
        Database.executeBatch(dos);

        Test.stopTest();

        System.debug(dos);

        List<Account> newAccountList = [SELECT Email_Address__c 
                     FROM Account
                    WHERE Email_Address__c = 'foo0@bar.com'
                    LIMIT 1];

        System.debug('******* Accounts :' + newAccountList);

        System.debug('******* Emails Map :' + DailyOpportunityStatus.emailToOpportunityMap);

        system.assertEquals(
            5000,
            DailyOpportunityStatus.emailToOpportunityMap.get(
                newAccountList[0].Email_Address__c
            ).aggregatedAmount
        );

    }
}