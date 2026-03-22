@isTest
public class OpportunityTriggerHandlerTest{
	
	@testSetup
    public static void updateMaxOppTest(){
        Account acc1 = new Account(Name='Test Acc1');
        Account acc2 = new Account(Name='Test Acc2');
        
        List<Account> accList = new List<Account>();
        accList.addAll(new List<Account>{acc1, acc2});
        
        insert accList;
        
    }
}