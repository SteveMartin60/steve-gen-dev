//..............................................................................
require('mesh-base');
require('mesh-doc-gen');

const {util} = cxq;

const {genPinDiagram} = meshDocGen;

const flushOutputs                 = require('./flush-outputs');

const namespacesGenerator          = require('../01-generate-namespaces/generate-namespaces-object'      );
const helpSourceGenerator          = require('../02-generate-js-source/generate-help-source'            );
const intellisenseSourceGenerator  = require('../02-generate-js-source/generate-intellisense-source'    );
const intermediateContentGenerator = require('../03-generate-intermediate/generate-intermediate-content');
const apiHtmlGenerator             = require('../04-generate-api-output/generate-api-html'               );
const apiJSGenerator               = require('../04-generate-api-output/generate-api-js'                 );
const productDocDataLoader         = require('../05-generate-doc-pages-object/product-doc-data-loader'   );
const localisedMDGenerator         = require('../06-generate-localised-md/generate-localised-md'        );
const localisedHTMLGenerator       = require('../07-final-output-generator/generate-final-output'         );
// const productDocAnalyser           = require('../08-product-doc-analysis/01-run-analysis'                );

//..............................................................................

//..............................................................................
function doStuff()
{
    console.time   ('All Processes Completed!               ');

    //if (flushOutputs.flush())
    {
        //namespacesGenerator         .generate();
        //helpSourceGenerator         .generate();
        //intellisenseSourceGenerator .generate();
        //intermediateContentGenerator.generate();
        //apiJSGenerator              .generate();
        //apiHtmlGenerator            .generate();

        //productDocDataLoader  .createDocPagesObject();
        //localisedMDGenerator  .generate();
        localisedHTMLGenerator.generate();
    }
/*
*/
        // productDocAnalyser.analyse();

    console.log    ('---------------------------------------');
    console.timeEnd('All Processes Completed!               ');
    console.log    ('---------------------------------------');
}
//..............................................................................

//..............................................................................
doStuff();
//..............................................................................

//..............................................................................

