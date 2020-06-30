//..............................................................................

const
    {
        ambient_temperature,
        barometric_pressure,
        battery_status,
        device,
        gesture_sense,
        humidity,
        lcd,
        light_level,
        motion_detector_9axis,
        proximity,
    } = require('./device-endpoints');

//..............................................................................
const sd003 =
    {
        id: 'mesh-sd003',
        device_model : 'mesh-sd003',
        endpoints:
            {
                ambient_temperature,
                barometric_pressure,
                battery_status,
                device,
                gesture_sense,
                humidity,
                lcd,
                light_level,
                motion_detector_9axis,
                proximity,
            }
    };
//..............................................................................

//..............................................................................
const exports =
    [
        sd003
    ];
//..............................................................................

module.exports = exports;
