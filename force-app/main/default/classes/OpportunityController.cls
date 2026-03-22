public class OpportunityController {

    @AuraEnabled 
    public static List<Opportunity> getOpps(){
        return [SELECT Id, Name, StageName, CloseDate FROM Opportunity LIMIT 20];
    }

    @AuraEnabled
    public static void updateOppFields(List<Opportunity> oppsFields){
        try {
            update oppsFields;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    
}