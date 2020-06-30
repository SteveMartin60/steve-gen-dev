//..............................................................................

const pinsStandard      = require('./pins-standard'      );
const pinTableConstants = require('./pin-table-constants');

const
{
    docUtils,
    docConstants,
} = require('mesh-doc-utils');

const
{
    loadTextFileIntoString,
    loadTextFileIntoArray,
    getUniqueArray,
    fileExists,
    findFiles,
    isInArray,
    writeFileToDisk,
} = docUtils;


const
{
    getStandardDevicePinFields,
} = pinsStandard;

const
{
    fileExtensions,
} = docConstants;

const
{
    descriptionEnToDo,
    descriptionZhToDo,
    deviceSheetFilePath,
    meshDocModuleInterfacesPath,
    pinTypes,
    pinTypeToDo,
} = pinTableConstants;

const {path} = cxq;

var deviceSheetFiles           = [];
var moduleInterfaceFiles       = [];
var modulesInterfaceDataJSON   = {};
var modulesInterfaceDataSheets = {};
//..............................................................................

//..............................................................................
function loadModulesInterfaceDataJSON()
{
    var modulesInterfaceDataJSON = {};
    var moduleInterface         = {};
    var interfaceName           = '';

    for (var i = 0; i < moduleInterfaceFiles.length; i++)
    {
        if (fileExists(moduleInterfaceFiles[i]))
        {
            moduleInterface = JSON.parse(loadTextFileIntoString(moduleInterfaceFiles[i]));

            interfaceName = Object.keys(moduleInterface)[0];

            console.log('Loading: ' + interfaceName);

            modulesInterfaceDataJSON = Object.assign(moduleInterface, modulesInterfaceDataJSON);

            moduleInterface = {};
        }

    }

    return modulesInterfaceDataJSON;
}
//..............................................................................

//..............................................................................
function getPinFields(pin)
{
    var aPin = {};
    var item = {};
    var itemName = '';

    // console.log('Processing Pin: ' + pin.sheetName + '.' + pin.designator + '.' + pin.netName);

    for (var i = 0; i < Object.keys(modulesInterfaceDataJSON).length; i++)
    {
        itemName = Object.keys(modulesInterfaceDataJSON)[i];

        item =  modulesInterfaceDataJSON[itemName];

        for (var j = 0; j < Object.keys(item).length; j++)
        {
            aPin = item[j];

            if (aPin.netName === pin.netName)
            {
                pin.descriptionEn = aPin.descriptionEn;
                pin.descriptionZh = aPin.descriptionZh;

                return pin;
            }
        }
    }

    return pin;
}
//..............................................................................

//..............................................................................
function getPinType(pinRecord, sheetName)
{
    if (pinRecord.indexOf('ELECTRICAL') === -1 ) return 'Input';

    var pinTypeIndex = pinRecord.substring(pinRecord.indexOf('ELECTRICAL')) + '|';

    pinTypeIndex = pinTypeIndex.substring(11, pinTypeIndex.indexOf('|')).trim();

    return pinTypes[pinTypeIndex];
}
//..............................................................................

//..............................................................................
function getPinsFromDeviceSheet(filePath)
{
    const pinLines   = [];
    const pinsObject = {};

    var designator = '';
    var pinType    = '';
    var pinRecords = [];
    var pinRecord  = [];
    var netName    = '';
    var pin        = {};

    var sheetName = path.basename(filePath);

    sheetName = sheetName.substring(0, sheetName.indexOf('.'));

    console.time('Processing Device Sheet: ' + sheetName);

    var fileContent = loadTextFileIntoArray(filePath);

    for (var i = 0; i < fileContent.length; i++)
    {
        if (fileContent[i].indexOf('|RECORD=2|') > -1)
        {
            pinLines.push(fileContent[i]);
        }
    }

    for (i = 0; i < pinLines.length; i++)
    {
        pinRecord = pinLines[i];

        netName = pinRecord.substring(pinRecord.indexOf('NAME'));

        netName = netName.substring(5, netName.indexOf('|'));

        designator = pinRecord.substring(pinRecord.indexOf('DESIGNATOR')) + '|';

        designator = designator.substring(11, designator.indexOf('|')).trim();

        pinType = getPinType(pinRecord, sheetName);

        pinRecords.push(netName + '{{}}' + designator + '{{}}' + pinType)
    }

    pinRecords = getUniqueArray(pinRecords);

    for (i = 0; i < pinRecords.length; i++)
    {
        pinRecord = pinRecords[i];

        pin.netName    = pinRecord.substring(0, pinRecord.indexOf('{{}}')).trim();

        pinRecord = pinRecord.substring(pinRecord.indexOf('{{}}') + 4).trim();

        pin.designator = pinRecord.substring(0, pinRecord.indexOf('{{}}')).trim();

        pinRecord = pinRecord.substring(pinRecord.indexOf('{{}}') + 4).trim();

        pin.pinType    = pinRecord.trim();

        pin.sheetName  = sheetName;

        pin = getPinFields(pin);

        pin = getStandardDevicePinFields(pin);

        pinsObject[i] = pin;

        pin = {};
    }

    console.log    ('---------------------------------------');
    console.timeEnd('Processing Device Sheet: ' + sheetName);
    console.log    ('---------------------------------------');

    return pinsObject;
}
//..............................................................................

//..............................................................................
function getModuleSheetsInterfaceData()
{
    var moduleSheetsPinsAll = {};
    var moduleSheetPins     = {};
    var sheetName           = '';

    for (var i = 0; i < deviceSheetFiles.length; i++)
    {
        sheetName = path.basename(deviceSheetFiles[i]);

        moduleSheetPins = getPinsFromDeviceSheet(deviceSheetFiles[i]);

        if (Object.keys(moduleSheetPins).length < 2)
        {
            moduleSheetsPinsAll[sheetName] = 'Error: Not ASCII File Format';

            console.log('Error: ' + sheetName + ' ' + 'Not ASCII File Format')
        }
        else moduleSheetsPinsAll[sheetName] = moduleSheetPins;
    }

    return moduleSheetsPinsAll;
}
//..............................................................................

//..............................................................................
function generateModulesInterfaceDataJSON()
{
    var deviceSheet     = {};
    var deviceSheetName = '';
    var pinReport       = [];
    var pin             = {};
    var pinNumber       = '';
    var line            = '';

    pin.pinType       = '';
    pin.descriptionEn = '';
    pin.descriptionZh = '';

    var netNameLength       = 0;
    var designatorLength    = 0;
    var sheetNameLength     = 0;
    var pinTypeLength       = 0;
    var descriptionEnLength = 0;

    var netNameSpacer       = '';
    var designatorSpacer    = '';
    var sheetNameSpacer     = '';
    var pinTypeSpacer       = '';
    var descriptionEnSpacer = '';

    var fileToWritePath = '';
    var fileToWriteName = '';

    //modulesInterfaceDataJSON = modulesInterfaceDataSheets;

    if (0 && !0)
    {
        console.log(modulesInterfaceDataSheets);
        console.log(modulesInterfaceDataJSON);
    }

    for (var i = 0; i < Object.keys(modulesInterfaceDataJSON).length; i++) {
        deviceSheetName = Object.keys(modulesInterfaceDataJSON)[i];

        console.log('deviceSheetName: ' + deviceSheetName);

        deviceSheet = modulesInterfaceDataJSON[deviceSheetName];

        pinReport.push('{');

        pinReport.push('  "' + deviceSheetName + '": {');

        for (var j = 0; j < Object.keys(deviceSheet).length; j++) {
            pinNumber = Object.keys(deviceSheet)[j];

            pin = deviceSheet[pinNumber];

            console.log('deviceSheet[pinNumber]: ' + pin.sheetName + '.' + pin.designator);

            pin = getStandardDevicePinFields(pin);

            if (!pin.pinType)
            {
                pin.pinType = pinTypeToDo;
            }
            if (!pin.pinType       || pin.pinType       === undefined || pin.pinType       === 'undefined') pin.pinType       = pinTypeToDo;
            if (!pin.descriptionEn || pin.descriptionEn === undefined) pin.descriptionEn = descriptionEnToDo;
            if (!pin.descriptionZh || pin.descriptionZh === undefined) pin.descriptionZh = descriptionZhToDo;

            if (pin.netName      .length > netNameLength      ) netNameLength       = pin.netName      .length;
            if (pin.designator   .length > designatorLength   ) designatorLength    = pin.designator   .length;
            if (pin.sheetName    .length > sheetNameLength    ) sheetNameLength     = pin.sheetName    .length;
            if (pin.pinType      .length > pinTypeLength      ) pinTypeLength       = pin.pinType      .length;
            if (pin.descriptionEn.length > descriptionEnLength) descriptionEnLength = pin.descriptionEn.length;
        }

        for (j = 0; j < Object.keys(deviceSheet).length; j++)
        {
            netNameSpacer       = '';
            designatorSpacer    = '';
            sheetNameSpacer     = '';
            pinTypeSpacer       = '';
            descriptionEnSpacer = '';

            pinNumber = Object.keys(deviceSheet)[j];

            pin = deviceSheet[pinNumber];

            while ((netNameSpacer      .length + pin.netName      .length) < netNameLength      ) netNameSpacer       = netNameSpacer       + ' ';
            while ((designatorSpacer   .length + pin.designator   .length) < designatorLength   ) designatorSpacer    = designatorSpacer    + ' ';
            while ((sheetNameSpacer    .length + pin.sheetName    .length) < sheetNameLength    ) sheetNameSpacer     = sheetNameSpacer     + ' ';
            while ((pinTypeSpacer      .length + pin.pinType      .length) < pinTypeLength      ) pinTypeSpacer       = pinTypeSpacer       + ' ';
            while ((descriptionEnSpacer.length + pin.descriptionEn.length) < descriptionEnLength) descriptionEnSpacer = descriptionEnSpacer + ' ';

            if (pinNumber.length === 1) line = '      "' + pinNumber + '": { ';
            if (pinNumber.length === 2) line = '     "'  + pinNumber + '": { ';
            if (pinNumber.length === 3) line = '    "'   + pinNumber + '": { ';

            line = line + '"netName": "'       + pin.netName       + '", ' + netNameSpacer;
            line = line + '"designator": "'    + pin.designator    + '", ' + designatorSpacer;
            line = line + '"sheetName": "'     + pin.sheetName     + '", ' + sheetNameSpacer;
            line = line + '"pinType": "'       + pin.pinType       + '", ' + pinTypeSpacer;
            line = line + '"descriptionEn": "' + pin.descriptionEn + '", ' + descriptionEnSpacer;
            line = line + '"descriptionZh": "' + pin.descriptionZh + '"';

            if (j > Object.keys(deviceSheet).length - 2)
            {
                line = line + '  }';
            }
            else
            {
                line = line + '  },';
            }

            pinReport.push(line);
        }

        pinReport.push('  }');
        pinReport.push('}');

        deviceSheetName = deviceSheetName.substring(0, deviceSheetName.indexOf('.'));

        fileToWritePath = meshDocModuleInterfacesPath + deviceSheetName.substring(0,2).toLowerCase() + '/';
        fileToWriteName = deviceSheetName + fileExtensions.json;

        if (!fileExists(fileToWritePath + fileToWriteName))
        {
            writeFileToDisk(pinReport.join('\n'), fileToWritePath, fileToWriteName);
        }

        pinReport = [];

        netNameLength       = 0;
        designatorLength    = 0;
        sheetNameLength     = 0;
        pinTypeLength       = 0;
        descriptionEnLength = 0;

        netNameSpacer       = '';
        designatorSpacer    = '';
        sheetNameSpacer     = '';
        pinTypeSpacer       = '';
        descriptionEnSpacer = '';
    }
}
//..............................................................................

//..............................................................................
/*
function getUniqueNetNames(deviceSheets)
{
    var deviceSheet = {};
    var deviceSheetName = '';
    var deviceSheetCount = Object.keys(deviceSheets).length;
    var pin = {};
    var uniqueNetNames = [];

    for (var i = 0; i < deviceSheetCount; i++)
    {
        deviceSheetName = Object.keys(deviceSheets)[i];

        deviceSheet =  deviceSheets[deviceSheetName];

        var pinCount = Object.keys(deviceSheet).length;

        for (var j = 0; j < pinCount; j++)
        {
            pin = deviceSheet[j];

            uniqueNetNames.push(pin.netName);

            pin = {};
        }

        deviceSheet = {};
    }

    uniqueNetNames = getUniqueArray(uniqueNetNames);

    uniqueNetNames.sort(sortAlphaNum);

    return uniqueNetNames;
}
*/
//..............................................................................

//..............................................................................
function generateNewInterfacesJSON()
{
    var moduleInterface = {};
    var interfaceName   = '';
    var interfaceNames  = [];
    var sheetNames      = [];
    var sheetName       = '';

    for (var i = 0; i < deviceSheetFiles.length; i++)
    {
        sheetName =  path.basename(deviceSheetFiles[i]);

        sheetName = sheetName.substring(0, sheetName.indexOf('.'));

        sheetNames.push(sheetName);
    }

    for (i = 0; i < moduleInterfaceFiles.length; i++)
    {
        interfaceName =  path.basename(moduleInterfaceFiles[i]);

        interfaceName = interfaceName.substring(0, interfaceName.indexOf('.'));

        interfaceNames.push(interfaceName);
    }

    for (i = 0; i < sheetNames.length; i++)
    {
        if (!isInArray(sheetNames[i], interfaceNames))
        {
            for (var j = 0; j < Object.keys(modulesInterfaceDataSheets).length; j++)
            {
                sheetName = Object.keys(modulesInterfaceDataSheets)[j];

                if (sheetName.indexOf(sheetNames[i]) > -1)
                {
                    moduleInterface = modulesInterfaceDataSheets[sheetName];

                    modulesInterfaceDataJSON[sheetName] = moduleInterface;
                }
            }
        }
    }
}
//..............................................................................

//..............................................................................
function getFileLists()
{
    deviceSheetFiles = findFiles(deviceSheetFilePath, '.SchDoc', 'deviceSheetFiles');

    moduleInterfaceFiles = findFiles(meshDocModuleInterfacesPath + 'mb', fileExtensions.json, 'moduleInterfaceFiles');
}
//..............................................................................

//..............................................................................
function checkDeviceSheetsFormat()
{
    var deviceSheet = [];
    var errorsFound = false;
    var errors      = [];

    for (var i = 0; i < deviceSheetFiles.length; i++)
    {
        deviceSheet = loadTextFileIntoArray(deviceSheetFiles[i]);

        if(!(deviceSheet[0].substring(0, 26) === '|HEADER=Protel for Windows'))
        {
            errorsFound = true;

            errors.push(deviceSheetFiles[i]);
        }

    }

    if (errorsFound)
    {
        console.log('');
        console.log('-----------------------------------------------------------');
        console.log('Device Sheet Errors Found:');
        console.log('-----------------------------------------------------------');

        for (i = 0; i < errors.length; i++)
        {
            console.log(errors[i])
        }

        console.log('-----------------------------------------------------------');

        return false;
    }

    return true;
}
//..............................................................................

//..............................................................................
function  generateModuleInterfaces()
{
    console.time('Module Interfaces Generated');

    getFileLists();

    if (!checkDeviceSheetsFormat()) return;

    modulesInterfaceDataJSON = loadModulesInterfaceDataJSON();

    modulesInterfaceDataSheets = getModuleSheetsInterfaceData();

    generateNewInterfacesJSON();

    generateModulesInterfaceDataJSON();

    console.log    ('---------------------------------------');
    console.timeEnd('Module Interfaces Generated');
    console.log    ('---------------------------------------');
}
//..............................................................................

//..............................................................................
var exported =
{
    generateModuleInterfaces,
};
//..............................................................................

//..............................................................................

module.exports = exported;
