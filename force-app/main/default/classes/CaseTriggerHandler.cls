public class CaseTriggerHandler {
    
    public static void updateAccRating(List<Case> newCases, Map<Id, Case> oldCaseMap){
        Set<Id> accIds = new Set<Id>();
        
        if(!newCases.isEmpty()){
            for(Case newCase : newCases){
                if(oldCaseMap != null){
                    Case oldCase = oldCaseMap.get(newCase.Id);
                    if(oldCase.AccountId != newCase.AccountId){
                        accIds.add(oldCase.AccountId);
                        accIds.add(newCase.AccountId);
                    }
                    else if(oldCase.IsClosed != newCase.IsClosed){
                        accIds.add(newCase.AccountId);
                    }
                }
                else if(newCase.IsClosed == true){
                    accIds.add(newCase.AccountId);
                }
            }
        }
        
        Map<Id, Integer> accCaseMap = new Map<Id, Integer>();
        
        for(AggregateResult result : [SELECT AccountId, COUNT(Id) caseCount FROM Case WHERE AccountId IN :accIds AND Status = 'Closed' GROUP BY AccountId]){
            accCaseMap.put((Id)result.get('AccountId'), (Integer)result.get('caseCount'));
        }
        
        List<Account> accToUpdate = new List<Account>();
        
        for(Id accId : accCaseMap.keySet()){
            Account acc = new Account(Id=accId);
            if(accCaseMap.get(accId) > 5){
                acc.Rating = 'Hot';
                accToUpdate.add(acc);
            }
            else if(accCaseMap.get(accId) > 2){
                acc.Rating = 'Warm';
                accToUpdate.add(acc);
            }
            else{
                acc.Rating = 'Cold';
                accToUpdate.add(acc);
            }
        }
        
        if(!accToUpdate.isEmpty()){
            update accToUpdate;
        }
    }

}