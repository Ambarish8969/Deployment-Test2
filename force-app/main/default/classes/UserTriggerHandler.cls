public with sharing class UserTriggerHandler {
    
    public static void assignPublicGroup(List<User> newUsers){
        Group pbGroup = [SELECT Id, Type FROM Group WHERE Type = 'Regular' AND DeveloperName  = 'All_Users'];
        
        Set<Id> userIds = new Set<Id>();
        List<GroupMember> membersList = new List<GroupMember>();
        
        if(!newUsers.isEmpty()){
            for(User newUser : newUsers){
                userIds.add(newUser.Id);
            }
        }
        
        if(!userIds.isEmpty()){
            for(Id userId : userIds){
                GroupMember newMember = new GroupMember();
                newMember.GroupId = pbGroup.Id;
                newMember.UserOrGroupId = userId;
                membersList.add(newMember);
            }
        }
        
        if(!membersList.isEmpty()){
            insert membersList;
        }
        
        postToChatterMessage(userIds);
    }
    
    @future
    public static void postToChatterMessage(Set<Id> userIds){
        
        List<CollaborationGroupMember> newMembersList = new List<CollaborationGroupMember>();
        List<FeedItem> newPostList = new List<FeedItem>();
        
        List<User> newUsers = [SELECT Id, Name FROM User WHERE ID IN :userIds];
        
        CollaborationGroup chatterGroup = [SELECT Id, Name FROM CollaborationGroup WHERE Name = 'UsersGroup'];
        
        if(!newUsers.isEmpty()){
            for(User newUser : newUsers){
                CollaborationGroupMember newColMember = new CollaborationGroupMember();
                newColMember.CollaborationGroupId = chatterGroup.Id;
                newColMember.MemberId = newUser.Id;
                newMembersList.add(newColMember);
                
                FeedItem newFeed = new FeedItem();
                newFeed.Title = 'Welcome '+newUser.Name;
                newFeed.Body = 'Congratulations to ' + newUser.Name + ' for joining us.';
                newFeed.ParentId = chatterGroup.Id;
                newPostList.add(newFeed);
            }
        }
        
        if(!newMembersList.isEmpty() && !newPostList.isEmpty()){
            insert newMembersList;
            insert newPostList;
        }
        
    }

    public static void assignPermissionSet(List<User> newUsers){

        Set<Id> userIds = new Set<Id>();

        if(!newUsers.isEmpty()){
            for(User newUser : newUsers){
                userIds.add(newUser.Id);
            }
        }

        UserTriggerHelper.insertAssingment(userIds);
    }
    
    public static void updateCaseOwner(List<User> newUsers, Map<Id, User> oldUserMap){
        
        Set<Id> userIds = new Set<Id>();

        if(!newUsers.isEmpty()){
            for(User newUser : newUsers){
                User oldUser = oldUserMap.get(newUser.Id);
                if(oldUser.isActive && !newUser.isActive){
                    userIds.add(newUser.Id);
                }
            }
        }

        updateCaseOwnerWithFuture(userIds);
    }

    @future
    public static void updateCaseOwnerWithFuture(Set<Id> usersIds){
        List<Case> caseToUpdate = new List<Case>();
        List<Case> userCases = [SELECT Id, OwnerId FROM Case WHERE OwnerId IN :usersIds AND Status != 'Closed'];

        Group queue = [SELECT Id FROM Group WHERE Type = 'Queue' AND DeveloperName = 'High_Priority_Queue'];

        for(Case userCase : userCases){
            userCase.OwnerId = queue.Id;
            caseToUpdate.add(userCase);
        }

        update caseToUpdate;
    }

}