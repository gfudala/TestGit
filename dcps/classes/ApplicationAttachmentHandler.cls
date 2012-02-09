global class ApplicationAttachmentHandler implements Messaging.InboundEmailHandler {
      global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.InboundEnvelope envelope) {
    	      Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();
 	
 			  Id emailAppId = email.subject.substring(email.subject.indexOf('[#') + 2, email.subject.indexOf('#]'));

    		  List<ts2__Application__c> app = [SELECT Id FROM ts2__Application__c WHERE Id = :emailAppId];
    		  if (app.size() == 0) {
				 System.debug('Could not find App ' + emailAppId); 
				 result.success = false;   		  	
    		  	 return result;
    		  }
    		   
    		  System.debug('====> Found Application '+ app[0].Id);
 
    		  if (email.binaryAttachments != null && email.binaryAttachments.size() > 0) {
      		  	  for (integer i = 0 ; i < email.binaryAttachments.size() ; i++) {
        		  	  Attachment attachment = new Attachment();
        			  // attach to the newly created contact record
        			  attachment.ParentId = app[0].Id;
        			  attachment.Name = email.binaryAttachments[i].filename;
        			  attachment.Body = email.binaryAttachments[i].body;
        			  insert attachment;
      			  }
   			   }
   			   
 			   result.success = true;
    		   return result;
    		   // Testing git
      }
      
      static testMethod void handleInboundEmailTest() {
      	
		 ts2__Job__c job = new ts2__Job__c(Name='Test Job');
      	 insert job;

		 Contact con = new Contact(LastName='Smith');
		 insert con;
		  	
      	 ts2__Application__c app = new ts2__Application__c(ts2__Candidate_Contact__c = con.Id, ts2__Job__c = job.Id );
      	 insert app;
      	 
		   // create a new email and envelope object
		  Messaging.InboundEmail email = new Messaging.InboundEmail() ;
		  Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
		 
		  // setup the data for the email
		  email.subject = '[#' + app.Id + '#]';
		  email.fromname = 'FirstName LastName';
		  env.fromAddress = 'someaddress@email.com';
		 
		  // add an attachment
		  Messaging.InboundEmail.BinaryAttachment attachment = new Messaging.InboundEmail.BinaryAttachment();
		  attachment.body = blob.valueOf('my attachment text');
		  attachment.fileName = 'textfile.txt';
		  attachment.mimeTypeSubType = 'text/plain';
		 
		  email.binaryAttachments =
		    new Messaging.inboundEmail.BinaryAttachment[] { attachment };
		 
		  // call the email service class and test it with the data in the testMethod
		  ApplicationAttachmentHandler emailProcess = new ApplicationAttachmentHandler();
		  emailProcess.handleInboundEmail(email, env);
		 
		  // find the attachment
		  Attachment a = [select name from attachment where parentId = :app.id];
		 
		  System.assertEquals(a.name,'textfile.txt');
		      	
      }
  }