//..............................................................................

const {} = cxq;

const pinTableConstants = require('./pin-table-constants');

const
{
    isOriginalDataFile,
    meshDocModuleInterfacesPath,
} = pinTableConstants;

const
{
    docUtils,
    docConstants,
} = require('mesh-doc-utils');

const
{
    findFiles,
    isInArray,
    loadObjectJSON,
    replaceAll,
    writeFileToDisk,
} = docUtils;


const
{
    fileExtensions,
} = docConstants;


//..............................................................................

//..............................................................................
function hasMissingData(pin)
{
    if (pin.pinType      .indexOf('ToDo') > -1) return true;
    if (pin.descriptionEn.indexOf('ToDo') > -1) return true;

    return pin.descriptionZh.indexOf('ToDo') > -1;
}
//..............................................................................

//..............................................................................
function alignArrayElements(array)
{
    var position = 0;

    for (var i = 0; i < array.length; i++)   if (array[i].indexOf('designator') >  position) position = array[i].indexOf('designator'               );
    for (i     = 0; i < array.length; i++)while (array[i].indexOf('designator') <  position) array[i] = array[i].replace('designator', ' designator');

    position = 0;

    for (i = 0; i < array.length; i++)    if (array[i].indexOf('sheetName') >  position) position = array[i].indexOf('sheetName'               );
    for (i = 0; i < array.length; i++) while (array[i].indexOf('sheetName') <  position) array[i] = array[i].replace('sheetName', ' sheetName');

    position = 0;

    for (i = 0; i < array.length; i++)    if (array[i].indexOf('pinType') >  position) position = array[i].indexOf('pinType'               );
    for (i = 0; i < array.length; i++) while (array[i].indexOf('pinType') <  position) array[i] = array[i].replace('pinType', ' pinType');

    position = 0;

    for (i = 0; i < array.length; i++)    if (array[i].indexOf('descriptionEn') >  position) position = array[i].indexOf('descriptionEn'               );
    for (i = 0; i < array.length; i++) while (array[i].indexOf('descriptionEn') <  position) array[i] = array[i].replace('descriptionEn', ' descriptionEn');

    position = 0;

    for (i = 0; i < array.length; i++)    if (array[i].indexOf('descriptionZh') >  position) position = array[i].indexOf('descriptionZh'               );
    for (i = 0; i < array.length; i++) while (array[i].indexOf('descriptionZh') <  position) array[i] = array[i].replace('descriptionZh', ' descriptionZh');

    return array;

}
//..............................................................................

//..............................................................................
function generateMissingDataReport()
{
    var missingDataReport = [];
    var moduleInterface   = {};
    var interfaceName     = '';
    var pin               = {};
    var sheetsMissingData = [];
    var pinsMissingData   = [];

    var moduleInterfaceFiles = findFiles(meshDocModuleInterfacesPath, fileExtensions.json);

    for (var i = 0; i < moduleInterfaceFiles.length; i++)
    {
        if(!isOriginalDataFile(moduleInterfaceFiles[i]))
        {
            moduleInterface = loadObjectJSON(moduleInterfaceFiles[i]);

            interfaceName = Object.keys(moduleInterface)[0];

            moduleInterface = moduleInterface[interfaceName];

            for (var j = 0; j < Object.keys(moduleInterface).length; j++)
            {
                pin = moduleInterface[j];

                if (hasMissingData(pin))
                {
                    if (!isInArray(pin.sheetName, sheetsMissingData)) sheetsMissingData.push(pin.sheetName);


                    if (j < 10) pinsMissingData.push('0' + j + ': ' + replaceAll(JSON.stringify(pin, null, '    '), '\n', '').trim());
                    else        pinsMissingData.push(      j + ': ' + replaceAll(JSON.stringify(pin, null, '    '), '\n', '').trim());
                }
            }

            pinsMissingData = alignArrayElements(pinsMissingData);

            if (pinsMissingData.length > 0)
            {
                missingDataReport.push(pinsMissingData);
            }

            pinsMissingData = [];
        }
    }

    missingDataReport.unshift('');
    missingDataReport.unshift('===================================');
    missingDataReport.unshift(sheetsMissingData);
    missingDataReport.unshift('');
    missingDataReport.unshift('-----------------------------------');
    missingDataReport.unshift('Module Interfaces with missing data');
    missingDataReport.unshift('-----------------------------------');

    missingDataReport = JSON.stringify(missingDataReport, null, 4);

    missingDataReport = replaceAll(missingDataReport, '\\"', '');

    writeFileToDisk(missingDataReport, meshDocModuleInterfacesPath, 'pinsMissingData.txt');


    return missingDataReport;
}
//..............................................................................

//..............................................................................
var exported =
    {
        generateMissingDataReport,
    };
//..............................................................................

//..............................................................................

module.exports = exported;
