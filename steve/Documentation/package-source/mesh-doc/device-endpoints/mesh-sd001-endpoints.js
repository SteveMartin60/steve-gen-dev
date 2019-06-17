//..............................................................................

const
    {
        air_quality_co,
        air_quality_pm25,
        pressure_barometric,
        battery_status,
        device,
        gesture_sense,
        humidity,
        lcd,
        light_level,
        motion_detector_9axis,
        proximity,
        temperature_ambient,
        voc_level,
    } = require('./device-endpoints');

//..............................................................................
const sd001 =
{
    id: 'mesh-sd001',
    device_model : 'mesh-sd001',
    endpoints:
    {
        temperature_ambient,
        pressure_barometric,
        battery_status,
        air_quality_co,
        air_quality_pm25,
        device,
        gesture_sense,
        humidity,
        lcd,
        light_level,
        motion_detector_9axis,
        proximity,
        voc_level,
    }
};
//..............................................................................

//..............................................................................
const exports =
    [
        sd001
    ];
//..............................................................................

module.exports = exports;
