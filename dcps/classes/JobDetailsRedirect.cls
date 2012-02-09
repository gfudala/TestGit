public class JobDetailsRedirect {
  public PageReference redirect() {
      return new PageReference('/ts2__JobDetails?JobId=' + ApexPages.currentPage().getParameters().get('JobId'));
  }
  
  	public static testMethod void testMyController() {
   		PageReference pageRef = Page.JobDetails;
        Test.setCurrentPage(pageRef);
      
        JobDetailsRedirect controller = new JobDetailsRedirect();
        controller.redirect();
  	}
  
}