//..............................................................................

const
    {
        temperature_ambient,
        battery_status,
        light_level,
        motion_detector_9axis,
        gpio_control_x16
    } = require('./device-endpoints');

//..............................................................................
const cm001 =
{
    id           : 'mesh-cm001',
    device_model : 'mesh-cm001',
    endpoints:
    {
        temperature_ambient,
        battery_status,
        light_level,
        motion_detector_9axis,
        gpio_control_x16,
    }
};
//..............................................................................

//..............................................................................
const exports =
    [
        cm001
    ];
//..............................................................................

module.exports = exports;
