public class CreateInvoiceController {
    
    public Id origin_record {get;set;}
    public Id account {get;set;}
    public Date invoice_date {get;set;}
    public string invoice_due_date {get;set;}
    public String child_relationship_name {get;set;}
    public String line_item_description {get;set;}
    public string line_item_quantity {get;set;}
    public string line_item_unit_price {get;set;}
    
    public CreateInvoiceController() {
        try {
            if (ApexPages.currentPage().getParameters().get('origin_record') != null) {
                origin_record = String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('origin_record'));
            }
            if (ApexPages.currentPage().getParameters().get('account') != null) {
            	account = String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('account'));
            }
            if (ApexPages.currentPage().getParameters().get('invoice_date') != null) {
            	invoice_date = Date.parse(String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('invoice_date')));    
            }
            if (ApexPages.currentPage().getParameters().get('invoice_due_date') != null) {
                invoice_due_date = (String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('invoice_due_date')));
            }
            if (ApexPages.currentPage().getParameters().get('child_relationship_name') != null) {
            	child_relationship_name = String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('child_relationship_name'));    
            }
            if (ApexPages.currentPage().getParameters().get('line_item_description') != null) {
                line_item_description = String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('line_item_description'));
            }
            if (ApexPages.currentPage().getParameters().get('line_item_quantity') != null) {
            	line_item_quantity = String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('line_item_quantity'));    
            }
            if (ApexPages.currentPage().getParameters().get('line_item_unit_price') != null) {
             	line_item_unit_price = String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('line_item_unit_price'));   
            }            
        }
        catch (Exception e) {
            System.debug('Error occured during processing url params -> ' + e);
        }
    }
    
}