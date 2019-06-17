require('mesh-base');
//..............................................................................
const {fs, path, logger, util} = cxq;
//..............................................................................

const puppeteer = require('puppeteer');

//..............................................................................
const
{
    abort,
    shutdown,
    wait,
    processList,
    processListParallel,
    processListSerial,
    processListLimit,
    addProperties,
    meshNowMs,
    meshNowSeconds,
    meshNow,
} = util;
//..............................................................................

//..............................................................................
const
{
    filenameNoExtension,
    findFiles,
    loadTextFileIntoString,
    paneliseContent,
    svgToPDF,
} = cxq.meshDocGen;

const log = logger('SVG To PDF');

log.setLevel('info');
//..............................................................................

//..............................................................................
const outputFolder      = 'E:/Dropbox (Mesheven)/Git/steve-gen-dev/mesh-doc-graphics/BB/dev/pdf';
//..............................................................................

//..............................................................................
function svgToPDFListOld(listArray, pageSize, landscape, mainCallback)
{
    const startTime = meshNowSeconds();

    pageSize  = pageSize  || false;
    landscape = landscape || false;

    //..........................................................................
    function processSVG(svgFile, callback)
    {
        const filename = path.basename(svgFile);

        console.log('\x1b[34m%s\x1b[0m', 'Starting Process      : ' + filename);

        var panelisedContent;

        const svgContent  = loadTextFileIntoString(svgFile);

        fileName = filenameNoExtension(path.basename(svgFile)) + '.pdf';

        const outputPath = path.join(outputFolder, fileName)

        if (!landscape)
        {
            panelisedContent = paneliseContent(svgContent)
        }

        (async function()
        {
            console.log('1: Launch Puppeteer   :', filename);

            const browser = await puppeteer.launch()

            console.log('2: Create Browser Page:', filename);

            const page    = await browser  .newPage()

            console.log('3: Set Page Content   :', filename);

            await page.setContent(panelisedContent || svgContent);

            console.log('4: Generate PDF       :', filename);

            await page.pdf({ path: outputPath, format: 'A4', pageRanges: '1', landscape: landscape })

            console.log('5: Close Browser      :', filename);

            await browser.close()

            console.log('\x1b[32m%s\x1b[0m', '6: Finished           : ' + filename);

            callback(null);
        })()
    }
    //..........................................................................
    function allDone(err)
    {
        const elapsed = meshNowSeconds() - startTime;

        console.log('');
        console.log('==========================');
        log.info('Complete:', 'Elapsed:',elapsed);
        console.log('--------------------------');

        shutdown();

        console.log('--------------------------');

        mainCallback(err);
    }
    ////////////////////////////////////////////////////////////////////////////

    landscape = false;

    console.log('Process Portrait Files');

    processListLimit(listArray, 10, processSVG, allDone)
}
//..............................................................................

//..............................................................................
addProperties(cxq.meshDocGen,
{
    //svgToPDFList,
});
