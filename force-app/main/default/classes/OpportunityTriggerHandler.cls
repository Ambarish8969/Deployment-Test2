public class OpportunityTriggerHandler{
    
    public static void preventDeletion(List<Opportunity> oldOpps){
        
        Profile adminProfile = [SELECT Id, Name FROM Profile WHERE Name = 'System Administrator'];
        
        if(!oldOpps.isEmpty()){
            for(Opportunity opp : oldOpps){
                if(System.UserInfo.getProfileId() != adminProfile.Id && (opp.StageName == 'Closed Won')){
                    System.debug('User ProfileId: '+UserInfo.getProfileId());
                    System.debug('Admin ProfileId: '+adminProfile.Id);
                    opp.addError('Only System Admin can delete this Opportunity');
                }
            }
        }
    }
    
    public static void updateMaxOpp(List<Opportunity> newOpps, Map<Id, Opportunity> oldOppMap){
        Set<Id> accIds = new Set<Id>();
        
        if(!newOpps.isEmpty()){
            if(oldOppMap != null){
                for(Opportunity newOpp : newOpps){
                    Opportunity oldOpp = oldOppMap.get(newOpp.Id);
                    if((oldOpp.Amount != newOpp.Amount)||(oldOpp.AccountId != newOpp.AccountId)){
                        accIds.add(newOpp.AccountId);
                        accIds.add(oldOpp.AccountId);
                    }
                }
            }
            else{
                for(Opportunity newOpp : newOpps){
                    accIds.add(newOpp.AccountId);
                }
            }
        }
        
        List<Account> results = [select Id, (select Name from Opportunities Order By Amount desc limit 1) from Account WHERE Id IN :accIds];
        
        Map<Id, String> accOppMap = new Map<Id, String>();
        
        for(Account result : results){
            accOppMap.put((Id)result.get('Id'),(String)result.Opportunities[0].Name);
        }
        
        List<Account> accToUpdate = new List<Account>();
        
        for(Id accId : accOppMap.keySet()){
            Account acc = new Account(Id=accId, MaxOpp__c= accOppMap.get(accId));
            accToUpdate.add(acc);
        }
        
        if(!accToUpdate.isEmpty()){
            update accToUpdate;
        }
        
    }
    
    public static void validateData(List<Opportunity> newOpps, Map<Id, Opportunity> oldOppMap){
        
        if(!newOpps.isEmpty()){
            if(oldOppMap != null){
                for(Opportunity newOpp : newOpps){
                    Opportunity oldOpp = oldOppMap.get(newOpp.Id);
                    if(newOpp.CloseDate < Date.today()){
                        newOpp.addError('Close Date cannot be less than today');
                    }
                    else if(oldOpp.StageName == 'Prospecting' && newOpp.StageName == 'Closed Won'){
                        newOpp.addError('Stage cannot be changed from Prospecting to Closed Won');
                    }
                    else if(newOpp.Amount <= 10000){
                        newOpp.addError('Amount should be greater than 10000');
                    }
                }
            }
        }
    }
}