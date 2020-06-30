function getModules()
{
    var itemCategories     = [];
    var itemCaptionsEn     = [];
    var itemCaptionsZh     = [];
    var itemDescriptionsEn = [];
    var itemDescriptionsZh = [];
    var meshMetaItem       = {};

    meshMetaItem.category = '';

    for (var i = 0; i < docDataObject.items.length; i++)
    {
        meshMetaItem = docDataObject.items[i];

        if (meshMetaItem.subcategory === subCategoryModule)
        {
            if (meshMetaItem.category       && !isInArray(meshMetaItem.category      , itemCategories    )) itemCategories    .push(meshMetaItem.category      );
            if (meshMetaItem.description_en && !isInArray(meshMetaItem.description_en, itemDescriptionsEn)) itemDescriptionsEn.push(meshMetaItem.description_en);
            if (meshMetaItem.caption_zh     && !isInArray(meshMetaItem.caption_zh    , itemCaptionsZh    )) itemCaptionsZh    .push(meshMetaItem.caption_zh    );
            if (meshMetaItem.caption_en     && !isInArray(meshMetaItem.caption_en    , itemCaptionsEn    )) itemCaptionsEn    .push(meshMetaItem.caption_en    );
            if (meshMetaItem.description_zh && !isInArray(meshMetaItem.description_zh, itemDescriptionsZh)) itemDescriptionsZh.push(meshMetaItem.description_zh);

            docDataObject.modules   .push(meshMetaItem   );
            docDataObject.modulesIds.push(meshMetaItem.id);
        }
    }

    for (i = 0; i < docDataObject.modules.length; i++)
    {
        var module = docDataObject.modules[i];

        if (!module.caption_en)
        {
            console.log('Test11')
        }
    }
}
//..............................................................................

//..............................................................................
