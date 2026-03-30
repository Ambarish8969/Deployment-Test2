public class QueueableTest1 implements Queueable {
	
    public void execute(QueueableContext qc){
        System.debug('Queueable Executed');
    }
}