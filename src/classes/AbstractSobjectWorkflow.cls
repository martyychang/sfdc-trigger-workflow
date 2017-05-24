global abstract with sharing class AbstractSobjectWorkflow
        implements TriggerWorkflow {

    /**
     * Additional context not provided natively
     */
    protected TriggerContext context { get; set; }

    /**
     * This is the list of qualifying records to be processed by the workflow.
     * Basically whatever passes the entry criteria defined in the `qualify`
     * method.
     */
    protected List<Sobject> records { get; set; }

    /**
     * Default constructor which assumes no prior evaluation and prepares
     * a clean, empty list of qualifying records.
     */
    global AbstractSobjectWorkflow() {
        this.records = new List<Sobject>();

        // Assume trigger context will be provided by a service before
        // the workflow is evaluated and executed.
        this.context = null;
    }

    /** 
     * Evaluation is a tricky business. First, `Trigger.old` and `Trigger.new`
     * need to be examined differently depending on the DML operation
     * Second, to maintain continuity in a single-trigger context where
     * the same workflow may have actions that need to occur in the before
     * context as well as in the after context, `evaluate` should only occur
     * once in the before context with the same result carrying forward into
     * the `after` context.
     *
     * @return whether the workflow should execute based on the records
     *         being processed in the current trigger context, namely as
     *         returned by Trigger.new and/or Trigger.old
     */
    global Boolean evaluate() {

        // We make the assumption that the service is deployed in a
        // single-trigger pattern, where we should only ever be evaluating
        // records in the `before` context. In the `after` context, we can
        // then assume that we've already evaluated records and should
        // continue processing the records qualified in the `before` event
        // immediately preceding the `after` event.
        if (Trigger.isBefore) {
            if (Trigger.isUpdate) {
                for (Sobject eachRecord : Trigger.new) {
                    if (this.qualify(eachRecord, Trigger.oldMap.get(eachRecord.Id))) {
                        this.records.add(eachRecord);
                    }
                }
            }
            else if (Trigger.isInsert || Trigger.isUndelete) {
                for (Sobject eachRecord : Trigger.new) {
                    if (this.qualify(eachRecord, null)) {
                        this.records.add(eachRecord);
                    }
                }
            }
            else if (Trigger.isDelete) {
                for (Sobject eachRecord : Trigger.old) {
                    if (this.qualify(null, eachRecord)) {
                        this.records.add(eachRecord);
                    }
                }
            }
        }

        return this.records.size() > 0;
    }

    /**
     * The workflow should be smart, knowing what to do in the before context
     * and what to do in the after context. The key reason for this is that
     * field modifications (i.e., setting field values) should only be
     * performed in the before context when the record is still unlocked.
     */
    global void execute() {
        if (Trigger.isBefore) {
            for (Sobject eachRecord : this.records) {
                this.executeBefore(eachRecord);
            }
        }
        else if (Trigger.isAfter) {
            for (Sobject eachRecord : this.records) {
                this.executeAfter(eachRecord);
            }
        }
    }

    /**
     * Do something useful in the before context for a given record
     *
     * @param record
     */
    global abstract void executeBefore(Sobject record);

    /**
     * Do something useful in the after context for a given record
     *
     * @param record
     */
    global abstract void executeAfter(Sobject record);

    /**
     * @return false by default, the workflow does not support recursion or
     *         should not be executed for records that have already been
     *         processed in a previous DML operation in the same transaction
     */
    global Boolean isRecursive() {
        return false;
    }

    /**
     * Given the new record (where applicable) and the old record (where
     * applicable), determine whether the record meets the entry criteria
     * for the workflow.
     *
     * @param newRecord
     *            only available in insert, update, and undelete triggers
     * @param oldRecord
     *            only available in update and delete triggers
     *
     * @return whether the record in question meets the entry criteria
     *         for executing the associated workflow actions
     * 
     * @see "Trigger Context Variables" in the Apex Developer Guide for
     *      more information on what's available in different contexts
     */
    global abstract Boolean qualify(Sobject newRecord, Sobject oldRecord);

    /**
     * Apply a specific trigger context to this workflow, and return the
     * workflow in this new context for ease of chaining.
     *
     * @param context The new trigger context
     *
     * @return the workflow with the new context applied
     */
    global TriggerWorkflow withContext(TriggerContext context) {
        this.context = context;
        return this;
    }
}