public class AccountUpdateBatch implements Database.Batchable<sObject>, Database.Stateful {
    
    public Integer recordProcessed = 0;
    
    List<Id> accIds = new List<Id>();
    
    public Database.queryLocator start(Database.BatchableContext bc){
        return Database.getQueryLocator('SELECT Id, Name, Description FROM Account');
    }
    
    public void execute(Database.BatchableContext bc, List<Account> scope){
        List<Account> accRecs = new List<Account>();
        if(!scope.isEmpty()){
            for(Account acc : scope){
                //acc.Description = 'Updated,';
                //accRecs.add(acc);
                recordProcessed++;
                
                accIds.add(acc.Id);
            }
        }
        
       // update accRecs;
    }
    
    public void finish(Database.BatchableContext bc){
      //  System.debug('AccountUpdateBatch finished');
       // System.debug('Records Processed: '+recordProcessed);
       // 
       	AsyncApexJob job = [SELECT Id, NumberOfErrors, TotalJobItems, JobItemsProcessed, CreatedBy.Email FROM AsyncApexJob WHERE Id = :bc.getJobId()];
       	Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setToAddresses(new String[]{job.CreatedBy.Email});
        mail.setSubject('Batch Completed with: '+job.TotalJobItems);
        mail.setPlainTextBody('The Batch processed '+job.JobItemsProcessed+' and failures '+job.NumberOfErrors);
        
        Messaging.sendEmail(new Messaging.SingleEmailMessage[]{mail});
        
        System.debug('------AccIds-----');
        System.debug(accIds);
    }

}