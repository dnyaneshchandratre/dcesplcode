@IsTest
private class AccountListControllerTest {

    public static final Integer RECORD_COUNT = 100;
    public static AccountListController controllerInstance;
    public static String methodName;

    public static testMethod void testWithoutAccounts() {

        methodName = 'testWithoutAccounts :';
        controllerInstance = new AccountListController();
        controllerInstance.getAccountList();
        System.assertEquals(0, controllerInstance.accountList.size(), methodName + ' List size should be zero');

    }

    public static testMethod void testAccountsWithoutContacts() {

        List<Account> accountList = TestDataFactory.createAccounts(RECORD_COUNT, true);

        controllerInstance = new AccountListController();
        controllerInstance.getAccountList();
        System.assertEquals(
            [
                SELECT Id
                  FROM Account
            ].size(),
            controllerInstance.accountList.size());

    }

    public static testMethod void testAccountSearchWithoutSearhKey() {

        List<Account> accountList = TestDataFactory.createAccounts(RECORD_COUNT, true);

        controllerInstance = new AccountListController();

        Test.startTest();
        Test.setCurrentPage(Page.AccountList);

        controllerInstance.getAccountList();
        System.assertEquals(RECORD_COUNT, controllerInstance.accountList.size());
        controllerInstance.searchAccounts();

        Test.stopTest();

        System.assertEquals(true, ApexPages.hasMessages());
        System.assertEquals(
            System.Label.Search_Key_Error_Message, 
            ApexPages.getMessages()[0].getSummary()
        );
        System.assertEquals(false, controllerInstance.searchFlag);
        System.assertEquals(RECORD_COUNT, controllerInstance.accountList.size());

    }

    public static testMethod void testAccountSearchNegative() {

        List<Account> accountList = TestDataFactory.createAccounts(RECORD_COUNT, true);

        controllerInstance = new AccountListController();

        Test.startTest();
        Test.setCurrentPage(Page.AccountList);

        controllerInstance.getAccountList();
        System.assertEquals(RECORD_COUNT, controllerInstance.accountList.size());
        controllerInstance.searchKey = '99';
        controllerInstance.searchAccounts();

        Test.stopTest();

        System.assertEquals(true, ApexPages.hasMessages());
        System.assertEquals(
            System.Label.Search_Key_Error_Message, 
            ApexPages.getMessages()[0].getSummary()
        );
        System.assertEquals(false, controllerInstance.searchFlag);
        System.assertEquals(RECORD_COUNT, controllerInstance.accountList.size());

    }

    public static testMethod void testAccountSearchPositive() {

        List<Account> accountList = TestDataFactory.createAccounts(RECORD_COUNT, true);

        controllerInstance = new AccountListController();

        Test.startTest();
        Test.setCurrentPage(Page.AccountList);

        controllerInstance.getAccountList();
        System.assertEquals(RECORD_COUNT, controllerInstance.accountList.size());
        controllerInstance.searchKey = 'bar 99';

        controllerInstance.searchAccounts();

        System.assertEquals(true, controllerInstance.searchFlag);
        System.assertEquals(1, controllerInstance.accountList.size());

        controllerInstance.clearList();
        controllerInstance.getAccountList();

        System.assertEquals(false, controllerInstance.searchFlag);
        System.assertEquals(100, controllerInstance.accountList.size());

        Test.stopTest();

    }

    public static testMethod void testRedirectWithoutParameters() {

        controllerInstance = new AccountListController();
        List<Account> accountList = TestDataFactory.createAccounts(RECORD_COUNT, true);
        List<Contact> contactList = TestDataFactory.createContacts(RECORD_COUNT * 10, false);
        Integer j = -1;

        for(Integer i = 0; i < contactList.size() && j < accountList.size(); i++ ) {

            if( Math.mod(i, 10) == 0) {
                j++;
            }

            contactList[i].AccountId = accountList[j].Id;
        }

        insert contactList;

        Test.startTest();
        Test.setCurrentPage(Page.AccountList);

        PageReference currPage = controllerInstance.redirectToContacts();

        System.assertEquals(NULL, controllerInstance.AccountId);
    }

    public static testMethod void testRedirect() {

        controllerInstance = new AccountListController();
        List<Account> accountList = TestDataFactory.createAccounts(RECORD_COUNT, true);
        List<Contact> contactList = TestDataFactory.createContacts(RECORD_COUNT * 10, false);
        Integer j = -1;

        for(Integer i = 0; i < contactList.size() && j < accountList.size(); i++ ) {

            if( Math.mod(i, 10) == 0) {
                j++;
            }

            contactList[i].AccountId = accountList[j].Id;

        }

        insert contactList;

        Test.startTest();
        Test.setCurrentPage(Page.AccountList);

        controllerInstance.getAccountList();
        ApexPages.currentPage().getParameters().put('aid', controllerInstance.accountList[0].Id);
        ApexPages.currentPage().getParameters().put('an', controllerInstance.accountList[0].Name);

        Test.setCurrentPage(controllerInstance.redirectToContacts());

        controllerInstance.getSelectedContactsList();
        Test.stopTest();

        System.assertEquals(controllerInstance.AccountId, accountList[0].Id);
        System.assertEquals([
            SELECT Id
               FROM Contact
              WHERE AccountId = :controllerInstance.AccountId
            ].size(),
            controllerInstance.selectedContactsList.size()
        );

    }

    public static testMethod void testAlphabetSearch() {

        controllerInstance = new AccountListController();
        List<Account> accountList = TestDataFactory.createAccounts(RECORD_COUNT, true);
        List<Contact> contactList = TestDataFactory.createContacts(RECORD_COUNT * 10, false);
        Integer j = -1;

        for(Integer i = 0; i < contactList.size() && j < accountList.size(); i++ ) {

            if( Math.mod(i, 10) == 0) {
                j++;
            }

            contactList[i].AccountId = accountList[j].Id;

        }

        insert contactList;

        Test.startTest();
        Test.setCurrentPage(Page.AccountList);

        controllerInstance.getAccountList();
        ApexPages.currentPage().getParameters().put('aid', controllerInstance.accountList[0].Id);
        ApexPages.currentPage().getParameters().put('an', controllerInstance.accountList[0].Name);

        Test.setCurrentPage(controllerInstance.redirectToContacts());

        ApexPages.currentPage().getParameters().put('aid', controllerInstance.accountList[0].Id);
        ApexPages.currentPage().getParameters().put('an', controllerInstance.accountList[0].Name);

        controllerInstance.getSelectedContactsList();

        ApexPages.currentPage().getParameters().put('selectedAlphabet', 'F');

        System.debug('******************* CURRENT PAGE : ' + ApexPages.currentPage());
        System.debug('*******************' + controllerInstance.selectedAlphabet);

        controllerInstance.searchByAlphabet();
        System.assert(controllerInstance.alphaFlag == true);
        System.assertEquals(10, controllerInstance.selectedContactsList.size());

        ApexPages.currentPage().getParameters().put('selectedAlphabet', 'A');
        controllerInstance.searchByAlphabet();
        System.assertEquals(0, controllerInstance.selectedContactsList.size());

        Test.stopTest();

    }

    public static testMethod void testRemoteDeletePositive() {

        controllerInstance = new AccountListController();
        List<Account> accountList = TestDataFactory.createAccounts(RECORD_COUNT, true);
        List<Contact> contactList = TestDataFactory.createContacts(RECORD_COUNT * 10, false);
        Integer j = -1;

        for(Integer i = 0; i < contactList.size() && j < accountList.size(); i++ ) {

            if( Math.mod(i, 10) == 0) {
                j++;
            }

            contactList[i].AccountId = accountList[j].Id;

        }

        insert contactList;

        Test.startTest();
        Test.setCurrentPage(Page.AccountList);

        controllerInstance.getAccountList();
        ApexPages.currentPage().getParameters().put('aid', controllerInstance.accountList[0].Id);
        ApexPages.currentPage().getParameters().put('an', controllerInstance.accountList[0].Name);

        Test.setCurrentPage(controllerInstance.redirectToContacts());

        ApexPages.currentPage().getParameters().put('aid', controllerInstance.accountList[0].Id);
        ApexPages.currentPage().getParameters().put('an', controllerInstance.accountList[0].Name);

        controllerInstance.getSelectedContactsList();

        Integer previousSize = controllerInstance.selectedContactsList.size();
        Boolean var = AccountListController.deleteRelatedContact(
                        controllerInstance.selectedContactsList[0].contactInstance.Id
                      );
        controllerInstance.getSelectedContactsList();
        Test.stopTest();

        System.assertNotEquals(previousSize, controllerInstance.selectedContactsList.size());

    }

    public static testMethod void testRemoteDeleteNegative() {

        controllerInstance = new AccountListController();
        List<Account> accountList = TestDataFactory.createAccounts(RECORD_COUNT, true);
        List<Contact> contactList = TestDataFactory.createContacts(RECORD_COUNT * 10, false);
        Integer j = -1;

        for(Integer i = 0; i < contactList.size() && j < accountList.size(); i++ ) {

            if( Math.mod(i, 10) == 0) {
                j++;
            }

            contactList[i].AccountId = accountList[j].Id;

        }

        insert contactList;

        Test.startTest();
        Test.setCurrentPage(Page.AccountList);

        controllerInstance.getAccountList();
        ApexPages.currentPage().getParameters().put('aid', controllerInstance.accountList[0].Id);
        ApexPages.currentPage().getParameters().put('an', controllerInstance.accountList[0].Name);

        Test.setCurrentPage(controllerInstance.redirectToContacts());

        ApexPages.currentPage().getParameters().put('aid', controllerInstance.accountList[0].Id);
        ApexPages.currentPage().getParameters().put('an', controllerInstance.accountList[0].Name);

        insert new Case(
            ContactId = contactList[0].Id
        );
        controllerInstance.getSelectedContactsList();

        Integer previousSize = controllerInstance.selectedContactsList.size();
        Boolean var = AccountListController.deleteRelatedContact(
                        controllerInstance.selectedContactsList[0].contactInstance.Id
                      );
        controllerInstance.getSelectedContactsList();

        Test.stopTest();

        System.assertEquals(previousSize, controllerInstance.selectedContactsList.size());

    }

    public static testMethod void testAddAssociatedContactPositive() {

        controllerInstance = new AccountListController();
        List<Account> accountList = TestDataFactory.createAccounts(RECORD_COUNT, true);
        List<Contact> contactList = TestDataFactory.createContacts(RECORD_COUNT * 10, false);
        Integer j = -1;

        for(Integer i = 0; i < contactList.size() && j < accountList.size(); i++ ) {

            if( Math.mod(i, 10) == 0) {
                j++;
            }

            contactList[i].AccountId = accountList[j].Id;

        }

        insert contactList;

        Test.startTest();
        Test.setCurrentPage(Page.AccountList);

        controllerInstance.getAccountList();
        ApexPages.currentPage().getParameters().put('aid', controllerInstance.accountList[0].Id);
        ApexPages.currentPage().getParameters().put('an', controllerInstance.accountList[0].Name);

        Test.setCurrentPage(controllerInstance.redirectToContacts());

        ApexPages.currentPage().getParameters().put('aid', controllerInstance.accountList[0].Id);
        ApexPages.currentPage().getParameters().put('an', controllerInstance.accountList[0].Name);

        controllerInstance.getSelectedContactsList();
        Integer previousSize = controllerInstance.selectedContactsList.size();

        controllerInstance.renderAddContactPanel();
        System.assertEquals(true, controllerInstance.isRendered);

        controllerInstance.associatedContact.FirstName = 'Dnyanesh';
        controllerInstance.associatedContact.LastName = 'Chandrate';
        controllerInstance.associatedContact.Email = 'd@c.com';
        controllerInstance.associatedContact.Primary__c = true;
        controllerInstance.saveContact();

        Test.stopTest();

        System.assertEquals(false, controllerInstance.isRendered);
        System.assertNotEquals(previousSize, controllerInstance.selectedContactsList.size());
        System.assertEquals(previousSize + 1, controllerInstance.selectedContactsList.size());

    }

    public static testMethod void testMultipleContactsDeletePositive() {

        controllerInstance = new AccountListController();
        List<Account> accountList = TestDataFactory.createAccounts(RECORD_COUNT, true);
        List<Contact> contactList = TestDataFactory.createContacts(RECORD_COUNT * 10, false);
        Integer j = -1;

        for(Integer i = 0; i < contactList.size() && j < accountList.size(); i++ ) {

            if( Math.mod(i, 10) == 0) {
                j++;
            }

            contactList[i].AccountId = accountList[j].Id;
        }

        insert contactList;

        Test.startTest();
        Test.setCurrentPage(Page.AccountList);

        controllerInstance.getAccountList();
        ApexPages.currentPage().getParameters().put('aid', controllerInstance.accountList[0].Id);
        ApexPages.currentPage().getParameters().put('an', controllerInstance.accountList[0].Name);

        Test.setCurrentPage(controllerInstance.redirectToContacts());

        ApexPages.currentPage().getParameters().put('aid', controllerInstance.accountList[0].Id);
        ApexPages.currentPage().getParameters().put('an', controllerInstance.accountList[0].Name);

        controllerInstance.getSelectedContactsList();
        Integer previousSize = controllerInstance.selectedContactsList.size();

        for(Integer i = 0; i < controllerInstance.selectedContactsList.size() / 2; i++) {
            controllerInstance.selectedContactsList[i].isSelected = true;
        }
        controllerInstance.deleteMultipleContacts();
        controllerInstance.getSelectedContactsList();

        Test.stopTest();

        System.assertNotEquals(previousSize, controllerInstance.selectedContactsList.size());

    }

    public static testMethod void testMultipleContactsDeleteNegative() {

        controllerInstance = new AccountListController();
        List<Account> accountList = TestDataFactory.createAccounts(RECORD_COUNT, true);
        List<Contact> contactList = TestDataFactory.createContacts(RECORD_COUNT * 10, false);
        Integer j = -1;

        for(Integer i = 0; i < contactList.size() && j < accountList.size(); i++ ) {

            if( Math.mod(i, 10) == 0) {
                j++;
            }

            contactList[i].AccountId = accountList[j].Id;

        }

        insert contactList;

        Test.startTest();
        Test.setCurrentPage(Page.AccountList);

        controllerInstance.getAccountList();
        ApexPages.currentPage().getParameters().put('aid', controllerInstance.accountList[0].Id);
        ApexPages.currentPage().getParameters().put('an', controllerInstance.accountList[0].Name);

        Test.setCurrentPage(controllerInstance.redirectToContacts());

        ApexPages.currentPage().getParameters().put('aid', controllerInstance.accountList[0].Id);
        ApexPages.currentPage().getParameters().put('an', controllerInstance.accountList[0].Name);

        insert new Case(
            ContactId = contactList[0].Id
        );
        controllerInstance.getSelectedContactsList();
        Integer previousSize = controllerInstance.selectedContactsList.size();

        for(Integer i = 0; i < controllerInstance.selectedContactsList.size() / 2; i++) {
            controllerInstance.selectedContactsList[i].isSelected = true;
        }
        controllerInstance.deleteMultipleContacts();
        controllerInstance.getSelectedContactsList();

        Test.stopTest();

        System.assertEquals(previousSize, controllerInstance.selectedContactsList.size());

    }

    public static testMethod void testReturnToAccount() {

        controllerInstance = new AccountListController();
        List<Account> accountList = TestDataFactory.createAccounts(RECORD_COUNT, true);
        List<Contact> contactList = TestDataFactory.createContacts(RECORD_COUNT * 10, false);
        Integer j = -1;

        for(Integer i = 0; i < contactList.size() && j < accountList.size(); i++ ) {

            if( Math.mod(i, 10) == 0) {
                j++;
            }

            contactList[i].AccountId = accountList[j].Id;

        }

        insert contactList;

        Test.startTest();
        Test.setCurrentPage(Page.AccountList);

        controllerInstance.getAccountList();
        ApexPages.currentPage().getParameters().put('aid', controllerInstance.accountList[0].Id);
        ApexPages.currentPage().getParameters().put('an', controllerInstance.accountList[0].Name);

        Test.setCurrentPage(controllerInstance.redirectToContacts());

        ApexPages.currentPage().getParameters().put('aid', controllerInstance.accountList[0].Id);
        ApexPages.currentPage().getParameters().put('an', controllerInstance.accountList[0].Name);

        controllerInstance.getSelectedContactsList();

        Test.setCurrentPage(controllerInstance.returnToAccount());

        Test.stopTest();

        System.assertEquals(Page.AccountList.getUrl(), ApexPages.currentPage().getUrl());
    }

}