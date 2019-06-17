//..............................................................................

const
    {
        battery_status,
        humidity,
        light_level,
        motion_detector_9axis,
        pressure_barometric,
        temperature_ambient,
    } = require('./device-endpoints');

//..............................................................................
const st001 =
{
    id: 'mesh-st001',
    device_model : 'mesh-st001',
    endpoints:
    {
        battery_status,
        humidity,
        light_level,
        motion_detector_9axis,
        pressure_barometric,
        temperature_ambient,
    }
};
//..............................................................................

//..............................................................................
const exports =
    [
        st001
    ];
//..............................................................................

module.exports = exports;
