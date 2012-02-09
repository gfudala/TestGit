public class ApplicationControllerExtensionTeachscape {

    private final ts2__Application__c app;
    
    public ApplicationControllerExtensionTeachscape(ApexPages.StandardController stdController) {
        this.app = (ts2__Application__c)stdController.getRecord();
    }

    public String getChecksum() {
        string keystring = 's3cr3thttp://dcps.teachscape.com/dcps/videos/' + app.ts2__Email__c;
        //string keystring = 's3cr3thttp://dcps.teachscape.com/dcps/videos/this.is@test.edu';
		Blob keyblob = Blob.valueof(keystring);
		Blob key = Crypto.generateDigest('MD5',keyblob);
		return encodingUtil.convertToHex(key);
    }
    
    static testMethod void Test_getCheckSum() {
    	Contact con = new Contact(LastName='Smith');
		insert con;
        ts2__Job__c job = new ts2__Job__c(Name='Test Job');
        insert job;
		ts2__Application__c app = new ts2__Application__c(ts2__Candidate_Contact__c = con.Id, ts2__Job__c = job.Id);
		insert app;
    	
		ApexPages.StandardController sc = new ApexPages.standardController(app);
    	ApplicationControllerExtensionTeachscape ext = new ApplicationControllerExtensionTeachscape(sc);
    	ext.getChecksum();
    }
}