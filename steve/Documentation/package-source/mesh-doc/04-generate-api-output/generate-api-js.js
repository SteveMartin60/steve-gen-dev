//..............................................................................
console.time    ('API JS Generator Modules Loaded        ');

const
{
    docUtils,
    docConstants,
} = require('mesh-doc-utils');

const
{
    delimiters,
    directoryNames,
    fileExtensions,
    stringsUtil,
    languages,
} = docConstants;

const {path} = cxq;

const
{
    copyFolderRecursiveSync,
    findFiles,
    loadTextFileIntoString,
    replaceAllInDirectory,
    writeFileToDisk,
} = docUtils;

//..............................................................................
console.timeEnd('API JS Generator Modules Loaded        ');
//..............................................................................

//..............................................................................
function getIntellisenseFilename(textString, language)
{
    var filename = path.basename(textString);

    if (language === languages.english.name)
    {
        filename = filename.substring(0, filename.indexOf('.')) + languages.english.suffix + fileExtensions.js;
    }

    if (language === languages.chinese.name)
    {
        filename = filename.substring(0, filename.indexOf('.')) + languages.chinese.suffix + fileExtensions.js;
    }

    return filename;
}
//..............................................................................

//..............................................................................
function generate()
{
    console.time   ('API JS Generation Complete             ');

    console.log    ('Generating API JS...                   ');

    var blockJS        = {lines : [], language : ''};
    var commentEndLine = 0;
    var fileJS         = [];
    var fileJsEn       = [];
    var fileJsZh       = [];

    copyFolderRecursiveSync(directoryNames.outputIntermediate + directoryNames.js + directoryNames.sourceIntellisense, directoryNames.outputTemp, '.js');

    var filesJS = findFiles(directoryNames.outputTemp, '.js', 'Generating API JS');

    for (var i = 0; i < filesJS.length; i++)
    {
        fileJS = loadTextFileIntoString(filesJS[i]).split(delimiters.jsDocStart);

        for (var j = 1; j < fileJS.length; j++)
        {
            blockJS = fileJS[j].split('\r');

            for (var k = 1; k < blockJS.length; k++)
            {
                if (blockJS[k].includes(delimiters.jsDocEnd))
                {
                    commentEndLine = k;
                }
            }

            for (k = 0; k < commentEndLine; k++)
            {
                if (blockJS[k].indexOf(' \* ') !== 0)
                    blockJS[k] = ' \* ' + blockJS[k];
            }

            blockJS.unshift(delimiters.jsDocStart);

            blockJS = blockJS.join('\r');

            if (blockJS.includes(languages.english.name))
            {
                fileJsEn.push(blockJS);
            }

            if (blockJS.includes(languages.chinese.name))
            {
                fileJsZh.push(blockJS);
            }
        }

        var filenameEn = getIntellisenseFilename(filesJS[i], languages.english.name);

        writeFileToDisk(fileJsEn.join('\n'), directoryNames.outputFinal + directoryNames.intellisense + directoryNames.intellisenseEn, filenameEn);

        var filenameZh = getIntellisenseFilename(filesJS[i], languages.chinese.name);

        writeFileToDisk(fileJsZh.join('\n'), directoryNames.outputFinal + directoryNames.intellisense + directoryNames.intellisenseZh, filenameZh);

        fileJsEn = [];
        fileJsZh = [];
    }

    replaceAllInDirectory(directoryNames.outputFinal + directoryNames.intellisense, ' * <b>language_en</b>', '', '.js');
    replaceAllInDirectory(directoryNames.outputFinal + directoryNames.intellisense, ' * <b>language_zh</b>', '', '.js');
    replaceAllInDirectory(directoryNames.outputFinal + directoryNames.intellisense, '//' + stringsUtil.unique    , '', '.js');

    console.log    ('---------------------------------------');
    console.timeEnd('API JS Generation Complete             ');
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