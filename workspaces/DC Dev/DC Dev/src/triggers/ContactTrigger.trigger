trigger ContactTrigger on Contact (before insert, before update, after insert) {

    TriggerSetting__c disableTriggerSetting = TriggerSetting__c.getInstance();

    if(disableTriggerSetting.Contact_Trigger__c == true) {

        return;

    }

    if(Trigger.isBefore && (Trigger.isInsert || Trigger.isUpdate)) {

        ContactTriggerHandler.updateAccountLookup(Trigger.new);

    }

    if(Trigger.isAfter && Trigger.isInsert) {

        ContactTriggerHandler.populatePrimaryContact(Trigger.new);

    }
}