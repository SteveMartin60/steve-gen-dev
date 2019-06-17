//..............................................................................

/*

Require Constants

const pinTableLoader = require('../util-pin-table/interface-generator');

const
    {
        loadPinTableData
    } = pinTableLoader;

*/




const pinTableLoader      = require('./interface-generator');
const missingDataReport   = require('./missing-data-report');
const factorisePins       = require('./factorise-pins');
const loadPinTablesYAML   = require('./load-pin-tables-yaml');
const loadFormFactorsYAML = require('./load-form-factors-yaml');

const {generateModuleInterfaces } = pinTableLoader;
const {generateMissingDataReport} = missingDataReport;
const {factorisePinsTables      } = factorisePins;
const {loadTablesYAML           } = loadPinTablesYAML;
const {loadFormFactors          } = loadFormFactorsYAML;

const {utils, vars} = require('mesh-doc-utils');

//..............................................................................

//..............................................................................
function doStuff()
{
    console.time   ('Pin Table Stuff Completed!             ');

    console.log   ('Doing Pin Table Stuff...                ');

    loadFormFactors();

    return;

    loadTablesYAML();

    factorisePinsTables();

    generateModuleInterfaces();

    generateMissingDataReport();

    console.log    ('---------------------------------------');
    console.timeEnd('Pin Table Stuff Completed!             ');
    console.log    ('---------------------------------------');

}
//..............................................................................

//..............................................................................
doStuff();
//..............................................................................

//..............................................................................
