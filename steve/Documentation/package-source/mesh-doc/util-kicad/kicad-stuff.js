//..............................................................................

const
{
    utils,
} = require('mesh-doc-utils');

const
{
    fileExists,
    findFiles,
    loadTextFileIntoArray,
    replaceAll,
    writeFileToDisk,
} = utils;



var symbolLibraryHeader = 'EESchema-LIBRARY Version 2.3\n#encoding utf-8';
var symbolLibraryFooter = '#End Library\n';
var filesKiCadSymbols   = [];
var libraryContent      = [];
//var symbolLibrarySourcePath = 'E:/Dropbox (Mesheven)/Git/HW Master/Altium 2 KiCad Device Sheets/KiCad-Symbols'; // E:\Dropbox (Mesheven)\Git\HW Master\Altium 2 KiCad Device Sheets\KiCad-Symbols
var symbolLibrarySourcePath = 'E:/Dropbox (Mesheven)/Git/HW Master/Altium 2 KiCad MB Sheets/Lib'; // E:\Dropbox (Mesheven)\Git\HW Master\Altium 2 KiCad MB Sheets\Lib
var symbolLibraryTargetPath = 'E:/Dropbox (Mesheven)/Git/Documentation/Working/KiCad-Symbol-Libraries';         // E:\Dropbox (Mesheven)\Git\Documentation\Working\KiCad-Symbol-Libraries
var writeCount          = 0;

//..............................................................................

//..............................................................................
function loadFileLists()
{
    console.log   ('Finding KiCad Symbol Libraries');

    filesKiCadSymbols = findFiles(symbolLibrarySourcePath, '*', 'Finding KiCad Symbol Libraries');

    console.log   ('Found Libraries: ' + filesKiCadSymbols.length);
}
//..............................................................................

//..............................................................................
function constructSingleSymbolLibraries()
{
    var symbolLibrary = [];
    var contentLine   = '';
    var symbolStarted = false;
    var symbolEnded   = false;
    var symbolName    = '';

    for (var i = 0; i < filesKiCadSymbols.length; i++)
    {
        //console.log('Processing: ' + i  + ' of ' + filesKiCadSymbols.length);
        //console.log('Processing: ' + filesKiCadSymbols[i]);

        symbolLibrary = loadTextFileIntoArray(filesKiCadSymbols[i]);

        for (var j = 2; j < symbolLibrary.length - 1; j++)
        {
            if (!symbolStarted && !symbolEnded)
            {
                libraryContent = [];

                libraryContent.push(symbolLibraryHeader);
                libraryContent.push('#');
                libraryContent.push('# Source: ' + filesKiCadSymbols[i]);
                libraryContent.push('#');
            }

            contentLine = symbolLibrary[j];

            if (contentLine.indexOf('#') === 0)
            {
                libraryContent.push(contentLine);
            }

            if (contentLine.indexOf('ENDDEF') === 0)
            {
                symbolStarted = false;
                symbolEnded   = true;
            }

            if (contentLine.indexOf('DEF ') === 0)
            {
                symbolStarted = true;

                symbolName = contentLine.substring(4);

                while (symbolName.indexOf(' ') > -1) symbolName = symbolName.substring(0, symbolName.length -1);

                if (fileExists(symbolLibraryTargetPath + '/' + symbolName + '.lib'))
                {
                    symbolStarted = false;
                    symbolEnded   = false;
                }
            }

            if (symbolStarted)
            {
                libraryContent.push(contentLine);
            }

            if (symbolEnded)
            {
                libraryContent.push(contentLine);

                libraryContent.push(symbolLibraryFooter);

                symbolName= replaceAll(symbolName, '\\', '-');
                symbolName= replaceAll(symbolName, '/' , '-');

                if(fileExists(symbolLibraryTargetPath + '/' + symbolName + '.lib'))
                {
                    console.log('Skipping ' + writeCount + ': Source: '  + filesKiCadSymbols[i] + ' | Target: ' + symbolName + '.lib');
                }
                else
                {
                    console.log('Writing  ' + writeCount + ': Source: '  + filesKiCadSymbols[i] + ' | Target: ' + symbolName + '.lib');

                    writeFileToDisk(libraryContent.join('\n'), symbolLibraryTargetPath, symbolName + '.lib');

                    writeCount++;
                }

                symbolEnded = false;
            }
        }
    }
}
//..............................................................................

//..............................................................................
function constructKiCadSymbolLibrary()
{
    loadFileLists();

    constructSingleSymbolLibraries();

}
//..............................................................................

//..............................................................................

var exported  =
{
    constructKiCadSymbolLibrary,
};
//..............................................................................

//..............................................................................

module.exports = exported;