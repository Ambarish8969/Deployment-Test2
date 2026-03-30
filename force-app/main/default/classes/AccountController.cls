public class AccountController {

    @AuraEnabled(cacheable = true)
    public static List<Account> getAccounts(){
        return [SELECT Id, Name, Industry, Website FROM Account WHERE Industry != null LIMIT 100];
    }

    @AuraEnabled
    public static void udpateAccounts(List<Account> accList){
        try{
            update accList;
        }
        catch(Exception e){
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static List<Account> getSearchedAccs(String keyword){
        keyword = '%'+keyword+'%';
        return [SELECT Id, Name, Industry, Website 
            FROM Account 
            WHERE Name LIKE :keyword 
            WITH USER_MODE];
    }

    @AuraEnabled
    public static List<Account> getAllAccounts(Integer limitSize, Integer offset){
        try {
            return [SELECT Id,Name,Rating, Industry FROM Account ORDER BY CreatedDate LIMIT 20 OFFSET :offset];
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
	public static void updateAccounts(List<Account> updatedAccs){
		try{
			if(!updatedAccs.isEmpty()){
				update updatedAccs;
			}
		}
		catch(Exception e){
			throw new AuraHandledException(e.getMessage());
		}
	}

	@AuraEnabled
	public static void deleteAccs(List<Id> accIds){
		try{
			if(!accIds.isEmpty()){
				List<Account> accs = new List<Account>();
				for(Id accId : accIds){
					accs.add(new Account(Id=accId));
				}
				delete accs;
			}
		}
		catch(Exception e){
			throw new AuraHandledException(e.getMessage());
		}
	}

    @AuraEnabled(cacheable = true)
    public static Account getAccountByName(String accName){
        try {
            List<Account> accList;
            if(accName != ''){
                accName = '%'+accName+'%';
                accList = [SELECT Id, Name, Industry FROM Account WHERE Name LIKE :accName LIMIT 1];
                
            }
            return accList[0];
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}