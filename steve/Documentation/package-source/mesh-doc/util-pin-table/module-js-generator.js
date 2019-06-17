//..............................................................................

const
{
    docUtils,
} = require('mesh-doc-utils');

const
{
    getSpacerString,
    isInArray,
    substringCount,
    writeFileToDisk,
    replaceAll,
} = docUtils;

var specialFunctionPinIDs = [];
var powerSignalPinIDs     = [];

const jsFormatStops =
{
    1: 29,
    2: 71,
    3: 100,
    4: 137,
    5: 207,
    6: 232,
    7: 268,
};
//..............................................................................

//..............................................................................
const pinElectricalTypes =
[
    { id: 'nc'             , short_en:'No-Connect', default_name:'NC' , caption_en:'No-Connect'             , description_en:'mechanical only, no electrical function.'                                                                                               , caption_zh:'无连接', description_zh:'仅限于结构，无电路功能'},
    { id: 'none'           , short_en:'None'                          , caption_en:'None'                   , description_en:'No information is available about this pin.'                                                                                            , caption_zh:'无', description_zh:'无关于此引脚的信息'},
    { id: 'reserved'       , short_en:'Reserved'                      , caption_en:'Reserved'               , description_en:'Nothing should be connected to this pin'                                                                                                , caption_zh:'预留', description_zh:'此引脚不应连接'},
    { id: 'ground'         , short_en:'GND'       , default_name:'GND', caption_en:'GND'                    , description_en:'Common electrical reference ground for power and signals.'                                                                              , caption_zh:'地', description_zh:'电源和信号的共同电路参考地'},
    { id: 'gpio'           , short_en:'GPIO'                          , caption_en:'GPIO'                   , description_en:'General purpose IO, configured to some specific pin-type by software.'                                                                  , caption_zh:'通用输入输出', description_zh:'通用输入输出，软件配置为不同引脚类型'},
    { id: 'digital_in'     , short_en:'Digital Inp'                   , caption_en:'Digital Input'          , description_en:'Logic input - recognizes the input signal as logic high or low based on some voltage threshold.'                                        , caption_zh:'数字输入', description_zh:'逻辑输入-根据门限值将输入信号识别为逻辑高或低电平'},
    { id: 'digital_out'    , short_en:'Digital Out'                   , caption_en:'Digital Output'         , description_en:'Generates a logical output that can drive high or low - normally low is zero volts and high is 3.3 volts.'                              , caption_zh:'数字输出', description_zh:'产生输出的逻辑高或低电平-通常低为0而高为3.3V'},
    { id: 'digital_io'     , short_en:'I/O'                           , caption_en:'Digital I/O'            , description_en:'Bidirectional digital signal, can act as an input or an output.'                                                                        , caption_zh:'数字输入输出', description_zh:'双向数字信号，可以作为输入和输出'},
    { id: 'analog_in'      , short_en:'Analog Inp'                    , caption_en:'Analog Input'           , description_en:'Voltage or current sense pin.'                                                                                                          , caption_zh:'模拟输入', description_zh:'电压或电流侦测管脚'},
    { id: 'analog_out'     , short_en:'Analog Out'                    , caption_en:'Analog Output'          , description_en:'Voltage or current output pin.'                                                                                                         , caption_zh:'模拟输入', description_zh:'电压或电流输出管脚'},
    { id: 'pullup'         , short_en:'Pullup'                        , caption_en:'Pullup'                 , description_en:'Digital input with an internal pullup. If the pin is not driven it will appear as logic high.'                                          , caption_zh:'上拉', description_zh:'带上拉的数字输入，如果管脚无信号驱动，缺省会为逻辑高'},
    { id: 'pulldown'       , short_en:'Pulldown'                      , caption_en:'Pulldown'               , description_en:'Digital input with an internal pulldown. If the pin is not driven it will appear as logic low.'                                         , caption_zh:'下拉', description_zh:'带下拉的数字输入，如果管脚无信号驱动，缺省会为逻辑低'},
    { id: 'pwm_output'     , short_en:'PWM'                           , caption_en:'PWM'                    , description_en:'Special type of digital output where the mark-space ratio of the output signal infers some value.'                                      , caption_zh:'脉宽调制', description_zh:'特殊的数字输出，信号占空比隐含输出数值'},
    { id: 'passive'        , short_en:'Passive'                       , caption_en:'Passive'                , description_en:'Analog signal with no specific logical direction. Normally an internal connection to passive components such as resistors, capacitors.' , caption_zh:'被动', description_zh:'无逻辑方向的模拟信号，通常为内部被动元器件连接'},
    { id: 'power_consumer' , short_en:'Power-In'                      , caption_en:'Power-Consumer'         , description_en:'Allows the component to receive power from some power provider.'                                                                        , caption_zh:'功率消耗者', description_zh:'允许元器件从其它功率提供者接收功率'},
    { id: 'power_provider' , short_en:'Power-Out'                     , caption_en:'Power-Provider'         , description_en:'Provides power for others to consume.'                                                                                                  , caption_zh:'功率提供者', description_zh:'为其它提供功率'},
    { id: 'tristate_out'   , short_en:'3-State'                       , caption_en:'Three-State'            , description_en:'Digital output that can be set to a high-impedance (disconnected) state.'                                                               , caption_zh:'三态', description_zh:'数字输出，可以被设为高阻（不连接）状态'},
    { id: 'oc_out'         , short_en:'Open-Collector'                , caption_en:'Open-Collector Output'  , description_en:'Digital output pin that can be driven low, but floats otherwise.'                                                                       , caption_zh:'集电极开路输出', description_zh:'数字输出，可以被拉低，否则浮动'},
    { id: 'oe_out'         , short_en:'Open-Emitter'                  , caption_en:'Open-Emitter Output'    , description_en:'Digital output pin that can be driven high, but floats otherwise.'                                                                      , caption_zh:'发射机开路输出', description_zh:'数字输出，可以被拉高，否则浮动'},
    { id: 'od_out'         , short_en:'Open-Drain'                    , caption_en:'Open-Drain Output'      , description_en:'Digital output pin that can be driven low, but floats otherwise.'                                                                       , caption_zh:'开漏输出', description_zh:'数字输出，可以被拉低，否则浮动'},
    { id: 'os_out'         , short_en:'Open-Source'                   , caption_en:'Open-Source Output'     , description_en:'Digital output pin that can be driven high, but floats otherwise.'                                                                      , caption_zh:'开源输出', description_zh:'数字输出，可以被拉高，否则浮动'},
    { id: 'usb_data'       , short_en:'USB Data'                      , caption_en:'USB Data'               , description_en:'USB data.'                                                                                                                              , caption_zh:'', description_zh:''},
];
//..............................................................................

//..............................................................................
const powerSignalPinTypes =
[
    { id: '3V3_OUT'     , default_name: '3V3_OUT'     , electrical_type: 'provider_3V3'  , caption_en: '3V3 Provider'       , description_en: 'Provides energy for connected 3V3 power consumers.', caption_zh:'3V3提供者', description_zh: '为3V3负载提供能量'},
    { id: '5V_OUT'      , default_name: '5V_OUT'      , electrical_type: 'provider_5V'   , caption_en: '5V Provider'        , description_en: 'Provides energy for connected 5V power consumers.' , caption_zh:'5V提供者', description_zh: '为5V负载提供能量'},

    { id: '5V_IN'       , default_name: '5V_IN'       , electrical_type: 'power_consumer', caption_en: '5V Power-In'        , description_en: '5V Power Input'                                    , caption_zh:'', description_zh:''},
    { id: '3V3_IN'      , default_name: '3V3_IN'      , electrical_type: 'power_consumer', caption_en: '3V3 Provider'       , description_en: 'V Power Input'                                    , caption_zh:'', description_zh:''},
    { id: '5V0_IN'      , default_name: '5V0_IN'      , electrical_type: 'power_consumer', caption_en: '5V Power-In'        , description_en: '5V Power Input'                                    , caption_zh:'', description_zh:''},
    { id: 'VA_IN'       , default_name: 'VA_IN'       , electrical_type: 'power_consumer', caption_en: 'VA Power-In'        , description_en: 'Power Input A, 5-18V'                              , caption_zh:'', description_zh:''},
    { id: 'VB_IN'       , default_name: 'VB_IN'       , electrical_type: 'power_consumer', caption_en: 'VB Power-In'        , description_en: 'Power Input B, 5-18V'                              , caption_zh:'', description_zh:''},
    { id: 'EN_3V3_OUT'  , default_name: 'EN_3V3_OUT'  , electrical_type: 'digital_in'    , caption_en: 'Enable 3V3'         , description_en: 'Enable 3V3 output'                                 , caption_zh:'', description_zh:''},
    { id: 'EN_5V_OUT'   , default_name: 'EN_5V_OUT'   , electrical_type: 'digital_in'    , caption_en: 'Enable 5V'          , description_en: 'Enable 5V output'                                  , caption_zh:'', description_zh:''},
    { id: 'LED_3V3_OUT' , default_name: 'LED_3V3_OUT' , electrical_type: 'passive'       , caption_en: 'LED 3V3 Out'        , description_en: 'LED driver for enable 3V3 output'                  , caption_zh:'', description_zh:''},
    { id: 'LED_5V_OUT'  , default_name: 'LED_5V_OUT'  , electrical_type: 'passive'       , caption_en: 'LED 5V Out'         , description_en: 'LED driver for enable 5V output'                   , caption_zh:'', description_zh:''},
    { id: 'DET_VA_IN'   , default_name: 'DET_VA_IN'   , electrical_type: 'digital_out'   , caption_en: 'VA Input Detect'    , description_en: 'VA power input detection'                          , caption_zh:'', description_zh:''},
    { id: 'DET_VB_IN'   , default_name: 'DET_VB_IN'   , electrical_type: 'digital_out'   , caption_en: 'VB Input Detect'    , description_en: 'VB power input detection'                          , caption_zh:'', description_zh:''},
    { id: 'DET_5V_IN'   , default_name: 'DET_5V_IN'   , electrical_type: 'digital_out'   , caption_en: '5V Input Detect'    , description_en: '5V power input detection'                          , caption_zh:'', description_zh:''},
    { id: 'LED_VA_IN'   , default_name: 'LED_VA_IN'   , electrical_type: 'digital_out'   , caption_en: 'LED VA Input Detect', description_en: 'LED driver for VA power input detection'           , caption_zh:'', description_zh:''},
    { id: 'LED_VB_IN'   , default_name: 'LED_VB_IN'   , electrical_type: 'digital_out'   , caption_en: 'LED VB Input Detect', description_en: 'LED driver for VB power input detection'           , caption_zh:'', description_zh:''},
    { id: 'LED_5V_IN'   , default_name: 'LED_5V_IN'   , electrical_type: 'digital_out'   , caption_en: 'LED 5V Input Detect', description_en: 'LED driver for 5V power input detection'           , caption_zh:'', description_zh:''},
    { id: 'OK_3V3_OUT_N', default_name: 'OK_3V3_OUT_N', electrical_type: 'digital_out'   , caption_en: 'Good 3V3 Out'       , description_en: 'Indicates good 3V3 output'                         , caption_zh:'', description_zh:''},
    { id: 'OK_5V_OUT_N' , default_name: 'OK_5V_OUT_N' , electrical_type: 'digital_out'   , caption_en: 'Good 5V Out'        , description_en: 'Indicates good 5V output'                          , caption_zh:'', description_zh:''},
    { id: '3V3_TO_5V_N' , default_name: '3V3_TO_5V_N' , electrical_type: 'passive'       , caption_en: '3V3 To 5V'          , description_en: 'Force 3V3 output to 5V'                            , caption_zh:'', description_zh:''},
    { id: '5V0_TO_3V3'  , default_name: '5V0_TO_3V3'  , electrical_type: 'passive'       , caption_en: '5V To 3V3'          , description_en: 'Force 5V output to 3V3'                            , caption_zh:'', description_zh:''},
    { id: 'FB_3V3_OUT'  , default_name: 'FB_3V3_OUT'  , electrical_type: 'passive'       , caption_en: '3V3 Adjust'         , description_en: '3V3 regulator adjust - Advanced use only'          , caption_zh:'', description_zh:''},
    { id: 'FB_5V_OUT'   , default_name: 'FB_5V_OUT'   , electrical_type: 'passive'       , caption_en: '5V Adjust'          , description_en: '5V regulator adjust - Advanced use only'           , caption_zh:'', description_zh:''},
];
//..............................................................................

//..............................................................................
const specialFunctionPinTypes =
[
    { id: 'mosi_slave'    , default_name:'MOSI'      , electrical_type: 'digital_in'     , caption_en: 'SPI Slave MOSI'       , description_en: 'Master-Out-Slave-In. Receives data from the master.'     , caption_zh:'SPI从MOSI', description_zh: '主出从入。从主设备接收数据'},
    { id: 'miso_slave'    , default_name:'MISO'      , electrical_type: 'digital_out'    , caption_en: 'SPI Slave MISO'       , description_en: 'Master-In-Slave-Out. Sends data to the master.'          , caption_zh:'SPI从MISO', description_zh: '主入从出。发数据到主设备'},
    { id: 'sclk_slave'    , default_name:'SCLK'      , electrical_type: 'digital_in'     , caption_en: 'SPI Slave SCLK'       , description_en: 'Clock signal provided by master.'                        , caption_zh:'SPI从时钟', description_zh: '主设备提供的时钟信号'},
    { id: 'cs_n_slave'    , default_name:'CS_N'      , electrical_type: 'digital_in'     , caption_en: 'SPI Slave Chip-Select', description_en: 'Chip-Select provided by the master. Normally a GPIO'     , caption_zh:'SPI从片选', description_zh: '主设备提供的片选。通常用一个GPIO'},
    { id: 'mosi_master'   , default_name:'MOSI'      , electrical_type: 'digital_out'    , caption_en: 'SPI Master MOSI'      , description_en: 'Master-Out-Slave-In. Sends data to the slave.'           , caption_zh:'SPI主MOSI', description_zh: '主出从入。发数据给从设备'},
    { id: 'miso_master'   , default_name:'MISO'      , electrical_type: 'digital_in'     , caption_en: 'SPI Master MISO'      , description_en: 'Master-In-Slave-Out. Receives data from the slave.'      , caption_zh:'SPI主MISO', description_zh: '主入从出。从从设备接收数据'},
    { id: 'sclk_master'   , default_name:'SCLK'      , electrical_type: 'digital_out'    , caption_en: 'SPI Master SCLK'      , description_en: 'Clock signal provided to slaves.'                        , caption_zh:'SPI主时钟', description_zh: '提供给从设备的时钟信号'},
    { id: 'swdio'         , default_name:'SWDIO'     , electrical_type: 'digital_io'     , caption_en: 'SWD Data'             , description_en: 'Serial-Wire-Debug data signal'                           , caption_zh:'SWD数据', description_zh: '串行线调试数据信号'},
    { id: 'swclk'         , default_name:'SWCLK'     , electrical_type: 'digital_in'     , caption_en: 'SWD Clock'            , description_en: 'Serial-Wire-Debug clock signal from attached debugger.'  , caption_zh:'SWD时钟', description_zh: '来自附属调试器的串行线调试时钟信号'},
    { id: 'sda_slave'     , default_name:'SDA'       , electrical_type: 'digital_io'     , caption_en: 'I2C Slave SDA'        , description_en: 'I2C data signal on slave'                                , caption_zh:'I2C从SDA', description_zh: '从设备I2C数据行'},
    { id: 'scl_slave'     , default_name:'SCL '      , electrical_type: 'digital_io'     , caption_en: 'I2C Slave SCL'        , description_en: 'I2C clock signal provided by master.'                    , caption_zh:'I2C从SCL', description_zh: '从设备I2C时钟信号'},
    { id: 'sda_master'    , default_name:'SDA'       , electrical_type: 'digital_io'     , caption_en: 'I2C Master SDA'       , description_en: 'I2C data signal on master'                               , caption_zh:'I2C主SDA', description_zh: '主设备I2C数据信号'},
    { id: 'scl_master'    , default_name:'SCL '      , electrical_type: 'digital_io'     , caption_en: 'I2C Master SCL'       , description_en: 'I2C clock signal from master.'                           , caption_zh:'I2C主SCL', description_zh: '主设备I2C时钟信号'},
    { id: 'wake_out'      , default_name:'WAKE_OUT'  , electrical_type: 'digital_out'    , caption_en: 'Wakeup Output'        , description_en: 'Output generated by slave to interrupt or wake-up master', caption_zh:'唤醒输出', description_zh: '从设备产生的中断或唤醒主设备的信号'},
    { id: 'wake_in'       , default_name:'WAKE_IN'   , electrical_type: 'digital_in'     , caption_en: 'Wakeup Input'         , description_en: 'Input from master to wake-up slave'                      , caption_zh:'唤醒输入', description_zh: '主设备的被唤醒输入信号'},
    { id: 'reset_n'       , default_name:'RST_N'     , electrical_type: 'digital_in'     , caption_en: 'Reset-N'              , description_en: 'Active-low hardware reset.'                              , caption_zh:'复位-N', description_zh: '低电平有效硬件复位'},
    { id: 'consumer_3V3'  , default_name:'3V3'       , electrical_type: 'power_consumer' , caption_en: '3V3 Consumer'         , description_en: 'Consumes energy from connected 3V3 power producer.'      , caption_zh:'3V3负载', description_zh: '连接3V3功率提供者的负载'},
    { id: 'consumer_5V'   , default_name:'5V'        , electrical_type: 'power_consumer' , caption_en: '5V Consumer'          , description_en: 'Consumes energy from connected 5V power producer.'       , caption_zh:'5V负载', description_zh: '连接5V3功率提供者的负载'},
    { id: 'provider_3V3'  , default_name:'3V3'       , electrical_type: 'power_provider' , caption_en: '3V3 Provider'         , description_en: 'Provides energy for connected 3V3 power consumers.'      , caption_zh:'3V3提供者', description_zh: '为3V3负载提供能量'},
    { id: 'provider_5V'   , default_name:'5V'        , electrical_type: 'power_provider' , caption_en: '5V Provider'          , description_en: 'Provides energy for connected 5V power consumers.'       , caption_zh:'5V提供者', description_zh: '为5V负载提供能量'},
];
//..............................................................................

//..............................................................................
function getSpecialFunctionPinByName(name)
{
    for (var i = 0; i < specialFunctionPinTypes.length; i++)
    {
        if (specialFunctionPinTypes[i].default_name === name)
        {
            return specialFunctionPinTypes[i];
        }
    }
}
//..............................................................................

//..............................................................................
function getPowerSignalPinByName(name)
{
    for (var i = 0; i < powerSignalPinTypes.length; i++)
    {
        if (powerSignalPinTypes[i].default_name === name)
        {
            return powerSignalPinTypes[i];
        }
    }
}
//..............................................................................

//..............................................................................
function getSpecialFunctionPinIDs()
{
    for (var i = 0; i < specialFunctionPinTypes.length; i++)
    {
        specialFunctionPinIDs.push(specialFunctionPinTypes[i].default_name);
    }
}
//..............................................................................

//..............................................................................
function getPowerSignalPinIDs()
{
    for (var i = 0; i < powerSignalPinTypes.length; i++)
    {
        powerSignalPinIDs.push(powerSignalPinTypes[i].default_name);
    }
}
//..............................................................................

//..............................................................................
function isModule(moduleID)
{
    return moduleID.indexOf('MB') === 0
}
//..............................................................................

//..............................................................................
function isSpecialFunctionPin(pinID)
{
    return isInArray(pinID, specialFunctionPinIDs);
}
//..............................................................................

//..............................................................................
function isPowerSignalPin(pinID)
{
    return isInArray(pinID, powerSignalPinIDs);
}
//..............................................................................

//..............................................................................
function isGroundPin(pinID)
{
    return pinID === 'GND';
}
//..............................................................................

//..............................................................................
function isRemoteGPIO(pinID)
{
    return pinID.indexOf('PWM') > -1
}
//..............................................................................

//..............................................................................
function getGroundPinArray(pin)
{
    var result     = [];
    var pinsString = '';
    var pins       = pin.pins;

    if (substringCount(pin.pins, ',') < 7)
    {
        var groundPinString = "    {";

        while (groundPinString.length < jsFormatStops[1]) groundPinString = groundPinString + ' ';

        groundPinString = groundPinString + "  refs: '" + pin.pins + "'";

        while (groundPinString.length < jsFormatStops[2]) groundPinString = groundPinString + ' ';

        groundPinString = groundPinString + ", pin_type: 'ground'         },";

        result.push(groundPinString);

        return  result;
    }

    while(pins.length > 0)
    {
        while (substringCount(pinsString, ',') < 5 && pins.length > 0)
        {
            pinsString = pinsString + pins[0];

            pins = pins.substring(1);
        }

        result.push("'" + pinsString.trim() + "' +");

        pinsString = '';
    }

    var tempString = result[0];

    result[0] = "    {";

    while (result[0].length < jsFormatStops[1]) result[0] = result[0] + ' ';

    result[0] = result[0] + "  refs: " + tempString;

    for (var i = 1; i < result.length; i++)
    {
        result[i] = getSpacerString(jsFormatStops[1]) + getSpacerString(8) + result[i];
    }

    while (result[result.length -1].length < jsFormatStops[2]) result[result.length -1] = result[result.length -1] + ' ';

    result[result.length -1] = result[result.length -1] + " , pin_type: 'ground'";

    while (result[result.length -1].length < jsFormatStops[3]) result[result.length -1] = result[result.length -1] + ' ';

    for (i = 0; i < result.length -1; i++)
    {
        if (result[i].indexOf("' +") > -1)
        {
            while (result[i].indexOf("' +") < jsFormatStops[1] + 33)
            {
                result[i] = replaceAll(result[i], "' +", " ' +")
            }
        }

        //result[i] = getSpacerString(jsFormatStops[1]) + getSpacerString(8) + result[i];
    }

    result[result.length -1] = result[result.length -1] + " },";

    result[result.length -1] = result[result.length -1].replace('+', '');

    return result;
}
//..............................................................................

//..............................................................................
function getSpecialFunctionString(pin, pins)
{
    var result = "    {";

    while (result.length < jsFormatStops[1]) result = result + ' ';

    result = result + "  refs: '" + pins + "'";

    while (result.length < jsFormatStops[2]) result = result + ' ';

    result = result + ", pin_type: '" + pin.id + "'";

    while (result.length < jsFormatStops[3]) result = result + ' ';

    result = result + "},";

    return result;
}
//..............................................................................

//..............................................................................
function getPowerSignalString(pin, pins)
{
    var result = "    { id: '" + pin.id + "'";

    while (result.length < jsFormatStops[1]) result = result + ' ';

    result = result + ", refs: '" + pins + "'";

    while (result.length < jsFormatStops[2]) result = result + ' ';

    result = result + ", pin_type: '" + pin.electrical_type + "'";

    while (result.length < jsFormatStops[3]) result = result + ' ';

    result = result + " , caption_en: '" + pin.caption_en + "'";

    while (result.length < jsFormatStops[4]) result = result + ' ';

    result = result + ", description_en: '" + pin.description_en + "'";

    while (result.length < jsFormatStops[5]) result = result + ' ';

    result = result + ", caption_zh: '" + pin.caption_zh + "'";

    while (result.length < jsFormatStops[6]) result = result + ' ';

    result = result + ", description_zh: '" + pin.description_zh + "'";

    while (result.length < jsFormatStops[7]) result = result + ' ';

    result = result + "},";

    return result;
}
//..............................................................................

//..............................................................................
function getRemoteGPIOString(pin)
{
    var result = "    { id: '" + pin.id + "'";

    while (result.length < jsFormatStops[1]) result = result + ' ';

    result = result + ", refs: '" + pin.pins + "'";

    while (result.length < jsFormatStops[2]) result = result + ' ';

    result = result + ", pin_type: 'gpio'";

    while (result.length < jsFormatStops[3]) result = result + ' ';

    result = result + "},";

    return result;
}
//..............................................................................

//..............................................................................
function getPinString(pin)
{
    var result = "    { id: '" + pin.id + "'";

    while (result.length < jsFormatStops[1]) result = result + ' ';

    result = result + ", refs: '" + pin.pins + "'";

    while (result.length < jsFormatStops[2]) result = result + ' ';

    result = result + ", pin_type: 'TBA'             , caption_en: '', description_en: '', caption_zh:'', description_zh:''";

    while (result.length < jsFormatStops[3]) result = result + ' ';

    result = result + "},";

    return result;
}
//..............................................................................

//..............................................................................
function generateModuleJS(objectsJSON)
{
    var pinTable            = {};
    var jsonObject          = {};
    var pin                 = {};
    var pins                = '';
    var moduleID            = '';
    var footprint           = '';
    var jsArray             = [];
    var specialFunctionPins = [];
    var powerSignalPins     = [];
    var remoteGPIOs         = [];
    var groundPin           = {};
    var groundPinArray      = [];
    var remainingPins       = [];

    getSpecialFunctionPinIDs();

    getPowerSignalPinIDs();

    for (var i = 0; i < objectsJSON.length; i++)
    {
        jsonObject = objectsJSON[i];

        moduleID = Object.keys(jsonObject)[0];

        moduleID= moduleID.substring(moduleID.indexOf('-') + 1);

        if (isModule(moduleID))
        {
            pinTable = jsonObject[Object.keys(jsonObject)[0]];

            for (var j =0; j < Object.keys(pinTable).length; j++)
            {
                pin = pinTable[Object.keys(pinTable)[j]];

                if (isSpecialFunctionPin(pin.id))
                {
                    specialFunctionPins.push(pin)
                }
                else if (isPowerSignalPin(pin.id))
                {
                    powerSignalPins.push(pin)
                }
                else if (isGroundPin(pin.id))
                {
                    groundPin = pin;
                }
                else if (isRemoteGPIO(pin.id))
                {
                    remoteGPIOs.push(pin)
                }
                else
                {
                    remainingPins.push(pin);
                }
            }

            moduleID= moduleID.substring(moduleID.indexOf('-') + 1);

            footprint = 'MB-' + jsonObject.formFactor.dimensions;

            groundPinArray = getGroundPinArray(groundPin);

            jsArray.push("//..............................................................................");
            jsArray.push("const definition =");
            jsArray.push("{");
            jsArray.push("  id        : '" + moduleID + "',");
            jsArray.push("  footprint : '" + footprint + "',");
            jsArray.push("  pins : ");
            jsArray.push("  [");

            for (j = 0; j < groundPinArray.length; j++)
            {
                jsArray.push(groundPinArray[j]);
            }

            for (j = 0; j < specialFunctionPins.length; j++)
            {
                pins = specialFunctionPins[j].pins;

                pin = getSpecialFunctionPinByName(specialFunctionPins[j].id);

                if (!isInArray(getSpecialFunctionString(pin, pins), jsArray)) jsArray.push(getSpecialFunctionString(pin, pins));
            }

            for (j = 0; j < powerSignalPins.length; j++)
            {
                pins = powerSignalPins[j].pins;

                pin = getPowerSignalPinByName(powerSignalPins[j].id);

                var powerSignalString = getPowerSignalString(pin, pins);

                if (!isInArray(powerSignalString, jsArray)) jsArray.push(powerSignalString);
            }
            for (j = 0; j < remoteGPIOs.length; j++)
            {
                if (!isInArray(getRemoteGPIOString(remoteGPIOs[j]), jsArray)) jsArray.push(getRemoteGPIOString(remoteGPIOs[j]));
            }
            for (j = 0; j < remainingPins.length; j++)
            {
                if (!isInArray(getPinString(remainingPins[j]), jsArray)) jsArray.push(getPinString(remainingPins[j]));
            }

            jsArray.push("  ]");
            jsArray.push("};");
            jsArray.push("//..............................................................................");
            jsArray.push("");
            jsArray.push("module.exports = definition;");

            writeFileToDisk(jsArray.join('\n'), 'E:\\Dropbox (Mesheven)\\Git\\Documentation\\mesh-electrical\\temp', moduleID + '.js');

            specialFunctionPins = [];
            remainingPins       = [];
            remoteGPIOs         = [];
            jsArray             = [];
            powerSignalPins     = [];
        }
    }
}
//..............................................................................

//..............................................................................
var exported =
{
    generateModuleJS,
};
//..............................................................................

//..............................................................................

module.exports = exported;
