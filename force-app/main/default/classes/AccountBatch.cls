public class AccountBatch implements Database.Batchable<sObject>, Database.Stateful{
    
    public Integer count = 0;
    
    public Database.QueryLocator start(Database.BatchableContext bc){
        return Database.getQueryLocator('SELECT Id, Name, Active__c FROM Account');
    }
    
    public void execute(Database.BatchableContext bc, List<Account> accs){
        /*
        List<Contact> contactsInsert = new List<Contact>();
        for(Account acc : accs){
            Contact newCon = new Contact();
            newCon.AccountId = acc.Id;
            newCon.LastName = acc.Name = 'Contact' + count;
        }
        
        insert contactsInsert;
        */
        
		Profile communityProfile = [
            SELECT Id 
            FROM Profile 
            WHERE Name = 'Customer Community User' 
            LIMIT 1
        ];
        
        // 2. Create an Account (or query existing one)
        Account acc = new Account(
            Name = 'Test Customer Account 2'
        );
        insert acc;
        
        // 3. Create a Contact for that Account
        Contact con = new Contact(
            FirstName = 'Test',
            LastName  = 'CommunityUser 2',
            Email     = 'test.communityuser@example.com',
            AccountId = acc.Id
        );
        insert con;
        
        // 4. Create the User linked to the Contact
        User u = new User();
        u.FirstName          = con.FirstName;
        u.LastName           = con.LastName;
        u.Alias              = 'tcus';
        u.Email              = con.Email;
        u.Username           = 'test.communityuser2+' + DateTime.now().getTime() + '@example.com';
        u.CommunityNickname  = 'tcustomeruser';
        u.TimeZoneSidKey     = 'Asia/Kolkata';
        u.LocaleSidKey       = 'en_IN';
        u.EmailEncodingKey   = 'UTF-8';
        u.LanguageLocaleKey  = 'en_US';
        u.ProfileId          = communityProfile.Id;
        u.ContactId          = con.Id;
        u.IsActive           = true;

        insert u;


    }
    
    public void finish(Database.BatchableContext bc){
        /*
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[]{'ambarish1350@gmail.com'};
        email.setToAddresses(toAddresses);
        email.setSubject('Accounts Executed');
        email.setPlainTextBody(count + ' Account Executed, Salesforce Team.');
        
        Messaging.sendEmail(new Messaging.SingleEmailMessage[]{email});
		*/
    }

}