CREATE TABLE [dbo].[AspNetRoles] (
[Id]   NVARCHAR (128) NOT NULL,
[Name] NVARCHAR (256) NOT NULL,
CONSTRAINT [PK_dbo.AspNetRoles] PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [RoleNameIndex]
ON [dbo].[AspNetRoles]([Name] ASC);



CREATE TABLE [dbo].[AspNetUsers] (
[Id]                   NVARCHAR (128) NOT NULL,
[Email]                NVARCHAR (256) NULL,
[EmailConfirmed]       BIT             NULL,
[PasswordHash]         NVARCHAR (MAX) NULL,
[SecurityStamp]        NVARCHAR (MAX) NULL,
[PhoneNumber]          NVARCHAR (MAX) NULL,
[PhoneNumberConfirmed] BIT             NULL,
[TwoFactorEnabled]     BIT             NULL,
[LockoutEndDateUtc]    DATETIME       NULL,
[LockoutEnabled]       BIT             NULL,
[AccessFailedCount]    INT             NULL,
[UserName]             NVARCHAR (256)  NULL,
[Name]				   NVARCHAR(50)		NULL,
CONSTRAINT [PK_dbo.AspNetUsers] PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [UserNameIndex]
ON [dbo].[AspNetUsers]([UserName] ASC);


CREATE TABLE [dbo].[AspNetUserRoles] (
[UserId] NVARCHAR (128) NOT NULL,
[RoleId] NVARCHAR (128) NOT NULL,
CONSTRAINT [PK_dbo.AspNetUserRoles] PRIMARY KEY CLUSTERED ([UserId] ASC, [RoleId] ASC),
CONSTRAINT [FK_dbo.AspNetUserRoles_dbo.AspNetRoles_RoleId] FOREIGN KEY ([RoleId]) REFERENCES [dbo].[AspNetRoles] ([Id]) ON DELETE CASCADE,
CONSTRAINT [FK_dbo.AspNetUserRoles_dbo.AspNetUsers_UserId] FOREIGN KEY ([UserId]) REFERENCES [dbo].[AspNetUsers] ([Id]) ON DELETE CASCADE
 );


GO
CREATE NONCLUSTERED INDEX [IX_UserId]
ON [dbo].[AspNetUserRoles]([UserId] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_RoleId]
ON [dbo].[AspNetUserRoles]([RoleId] ASC);



CREATE TABLE [dbo].[AspNetUserLogins] (
[LoginProvider] NVARCHAR (128) NOT NULL,
[ProviderKey]   NVARCHAR (128) NOT NULL,
[UserId]        NVARCHAR (128) NOT NULL,
CONSTRAINT [PK_dbo.AspNetUserLogins] PRIMARY KEY CLUSTERED ([LoginProvider] ASC, [ProviderKey] ASC, [UserId] ASC),
CONSTRAINT [FK_dbo.AspNetUserLogins_dbo.AspNetUsers_UserId] FOREIGN KEY ([UserId]) REFERENCES [dbo].[AspNetUsers] ([Id]) ON DELETE CASCADE
);


GO
CREATE NONCLUSTERED INDEX [IX_UserId]
ON [dbo].[AspNetUserLogins]([UserId] ASC);



CREATE TABLE [dbo].[AspNetUserClaims] (
[Id]         INT            IDENTITY (1, 1) NOT NULL,
[UserId]     NVARCHAR (128) NOT NULL,
[ClaimType]  NVARCHAR (MAX) NULL,
[ClaimValue] NVARCHAR (MAX) NULL,
CONSTRAINT [PK_dbo.AspNetUserClaims] PRIMARY KEY CLUSTERED ([Id] ASC),
CONSTRAINT [FK_dbo.AspNetUserClaims_dbo.AspNetUsers_UserId] FOREIGN KEY ([UserId]) REFERENCES [dbo].[AspNetUsers] ([Id]) ON DELETE CASCADE
);


GO
CREATE NONCLUSTERED INDEX [IX_UserId]
ON [dbo].[AspNetUserClaims]([UserId] ASC);

/****** Object:  Table [dbo].[Messages]    Script Date: 06.12.2017 21:49:39 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Messages](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[UserId] [nvarchar](128) NOT NULL,
	[Date] [datetime] NOT NULL,
	[Message] [nvarchar](max) NULL,
 CONSTRAINT [PK_Messages] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO

/********************** JOB CLEAR DATA BASE ****************************************************/


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Spiridonova Helen
-- Create date: 06/12/2017
-- Description:	Clear data base
-- =============================================
CREATE PROCEDURE ClearDB
	
AS
BEGIN
	
	SET NOCOUNT ON;

	TRUNCATE TABLE [dbo].[Messages]
	TRUNCATE TABLE [dbo].[AspNetUserClaims]
	TRUNCATE TABLE [dbo].[AspNetUserRoles]
	TRUNCATE TABLE [dbo].[AspNetUserLogins]

	DELETE FROM  [dbo].[AspNetUsers]
	DELETE FROM [dbo].[AspNetRoles]
   	
END
GO

/********************  CREATE  JOB  BY  CLEAR  DB  *********************************************/


/****** Object:  Job [ClearDB]    Script Date: 07.12.2017 13:54:29 ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]    Script Date: 07.12.2017 13:54:29 ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'ClearDB', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'Clear old message', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'windraw', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [step_1]    Script Date: 07.12.2017 13:54:29 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'step_1', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'exec dbo.ClearDB', 
		@database_name=N'IdentityDb', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'ClearDB', 
		@enabled=1, 
		@freq_type=4, 
		@freq_interval=1, 
		@freq_subday_type=1, 
		@freq_subday_interval=0, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=0, 
		@active_start_date=20171207, 
		@active_end_date=99991231, 
		@active_start_time=0, 
		@active_end_time=235959, 
		@schedule_uid=N'1637d988-bc62-4c83-9d91-6da2e0281df9'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:

GO