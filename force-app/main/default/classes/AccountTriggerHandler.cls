public class AccountTriggerHandler {
    
    public static void createEntitlements(List<Account> newAccounts){
        
        Map<String, Id> processMap = new Map<String, Id>();
        
        for(SlaProcess process : [SELECT Id, Name FROM SlaProcess]){
            processMap.put(process.Name, process.Id);
        }
        
        List<Entitlement> newEntitlements = new List<Entitlement>();
        
        for(Account newAccount : newAccounts){
            if(newAccount.Support_Level__c == '' || String.isBlank(newAccount.Support_Level__c)){
                return;
            }
            Entitlement newEntitlement = new Entitlement();
            newEntitlement.Name = newAccount.Name+' Entitlement';
            newEntitlement.AccountId = newAccount.Id;
            newEntitlement.StartDate = Date.today();
            newEntitlement.EndDate = Date.today().addDays(365);
            if(newAccount.Support_Level__c == 'Gold' && processMap.containsKey('Gold Support')){
                newEntitlement.SlaProcessId = processMap.get('Gold Support');
            }else if(newAccount.Support_Level__c == 'Standard' && processMap.containsKey('Standard Support')){
                newEntitlement.SlaProcessId = processMap.get('Standard Support');
            }
            newEntitlements.add(newEntitlement);
        }
        
		insert newEntitlements;       
    }

}