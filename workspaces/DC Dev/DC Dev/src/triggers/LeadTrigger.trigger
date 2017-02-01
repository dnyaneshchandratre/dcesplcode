trigger LeadTrigger on Lead (after insert) {

    TriggerSetting__c disableTriggerSetting = TriggerSetting__c.getInstance();
    if(disableTriggerSetting.Lead_Trigger__c == true) {
        return;
    }

    if(Trigger.isAfter && Trigger.isInsert) {
        CloneTriggerHandler.cloneLead(Trigger.new);
    }
}