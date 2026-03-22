public class UserTriggerHelper {

    @future
    public static void insertAssingment(Set<Id> newUserIds){
        List<PermissionSetAssignment> assignList = new List<PermissionSetAssignment>();

        PermissionSet perSet = [SELECT Id, Name FROM PermissionSet WHERE Name = 'Sales_User_Permissions'];
       
        for(Id newUserId : newUserIds){
            PermissionSetAssignment newAssign = new PermissionSetAssignment();
            newAssign.AssigneeId = newUserId;
            newAssign.PermissionSetId = perSet.Id;
            assignList.add(newAssign);
        }

        if(!assignList.isEmpty()){
            insert assignList;
        }
    }
}