trigger AccountTrigger on Account (after insert, after update,before insert, before delete) {
    
    if(Trigger.isBefore && Trigger.isInsert){
        AccountTriggerHandler.preventDuplicates(Trigger.new);
        AccountTriggerHandler.setDefaultIndustry(Trigger.new);
    }
    else if(Trigger.isAfter && Trigger.isInsert){
        List<Id> accIds = new List<Id>();
        for(Account acc : Trigger.new){
            accIds.add(acc.Id);
        }
       // AccountTriggerHandler.getData(accIds);
        AccountTriggerHandler.createAgriOpp(Trigger.new, null);
    }
    else if(Trigger.isAfter && Trigger.isUpdate){
        AccountTriggerHandler.createAgriOpp(Trigger.new, Trigger.oldMap);
    }
    else if(Trigger.isBefore && Trigger.isDelete){
        AccountTriggerHandler.preventDeletion(Trigger.old);
    }

}