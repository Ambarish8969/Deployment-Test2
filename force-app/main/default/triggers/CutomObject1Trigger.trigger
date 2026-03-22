trigger CutomObject1Trigger on Custom_Object1__c (after update) {

    CutomObject1TriggerHandler.updateContactOwner(Trigger.new, Trigger.oldMap);

}