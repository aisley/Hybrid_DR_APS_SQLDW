-- =============================================
-- Author:		CAI - Microsoft APS-COE
-- Create date: 4/8/2015
-- Description:	Procedure to record the status of the Backup 
--              and Restore Process. 
-- =============================================
/*
Declare @BackupProcessStatusID int = 50  --ID of the BackupProcessStatus table to be updated.
	   ,@BackupProcessStatusStepID int = 36  --ID of the BackupProcessStatusSteps table to be updated 
	   ,@ArchiveLocation varchar(128) = '\\test\Foleder_name\folder' --Location where the backup set was archived.  This is stored in the BackupProcessStatus table

Exec usp_EndArchiveProcess @BackupProcessStatusID, @BackupProcessStatusStepID , @ArchiveLocation 
	*/
CREATE PROCEDURE [dbo].[usp_EndArchiveProcess] 
	 @BackupProcessStatusID int
	 ,@BackupProcessStatusStepID int
	,@ArchiveLocation varchar(128)
AS
BEGIN
	
	

	UPDATE [dbo].[BackupProcessStatus]
	   SET Status = 'Archive Process Complete'
			, [ArchiveDBBackupName] = @ArchiveLocation
			,[UpdateDate] = Getdate()
	 WHERE  Id = @BackupProcessStatusID

	Update [dbo].[BackupProcessStatusSteps]
			   SET [EndDate]= getdate() 
			   where Id = @BackupProcessStatusStepID
	
	

END
