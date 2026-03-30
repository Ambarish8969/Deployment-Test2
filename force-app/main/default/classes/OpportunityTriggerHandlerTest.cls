@isTest
public class OpportunityTriggerHandlerTest{
	
	@testSetup
    public static void updateMaxOppTest(){
        List<Account> accList = new List<Account>();
        List<Opportunity> oppList  = new List<Opportunity>();

        Account acc1 = new Account(Name='Test Acc1');
        Account acc2 = new Account(Name='Test Acc2');
        
        accList.addAll(new List<Account>{acc1, acc2});
        
        insert accList;

        Opportunity opp1 = new Opportunity(Name = 'Test Opp 1', StageName = 'Prospecting', CloseDate = Date.today());
        Opportunity opp2 = new Opportunity(Name = 'Test Opp 2', StageName = 'Qualification', CloseDate = Date.today().addDays(10));
        Opportunity opp3 = new Opportunity(Name = 'Test Opp 3', StageName = 'Closed Won', CloseDate = Date.today().addDays(20));

        oppList.addAll(new List<Opportunity>{opp1, opp2, opp3});

        insert oppList;
        
    }

    @isTest
    public static void validateDataTest1(){

        Opportunity opp1 = [SELECT Id, Name, StageName, CloseDate FROM Opportunity WHERE Name = 'Test Opp 1'];

        opp1.StageName = 'Closed Won';

        Test.startTest();
        try{
            update opp1;
            System.debug(opp1.StageName);
        }catch(Exception e){
            System.assertEquals(true, e.getMessage().contains('Stage cannot be changed from Prospecting to Closed Won'),'When updating to Closed Won it should throw an Error');
        }
        
        Test.stopTest();

    }
    @isTest
    public static void validateDataTest2(){

        Opportunity opp2 = [SELECT Id, Name, StageName, CloseDate FROM Opportunity WHERE Name = 'Test Opp 2'];

        opp2.Amount = 2000;

        Test.startTest();
        try{
            update opp2;
        }catch(Exception e){
            System.assertEquals(true, e.getMessage().contains('Amount should be greater than 10000'),'When updating to Amount it should throw an Error');
        }
        
        Test.stopTest();

    }
    @isTest
    public static void validateDataTest3(){

        Opportunity opp3 = [SELECT Id, Name, StageName, CloseDate FROM Opportunity WHERE Name = 'Test Opp 3'];

        opp3.CloseDate = Date.today().addDays(-30);

        Test.startTest();
        try{
            update opp3;
        }catch(Exception e){
            System.assertEquals(true, e.getMessage().contains('Close Date cannot be less than today'),'When updating to Close Date it should throw an Error');
        }
        
        Test.stopTest();

    }
}