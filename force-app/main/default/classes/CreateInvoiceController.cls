public class CreateInvoiceController {
    
    public Class LineItemWrapper {
        public String description {get;set;}
        public Integer quantity {get;set;}
        public Double unitAmount {get;set;}
        public String itemCode {get;set;}
        public String accountCode {get;set;}
        public String lineItemId {get;set;}
        public String taxType {get;set;}
        public Double taxAmount {get;set;}
        public Double lineAmount {get;set;}
        public Double discountAmount {get;set;}
        public String tracking {get;set;}
    }
    
    public class XeroWrapper {
        public String invoiceType {get;set;}
        public String contact {get;set;}
        public LineItemWrapper[] lineItems {get;set;}
        public Date invoiceDate {get;set;}
        public Date invoiceDueDate {get;set;}
        public String lineAmountType {get;set;}
        public String invoiceNumber {get;set;}
        public String reference {get;set;}
        public String url {get;set;}
        public String currencyCode {get;set;}
        public String currencyRate {get;set;}
        public String status {get;set;}
        public Boolean sentToContact {get;set;}
        public Date expectedPaymentDate {get;set;}
        public Date plannedPaymentDate {get;set;}
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
        System.debug('Displaying JSON');
        try {
			xero = new XeroWrapper();
            xero.invoiceType = 'ACCPAY';
            xero.contact = '00000';
            xero.invoiceDate = oppRecord.CloseDate;
            xero.invoiceDueDate = oppRecord.Invoice_Due_Date__c;
            xero.lineItems = new List<LineItemWrapper>();
            for (OpportunityLineItem lineItem: oppRecord.OpportunityLineItems) {
                LineItemWrapper lineItemWrap = new LineItemWrapper();
                lineItemWrap.description = lineItem.Description;
                lineItemWrap.lineItemId = lineItem.Id;
                lineItemWrap.itemCode = lineItem.Name;
                lineItemWrap.quantity = Integer.valueOf(lineItem.Quantity);
                lineItemWrap.unitAmount = lineItem.UnitPrice;
                lineItemWrap.accountCode = oppRecord.AccountId;
                lineItemWrap.taxType = 'INPUT';
                lineItemWrap.taxAmount = 0;
                lineItemWrap.lineAmount = lineItem.Quantity * lineItem.UnitPrice;
                lineItemWrap.discountAmount = 0;
                xero.lineItems.add(lineItemWrap);
            }
            boolShowJSON = true;
            boolShowURLParams = false;
            System.debug(xero + ' xero');
        }
        catch (Exception e) {
            System.debug('Exception occured when initializing wrapper -> ' + e.getMessage());
            boolShowError = true;
            boolShowJSON = false;
            boolShowURLParams = false;
        }
        finally {
            System.debug('boolShowError -> ' + boolShowError);
            System.debug('boolShowJSON -> ' + boolShowJSON);
            System.debug('boolShowURLParams -> ' + boolShowURLParams);
        }
    }
    
}