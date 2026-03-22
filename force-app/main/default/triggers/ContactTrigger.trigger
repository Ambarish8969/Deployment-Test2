trigger ContactTrigger on Contact (after update) {
    
    ContactTriggerHandler.mixedDmlExc(Trigger.new);

}