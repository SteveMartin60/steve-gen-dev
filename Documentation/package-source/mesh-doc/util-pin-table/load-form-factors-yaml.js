//..............................................................................

const
{
    docUtils,
    docConstants,
    docUtilsYAML,
} = require('mesh-doc-utils');

const
{
    fileExists,
    findFiles,
    getSafeNamePathString,
    replaceAll,
    writeFileToDisk,
} = docUtils;

const
{
    directoryNames,
    fileExtensions,
    fileNames,
} = docConstants;

const
{
    loadYamlObject,
} = docUtilsYAML;

const {path} = cxq;
//..............................................................................

//..............................................................................
function generateFormFactorsFromYAML(yamlObject, filePath)
{
    var pinsObject      = {};
    var field           = {};
    var pinTableJSON    = {};

    var fileToWritePath = path.dirname(filePath);
    var fileToWriteName = yamlObject.id + fileNames.formFactor + fileExtensions.json;
    var formFactor      = yamlObject.formFactor;

    if (formFactor.dimensions) var dimensions = formFactor.dimensions;
    if (formFactor.image     ) var image      = formFactor.image.filePath;
    if (formFactor.connectors) var connectors = formFactor.connectors;

    for (var i = 0; i < Object.keys(formFactor).length; i++)
    {
        field = formFactor[Object.keys(formFactor)[i]];
    }

    if (!fileExists(fileToWritePath + fileToWriteName))
    {
        //writeFileToDisk(pinTableJSON.join('\n'), fileToWritePath, fileToWriteName);

        console.log('Written: ' + fileToWriteName);
    }
    else
    {
        console.log('File Exists: ' + fileToWriteName)
    }
}
//..............................................................................

//..............................................................................
function loadFormFactors()
{
    var yamlDataObject = {};

    var filesYAML = findFiles(directoryNames.productSource, fileExtensions.yaml, 'filesYAML');

    for (var i = 0; i < filesYAML.length; i++)
    {
        yamlDataObject = loadYamlObject(filesYAML[i]);

        if (yamlDataObject.formFactor)
        {
            generateFormFactorsFromYAML(yamlDataObject, filesYAML[i]);
        }
    }

    console.log('All Form Factors Generated')
}
//..............................................................................

//..............................................................................
var exported =
{
    loadFormFactors,
};
//..............................................................................

//..............................................................................

module.exports = exported;
