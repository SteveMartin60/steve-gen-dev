//..............................................................................
console.time    ('Intellisense Generator Modules Loaded  ');

const {docUtils, docConstants, docElementsJsDoc} = require('mesh-doc-utils');

var
{
    directoryNames,
    fileNames,
    stringsUtil,
    namespaces,
} = docConstants;

const {path} = cxq;

console.timeEnd('Intellisense Generator Modules Loaded  ');

const
{
    loadObjectJSON,
    writeFileToDisk,
} =  docUtils;

const
{
    blankLine,
    codeContentFinish,
    codeContentPrefixEn,
    codeContentPrefixZh,
    codeContentStart,
    codeContentSuffix,
    codeDeclarationPrefix,
    codeExampleDescriptionEn,
    codeExampleDescriptionZh,
    codeExampleTitleIntellisenseEn,
    codeExampleTitleIntellisenseZh,
    codeFormatFinishIntellisense,
    codeFormatStartIntellisense,
    commentBlockEnd,
    commentBlockStart,
    commentDescriptionPrefixIntellisenseEn,
    commentDescriptionPrefixIntellisenseZh,
    curlyBracketsClose,
    curlyBracketsOpen,
    memberOfPrefix,
    oneDoubleQuote,
    parameterDescriptionInfixIntellisenseEn ,
    parameterDescriptionInfixIntellisenseZh ,
    parameterPrefix,
    parameterTypeSuffix,
    propertyDeclarationSuffix,
    propertyInfix,
    propertyPrefix,
    returnsPrefix,
    roundBrackets,
    seeAlsoLinkPrefixIntellisenseEn,
    seeAlsoLinkPrefixIntellisenseZh,
    seeAlsoLinkSuffixIntellisenseEn,
    seeAlsoLinkSuffixIntellisenseZh,
    singleSpace,
    summaryPrefixIntellisenseEn,
    summaryPrefixIntellisenseZh,
    typeDefPrefix,
    typePrefix,
} = require('../../../node_modules/mesh-doc-gen/static/jsdoc');

const
{
    getMethodDeclaration,
    doPostProcess,
    writeCommentFooter,
    writeNamespaceHeader,
    writeSpacerBlock,
} = require('../../../node_modules/mesh-doc-gen/helpers/jsdoc');

//..............................................................................

//..............................................................................
function writeCommentHeaderEn(jsFile, object)
{
    var seeAlsoLinkString = seeAlsoLinkPrefixIntellisenseEn        + object.fullName  + ' ' + object.fullName + seeAlsoLinkSuffixIntellisenseEn;

    jsFile.push(commentBlockStart                                         + stringsUtil.newLine);
    jsFile.push(memberOfPrefix                         + object.parent    + stringsUtil.newLine);
    jsFile.push(blankLine                                                 + stringsUtil.newLine);
    jsFile.push(summaryPrefixIntellisenseEn            + object.shortName + stringsUtil.newLine);
    jsFile.push(blankLine                                                 + stringsUtil.newLine);
    jsFile.push(commentDescriptionPrefixIntellisenseEn + object.shortName + stringsUtil.newLine);
    jsFile.push(blankLine                                                 + stringsUtil.newLine);
    jsFile.push(seeAlsoLinkString                                         + stringsUtil.newLine);
}
//..............................................................................

//..............................................................................
function writeCommentHeaderZh(jsFile, object)
{
    var seeAlsoLinkString = seeAlsoLinkPrefixIntellisenseZh        + object.fullName  + ' ' + object.fullName + seeAlsoLinkSuffixIntellisenseZh;

    jsFile.push(commentBlockStart                                         + stringsUtil.newLine);
    jsFile.push(memberOfPrefix                         + object.parent    + stringsUtil.newLine);
    jsFile.push(blankLine                                                 + stringsUtil.newLine);
    jsFile.push(summaryPrefixIntellisenseZh            + object.shortName + stringsUtil.newLine);
    jsFile.push(blankLine                                                 + stringsUtil.newLine);
    jsFile.push(commentDescriptionPrefixIntellisenseZh + object.shortName + stringsUtil.newLine);
    jsFile.push(blankLine                                                 + stringsUtil.newLine);
    jsFile.push(seeAlsoLinkString                                         + stringsUtil.newLine);
}
//..............................................................................

//..............................................................................
function writeCodeExampleEn(shortName, fullName, jsFile)
{
    jsFile.push(blankLine                                                      + stringsUtil.newLine);
    jsFile.push(codeExampleTitleIntellisenseEn                                 + stringsUtil.newLine);
    jsFile.push(codeExampleDescriptionEn                                       + stringsUtil.newLine);
    jsFile.push(codeFormatStartIntellisense                                    + stringsUtil.newLine);
    jsFile.push(codeDeclarationPrefix          + shortName + roundBrackets     + stringsUtil.newLine);
    jsFile.push(codeContentStart                                               + stringsUtil.newLine);
    jsFile.push(codeContentPrefixEn            + fullName  + codeContentSuffix + stringsUtil.newLine);
    jsFile.push(codeContentFinish                                              + stringsUtil.newLine);
    jsFile.push(codeFormatFinishIntellisense                                   + stringsUtil.newLine);
    jsFile.push(codeExampleTitleIntellisenseEn                                 + stringsUtil.newLine);
    jsFile.push(codeExampleDescriptionEn                                       + stringsUtil.newLine);
    jsFile.push(codeFormatStartIntellisense                                    + stringsUtil.newLine);
    jsFile.push(codeDeclarationPrefix          + shortName + roundBrackets     + stringsUtil.newLine);
    jsFile.push(codeContentStart                                               + stringsUtil.newLine);
    jsFile.push(codeContentPrefixEn            + fullName  + codeContentSuffix + stringsUtil.newLine);
    jsFile.push(codeContentFinish                                              + stringsUtil.newLine);
    jsFile.push(codeFormatFinishIntellisense                                   + stringsUtil.newLine);

    return jsFile;
}
//..............................................................................

//..............................................................................
function writeCodeExampleZh(shortName, fullName, jsFile)
{
    jsFile.push(blankLine                                                      + stringsUtil.newLine);
    jsFile.push(codeExampleTitleIntellisenseZh                                 + stringsUtil.newLine);
    jsFile.push(codeExampleDescriptionZh                                       + stringsUtil.newLine);
    jsFile.push(codeFormatStartIntellisense                                    + stringsUtil.newLine);
    jsFile.push(codeDeclarationPrefix          + shortName + roundBrackets     + stringsUtil.newLine);
    jsFile.push(codeContentStart                                               + stringsUtil.newLine);
    jsFile.push(codeContentPrefixZh            + fullName  + codeContentSuffix + stringsUtil.newLine);
    jsFile.push(codeContentFinish                                              + stringsUtil.newLine);
    jsFile.push(codeFormatFinishIntellisense                                   + stringsUtil.newLine);
    jsFile.push(codeExampleTitleIntellisenseZh                                 + stringsUtil.newLine);
    jsFile.push(codeExampleDescriptionZh                                       + stringsUtil.newLine);
    jsFile.push(codeFormatStartIntellisense                                    + stringsUtil.newLine);
    jsFile.push(codeDeclarationPrefix          + shortName + roundBrackets     + stringsUtil.newLine);
    jsFile.push(codeContentStart                                               + stringsUtil.newLine);
    jsFile.push(codeContentPrefixZh            + fullName  + codeContentSuffix + stringsUtil.newLine);
    jsFile.push(codeContentFinish                                              + stringsUtil.newLine);
    jsFile.push(codeFormatFinishIntellisense                                   + stringsUtil.newLine);

    return jsFile;
}
//..............................................................................

//..............................................................................
function writeCommentExampleCodeFunctionEn(jsFile, method)
{
    var basicCache = []; basicCache.addItem = '';

    var fullName = '';

    if (method.parent)
    {
        fullName = method.parent + '.' + method.shortName;
    }
    else
    {
        fullName = method.shortName;
    }

    writeCodeExampleEn(method.shortName, fullName, jsFile);
}
//..............................................................................

//..............................................................................
function writeCommentExampleCodeFunctionZh(jsFile, method)
{
    var basicCache = []; basicCache.addItem = '';

    var fullName = '';

    if (method.parent)
    {
        fullName = method.parent + '.' + method.shortName;
    }
    else
    {
        fullName = method.shortName;
    }

    writeCodeExampleZh(method.shortName, fullName, jsFile);
}
//..............................................................................

//..............................................................................
function writePropertyEn(jsFile, property)
{
    jsFile.push(stringsUtil.newLine);

    writeCommentHeaderEn(jsFile, property);

    writeCodeExampleEn(property.shortName, property.parent + '.' + property.shortName, jsFile);

    jsFile.push(typePrefix     + property.type                                                      + stringsUtil.newLine);
    jsFile.push(propertyPrefix + property.type + propertyInfix + property.shortName + stringsUtil.newLine);
    jsFile.push(commentBlockEnd                                                                     + stringsUtil.newLine);
    jsFile.push(                                      property.shortName + propertyDeclarationSuffix     + stringsUtil.newLine);

    writeSpacerBlock(jsFile);

    return jsFile;
}
//..............................................................................

//..............................................................................
function writePropertyZh(jsFile, property)
{
    jsFile.push(stringsUtil.newLine);

    writeCommentHeaderZh(jsFile, property);

    writeCodeExampleZh(property.shortName, property.parent + '.' + property.shortName, jsFile);

    jsFile.push(typePrefix     + property.type                                                      + stringsUtil.newLine);
    jsFile.push(propertyPrefix + property.type + propertyInfix + property.shortName + stringsUtil.newLine);
    jsFile.push(commentBlockEnd                                                                     + stringsUtil.newLine);
    jsFile.push(                                      property.shortName + propertyDeclarationSuffix     + stringsUtil.newLine);

    writeSpacerBlock(jsFile);

    return jsFile;
}
//..............................................................................

//..............................................................................
function writeCustomTypeEn(jsFile, customType)
{
    jsFile.push(stringsUtil.newLine);

    writeCommentHeaderEn(jsFile, customType);

    jsFile.push(typeDefPrefix + customType.shortName + stringsUtil.newLine);

    jsFile.push(commentBlockEnd                 + stringsUtil.newLine);

    writeSpacerBlock(jsFile);

    return jsFile;
}
//..............................................................................

//..............................................................................
function writeCustomTypeZh(jsFile, customType)
{
    jsFile.push(stringsUtil.newLine);

    writeCommentHeaderZh(jsFile, customType);

    jsFile.push(typeDefPrefix + customType.shortName + stringsUtil.newLine);

    jsFile.push(commentBlockEnd                 + stringsUtil.newLine);

    writeSpacerBlock(jsFile);

    return jsFile;
}
//..............................................................................

//..............................................................................
function writeMethodEn(jsFile, method)
{
    var jsLine    = '';

    writeCommentHeaderEn(jsFile, method);
    writeCommentExampleCodeFunctionEn(jsFile, method);

    if (method.params)
    {
        for (var i = 0; i < method.params.length; i++)
        {
            jsLine = parameterPrefix;

            if (method.params[i].type)
            {
                jsLine = jsLine + curlyBracketsOpen +  method.params[i].type + parameterTypeSuffix;
            }
            else
            {
                jsLine = jsLine + curlyBracketsOpen +  'operator' + parameterTypeSuffix;
            }

            jsLine = jsLine + method.params[i].name + singleSpace;

            if (method.params[i].description)
            {
                jsLine = jsLine +  method.params[i].description;
            }
            else  jsLine = jsLine +  parameterDescriptionInfixIntellisenseEn + method.params[i].name + oneDoubleQuote;

            jsFile.push(jsLine + stringsUtil.newLine);
        }
    }

    if (method.returns)
    {
        jsFile.push(returnsPrefix + method.returns + curlyBracketsClose + stringsUtil.newLine);
    }

    var methodDeclaration = getMethodDeclaration(method.rawText, method);

    writeCommentFooter(jsFile);
    jsFile.push(methodDeclaration + stringsUtil.newLine);

    writeSpacerBlock(jsFile);

    return jsFile;
}
//..............................................................................

//..............................................................................
function writeMethodZh(jsFile, method)
{
    var jsLine    = '';

    writeCommentHeaderZh(jsFile, method);
    writeCommentExampleCodeFunctionZh(jsFile, method);

    if (method.params)
    {
        for (var i = 0; i < method.params.length; i++) {
            jsLine = parameterPrefix;

            if (method.params[i].type) {
                jsLine = jsLine + curlyBracketsOpen + method.params[i].type + parameterTypeSuffix;
            }
            else {
                jsLine = jsLine + curlyBracketsOpen + 'operator' + parameterTypeSuffix;
            }

            jsLine = jsLine + method.params[i].name + singleSpace;

            if (method.params[i].description) {
                jsLine = jsLine + method.params[i].description;
            }
            else  jsLine = jsLine + parameterDescriptionInfixIntellisenseZh + method.params[i].name + oneDoubleQuote;

            jsFile.push(jsLine + stringsUtil.newLine);
        }
    }

    if (method.returns)
    {
        jsFile.push(returnsPrefix + method.returns + curlyBracketsClose + stringsUtil.newLine);
    }

    var methodDeclaration = getMethodDeclaration(method.rawText, method);

    writeCommentFooter(jsFile);
    jsFile.push(methodDeclaration + stringsUtil.newLine);

    writeSpacerBlock(jsFile);

    return jsFile;
}
//..............................................................................

//..............................................................................
function writeFile(namespace)
{
    var jsFile   = writeNamespaceHeader(namespace);

    for (var i = 0; i < namespace.customTypes.length; i++)
    {
        writeCustomTypeEn(jsFile  , namespace.customTypes[i]);
        writeCustomTypeZh(jsFile  , namespace.customTypes[i]);
    }

    for (i = 0; i < namespace.properties.length; i++)
    {
        writePropertyEn(jsFile, namespace.properties[i]);
        writePropertyZh(jsFile, namespace.properties[i]);
    }

    for (i = 0; i < namespace.methods.length; i++)
    {
        writeMethodEn(jsFile, namespace.methods[i]);
        writeMethodZh(jsFile, namespace.methods[i]);
    }

    var filename = namespace.filename.substring(0, namespace.filename.lastIndexOf('.')) + path.extname(namespace.filename);

    writeFileToDisk(jsFile.join(''), directoryNames.outputIntermediate + directoryNames.js +  directoryNames.sourceIntellisense, filename);
}
//..............................................................................

//..............................................................................
function writeDocs()
{
    for (var i = 0; i <  namespaces.length; i++)
    {
        writeFile(namespaces[i]);
    }
}
//..............................................................................

//..............................................................................
function generate()
{
    console.time   ('API Intellisense Source Generated      ');

    console.log    ('Generating API Intellisense Source...  ');

    namespaces = loadObjectJSON(directoryNames.outputIntermediate + '/' + fileNames.namespacesJSON);

    writeDocs();

    doPostProcess(directoryNames.sourceIntellisense);

    console.log    ('---------------------------------------');
    console.timeEnd('API Intellisense Source Generated      ');
    console.log    ('---------------------------------------');
}
//..............................................................................

//..............................................................................

const exported =
{
    generate
};

module.exports =  exported;