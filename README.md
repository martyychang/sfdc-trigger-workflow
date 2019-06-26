# Salesforce Trigger Workflow Framework

An opinionated, lightweight framework enabling admins and junior developers to implement business rules in Apex. Bulk-friendly by design.

## Installation

Zip up the **src** directory and deploy with [Workbench][1] or your favorite IDE.

[1]: https://workbench.developerforce.com

## Quick Start

Let's say you're creating your first trigger on the Account object, and you want to implement a business rule to capitalize every letter in the Account Name field.

### One-time Account object setup

Create a single trigger on the Account object named `AccountTrigger` as shown below.

```java
trigger AccountTrigger on Account (
        before insert, after insert,
        before update, after update,
        before delete, after delete, after undelete) {

    // For readability, get a handle on the TriggerService object
    // for this Sobject type
    TriggerService service = TriggerService.getInstance(
        Schema.sobjectType.Account.getName(),
        TriggerWorkflowContext.getInstance()
    );

    // Process all of the trigger workflows
    service.processActiveWorkflows();
}
```

### Create the AccountCapitalizeWorkflow class

```java
public class AccountCapitalizeWorkflow extends AbstractSobjectWorkflow {
    
    /**
     * Code to execute in the `Trigger.isAfter` context. For insert
     * and update operations, this would be a good place to
     * create child records, enqueue async jobs, etc.
     */
    public override void executeAfter() {
        /* do nothing */
    }
    
    /**
     * Code to execute in the `Trigger.isBefore` context. For insert
     * and update operations, this is a good place to modify field
     * values on records being processed.
     */
    public override void executeBefore() {
        for (Account eachAccount : (List<Account>)this.records) {
            eachAccount.Name = eachAccount.Name.toUpperCase();
        }
    }

    /**
     * This is where entry criteria are defined, similar to
     * workflow rules.
     */
    public override Boolean qualify(Sobject newRecord, Sobject oldRecord) {
        
        // We are indiscriminately capitalizing the name
        // of an account every time a record is inserted or updated.
        return this.context.isInsert || this.context.isUpdate;
    }
}
```

All workflows must extend `AbstractSobjectWorkflow`. And as a result, three
methods at a minimum must be overridden.

* `executeBefore` can be used to do stuff with records (`this.records`) that meet the entry criteria before a record has been locked. For example, modify field values.
* `executeAfter` can be used to do stuff with records (`this.records`) that meet the entry criteria after a record has been locked. For example, create child records, enqueue asynchronous jobs.
* `qualify` defines the entry criteria

It's fine to do nothing in either `executeBefore` or `executeAfter`, but the methods must be overridden. This has the benefit of showing the reader at a glance that something or nothing is supposed to happen in either the `before` or `after` contexts.

### Define the trigger workflow for AccountCapitalizeWorkflow

Open Custom Metadata in Setup, then create a new Trigger Workflow record. The name and label should both be "AccountCapitalizeWorkflow". Trigger Workflow records are used by admins in an environment to control whether a specific trigger workflow should be active, just like regular workflow rules.
