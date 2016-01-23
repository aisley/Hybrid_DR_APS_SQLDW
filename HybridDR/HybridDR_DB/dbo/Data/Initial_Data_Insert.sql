INSERT INTO [PDW]
           ([PDWName]
           ,[PrimaryPDW]
           ,[PDWIPAddress])
     VALUES
           ('APS', 1, '10.200.181.197,17001'), 
		   ('SQLDW', 0, 'sqlservercharis.database.windows.net');
		   

INSERT INTO [ETLControl]
           ([ControlProcess]
           ,[LastRunDate]
           ,[FileNameLike]
           ,[FilePath]
           ,[ToBeProcessedPath]
           ,[ArchivePath])
     VALUES
           ('DimEmployee'
           ,getdate()
           ,'DimEmployee*.csv'
           ,'Z:\DimEmployee'
           ,'Z:\DimEmployee\ToBeProcessed'
           ,'Z:\DimEmployee\Archived');



INSERT INTO [ETLStatusCode]
           ([DescShort]
           ,[DescLong])
     VALUES
           ('NP', 'Not Processed'), 
		   ('Processing', 'In Process'), 
		   ('Complete', 'Complete'), 
		   ('Archived', 'Archived - Process Complete')
GO




