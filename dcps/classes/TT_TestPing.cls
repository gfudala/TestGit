public class TT_TestPing {
	
	public List<Appointment> apptList = new List<Appointment>();
	
	public class Appointment {
		string activityExternalId;
		string activityName;
		Integer appointmentDurationMin;
		dateTime appointmentEndDate;
		Integer appointmentid;
		dateTime appointmentStartDate;
		string createdByExternalUserId;
		string createdByUserName;
		dateTime createdDate;
		string clientExternalId;
		/*
		apptOriginName
		campaignExternalId
		campaignName
		campaignTimezone
		clientExternalId
		clientFirstname
		clientLastname
		clientTimezone
		confirmationNumber
		custom0
		custom1
		custom2
		custom3
		custom4
		custom5
		custom6
		custom7
		custom8
		custom9
		isCancelled
		isCheckedIn
		isCheckedOut
		isConfirmed
		isLateCanceled
		isWalkIn
		locationExternalId
		numberOfAttendees
		programExternalId
		programName
		//resourcepool
		setupDurationMin*/
	}
	
 public void DoPing() { 
 	string SoapXMLBody; 
 	SoapXMLBody = '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://timetrade.timecommerce/services/ws" xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd" xmlns:wsu="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd" > <soapenv:Header><wsse:Security soapenv:mustUnderstand="1"> <wsse:UsernameToken> <wsse:Username>apiuser1132</wsse:Username> <wsse:Password Type="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-username-token-profile-1.0#PasswordText">DCPublicSch00!s1132</wsse:Password> </wsse:UsernameToken> </wsse:Security> </soapenv:Header> <soapenv:Body> <ws:getAppointmentsByCriteriaCreateDateRange> <criteria><locationExternalId>dcps</locationExternalId></criteria> <startCreateDateTime>2010-10-01T13:00:00Z</startCreateDateTime> <endCreateDateTime>2012-10-01T13:00:00Z</endCreateDateTime> </ws:getAppointmentsByCriteriaCreateDateRange> </soapenv:Body> </soapenv:Envelope>';

	string SoapXML; 
 	SoapXML = SoapXMLBody; 
 	Integer ContentLength = 0; 
 	ContentLength = SoapXML.length(); 
 	Http h = new Http(); 
 	HttpRequest req = new HttpRequest(); 
 	HttpResponse res = new HttpResponse(); 
 	req.setMethod('POST'); 
 	//http://99.130.174.6/ReceivePost.aspx https://demo..net/api/3.0/api.asmx 
 	req.setEndPoint('https://nc1devapi2.timetradesystems.com:443/tc/appointmentservices'); 
 	req.setHeader('Content-type','text/xml'); 
 	req.setHeader('Content-Length',ContentLength.format()); 
 	req.setHeader('SoapAction','https://nc1devapi2.timetradesystems.com:443/tc/appointmentservices/getAppointmentsByCriteriaCreateDateRange'); 
 	req.setBody(SoapXML); 
 	System.Debug(req.getHeader('Content-Length')); 
 	System.Debug(req); 
 	System.Debug(req.getBody()); 
 	res = h.send(req); 
 	//System.Debug(res); 
 	//String auth = res.getBody(); 
 	//System.Debug(auth); 
 	//extractAppointments(res);
 	Dom.XMLNode root = res.getBodyDocument().getRootElement();
 	walkThrough(root);
 	} 
 	
	 private void walkThrough(DOM.XMLNode node) {
		 if (node.getNodeType() == DOM.XMLNodeType.ELEMENT && node.getName() == 'appointments') {  
		  	Appointment appt = new Appointment();
		  	for (Dom.XMLNode apptNode: node.getChildElements()) {
		  		//System.Debug(apptNode.getName() + ': ' + apptNode.getText());
		  		string nodeName = apptNode.getName();
		  		if (nodeName == 'clientExternalId') {
		  			appt.clientExternalId = apptNode.getText();
		  			System.Debug('Set ClientExternalId to ' + apptNode.getText());
		  		} else if (nodeName == 'appointmentStartDate') {
		  			string thisDate = apptNode.getText().trim();
		  			appt.appointmentStartDate = 
		  				dateTime.newInstance(Integer.valueOf(thisDate.substring(0,4)), 
		  										Integer.valueOf(thisDate.substring(5,7)), 
		  										Integer.valueOf(thisDate.substring(8,10)), 
		  										Integer.valueOf(thisDate.substring(11,13)), 
		  										Integer.valueOf(thisDate.substring(14,16)), 
		  										Integer.valueOf(thisDate.substring(17,19)));
		  			System.Debug('Set AppointmentStartDate to ' + apptNode.getText());
		  			System.Debug(appt.appointmentStartDate);
		  		} else if (nodeName == 'appointmentEndDate') {
		  			string thisDate = apptNode.getText().trim();
		  			appt.appointmentEndDate = 
		  				dateTime.newInstance(Integer.valueOf(thisDate.substring(0,4)), 
		  										Integer.valueOf(thisDate.substring(5,7)), 
		  										Integer.valueOf(thisDate.substring(8,10)), 
		  										Integer.valueOf(thisDate.substring(11,13)), 
		  										Integer.valueOf(thisDate.substring(14,16)), 
		  										Integer.valueOf(thisDate.substring(17,19)));
		  		}
		  	}
		  	apptList.add(appt);
		 } else {
			 for (Dom.XMLNode child: node.getChildElements()) {
			 	walkThrough(child);
			 }
		 }
		 return;
	}
	 	
	
	private void extractAppointments(HttpResponse res) {
		dom.Document doc = res.getBodyDocument();
		dom.Xmlnode resultNode = doc.getRootElement().getChildElement('Body', null);
		for(dom.XmlNode node : resultNode.getChildElements()) {
			System.Debug(node.getName());
			if(node.getName()=='appointments') {
				for (dom.Xmlnode subnode : node.getChildElements()) {
					System.Debug(subnode.getName() + ': ' + subnode.GetText());
				}
			}
		}
	}
	

}