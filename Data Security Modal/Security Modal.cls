                                                    Security Modal Salesforce
                                                ----------------------------------

    Data Modal Security Salesforce :- To protect a access and sensitive information in Salesforce from unauthorized access and breaches,
                                       ensuring that only authorized users can view or use the data. we can control over the object,
                                       fields,records and users.

        Level of Access:-
                           a). Organisation Level
                           b). object Level
                           c). field Level
                           e). records Level

            Organisation Level Access:- Through Org level access we can maintain a list of authorized users.
        ---------------------------------

                            a). Set Password Policies :- we can set the Password Policies like Password expires in,password should be 
                                                        contain alphanumeric etc, remember maximum invalid attempts etc, while creating
                                                        a user profile is mandatory so on profile we can give the limation of Password 
                                                        realted.

                            b). Login Hour :- We can restrict access to the login and assign them permissions as per needed.
                                            details:- Through Profile level we can restrict the login access on particaulr days and
                                                      time as well,
                                                Note:- if we keep nothing in login hour user can login any time.
                                                       if we want to restrict all days keep start and end timing 12am to 12am fo the day.
                                                       if we want to give access the login hour timings while seting we need to set as
                                                                              per the GMT-07:00 , means 12 hours 30 min minus.
                                                       want to give access on sunday 3:30 PM to 4:30 PM, assign on profile 3am to 4am,
                                                       conculusion:- current Ist time - 12 hours 30 min .


                            c). IP Restriction :- we can restrict through the IP address, they can login only if IP address lies between 
                                                  what we provide in start address or end address. eg:- 183.82.124.217 to 184,34,128,244

            Object Level Access:- We can control both standard and custom objects through profile and permissionset.
        ---------------------------
                                details:- we can assign the permission through profile and permissionset view edit delete viewall
                                 and modifyall.
                                note:- profile level permission can not be decrease by permission set only will be increased.

                                            Diffrences between Profile and permissions set
                                        ---------------------------------------------------------
                a). User can have only one profile but user can have multiple permission sets.
                b). Organisation related like login hour, ip restriction can be defined on profile level only not on permission sets.
                c). Through permission set we can increase  the accesss but not decrease the access.

            Field Level Access:- We can restrict the access through field level if having a oject level access.
        -----------------------------
                                details:-  we can restrict the access to field level if it's having a object level access and make a 
                                            field visible to a particular user and can be hidden for the  another user.
                                           Field level security can be controlled using profiles and permission sets.

            Records level security:- We can manage record level access through following ways. we can restrict access to records for user
        --------------------------------                                           if user has object level permission.

            Example:- A user can view his records but not others, to manage this we have following approach below.
                a). OWD (Organisation wide default, sharing setting)
                b). Role 
                c). Sharing Rules
                d). Manual Sharing

                a) OWD :- Organisation wide default, it specifies the default level of access of records.
                          OWD setting lock down the data to the most restrictive  level.
                          we have three access level
                            a). Private:- if owd is private other user can not see the other records except system admin.
                                Note:- we can use other record level security to open up the sharing records.
                                    :- System admin can see all the records even owd is private.
                                    :- Record owner, system admin and view all permission user can see and edit the records.
                                    :- After assigning role hierarchy in above, above user can able to see the records.

                            b). Public read only:- if public read only will be given then only other user can able to see the records
                                                    if it's having a edit permission from profile or permissionset only then he can edit
                                                    his own records not others.

                            c). Public read/ write:- if public read/write will be given then other user can able to read and edit the 
                                                     records,but it should have permission from profile or permission set levels.

                b). Role  :- It gives access for users higher in the hierarchy. this user can access all the records owned by
                                      the user below them in the hierarchy.
                            Note:- if owd is private and role hierarchy is assign, Higher role can access the records of lower role.
                                :- on owd page "grant access using hierarchy" checkbox will work for custom object only for standard 
                                   by default checked can not be unchecked. for custom if it is unchecked can be access in the roles.

                c).Sharing Rules:- When two or more users, groups, or roles need to view records based on specific criteria and 
                                   ownership, and the organization-wide default (OWD) is set to private, you can create sharing 
                                   rules on the object to grant access to those records.
                        Note & Process:- sharing rules is used to open up the records if owd is set to private.
                                      :- Based on the ownership and criteria we can set the conditions,which records to be shared.
                                      :- Records will be shared to the public group, roles and roles and subordinates.

                d). Manual Sharing:- When the Organization-Wide Defaults (OWD) are set to private, you can share access to specific 
                                     records with public groups, roles, users, and roles and subordinates. There are buttons available 
                                     that allow you to assign access to particular records.
                        Note & Process:- sharing a particular record to user or role etc if owd is set to private.
                                      :- we have sharing button through we can assign some time it not availbel in lightning you need to
                                         migrate classic and you will be able to see.

            Apex Sharing:-  it allows us to programmatically assign access to the records using an Apex class,  who can view or edit 
        -------------------------------------                                   specific records based on your business requirements.

                Note:- for every custom object there is share object and even for some standard as well (Account, contact, case,lead etc).
                    :- Account --> AccountShare, contact-->contactShare etc.
                    :- for custom object instead of adding __C in the last add share only. eg:- Project__c --> Project__share.

                a). Scenario 1:- As we have two users Lavanya and Imran , When a account is created or updated by lavanya, then only it
                                 should be accessable by imran, as OWD is private.
                        Solution:- 
                            Trigger:-
                                         trigger ApexSharing on Account (after insert, after update) {
                                            if(Trigger.isAfter || Trigger.isUpdate) {
                                            SharingPractice.shareAccountRecordsToUserA(Trigger.New);
                                            }
                                        }
                            Apex Handler:- 
                                        public class SharingPractice {
                                            public static void shareAccountRecordsToUserA(List<Account> accList) {
                                                List<AccountShare> accShareList = new List<AccountShare>();  
                                                User toUser = [select id from user where username='pmimran@accellor.com' limit 1];
                                                User recordCreated = [select id from user where username='pmlavanya@accellor.com'];
                                                for(Account accRecords : accList) {
                                                    if(accRecords.CreatedById == recordCreated.Id) {
                                                        AccountShare accShare = new AccountShare();
                                                        accShare.AccountId = accRecords.Id;   		// Required field
                                                        accShare.AccountAccessLevel = 'Read';  	   // Required field
                                                        accShare.OpportunityAccessLevel = 'Read'; // Required field
                                                        accShare.UserOrGroupId = toUser.id;      // Required field
                                                        accShareList.add(accShare);
                                                    }
                                                }
                                                if(accShareList.size() > 0) {
                                                    insert accShareList;
                                                }
                                            }  
                                        }

                b). Scenario 2nd on custom object:- we have two users lavanya and imran, whenever a custom object record is created
                                                    or updated by lavanya it should be accessable by imran as OWD is private.

                            Solution:- original object name Boy__C and shar object Boy__share

                            Trigger:- 
                                trigger ApexSharingBoyObject on Boy__c (after insert,after update) {
                                    if(Trigger.isAfter || Trigger.isUpdate) {
                                        SharingPractice.shareBoyCustomObject(Trigger.New);
                                    }
                                }
                            Handler class:- 
                                public class SharingPractice {
                                    public static void shareBoyCustomObject(List<Boy__c> boyList) {
                                        List<Boy__share> boyShareList = new List<Boy__share>();  
                                        User toUser = [select id from user where username='pmimran@accellor.com' limit 1];
                                        User recordCreated = [select id from user where username='pmlavanya@accellor.com'];
                                        for(Boy__c boyRecords : boyList) {
                                            if(boyRecords.CreatedById == recordCreated.Id) {
                                                Boy__share boyShare = new Boy__share();
                                                boyShare.AccessLevel = 'read';  		// Required field
                                                boyShare.ParentId = boyRecords.id;     // Required field
                                                boyShare.UserOrGroupId = toUser.id;   // Required field
                                                boyShareList.add(boyShare);
                                            }
                                        }
                                        if(boyShareList.size() > 0) {
                                            insert boyShareList;
                                        }
                                    }
                                }
----------------------------------------------------------------------------------------------------------------------------
					    	With Sharing | Without Sharing | Inherited Sharing
					--------------------------------------------------------------------

	a). Without Sharing :-  without sharing apex class runs in the system Context,It does not enforce the sharing rules. When we query records, 
				all records will be fetched, even if the OWD is set to private. By default an Apex class is
				without sharing.
		Note:- With sharing/Without sharing / Inherited sharing work's only on Record level. 

		Example :- See the below class, getBoys method will return all the records of boy object. 

			public Without sharing class WithSharingPractice {
			   	@AuraEnabled
    				public static List<Boy__c > getBoys() {
        				List<Boy__c > boysList = [SELECT Id, Name FROM Boy__c ];
        				return boysList;
    				}
			}

	b). With Sharing :- with sharing apex class runs in the User context, it enforces the sharing rules. When we query
				records, it will fetch only those records to which the current user has access.

		Example:- See the below apex class, getBoys method will return those records which user has access only.

			public With sharing class WithSharingPractice {
   				@AuraEnabled
    				public static List<Boy__c > getBoys() {
        			List<Boy__c > boysList = [SELECT Id, Name FROM Boy__c ];
        			return boysList;
    				}
			}

	c). Inherited Sharing :- Inherited sharing Apex class runs in a dynamic context based on the main (parent) class.
				 If the parent class is "with sharing," the inherited class will behave as "with sharing.
				 " If the parent class is "without sharing," the inherited class will behave as "without 
				sharing." It dynamically determines the context in which the Apex class runs.it released 
				in winter19.

			Inherited sharing = with sharing + without sharing   => depends on the main class. but if we not declare main class without sharing then it will treat as a with sharing.

		Example : - See the below apex class.
				
				               Inherited Class
		-----------------------------------------------------------------------------------
		|	public inherited sharing class InheritedsharingPractice {                  |
     		|		@AuraEnabled							   |
    		|		public static List<Boy__c > getBoys() {				   |
        	|		List<Boy__c > boysList = [SELECT Id, Name FROM Boy__c ];	   |
        	|		return boysList;						   |
    		|		}								   |
		|	}									   |
		-----------------------------------------------------------------------------------

		Scenario 1: WithoutSharingPractice is calling the inherited class, so the inherited class will treat the method in "without sharing" mode.

					public without sharing class WithoutSharingPractice {
   						@AuraEnabled
   						public static List<Boy__c > getBoys() {
       						return InheritedsharingPractice.getBoys();
    						}
					}

		Scenario 2: WithSharingPractice is calling the inherited class, so the inherited class will treat the method in "with sharing" mode.

					public with sharing class WithSharingPractice {
    						@AuraEnabled
    						public static List<Boy__c > getBoys() {
        					return InheritedsharingPractice.getBoys();
    						}
					}

		Scenario 3: No_With_Without_SharingPractice is calling the inherited class, so the inherited class will treat the method in "with sharing" mode.

					public class No_With_Without_SharingPractice {
    						@AuraEnabled
    						public static List<Boy__c > getBoys() {
        					return InheritedsharingPractice.getBoys();
    						}
					}
************************************************************************************************************************************************************************
					WITH SECURITY_ENFORCED VS WITH USER_MODE VS Security.stripInaccessible VS Schema.SObjectType.Account.isAccessible() Etc
					***********************************************************************************************************************

WITH SECURITY_ENFORCED: - 
--------------------------
					It was the first major step Salesforce took to simplify security in Apex. Before it existed, developers had to write dozens of lines of 
					  Schema.SObjectType checks to ensure a user had permission to see every field in a query.
		  Points:- 
					1). Actually WITH SECURITY_ENFORCED do Enforce the Security to check the FLS(Field Level Security) and Object Level access check on every single field
				        and object mentioned in the SELECT, FROM, and WHERE clauses.
					2). It does not check on the Record level security, like owd sharing rules.
					3). It throws a System.QueryException if permissions are missing we should always wrap these queries in a try-catch block.
					4). We can not query polymorphic fields with "WITH SECURITY_ENFORCED" like owner, whatid or whoid.
                 polymorphic fields:- suppose owner field, owner can be a user or queue. so modern fix is WITH USER_MODE.
      	Syntax:-  List<Account> accs = [SELECT Id, Name,Industry FROM Account WITH SECURITY_ENFORCED];  it will check the object level and FLS as well if any of 
							those field does not have an access it thorws an exception System.queryException.so use try and catch block.

			example with error handling: - try {
										    // Attempting to query a sensitive field
										    List<Contact> contacts = [SELECT Id, Social_Security_Number__c FROM Contact WITH SECURITY_ENFORCED];
										} catch (System.QueryException e) {
										    // If the user lacks FLS for the SSN field, the code jumps here
										    System.debug('Insufficient permissions: ' + e.getMessage());
										}

	WITH USER_MODE: - (The Modern Standard)
---------------------------
		Points: - 
				Definition: A comprehensive security keyword that enforces CRUD (Object-level), FLS (Field-level), and Sharing Rules (Record-level) in a single operation.		
				Scope: Works for both SOQL queries and DML statements (insert, update, upsert, delete, merge).
				Sharing: Always respects OWD and Sharing Rules, regardless of whether the class is marked with sharing or without sharing.
				Error Handling: Throws a System.SecurityException if any permission check fails.
		Syntax:  [SELECT Id FROM Account WITH USER_MODE]
	
		DML: insert as user myAccount; 
			 Database Methods: Database.insert(record, true, AccessLevel.USER_MODE);
			 Best For: All new development, UI-driven logic, and external API integrations.


	 Comparison Table
--------------------------------------------------------------------------------------------------------------------------------------------------------------------
			Feature                        		 WITH USER_MODE                                             				WITH SECURITY_ENFORCED
	--------------------------------------------------------------------------------------------------------------------------------------------------
            Primary Purpose				Modern, all-in-one security enforcement everything.						Legacy SOQL-only field/object filtering.
			Apex Version					API 58.0 and higher.,															API 45.0 to 57.0 (Legacy).
			Supported Operations			SOQL and DML (insert, update, etc.)												SOQL Only.
			Object/CRUD Checks,						Yes																		Yes		
			Field/FLS Checks						Yes																		Yes
			Record-Level Sharing,		Yes (Automatic). Overrides class header. 								No. Requires with sharing on the class.
			Exception Thrown				System.SecurityException												System.QueryException
			Polymorphic Fields			Supported. Handles Owner, WhatId, etc									Limited. Often fails on complex lookups.
			Execution Mode					Strictly User Context												User context on only soql
			Database Methods			Supports AccessLevel.USER_MODE												Not applicable.
-----------------------------------------------------------------------------------------------------------------------------------------------------------------

Security.stripInaccessible
--------------------------------

		Security.stripInaccessible:- This method is the "graceful" security filter in Apex. Unlike the strict keywords (WITH USER_MODE), it does not crash 
									 your code, it simply "sanitizes" your data by removing what the user isn't allowed to see or edit.

				Points: - 
							1). It can be used post query.
							2). It does not check OWD Sharing rules need to add with sharing etc.
							3). It removes the field which does not have an access and keep running the transaction.
				summary: - Use stripInaccessible when you want to sanitize data without stopping the execution flow. It is the best choice for "soft" security enforcement
							where a partial result is better than a total failure.

				Syntax:-  List<Contact> rawContacts = [SELECT FirstName, LastName, Secret_Note__c FROM Contact];
							// Sanitize the list
							SObjectAccessDecision decision = Security.stripInaccessible(AccessType.READABLE, rawContacts);

			 Access Type : - We must tell Salesforce what we are trying to do. Use the AccessType enum:

							AccessType.READABLE: Filter fields for a SELECT query.
							
							AccessType.CREATEABLE: Filter fields before an INSERT.
							
							AccessType.UPDATABLE: Filter fields before an UPDATE.
							
							AccessType.UPSERTABLE: Filter fields before an UPSERT.

					SObjectAccessDecision decision = Security.stripInaccessible(AccessType.READABLE, listAccounts);
								Extract the Removed Fields Map
					Map<String, Set<String>> removedFieldsMap = decision.getRemovedFields(); // where key as an object and values are fields.
			
		example: -  		READABLE

							@AuraEnabled(cacheable=true)
							    public static List<Account> searchAccounts(String searchKey) {
							        String query = 'SELECT Name, Phone, Social_Security_Number__c FROM Account WHERE Name LIKE :searchKey';
							        List<Account> rawResults = Database.query(query);
							        // STRIP fields the user isn't allowed to Social_Security_Number__c
							        SObjectAccessDecision decision = Security.stripInaccessible(AccessType.READABLE, rawResults); // removed unacess fields.
							        Map<String, Set<String>> removedFields = decision.getRemovedFields();
							        // Returns Name and Phone; Social_Security_Number__c is automatically removed for unauthorized users
							        return (List<Account>) decision.getRecords();
							    }

							CREATABLE

									public static void detailsOfStipInAccessible() {
											Lead newLead = new Lead(FirstName = 'John',LastName = 'Doe',Rating = 'Hot' /* User shouldn't be able to set this*/);
									        // Strip fields the user is not allowed to CREATE
									        SObjectAccessDecision decision = Security.stripInaccessible(AccessType.CREATABLE,new List<Lead>{newLead});
									        // The 'clean' lead will have Name, but Rating and Notes will be NULL
									        insert decision.getRecords();
									}

Comparison Table between WITH USER_MODE	VS Security.stripInaccessible method
-----------------------------------------------------------------------------------------------------------------------------------------------------
			Feature										WITH USER_MODE										Security.stripInaccessible
        -------------------------------------------------------------------------------------------------------------------------------
			Philosophy									Stop All or nothing									 Sift: Keep what is allowed
			Primary									 UseCore business logic/Integrity						UI Grids, Search, & External APIs
			Sharing Rules								Always Enforced.										Ignored (Needs with sharing).	
			Field Access							Throws SecurityException										Nulls out the field	
			DML Syntax									insert as user myObj;								Requires pre-processing steps
			System Fields								Respects all permissions								Never strips Id or OwnerId.
------------------------------------------------------------------------------------------------------------------------------------------------------
						




