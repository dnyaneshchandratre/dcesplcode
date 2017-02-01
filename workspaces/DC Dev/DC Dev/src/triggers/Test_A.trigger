trigger Test_A on A__c (after delete, after insert, after undelete, 
after update, before delete, before insert, before update) {
    
    if(Trigger.isbefore && Trigger.isInsert) {
        system.debug(' BEFORE INSERT ');
        system.debug(' BEFORE INSERT OLD  : '+ Trigger.Old);
        system.debug(' BEFORE INSERT NEW  : '+ Trigger.New);
        system.debug(' BEFORE INSERT OLD MAP : '+Trigger.OldMap);
        system.debug(' BEFORE INSERT NEW MAP : '+Trigger.NewMap);
    }


    //   AFTER INSERT    
    if(Trigger.isAfter && Trigger.isInsert)
    {
      system.debug(' AFTER INSERT');
      system.debug(' AFTER INSERT OLD  : '+ Trigger.Old);
        system.debug(' AFTER INSERT NEW  : '+ Trigger.New);
        system.debug(' AFTER INSERT OLD MAP: '+Trigger.OldMap);
        system.debug(' AFTER INSERT NEW MAP: '+Trigger.NewMap);
        
         
    }  
    
    //    BEFORE UPDATE
    if(Trigger.isBefore && Trigger.isUpdate)
    {
      system.debug(' BEFORE UPDATE');
        system.debug(' BEFORE UPDATE OLD  : '+Trigger.Old);
        system.debug(' BEFORE UPDATE NEW  : '+Trigger.New);
        system.debug(' BEFORE UPDATE OLD MAP : '+Trigger.OldMap);
        system.debug(' BEFORE UPDATE NEW MAP : '+Trigger.NewMap);
        
    }
    
    //    AFTER UPDATE
    if(Trigger.isafter && Trigger.isUpdate)
    {
      system.debug(' AFTER UPDATE');
      system.debug(' AFTER UPDATE OLD  : '+Trigger.Old);
        system.debug(' AFTER UPDATE NEW  : '+Trigger.New);
        system.debug(' AFTER UPDATE OLD MAP : '+Trigger.OldMap);
        system.debug(' AFTER UPDATE NEW MAP : '+Trigger.NewMap);
        
    }  
    
    
    //    BEFORE DELETE
    if(Trigger.isbefore && Trigger.isDelete)
    {
      system.debug(' BEFORE DELETE');
      
      system.debug(' BEFORE DELETE OLD  : '+Trigger.Old);
        system.debug(' BEFORE DELETE NEW  : '+Trigger.New);
      system.debug(' BEFORE DELETE OLD MAP : '+Trigger.OldMap);
        system.debug(' BEFORE DELETE NEW MAP : '+Trigger.NewMap);
        
    }  
    
    //   AFTER DELETE
    if(Trigger.isafter && Trigger.isDelete)
    {
      system.debug(' AFTER DELETE ');
      system.debug(' AFTER DELETE OLD  : '+Trigger.Old);
        system.debug(' AFTER DELETE NEW  : '+Trigger.New);
        system.debug(' AFTER DELETE OLD MAP : '+Trigger.OldMap);
        system.debug(' AFTER DELETE NEW MAP : '+Trigger.OldMap);
        
        
    }  
    
    
}