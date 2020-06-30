
//..............................................................................
console.time    ('Namespace Generator Modules Loaded     ');

const {docUtils, docConstants} = meshDocGen;

var
{
    directoryNames,
    fileNames,
    stringsUtil,
} = docConstants;


const {fs, path} = cxq;

console.timeEnd('Namespace Generator Modules Loaded     ');

const
{
    loadTextFileIntoArray,
    replaceAt,
    replaceBetween,
    substringCount,
    replaceAll,
    writeObjectToDiskJSON,
} = docUtils;

//..............................................................................

//..............................................................................
function getParameterType(parameter)
{
        if (parameter.name.toLowerCase() === 'id' || parameter.name.substring(parameter.name.length-2).toLowerCase() === 'id')
        {
            parameter.type = 'string';
        }

        if (parameter.name.toLowerCase() === 'path' || parameter.name.substring(parameter.name.length-4).toLowerCase() === 'path')
        {
            parameter.type = 'string';
        }

        if (parameter.name.toLowerCase() === 'options')
        {
            parameter.type =  'object';
        }

        if (parameter.name.toLowerCase() === 'fn')
        {
            parameter.type =  'function';
        }

        if (parameter.name.substring(parameter.name.length - 2) === 'Fn')
        {
            parameter.type =  'function';
        }

        if (parameter.name === 'callback' || parameter.name.substring(parameter.name.length - 8) === 'Callback')
        {
            parameter.type =  'callback';
        }

        if (parameter.name === 'obj' || parameter.name.substring(parameter.name.length - 6) === 'Object')
        {
            parameter.type =  'object';
        }

        if (parameter.name.substring(parameter.name.length - 4).toLowerCase() === 'name')
        {
            parameter.type =  'string';
        }

        if (parameter.name === 'num')
        {
            parameter.type =  'number';
        }

        if (parameter.name === 's')
        {
            parameter.type =  'string';
        }

        if (parameter.name === 'size' || parameter.name.substring(parameter.name.length - 4) === 'Size')
        {
            parameter.type =  'number';
        }

        if (parameter.name === 'str' || parameter.name.substring(parameter.name.length - 3) === 'Str')
        {
            parameter.type =  'string';
        }

        if (parameter.name === 'extension' || parameter.name.substring(parameter.name.length - 9) === 'Extension')
        {
            parameter.type =  'string';
        }

        if (parameter.name === 'string' || parameter.name.substring(parameter.name.length - 6) === 'String')
        {
            parameter.type =  'string';
        }

        if (parameter.name === 'password' || parameter.name.substring(parameter.name.length - 8) === 'Password')
        {
            parameter.type =  'string';
        }

        if (parameter.name === 'text' || parameter.name.substring(parameter.name.length - 4) === 'Text')
        {
            parameter.type =  'string';
        }

        if (parameter.name === 's1' || parameter.name === 's2'  || parameter.name === 's3'  || parameter.name === 's4')
        {
            parameter.type =  'string';
        }

        if (parameter.name === 'n1' || parameter.name === 'n2'  || parameter.name === 'n3'  || parameter.name === 'n4')
        {
            parameter.type =  'number';
        }

        return parameter;
}
//..............................................................................

//..............................................................................
function getParameter(parameterString)
{
    var parameter =
        {
            name    : '',
        };

    parameter.name = parameterString;

    parameter = getParameterType(parameter);

    if (parameterString.includes('='))
    {
        parameter.name    = parameterString.substring(0, parameterString.indexOf('='));
        parameter.default = parameterString.substring(parameterString.indexOf('=')+1);
    }

    if (parameter.type)
    {
        //noinspection EqualityComparisonWithCoercionJS
        if (typeof parameter.default == 'number') parameter.type = 'number';
    }

    return parameter;
}
//..............................................................................

//..............................................................................
function getParameterStrings(rawText)
{
    // TODO deal with curly brackets parameters
    var tempString = replaceAll(rawText, '{', '');
    tempString     = replaceAll(tempString, '}', '');

    while (tempString.indexOf('(') !== 0) tempString = tempString.substring(1);

    while (tempString.indexOf(')') !== tempString.length -1) tempString = tempString.substring(0, tempString.length -1);

    tempString = tempString.substring(1, tempString.length -1);

    if (tempString.charAt(0) === '{')
    {
        tempString = tempString.substring(1, tempString.length -1);
    }

    if (tempString.includes('/*'))
    {
        tempString = replaceAt(tempString, tempString.lastIndexOf("/"), "ﬆ");
        tempString = replaceAt(tempString, tempString.lastIndexOf("/"), "ự");

        var commentStr = tempString;

        commentStr = commentStr.substring(commentStr.lastIndexOf("ﬆ"), commentStr.lastIndexOf("ự"));

        while (commentStr.includes(',')) commentStr = commentStr.replace(',', 'Ễ');

        tempString = replaceBetween(tempString, tempString.lastIndexOf("ự"), tempString.lastIndexOf("ﬆ"), commentStr);
    }

    var parameterStrings = tempString.split(',');

    for (var i = 0; i < parameterStrings.length; i++)
    {
        parameterStrings[i] = parameterStrings[i].trim();

        parameterStrings[i] = parameterStrings[i].replace('ự*', ' //');
        parameterStrings[i] = parameterStrings[i].replace(' *ﬆ', '');

        while (parameterStrings[i].includes('Ễ')) parameterStrings[i] = parameterStrings[i].replace('Ễ', ',');
    }

    return parameterStrings;
}
//..............................................................................

//..............................................................................
function getMethodName(rawText)
{
    var methodName = rawText;

    methodName = methodName.substring(9).trim();

    while (methodName.includes("(")) methodName = methodName.substring(0, methodName.length -1);

    return methodName.trim();
}
//..............................................................................

//..............................................................................
function getPropertyName(rawText)
{
    var propertyName = rawText;

    propertyName = propertyName.substring(propertyName.indexOf(' ')).trim();

    while (propertyName.includes(' ')) propertyName = propertyName.substring(0, propertyName.length -1);

    return propertyName.trim();
}
//..............................................................................

//..............................................................................
function getCallbackParameters(parameters, parameter)
{
    var callbackParameter = parameter;

    callbackParameter.type = 'callback';
    callbackParameter.description = 'Callback function that returns an error state and data';

    parameters.push(callbackParameter);

    var callbackErrorParameter =
        {
            name        : 'callback.err',
            type        : 'string',
            description : 'Callback function error string',
        };

    var callbackDataParameter =
        {
            name        : 'callback.data',
            type        : 'string',
            description : 'Callback function data',
        };

    parameters.push(callbackErrorParameter);

    parameters.push(callbackDataParameter);

    return parameters;
}
//..............................................................................

//..............................................................................
function getMethodReturns(method)
{
    if (method.shortName.substring(0, 3) === 'has' && method.shortName.substring(3, 3) !== method.shortName.substring(3, 2).toLowerCase())
    {
      method.returns = 'boolean';
    }

    if (method.shortName.substring(0, 2) === 'is' && method.shortName.substring(3, 2) !== method.shortName.substring(3, 2).toLowerCase())
    {
      method.returns = 'boolean';
    }

    if (method.shortName.indexOf('fieldIs') === 0)
    {
        method.returns = 'boolean';
    }

    if (method.shortName.substring(0, 8) === 'asString' || method.shortName.substring(method.shortName.length -8, method.shortName.length) === 'AsString')
    {
        method.returns = 'string';
    }

    if (method.shortName.substring(0, 4) === 'asId' || method.shortName.substring(method.shortName.length -4, method.shortName.length) === 'AsId')
    {
        method.returns = 'string';
    }

    if (method.shortName.substring(0, 4) === 'getDescription')
    {
        method.returns = 'string';
    }

    if (method.shortName.substring(0, 4) === 'getCaption')
    {
        method.returns = 'string';
    }

    return method;
}
//..............................................................................

//..............................................................................
function getMethod(rawText, namespace)
{
    var parameterStrings = [];

    var method =
        {
            rawText   : '',
            fullName  : '',
            shortName : '',
            params    : [],
        };

    method.rawText   = rawText;
    method.shortName = getMethodName(rawText);
    method.fullName  = namespace + '.' + method.shortName;

    if (rawText.substring(rawText.length -2, rawText.length) === '()')
    {
        return method;
    }
    else
    {
        parameterStrings = getParameterStrings(rawText);
    }

    for (var i = 0; i < parameterStrings.length; i++)
    {
        var parameter = getParameter(parameterStrings[i]);

        if (parameter.type === 'callback')
        {
            method.params = getCallbackParameters(method.params, parameter);
        }
        else method.params.push(parameter);
    }

    method = getMethodReturns(method);

    return method;
}
//..............................................................................

//..............................................................................
function getPropertyType(rawText)
{
    var propertyType = rawText;

    if (propertyType.includes('Type: '))
    {
        while (propertyType.includes(':')) propertyType = propertyType.substring(1);

        return propertyType.trim();
    }

    return propertyType.substring(propertyType.indexOf(':') + 1, propertyType.lastIndexOf(' ')).trim();
}
//..............................................................................

//..............................................................................
function getProperty(rawText, namespace)
{
    var property =
        {
            shortName : '',
            fullName  : '',
            rawText   : '',
            type      : '',
        };

    property.rawText   = rawText;
    property.shortName = getPropertyName(rawText);

    if (namespace.fullName)
    {
        property.fullName  = namespace.fullName + '.' + property.shortName;
    }
    else property.fullName  = namespace + '.' + property.shortName;

    property.type = getPropertyType(rawText);

    return property;
}
//..............................................................................

//..............................................................................
function getCustomType(rawText, namespace)
{
    var customType =
        {
            shortName : '',
            fullName  : '',
            rawText   : '',
            type      : '',
        };

    customType.rawText   = rawText;
    customType.shortName = getPropertyName(rawText);
    customType.fullName  = namespace.fullName + '.' + customType.shortName;

    customType.type      = rawText.substring(rawText.lastIndexOf(' ')).trim();
    customType.shortName = rawText.substring(rawText.indexOf(' '), rawText.indexOf('Type')).trim();
    customType.rawText   = rawText;
    if (namespace.parent)
    {
        customType.fullName  = parent + '. ' + customType.shortName;
        customType.parent    = parent;
    }
    else
    {
        customType.fullName  = customType.shortName;
    }

    return customType;
}
//..............................................................................

//..............................................................................
function getNamespacesHierarchy(data)
{
    var names               = [];
    var namespacesHierarchy = data;

    for (var i = 0; i < namespacesHierarchy.length; i++)
    {
        if (namespacesHierarchy[i].isChild)
        {
            names.push(namespacesHierarchy[i].parent + '/' +  namespacesHierarchy[i].shortName);
        }
        else names.push(namespacesHierarchy[i].shortName);
    }

    for (i = 0; i < namespacesHierarchy.length; i++)
    {
        if (namespacesHierarchy[i].fullName.indexOf('.') === -1) namespacesHierarchy[i].isChild = false;
    }

    for (i = 0; i < namespacesHierarchy.length; i++)
    {
        for (var j = 0; j < namespacesHierarchy.length; j++)
        {
            if (namespacesHierarchy[j].fullName === namespacesHierarchy[i].parent)
            {
                namespacesHierarchy[j].children.push(namespacesHierarchy[i]);

                namespacesHierarchy[j].isParent = true;
            }
        }
    }

    return namespacesHierarchy
}
//..............................................................................

//..............................................................................
function getNamespaces(rawStructure)
{
    var namespace =
        {
            children      : [],
            count         : [],
            customTypes   : [],
            filename      : '',
            fullName      : '',
            isChild       : false,
            isParent      : false,
            methodCount   : 0,
            methods       : [],
            parent        : '',
            properties    : [],
            shortName     : '',
        };

    var namespaces = [];

    var method     = [];
    var property   = [];
    var customType = [];

    namespace.fullName = rawStructure[0].substring(17).trim();
    namespace.filename = replaceAll(rawStructure[0].substring(17).toLowerCase().trim(), '.', '-') + '.js';

    for (var i = 1; i < rawStructure.length; i++)
    {
        if (!rawStructure[i].includes('NameSpaceObject'))
        {
            if (rawStructure[i].indexOf("function ") === 0)
            {
                method = getMethod(rawStructure[i], namespace.fullName);

                method.parent = namespace.fullName;

                namespace.methods.push(method);
            }

            if (rawStructure[i].indexOf("Property:") === 0)
            {
                property = getProperty(rawStructure[i], namespace.fullName);

                property.parent = namespace.fullName;

                namespace.properties.push(property);
            }

            if (rawStructure[i].indexOf("Property:") === 0 && rawStructure[i].includes('Type: '))
            {
                customType = getCustomType(rawStructure[i], namespace);

                customType.parent = namespace.fullName;

                namespace.customTypes.push(customType);
            }
        }
        else
        {
            namespaces.push(namespace);

            namespace =
                {
                    children      : [],
                    customTypes   : [],
                    count         : [],
                    methods       : [],
                    properties    : [],
                };
            namespace.fullName = rawStructure[i].substring(17).trim();

            namespace.filename = replaceAll(rawStructure[i].substring(17).toLowerCase().trim(), '.', '-') + '.js';

            namespace.fullName = rawStructure[i].substring(17).trim();
        }
    }

    namespaces.push(namespace);

    for (i = 0; i < namespaces.length; i++)
    {

        if (namespaces[i].fullName.includes('.'))
        {
            var nameSubstring = namespaces[i].fullName;

            while (substringCount(nameSubstring, '.') > 1)
                nameSubstring = nameSubstring.substring(1);

            nameSubstring = nameSubstring.split('.');

            namespaces[i].shortName = nameSubstring[1];
            namespaces[i].parent    = namespaces[i].fullName;

            while (namespaces[i].parent.charAt(namespaces[i].parent.length -1)!== '.')
            {
                namespaces[i].parent = namespaces[i].parent.substring(0, namespaces[i].parent.length -1);
            }

            namespaces[i].parent = namespaces[i].parent.substring(0, namespaces[i].parent.length -1).trim();

            namespaces[i].isChild = true;
        }

        if(!namespaces[i].shortName) namespaces[i].shortName = namespaces[i].fullName;
    }

    return namespaces;
}
//..............................................................................

//..............................................................................
function updateReservedWords(data)
{
    var rawStructure = data;

    var reservedWordListFile = path.resolve(directoryNames.source + directoryNames.api + '/' + fileNames.reservedWordList);

    var reservedWords = fs.readFileSync(reservedWordListFile).toString().split("\n");

    for (var i = 0; i < reservedWords.length; i++)
    {
        var reservedWord = reservedWords[i].trim();

        for (var j = 0; j < rawStructure.length -1; j++)
        {
            if (reservedWord.length > 1)
            {
                if (rawStructure[i].includes(reservedWord))
                {
                    rawStructure[i] = rawStructure[i].replace(reservedWord, stringsUtil.unique + reservedWord + stringsUtil.unique);
                }
            }
        }
    }

    return rawStructure;
}
//..............................................................................

//..............................................................................
function generate()
{
    console.time   ('API Namespaces Object Generated        ');

    console.log    ('Generating API Namespaces Object...    ');

    var sourceAPI = loadTextFileIntoArray(directoryNames.source + directoryNames.api + '/'  + fileNames.apiStructure);

    var rawStructure = [];

    for (var i = 0; i < sourceAPI.length; i++)
    {
        if (!sourceAPI[i].includes('---') && sourceAPI[i].length > 2) rawStructure.push(sourceAPI[i].trim());
    }

    rawStructure = updateReservedWords(rawStructure);

    var namespaces = getNamespaces(rawStructure);

    namespaces = getNamespacesHierarchy(namespaces);

    writeObjectToDiskJSON(namespaces, directoryNames.outputIntermediate, fileNames.namespacesJSON);

    console.log    ('---------------------------------------');
    console.timeEnd('API Namespaces Object Generated        ');
    console.log    ('---------------------------------------');
}
//..............................................................................

//..............................................................................

const exported =
{
    generate
};

module.exports =  exported;