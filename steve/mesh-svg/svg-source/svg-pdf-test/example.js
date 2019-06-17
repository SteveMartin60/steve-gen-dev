const puppeteer = require('puppeteer');
const path = require('path');

const svgFilePath = path.join(__dirname, "artwork.svg");
const svgFileUrl = "file://" + svgFilePath

const outputPdfFilePath = "artwork-saved.pdf"

function init()
{    
    let browser = null;
    let page    = null;
    //..........................................................................
    function createBrowser()
    {
        return puppeteer.launch()
            .then(function(result)
            {
                browser = result;
            });
    }
    //..........................................................................
    function createNewPage()
    {
        return browser.newPage()
            .then(function(result)
            {
                page = result;
            });
    }
    //..........................................................................
    function openUrl()
    {
        return page.goto(svgFileUrl, {waitUntil: 'networkidle2'});
    }
    //..........................................................................
    function capturePdf()
    {
        return page.pdf({path: outputPdfFilePath, width:"210mm", height:"297mm", preferCSSPageSize:true});
    }
    //..........................................................................
    function closeBrowser()
    {
        return browser.close();
    }
    //..........................................................................    
    return createBrowser()
        .then(createNewPage)
        .then(openUrl)
        .then(capturePdf)
        .then(closeBrowser)
}

function handleOk()
{
    console.log("Completed:OK");
}

function handleError(error)
{
    console.error("Completed:FAILED", error);
}

init()
    .then(handleOk)
    .catch(handleError)