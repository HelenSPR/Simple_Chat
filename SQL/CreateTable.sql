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