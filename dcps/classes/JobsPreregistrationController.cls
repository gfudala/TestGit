public with sharing class JobsPreregistrationController {
      public Lead preRegistration {get; private set;}
      public string pageMessage {get; private set;}

      public JobsPreregistrationController() {
            preRegistration = new Lead();
            preRegistration.Company = 'DCPS Pre-registered Candidate';
            
            //[select id, name from Pre_Registration__c where id =
              //         :ApexPages.currentPage().getParameters().get('id')];
      }


      public PageReference save() 
      {
          try {
            insert preRegistration;
              } catch(System.DMLException e) {
                  ApexPages.addMessages(e);
                  return null;
                  }
         return page.PreRegisterSuccess;
     }
     
    @IsTest static void testJobsPreregistrationController () {
        // Instantiate a new controller with all parameters in the page
        JobsPreregistrationController controller = new JobsPreregistrationController ();
        
        // Test exceltion catch clause
        controller.save();
        
        // Now try to save successfully
        controller.preRegistration.Email = 'test@salesforce.com';
        controller.preRegistration.FirstName = 'First';
        controller.preRegistration.LastName = 'Last';
        controller.preRegistration.Careers_Area_of_Interest__c = 'Teacher';
        controller.save();      
        //System.assertEquals(controller.save(), page.PreRegisterSuccess);                           
    }       
}