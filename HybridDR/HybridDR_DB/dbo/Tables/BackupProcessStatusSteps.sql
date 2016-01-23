CREATE TABLE [dbo].[BackupProcessStatusSteps] (
    [Id]                         INT      IDENTITY (1, 1) NOT NULL,
    [BackupProcessStatusID]      INT      NOT NULL,
    [BackupProcessID]            INT      NOT NULL,
    [BackupProcessStatusID_Full] INT      NULL,
    [BackupProcessStatusID_Diff] INT      NULL,
    [StartDate]                  DATETIME NOT NULL,
    [EndDate]                    DATETIME NULL
);


