/**
 * @Description :   Batch class to fetch SetupAuditTrail records and insert them into SetupAuditTrail2__c object.
 */
public with sharing class SetupAuditTrail2All_Batch implements Database.Batchable<sObject> {

    /**
     * @Description :   Start method to fetch SetupAuditTrail records.
     */
    public Database.QueryLocator start(Database.BatchableContext batchContext) {
    	String setupAuditTrailQuery = 'SELECT Id, Action, Display, CreatedBy.Name, CreatedDate FROM SetupAuditTrail';
    	if(Test.isRunningTest()) {
        	setupAuditTrailQuery += ' LIMIT 200';
    	}
    	return Database.getQueryLocator(setupAuditTrailQuery);
	}

    /**
     * @Description :   Execute method to insert SetupAuditTrail records into SetupAuditTrail2__c object.
     */
    public void execute(Database.BatchableContext batchContext, List<SetupAuditTrail> records) {
        String defaultCreatedByName = Label.SetupAuditTrail2_SfdcString;

        Map<Id, SetupAuditTrail> recordMap = new Map<Id, SetupAuditTrail>();
        for (SetupAuditTrail record : records) {
            recordMap.put(record.Id, record);
        }

        List<SetupAuditTrail2__c> existingRecords = [SELECT SetupAuditTrailRecordId__c FROM SetupAuditTrail2__c WHERE SetupAuditTrailRecordId__c IN :recordMap.keySet()];

        for (SetupAuditTrail2__c existingRecord : existingRecords) {
            recordMap.remove(existingRecord.SetupAuditTrailRecordId__c);
        }

        List<SetupAuditTrail2__c> newRecords = new List<SetupAuditTrail2__c>();
        for (SetupAuditTrail record : recordMap.values()) {
            String createdByName = String.isBlank(record.CreatedBy.Name) ? defaultCreatedByName : record.CreatedBy.Name;
            SetupAuditTrail2__c newRecord = new SetupAuditTrail2__c(
                SetupAuditTrailRecordId__c          = record.Id,
                Action__c                           = record.Action,
                Display__c                          = record.Display,
                SetupAuditTrailCreatedByName__c     = createdByName,
                SetupAuditTrailRecordCreatedDate__c = record.CreatedDate
            );
            newRecords.add(newRecord);
        }

        if (!newRecords.isEmpty()) {
            Database.SaveResult[] results = Database.insert(newRecords, false);
            logErrors(results);
        }
    }

    /**
     * @Description :   Finish method to log the completion of the batch process.
     */
    public void finish(Database.BatchableContext batchContext) {
        System.debug('Batch process completed. Processed ' + batchContext.getJobId());
    }

    /**
     * @Description :   Method to log errors while inserting records.
     */
    private void logErrors(Database.SaveResult[] results) {
        List<String> errorMessages = new List<String>();
        for (Database.SaveResult result : results) {
            if (!result.isSuccess()) {
                for (Database.Error error : result.getErrors()) {
                    errorMessages.add('Error inserting record: ' + error.getMessage());
                }
            }
        }
        if (!errorMessages.isEmpty()) {
            System.debug('Errors: ' + String.join(errorMessages, '\n'));
        }
    }
}