//..............................................................................
const {fs, path, logger, util} = cxq;
//..............................................................................
const
{
    addProperties,
    forceDirectorySync,
} = util;
//..............................................................................
const
{
    stringsTemplate,
    loadTextFileIntoString,
    filenameNoExtension,
    pathsOutput,
    pathsSourceSVG ,
    writeFileToDisk,
} = cxq.meshDocGen;
//..............................................................................
const log = logger('SVG To PDF');

log.setLevel('info');

var svgCount = 0;
var x        = 0;
//..............................................................................
const puppeteer = require('puppeteer');
//..............................................................................

//..............................................................................
function hideMBs(svgContent)
{
    var result = svgContent;

    var re = new RegExp('<g id="round-rect"', 'g');

    result = result.replace(re, '<g visibility="hidden" id="round-rect"')

    var re = new RegExp('id = "QR-CODE-MB"', 'g');

    result = result.replace(re, ' visibility="hidden" id = "QR-CODE-MB"')

    var re = new RegExp('>\n            MB', 'g');

    result = result.replace(re, ' visibility="hidden">\n            MB')

    var re = new RegExp('>\n            MESHEVEN', 'g');

    result = result.replace(re, ' visibility="hidden">\n            MESHEVEN')

    var re = new RegExp('r="0.4" fill="#bdbcbc" stroke="none"/>', 'g');

    result = result.replace(re, 'r="0.4" fill="#bdbcbc" stroke="none" visibility="hidden"/>')

    return result;
}
//..............................................................................

//..............................................................................
function hidePatterns(svgContent)
{
    var result = svgContent;

    const re = new RegExp('pattern id', 'g');

    result = result.replace(re, 'pattern visibility="hidden" id')

    return result;
}
//..............................................................................

//..............................................................................
function hidePins(svgContent)
{
    var result = svgContent;

    var re = new RegExp('id = "pin', 'g');

    result = result.replace(re, ' visibility="hidden" id = "pin')

    re = new RegExp('id = "PIN', 'g');

    result = result.replace(re, ' visibility="hidden" id = "PIN')

    return result;
}
//..............................................................................

//..............................................................................
function hideOriginMarkers(svgContent)
{
    var result = svgContent;

    const re = new RegExp('stroke-width="0.1" stroke="black"', 'g');

    result = result.replace(re, ' stroke-width="0.1" stroke="black" visibility="hidden" ')

    return result;
}
//..............................................................................

//..............................................................................
function hidePads(svgContent)
{
    var result = svgContent;

    var re = new RegExp('id = "pad', 'g');

    result = result.replace(re, ' visibility="hidden" id = "pad')

    re = new RegExp('id = "PAD', 'g');

    result = result.replace(re, ' visibility="hidden" id = "PAD')

    re = new RegExp('id="padEnd', 'g');

    result = result.replace(re, ' visibility="hidden" id="padEnd')

    re = new RegExp('<circle cx="0" cy="0" r="0.65" fill="#D0D0D0" stroke="none"/>', 'g');

    result = result.replace(re, '<circle cx="0" cy="0" r="0.65" fill="#D0D0D0" stroke="none" visibility="hidden"/>')

    re = new RegExp('fill  = "#ebb300">', 'g');

    result = result.replace(re, 'visibility="hidden" fill  = "#ebb300">')

    return result;
}
//..............................................................................

//..............................................................................
function hideGradients(svgContent)
{
    var result = svgContent;

    var re = new RegExp('<radialGradient', 'g');

    result = result.replace(re, '<radialGradient visibility="hidden" ')

    var re = new RegExp('<linearGradient', 'g');

    result = result.replace(re, '<linearGradient visibility="hidden" ')

    return result;
}
//..............................................................................

//..............................................................................
function hideComponents(svgContent)
{
    var result = svgContent;

    var re = new RegExp('href="#LED', 'g');

    result = result.replace(re, ' visibility="hidden" href="#LED')

    var re = new RegExp('href="#USB', 'g');

    result = result.replace(re, ' visibility="hidden" href="#USB')

    var re = new RegExp('href="#SMA', 'g');

    result = result.replace(re, ' visibility="hidden" href="#SMA')

    var re = new RegExp(' id="SWD-Holes', 'g');

    result = result.replace(re, ' visibility="hidden" id="SWD-Holes')

    var re = new RegExp(' id="SWD-PADS', 'g');

    result = result.replace(re, ' visibility="hidden" id="SWD-PADS')

    return result;
}
//..............................................................................

//..............................................................................
function hideJumpers(svgContent)
{
    var result = svgContent;

    var re = new RegExp('id = "JUMPER', 'g');

    result = result.replace(re, 'visibility="hidden" id = "JUMPER')

    return result;
}
//..............................................................................

//..............................................................................
function hideOutline(svgContent)
{
    var result = svgContent;

    var re = new RegExp('<rect rx="0.5" ry= "0.5"', 'g');

    result = result.replace(re, '<rect rx="0.5" ry= "0.5" visibility="hidden"')

    return result;
}
//..............................................................................

//..............................................................................
function hideNonPrintElements(svgContent)
{
    var result = svgContent;

    result = hidePatterns     (result)
    result = hideGradients    (result)
    result = hideJumpers      (result)
    result = hideMBs          (result)
    result = hidePads         (result)
    result = hidePins         (result)
    // result = hideOutline      (result)
    result = hideComponents   (result)
    // result = hideOriginMarkers(result)

    return result;

}
//..............................................................................

//..............................................................................
function getBoardSVG(svgFile, boardID)
{
    var result = loadTextFileIntoString(svgFile);

    result = hideNonPrintElements(result);

    writeFileToDisk(result, pathsOutput.pdf, 'test.svg');

    while(result.indexOf('</style>') > -1) {result = result.substring(1)}

    result = result.substring(9) + '\n';

    var re = new RegExp('\n\n', 'g');

    while(result.indexOf('\n\n') > -1) {result = result.replace(re, '\n');}

    re = new RegExp('\n    \n', 'g');

    while(result.indexOf('\n    \n') > -1) {result = result.replace(re, '\n');}

    re = new RegExp('\n', 'g');

    result = result.replace(re, '\n        ')

    while(result.substring(result.length - 6) !== '</svg>') {result = result.substring(0, result.length -1);}

    result = result.trim();

    result = result.substring(0, result.length - 6);

    result = '        ' + result.trim();

    return result;
}
//..............................................................................

//..............................................................................
function svgToPDF(svgFile, templateFile, outputFolder)
{
    console.log('\x1b[34m%s\x1b[0m', 'Starting Process   : ' + svgFile);

    const svgContent = getBoardSVG(svgFile);

    var template =  loadTextFileIntoString(templateFile);

    const htmlOutput = template.replace(stringsTemplate.injectSVG, svgContent)

    const boardID = filenameNoExtension(path.basename(svgFile));

    const filename = filenameNoExtension(path.basename(templateFile)) + '.pdf';

    forceDirectorySync(outputFolder);

    const outputPath = path.join(outputFolder, filename)

    console.log('Save Single SVG    :', filename);

    (async () =>
    {
        console.log('Launch Puppeteer   :', filename);

        const browser = await puppeteer.launch()

        console.log('Create Browser Page:', filename);

        const page    = await browser  .newPage()

        console.log('Set Page Content   :', filename);

        await page.setContent (htmlOutput);

        console.log('Generate PDF       :', filename);

        await page.pdf
        (
            {
                path      : outputPath,
                // pageRanges: '1',
                width     : '200mm',
                height    :'180mm',
                landscape : false,
            }
        )

        console.log('Close Browser      :', filename);

        await browser.close()

        console.log('\x1b[32m%s\x1b[0m', 'Finished           : ' + outputPath);
    })()
}   /*svgToPDF*/
//..............................................................................

//..............................................................................
addProperties(cxq.meshDocGen,
{
    svgToPDF,
});
