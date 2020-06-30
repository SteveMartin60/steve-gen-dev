//..............................................................................

const
    {
        ambient_temperature,
        barometric_pressure,
        battery_status,
        co_level,
        device,
        gesture_sense,
        humidity,
        lcd,
        light_level,
        motion_detector_9axis,
        pm25_level,
        proximity,
    } = require('./device-endpoints');

//..............................................................................
const sd002 =
    {
        id: 'mesh-sd002',
        device_model : 'mesh-sd002',
        endpoints:
            {
                ambient_temperature,
                barometric_pressure,
                battery_status,
                co_level,
                device,
                gesture_sense,
                humidity,
                lcd,
                light_level,
                motion_detector_9axis,
                pm25_level,
                proximity,
            }
    };
//..............................................................................

//..............................................................................
const exports =
    [
        sd002
    ];
//..............................................................................

module.exports = exports;
