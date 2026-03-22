trigger AccountTrigger on Account (after insert, after update) {
    
    if(Trigger.isAfter && Trigger.isInsert){
        AccountTriggerHandler.createEntitlements(Trigger.new);
    }else if(Trigger.isAfter && Trigger.isUpdate){
        List<Account> updatedAccounts = new List<Account>();
        for(Account acc : Trigger.new){
            if((acc.Support_Level__c != Trigger.oldMap.get(acc.Id).Support_Level__c) && 
               (Trigger.oldMap.get(acc.Id).Support_Level__c != 'Gold' || Trigger.oldMap.get(acc.Id).Support_Level__c != 'Standard') ){
                   updatedAccounts.add(acc);
               }
        }
        AccountTriggerHandler.createEntitlements(updatedAccounts);
    }

}