//..............................................................................
console.time    ('API HTML Generator Modules Loaded      ');

const
{
    docUtils,
    docConstants,
} = require('mesh-doc-utils');

const
{
    docMarkdownParser,
} = require('mesh-doc-gen');

const
{
    directoryNames,
    languages,
    fileExtensions,
    fileNames,
} = docConstants;

const
{
    markdownToHTML,
} = docMarkdownParser;

const {path, util} = cxq;

const
{
    forceDirectorySync,
} = util;

const
{
    copyFileSync,
    findFiles,
    loadTextFileIntoString,
    replaceAll,
    writeFileToDisk,
} = docUtils;

console.timeEnd('API HTML Generator Modules Loaded      ');

//..............................................................................

//..............................................................................
function copyPartialsToOutput(outputDir, partialsFolder)
{
    var filesPartials = findFiles(partialsFolder, '*', 'copyPartialsToOutput');

    for (var i = 0; i < filesPartials.length; i++)
    {
        var partial = filesPartials[i];

        if (path.extname(partial) === '.css')
        {
            forceDirectorySync(outputDir + '/css');
            copyFileSync(partial, outputDir + '/css/');
        }

        if (path.extname(partial) === '.js')
        {
            forceDirectorySync(outputDir + '/js');
            copyFileSync(partial, outputDir + '/js/');
        }
    }
}
//..............................................................................

//..............................................................................
function generateHTMLFilesAPI(contentBlocks, contentTOC)
{
    console.time   ('HTML Files Generated                   ');

    console.log   ('Generating HTML Files...                ');

    var partialsFolder = directoryNames.source + directoryNames.partials + directoryNames.api;

    var output = directoryNames.outputFinal + directoryNames.html;

    var footer         = [];
    var header         = [];
    var divider        = [];
    var partial        = '';
    var blocksEn       = [];
    var blocksZh       = [];

    for (var i = 1; i < contentBlocks.length; i++)
    {
        if (contentBlocks[i].language === languages.english.name)
            blocksEn.push(contentBlocks[i].lines.join('\n'));

        if (contentBlocks[i].language === languages.chinese.name)
            blocksZh.push(contentBlocks[i].lines.join('\n'))
    }

    copyPartialsToOutput(output + directoryNames.apiDocEn, partialsFolder);
    copyPartialsToOutput(output + directoryNames.apiDocZh, partialsFolder);

    var filesPartials = findFiles(partialsFolder, '*', 'generateHTMLFilesAPI');

    for (i= 0; i < filesPartials.length; i++)
    {
        partial = filesPartials[i];

        if (partial.includes('footer' )) footer  = loadTextFileIntoString(partial);
        if (partial.includes('header' )) header  = loadTextFileIntoString(partial);
        if (partial.includes('divider')) divider = loadTextFileIntoString(partial);
    }

    console.log    ('Rendering: ' + '..' + 'bodyEn');

    var renderedHTMLEn = markdownToHTML(blocksEn.join('\n'), );

    console.log    ('Rendering: ' + '..' + 'bodyZh');

    var renderedHTMLZh = markdownToHTML(blocksZh.join('\n'));

    var renderedTOC = markdownToHTML(contentTOC);

    var htmlAll = header.concat(renderedTOC, divider, renderedHTMLEn, footer);

    htmlAll = replaceAll(htmlAll, '<td><code>operator</code></td>', '<td><code>todo</code></td>');

    writeFileToDisk(htmlAll, output + directoryNames.apiDocEn, fileNames.index + fileExtensions.html);

    htmlAll = header.concat(renderedTOC, divider, renderedHTMLZh, footer);

    htmlAll = replaceAll(htmlAll, '<td><code>operator</code></td>', '<td><code>todo</code></td>');

    writeFileToDisk(htmlAll, output + directoryNames.apiDocZh, fileNames.index + fileExtensions.html);

    console.log    ('---------------------------------------');
    console.timeEnd('HTML Files Generated                   ');
    console.log    ('---------------------------------------');
}
//..............................................................................

//..............................................................................
function getContentBlocksLanguage(contentBlocks)
{
    var blocks  = [];
    var block = {lines : [], language : ''};

    for (var i = 1; i < contentBlocks.length;i++)
    {
        block.lines = contentBlocks[i].split('\n');

        if (block.lines[3].includes(languages.english.name))
        {
            block.language = 'languages.english.name';
            block.lines[3] = '';
        }

        if (block.lines[3].includes('languages.chinese.name'))
        {
            block.language = 'languages.chinese.name';
            block.lines[3] = '';
        }

        blocks.push(block);

        block = {lines : [], language : ''};
    }

    return blocks;
}
//..............................................................................

//..............................................................................
function generate()
{
    console.time   ('API HTML Generation Complete           ');

    console.log    ('Generating API HTML...                 ');

    var generatedBody = loadTextFileIntoString(directoryNames.outputIntermediate + '/' + fileNames.generatedBodyAPI);
    var generatedTOC = loadTextFileIntoString(directoryNames.outputIntermediate + '/' + fileNames.generatedTocAPI);

    var contentBlocks = generatedBody.split('<a name=');

    for (var i = 1; i < contentBlocks.length; i++) contentBlocks[i] = '<a name=' + contentBlocks[i];

    contentBlocks = getContentBlocksLanguage(contentBlocks);

    generateHTMLFilesAPI(contentBlocks, generatedTOC);

    console.log    ('---------------------------------------');
    console.timeEnd('API HTML Generation Complete           ');
    console.log    ('---------------------------------------');
}
//..............................................................................

//..............................................................................

var exported =
    {
        generate,
    };
//..............................................................................

//..............................................................................

module.exports = exported;