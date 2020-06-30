//..............................................................................

const
{
    docConstants,
} = require('mesh-doc-utils');

const
{
    languages,
} = docConstants;

var
{
    generatePinDiagram
} = require('../../../node_modules/mesh-doc-gen/gen-pin-diagram');

var
{
    generateHeadlineImages
} = require('../../../node_modules/mesh-doc-gen/gen-headline-image');

var
{
    generateDeviceSheetFilesSVG
} = require('../../../node_modules/mesh-doc-gen/gen-device-sheet');

//..............................................................................

//..............................................................................

function generateImagesSVG()
{
    generateHeadlineImages();

    generatePinDiagram(languages.english.name);
    generatePinDiagram(languages.chinese.name);

    generateDeviceSheetFilesSVG(languages.english.name);

    //throw new TypeError('Breaking for debug');

    generateDeviceSheetFilesSVG(languages.chinese.name);


    //generateFormFactorSVG();
}
//..............................................................................

//..............................................................................

var exported  =
{
    generateImagesSVG,
};
//..............................................................................

//..............................................................................

module.exports = exported;

