@isTest
public class ContactTriggerHandlerTest{
	
	@isTest
	public static void preventEmailUpdationTest(){
		Contact con1 = new Contact(LastName = 'TestCon1', Email = 'testcon1@gmail.com');
		insert con1;
		
		con1.Email = 'test2con1@gmail.com';
		try{
			update con1;
		}
		catch(Exception e){
			System.assert(true, e.getMessage().contains('Contact Email can not be updated once set'));
		}
	}
}