/**
 * @name SetupAuditTrail2LastSevenDays_BatchTest
 * @description : Test class for SetupAuditTrail2LastSevenDays_Batch

 */
@isTest
private class SetupAuditTrail2LastSevenDays_BatchTest {
    static testMethod void test() {
        Test.startTest();
        SetupAuditTrail2LastSevenDays_Batch c = new SetupAuditTrail2LastSevenDays_Batch();
        Database.executeBatch(c, 200);
        Test.stopTest();
    }
}