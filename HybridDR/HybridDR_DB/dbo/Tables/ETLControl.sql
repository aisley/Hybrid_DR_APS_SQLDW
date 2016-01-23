CREATE TABLE [dbo].[ETLControl] (
    [Id]                INT           IDENTITY (1, 1) NOT NULL,
    [ControlProcess]    VARCHAR (128) NOT NULL,
    [LastRunDate]       DATETIME      NOT NULL,
    [FileNameLike]      VARCHAR (128) NULL,
    [FilePath]          VARCHAR (500) NULL,
    [ToBeProcessedPath] VARCHAR (500) NULL,
    [ArchivePath]       VARCHAR (500) NULL,
    CONSTRAINT [PK_ETLControl] PRIMARY KEY CLUSTERED ([Id] ASC)
);

