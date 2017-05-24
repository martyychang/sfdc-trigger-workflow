# Salesforce Trigger Workflow Framework

An opinionated, lightweight framework enabling admins and junior developers to implement business rules in Apex. Bulk-friendly by design.

## Installation

Zip up the **src** directory and deploy with [Workbench][1] or your favorite IDE.

[1]: https://workbench.developerforce.com

## Quick Start

Let's say you're creating your first trigger on the Account object, and you want to implement a business rule to capitalize every letter in the Account Name field.

1. Create an unchecked-by-default checkbox field _named_ `IsProcessed__c` on the Account object.
2. Create and _activate_ a workflow rule on the Account object that always sets `IsProcessed__c` to TRUE.
3. Create an Apex class named `AccountCapitalizeWorkflow` as shown below.
4. Create a single trigger on the Account object named `AccountTrigger` as shown below.

### AccountCapitalizeWorkflow Class

```java
public class AccountCapitalizeWorkflow extends AbstractSobjectWorkflow {
    
    public override void executeBefore() {
        for (Account eachAccount : (List<Account>)this.records) {
            eachAccount.Name = eachAccount.Name.toUpperCase();
        }
    }
    
    public override void executeAfter() {
        /* do nothing */
    }
    
    public override Boolean qualify(Sobject newRecord, Sobject oldRecord) {
        return Trigger.isInsert || Trigger.isUpdate;
    }
}
```

All workflows must extend `AbstractSobjectWorkflow`. And as a result, three
methods at a minimum must be overridden.

* `executeBefore` can be used to do stuff with records (`this.records`) that meet the entry criteria before a record has been locked. For example, modify field values.
* `executeAfter` can be used to do stuff with records (`this.records`) that meet the entry criteria after a record has been locked. For example, create child records, enqueue asynchronous jobs.
* `qualify` defines the entry criteria

It's fine to do nothing in either `executeBefore` or `executeAfter`, but the methods must be overridden. This has the benefit of showing the reader at a glance that something or nothing is supposed to happen in either the `before` or `after` contexts.

### AccountTrigger Trigger

```java
trigger AccountTrigger on Account (
        before insert, after insert,
        before update, after update,
        before delete, after delete, after undelete) {

    // For readability, get a handle on the TriggerService object
    // for this Sobject type
    TriggerService service = TriggerService.getInstance(
            Schema.sobjectType.Account.getName());

    // Process all of the trigger workflows
    service.process(new List<Type> {
        AccountCapitalizeWorkflow.class
    });
}
```

This is a single trigger that handles all trigger events. The service is object-specific, so `TriggerService.getInstance` is used to get the appropriate service for the Account object.

The `process` method is called on the service to process an ordered list of workflows, where each workflow is added by its Apex type (i.e., class) via the `class` property.
