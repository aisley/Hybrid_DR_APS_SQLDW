-- =============================================
-- Author:		CAI - Microsoft APS-COE
-- Create date: 4/8/2015
-- Description:	Procedure to record the status of the Backup 
--              and Restore Process. 
-- =============================================
/*
Declare @BackupProcessStatusID int = 50 --Id of the BackupProcessStatus that needs to be updated
	,@ArchiveLocation varchar(128) = '\\test\Foleder_name'  --Archive Location where backup set will be moved

Exec usp_StartArchiveProcess @BackupProcessStatusID, @ArchiveLocation 
	*/
CREATE PROCEDURE [dbo].[usp_StartArchiveProcess] 
	@BackupProcessStatusID int
	,@ArchiveLocation varchar(128)
AS
BEGIN
	
	Declare  @BackupProcessStatusStepID int

	set @ArchiveLocation = (select  @ArchiveLocation + reverse(left(reverse(DestDBBackupName), charindex('\', reverse(DestDBBackupName)) -1)) from [dbo].[BackupProcessStatus] Where Id = @BackupProcessStatusID)

	UPDATE [dbo].[BackupProcessStatus]
	   SET Status = 'Archive Process Started'
			, [ArchiveDBBackupName] = @ArchiveLocation
			,[UpdateDate] = Getdate()
	 WHERE  Id = @BackupProcessStatusID

	INSERT INTO [dbo].[BackupProcessStatusSteps]
			   ([BackupProcessStatusID]
			   ,[BackupProcessID]
			   ,[BackupProcessStatusID_Full]
			   ,[BackupProcessStatusID_Diff]
			   ,[StartDate]
			   ,[EndDate])
	VALUES
			   (@BackupProcessStatusID
			   ,6
			   ,NULL
			   ,NULL
			   ,Getdate()
			   ,NULL)

	Select @BackupProcessStatusStepID = SCOPE_IDENTITY() 

	Select @BackupProcessStatusStepID as BackupProcessStatusStepID, @ArchiveLocation as ArchiveLocation

END
