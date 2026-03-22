public class TestDataFactory {
    
    public static User createUser(){
        Profile testProfile = [SELECT Id, Name FROM Profile WHERE Name = 'System Administrator' LIMIT 1];

        User u = new User(Alias = 'standt', Email='standarduser@testclasses.com', 
            EmailEncodingKey='UTF-8', LastName='TestUser', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = testProfile.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='lodustandarduser@testclasses.com');

        return u;
    }
    
    public static Account createAccountWithIndustry(String industryName){
        Account indAcc = new Account();
        indAcc.Name = 'Industry '+industryName+' Account';
        indAcc.Industry = industryName;
        
        insert indAcc;
        return indAcc;
    }
    
}