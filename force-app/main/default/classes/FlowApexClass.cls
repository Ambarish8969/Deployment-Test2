public class FlowApexClass {
    /*
    public class ApexInput{
        @InvocableVariable public String apexInput;
    } */
    
    @InvocableMethod(label = 'Get Users based on Role')
    public static List<List<User>> getUsersBasedOnRoleName(List<String> roleNames){
       /* List<ApexOutput> output = new List<ApexOutput>(); */

        List<User> users = [SELECT Id, Name, Email, Username FROM User WHERE UserRole.Name = :roleNames[0]];
        
        /* 
        for(User u : users){
            ApexOutput o = new ApexOutput();
            o.name = u.Name;
            o.email = u.Email;
            o.username = u.Username;
            output.add(o);
        }
        return output;
		*/
        
        return new List<List<User>>{users};
    }
    
    /*
    public class ApexOutput{
       	@InvocableVariable public String name;	
       	@InvocableVariable public String email;
        @InvocableVariable public String username;
    }
	*/

}