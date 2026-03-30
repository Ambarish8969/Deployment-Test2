public class Test1Class {
    
    @future
    public static void method1(){
        System.debug('Future Started');
        System.enqueueJob(new QueueableTest1());
    }

}