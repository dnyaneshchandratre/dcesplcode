public with sharing class JsonToRecordCreator implements 
    Database.Batchable<sObject>, Database.Stateful, Schedulable {

    // IS STATEFUL AND SCHEDULABLE NEEDED ??? [Yes]

    // INDENT QUERY AS IN DailyOpportunityStatus CLASS [Done]
    public final static String QUERY = 'SELECT Name,'
                                     + '       JSON__c,' 
                                     + '       Processed__c' 
                                     + '  FROM Event__c '
                                     + ' WHERE Processed__c = false';

    public List<sObject> listRecords = new List<sObject>();
    Map<String, Object> recordCreatorMap = new Map<String, Object>();
    SObject newRecord;

    // PARAMETER NAME [Done]
    public Database.QueryLocator start(Database.BatchableContext batchableContextInstance) {
        System.debug('<<<<<<<<< IN START >>>>>>>>>>');
        return Database.getQueryLocator(QUERY);
    }

    public void execute(Database.BatchableContext batchableContextInstance, List<Event__c> eventList) {

        System.debug('<<<<<<<<< IN EXECUTE >>>>>>>>>>');

        // ITERATOR SHOULD BE SIMPLE NAME OF OBJECT -> event [Done]
        for(Event__c event : eventList) {

            // DIFFERENCE BETWEEN deserializeUntyped AND deserialize
            recordCreatorMap = (Map<String, Object>)Json.deserializeUntyped(event.JSON__c);
            if(NULL <> Schema.getGlobalDescribe().get(event.Name)) {
                newRecord = Schema.getGlobalDescribe().get(event.Name).newSObject();
             
                for(String fieldName : recordCreatorMap.keySet()) {
	                newRecord.put( fieldName,
    	                           recordCreatorMap.get(fieldName) );
	            }

    	        listRecords.add(newRecord);
        	    event.Processed__c = true;

        	}
        }

        if(!listRecords.isEmpty()) {
            update eventList;
            insert listRecords;

        }
    }

    public void execute(SchedulableContext schedulableContextInstance) {}

    public void finish(Database.BatchableContext batchableContextInstance) {

        System.debug('<<<<<<<<< IN FINISH >>>>>>>>>>');

    }
}