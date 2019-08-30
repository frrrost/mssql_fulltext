SELECT
cat.name,
    FULLTEXTCATALOGPROPERTY(cat.name,'ItemCount') AS [ItemCount],
    FULLTEXTCATALOGPROPERTY(cat.name,'MergeStatus') AS [MergeStatus],
    FULLTEXTCATALOGPROPERTY(cat.name,'PopulateCompletionAge') AS [PopulateCompletionAge],
    FULLTEXTCATALOGPROPERTY(cat.name,'PopulateStatus') AS [PopulateStatus],
    FULLTEXTCATALOGPROPERTY(cat.name,'ImportStatus') AS [ImportStatus]
FROM sys.fulltext_catalogs AS cat


select object_name(object_id), * from sys.fulltext_indexes
