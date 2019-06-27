public with sharing class DatabaseJockey {

    /**
     * Deletes a list of existing sObject records, such as individual accounts
     * or contacts, from your organization’s data.
     *
     * @param recordsToDelete
     *
     * @return results from the DML operation
     *
     * @see https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_methods_system_database.htm
     */
    public List<Database.DeleteResult> del(List<SObject> recordsToDelete) {
        return Database.delete(recordsToDelete, true);
    }
    
    /**
     * Adds an sObject, such as an individual account or contact,
     * to your organization's data.
     *
     * @param recordToInsert
     *
     * @return result from the DML operation
     *
     * @see https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_methods_system_database.htm
     */
    public Database.SaveResult ins(SObject recordToInsert) {
        return Database.insert(recordToInsert, true);
    }
    
    /**
     * Adds one or more sObjects, such as individual accounts or contacts,
     * to your organization’s data.
     *
     * @param recordsToInsert
     *
     * @return results from the DML operation
     *
     * @see https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_methods_system_database.htm
     */
    public List<Database.SaveResult> ins(List<SObject> recordsToInsert) {
        return Database.insert(recordsToInsert, true);
    }

    /**
     * @return a fresh jockey to perform DML operations
     */
    public static DatabaseJockey newInstance() {
        return new DatabaseJockey();
    }

    public List<SObject> query(String query) {
        return Database.query(query);
    }

    /**
     * Modifies an existing sObject record, such as an individual account
     * or contact, in your organization's data.
     *
     * @param recordToUpdate
     *
     * @return result from the DML operation
     *
     * @see https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_methods_system_database.htm
     */
    public Database.SaveResult upd(SObject recordToUpdate) {
        return Database.update(recordToUpdate, true);
    }

    /**
     * Modifies one or more existing sObject records, such as individual
     * accounts or contacts, in your organization’s data.
     *
     * @param recordsToUpdate
     *
     * @return results from the DML operation
     *
     * @see https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_methods_system_database.htm
     */
    public List<Database.SaveResult> upd(List<SObject> recordsToUpdate) {
        return Database.update(recordsToUpdate, true);
    }
}