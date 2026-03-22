public class CaseWebServiceFromOrg2 {
	
    @AuraEnabled
    public static List<Case> getCasesFromOrg2(){
        List<Case> caseList = new List<Case>();
        try{
            Http http = new Http();
            HttpRequest hReq = new HttpRequest();
            hReq.setEndPoint('callout:trailheadcpq_ambi_com_cred/services/apexrest/records/allcases');
            hReq.setMethod('GET');
            
            HttpResponse hRes = http.send(hReq);
            
            if(hRes.getStatusCode() == 200){
                System.debug('Cases from Org2: '+hRes.getBody());
                List<Case> cases = (List<Case>)JSON.deserialize(hRes.getBody(), List<Case>.class);
                /*
                for(Case record : cases){
                    System.debug('CaseId: '+record.Id+' CaseNumber: '+record.CaseNumber);
                } */
                caseList = cases;
            }else{
                System.debug('Error: '+hRes.getStatusCode()+'--'+hRes.getBody());
            }
            
        }catch(Exception e){
           // System.debug('Exception: '+e.getMessage());
            throw new AuraHandledException(e.getMessage());
        }
        return caseList; 
    }
    
    public static void sendCreatedCases() {

        String endpoint =
            'callout:trailheadcpq_ambi_com_cred/services/apexrest/records/createcases';

        HttpRequest req = new HttpRequest();
        req.setEndpoint(endpoint);
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/json');

        List<Case> casesToday = [
            SELECT Subject, Origin, Status, Description
            FROM Case
            WHERE CreatedDate = TODAY
        ];

        if(casesToday.isEmpty()){
            return;
        }

        List<Map<String, Object>> payloadCases = new List<Map<String, Object>>();

        for(Case c : casesToday){
            payloadCases.add(new Map<String, Object>{
                'Subject' => c.Subject,
                'Origin' => c.Origin,
                'Status' => c.Status,
                'Description' => c.Description
            });
        }

        Map<String, Object> wrapper = new Map<String, Object>{
            'cases' => payloadCases
        };

        req.setBody(JSON.serialize(wrapper));

        Http http = new Http();
        HttpResponse res = http.send(req);

        System.debug('Response from Org B: ' + res.getBody());
    }
    
    /*
    public static void sendCreatedCases(){
        String endURL = 'callout:trailheadcpq_ambi_com_cred/services/apexrest/records/createcases';
        Http http = new Http();
        HttpRequest hReq = new HttpRequest();
        hReq.setEndPoint(endURL);
        hReq.setMethod('POST');
        hReq.setHeader('Content-Type', 'application/json');

        List<Case> caseRecords = [SELECT Id, Subject, Origin, Status, Description FROM Case WHERE CreatedDate = TODAY];
        
        if(caseRecords.isEmpty()){
            System.debug('Empty List');
            return;
        }
        
        List<Map<String, Object>> caseList = new List<Map<String, Object>>();
        
        for(Case caseRecord : caseRecords){
            Map<String, Object> caseMap = new Map<String, Object>();
            caseMap.put('Subject', caseRecord.Subject);
            caseMap.put('Origin', caseRecord.Origin);
            caseMap.put('Status', caseRecord.Status);
            caseMap.put('Description', caseRecord.Description);
            caseList.add(caseMap);
        }
        
    	Map<String, Object> wrapper = new Map<String, Object>();
    	wrapper.put('cases', caseList);

    	String payload = JSON.serialize(wrapper);
        hReq.setBody(payload);
        
        HttpResponse hRes = http.send(hReq);
        System.debug('Response: '+hRes.getBody());
        
    } */
    
    public static void sendAccounts(){
        Http http = new Http();
        HttpRequest hReq = new HttpRequest();
        hReq.setEndpoint('callout:trailheadcpq_ambi_com_cred/services/apexrest/records/createaccounts');
        hReq.setMethod('POST');
        hReq.setHeader('Content-Type', 'application/json');
        
        List<Account> newAccounts = [SELECT Id, Name, Phone, Industry FROM Account WHERE CreatedDate = TODAY];
        
        List<Map<String, Object>> accountList = new List<Map<String, Object>>();
        
        for(Account newAccount : newAccounts){
            Map<String, Object> accountMap = new Map<String, Object>();
            accountMap.put('Name', newAccount.Name);
            accountMap.put('Phone', newAccount.Phone);
            accountMap.put('Industry', newAccount.Industry);
            accountList.add(accountMap);
        }
        Map<String, Object> accountWrap = new Map<String, Object>();
        accountWrap.put('accounts', accountList);
        
        String payload = JSON.serialize(accountWrap);
        
        hReq.setBody(payload);
        
        HttpResponse hRes;
        
        try{
            hRes = http.send(hReq);
            System.debug('Response: '+hRes.getBody());
        }catch(Exception e){
            System.debug('Exception: '+e.getMessage());
        }
    }
}