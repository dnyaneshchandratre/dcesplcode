@isTest
private class QueryBuilderControllerTest {

    static testMethod void testQueryBuilderControllerPositive() {

        List<Account> AccountList = TestDataFactory.createAccounts(10, true);

        test.startTest();

        QueryBuilderController controllerInstance = new QueryBuilderController();
        test.setCurrentPage(Page.QueryBuilder);

        controllerInstance.init();
        controllerInstance.getOrderRadioList();
        controllerInstance.getRecordCountList();
        controllerInstance.getObjectNameList();
        controllerInstance.selectedObject = 'Account';
        controllerInstance.initObjectFieldsSet();
        controllerInstance.addSelectedFields();

        controllerInstance.selectedFieldsList
                          .addAll(new List<String>{'AccountNumber','CreatedDate'});
        controllerInstance.addSelectedFields();
        controllerInstance.removeSelectedFieldsList.add('CreatedDate');
        controllerInstance.removeSelectedFields();

        controllerInstance.selectedOrder = 'DESC';
        controllerInstance.selectedFieldToOrderBy = 'Name';
        controllerInstance.selectedRecordLimit = '1000';

        controllerInstance.generateQuery();
        System.debug('*********/*/*/*/*/\n\n\n\n' + controllerInstance.generatedQuery);

        System.assertEquals(
            10,
            controllerInstance.queryResults.size(),
            'Should be equal to 10 and it is ' + controllerInstance.queryResults.size()
        );

        System.assertNotEquals(
            0,
            controllerInstance.queryResults.size(),
            'Should be greater than zero and it is ' + controllerInstance.queryResults.size()
        );

        test.stopTest();
    }

    static testMethod void testQueryBuilderControllerNegative() {

        List<Account> AccountList = TestDataFactory.createAccounts(10, true);

        test.startTest();

        QueryBuilderController controllerInstance = new QueryBuilderController();
        test.setCurrentPage(Page.QueryBuilder);

        controllerInstance.init();
        controllerInstance.getOrderRadioList();
        controllerInstance.getRecordCountList();
        controllerInstance.getObjectNameList();

        controllerInstance.generateQuery();
        System.debug('*********/*/*/*/*/\n\n\n\n' + controllerInstance.generatedQuery);

        System.assertEquals(
            0,
            controllerInstance.queryResults.size(),
            'Should be equal to 0 and it is ' + controllerInstance.queryResults.size()
        );

        test.stopTest();
    }
}