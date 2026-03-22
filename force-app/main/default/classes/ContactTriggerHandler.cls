public class ContactTriggerHandler {
    
    public static void mixedDmlExc(List<Contact> newCons){
        insert new Account(Name='Mixed Account');
        
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User' LIMIT 1];

        // 2. Initialize the User object
        User u = new User(
            //Id = '005fj00000Bv3KbAAJ',
            FirstName         = 'Satoshi',
            LastName          = 'Nakamoto',
            Email             = 'satoshi@example.com',
            Username          = 'satoshi.2' + DateTime.now().getTime() + '@example.com', // Must be unique across all SF orgs
            Alias             = 'sna',                                               // Max 8 characters
            TimeZoneSidKey    = 'America/Los_Angeles',
            LocaleSidKey      = 'en_US',
            EmailEncodingKey  = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            ProfileId         = p.Id
        );
        
        // 3. Insert the record
        insert u;
    }
    
    public static void preventEmailUpdation(List<Contact> newContacts, Map<Id, Contact> oldContactsMap){
        
        if(!newContacts.isEmpty()){
            for(Contact newContact : newContacts){
                Contact oldContact = oldContactsMap.get(newContact.Id);
                    if(oldContact.Email != newContact.Email){
                        newContact.addError('Contact Email can not be updated once set');
                    }
            }
        }
    }
    
    public static void preventDuplication(List<Contact> newContacts){
        
		// Collect all emails from incoming records
        Set<String> emailSet = new Set<String>();
        for (Contact con : newContacts) {
            if (con.Email != null) {
                emailSet.add(con.Email.toLowerCase());
            }
        }

        // Query existing contacts with these emails
        List<AggregateResult> aggResults = [
            SELECT Email, COUNT(Id) cnt
            FROM Contact
            WHERE Email IN :emailSet
            GROUP BY Email
        ];

        // Map email -> existing count
        Map<String, Integer> emailCountMap = new Map<String, Integer>();
        for (AggregateResult ar : aggResults) {
            emailCountMap.put(((String)ar.get('Email')).toLowerCase(), (Integer)ar.get('cnt'));
        }

        // Validate new contacts
        for (Contact con : newContacts) {
            if (con.Email != null) {
                String emailKey = con.Email.toLowerCase();
                Integer existingCount = emailCountMap.containsKey(emailKey) ? emailCountMap.get(emailKey) : 0;

                // If existing count is 2 or more, block the new one
                if (existingCount >= 2) {
                    con.addError('Cannot insert/update: There are already two contacts with this email.');
                }
            }
        }
    }

}