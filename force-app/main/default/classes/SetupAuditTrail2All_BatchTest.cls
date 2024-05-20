/**
 * @description   : Test class for SetupAuditTrail2All_Batch
 */
@isTest
private class SetupAuditTrail2All_BatchTest {
   static testMethod void test() {
      Test.startTest();
      SetupAuditTrail2All_Batch c = new SetupAuditTrail2All_Batch();
      Database.executeBatch(c, 200); 
      Test.stopTest();
   }
}