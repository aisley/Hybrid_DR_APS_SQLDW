CREATE TABLE [dbo].[BackupProcessStatus] (
    [Id]                  INT            IDENTITY (1, 1) NOT NULL,
    [PDWID]               INT            NOT NULL,
    [DBBackupName]        NVARCHAR (128) NOT NULL,
    [DestDBBackupName]    NVARCHAR (128) NULL,
    [ArchiveDBBackupName] NVARCHAR (128) NULL,
    [DBName]              NVARCHAR (128) NOT NULL,
    [DestPDWID]           INT            NOT NULL,
    [Status]              VARCHAR (50)   NOT NULL,
    [BackupType]          CHAR (1)       NOT NULL,
    [CreateDate]          DATETIME       NOT NULL,
    [UpdateDate]          DATETIME       NOT NULL
);



