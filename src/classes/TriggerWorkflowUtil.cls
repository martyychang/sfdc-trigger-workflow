global class TriggerWorkflowUtil {

    /**
     * Given an `SObjectType`, determine whether the object supports
     * rerunnable trigger workflows by checking for the existence of
     * an `IsProcessed__c` field
     *
     * @param objectType
     *
     * @return `true` if the object supports rerunnable trigger workflows;
     *         `false` otherwise
     */
    global static Boolean isRerunSupported(Schema.SObjectType objectType) {

        // Get the object's describe info
        Schema.DescribeSObjectResult objectDesc = objectType.getDescribe();

        // Return whether the object has an `IsProcessed__c` field
        return objectDesc.fields.getMap().containsKey('IsProcessed__c');
    }
}