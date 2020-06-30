//..............................................................................

const {docUtils, docConstants} = require('mesh-doc-gen');

const {util} = cxq;

const {deleteExistingFileSync} = util;

const {directoryNames  } = meshDocGen;

//..............................................................................

//..............................................................................
function flushDirectory(directory)
{
    if(!directoryExists(directory))
    {
        console.log("Directory Doesn't Exist: " +  directory);

        return;
    }

    try
    {
        var files = getFileListRecursive(directory, 'Flushing Directory');

        for (var i = 0; i < files.length; i++)
        {
            try
            {
                deleteExistingFileSync(files[i]);
            }
            catch (e)
            {
                console.log(e);
                return;
            }
        }
    }
    catch (e)
    {
        console.log(e);
        return;
    }

    deleteFolderRecursive(directory);

}
//..............................................................................

//..............................................................................
function flushOutputFiles(directory, fileFilter)
{
    if(!directoryExists(directory))
    {
        console.log("Directory Doesn't Exist: " +  directory);

        return true;
    }

    var flushPath = path.resolve(directory);

    console.log('Flushing Directory: ' + flushPath);

    try
    {
        flushDirectory(flushPath, false, fileFilter);

        if (fs.existsSync(flushPath))
        {
            deleteFolderRecursive(path.resolve(flushPath));

            if (fs.existsSync(flushPath)) fs.rmdirSync(flushPath);
        }

        return true;
    }
    catch (error)
    {
        console.log('=========================================');
        console.log('Failed to flush: ' + flushPath);
        console.log('----------------------------------');
        console.log('Error Details');
        console.log('----------------------------------');
        console.log(error);
        console.log('=========================================');

        return false;
    }
}
//..............................................................................

//..............................................................................
function flush()
{
    console.time   ('All Outputs Flushed                    ');

    console.log    ('Flushing Outputs...                    ');

    if(!flushOutputFiles(directoryNames.outputFinal       , '*'))
    {
        console.log('Process failed');
        return false;
    }

    if(!flushOutputFiles(directoryNames.outputReports     , '*'))
    {
        console.log('Process failed');
        return false;
    }

    if(!flushOutputFiles(directoryNames.outputIntermediate, '*'))
    {
        console.log('Process failed');
        return false;
    }

    if(!flushOutputFiles(directoryNames.outputTemp              , '*'))
    {
        console.log('Process failed');
        return false;
    }

    if(!flushOutputFiles(directoryNames.outputTemp        , '*'))
    {
        console.log('Process failed');
        return false;
    }

    if(!flushOutputFiles(directoryNames.outputAnalysis    , '*'))
    {
        console.log('Process failed');
        return false;
    }

    console.log    ('---------------------------------------');
    console.timeEnd('All Outputs Flushed                    ');
    console.log    ('---------------------------------------');

    return true;
}
//..............................................................................

//..............................................................................
var exported =
{
    flush
};
//..............................................................................

//..............................................................................

module.exports = exported;
