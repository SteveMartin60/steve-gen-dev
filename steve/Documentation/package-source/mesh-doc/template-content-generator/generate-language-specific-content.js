//..............................................................................

require('mesh-base'    );

const {docUtils, docConstants} = require('mesh-doc-utils');

const stringSimilarity = require('string-similarity');

const
{
    findFiles,
    isInArray,
} = docUtils;

const
{
    directoryNames,
    fileExtensions,
    languages,
} = docConstants;

const {fs, path} = cxq;

//..............................................................................

//..............................................................................
function isLanguageSpecificFile(filePath)
{
    return filePath.indexOf(languages.english.suffix) > -1 || filePath.indexOf(languages.chinese.suffix) > -1
}
//..............................................................................

//..............................................................................
function getLanguageSpecificFiles()
{
    console.time   ('Files List Gotten                      ');

    console.log    ('Getting Language Specific Files...     ');

    var languageSpecificFiles = [];

    var filesList = findFiles(directoryNames.productSource, fileExtensions.markdown, 'getLanguageSpecificFiles');

    for (var i = 0; i < filesList.length; i++)
    {
        if (isLanguageSpecificFile(filesList[i]))
        {
            languageSpecificFiles.push(filesList[i]);
        }
    }

    console.log    ('---------------------------------------');
    console.timeEnd('Files List Gotten                       ');
    console.log    ('---------------------------------------');

    return languageSpecificFiles;
}
//..............................................................................

//..............................................................................
function isEnglishFile(filePath)
{
    return filePath.indexOf(languages.english.suffix) > -1
}
//..............................................................................

//..............................................................................
function getMissingContentFilesList(languageSpecificFiles)
{
    var missingContentFilesList = {};
    var missingContentFile      = '';
    var objectName              = '';
    var sourceFile              = '';

    for (var i = 0; i < languageSpecificFiles.length; i++)
    {
        if (isEnglishFile(languageSpecificFiles[i]))
        {
            missingContentFile = languageSpecificFiles[i].replace(languages.english.suffix, languages.chinese.suffix);
        }
        else
        {
            missingContentFile = languageSpecificFiles[i].replace(languages.chinese.suffix, languages.english.suffix);
        }

        if (!isInArray(missingContentFile, languageSpecificFiles))
        {
            sourceFile = languageSpecificFiles[i];

            if (!isEnglishFile(sourceFile))
            {
                console.log('A strange thing: ' + sourceFile);
            }

            objectName = path.basename(missingContentFile);

            missingContentFilesList[objectName] = {};

            missingContentFilesList[objectName].sourceFile         = sourceFile;
            missingContentFilesList[objectName].missingContentFile = missingContentFile;
        }

    }

    return missingContentFilesList;
}
//..............................................................................

//..............................................................................
function createFileCopies(missingContentFilesList)
{
    var fileToCopy = {};

    for (var i = 0; i < Object.keys(missingContentFilesList).length; i++)
    {
        fileToCopy = missingContentFilesList[Object.keys(missingContentFilesList)[i]];

        console.log('Creating File Copy: ' + fileToCopy.missingContentFile);

        fs.copyFileSync(fileToCopy.sourceFile, fileToCopy.missingContentFile);
    }

}
//..............................................................................

//..............................................................................
function generateContent()
{
    console.time   ('Template Content Generated!            ');

    console.log    ('Generating Template Content...         ');

    var similarity = stringSimilarity.compareTwoStrings('sed', 'sealed');

    var languageSpecificFiles = getLanguageSpecificFiles();

    var missingContentFilesList = getMissingContentFilesList(languageSpecificFiles);

    createFileCopies(missingContentFilesList);

    console.log    ('---------------------------------------');
    console.timeEnd('Template Content Generated!            ');
    console.log    ('---------------------------------------');
}
//..............................................................................

//..............................................................................

const exported =
{
    generateContent,
};

module.exports = exported;
