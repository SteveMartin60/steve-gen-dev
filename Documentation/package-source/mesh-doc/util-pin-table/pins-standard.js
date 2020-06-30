//..............................................................................

const pinTypes =
{
    analog    : {captionEn :'Analog'     , captionZh: '模拟'},
    gpioM     : {captionEn :'GPIO'       , captionZh: 'GPIO'},
    gpioR     : {captionEn :'Remote GPIO', captionZh: '远程 GPIO'},
    i_o       : {captionEn :'I/O'        , captionZh: 'I/O'},
    input     : {captionEn :'Input'      , captionZh: '输入'},
    output    : {captionEn :'Output'     , captionZh: '输出'},
    power     : {captionEn: 'Power'      , captionZh: '功率'},
    passive   : {captionEn :'Passive'    , captionZh: '被动式'},
    reserved  : {captionEn :'Reserved'   , captionZh: '预留管脚'},
};

const gpioRemoteDescriptionEn = 'GPIO (See Remote GPIO Pin Functions)';
const gpioRemoteDescriptionZh = 'GPIO (See Remote GPIO Pin Functions)';
const gpioRemotePinType       = 'I/O';
//..............................................................................
const standardDeviceSheetPins =
{
     0:  { id: "1V2"             , pinType: pinTypes.reserved, descriptionEn: "Reserved"                                    , descriptionZh: "保留管脚"},
     1:  { id: "1V8"             , pinType: pinTypes.reserved, descriptionEn: "Reserved"                                    , descriptionZh: "保留管脚"},
     2:  { id: "3V3"             , pinType: pinTypes.power   , descriptionEn: "3.3V Power"                                  , descriptionZh: "3.3V功率"},
     3:  { id: "3V3_ALW"         , pinType: pinTypes.power   , descriptionEn: "3.3V Always On Power Output"                 , descriptionZh: "3.3V永远在功率输出"},
     4:  { id: "3V3_IN"          , pinType: pinTypes.power   , descriptionEn: "3.3V Power Input"                            , descriptionZh: "3.3V功率输入"},
     5:  { id: "3V3_OUT"         , pinType: pinTypes.power   , descriptionEn: "3.3V Power Output"                           , descriptionZh: "3.3V功率输出"},
     6:  { id: "3V3_TO_5V0_N"    , pinType: pinTypes.input   , descriptionEn: "Switch 3V3 Output to 5V0"                    , descriptionZh: ""},
     7:  { id: "5V0"             , pinType: pinTypes.power   , descriptionEn: "5.0V Power Input"                            , descriptionZh: "5.0V功率输入"},
     8:  { id: "5V0A_IN"         , pinType: pinTypes.power   , descriptionEn: "5V Power Input"                              , descriptionZh: "5V功率输入"},
     9:  { id: "5V0A_OUT"        , pinType: pinTypes.power   , descriptionEn: "5V Power Output"                             , descriptionZh: "5V功率输出"},
    10:  { id: "5V0B_IN"         , pinType: pinTypes.power   , descriptionEn: "5V Power Input"                              , descriptionZh: "5V功率输入"},
    11:  { id: "5V0B_OUT"        , pinType: pinTypes.power   , descriptionEn: "5V Power Output"                             , descriptionZh: "5V功率输出"},
    12:  { id: "5V0_IN"          , pinType: pinTypes.power   , descriptionEn: "5.0V Power Supply Input"                     , descriptionZh: "5.0V功率输入"},
    13:  { id: "5V0_OUT"         , pinType: pinTypes.power   , descriptionEn: "5.0V Power Output"                           , descriptionZh: "5.0V功率输出"},
    14:  { id: "5V0_TO_3V3"      , pinType: pinTypes.input   , descriptionEn: "Switch 5V0 Output to 3V3"                    , descriptionZh: ""},
    15:  { id: "5VIN_A"          , pinType: pinTypes.power   , descriptionEn: "5V Power Supply Input for Downstream Port 1" , descriptionZh: "下游端口1功率输入"},
    16:  { id: "5VIN_B"          , pinType: pinTypes.power   , descriptionEn: "5V Power Supply Input for Downstream Port 2" , descriptionZh: "下游端口2功率输入"},
    17:  { id: "5VIN_C"          , pinType: pinTypes.power   , descriptionEn: "5V Power Supply Input for Downstream Port 3" , descriptionZh: "下游端口3功率输入"},
    18:  { id: "5VIN_D"          , pinType: pinTypes.power   , descriptionEn: "5V Power Supply Input for Downstream Port 4" , descriptionZh: "下游端口4功率输入"},
    19:  { id: "5VOUT_A"         , pinType: pinTypes.power   , descriptionEn: "5V Power Supply Output for Downstream Port 1", descriptionZh: "下游端口1功率输出"},
    20:  { id: "5VOUT_B"         , pinType: pinTypes.power   , descriptionEn: "5V Power Supply Output for Downstream Port 2", descriptionZh: "下游端口2功率输出"},
    21:  { id: "5VOUT_C"         , pinType: pinTypes.power   , descriptionEn: "5V Power Supply Output for Downstream Port 3", descriptionZh: "下游端口3功率输出"},
    22:  { id: "5VOUT_D"         , pinType: pinTypes.power   , descriptionEn: "5V Power Supply Output for Downstream Port 4", descriptionZh: "下游端口4功率输出"},
    23:  { id: "5V_IN"           , pinType: pinTypes.power   , descriptionEn: "5.0V Power Input"                            , descriptionZh: "5.0V功率输入"},
    24:  { id: "9V0"             , pinType: pinTypes.power   , descriptionEn: "9V Power Output"                             , descriptionZh: "9V 功率输出"},
    25:  { id: "9V0_OUT"         , pinType: pinTypes.power   , descriptionEn: "9.0V Power Output"                           , descriptionZh: "9.0V功率输出"},
    26:  { id: "AGND"            , pinType: pinTypes.power   , descriptionEn: "Analog Ground"                               , descriptionZh: "模拟接地"},
    27:  { id: "ANT"             , pinType: pinTypes.analog  , descriptionEn: "Antenna"                                     , descriptionZh: "天线"},
    28:  { id: "ANT_N"           , pinType: pinTypes.analog  , descriptionEn: "Antenna A"                                   , descriptionZh: "天线A"},
    29:  { id: "ANT_P"           , pinType: pinTypes.analog  , descriptionEn: "Antenna B"                                   , descriptionZh: "天线B"},
    30:  { id: "CHRG_N"          , pinType: pinTypes.output  , descriptionEn: "Charging Indicator"                          , descriptionZh: "充电指示器"},
    31:  { id: "COMM_RXD"        , pinType: pinTypes.input   , descriptionEn: "Debug Communications (Receive)"              , descriptionZh: "调试通信（接收）"},
    32:  { id: "COMM_TXD"        , pinType: pinTypes.output  , descriptionEn: "Debug Communications (Transmit)"             , descriptionZh: "调试通信（传输）"},
    33:  { id: "CS_N"            , pinType: pinTypes.input   , descriptionEn: "Chip Select"                                 , descriptionZh: "片选"},
    34:  { id: "D0_N"            , pinType: pinTypes.i_o     , descriptionEn: "Downstream Port 0 Data (-ve)"                , descriptionZh: "下游端口0数据（-ve）"},
    35:  { id: "D0_P"            , pinType: pinTypes.i_o     , descriptionEn: "Downstream Port 0 Data (+ve)"                , descriptionZh: "下游端口0数据（+ve）"},
    36:  { id: "D1_N"            , pinType: pinTypes.i_o     , descriptionEn: "Downstream Port 1 Data (-ve)"                , descriptionZh: "下游端口1数据（-ve）"},
    37:  { id: "D1_P"            , pinType: pinTypes.i_o     , descriptionEn: "Downstream Port 1 Data (+ve)"                , descriptionZh: "下游端口1数据（+ve）"},
    38:  { id: "D2_N"            , pinType: pinTypes.i_o     , descriptionEn: "Downstream Port 2 Data (-ve)"                , descriptionZh: "下游端口2数据（-ve）"},
    39:  { id: "D2_P"            , pinType: pinTypes.i_o     , descriptionEn: "Downstream Port 2 Data (+ve)"                , descriptionZh: "下游端口2数据（+ve）"},
    40:  { id: "D3_N"            , pinType: pinTypes.i_o     , descriptionEn: "Downstream Port 3 Data (-ve)"                , descriptionZh: "下游端口3数据（-ve）"},
    41:  { id: "D3_P"            , pinType: pinTypes.i_o     , descriptionEn: "Downstream Port 3 Data (+ve)"                , descriptionZh: "下游端口3数据（+ve）"},
    42:  { id: "DET_3V3_IN"      , pinType: pinTypes.output  , descriptionEn: "3.3V Power Input Detection"                  , descriptionZh: "3.3V功率输入示器LED"},
    43:  { id: "DET_5V0_IN"      , pinType: pinTypes.output  , descriptionEn: "5.0V Power Input Detection"                  , descriptionZh: "5.0V功率输入示器LED"},
    44:  { id: "D_N"             , pinType: pinTypes.i_o     , descriptionEn: "USB 2.0 Data (-ve)"                          , descriptionZh: "USB 2.0数据(-ve)"},
    45:  { id: "D_P"             , pinType: pinTypes.i_o     , descriptionEn: "USB 2.0 Data (+ve)"                          , descriptionZh: "USB 2.0数据(+ve)"},
    46:  { id: "EN0"             , pinType: pinTypes.input   , descriptionEn: "Enable Output 0"                             , descriptionZh: "使能输出0"},
    47:  { id: "EN1"             , pinType: pinTypes.input   , descriptionEn: "Enable Output 1"                             , descriptionZh: "使能输出1"},
    48:  { id: "EN_1V2"          , pinType: pinTypes.reserved, descriptionEn: "Reserved"                                    , descriptionZh: "保留管脚"},
    49:  { id: "EN_3V3"          , pinType: pinTypes.input   , descriptionEn: "3.3V Output Enable"                          , descriptionZh: "3.3V输出使能"},
    50:  { id: "EN_3V3_OUT"      , pinType: pinTypes.input   , descriptionEn: "3.3V Output Enable"                          , descriptionZh: "3.3V输出使能"},
    51:  { id: "EN_5V0"          , pinType: pinTypes.input   , descriptionEn: "5.0V Output Enable"                          , descriptionZh: "5.0V输出使能"},
    52:  { id: "EN_5V0_OUT"      , pinType: pinTypes.input   , descriptionEn: "5.0V Output Enable"                          , descriptionZh: "5.0V输出使能"},
    53:  { id: "EN_CHARGE"       , pinType: pinTypes.input   , descriptionEn: "Enable Charging"                             , descriptionZh: "充电使能"},
    54:  { id: "EN_CHG"          , pinType: pinTypes.input   , descriptionEn: "Charging Enable"                             , descriptionZh: "充电使能"},
    55:  { id: "EN_FAST_CHARGE"  , pinType: pinTypes.input   , descriptionEn: "Enable Fast Charging"                        , descriptionZh: ""},
    56:  { id: "EN_N"            , pinType: pinTypes.input   , descriptionEn: "Enable"                                      , descriptionZh: "使能"},
    57:  { id: "FB_3V3_OUT"      , pinType: pinTypes.input   , descriptionEn: "3.3V Adjust"                                 , descriptionZh: "3.3V电压调整"},
    58:  { id: "FB_5V0_OUT"      , pinType: pinTypes.input   , descriptionEn: "5.0V Adjust"                                 , descriptionZh: "5.0V电压调整"},
    59:  { id: "FB_9V0_OUT"      , pinType: pinTypes.input   , descriptionEn: "9.0V Adjust"                                 , descriptionZh: "9.0V电压调整"},
    60:  { id: "GND"             , pinType: pinTypes.power   , descriptionEn: "Ground"                                      , descriptionZh: "接地"},
    61:  { id: "GOOD_3V3_OUT_N"  , pinType: pinTypes.output  , descriptionEn: "3V3 Output Good"                             , descriptionZh: ""},
    62:  { id: "GOOD_5V0_OUT_N"  , pinType: pinTypes.output  , descriptionEn: "5V0 Output Good"                             , descriptionZh: ""},
    63:  { id: "LED_5V0_IN"      , pinType: pinTypes.output  , descriptionEn: "5V0 Input Indicator"                         , descriptionZh: ""},
    64:  { id: "LED_CHARGING_N"  , pinType: pinTypes.output  , descriptionEn: "Charging Indicator"                          , descriptionZh: "充电指示器"},
    65:  { id: "OC_N"            , pinType: pinTypes.output  , descriptionEn: "Over Current Detection"                      , descriptionZh: "过电流检测"},
    66:  { id: "PGND"            , pinType: pinTypes.power   , descriptionEn: "Transformer Ground"                          , descriptionZh: "变压器接地"},
    67:  { id: "PIR_EN_0"        , pinType: pinTypes.input   , descriptionEn: "Sensor 0 Enable"                             , descriptionZh: "傳感器使能接地"},
    68:  { id: "PIR_EN_1"        , pinType: pinTypes.input   , descriptionEn: "Sensor 1 Enable"                             , descriptionZh: "傳感器使能接地"},
    69:  { id: "PWREN_N"         , pinType: pinTypes.output  , descriptionEn: "Power Enable"                                , descriptionZh: "功率使能"},
    70:  { id: "RST_N"           , pinType: pinTypes.input   , descriptionEn: "Reset"                                       , descriptionZh: "复位"},
    71:  { id: "RSVD"            , pinType: pinTypes.reserved, descriptionEn: "Reserved"                                    , descriptionZh: "保留管脚"},
    72:  { id: "SCL"             , pinType: pinTypes.i_o     , descriptionEn: "SCL"                                         , descriptionZh: "SCL"},
    73:  { id: "SCLK"            , pinType: pinTypes.input   , descriptionEn: "SCLK"                                        , descriptionZh: "SCLK"},
    74:  { id: "SDA"             , pinType: pinTypes.i_o     , descriptionEn: "SDA"                                         , descriptionZh: "SDA"},
    75:  { id: "SWCLK"           , pinType: pinTypes.input   , descriptionEn: "Debug Clock"                                 , descriptionZh: "调试钟"},
    76:  { id: "SWDIO"           , pinType: pinTypes.i_o     , descriptionEn: "Debug I/O"                                   , descriptionZh: "调试I/O"},
    77:  { id: "USB0_N"          , pinType: pinTypes.i_o     , descriptionEn: "Port 0 USB Data (-ve)"                       , descriptionZh: "端口0数据（+ve）"},
    78:  { id: "USB0_P"          , pinType: pinTypes.i_o     , descriptionEn: "Port 0 USB Data (-ve)"                       , descriptionZh: "端口0数据（-ve）"},
    79:  { id: "USB1_N"          , pinType: pinTypes.i_o     , descriptionEn: "Port 1 USB Data (-ve)"                       , descriptionZh: "端口1数据（+ve）"},
    80:  { id: "USB1_P"          , pinType: pinTypes.i_o     , descriptionEn: "Port 1 USB Data (-ve)"                       , descriptionZh: "端口1数据（-ve）"},
    81:  { id: "USB2_N"          , pinType: pinTypes.i_o     , descriptionEn: "Port 2 USB Data (-ve)"                       , descriptionZh: "端口2数据（+ve）"},
    82:  { id: "USB2_P"          , pinType: pinTypes.i_o     , descriptionEn: "Port 2 USB Data (-ve)"                       , descriptionZh: "端口2数据（-ve）"},
    83:  { id: "USB3_N"          , pinType: pinTypes.i_o     , descriptionEn: "Port 3 USB Data (-ve)"                       , descriptionZh: "端口3数据（+ve）"},
    84:  { id: "USB3_P"          , pinType: pinTypes.i_o     , descriptionEn: "Port 3 USB Data (-ve)"                       , descriptionZh: "端口3数据（-ve）"},
    85:  { id: "USB_N"           , pinType: pinTypes.i_o     , descriptionEn: "USB Data (-ve)"                              , descriptionZh: "USB数据(-ve)"},
    86:  { id: "USB_P"           , pinType: pinTypes.i_o     , descriptionEn: "USB Data (-ve)"                              , descriptionZh: "USB数据(-ve)"},
    87:  { id: "VA_IN"           , pinType: pinTypes.power   , descriptionEn: "Power Input (A)"                             , descriptionZh: "功率输入（A）"},
    88:  { id: "VBAT"            , pinType: pinTypes.power   , descriptionEn: "Battery Power Input"                         , descriptionZh: "电池功率输入"},
    89:  { id: "VDC"             , pinType: pinTypes.power   , descriptionEn: "Power Input"                                 , descriptionZh: "功率输入"},
    90:  { id: "VB_IN"           , pinType: pinTypes.power   , descriptionEn: "Power Input (B)"                             , descriptionZh: "功率输入（B）"},
    91:  { id: "WAKE_IN"         , pinType: pinTypes.input   , descriptionEn: "Wakeup Input"                                , descriptionZh: "唤醒输入"},
    92:  { id: "WAKE_OUT"        , pinType: pinTypes.output  , descriptionEn: "Wakeup Output"                               , descriptionZh: "唤醒输出"},
};
//..............................................................................

//..............................................................................
function isStandardRemoteGPIO(netName)
{
    try
    {
        return netName.indexOf('/PWM') > -1;
    }
    catch (error)
    {
        console.log('Houston... we have a problem...');

        return 'No Net Name';
    }
}
//..............................................................................

//..............................................................................
function getStandardRemoteGpioFields(pin)
{
    pin.pinType       = gpioRemotePinType;
    pin.descriptionEn = gpioRemoteDescriptionEn;
    pin.descriptionZh = gpioRemoteDescriptionZh;

    return pin;
}
//..............................................................................

//..............................................................................
function getStandardDevicePinFields(pin)
{
    var standardPin = {};

    if (isStandardRemoteGPIO(pin.id))
    {
        pin = getStandardRemoteGpioFields(pin);

        return pin
    }

    for (var i = 1; i < Object.keys(standardDeviceSheetPins).length; i++)
    {
        standardPin = standardDeviceSheetPins[i];

        if (pin.id === standardPin.id)
        {
            pin.pinType       = standardPin.pinType;
            pin.descriptionEn = standardPin.descriptionEn;
            pin.descriptionZh = standardPin.descriptionZh;

            return pin;
        }
    }

    return pin;
}
//..............................................................................

//..............................................................................
const exported =
{
    getStandardDevicePinFields,
};

module.exports = exported;


