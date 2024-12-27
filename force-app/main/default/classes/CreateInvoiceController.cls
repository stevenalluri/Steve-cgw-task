public class CreateInvoiceController {
    
    public static Id origin_record {get;set;}
    public static Id account {get;set;}
    public static Date invoice_date {get;set;}
    public static Date invoice_due_date {get;set;}
    public static String child_relationship_name {get;set;}
    public static String line_item_description {get;set;}
    public static String line_item_quantity {get;set;}
    public static String line_item_unit_price {get;set;}
    public static Boolean boolShowJSON {get;set;}
    public static Boolean boolShowError {get;set;}
    public static Boolean boolShowURLParams {get;set;}
    public static Opportunity oppRecord {get;set;}
    
    public CreateInvoiceController() {
        try {
            boolShowJSON = false;
            boolShowError = false;
            Map<String, Object> opptyBinds = new Map<String, Object>();
            if (ApexPages.currentPage().getParameters().get('origin_record') != null) {
               origin_record = String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('origin_record'));
                opptyBinds.put('origin_record', origin_record);
            }
            if (ApexPages.currentPage().getParameters().get('account') != null) {
				account = String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('account'));
                opptyBinds.put('account', account);
                
            }
            if (ApexPages.currentPage().getParameters().get('invoice_date') != null) {
            	invoice_date = Date.parse(String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('invoice_date')));  
                opptyBinds.put('invoice_date', invoice_date);
            }
            if (ApexPages.currentPage().getParameters().get('invoice_due_date') != null) {
                invoice_due_date = Date.parse(String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('invoice_due_date')));
                opptyBinds.put('invoice_due_date', invoice_due_date);
            }
            if (ApexPages.currentPage().getParameters().get('child_relationship_name') != null) {
            	child_relationship_name = String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('child_relationship_name'));    
            }
            if (ApexPages.currentPage().getParameters().get('line_item_description') != null) {
                line_item_description = String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('line_item_description'));
                opptyBinds.put('line_item_description', line_item_description);
            }
            if (ApexPages.currentPage().getParameters().get('line_item_quantity') != null) {
            	line_item_quantity = String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('line_item_quantity'));  
                opptyBinds.put('line_item_quantity', Double.valueOf(line_item_quantity));
            }
            if (ApexPages.currentPage().getParameters().get('line_item_unit_price') != null) {
             	line_item_unit_price = String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('line_item_unit_price'));
                line_item_unit_price = line_item_unit_price.replaceAll('[^0-9.-]', '');
                opptyBinds.put('line_item_unit_price', Double.valueOf(line_item_unit_price));
            }
            if (origin_record != null) {
                System.debug(opptyBinds + ' binds');
                String query = 'SELECT Id, AccountId, CloseDate, Invoice_Due_Date__c, Description, Quantity__c, Amount from Opportunity WHERE Id = :origin_record AND AccountId = :account ' + 
                    			'AND CloseDate = :invoice_date AND Invoice_Due_Date__c = :invoice_due_date AND Quantity__c = :line_item_quantity AND Amount = :line_item_unit_price';
                oppRecord = Database.queryWithBinds(query, opptyBinds, AccessLevel.USER_MODE);
                System.debug(oppRecord);
            }
            boolShowURLParams = true;
        }
        catch (Exception e) {
            System.debug('Error occured during processing url params -> ' + e);
        }
    }
    
    public static void displayJSON() {
        System.debug('Displaying JSON');
        try {
            XeroWrapper xero = new XeroWrapper();
            xero.invoiceType = 'ACCPAY';
            xero.contact = '00000';
            xero.lineItems = new List<LineItemWrapper>();
            LineItemWrapper lineItem = new LineItemWrapper();
            lineItem.description = line_item_description;
            lineItem.quantity = Integer.valueOf(line_item_quantity);
            lineItem.unitAmount = Double.valueOf(line_item_unit_price);
            lineItem.accountCode = account;
            lineItem.taxType = 'INPUT';
            lineItem.taxAmount = 0;
            lineItem.lineAmount = Integer.valueOf(line_item_quantity) * Double.valueOf(line_item_unit_price);
            lineItem.discountAmount = 0;
            boolShowJSON = true;
            boolShowURLParams = false;
        }
        catch (Exception e) {
            System.debug('Exception occured when initializing wrapper -> ' + e.getMessage());
            boolShowError = true;
            boolShowJSON = false;
        }
    }
    
    public Class LineItemWrapper {
        public String description;
        public Integer quantity;
        public Double unitAmount;
        public String itemCode;
        public String accountCode;
        public String lineItemId;
        public String taxType;
        public Double taxAmount;
        public Double lineAmount;
        public Double discountAmount;
        public String tracking;
    }
    
    public class XeroWrapper {
        public String invoiceType;
        public String contact;
        public LineItemWrapper[] lineItems;
        public Date invoiceDate;
        public Date invoiceDueDate;
        public String lineAmountType;
        public String invoiceNumber;
        public String reference;
        public String url;
        public String currencyCode;
        public String currencyRate;
        public String status;
        public Boolean sentToContact;
        public Date expectedPaymentDate;
        public Date plannedPaymentDate;
    }
    
}