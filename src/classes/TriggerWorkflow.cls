global interface TriggerWorkflow {

    /**
     * @return whether the workflow should execute, based on the presence
     *         or absence of records which meet the entry criteria
     */
    Boolean evaluate();

    /**
     * Do something useful
     */
    void execute();
}