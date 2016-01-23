CREATE TABLE [dbo].[ETLStatusCode] (
    [Id]        SMALLINT      IDENTITY (1, 1) NOT NULL,
    [DescShort] VARCHAR (20)  NOT NULL,
    [DescLong]  VARCHAR (200) NOT NULL,
    CONSTRAINT [PK_ETLStatusCode] PRIMARY KEY CLUSTERED ([Id] ASC)
);

