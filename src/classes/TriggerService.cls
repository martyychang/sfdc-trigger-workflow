global with sharing class TriggerService {

    /**
     * The static registry of trigger services that have been invoked
     * in the current transaction, where the key for each service is
     * the Sobject name for the object on which the trigger is defined.
     */
    private static final Map<String, TriggerService> servicesByName =
            new Map<String, TriggerService>();

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
    global static TriggerService getInstance(String name) {
        
        // If no service has been initialized yet for the given Sobject,
        // first initialize and register the service.
        if (!servicesByName.containsKey(name)) {
            servicesByName.put(name, new TriggerService());
        }

        // Return the singleton service
        return servicesByName.get(name);
    }

    global TriggerWorkflow getWorkflow(Type workflowType) {
        return (TriggerWorkflow)workflowType.newInstance();
    }

    /**
     * Given a list of TriggerWorkflow subclass types, perform the appropriate
     * workflow actions for each type, carefully managing interdependencies
     * and recursion considerations.
     *
     * @param workflowTypes
     *.           A list of types, for example, as expected from 
     *            LeadAssignWorkflow.class
     */
    global void process(List<Type> workflowTypes) {
        for (Type eachType : workflowTypes) {
            
            // Get the workfow, trusting the getter to return an appropriate
            // workflow for the given context. Specifically, it'd be awesome
            // to get one instance of the workflow for continuity of execution
            // between the before context and the after context.
            TriggerWorkflow workflow = this.getWorkflow(eachType);

            // Evaluate the workflow's entry criteria, then execute the workflow
            // if there are any qualifying records to process.
            if (workflow.evaluate()) {
                workflow.execute();
            }
        }
    }
}