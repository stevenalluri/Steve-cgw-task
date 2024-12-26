Salesforce Data Modelling:
Created two Custom objects 'Invoice' and 'Line Item' with the necessary fields as mentioned in the document. Attached the screenshots in the email.
We can use the Standard Salesforce objects where we have 'Invoice' and 'InvoiceLine' objects for the same use case but due to dev org billing requirement, we are not able to create any invoices. So, created the custom objects.

Git:
Created a public git repository under the name “Steve-cgw-task” and pushed the vf page, apex class

Visualforce page:
Created a visual force page to display the table with url parameters. We are initialising the values in constructor of the apex class and displaying the data using a html table.
Salesforce is encoding the URL parameters. Attaching the decoded screenshot in the email

Apex class:
Created an apex class with the name “CreateInvoiceController”, declared the variables with appropriate data types and initialised them in the constructor. Added null checks before assigning the values to variables to avoid null pointer exceptions and wrapped the assignments in a try catch block for better error handling. Added the appropriate type castings and vulnerability handling.

Opportunity object:
Created a detail page button with the name Create Invoice which redirects to the visual force page and passes the parameters from the record. Added the button to opportunity layout.
