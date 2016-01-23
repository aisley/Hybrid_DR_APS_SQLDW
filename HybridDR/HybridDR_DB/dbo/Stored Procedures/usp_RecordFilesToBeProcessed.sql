
-- =============================================
-- Author:		CAI - Microsoft APS-COE
-- Create date: 4/14/2015
-- Description:	Procedure to record each File that needs to be Processed by the Dual Load
-- =============================================
/*
DECLARE
	@ETLControlID int = 2,
	@FileName varchar(500) = 'c:\test\test.csv' --name of the File to Process

Exec usp_RecordFilesToBeProcessed
	@ETLControlID,
	@FileName

	
*/
CREATE PROCEDURE usp_RecordFilesToBeProcessed 
	@ETLControlID int = 2,
	@FileName varchar(500) = 'c:\test\test.csv' --name of the File to Process
AS
BEGIN
	Declare @ETLControlDetailID int = 0
	If(not Exists(select 1 from [dbo].[ETLControlDetail] where ETLControlID = @ETLControlID and FileName = @FileName))
	Begin
		insert into [dbo].[ETLControlDetail]
		Values (@ETLControlID, 1, @FileName, 1, 1)

		Select @ETLControlDetailID = SCOPE_IDENTITY() 
		
		Select 1 ProcessFile, @ETLControlDetailID ETLControlDetailID

	End
	Else select 0 ProcessFile, @ETLControlDetailID ETLControlDetailID


END
