public with sharing class DCPSFormShellController2 {
	public String formUrl { get; set; }
	public Integer formPadding { get; set; }
	
	public DCPSFormShellController2() {
		String buildFormUrl = '';
		//if (Site.getPrefix() != 'null') {
		//	buildFormUrl = '/' + Site.getPrefix();
		//}
	 	buildFormUrl = '/forms/JSForms__FormInclude?';
		formPadding = 0;
		Map<String, String> parmMap = ApexPages.currentPage().getParameters();
		for (String pageParm : parmMap.keySet()) {
			if (pageParm == 'formPadding') {
				formPadding = integer.valueOf(parmMap.get(pageParm));
			}
			else {
				buildFormUrl += pageParm + '=' + parmMap.get(pageParm) +'&';
			}
		}
		formUrl = buildFormUrl;
	}
	
  	public static testMethod void Test_DCPSFormShellController() {
   		PageReference pageRef = Page.DCPSFormShell;
        Test.setCurrentPage(pageRef);
   		ApexPages.currentPage().getParameters().put('formPadding', '100');
      
        DCPSFormShellController2 controller = new DCPSFormShellController2();
  	}	

}