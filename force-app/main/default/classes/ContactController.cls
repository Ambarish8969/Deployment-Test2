public class ContactController {

    @AuraEnabled(cacheable = true)
    public static List<Contact> getContacts(){
        try {
            return [SELECT Id, Name, FirstName, LastName, Email, Phone, Description FROM Contact];
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static void updateContacts(List<Contact> updatedCons){
        try{
            if(!updatedCons.isEmpty()){
                update updatedCons;
            }
        }catch(Exception e){
            throw new AuraHandledException(e.getMessage());
        }
    }
    
}