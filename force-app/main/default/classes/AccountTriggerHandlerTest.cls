@isTest
private class AccountTriggerHandlerTest {
    
    @isTest
    static void preventDeletionTestPositive(){
        Account acc = TestDataFactory.createAccountWithIndustry('Banking');
        
        Contact con = new Contact();
        con.LastName = 'Test Con';
        con.AccountId = acc.Id;
        insert con;
        
        Test.startTest();
        try{
            delete acc;
        }
        catch(Exception e){
            System.assert(e.getMessage().contains('Account cannot be deleted if it has active contacts'), 'Account cannot be deleted if it has active contacts');
            List<Account> accList = [SELECT Id, Name FROM Account WHERE Id = :acc.Id];
        	System.assertEquals(1, accList.size(),'Size should match');
        }
        Test.stopTest();
        
    }
    
    @isTest
    static void preventDeletionTestNegative(){
        Account acc = TestDataFactory.createAccountWithIndustry('Banking');
        
        Test.startTest();
        try{
            delete acc;
        }
        catch(Exception e){
            System.assertEquals(0,[SELECT Id, Name FROM Account WHERE Id = :acc.Id].size(),'Account should be deleted.');
        }
        Test.stopTest();
    }
    
    @isTest
    static void createAgriOppInsertTest(){
        Test.startTest();
		Account indAcc = TestDataFactory.createAccountWithIndustry('Agriculture'); 
        Test.stopTest();
        
        List<Opportunity> opp = [SELECT Id, Name FROM Opportunity WHERE AccountId = :indAcc.Id];
        System.assertEquals(1, opp.size(),'Should Have one opportunity');
        System.assertEquals('Industry Agriculture Account Opp 1', opp[0].Name, 'Opp name should Match');
    }
    
    @isTest
    static void createAgriOppUpdateTest(){
        Account indAcc = TestDataFactory.createAccountWithIndustry('Banking'); 
        
        Test.startTest();
		indAcc.Industry = 'Agriculture';
        update indAcc;
        Test.stopTest();
        
        List<Opportunity> opp = [SELECT Id, Name FROM Opportunity WHERE AccountId = :indAcc.Id];
        Account acc = [SELECT Id, Name, Industry FROM Account WHERE Id = :indAcc.Id];
        
        System.assertEquals('Agriculture', acc.Industry,'Industry should Match.');
        System.assertEquals(1, opp.size(), 'Opp size should Match');
    }
    
    @isTest
    private static void preventDuplicateTest(){
        Account acc1 = new Account(Name = 'Test 1');
        insert acc1;
        
        Account acc2 = new Account(Name = 'Test 1');
        Account acc3 = new Account(Name = 'Test 2');
        
        Test.startTest();
        try{
            insert acc2;
        }
        catch(Exception e){
            System.assert(true, e.getMessage().contains('Account is already present with the same name'));
        }
        insert acc3;
        System.assertEquals('Test 2',[SELECT Name FROM Account WHERE Name = 'Test 2'][0].Name);
        Test.stopTest();
    }
    
    @isTest
	private static void setDefaultIndustryTest(){
		
		Account acc1 = new Account(Name='Test Acc');
		
		try{
			insert acc1;
		}
		catch(Exception e){
			System.assertEquals('Banking',[SELECT Industry FROM Account WHERE Name = 'Test Acc'][0].Industry);
		}
	}
    

}