public class CreateInvoiceController {
    
    public class LineItemWrapper {
        public String Description {get;set;}
        public Integer Quantity {get;set;}
        public Double UnitAmount {get;set;}
        public String ItemCode {get;set;}
        public String AccountCode {get;set;}
        public String LineItemId {get;set;}
        public String TaxType {get;set;}
        public Double TaxAmount {get;set;}
        public Double LineAmount {get;set;}
        public Double DiscountAmount {get;set;}
        public String Tracking {get;set;}
    }
    
    public class ContactWrapper {
        public String ContactId {get;set;}
    }
    
    public class XeroWrapper {
        public String Type {get;set;}
        public ContactWrapper Contact {get;set;}
        public LineItemWrapper[] LineItems {get;set;}
        public String InvoiceDate {get;set;}
        public Date InvoiceDateString {get;set;}
        public String DueDate {get;set;}
        public Date DueDateString {get;set;}
        public String LineAmountTypes {get;set;}
        public String InvoiceNumber {get;set;}
        public String Reference {get;set;}
        public String Url {get;set;}
        public String CurrencyCode {get;set;}
        public String CurrencyRate {get;set;}
        public String Status {get;set;}
        public Boolean SentToContact {get;set;}
        public Date ExpectedPaymentDate {get;set;}
        public Date PlannedPaymentDate {get;set;}
    }
    
    public Id origin_record {get;set;}
    public String account {get;set;}
    public String invoice_date {get;set;}
    public String invoice_due_date {get;set;}
    public String child_relationship_name {get;set;}
    public String line_item_description {get;set;}
    public String line_item_quantity {get;set;}
    public String line_item_unit_price {get;set;}
    public Boolean boolShowJSON {get;set;}
    public Boolean boolShowError {get;set;}
    public Boolean boolShowURLParams {get;set;}
    public Opportunity oppRecord {get;set;}
    public List<OpportunityLineItem> listProducts {get;set;}
    public List<Line_Item__c> listLineItems {get;set;}
    public List<Invoice__c> listInvoices {get;set;}
    public XeroWrapper xero {get;set;}
    public static String jsonString {get;set;}
    
    public CreateInvoiceController() {
        try {
            boolShowJSON = false;
            boolShowError = false;
            Map<String, Object> opptyBinds = new Map<String, Object>();
            List<String> listFieldApiNames = new List<String>();
            if (ApexPages.currentPage().getParameters().get('origin_record') != null) {
                origin_record = String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('origin_record'));
                opptyBinds.put('origin_record', origin_record);
            }
            if (ApexPages.currentPage().getParameters().get('account') != null) {
                account = String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('account'));
                listFieldApiNames.add(account);
            }
            if (ApexPages.currentPage().getParameters().get('invoice_date') != null) {
                invoice_date = String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('invoice_date'));
                listFieldApiNames.add(invoice_date);
            }
            if (ApexPages.currentPage().getParameters().get('invoice_due_date') != null) {
                invoice_due_date = String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('invoice_due_date'));
                listFieldApiNames.add(invoice_due_date);
            }
            if (ApexPages.currentPage().getParameters().get('child_relationship_name') != null) {
                child_relationship_name = String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('child_relationship_name'));
                listFieldApiNames.add(child_relationship_name);
            }
            if (ApexPages.currentPage().getParameters().get('line_item_description') != null) {
                line_item_description = String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('line_item_description'));
                listFieldApiNames.add(line_item_description);
            }
            if (ApexPages.currentPage().getParameters().get('line_item_quantity') != null) {
                line_item_quantity = String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('line_item_quantity'));  
                listFieldApiNames.add(line_item_quantity);
            }
            if (ApexPages.currentPage().getParameters().get('line_item_unit_price') != null) {
                line_item_unit_price = String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('line_item_unit_price'));
                listFieldApiNames.add(line_item_unit_price);
            }
            if (origin_record != null) {
                String query = 'SELECT Id, ';
                String subQuery = '(SELECT Id, Name, ';
                for (String strField: listFieldApiNames) {
                    if (strField.equals('OpportunityLineItem')) {
                        continue;
                    }
                    else if (strField.contains('OpportunityLineItem.')) {
                        subQuery += strField.substringAfter('OpportunityLineItem.') + ', ';
                    }
                    else {
                        query += strField + ', ';
                    }
                }
                subQuery = subQuery.substring(0, subQuery.length() - 2);
                subQuery += ' FROM OpportunityLineItems)';
                query = query + subQuery + ' FROM Opportunity WHERE Id = :origin_record';
                System.debug(subQuery + ' subQuery');
                System.debug(query + ' query');
                oppRecord = Database.queryWithBinds(query, opptyBinds, AccessLevel.SYSTEM_MODE);
                System.debug(oppRecord.OpportunityLineItems + ' oppRecord');
            }
            boolShowURLParams = true;
        }
        catch (Exception e) {
            System.debug('Error occured during processing url params -> ' + e);
        }
    }
    
    public void displayJSON() {
        try {
            xero = new XeroWrapper();
            xero.Type = 'ACCREC';
            xero.Contact = new ContactWrapper();
            xero.Contact.ContactId = '0000000';
            xero.InvoiceDate = '/Date(' + String.valueOf(datetime.newInstance(oppRecord.CloseDate.year(), oppRecord.CloseDate.month(), oppRecord.CloseDate.day()).getTime()) + ')/';
            xero.InvoiceDateString = oppRecord.CloseDate;
            xero.DueDate = '/Date(' + String.valueOf(datetime.newInstance(oppRecord.Invoice_Due_Date__c.year(), oppRecord.Invoice_Due_Date__c.month(), oppRecord.Invoice_Due_Date__c.day()).getTime()) + ')/';
            xero.DueDateString = oppRecord.Invoice_Due_Date__c;
            xero.Status = 'DRAFT';
            xero.lineItems = new List<LineItemWrapper>();
            for (OpportunityLineItem lineItem: oppRecord.OpportunityLineItems) {
                LineItemWrapper lineItemWrap = new LineItemWrapper();
                lineItemWrap.Description = lineItem.Description;
                lineItemWrap.LineItemId = lineItem.Id;
                lineItemWrap.ItemCode = lineItem.Name;
                lineItemWrap.Quantity = Integer.valueOf(lineItem.Quantity);
                lineItemWrap.UnitAmount = lineItem.UnitPrice;
                lineItemWrap.AccountCode = oppRecord.AccountId;
                lineItemWrap.TaxType = 'INPUT';
                lineItemWrap.TaxAmount = 0;
                lineItemWrap.LineAmount = lineItem.Quantity * lineItem.UnitPrice;
                lineItemWrap.DiscountAmount = 0;
                xero.lineItems.add(lineItemWrap);
            }
            boolShowJSON = true;
            boolShowURLParams = false;
            jsonString = JSON.serializePretty(xero, true);
            System.debug(jsonString + ' jsonString');
        }
        catch (Exception e) {
            System.debug('Exception occured when initializing wrapper -> ' + e.getMessage());
            boolShowError = true;
            boolShowJSON = false;
            boolShowURLParams = false;
        }
    }
    
}