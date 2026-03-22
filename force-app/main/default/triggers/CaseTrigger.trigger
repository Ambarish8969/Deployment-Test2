trigger CaseTrigger on Case (after insert, after update, after delete, after undelete) {

    if(Trigger.isAfter){
        if(Trigger.isInsert || Trigger.isUndelete){
            CaseTriggerHandler.updateAccRating(Trigger.new, null);
        }
        else if(Trigger.isUpdate){
            CaseTriggerHandler.updateAccRating(Trigger.new, Trigger.oldMap);
        }
        else if(Trigger.isDelete){
            CaseTriggerHandler.updateAccRating(Trigger.old, null);
        }
    }
}