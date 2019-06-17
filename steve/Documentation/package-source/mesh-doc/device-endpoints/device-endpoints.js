//..............................................................................
const level_control_x16 =
{
    id         : 'level_control_x16',
    data_model : 'level_control_x16',
};
//..............................................................................

//..............................................................................
const enable =
{
    id             : 'enable',
    primitive_type : 'boolean',
    caption_en     : 'Enable',
    description_en : 'Channel enabled',
};
//..............................................................................

//..............................................................................
const temperature_sensor =
{
    id         : 'temperature_sensor',
    data_model : 'temperature_sensor',
};
//..............................................................................

//..............................................................................
const temperature_internal_enclosure =
{
    id             : 'temperature_internal_enclosure',
    caption_en     : 'Temperature',
    description_en : 'Internal enclosure temperature',
    metrics:
    {
        temperature_sensor,
    },
};
//..............................................................................

//..............................................................................
const temperature_psu  =
{
    id             : 'temperature_psu',
    caption_en     : 'Temperature',
    description_en : 'Power supply temperature',
    metrics:
    {
        temperature_sensor,
    },
};
//..............................................................................

//..............................................................................
const temperature_ambient =
    {
        id             : 'temperature_ambient',
        caption_en     : 'Temperature °C',
        description_en : 'Ambient temperature in Celsius)',
        metrics:
        {
            temperature_sensor,
        },
    };
//..............................................................................

//..............................................................................
const voltage_input =
{
    id             : 'voltage_input',
    unit_type      : 'millivolts',
    caption_en     : 'Voltage',
    description_en : 'Input voltage',
};
//..............................................................................

//..............................................................................
const voltage_output =
    {
        id             : 'voltage_output',
        unit_type      : 'millivolts',
        caption_en     : 'Voltage',
        description_en : 'Output voltage',
    };
//..............................................................................

//..............................................................................
const proximity =
{
    id        : 'proximity',
    caption_en: 'proximity',
    metrics:
    {
        unit_type  : 'mm',
        caption_en : 'Proximity',
    }
};
//..............................................................................

//..............................................................................
const current =
{
    id             : 'current',
    unit_type      : 'milliamp',
    caption_en     : 'Current',
    description_en : 'Load current',
};
//..............................................................................

//..............................................................................
const button_control =
{
    id         : 'button_control',
    data_model : 'button_control',
};
//..............................................................................

//..............................................................................
const button_state =
{
    id         : 'button_state',
    data_model : 'button_state',
};
//..............................................................................

//..............................................................................
const button_user =
{
    caption_en: 'User Button',
    id        : 'user_button',
    controls  :
    {
        button_control,
    },
    metrics:
    {
        button_state,
    },
};
//..............................................................................

//..............................................................................
const color_controller =
{
    id         : 'color_controller',
    data_model : 'color_controller',
};
//..............................................................................

//..............................................................................
const rgb_control =
{
    caption_en: 'RGB LED',
    id        : 'rgb',
    controls  :
    {
        color_controller
    }
};
//..............................................................................

//..............................................................................
const gpio_control =
{
    id         : 'gpio_control',
    data_model : 'gpio_control',
};
//..............................................................................

//..............................................................................
const gpio_metrics =
{
    id         : 'gpio_metrics',
    data_model : 'gpio_in',
};
//..............................................................................

//..............................................................................
const gpio_control_unused   = {id : 'gpio_control_unused'  , data_model : gpio_control, controls :{mode : 'unused'  , dout : false, aout : 0, aout_enable : false                  }};
const gpio_control_input    = {id : 'gpio_control_input'   , data_model : gpio_control, controls :{mode : 'input'   , dout : false, aout : 0, aout_enable : false                  }};
const gpio_control_pulldown = {id : 'gpio_control_pulldown', data_model : gpio_control, controls :{mode : 'pulldown', dout : false, aout : 0, aout_enable : false                  }};
const gpio_control_output   = {id : 'gpio_control_output'  , data_model : gpio_control, controls :{mode : 'output'  , dout : false, aout : 0, aout_enable : true                   }};
const gpio_control_pwm      = {id : 'gpio_control_pwm'     , data_model : gpio_control, controls :{mode : 'pwm'     , dout : false, aout : 0, aout_enable : false, frequency : 1000}};
const gpio_control_dac      = {id : 'gpio_control_dac'     , data_model : gpio_control, controls :{mode : 'dac'     , dout : true , aout : 0, aout_enable : false                  }};
const gpio_control_adc      = {id : 'gpio_control_adc'     , data_model : gpio_control, controls :{mode : 'adc'     , dout : false, aout : 0, aout_enable : true                   }};
const gpio_control_pullup   = {id : 'gpio_control_pullup'  , data_model : gpio_control, controls :{mode : 'pullup'  , dout : false, aout : 0, aout_enable : false                  }};
//..............................................................................

//..............................................................................
const gpio_control_x16 =
{
    id             : 'gpio_channels',
    caption_en     : 'GPIO Control x 16',
    description_en : '16-Channel GPIO Controller',
    channel_id     : 'Ch{{x}}',
    channel_count  : 0,
    channels:
    {
       io0  : {pin_mode :  gpio_control_unused},
       io1  : {pin_mode :  gpio_control_unused},
       io2  : {pin_mode :  gpio_control_unused},
       io3  : {pin_mode :  gpio_control_unused},
       io4  : {pin_mode :  gpio_control_unused},
       io5  : {pin_mode :  gpio_control_unused},
       io6  : {pin_mode :  gpio_control_unused},
       io7  : {pin_mode :  gpio_control_unused},
       io8  : {pin_mode :  gpio_control_unused},
       io9  : {pin_mode :  gpio_control_unused},
       io10 : {pin_mode :  gpio_control_unused},
       io11 : {pin_mode :  gpio_control_unused},
       io12 : {pin_mode :  gpio_control_unused},
       io13 : {pin_mode :  gpio_control_unused},
       io14 : {pin_mode :  gpio_control_unused},
       io15 : {pin_mode :  gpio_control_unused},
    }
};
//..............................................................................

//..............................................................................
const A0  = {id : 'A0' , caption_en : 'A0/PWM0/ADC0', controls : {gpio_control_adc   }, metrics:{gpio_metrics}};
const A1  = {id : 'A1' , caption_en : 'A1/PWM1/ADC1', controls : {gpio_control_adc   }, metrics:{gpio_metrics}};
const A2  = {id : 'A2' , caption_en : 'A2/PWM2/ADC2', controls : {gpio_control_adc   }, metrics:{gpio_metrics}};
const A3  = {id : 'A3' , caption_en : 'A3/PWM3/ADC3', controls : {gpio_control_adc   }, metrics:{gpio_metrics}};
const A4  = {id : 'A4' , caption_en : 'A4/PWM4/ADC4', controls : {gpio_control_adc   }, metrics:{gpio_metrics}};
const A5  = {id : 'A5' , caption_en : 'A5/PWM5/ADC5', controls : {gpio_control_adc   }, metrics:{gpio_metrics}};
const A6  = {id : 'A6' , caption_en : 'A6/PWM6/ADC6', controls : {gpio_control_adc   }, metrics:{gpio_metrics}};
const A7  = {id : 'A7' , caption_en : 'A7/PWM7/ADC7', controls : {gpio_control_adc   }, metrics:{gpio_metrics}};
const A8  = {id : 'A8' , caption_en : 'A8/PWM8'     , controls : {gpio_control_pwm   }, metrics:{gpio_metrics}};
const A9  = {id : 'A9' , caption_en : 'A9/PWM9'     , controls : {gpio_control_pwm   }, metrics:{gpio_metrics}};
const B5  = {id : 'B5' , caption_en : 'B5/PWMX0/CS' , controls : {gpio_control_pwm   }, metrics:{gpio_metrics}};
const B6  = {id : 'B6' , caption_en : 'B6/PWMX1'    , controls : {gpio_control_pwm   }, metrics:{gpio_metrics}};
const B7  = {id : 'B7' , caption_en : 'B7/PWMX2'    , controls : {gpio_control_pwm   }, metrics:{gpio_metrics}};
const C6  = {id : 'C6' , caption_en : 'C6/PWM11'    , controls : {gpio_control_pwm   }, metrics:{gpio_metrics}};
const C1  = {id : 'C1' , caption_en : 'C1/PWM10'    , controls : {gpio_control_pwm   }, metrics:{gpio_metrics}};
const C2  = {id : 'C2' , caption_en : 'C2/RTS'      , controls : {gpio_control_output}, metrics:{gpio_metrics}};
const C3  = {id : 'C3' , caption_en : 'C3/TX'       , controls : {gpio_control_output}, metrics:{gpio_metrics}};
const C4  = {id : 'C4' , caption_en : 'C4/CTS'      , controls : {gpio_control_output}, metrics:{gpio_metrics}};
const C5  = {id : 'C5' , caption_en : 'C5/RX'       , controls : {gpio_control_input }, metrics:{gpio_metrics}};
const C7  = {id : 'C7' , caption_en : 'C7/PWM12'    , controls : {gpio_control_adc   }, metrics:{gpio_metrics}};
const C8  = {id : 'C8' , caption_en : 'C8/PWM13'    , controls : {gpio_control_adc   }, metrics:{gpio_metrics}};
const C9  = {id : 'C9' , caption_en : 'C9/PWM14'    , controls : {gpio_control_adc   }, metrics:{gpio_metrics}};
const C10 = {id : 'C10', caption_en : 'C10/PWM15'   , controls : {gpio_control_pwm   }, metrics:{gpio_metrics}};
const C11 = {id : 'C11', caption_en : 'C11/PWM16'   , controls : {gpio_control_pwm   }, metrics:{gpio_metrics}};
const C12 = {id : 'C12', caption_en : 'C12/PWM17'   , controls : {gpio_control_pwm   }, metrics:{gpio_metrics}};
const C13 = {id : 'C13', caption_en : 'C13/PWM18'   , controls : {gpio_control_pwm   }, metrics:{gpio_metrics}};
//..............................................................................

//..............................................................................
const accelerometer_3axis =
{
    id         : 'accelerometer_3axis',
    data_model : 'accelerometer_3axis',
};
//..............................................................................

//..............................................................................
const motion_3axis =
{
    id         : "motion",
    caption_en : "Motion Sensor",
    metrics:
    {
        accelerometer_3axis
    }
};
//..............................................................................

//..............................................................................
const trigger_temp_low_warning =
{
    id         : 'temp_low_warning',
    caption_en : 'Low Temperature Warning',
    level      : '1',
    for        : 1,
    lte        : 5,
    generate   : 'temperature_alarm',
    when       : 'environment.celsius'
};
//..............................................................................

//..............................................................................
const trigger_temp_low_critical =
{
    id         : 'temp_low_critical',
    caption_en : 'Critical Low Temperature Warning',
    level      : '2',
    for        : 1,
    lte        : 0,
    generate   : 'temperature_alarm',
    when       : 'environment.celsius'
};
//..............................................................................

//..............................................................................
const trigger_temp_high_warning =
{
    id         : 'temp_high_warning',
    caption_en : 'High Temperature Warning',
    level      : '1',
    for        : 1,
    gte        : 70,
    generate   : 'temperature_alarm',
    when       : 'environment.celsius'
};
//..............................................................................

//..............................................................................
const trigger_temp_high_critical =
{
    id         : 'temp_high_critical',
    caption_en : 'Critical High Temperature Warning',
    level      : '2',
    for        : 1,
    gte        : 80,
    generate   : 'temperature_alarm',
    when       : 'environment.celsius'
};
//..............................................................................

//..............................................................................
const environment_tl =
    {
        id        : "motion",
        caption_en: "Motion Sensor",
        metrics:
            {
                environment_temp_light
            },
        triggers :
            {
                trigger_temp_low_critical,
                trigger_temp_low_warning,
                trigger_temp_high_critical,
                trigger_temp_high_warning,
            }
    };
//..............................................................................

//..............................................................................
const gyro_3axis =
{
    caption_en : '3 Axis Gyro',
    data_model : 'agc_9axis',
    metrics:
    {
        heading:{id : 'heading'},
        pitch  :{id : 'pitch'  },
        roll   :{id : 'roll'   },
        right  :{id : 'right'  },
    }
};
//..............................................................................

//..............................................................................
const compass_3axis =
{
    caption_en : '3 Axis Compass',
    metrics:
    {
        degree_x:{id : 'degree_x', default : '0', unit_type  : 'degree', caption_en : 'Orientation-X'},
        degree_y:{id : 'degree_y', default : '0', unit_type  : 'degree', caption_en : 'Orientation-Y'},
        degree_z:{id : 'degree_z', default : '0', unit_type  : 'degree', caption_en : 'Orientation-z'}
    }
};
//..............................................................................

//..............................................................................
const motion_detector_9axis =
{
    id          : 'agc_9axis',
    caption_en  : '9-Axis Motion',
    data_model  : 'agc_9axis',
    metrics:
    {
        accelerometer_3axis,
        gyro_3axis,
        compass_3axis
    },
};
    
//..............................................................................

//..............................................................................
const level_voc =
{
    unit_type       : 'ppm',
    caption_en      : 'VOC Level',
    description_en  : 'VOC ("Volatile Organic Compound") level (ppm)',
};
//..............................................................................

//..............................................................................
const air_quality_co =
    {
        id         : 'air_quality_co',
        data_model : 'air_quality_co_pm25',
        metrics:
            {
                co : {id : 'co'}
            }
    };
//..............................................................................

//..............................................................................
const air_quality_pm25 =
{
    id         : 'air_quality_pm25',
    data_model : 'air_quality_co_pm25',
    metrics:
    {
        pm25 : {id : 'pm25'}
    }
};
//..............................................................................

//..............................................................................
const gesture_sense =
{
    id         : 'gesture_sense',
    caption_en : 'Gesture Sensing',
    picklist   : 'event_type_touch',
    metrics    :
    {
        unit_type  : 'gesture',
        caption_en : 'Gesture sensing',
        metrics:
        {
            touch_swipe_left  :{id : 'touch_swipe_left' },
            touch_swipe_right :{id : 'touch_swipe_right'},
            touch_swipe_up    :{id : 'touch_swipe_up'   },
            touch_swipe_down  :{id : 'touch_swipe_down' },
        }
    }
};
//..............................................................................

//..............................................................................
const battery_status =
{
    id         : 'battery_level',
    data_model : 'battery_level'
};
//..............................................................................

//..............................................................................
const pir_sensor =
{
    id         : 'pir',
    data_model : 'pir',
};
//..............................................................................

//..............................................................................
const motion_9axis =
{
    id         : 'agc_9axis',
    caption_en : '9-Axis Motion',
    metrics    :
    {
        motion_detector_9axis
    }
};
//..............................................................................

//..............................................................................
const co_level =
{
    id         : 'co_level',
    caption_en : 'CO Level',
    metrics:
    {
        air_quality_co,
    },
};
//..............................................................................

//..............................................................................
const voc_level =
{
    id         : 'voc_level',
    caption_en : 'VOC Level',
    metrics:
    {
        level_voc,
    },
};
//..............................................................................

//..............................................................................
const pressure_barometric =
{
    id         : 'pressure_barometric',
    data_model : 'environment_tphl',
    metrics:
    {
        pressure : {id: 'hpa'},
    },
};
//..............................................................................

//..............................................................................
const humidity =
{
    id         : 'humidity',
    data_model : 'environment_tphl',
    metrics:
    {
        humidity : {id : 'humidity'}
    },
};
//..............................................................................

//..............................................................................
const light_level =
{
    id         : 'light_level',
    data_model : 'environment_tphl',
    metrics:
    {
        light_level : {id : 'light_level'}
    },
};
//..............................................................................

//..............................................................................
const lcd =
{
    id         : 'lcd',
    caption_en : 'LCD Screen',
    controls:
    {
        id         : 'lcd',
        data_model : 'color_controller',
    },
};
//..............................................................................

//..............................................................................
const device_vt =
{
    caption_en : 'Device',
    metrics:
    {
        temperature_internal_enclosure,
        voltage_input,
    }
};
//..............................................................................

//..............................................................................
const light_controller =
{
    id         : 'light_controller',
    caption_en : 'Light-Control x 16',
    controls:
    {
        level_control_x16,
    },
    metrics:
    {
        temperature_psu,
        current
    }
};
//..............................................................................

//..............................................................................
const rfid_uid =
{
    id         : 'rfid_uid',
    data_model : 'rfid_uid'
};
//..............................................................................

//..............................................................................
const rfid_activity =
{
    id         : 'rfid_activity',
    data_model : 'rfid_activity',
    metrics:
    {
        child_model : rfid_uid,
    }
};
//..............................................................................

//..............................................................................
const rfid_control =
{
    id         : 'rfid_control',
    data_model : 'rfid_control',
};
//..............................................................................

//..............................................................................
const rfid =
    {
        id : 'rfid',
        caption_en:'RFID',
        controls :
        {
            rfid_control
        },
        metrics:
        {
            rfid_activity
        }
    };
//..............................................................................

//..............................................................................

const deviceEndpoints =
[
    A0,
    A1,
    A2,
    A3,
    A4,
    A5,
    A6,
    A7,
    A8,
    A9,
    B5,
    B6,
    B7,
    C6,
    C1,
    C2,
    C3,
    C4,
    C5,
    C7,
    C8,
    C9,
    C10,
    C11,
    C12,
    C13,
    gpio_control_x16,
    temperature_ambient,
    pressure_barometric,
    battery_status,
    environment_tl,
    gesture_sense,
    air_quality_co,
    air_quality_pm25,
    voc_level,
    light_level,
    motion_3axis,
    motion_9axis,
    pir_sensor,
    proximity,
    humidity,
    rgb_control,
    voltage_input,
    voltage_output,
    device_vt,
    light_controller,
    button_user,
];
//..............................................................................

module.exports = deviceEndpoints;
