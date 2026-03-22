public class CutomObject1TriggerHandler {

    public static void updateContactOwner(List<Custom_Object1__c> newAccounts, Map<Id, Custom_Object1__c> oldAccMap){

        Set<Id> accIds = new Set<Id>();
        Map<Id, Id> accIdMap = new Map<Id, Id>();
        List<Custom_Object2__c> conListUpdate = new List<Custom_Object2__c>();

        if(!newAccounts.isEmpty()){
            for(Custom_Object1__c newAccount : newAccounts){
                Custom_Object1__c oldAccount = oldAccMap.get(newAccount.Id);
                if(oldAccount.OwnerId != newAccount.OwnerId){
                    accIdMap.put(newAccount.Id, newAccount.OwnerId);
                    accIds.add(newAccount.Id);
                }
            }
        }

        List<Custom_Object2__c> cons = [SELECT Id, Custom_Object1__c, OwnerId FROM Custom_Object2__c WHERE Custom_Object1__c IN :accIds];

        for(Custom_Object2__c con : cons){
            if(accIdMap.containsKey(con.Custom_Object1__c)){
                con.OwnerId = accIdMap.get(con.Custom_Object1__c);
                conListUpdate.add(con);
            }
        }

        if(!conListUpdate.isEmpty()){
            update conListUpdate;
        }

    }

}