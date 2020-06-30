//..............................................................................

const
    {
        temperature_ambient,
        light_level,
        battery_status,
        motion_detector_9axis,
    } = require('./device-endpoints');

//..............................................................................
const cs2000 =
{
    id: 'mesh-cs2000',
    device_model : 'mesh-cs2000',
    endpoints:
    {
        temperature_ambient,
        battery_status,
        light_level,
        motion_detector_9axis,
    }
};
//..............................................................................

//..............................................................................
const exports =
    [
        cs2000
    ];
//..............................................................................

module.exports = exports;
