/**
 * @name SetupAuditTrail2Last24Hours_BatchTest
 * @description : Test class for SetupAuditTrail2Last24Hours_Batch
 
 */
@isTest
private class SetupAuditTrail2Last24Hours_BatchTest {
    static testMethod void test() {
        Test.startTest();
        SetupAuditTrail2Last24Hours_Batch c = new SetupAuditTrail2Last24Hours_Batch();
        Database.executeBatch(c, 200);
        Test.stopTest();
    }
}