//..............................................................................
const pinsStandard      = require('./pins-standard'      );
const pinTableConstants = require('./pin-table-constants');

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
    getStandardDevicePinFields,
} = pinsStandard;

const
{
    directoryNames,
    fileExtensions,
    fileNames,
    stringsUtil,
} = docConstants;

const
{
    pinTypeToDo,
} = pinTableConstants;

const
{
    loadYamlObject,
} = docUtilsYAML;

const {path} = cxq;
//..............................................................................

//..............................................................................
function getPinObject(pinString)
{
    var pin = {};

    pin.id            = pinString.substring(0, pinString.indexOf(' ')).trim();
    pinString         = pinString.substring(pinString.indexOf('|') + 1);
    pin.pinType       = pinString.substring(0, pinString.indexOf('|')).trim();
    pinString         = pinString.substring(pinString.indexOf('|') + 1);
    pin.pins          = pinString.substring(0, pinString.indexOf('|')).trim();
    pinString         = pinString.substring(pinString.indexOf('|') + 1);
    pin.descriptionEn = pinString.substring(0, pinString.indexOf('|')).trim();
    pinString         = pinString.substring(pinString.indexOf('|') + 1);
    pin.descriptionZh = pinString.trim();
    pin.descriptionZh = pin.descriptionZh || pin.descriptionEn;

    return pin;
}
//..............................................................................

//..............................................................................
function getPinTableJSON(pinTable, itemName)
{
    var pinTableJSON    = [];
    var pin             = {};
    var pinNumber       = '';
    var line            = '';

    pin.pinType       = '';
    pin.descriptionEn = '';
    pin.descriptionZh = '';

    var idLength            = 0;
    var pinsLength          = 0;
    var pinTypeLength       = 0;
    var descriptionEnLength = 0;

    var idSpacer            = '';
    var pinsSpacer          = '';
    var pinTypeSpacer       = '';
    var descriptionEnSpacer = '';

    pinTableJSON.push('{');

    pinTableJSON.push('  "' + itemName + '": {');

    for (var i = 0; i < Object.keys(pinTable).length; i++)
    {
        pin = pinTable[i];

        pinNumber = i;

        pin = getStandardDevicePinFields(pin);

        if (!pin.pinType)
        {
            pin.pinType = pinTypeToDo;
        }

        if (!pin.pinType || pin.pinType === undefined || pin.pinType === 'undefined') pin.pinType = pinTypeToDo;

        if (pin.id           .length > idLength           ) idLength            = pin.id           .length;
        if (pin.pins         .length > pinsLength         ) pinsLength          = pin.pins         .length;
        if (pin.pinType      .length > pinTypeLength      ) pinTypeLength       = pin.pinType      .length;
        if (pin.descriptionEn.length > descriptionEnLength) descriptionEnLength = pin.descriptionEn.length;
    }

    for (var j = 0; j < Object.keys(pinTable).length; j++)
    {
        idSpacer            = '';
        pinsSpacer          = '';
        pinTypeSpacer       = '';
        descriptionEnSpacer = '';

        pinNumber = j.toString();

        pin = pinTable[pinNumber];

        while ((idSpacer           .length + pin.id           .length) < idLength           ) idSpacer            = idSpacer            + ' ';
        while ((pinsSpacer         .length + pin.pins         .length) < pinsLength         ) pinsSpacer          = pinsSpacer          + ' ';
        while ((pinTypeSpacer      .length + pin.pinType      .length) < pinTypeLength      ) pinTypeSpacer       = pinTypeSpacer       + ' ';
        while ((descriptionEnSpacer.length + pin.descriptionEn.length) < descriptionEnLength) descriptionEnSpacer = descriptionEnSpacer + ' ';

        if (pinNumber.length === 1) line = '      "' + pinNumber + '": { ';
        if (pinNumber.length === 2) line = '     "'  + pinNumber + '": { ';
        if (pinNumber.length === 3) line = '    "'   + pinNumber + '": { ';

        line = line + '"id": "'            + pin.id            + '", ' + idSpacer;
        line = line + '"pins": "'          + pin.pins          + '", ' + pinsSpacer;
        line = line + '"pinType": "'       + pin.pinType       + '", ' + pinTypeSpacer;
        line = line + '"descriptionEn": "' + pin.descriptionEn + '", ' + descriptionEnSpacer;
        line = line + '"descriptionZh": "' + pin.descriptionZh + '"';

        if (j > Object.keys(pinTable).length - 2)
        {
            line = line + '  }';
        }
        else
        {
            line = line + '  },';
        }

        pinTableJSON.push(line);
    }

    pinTableJSON.push('  }');
    pinTableJSON.push('}');

    return pinTableJSON;
}
//..............................................................................

//..............................................................................
function generatePinTablesFromYAML(yamlObject, filePath)
{
    var pinTable        = {};
    var pinsObject      = {};
    var pin             = {};
    var pinTableJSON    = {};

    var fileToWritePath = path.dirname(filePath);
    var pinTables       = yamlObject.pinTables;
    var pinTablesCount  = Object.keys(pinTables).length;

    if (pinTablesCount === 1)
    {
        pinTable = pinTables[Object.keys(pinTables)[0]];

        if (pinTable.name_en) delete(pinTable.name_en);
        if (pinTable.name_zh) delete(pinTable.name_zh);

        for (var i = 0; i < Object.keys(pinTable).length; i++)
        {
            pin = pinTable[Object.keys(pinTable)[i]];

            pin = getPinObject(pin);

            pinsObject[i] = pin;
        }

        pinTableJSON = getPinTableJSON(pinsObject, yamlObject.id);

        var fileToWriteName = yamlObject.id + fileNames.pinTable;

        if (!fileExists(fileToWritePath + fileToWriteName))
        {
            writeFileToDisk(pinTableJSON.join('\n'), fileToWritePath, fileToWriteName);

            console.log('Written: ' + fileToWriteName);
        }
        else
        {
            console.log('File Exists: ' + fileToWriteName)
        }
    }
    else
    {
        console.log('Begin Writing Tables: ' + yamlObject.id);

        for (i = 0; i < pinTablesCount; i++)
        {
            pinTable = pinTables[Object.keys(pinTables)[i]];

            if (pinTable.note)
            {
                delete(pinTable.note);
            }

            if (pinTable.name_en)
            {
                var nameEn = pinTable.name_en;

                delete(pinTable.name_en);
            }

            if (pinTable.name_zh)
            {
                var nameZh = pinTable.name_zh;

                delete(pinTable.name_zh);
            }

            nameZh = nameZh || nameEn;

            for (var j = 0; j < Object.keys(pinTable).length; j++)
            {
                pin = pinTable[Object.keys(pinTable)[j]];

                pin = getPinObject(pin);

                pinsObject[j] = pin;
            }

            pinTableJSON = getPinTableJSON(pinsObject, yamlObject.id);

            pinTableJSON[pinTableJSON.length -2] = pinTableJSON[pinTableJSON.length -2] + ',';

            pinTableJSON[pinTableJSON.length -1] = '     "tableName": { "nameEn": "' + nameEn + '", "nameZh": "' + nameZh + '"}';

            pinTableJSON.push('}');

            fileToWriteName = replaceAll(nameEn, ' ', '-').toLowerCase();

            fileToWriteName = yamlObject.id + '-' + fileToWriteName + fileNames.pinTable;

            fileToWriteName = getSafeNamePathString(fileToWriteName);

            if (!fileExists(fileToWritePath + '/' + fileToWriteName))
            {
                console.log('    Written: ' + fileToWriteName);

                writeFileToDisk(pinTableJSON.join('\n'), fileToWritePath, fileToWriteName);
            }
            else
            {
                console.log('    File Exists: ' + fileToWriteName)
            }

            pinTableJSON = {};
            nameEn       = '';
            nameZh       = '';
        }

        console.log('Finish Writing Tables: ' + yamlObject.id);
    }
}
//..............................................................................

//..............................................................................
function loadTablesYAML()
{
    var yamlDataObject = {};

    var filesYAML = findFiles(directoryNames.productSource, fileExtensions.yaml, 'loadTablesYAML');

    for (var i = 0; i < filesYAML.length; i++)
    {
        yamlDataObject = loadYamlObject(filesYAML[i]);

        if (yamlDataObject.pinTables)
        {
            generatePinTablesFromYAML(yamlDataObject, filesYAML[i]);
        }
    }

    console.log('All Tables Generated')
}
//..............................................................................

//..............................................................................
var exported =
{
    loadTablesYAML,
};
//..............................................................................

//..............................................................................

module.exports = exported;
