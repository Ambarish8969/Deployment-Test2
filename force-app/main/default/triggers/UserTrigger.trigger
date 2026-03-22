trigger UserTrigger on User (after insert, after update) {

    if(Trigger.isAfter){
        if(Trigger.isInsert){
           UserTriggerHandler.assignPermissionSet(Trigger.new);
           	UserTriggerHandler.assignPublicGroup(Trigger.new);
        }
        else if(Trigger.isUpdate){
            UserTriggerHandler.updateCaseOwner(Trigger.new, Trigger.oldMap);
        }
    }

}