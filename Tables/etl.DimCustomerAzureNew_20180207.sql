CREATE TABLE [etl].[DimCustomerAzureNew_20180207]
(
[DimCustomerId] [int] NOT NULL IDENTITY(1, 1)
)
GO
CREATE CLUSTERED INDEX [IX] ON [etl].[DimCustomerAzureNew_20180207] ([DimCustomerId])
GO
