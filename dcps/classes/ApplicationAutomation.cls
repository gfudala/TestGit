global class ApplicationAutomation {
	//Testing git
    // Returns a dynamic SOQL statement for the whole object, includes only creatable fields since we will be inserting a cloned result of this query
    public static string getCreatableFieldsSOQL(String objectName, String whereClause){
 
        String selects = '';
 
        if (whereClause == null || whereClause == ''){ return null; }
 
        // Get a map of field name and field token
        Map<String, Schema.SObjectField> fMap = Schema.getGlobalDescribe().get(objectName.toLowerCase()).getDescribe().Fields.getMap();
        list<string> selectFields = new list<string>();
 
        if (fMap != null){
            for (Schema.SObjectField ft : fMap.values()){ // loop through all field tokens (ft)
                Schema.DescribeFieldResult fd = ft.getDescribe(); // describe each field (fd)
                if (fd.isCreateable()){ // field is creatable
                    selectFields.add(fd.getName());
                }
            }
        }
 
        if (!selectFields.isEmpty()){
            for (string s:selectFields){
                selects += s + ',';
            }
            if (selects.endsWith(',')){selects = selects.substring(0,selects.lastIndexOf(','));}
 
        }
 
        return 'SELECT ' + selects + ' FROM ' + objectName + ' WHERE ' + whereClause;
 
    }	
	
	@future
	public static void CloneApplicationForME(Id appId) {
		try {		
			String queryAllAppFields = getCreatableFieldsSOQL('ts2__Application__c', 'Id = \'' + appId + '\'');
			ts2__Application__c app = (ts2__Application__c)Database.query(queryAllAppFields);
			
			String meJobTitle = 'Master Educator';
		    List<ts2__Job__c> ME_Job = [SELECT Id from ts2__Job__c WHERE Original_Job_Title__c = :meJobTitle AND ts2__Status__c = 'Open'];
		    if (ME_Job.size() == 0) return;        		
			
			// Don't proceed if this Candidate alrady has an Application for ME
			List<ts2__Application__c> existingApp = [SELECT Id FROM ts2__Application__c WHERE ts2__Job__c = :ME_Job[0].Id AND ts2__Candidate_Contact__c = :app.ts2__Candidate_Contact__c];
			if (existingApp.size() > 0) return;
			        		
		    ts2__Application__c newApp = app.Clone(false, true);
		            	
		    newApp.ts2__Job__c = ME_Job[0].Id;
		    newApp.Related_Application__c = appId;
		    newApp.ts2__Stage__c = 'Review';
		    newApp.ts2__Application_Status__c = 'ME Performance Task Review';
		    newApp.Master_Educator_Consideration__c = false;
		            	
		    insert newApp;
		    return;
		}
        catch (System.QueryException e) {
            System.debug('Could not find the related Application');
            return;   
        } 
    }
    
    static testMethod void Test_CloneApplicationForME() {
		Contact con = new Contact(LastName='Smith', ts2__Social_Security__c = '321321321');
		insert con;
        ts2__Job__c job1 = new ts2__Job__c(Name='Principal', ts2__Status__c = 'Open' );
        insert job1;
        ts2__Job__c job2 = new ts2__Job__c(Name='Master Educator', ts2__Status__c = 'Open' );
        insert job2;
		ts2__Application__c app = new ts2__Application__c(ts2__Candidate_Contact__c = con.Id, ts2__Job__c = job1.Id, ts2__Completed__c = true);
		insert app;
		
		ApplicationAutomation.CloneApplicationForME(app.Id);
    	
    }
    
}