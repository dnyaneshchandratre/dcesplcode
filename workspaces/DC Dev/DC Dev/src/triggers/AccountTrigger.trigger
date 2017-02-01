trigger AccountTrigger on Account (before insert,
                                   before update,
                                   before delete,
                                   after insert,
                                   after update,
                                   after delete,
                                   after undelete) {

    TriggerSetting__c disableTriggerSetting = TriggerSetting__c.getInstance();

    if(disableTriggerSetting.Account_Trigger__c == true) {
        return;
    }

    if(Trigger.isBefore) {
        if(Trigger.isInsert) {
            AccountTriggerHandler.debugTriggerNew(Trigger.new);
        }
        if(Trigger.isUpdate) {
            AccountTriggerHandler.debugTriggerNew(Trigger.new);
            AccountTriggerHandler.debugTriggerNewMap(Trigger.newMap);
            AccountTriggerHandler.debugTriggerNew(Trigger.old);
            AccountTriggerHandler.debugTriggerNewMap(Trigger.oldMap);
        }
        if(Trigger.isDelete) {
            AccountTriggerHandler.debugTriggerNew(Trigger.old);
            AccountTriggerHandler.debugTriggerNewMap(Trigger.oldMap);
        }
    }

    if(Trigger.isAfter) {
        if(Trigger.isInsert) {
            createTaskHandler.createTask(Trigger.new);
            AccountTriggerHandler.debugTriggerNew(Trigger.new);
            AccountTriggerHandler.debugTriggerNewMap(Trigger.newMap);
        }
        if(Trigger.isUpdate) {
            AccountTriggerHandler.debugTriggerNew(Trigger.new);
            AccountTriggerHandler.debugTriggerNewMap(Trigger.newMap);
            AccountTriggerHandler.debugTriggerNew(Trigger.old);
            AccountTriggerHandler.debugTriggerNewMap(Trigger.oldMap);
        }
        if(Trigger.isDelete) {
            AccountTriggerHandler.debugTriggerNew(Trigger.old);
            AccountTriggerHandler.debugTriggerNewMap(Trigger.oldMap);
        }
        if(Trigger.isUndelete) {
            AccountTriggerHandler.debugTriggerNew(Trigger.new);
            AccountTriggerHandler.debugTriggerNewMap(Trigger.newMap);
        }
    }
}