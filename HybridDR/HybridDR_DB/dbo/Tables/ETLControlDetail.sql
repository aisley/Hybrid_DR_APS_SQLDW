CREATE TABLE [dbo].[ETLControlDetail] (
    [Id]                 INT            IDENTITY (1, 1) NOT NULL,
    [ETLControlID]       INT            NOT NULL,
    [Status]             SMALLINT       NOT NULL,
    [FileName]           NVARCHAR (500) NOT NULL,
    [PrimaryAPSStatus]   SMALLINT       NULL,
    [SecondaryAPSStatus] SMALLINT       NULL,
    CONSTRAINT [PK_ETLControlDetail] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_ETLControlDetail_ETLControl] FOREIGN KEY ([ETLControlID]) REFERENCES [dbo].[ETLControl] ([Id]),
    CONSTRAINT [FK_ETLControlDetail_ETLStatusCode] FOREIGN KEY ([Status]) REFERENCES [dbo].[ETLStatusCode] ([Id]),
    CONSTRAINT [FK_ETLControlDetail_ETLStatusCode1] FOREIGN KEY ([PrimaryAPSStatus]) REFERENCES [dbo].[ETLStatusCode] ([Id]),
    CONSTRAINT [FK_ETLControlDetail_ETLStatusCode2] FOREIGN KEY ([SecondaryAPSStatus]) REFERENCES [dbo].[ETLStatusCode] ([Id])
);

