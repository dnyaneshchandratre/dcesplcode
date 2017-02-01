trigger CaseTrigger on Case (before insert, before update) {

    // CHANGE THE NAME disableTriggerInstance [Done]
    // CHECK SETTING FOR TRUE VALUE AND RETURN
    if(TriggerSetting__c.getInstance().Case_Update_Trigger__c == true) {
        return;
    }

    else {
        // NO NEED TO CHECK FOR TWO DIFFERENT CONDITIONS [Done]
        // AS SAME METHOD FROM HANDLER IS BEING CALLED [Done]
        // IF(TRIGGER.ISBEFORE && (TRIGGER.ISINSERT || TRIGGER.ISUPDATE)) [Done]
        if(Trigger.isBefore && (Trigger.isInsert || Trigger.isUpdate)) {
            System.debug('*/*/*/*//*/*/*/*/*/ IN TRIGGER */*/*/*/*/*/*/*/*/*/');
            CaseTriggerHandler.updateCase(Trigger.new);
        }

    }

}