trigger OpportunityTrigger on Opportunity(after insert, after update, after delete, before delete){
	
    if(Trigger.isAfter){
        // if(Trigger.isInsert){ 
        //     OpportunityTriggerHandler.updateMaxOpp(Trigger.new, null);
        // }
        // else if(Trigger.isUpdate){
        //     OpportunityTriggerHandler.updateMaxOpp(Trigger.new, Trigger.oldMap);
        // }
        // else if(Trigger.isDelete){
        //     OpportunityTriggerHandler.updateMaxOpp(Trigger.old, null);
        // }
    }
    else if(Trigger.isBefore){
        if(Trigger.isDelete){
            OpportunityTriggerHandler.preventDeletion(Trigger.old);
        }
    }

}