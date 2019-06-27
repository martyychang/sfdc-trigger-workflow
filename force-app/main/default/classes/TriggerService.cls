/**
 * For the service, it's important to define two key words to avoid confusion.
 *
 * First, "recursion" means that triggers and other automation are executing
 * on a particular record as a result of a DML operation performed in the same
 * transaction but where a DML operation has already been performed on that
 * particular record.
 *
 * For example, a Lead trigger creates a child task, and the
 * task meets entry criteria for a Task trigger that then updates the parent
 * lead. This is one transaction, and when the same Lead trigger fires as
 * a result of the Task trigger firing, this situation is considered recursion.
 *
 * It's important to note that in a single batch of records, recursion may
 * only apply to a subset of those records. This is a Venn diagram situation
 * where the initial batch of records processed by a trigger has some but
 * not complete overlap with a subsequent batch of records processed by the
 * same trigger in a single transaction.
 *
 * Second, "rerun" means that in a single DML operation, triggers are being
 * re-run as a result of a workflow field update.
 *
 * In a rerun situation, the batch of records affected may only be a subset
 * of the records processed by the first run of the same trigger.
 *
 * For example, given two leads, A and B, that are inserted in the same
 * transaction, where only B meets entry criteria for a native workflow rule
 * that performs a field update, when the trigger is rerun only B is expected
 * to be included in `Trigger.new`.
 *
 * It's important to note that this service is _only_ compatible with
 * a single-trigger pattern, where there's only one trigger using this service
 * in handling all `before` and `after` events.
 */
global with sharing class TriggerService {

    private List<TriggerWorkflow> activeWorkflows { get; set; }

    /**
     * Additional context for the trigger not provided natively
     */
    private TriggerWorkflowContext context { get; set; }

    private TriggerWorkflowSelector selector;

    /**
     * The static registry of trigger services that have been invoked
     * in the current transaction, where the key for each service is
     * the Sobject name for the object on which the trigger is defined.
     */
    private static final Map<String, TriggerService> servicesByName =
            new Map<String, TriggerService>();

    private String sobjectName { get; set; }

    /**
     * The service-specfiic registry of invoked workflows, used to return
     * the same workflow for processing continuity when a workflow has
     * actions to execute in both the before context and the after context
     * within a single DML operation.
     */
    private Map<String, TriggerWorkflow> workflowsByName { get; set; }

    global TriggerService(String sobjectName) {
        this(
            sobjectName,
            TriggerWorkflowContext.getInstance(),
            TriggerWorkflowSelector.newInstance()
        );
    }

    global TriggerService(
        String sobjectName,
        TriggerWorkflowContext context,
        TriggerWorkflowSelector selector
    ) {
        this.sobjectName = sobjectName;
        this.context = context;
        this.selector = selector;

        this.activeWorkflows = new List<TriggerWorkflow>();
        this.workflowsByName = new Map<String, TriggerWorkflow>();
    }

    global List<TriggerWorkflow> getActiveWorkflows() {

        // If there are no workflows cached, look for active ones
        if (this.activeWorkflows.isEmpty()) {
            for (TriggerWorkflow__mdt eachEntry
                    : this.selector.selectActiveBySobjectNameAndContext(
                        this.sobjectName,
                        this.context
                    )
            ) {
                this.activeWorkflows.add(
                    this.getWorkflow(eachEntry.DeveloperName)
                );
            }
        }

        // Return the remembered, cached workflows
        return this.activeWorkflows;
    }

    /**
     * Given an Sobject name, return the persistent singleton service for
     * that object which can provide additional context for any executed
     * trigger workflows.
     *
     * @param  sobjectName
     *             For example, as expected from
     *             Schema.sobjectType.ApexTruth__c.getName()
     * @return the TriggerService object for the given Sobject
     */
    global static TriggerService getInstance(
        String name,
        TriggerWorkflowContext context
    ) {
        
        // If no service has been initialized yet for the given Sobject,
        // first initialize and register the service.
        if (!servicesByName.containsKey(name)) {
            servicesByName.put(name, new TriggerService(name));
        }

        // Update the context for the service
        TriggerService service = servicesByName.get(name);
        service.context = context;

        if (service.context.isRerunEnabled()) {
            refreshContext(service);
        }

        // Return the service
        return service;
    }

    global TriggerWorkflow getWorkflow(String workflowName) {
        return this.getWorkflow(workflowName, Type.forName(workflowName));
    }

    /**
     * In a simple DML operation where before triggers run and after triggers
     * run, this method should initialize a new workflow if it's the first time
     * the workflow is being invoked either in the before context or
     * in the after context. But if a workflow field update or something else
     * causes the triggers to re-run, a new instance of this workflow should
     * be constructed, initialized and returned.
     *
     * Consider a DML update scenario where a field update causes
     * triggers to re-run.
     *
     * - In the first before update context, this method returns a new
     *   workflow object.
     * - In the first after update context, this method returns the same
     *   workflow object.
     * - In the second before update context, this method returns a new
     *   workflow object, which is _not_ the same as what was constructed in
     *   the first before update context.
     * - In the second after update context, this method returns the
     *   second workflow object, not the first one.
     *
     * @return the appropriate workflow for the given context
     */
    global TriggerWorkflow getWorkflow(String workflowName, Type workflowType) {

        // We know that every time we hit a before context, a new workflow
        // object must be constructed. The only complication is that in the
        // after context, we need to check whether a workflow object has
        // already been constructed and should be returned.
        Boolean isRegistered =
                this.workflowsByName.containsKey(workflowName);

        if (this.context.isBefore || !isRegistered) {

            // Initialize a new instance of the workflow
            TriggerWorkflow workflow =
                    (TriggerWorkflow)workflowType.newInstance();

            // Register the workflow
            this.workflowsByName.put(workflowName, workflow);
        }

        // Return the registered workflow
        return this.workflowsByName.get(workflowName);
    }

    /**
     * Given a list of TriggerWorkflow subclass types, perform the appropriate
     * workflow actions for each type, carefully managing interdependencies
     * and recursion considerations.
     */
    global void process(List<TriggerWorkflow> workflows) {
        for (TriggerWorkflow eachWorkflow : workflows) {
            if (eachWorkflow.withContext(this.context).evaluate()) {
                eachWorkflow.execute();
            }
        }
    }

    /**
     * Convenience method for processing all active workflows instead of
     * calling `process` with the results from `getActiveWorkflows`
     */
    global void processActiveWorkflows() {
        this.process(this.getActiveWorkflows());
    }

    /**
     * Refresh the context for a service, specifically to note whether the
     * trigger is executing again as a result of a field update.
     */
    global static void refreshContext(TriggerService service) {

        // Assume not a rerun
        Boolean rerun = false;

        // Check the records and unset `IsProcessed__c` if a rerun is detected
        for (Sobject eachRecord : service.context.newRecords) {
            if (eachRecord.get('IsProcessed__c') == true) {
                rerun = true;
                eachRecord.put('IsProcessed__c', false);
            }
        }
        
        // Set the context correctly
        service.context.isRerun = rerun;
    }
}