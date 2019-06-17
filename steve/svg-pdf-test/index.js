//..............................................................................
require('mesh-base');
require('mesh-doc-gen');

require('./requires');
//..............................................................................

//..............................................................................
const
{
    processDS,
    processPCB,
    processPins,
    findFiles,
    pathsSourceSVG,
    pathsOutput,
    fileExtensions,
    svgToPDF,
} = cxq.meshDocGen;

const {util, path} = cxq;

const
{
    abort,
    processListLimit,
    shutdown,
} = util;
//..............................................................................

//..............................................................................
function doStuff()
{
/*
    const pageSize = 'A4';

    var boardsSVG = '';

    const svgFilesMeasure          = findFiles(pathsSourceSVG.measure         , fileExtensions.svg, 'Find SVG Files Measure'          );
    const svgFilesMX               = findFiles(pathsSourceSVG.mx              , fileExtensions.svg, 'Find SVG Files MX'               );
    const svgFilesMxSingle         = findFiles(pathsSourceSVG.mxSingle        , fileExtensions.svg, 'Find SVG Files MX Single'        );
    const svgFileOriginal          = findFiles(pathsSourceSVG.original        , fileExtensions.svg, 'Find SVG Files Original'         );
    const svgFilesPlugins          = findFiles(pathsSourceSVG.plugins         , fileExtensions.svg, 'Find SVG Files Plugins'          );
    const svgFilesPluginsComposite = findFiles(pathsSourceSVG.pluginsComposite, fileExtensions.svg, 'Find SVG Files Plugins Composite');
    const svgFilesPluginSingle     = findFiles(pathsSourceSVG.pluginsSingle   , fileExtensions.svg, 'Find SVG Files Plugins Single'   );
    const svgFileTemplates         = findFiles(pathsSourceSVG.templates       , fileExtensions.html, 'Find SVG Files Templates'        );

    svgToPDF(svgFileOriginal[0] , svgFileTemplates[0], pathsOutput.panels);
    // svgToPDF(svgFilesPluginSingle[0] , svgFileTemplates[0], pathsOutput.panels);

    svgToPDF    (svgFilesMeasure[0]      , pageSize, true, 'measure'          );
    svgToPDF    (svgFilesMxSingle        , pageSize, true, 'mx-single'        );
    svgToPDF    (svgFilesPluginsComposite, pageSize, true, 'plugins-composite');
    svgToPDFList(svgFilesMX              , pageSize, true, 'mx'               );
    svgToPDFList(svgFilesPlugins         , pageSize, true, 'plugins'          );

    for (var i = 0; i < svgFilesPlugins.length; i++)
    {
        var svgContent = loadTextFileIntoString(svgFilesPlugins[i]);

        var boardID = filenameNoExtension(path.basename(svgFilesPlugins[i]));

        var defsSVG = getDefsSVG(svgContent);

        var boardContent = getBoardContentWithID(svgContent, boardID);

        boardsSVG = boardsSVG + boardContent + '\n'
    }

    boardsSVG = boardsSVG + '\n';
*/

    var dataJSON    = {};

    processDS();
/*
    dataJSON = processPins(dataJSON);
    dataJSON = processPCB (dataJSON);

*/
}
//..............................................................................

//..............................................................................
doStuff();

