@isTest
public class UserTriggerHandlerTest {

    @testSetup
    static void makeData(){
        CollaborationGroup usersChatterGroup = new CollaborationGroup(Name = 'UsersGroup',
                                                                      CollaborationType = 'Public',
                                                                      OwnerId = UserInfo.getUserId());
        insert usersChatterGroup;
    }
    
    @isTest
    static void assignPublicGroupTest(){
        User u = TestDataFactory.createUser();
        
        Group gp = [SELECT Id, Type FROM Group WHERE Type = 'Regular' AND DeveloperName  = 'All_Users'];
        CollaborationGroup cgp = [SELECT Id, Name FROM CollaborationGroup WHERE Name = 'UsersGroup'];
        
        Test.startTest();
        insert u;
        Test.stopTest();
        
        List<GroupMember> gpmList = [SELECT GroupId, UserOrGroupId FROM GroupMember WHERE GroupId = :gp.Id AND UserOrGroupId = :u.Id];
        List<CollaborationGroupMember> cgpm = [SELECT CollaborationGroupId, MemberId FROM CollaborationGroupMember WHERE CollaborationGroupId = :cgp.Id AND
                                              MemberId = :u.Id];
    	
        System.assertEquals(1, gpmList.size(), 'Size should match');
        System.assertEquals(1, cgpm.size(),'chatter member size should match');
    }
    
    @isTest
    public static void assignPermissionTest(){
        
        User u = TestDataFactory.createUser();

        Test.startTest();
            insert u;
        Test.stopTest();
		
        PermissionSet perSet = [SELECT Id FROM PermissionSet WHERE Name = 'Sales_User_Permissions' LIMIT 1];
        PermissionSetAssignment perSetAssign = [SELECT Id, AssigneeId, PermissionSetId FROM PermissionSetAssignment 
                                                WHERE Assignee.Id = :u.Id AND PermissionSet.Id = :perSet.Id];

        System.assertEquals(perSetAssign.AssigneeId, u.Id,'User id should match.');
        System.assertEquals(perSetAssign.PermissionSetId, perSet.Id, 'Permission set should Match');

    }
}