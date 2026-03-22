@isTest
public class CutomObject1TriggerHandlerTest {

    @testSetup
    static void makeData(){

        Profile testProfile = [SELECT Id, Name FROM Profile WHERE Name = 'System Administrator' LIMIT 1];

        User standardUser = new User(Alias = 'standt', Email='standarduser@testclasses.com', 
            EmailEncodingKey='UTF-8', LastName='TestUser', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = testProfile.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='lodustandarduser@testclasses.com');
        
        //insert standardUser;

        System.runAs(standardUser){
            Custom_Object1__c obj1 = new Custom_Object1__c(Name='TestName 1');
            insert obj1;

            Custom_Object2__c obj2 = new Custom_Object2__c(Name='TestName 2', Custom_Object1__c=obj1.Id);
            insert obj2;
        }    
        
    }

    @isTest
    public static void updateOwnerTest(){

        Custom_Object1__c testRec1 = [SELECT Id, Name, OwnerId FROM Custom_Object1__c LIMIT 1];
        Custom_Object2__c testRec2 = [SELECT Id, Name, OwnerId FROM Custom_Object2__c LIMIT 1];

        Test.startTest();
        testRec1.OwnerId = System.UserInfo.getUserId();
        update testRec1;
        Test.stopTest();

        System.assertEquals(System.UserInfo.getUserId(), testRec1.OwnerId, 'Owner should be same for record1.');
        System.assertEquals(System.UserInfo.getUserId(),[SELECT Id, OwnerId FROM Custom_Object2__c LIMIT 1].OwnerId, 'Owner should be same for record2.');

    }
    
    @isTest
    public static void fieldUpdateTest(){
        Custom_Object2__c testRec1 = [SELECT Id, Name, OwnerId FROM Custom_Object2__c LIMIT 1];
        
        testRec1.OwnerId = System.UserInfo.getUserId();
        update testRec1;

        Test.startTest();
        testRec1.Name = 'Testing Name 3';
        update testRec1;
        Test.stopTest();

        Custom_Object1__c testRec2 = [SELECT Id, Name, OwnerId FROM Custom_Object1__c LIMIT 1];
        Custom_Object2__c testRec3 = [SELECT Id, Name, OwnerId FROM Custom_Object2__c LIMIT 1];

        System.assertNotEquals(testRec2.OwnerId, testRec3.OwnerId, 'Owner should not be same.');
    }
}