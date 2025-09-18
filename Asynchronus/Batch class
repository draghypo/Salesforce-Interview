                                									Batch Apex
								                            --------------------------
    Batch apex is a part of asynchronous. 

	Purpose:- As we know that in salesforce there are some governor limits, To access the record more than the governor limits we use batch apex.

    example-1. as we know the governor limits of total record retrived by soql query is 50000(50k) but in batch
			   apex 50 million. if we use normal class then give exception like (System.LimitException: Too many
			   query rows: 50001).

            List<Account> acc=[select id from account]; it will fetch if the records is not more than the 50k else will occur exception.
	        Note:- in batch apex, it can be fetched upto 50million and perform the dml operation as well.

	==> if we want to run batch apex then we have to implements batchable interface.

		Synatax of batch apex class:-   global class Sadiq implements Database.batchable <Sobject>{}

		There are three methods in batchable interface.
		a). start() - fetch all the records on which the logic has to run.
			syntax:-   global Database.queryLocator or(Iterable<Sobject>) start(Database.batchableContext bc){}
      			
		    Database.queryLocator :- if we want to write a soql query and get the data then we use it. we can use 50 millions records using soql. 
                                        normal class only 50k.

		        start method example with Database.queryLocator returntype:- 

								public Database.QueryLocator start(Database.BatchableContext bc){
       								 String query='SELECT id FROM account';
        							 return Database.getQueryLocator(query); // send to execute method.
   								}

		    Iterable<Sobject>:- Fetch the record using soql query or prepare your own record after storing that record in List, Set, Map and Wrapper perform the logic,
                                as you want and return that record.

                start method example with Iterable returntype:- 

                                global class BatchApexExample implements Database.Batchable<String> {
                                    global Iterable<String> start(Database.BatchableContext bc) {
                                        List<String> stringList = new List<String>{'Record 1', 'Record 2', 'Record 3', 'Record 4', 'Record 5'};
                                        return stringList;
                                    }
                                    global void execute(Database.BatchableContext bc, List<String> scope) {
                                        for(String str : scope) {
                                            System.debug('Processing record: ' + str);
                                            // Add your processing logic here
                                        }
                                    }
                                    global void finish(Database.BatchableContext bc) {
                                        System.debug('Batch job completed successfully.');
                                    }
                                }

	    b). execute() - in this method we perform bussiness logic as per the needed.it will call multiple time as per batch decided.
                
                    syntax:-  global void execute(Database.batchableContext bc, List<Object> obj){}

				    example:- global void execute(Database.batchableContext bc,List<Sobject> scope){
                                for(Sobject sObjRecord: scope){
                                    Account acc = (Account)sObjRecord;
                                    acc.rating='hot';
                                }
                                update acc;
                              }

	    c). finish() - in this method we can do final task what you want like send an email etc.
                    
                    syntax:- global void finish(Database.batchableContext bc){}

                                                Simple Program for understanding BatchApex.
                                            -----------------------------------------------------
                    global class ProjectResourceManagerAlerter implements Database.Batchable <Sobject> {
                        global Database.QueryLocator start(Database.BatchableContext bc) {
                            String query = 'SELECT Id, End_Date__c, Status__c, Project__r.Name, Project__r.Status__c, Project__r.End_Date__c, Resource__r.name, Resource__r.email FROM project_resource__c';
                            return Database.getQueryLocator(query);        
                        }
                        global void execute(Database.BatchableContext bc, List<Project_Resource__c> projectResourceList) {
                            List<string> email = new List<String>();
                            for (Project_Resource__c projectResource : projectResourceList) {
                                if (projectResource.End_Date__c > projectResource.Project__r.End_Date__c && projectResource.Status__c == 'Active' && projectResource.Project__r.Status__c == 'Completed') {
                                email.add(projectResource.Resource__r.email);                
                                }            
                            }
                            System.debug('list of email'+email);
                            System.debug('size of listofemail'+email.size());
                        }
                        global void finish(Database.BatchableContext bc) {
                        }
                    }
   
        ==> Run the batch apex below are the process.

			    example:-      BatchClassName batchInstance = new BatchClassName();
			                   Id jobId = Database.executeBatch(batchInstance, 5); // Here 5 means dividing all records into 5 batch, means allrecords/5.
                               1 Batch = TotalRecords/ number of batch.

			        Note:-  if we will not assign the batch by default it will take 200.
			                Minimum number of batch = 1
                            Maximum number of batch = 2000

        ==> Database.stateful:-  it is an interface which is used to transfer the data for one batch to other batch. if we don't use 
  					             Database.stateful we can not carry or anything from one batch to other batch so carry or anything from one
					             batch to other batch have to implements Database.stateful interface. and if we are holding the value in the variable
                                 or whatever it may be that should be instance varaible not static variable, if static that will not maintain the state.

                    syntax:- global class sadiq implements Database.batchable <Sobject>, Database.stateful{}

                    example:- . Want to calculate the total AnnualRevenue of Account object so we have a 200000 lakh record.
                            
                         Solution:- public class BatchApexTest implements Database.Batchable<sObject>,Database.stateful {
                                        public static Decimal totalAnnualRevenueStatic = 0.0;
                                        public Decimal totalAnnualRevenueInstance = 0.0;
                                            public Database.queryLocator start(Database.BatchableContext bc) {
                                            return Database.getQueryLocator('SELECT Id, Name, AnnualRevenue from Account WHERE AnnualRevenue != NULL');
                                            
                                        }
                                        public void execute(Database.BatchableContext bc, List<SObject> sObjectRecord) {
                                            for(sobject sobj : sObjectRecord) {
                                                Account acc = (Account)sobj;
                                                totalAnnualRevenueStatic = totalAnnualRevenueStatic + acc.annualRevenue;
                                                totalAnnualRevenueInstance = totalAnnualRevenueInstance + acc.AnnualRevenue;            
                                            }
                                        }
                                        public void finish(Database.BatchableContext bc) {
                                            System.debug('Total with static=='+totalAnnualRevenueStatic);       // output:-   0.0
                                            System.debug('Total with instance=='+totalAnnualRevenueInstance);  // output:- 123585784 as per your org data.
                                            
                                        }
                                    
                                    }

        ==> Database.AllowsCallouts:- It is an interface which is used to when we use callouts means performing Http resquest in the batch apex then 
                                        need to implements Database.AllowsCallouts.

                    Synatax:- public class BatchApexWithAllowsCallouts implements Database.Batchable<sObject>, Database.AllowsCallouts{}

                    example:- 
                                global class BatchClassWithAllowsCallouts implements Database.Batchable<sObject>, Database.AllowsCallouts {
    
                                    global Database.QueryLocator start(Database.BatchableContext BC) {
                                        return Database.getQueryLocator('SELECT Id, Name, Website FROM Account WHERE Website != null');
                                    }
                        
                                    global void execute(Database.BatchableContext BC, List<Account> scope) {
                                        for(Account acc : scope) {
                                            HttpRequest req = new HttpRequest();
                                            req.setEndpoint('https://api.example.com/external-service'); // dummy 
                                            req.setMethod('POST');
                                            req.setHeader('Content-Type', 'application/json');
                                            req.setBody('{"accountId": "' + acc.Id + '", "accountName": "' + acc.Name + '"}');
                                            HttpResponse res = new Http().send(req);
                                            if (res.getStatusCode() == 200) {
                                                acc.Description = 'Callout Successful';
                                            } 
                                            else {
                                                acc.Description = 'Callout Failed';
                                            }
                                        }
                                        update scope; // Update the processed records
                                    }
                        
                                    global void finish(Database.BatchableContext BC) {
                                        // Optional post-processing logic
                                    }
                                }
                
        ==> for more details visit on this link :- https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_batch_interface.htm







   
     			
