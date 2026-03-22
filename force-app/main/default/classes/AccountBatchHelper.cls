public class AccountBatchHelper {
    
    @InvocableMethod(label='Run Account Batch')
    public static List<String> executeAccBatch(){
        List<String> jobIds = new List<String>();
        Id jobId = Database.executeBatch(new AccountUpdateBatch());
        jobIds.add((String)jobId);
        
        return jobIds;
    }

}