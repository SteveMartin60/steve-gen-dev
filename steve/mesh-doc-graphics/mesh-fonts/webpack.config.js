var webpackTools = require('../../mesh-builder');

const buildConfig = webpackTools.getWebpackOptions
({
    projectName              : 'mesh-fonts',
    projectRootPath          : __dirname,
    projectType              : 'intermediate',
    projectEntryPath         : '.',
    meshApplicationFramework : '0.0.1'
});

module.exports = buildConfig;

