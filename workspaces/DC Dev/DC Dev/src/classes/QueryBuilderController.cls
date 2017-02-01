public with sharing class QueryBuilderController {

    public static final String ASCENDING_VALUE = 'ASC';
    public static final String ASCENDING_LABEL = 'Ascending';
    public static final String DESCENDING_VALUE = 'DESC';
    public static final String DESCENDING_LABEL = 'Descending';
    
    public static final String RECORDS_500 = '500';
    public static final String RECORDS_1000 = '1000';
    public static final String RECORDS_5000 = '5000';
    public static final String RECORDS_50000 = '50000';

    public String selectedObject                    {get; set;}
    public String selectedOrder                     {get; set;}
    public String selectedRecordLimit               {get; set;}
    public String selectedFieldToOrderBy            {get; set;}
    public String generatedQuery                    {get; set;}

    public List<Sobject> queryResults               {get; set;}
    public List<String> selectedFieldsList          {get; set;}
    public List<String> removeSelectedFieldsList    {get; set;}
    public List<String> displaySelectedFieldsList   {get; set;}

    public List<SelectOption> objectFieldsList      {get; set;}
    public List<SelectOption> addedFieldsList       {get; set;}
    public List<SelectOption> removedFieldsList     {get; set;}
    public List<SelectOption> fieldToOrderByList    {get; set;}

    public List<SelectOption> objectNameList = new List<SelectOption>();
    public List<SelectOption> orderRadioList = new List<SelectOption>();
    public List<SelectOption> recordCountList = new List<SelectOption>();

    public void init() {

        selectedObject = 'NULL';
        selectedOrder = ASCENDING_VALUE;
        selectedRecordLimit = RECORDS_500;

        selectedFieldsList = new List<String>();
        removeSelectedFieldsList = new List<String>();
        objectFieldsList = new List<SelectOption>();
        addedFieldsList = new List<SelectOption>();
        removedFieldsList = new List<SelectOption>();
        fieldToOrderByList = new List<SelectOption>();
        queryResults = new List<SObject>();

    }

    public List<SelectOption> getObjectNameList() {

        objectNameList.clear();
        objectNameList.add(
                    new SelectOption(
                        'NULL', 
                        '--- Select Object ---'
                    )
                );
        for(SObjectType objectName : Schema.getGlobalDescribe().values()) {
            if(objectName.getDescribe().isQueryable() == true) {
                objectNameList.add(
                    new SelectOption(
                        objectName.getDescribe().getName(), 
                        objectName.getDescribe().getName()
                    )
                );
            }
        }

        objectNameList.sort();
        return objectNameList;

    }

    public void initObjectFieldsSet() {

        System.debug('************* IN INIT *****************');

        objectFieldsList = new List<SelectOption>();
        fieldToOrderByList = new List<SelectOption>();

        if(selectedObject == 'NULL') {
            return;
        }

        Schema.SObjectType selectedObjectType = Schema.getGlobalDescribe().get(selectedObject);
        Map<String, Schema.SObjectField> fieldResult = selectedObjectType.getDescribe()
                                                                         .fields
                                                                         .getMap();

        for(String fieldName : fieldResult.keySet()) {
            if(fieldName == 'Name' || fieldName == 'Id') {
                continue;
            }
            objectFieldsList.add(
                new SelectOption(
                    fieldName,
                    fieldName
                )
            );
            if(fieldResult.get(fieldName).getDescribe().isSortable() == true) {
                fieldToOrderByList.add(
                    new SelectOption(
                        fieldName,
                        fieldName
                    )
                );
            }
        }

        objectFieldsList.sort();
        fieldToOrderByList.sort();
        selectedFieldsList.clear();
        addedFieldsList.clear();

    }

    public void addSelectedFields() {

        System.debug('FIELDS SIZE ********** ' + selectedFieldsList.size());

        for(String fieldName : selectedFieldsList) {
            addedFieldsList.add(new SelectOption(fieldName, fieldName));
        }

        System.debug(addedFieldsList);

        Map<SelectOption, Boolean> selectedFieldsMap = new Map<SelectOption, Boolean>();
        for(SelectOption field : objectFieldsList) {
            selectedFieldsMap.put(field, false);
        }

        for(SelectOption selectedField : addedFieldsList) {
            if(selectedFieldsMap.containsKey(selectedField)) {
                selectedFieldsMap.put(selectedField, true);
            }
        }

        Boolean selectedKeyValue;
        for(SelectOption selectedField : addedFieldsList) {
            if(selectedFieldsMap.containsKey(selectedField)) {
                selectedKeyValue = selectedFieldsMap.remove(selectedField);
            }
        }

        objectFieldsList.clear();
        objectFieldsList.addAll(selectedFieldsMap.keySet());
        objectFieldsList.sort();

    }

    public void removeSelectedFields() {

        System.debug('*************/*/*/*/*/*/*/*/*/*/*/1 \n' + removeSelectedFieldsList);
        for(String fieldName : removeSelectedFieldsList) {
            removedFieldsList.add(
                new SelectOption(
                    fieldName,
                    fieldName
                )
            );
        }
        
        System.debug('*************/*/*/*/*/*/*/*/*/*/*/2 \n' + removedFieldsList);

        Map<SelectOption, Boolean> removedFieldsMap = new Map<SelectOption, Boolean>();
        for(SelectOption field : addedFieldsList) {
            removedFieldsMap.put(field, false);
        }

        System.debug('*************/*/*/*/*/*/*/*/*/*/*/3 \n' + removedFieldsMap);

        for(SelectOption selectedField : removedFieldsList) {
            if(removedFieldsMap.containsKey(selectedField)) {
                removedFieldsMap.put(selectedField, true);
            }
        }

        System.debug('*************/*/*/*/*/*/*/*/*/*/*/4 \n' + removedFieldsMap);

        Boolean selectedKeyValue;
        for(SelectOption selectedField : removedFieldsList) {
            if(removedFieldsMap.containsKey(selectedField)) {
                objectFieldsList.add(selectedField);
                selectedKeyValue = removedFieldsMap.remove(selectedField);
            }
        }

        System.debug('*************/*/*/*/*/*/*/*/*/*/*/5 \n' + removedFieldsMap);

        addedFieldsList.clear();
        addedFieldsList.addAll(removedFieldsMap.keySet());
        addedFieldsList.sort();

    }

    public List<SelectOption> getOrderRadioList() {
        orderRadioList.clear();
        orderRadioList.add(new SelectOption(ASCENDING_VALUE, ASCENDING_LABEL));
        orderRadioList.add(new SelectOption(DESCENDING_VALUE, DESCENDING_LABEL));
        return orderRadioList;
    }

    public List<SelectOption> getRecordCountList() {
        recordCountList.clear();
        recordCountList.add(new SelectOption(RECORDS_500, RECORDS_500));
        recordCountList.add(new SelectOption(RECORDS_1000, RECORDS_1000));
        recordCountList.add(new SelectOption(RECORDS_5000, RECORDS_5000));
        recordCountList.add(new SelectOption(RECORDS_50000, RECORDS_50000));
        return recordCountList;
    }

    public void generateQuery() {

        System.debug('**************/*/*/*/*/*/*/*/7' + addedFieldsList);
        String queryFields = ' Name,';
        displaySelectedFieldsList = new List<String>{'Id','Name'};

        if(selectedObject == 'NULL' || addedFieldsList.isEmpty()) {
            return;
        }

        for(Selectoption selectOptionIterator : addedFieldsList) {
            queryFields += ' ' + selectOptionIterator.getValue() + ',';
            displaySelectedFieldsList.add(selectOptionIterator.getValue());
        }

        queryFields = queryFields.removeEnd(',');

        generatedQuery = 'SELECT '
                       + queryFields
                       + ' FROM '
                       + selectedObject;

        if(String.isNotBlank(selectedFieldToOrderBy)) {
            generatedQuery += ' ORDER BY '
                            + selectedFieldToOrderBy 
                            + ' ' 
                            + selectedOrder;
        }

        generatedQuery += ' LIMIT '
                        + selectedRecordLimit;

        try {
            queryResults = database.Query(generatedQuery);

        } catch(QueryException exceptionInstance) {

           ApexPages.addMessage( new ApexPages.Message(
                ApexPages.Severity.ERROR,
                'Please check the query again!'
            ));

        }

        System.debug('*****************\n\n\n' + queryResults);
    }
}