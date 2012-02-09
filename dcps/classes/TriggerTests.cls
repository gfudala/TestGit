@isTest
private class TriggerTests {
	
	static testMethod void Test_App_Check_Contact_ARBUL_List() {
		Contact oldCon = new Contact(LastName='Smith', Employee_Hold__c = 'LMER', ts2__Social_Security__c = '321321321');
		insert oldCon;
		Contact newCon = new Contact(LastName='Smith', ts2__Social_Security__c = '321321321');
		insert newCon;
        ts2__Job__c job = new ts2__Job__c(Name='Test Job');
        insert job;
		ts2__Application__c app = new ts2__Application__c(ts2__Candidate_Contact__c = newCon.Id, ts2__Job__c = job.Id);
		insert app;
		
		Test.startTest();
		Contact checkCon = [SELECT Id, Employee_Hold__c FROM Contact WHERE Id = :newCon.Id];
		Test.stopTest();
		
		System.AssertEquals(checkCon.Employee_Hold__c, oldCon.Employee_Hold__c);
	}
	
	static testMethod void Test_App_Submitted_Auto_Update_Status() {
		Contact con = new Contact(LastName='Smith', ts2__Social_Security__c = '321321321');
		insert con;
        ts2__Job__c job1 = new ts2__Job__c(Name='Test Job 1', ts2__Passing_Score__c = 10 );
        insert job1;
		ts2__Application__c app = new ts2__Application__c(ts2__Candidate_Contact__c = con.Id, ts2__Job__c = job1.Id, ts2__Completed__c = false);
		insert app;
		app.ts2__Prescreen_Score__c = 2;
		app.ts2__Completed__c = true;
		
		update app;
		
		ts2__Application__c checkApp1 = [SELECT Id, ts2__Stage__c FROM ts2__Application__c WHERE Id = :app.Id];
		System.assertEquals('Application rejected', checkApp1.ts2__Stage__c);
		
		con.Legal_to_Work_in_the_US__c = 'No';
		update con;
        ts2__Job__c job2 = new ts2__Job__c(Name='Test Job 1', ts2__Passing_Score__c = 10 );
        insert job2;
		ts2__Application__c app2 = new ts2__Application__c(ts2__Candidate_Contact__c = con.Id, ts2__Job__c = job2.Id, ts2__Completed__c = false);
		insert app2;
		app2.ts2__Completed__c = true;
		
		update app2;
		
		ts2__Application__c checkApp2 = [SELECT Id, ts2__Stage__c FROM ts2__Application__c WHERE Id = :app2.Id];
		System.assertEquals('Application rejected', checkApp2.ts2__Stage__c);

		con.Legal_to_Work_in_the_US__c = 'Yes';
		update con;
        ts2__Job__c job3 = new ts2__Job__c(Name='Teacher');
        insert job3;
		ts2__Application__c app3 = new ts2__Application__c(ts2__Candidate_Contact__c = con.Id, ts2__Job__c = job3.Id, ts2__Completed__c = false);
		insert app3;
		app3.ts2__Completed__c = true;
		app3.Licensure_Bachelors_Degree__c = 'No';
		update app3;

		ts2__Application__c checkApp3 = [SELECT Id, ts2__Stage__c FROM ts2__Application__c WHERE Id = :app3.Id];
		System.assertEquals('Application rejected', checkApp3.ts2__Stage__c);

		
		app3.Licensure_Bachelors_Degree__c = 'Yes';
		app3.Praxis_I_Reading_and_Math_or_SAT__c = 'Yes';
		app3.Praxis__c = 'Yes';
		app3.Licensure_Praxis_II__c = 'Yes';
		
		update app3;
		
		
		
	}
	
	static testMethod void Test_App_Update_Related_Object_ME_Consideration() {
    	Contact con = new Contact(LastName='Smith');
		insert con;
        ts2__Job__c job = new ts2__Job__c(Name='Test Job');
        insert job;
		ts2__Application__c app = new ts2__Application__c(ts2__Candidate_Contact__c = con.Id, ts2__Job__c = job.Id);
		insert app;
		ts2__Interview__c inter = new ts2__Interview__c(ts2__Job__c = job.Id, ts2__Candidate__c = con.Id, ts2__Related_Application__c = app.Id);
		insert inter;
		Content_Knowledge__c ck = new Content_Knowledge__c(Application__c = app.Id);
		insert ck;
		Content_Assessment__c ca = new Content_Assessment__c(Application__c = app.Id, Content_Knowledge__c = ck.Id);
		insert ca;
		
		app.Master_Educator_Consideration__c = true;
		update app;
		
	}
	
	static testMethod void Test_CA_Update_Application_Stage_Status() {
    	Contact con = new Contact(LastName='Smith');
		insert con;
        ts2__Job__c job = new ts2__Job__c(Name='Assistant Principal');
        insert job;
		ts2__Application__c app = new ts2__Application__c(ts2__Candidate_Contact__c = con.Id, ts2__Job__c = job.Id);
		insert app;
		ts2__Interview__c inter = new ts2__Interview__c(ts2__Job__c = job.Id, ts2__Candidate__c = con.Id, ts2__Related_Application__c = app.Id);
		insert inter;
		Content_Knowledge__c ck = new Content_Knowledge__c(Application__c = app.Id);
		insert ck;
		Content_Assessment__c ca = new Content_Assessment__c(Application__c = app.Id, Content_Knowledge__c = ck.Id, Master_Educator_Consideration__c = true);
		insert ca;
		
		ca.Selection_Decision__c = 'Advance';
		update ca;
		ca.Selection_Decision__c = 'Do not advance';
		update ca;	
					
		ca.PCK_Review_Decision__c = 'Advance';
		update ca;
		ca.PCK_Review_Decision__c = 'Do not advance';
		update ca;		

		ca.Selection_Decision__c = 'ME Consideration for A/P - Do not advance';
		update ca;
		ca.Selection_Decision__c = 'ME Consideration for A/P - Advance';
		update ca;
		job.Name = 'Principal';
		update job;
		ca.Selection_Decision__c = 'ME Consideration for Principal - Do not advance';
		update ca;
		ca.Selection_Decision__c = 'ME Consideration for Principal - Advance';
		update ca;
		
		ca.EA_Selection_Decision__c = 'Advance';
		update ca;
		ca.EA_Selection_Decision__c = 'Do not advance';
		update ca;
		
		
		ca.IC_Selection_Decision__c = 'Advance';
		update ca;
		ca.IC_Selection_Decision__c = 'Do not advance';
		update ca;			
	}
	
	static testMethod void Test_CK_Set_ME_Consideration_Before_Insert() {
		
	}

	static testMethod void Test_CreateAppReview_Task_After_InsertUpdate() {
		
	}
	
	static testMethod void Test_Int_Set_ME_Consideration_Before_Insert() {
		
	}
	
	static testMethod void Test_Int_Update_Application_Stage_Status1() {
    	Contact con = new Contact(LastName='Smith');
		insert con;
        ts2__Job__c job = new ts2__Job__c(Name='Teacher');
        insert job;
		ts2__Application__c app = new ts2__Application__c(ts2__Candidate_Contact__c = con.Id, ts2__Job__c = job.Id);
		insert app;
		ts2__Interview__c inter = new ts2__Interview__c(ts2__Job__c = job.Id, ts2__Candidate__c = con.Id, ts2__Related_Application__c = app.Id);
		insert inter;
		
		inter.ts2__Status__c = 'Passed Interview Stage';
		update inter;	
		inter.Teacher_Interview_Results__c = 'Rejected';
		update inter;	
		
		inter.EA_Selection_Decision__c = 'Educational Aide Moved to Pool of Candidates';
		update inter;
		inter.EA_Selection_Decision__c = 'Educational Aide Rejected';
		update inter;
		
		inter.IC_Final_Decision__c = 'Advance';
		update inter;
		inter.IC_Final_Decision__c = 'Do not advance';
		update inter;
		
		inter.SME_Recommendation__c = 'Recommend for advancement';
		inter.Recommendation__c = 'Recommend for advancement';
		update inter;			
		
	}
	
	static testMethod void Test_Int_Update_Application_Stage_Status2() {
    	Contact con = new Contact(LastName='Smith');
		insert con;
        ts2__Job__c job = new ts2__Job__c(Name='Teacher');
        insert job;
		ts2__Application__c app = new ts2__Application__c(ts2__Candidate_Contact__c = con.Id, ts2__Job__c = job.Id);
		insert app;
		ts2__Interview__c inter = new ts2__Interview__c(ts2__Job__c = job.Id, ts2__Candidate__c = con.Id, ts2__Related_Application__c = app.Id);
		insert inter;

		inter.AP_Selection_Decision__c = 'Advance';
		update inter;
		inter.AP_Selection_Decision__c = 'Do not advance';
		update inter;		

		inter.P_Debrief_Outcome__c = 'Advance';
		update inter;
		inter.P_Debrief_Outcome__c = 'Do not advance';
		update inter;
		
		inter.RSP_Selection_Decision__c = 'Advance';
	 	update inter;
	 	inter.RSP_Selection_Decision__c = 'Do not advance';
	 	update inter;
	 	
	 	inter.T_and_L_Selection_Decision__c = 'Advance';
	 	update inter;
	 	inter.T_and_L_Selection_Decision__c = 'Do not advance';
	 	update inter;
	}
	
	static testMethod void Test_Populate_CA_CandidateAndJob() {
		
	}
	
	static testMethod void Test_Populate_CK_CandidateAndJob() {
		
	}
	
	static testMethod void Test_PopulatePckEssayCandidateAndJob() {
		
	}
	
	static testMethod void Test_Prescreen_Update_Application_Score() {
    	Contact con = new Contact(LastName='Smith');
		insert con;
        ts2__Job__c job = new ts2__Job__c(Name='Test Job');
        insert job;
		ts2__Application__c app = new ts2__Application__c(ts2__Candidate_Contact__c = con.Id, ts2__Job__c = job.Id);
		insert app;
		ts2__Prescreen2__c ps = new ts2__Prescreen2__c(ts2__Application__c = app.Id, ts2__Score__c = 1);
		insert ps;
		
		ts2__Application__c checkApp = [SELECT Id, ts2__Prescreen_Score__c FROM ts2__Application__c WHERE Id = :app.Id];
		
		System.assertEquals(1, checkApp.ts2__Prescreen_Score__c);		
	}
	  
    static testMethod void Test_Set_Application_Formset_on_JobOrder() {
        JSForms__Workflow__c wf = new JSForms__Workflow__c(Name='Test Job');
        insert wf;
        ts2__Job__c job = new ts2__Job__c(Name='Test Job', Application_Formset__c = wf.Id);
        insert job;
        
        job.Name = 'New Job Title';
        
        Test.StartTest();
        update job;
        Test.StopTest();
        
        ts2__Job__c sameJob = [SELECT Id, Application_Formset__c FROM ts2__Job__c WHERE Id = :job.Id];
        
        System.assertEquals(sameJob.Application_Formset__c, wf.Id);
        
    }
    
   	static testMethod void Test_Set_PCK_Essay_Formset_on_Application() {
        JSForms__Workflow__c wf = new JSForms__Workflow__c(Name='Test Job');
        insert wf;
      	Contact con = new Contact(LastName='Smith');
		insert con;
        ts2__Job__c job = new ts2__Job__c(Name='Test Job', Application_Formset__c = wf.Id);
        insert job;
   		ts2__Application__c app = new ts2__Application__c(ts2__Candidate_Contact__c = con.Id, ts2__Job__c = job.Id);
		insert app;
        
        app.PCK_Essay_Type__c = 'Teacher';
        app.PCK_Essay_List_For_Teachers__c = 'Chemistry';
        update app;
        app.PCK_Essay_Type__c = 'Master Educator';
        app.PCK_Essay_List_for_Master_Educators__c = 'Chemistry';
        update app;
        app.PCK_Essay_Type__c = 'Instructional Coach';
        app.PCK_Essay_List_For_Instructional_Coaches__c = 'Chemistry';
        update app;
                
   	}
   	
}