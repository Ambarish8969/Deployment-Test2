public class CaseServiceConsoleController {
    
    public class WarrantyAndKnowledgeWrapper{
        @AuraEnabled
        public WarrantyInfo warranty;
        
        @AuraEnabled
        public List<KnowledgeArticleVersion> articles;

        public WarrantyAndKnowledgeWrapper(WarrantyInfo w, List<KnowledgeArticleVersion> a) {
            this.warranty = w;
            this.articles = a;
        }
    }
    
    public class WarrantyInfo {
        @AuraEnabled
        public String productName { get; set; }
        @AuraEnabled
        public Date purchaseDate { get; set; }
        @AuraEnabled
        public Date warrantyEndDate { get; set; }
        @AuraEnabled
        public String status { get; set; }
        @AuraEnabled
        public boolean isUnderWarranty { get; set; }

        public WarrantyInfo(String name, Date pDate, Date wDate, String stat, boolean isUnder) {
            this.productName = name;
            this.purchaseDate = pDate;
            this.warrantyEndDate = wDate;
            this.status = stat;
            this.isUnderWarranty = isUnder;
        }
    }
    
    @AuraEnabled(cacheable=true)
    public static WarrantyAndKnowledgeWrapper getCaseDetails(String caseId) {
        if (String.isBlank(caseId)) {
            throw new AuraHandledException('Case ID is required.');
        }

        try {
            // 1. Get Case data
            Case c = [SELECT Serial_Number__c, Issue_Type__c
                      FROM Case
                      WHERE Id = :caseId
                      LIMIT 1];

            // 2. Get Mock Warranty Info
            WarrantyInfo warranty = getMockWarranty(c.Serial_Number__c);

            // 3. Get Knowledge Articles
            List<KnowledgeArticleVersion> articles = new List<KnowledgeArticleVersion>();
            if (String.isNotBlank(c.Issue_Type__c)) {
                 articles = searchKnowledge(c.Issue_Type__c);
            }

            // 4. Return the wrapper
            return new WarrantyAndKnowledgeWrapper(warranty, articles);

        } catch (Exception e) {
            // Pass errors to the LWC in a friendly way
            throw new AuraHandledException(e.getMessage());
        }
    }
	
    private static WarrantyInfo getMockWarranty(String serialNumber) {
        if (String.isBlank(serialNumber)) {
            return new WarrantyInfo('N/A', null, null, 'No serial number', false);
        }

        String productName = 'ProLaptop X15';
        Date purchaseDate = Date.today().addYears(-1);
        Date warrantyEndDate;
        String status;
        boolean isUnderWarranty;

        // Use last digit to simulate different statuses
        if (serialNumber.endsWith('1')) {
            // In Warranty
            warrantyEndDate = Date.today().addMonths(6);
            status = 'Active';
            isUnderWarranty = true;
        } else if (serialNumber.endsWith('2')) {
            // Out of Warranty
            warrantyEndDate = Date.today().addMonths(-3);
            status = 'Expired';
            isUnderWarranty = false;
        } else {
            // Product not found
            productName = 'Unknown Product';
            status = 'Not Found';
            isUnderWarranty = false;
        }

        return new WarrantyInfo(productName, purchaseDate, warrantyEndDate, status, isUnderWarranty);
    }
    
    private static List<KnowledgeArticleVersion> searchKnowledge(String issueType) {
        // Sanitize the search term
        String searchTerm = String.escapeSingleQuotes(issueType);
        
        // Build the SOSL query
        // We search for the issue type and only return Published, English articles
        String soslQuery = 'FIND \'' + searchTerm + '\' IN ALL FIELDS ' +
                           'RETURNING KnowledgeArticleVersion(Id, Title, Summary ' +
                           'WHERE PublishStatus=\'Online\' AND Language = \'en_US\') ' +
                           'LIMIT 5';

        // Execute the search
        List<List<SObject>> searchResults = Search.query(soslQuery);

        // SOSL returns a list of lists. We only care about the first one (Knowledge).
        if (searchResults.size() > 0) {
            return (List<KnowledgeArticleVersion>)searchResults[0];
        } else {
            return new List<KnowledgeArticleVersion>();
        }
    }
}