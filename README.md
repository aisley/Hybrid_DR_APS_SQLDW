# A Framework to a Hybrid Disaster Recovery (DR) Solution between APS and Azure SQLDW  ##
 

## Importance for a DR solution ##
DR becomes more important as the business users begin to rely on the solutions running on an On-Premise APS to complete their day to day jobs.  As this reliance builds, the amount of down time the business user will tolerate becomes less.  At some point, the threshold of this tolerance may be exceeded during regular system maintenance and not just a complete outage of the system due to hardware or connectivity failures.  When this occurs, a DR solution needs to be implemented.  In the past, purchasing a secondary APS was the only solution.  With the development of Azure SQLDW, customers how have another option.

## Disaster Recovery vs Business Continuity ##
**Disaster recovery**

Disaster recovery focuses on the IT or technology systems that support business functions…

Defines the processes, policy and procedures related to recovering or continuing the use us of technology that is vital to an organization to continue business

**Business continuity**

Involves the planning and implementing processes to keep all aspects of business functioning during and after a disruptive event.

Includes people, facilities, security, access, etc. Anything that circumvents the technology boundary. The disaster recovery plan is part of the overall business continuity plan.
 

## Components to a Enterprise DR solution  ##
When implementing a DR solution, several items need to be considered.

**RTO – Recovery time objective**

How long (time: minutes, hours) do we have to recover the service?

- Defines the SLA RTO
- Defines or leverages existing technology capabilities or process
- Interfaces with other operational services

**RPO – Recovery point objective**

Revenue is protected up to the point of the disaster

The scope of the recovery which specifically states to what point do we recover the platform.

**Technical Considerations**

*Availability* - Ever heard of the ‘five nines’?

*Capability* - Are we capable of performing the task?

*Security Model* - Method to keep the Security Model between the Primary and Secondary APS’s in sync.

*Fail over* - Steps from Primary to Secondary

*Fail back* - Steps to switch from Secondary back to Primary

*Audit reports* - Validation reports to determine that both systems are in sync.  This should include Schema, security and data.

*Sync after an extended outage*  Synchronization should be bidirectional.

*Central Monitoring Database (DB) location * 

## Security Model Sync ##
Keeping the security model in sync between the two systems should be considered mandatory.  Currently APS and SQLDW does not have an automatic method of syncing security across two systems.   Therefore, it will be up to the individual organization to implement processes and procedures to keep the security model in sync.  
 
Options:

- Apply security changes to both systems at the same time.
- Generate a script to sync the two systems.  This can be completed for Active Directory Accounts only. 
 
## Failover/Failback Steps ##
The process of failing over and back should be tested from time to time.  This insures everything is working as expected and no surprises occur when an actual outage happens.  Best practice would be to have a mock DR drill scheduled from time to time.  

During this drill the steps for failing over and back can be tested.  To insure a smooth drill, the steps should be well documented.  

## Audit Reporting ##
Auditing the DR process is vital to making sure both systems are in sync.  Auditing starts with Configuration DB for the Load/backup Process and can go as deep as a customer needs.  Items to be monitored:

•	Load/Backup/Restore Process

•	Security

•	Schema

•	Data level if desired.  This can start at a high level and dive into individual records.
  
## Extended Outage ##
Having an outage longer than a few hours may require additional steps to return the two systems to a sync’d state.
 
###Dual Load###

This process tends to be less susceptible to extended outages.  Depending on how the load process is designed, the system may be able to catch up by processing all the load routines in order of receipt.  This will depend on the amount of data and the duration of each load process.

Determining how to handle an extended outage will need to be assessed at an individual DB and type of outage level.  

## Central Monitoring Database ##
A central monitoring DB is required for any DR process.  This central monitoring DB is used to keep track of each step in the process and report each step performed by each of the Systems.

The DB system needs to be available at all times.  Without the central monitoring DB, an organization and the DR process selected will not be able to keep track of the processes that have occurred.  

One potential solution would be to utilize Azure SQL DB.  This solution allows both the primary and Secondary APS systems to access the status DB without having to implement costly and redundant hardware.   


# Dual Load DR Process through Flat File Load #
A dual load process allows for both the Primary APS and Secondary SQLDW to be used at the same time, thus doubling the number of users that can access the data.

##The dual load process has both multiple benefits and complications. ##
###Benefits:###
- Both systems function independently of each other. 
- Data can be kept in sync on an interval from 5 to 10 minutes.  Sync speed is dependent on the source system, load process and volume of data.
- Audit checks can be put in place to make sure the data/security/schema is in sync.
- Maintenance can be performed on one system without the need to move large backup sets between data centers.
- Both systems do not need to be same size, configuration or release.
###Complications:###
- System generated ID’s will not match between the two systems.  
- Schema updates need to be completed on both systems
- Security changes need to be completed on both systems
- Additional work to implement ETL audit checks on data quality.

A flat file process allows an easy method to make sure both system stay 100% in sync.  By using flat files, if the Primary system has processed the same files as the Secondary system, the data should be 100% the same.  

A typical ETL process uses a control table to record when the last time the source system data was pulled.  When dual loading two systems, the dual ETL process will not pull the data at the same rate or at exactly the same time.  Therefore, having a central process that pulls the data and generates a flat file that both systems use, the potential of one system being different than the other will be lessened.

##PDW DR Architecture – Dual Load##
While there are several methods the implement a DR solution on APS, this section will cover a dual load approach using flat files.  The diagram below outlines an architecture that needs to be in place to fully take advantage of a dual load architecture.  

 
#IMAGE - Mid-level_Architecture#




All systems surrounding the DW system should be duplicated.  Without having all systems 100% redundant surrounding the DW, should one of the other systems fail, the end users will either not be able to access the data or new data will not be loaded to the DW solution.

## Central Monitoring Database - Dual Load Process ##
In order to implement a dual load flat file DR process, you need to create a process that tracks when a flat file has been loaded on both PDW systems. If the source system already provides a flat file, then half the ETL process is complete.  If the source does not provide a flat file, a dual load can still be accomplished.  However, additional work will need to be completed to create a flat file.  

The next section will walk through the steps to perform a dual load from flat files after the flat file has been created.  This process will retrieve all the files located in a central location to be processed.  It will then process the files in order based on create data.  The dual load process by flat file requires three SSIS packages to run and a central control DB.

**DualLoadInitProcess** – This package begins the dual load process by retrieving a list of flat files stored in a directory and recording the location and filename in the control db.  This SSIS package can be run on any SSIS server in the Primary DC.  If the Primary DC or the SSIS server is off line, this process should be started up on a SSIS server in the secondary DC.

**DualLoadDriver** - This package should be run on an SSIS Server in both DC’s.  The package reads the central control DB and determines the flat files that need to be loaded into the PDW that the SSIS server is responsible for loading.  Should one of the PDW or SSIS servers go offline, no steps will need to be taken.  When the PDW or SSIS server comes back online, the package will process the files that have not been processed for the given PDW. 

**ArchiveProcessedFiles** – This package reviews the control tables to determine what flat files have been processed by both systems.  If the file has been processed by both systems, the flat file will be moved to an archive location.  If the file has only been processed by one system, the files will remain on the disk until the other system can process the file. This SSIS package only needs to run in one DC.   


## Flat File Dual load Process Internals ##
Using a Flat File Dual Load process for DR requires the use of three SSIS packages and a central DB on SQL Server that is mirrored across both Data Centers. 
### Central SQL Server Dual load Tracking DB  ###
The tracking DB consists of 4 tables that track the dual load process.

![](https://github.com/aisley/Hybrid_DR_APS_SQLDW/blob/master/Images/ERD.jpg)


**PDW** – Identifies the source the Destination PDW connection information

![](https://github.com/aisley/Hybrid_DR_APS_SQLDW/blob/master/Images/PDW.jpg)

**ETLControl** – This table stores the configuration details for performing the dual load process for each ETL process.

![](https://github.com/aisley/Hybrid_DR_APS_SQLDW/blob/master/Images/ETLControl.jpg)

**ETLControlDetail** – Tracks each step of the dual load process for each file.

![](https://github.com/aisley/Hybrid_DR_APS_SQLDW/blob/master/Images/ETLControl.jpg)

ETLStatusCode – Stores the code to identify the step in the process.

![](https://github.com/aisley/Hybrid_DR_APS_SQLDW/blob/master/Images/ETLControl.jpg)

### Central SQL Server Dual load Tracking Stored Procedure  ###
The tracking solution consists of a stored procedure.

**usp_RecordFilesToBeProcessed** – Added record to the ETLControlDetail table for the files that need to be processed.
    
	
    DECLARE
	@ETLControlID int = 2, - ID of the ETLcontrol Record being processed
	@FileName varchar(500) = 'c:\test\test.csv' --name of the File to Process

    Exec usp_RecordFilesToBeProcessed
	@ETLControlID,
	@FileName>


###Central SQL Server Dual Load SSIS Packages###

**DualLoadInitProcess** – Begins the dual load ET Process

**Parameters:**

![](https://github.com/aisley/Hybrid_DR_APS_SQLDW/blob/master/Images/DualLoadInitProcess_Params.jpg)

![](https://github.com/aisley/Hybrid_DR_APS_SQLDW/blob/master/Images/DualLoadInitProcess_SSIS.jpg)

**DualLoadDriver** – Process each of the flat files on a given PDW.

**Parameters:**

![](https://github.com/aisley/Hybrid_DR_APS_SQLDW/blob/master/Images/DualLoadDriver_Parms.jpg)
![](https://github.com/aisley/Hybrid_DR_APS_SQLDW/blob/master/Images/DualLoadDriver_SSIS.jpg)

**ArchiveProcessedFiles** – Ends the Dual load ETL process by moving all processed files to the archive path.
**Parameters:	**

![](https://github.com/aisley/Hybrid_DR_APS_SQLDW/blob/master/Images/ArchiveProcessedFiles_Params.jpg)
![](https://github.com/aisley/Hybrid_DR_APS_SQLDW/blob/master/Images/ArchiveProcessedFiles_SSIS.jpg)

	



