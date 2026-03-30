public with sharing class AmbiTestClass {
    public AmbiTestClass() {

    }

    public static void testMethod1() {
        System.debug('This is a test method for AmbiTestClass.');
    }

    public static void testAssignPublicGroup(List<User> users) {
        System.debug('Assigning users to a public group.');
    }

}