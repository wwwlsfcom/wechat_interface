use wechat
go

if object_id(N'[T_troubles]',N'U') is null
	create table T_troubles 
	(
		id nvarchar(100) not null
		,photo nvarchar(100)
		,describe nvarchar(500)
		,position nvarchar(500)
	)
go
if not exists(select 1 from SYSCOLUMNS where id = object_id('T_troubles') and name = 'isNew')
	alter table T_troubles	add isNew bit
go

IF NOT EXISTS ( SELECT name FROM sysobjects WHERE id = ( SELECT syscolumns.cdefault FROM sysobjects 
    INNER JOIN syscolumns ON sysobjects.Id=syscolumns.Id 
    WHERE sysobjects.name=N'T_troubles' AND syscolumns.name=N'isNew' ) 
)
	ALTER TABLE dbo.T_troubles  
	ADD CONSTRAINT col_isnew_def  
	DEFAULT 0 FOR isNew 
GO  