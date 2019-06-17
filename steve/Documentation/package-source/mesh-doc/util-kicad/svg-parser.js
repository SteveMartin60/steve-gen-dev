//..............................................................................

const
{
    utils,
} = require('mesh-doc-utils');

const
{
    getUniqueArray,
    loadTextFileIntoString,
    replaceAll,
    writeFileToDisk,
} = utils;

const kicadFileTypes =
{
    fileTypePCB       : '.kicad_mod',
    fileTypeSch       : '.sch',
    fileTypeFootprint : '.mod',
    fileType3dM : '.mod',
};

var componentList       = [];
var kiCadPCB            = [];
var elementGroupObjects = [];
var elementGroupObject  = {};
var primitivesCircle    = [];
var primitivesLine      = [];
var primitivesPath      = [];
var primitivesRect      = [];
var primitivesText      = [];
var primitivesPad       = [];
var boardLayer          = '';
var layerFootprints     = {};
var layerOutline        = {};
var boardObject         = {};

boardObject.layerOutline    = {};
boardObject.layerFootprints = [];

const primitiveTypeCircle = 'circle';
const primitiveTypeArc    = 'arc';
const primitiveTypePad    = 'pad-group';
const primitiveTypeRect   = 'rect';
const primitiveTypeLine   = 'line';
const primitiveTypePath   = 'path';
const primitiveTypeText   = 'text';
const nonPrimitive        = 'nonPrimitive';

//..............................................................................

//..............................................................................
function iterateBoard(boardXML)
{
    Object.keys(boardXML).forEach(function (key)
    {
        if (typeof boardXML[key] === 'object')
        {
            if (boardXML[key]['attr'])
            {
                if (boardXML[key]['attr']['inkscape:label'] === 'layer-footprints' )
                {
                    layerFootprints.footprints = boardXML[key]['g'];

                    if (boardXML[key]['attr']['transform'])
                    {
                        layerFootprints.transform = boardXML[key]['attr']['transform'];
                    }
                }

                if (boardXML[key]['attr']['inkscape:label'] === 'layer-board-outline' )
                {
                    layerOutline.outlinePath = boardXML[key]['path']['attr'];

                    if (boardXML[key]['attr']['transform'])
                    {
                        layerOutline.transform = boardXML[key]['attr']['transform'];
                    }
                }
            }

            return iterateBoard(boardXML[key]);
        }
    });
}
//..............................................................................

//..............................................................................
function isFootprintLayer(jsonString)
{
    if (jsonString.indexOf('layer-footprints') === -1) return false;

    return jsonString.indexOf('layer-footprints') < 100;
}
//..............................................................................

//..............................................................................
function getElementType(elementString)
{
    if (elementString.indexOf(',"circle":') > -1) return 'elementTypeCircle';
    if (elementString.indexOf(',"path":'  ) > -1) return 'elementTypePath';
    if (elementString.indexOf(',"line":'  ) > -1) return 'elementTypeLine';

    return 'nonElementType';
}
//..............................................................................

//..............................................................................
function cleanElementString(elementString)
{
    var tempString = replaceAll(elementString, '{"attr":{' , '');
    tempString     = replaceAll(tempString   , ',"circle":', '');


    return tempString;
}
//..............................................................................

//..............................................................................
function renderElementString(elementString)
{
    var kiCadString = '';
    var subElements = [];
    var elementType = getElementType(elementString);
    var tempString  = cleanElementString(elementString);

    subElements = tempString.split(',');

    for (var i = 0; i < subElements.length; i++)
    {
        if (subElements[i].indexOf('"style":') > -1)
        {
            var elementStyle = replaceAll(subElements[i], '"style":"', '').split(';')
        }
    }


    kiCadPCB.push(kiCadString);
}
//..............................................................................

//..............................................................................
function getLayerFromObject(object)
{
    var jsonString = JSON.stringify(object);

    if (jsonString.indexOf('"inkscape:groupmode":"layer"') > -1)
    {
        boardLayer = jsonString;

        while (boardLayer.indexOf('inkscape:label') > -1)
        {
            boardLayer = boardLayer.substring(1);
        }

        boardLayer = boardLayer.substring(16);

        while (boardLayer.indexOf('"') > -1)
        {
            boardLayer = boardLayer.substring(0, boardLayer.length -1);
        }

        boardLayer = boardLayer.trim();
    }
}
//..............................................................................

//..............................................................................
function iterateComponent(component)
{
    Object.keys(component).forEach(function (key)
    {
        if (typeof component[key] === 'object')
        {
            elementGroupObject = component[key];

            getLayerFromObject(elementGroupObject);

            elementGroupObject.layer = boardLayer;

            if (component[key][primitiveTypeCircle]) elementGroupObjects.push(JSON.stringify(component[key]));
            if (component[key][primitiveTypeLine  ]) elementGroupObjects.push(JSON.stringify(component[key]));
            if (component[key][primitiveTypeRect  ]) elementGroupObjects.push(JSON.stringify(component[key]));
            if (component[key][primitiveTypePath  ]) elementGroupObjects.push(JSON.stringify(component[key]));
            if (component[key][primitiveTypeText  ]) elementGroupObjects.push(JSON.stringify(component[key]));

            return iterateComponent(component[key]);
        }
    });
}
//..............................................................................

//..............................................................................
function isPadGroup(elementGroupObject)
{
    if (elementGroupObject['attr']['inkscape:label'] === undefined) return false;

    return elementGroupObject['attr']['inkscape:label'].indexOf('pad-group') > -1;
}
//..............................................................................

//..............................................................................
function getPrimitives(elementGroupObjects)
{
    var j = 0;

    for (var i = 0; i < elementGroupObjects.length; i++)
    {
        elementGroupObject = elementGroupObjects[i];

        if (isPadGroup(elementGroupObject))
        {
            primitivesPad.push(elementGroupObject);
        }

        if (elementGroupObject[primitiveTypeLine])
        {
            var primitiveGroup = elementGroupObject[primitiveTypeLine];

            if (Array.isArray(primitiveGroup))
            {
                for (j = 0; j < primitiveGroup.length; j++)
                {
                    var lineObject = primitiveGroup[j]['attr'];

                    lineObject.layer = elementGroupObject.layer;

                    primitivesLine.push(lineObject);
                }
            }
            else
            {
                primitiveGroup['attr'].layer = elementGroupObject.layer;

                primitivesLine.push(primitiveGroup['attr']);
            }
        }

        if (elementGroupObject[primitiveTypeCircle])
        {
            primitiveGroup = elementGroupObject[primitiveTypeCircle];

            if (Array.isArray(primitiveGroup))
            {
                for ( j = 0; j < primitiveGroup.length; j++)
                {
                    var circleObject = primitiveGroup[j]['attr'];

                    circleObject.layer = elementGroupObject.layer;

                    primitivesCircle.push(circleObject);
                }
            }
            else
            {
                primitiveGroup['attr'].layer = elementGroupObject.layer;

                primitivesCircle.push(primitiveGroup['attr']);
            }
        }

        if (elementGroupObject[primitiveTypePath])
        {
            primitiveGroup = elementGroupObject[primitiveTypePath];

            if (Array.isArray(primitiveGroup))
            {
                for ( j = 0; j < primitiveGroup.length; j++)
                {
                    var pathObject = primitiveGroup[j]['attr'];

                    pathObject.layer = elementGroupObject.layer;

                    primitivesPath.push(pathObject);
                }
            }
            else
            {
                primitiveGroup['attr'].layer = elementGroupObject.layer;

                primitivesCircle.push(primitiveGroup['attr']);
            }
        }

        if (elementGroupObject[primitiveTypeRect])
        {
            primitiveGroup = elementGroupObject[primitiveTypeRect];

            if (Array.isArray(primitiveGroup))
            {
                for ( j = 0; j < primitiveGroup.length; j++)
                {
                    var rectObject = primitiveGroup[j]['attr'];

                    rectObject.layer = elementGroupObject.layer;

                    primitivesRect.push(rectObject);
                }
            }
            else
            {
                primitiveGroup['attr'].layer = elementGroupObject.layer;

                primitivesRect.push(primitiveGroup['attr']);
            }
        }

        if (elementGroupObject[primitiveTypeText])
        {
            primitiveGroup = elementGroupObject[primitiveTypeText];

            if (Array.isArray(primitiveGroup))
            {
                for ( j = 0; j < primitiveGroup.length; j++)
                {
                    var textObject = primitiveGroup[j]['attr'];

                    textObject.layer = elementGroupObject.layer;

                    primitivesText.push(textObject);
                }
            }
            else
            {
                primitiveGroup['attr'].layer = elementGroupObject.layer;

                primitivesCircle.push(primitiveGroup['attr']);
            }
        }
    }
}
//..............................................................................

//..............................................................................
function convertLayerNameKiCad(layerName)
{
    return layerName;
}
//..............................................................................

//..............................................................................
function renderPad(padObject)
{
    var designator = padObject['text']['tspan']['#text'];
    var padLayer   = convertLayerNameKiCad(primitivesPad[0]['layer']);
}
//..............................................................................

//..............................................................................
function renderPrimitives()
{
    for (var i = 0; i < primitivesPad.length; i++)
    {
        renderPad(primitivesPad[i]);
    }
}
//..............................................................................

//..............................................................................
function renderFootprints()
{
    var footprint  = [];
    var element    = [];
    var elementRaw = [];

    for (var i = 0; i < layerFootprints.footprints.length; i++)
    {
        footprint = layerFootprints.footprints[i];

        for (var j = 0; j < footprint.length; j++)
        {
            iterateComponent(footprint[j]);
        }

        elementGroupObjects = getUniqueArray(elementGroupObjects);

        for (j = 0; j < elementGroupObjects.length; j++)
        {
            elementGroupObjects[j] = JSON.parse(elementGroupObjects[j]);
        }

        getPrimitives(elementGroupObjects);

        renderPrimitives();

        elementGroupObjects = [];

        // writeFileToDisk(JSON.stringify(elementGroupObjects, null, 4), 'E:\\Dropbox (Mesheven)\\Git\\Documentation\\Working', 'working2.json');

    console.log('Circle: ' + primitivesCircle);
    console.log('Line  : ' + primitivesLine  );
    console.log('Path  : ' + primitivesPath  );
    console.log('Pad   : ' + primitivesPad   );
    console.log('Rect  : ' + primitivesRect  );
    console.log('Text  : ' + primitivesText  );
    }
}
//..............................................................................

//..............................................................................
function parseSVG()
{
    var boardSVG = loadTextFileIntoString('E:\\Dropbox (Mesheven)\\Git\\Documentation\\mesh-doc-graphics\\Source\\Items\\BB\\BB0001-Relays.svg');

    boardObject.layerFootprints = layerFootprints;

    boardObject.layerOutline    = layerOutline;

    //renderFootprints();

    writeFileToDisk(JSON.stringify(boardObject, null, 4), 'E:\\Dropbox (Mesheven)\\Git\\Documentation\\Working\\', 'working1.json');

    console.log('Component List: ' + componentList)
}

//..............................................................................

//..............................................................................

var exported  =
    {
        parseSVG,
    };
//..............................................................................

//..............................................................................

module.exports = exported;