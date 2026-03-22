public class AccountTriggerHandler {
    
    public static void preventDeletion(List<Account> oldAccs){
        Set<Id> accIds = new Set<Id>();
        Map<Id, Integer> accMap = new Map<Id, Integer>();
        
        if(!oldAccs.isEmpty()){
            for(Account oldAcc : oldAccs){
                accIds.add(oldAcc.Id);
            }
        }
        
        List<AggregateResult> results = [SELECT AccountId, COUNT(Id) conCount FROM Contact WHERE AccountId IN :accIds GROUP BY AccountId];
        
        for(AggregateResult result : results){
            accMap.put((Id)result.get('AccountId'), (Integer)result.get('conCount'));
        }
        
        for(Account oldAcc : oldAccs){
            if(accMap.containsKey(oldAcc.Id) && accMap.get(oldAcc.id) > 0){
                oldAcc.addError('Account cannot be deleted if it has active contacts');
            }
        }
    }
    
    public static void createAgriOpp(List<Account> newAccs, Map<Id, Account> oldAccMap){
        
        List<Opportunity> newOppList = new List<Opportunity>();
        
        if(!newAccs.isEmpty()){
            if(oldAccMap != null){
                for(Account newAcc : newAccs){
                    Account oldAcc = oldAccMap.get(newAcc.Id);
                    if(newAcc.Industry == 'Agriculture' && (oldAcc.Industry != newAcc.Industry)){
                        Opportunity newOpp = new Opportunity();
                        newOpp.Name = newAcc.Name + ' Opp 1';
                        newOpp.AccountId = newAcc.Id;
                        newOpp.StageName = 'Prospecting';
                        newOpp.CloseDate = Date.today().addDays(90);
                        newOpp.Amount = 0;
                        newOppList.add(newOpp);
                    }
            	}
            }
            else if(oldAccMap == null){
                for(Account newAcc : newAccs){
                    if(newAcc.Industry == 'Agriculture'){
                        Opportunity newOpp = new Opportunity();
                        newOpp.Name = newAcc.Name + ' Opp 1';
                        newOpp.AccountId = newAcc.Id;
                        newOpp.StageName = 'Prospecting';
                        newOpp.CloseDate = Date.today().addDays(90);
                        newOpp.Amount = 0;
                        newOppList.add(newOpp);
                    }
            	}
            }
        }
        
        if(!newOppList.isEmpty()){
            insert newOppList;
        }
    }
    
    public static void preventDuplicates(List<Account> newAccounts){
        Set<String> accNames = new Set<String>();
        
        if(!newAccounts.isEmpty()){
            for(Account newAccount : newAccounts){
                accNames.add(newAccount.Name);
            }
        }
        
        List<AggregateResult> results = [SELECT Name, COUNT(Id) countacc FROM Account WHERE Name IN :accNames GROUP BY Name];
        Map<String, Integer> accMap = new Map<String, Integer>();
        
        for(AggregateResult result : results){
            accMap.put((String)result.get('Name'),(Integer)result.get('countacc'));
        }
        
        for(Account newAccount : newAccounts){
            if(accMap.keySet().contains(newAccount.Name)){
                newAccount.addError('Account is already present with the same name');
            }
        }
    }
    
    public static void setDefaultIndustry(List<Account> newAccounts){
		for(Account newAccount : newAccounts){
			if(newAccount.Industry == null || String.isBlank(newAccount.Industry)){
				newAccount.Industry = 'Banking';
			}
		}
	}
    /*
    @future(callout = true)
    public static void getData(List<Id> newAccounts){
        //System.debug('-------------Started-----------');
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://api.api-ninjas.com/v1/passwordgenerator?length=5');
        req.setMethod('GET');
        req.setHeader('X-Api-Key','I8qlnwE1ayBN7N+nk6+/ew==2GE8JvQndf56x62a');
        
        HttpResponse res = http.send(req);
        System.debug('Response: '+res);
        
        List<Account> accs = [SELECT Id, Name, Description FROM Account WHERE Id IN :newAccounts];
        
        for(Account newAccount :accs ){
            newAccount.Description = res.getBody();
        }
        update accs;
        //System.debug('-------------Stopped-----------');
    }*/

}