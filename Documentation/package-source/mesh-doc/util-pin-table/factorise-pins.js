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
    sortAlphaNum,
    writeFileToDisk,
} = docUtils;

const
{
    directoryNames,
    fileExtensions,
    fileNames,
} = docConstants;

const {path} = cxq;

//..............................................................................

//..............................................................................
function factorisePinsTables()
{
    var filesJSON = findFiles(directoryNames.productSource, fileExtensions.json, 'factorisePinsTables');
    var filesPinTables = [];
    var pinTable = {};
    var uniquePinNames = [];
    var pin = {};
    var factorisedTable = {};
    var designatorList = [];

    var pinReport       = [];
    var pinNumber       = '';
    var line            = '';

    var idLength            = 0;
    var pinsLength          = 0;
    var pinTypeLength       = 0;
    var descriptionEnLength = 0;

    var idSpacer            = '';
    var pinsSpacer          = '';
    var pinTypeSpacer       = '';
    var descriptionEnSpacer = '';

    var fileToWritePath = '';
    var fileToWriteName = '';

    var sheetName = '';


    for (var i = 0; i < filesJSON.length; i++)
    {
        if (filesJSON[i].indexOf(fileNames.pinTable) > -1)
        {
            filesPinTables.push(filesJSON[i]);
        }
    }

    for (i = 0; i < filesPinTables.length; i++)
    {
        pinTable = JSON.parse(loadTextFileIntoString(filesPinTables[i]));

        sheetName = Object.keys(pinTable)[0].substring(0, Object.keys(pinTable)[0].indexOf('.'));

        pinTable = pinTable[Object.keys(pinTable)[0]];

        for (var j = 0; j < Object.keys(pinTable).length; j++)
        {
            uniquePinNames.push(pinTable[Object.keys(pinTable)[j]].netName);
        }

        uniquePinNames = getUniqueArray(uniquePinNames);

        for (j = 0; j < uniquePinNames.length; j++)
        {
            factorisedTable[j] = {};

            factorisedTable[j].id = uniquePinNames[j];

            factorisedTable[j].pins = '';

            for (var k = 0;  k < Object.keys(pinTable).length; k++)
            {
                pin = pinTable[Object.keys(pinTable)[k]];

                if(pin.netName === factorisedTable[j].id)
                {
                    designatorList.push(pin.designator);

                    factorisedTable[j].pinType       = pin.pinType;
                    factorisedTable[j].descriptionEn = pin.descriptionEn;
                    factorisedTable[j].descriptionZh = pin.descriptionZh;
                }

            }

            designatorList = designatorList.sort(sortAlphaNum);

            factorisedTable[j].pins          = designatorList.join(', ');

            designatorList = [];
        }

        pinReport.push('{');

        pinReport.push('  "' + sheetName + '": {');

        for (j = 0; j < Object.keys(factorisedTable).length; j++) {
            pinNumber = Object.keys(factorisedTable)[j];

            pin = factorisedTable[pinNumber];

            console.log('factorisedTable[pinNumber]: ' + pin.id + '.' + pin.descriptionEn);

            if (pin.id           .length > idLength           ) idLength            = pin.id           .length;
            if (pin.pins         .length > pinsLength         ) pinsLength          = pin.pins         .length;
            if (pin.pinType      .length > pinTypeLength      ) pinTypeLength       = pin.pinType      .length;
            if (pin.descriptionEn.length > descriptionEnLength) descriptionEnLength = pin.descriptionEn.length;
        }

        for (j = 0; j < Object.keys(factorisedTable).length; j++)
        {
            idSpacer            = '';
            pinsSpacer          = '';
            pinTypeSpacer       = '';
            descriptionEnSpacer = '';

            pinNumber = Object.keys(factorisedTable)[j];

            pin = factorisedTable[pinNumber];

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

            if (j > Object.keys(factorisedTable).length - 2)
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

        factorisedTable = {};
        uniquePinNames  = [];

        fileToWritePath = path.dirname (filesPinTables[i]);
        fileToWriteName = path.basename(filesPinTables[i]);

        writeFileToDisk(pinReport.join('\n'), fileToWritePath, fileToWriteName);

        pinReport = [];

        idSpacer            = '';
        pinsSpacer          = '';
        pinTypeSpacer       = '';
        descriptionEnSpacer = '';

        idLength            = 0;
        pinsLength          = 0;
        pinTypeLength       = 0;
        descriptionEnLength = 0;
    }
}
//..............................................................................

//..............................................................................
var exported =
    {
        factorisePinsTables,
    };
//..............................................................................

//..............................................................................

module.exports = exported;
