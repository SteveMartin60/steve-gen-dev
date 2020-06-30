# Documentation Standards

## Families

There are two types of family object in the product documentation:
1. Device Family: refers to the specific device type. For example, emBoard plugin, Sensor Device, Mesheven Machine etc.
2. Functional Family: refers to the function that the device fulfils. For example, Motor Control, AV Interface, MCU etc.

**Note that while all devices are members of a Device Family, not all devices are members of a Functional Family, and each device can only be a member of one Device Family and one Functional Family** 

Both family types are limited to specific instances listed in this documentation and referred to as `allowedDeviceFamilies` and `allowedDeviceFamilies` respectively. 

Any requirement to change the allowed families requires management approval as all families, both Device and Functional are implicitly built into Mesheven' website and software & hardware infrastructure. 

### Allowed Device Families

| Prefix | Family Name                                                                                                            |
|--------|------------------------------------------------------------------------------------------------------------------------|
| AB     | [Auxiliary Boards                      ](https://github.com/SteveMartin60/doc/blob/master/device-families/mesh-ab.md ) |
| AC     | [Smart SSR Power Controllers           ](https://github.com/SteveMartin60/doc/blob/master/device-families/mesh-ac.md ) |
| BB     | [emBoard Plugins                       ](https://github.com/SteveMartin60/doc/blob/master/device-families/mesh-bb.md ) |
| CM     | [Mesheven Cloud Managed Devices        ](https://github.com/SteveMartin60/doc/blob/master/device-families/mesh-cm.md ) |
| CS     | [Core-Subsystem Boards                 ](https://github.com/SteveMartin60/doc/blob/master/device-families/mesh-cs.md ) |
| DT     | [Development Tools                     ](https://github.com/SteveMartin60/doc/blob/master/device-families/mesh-dt.md ) |
| GW     | [Mesheven Cloud-Connected USB Gateways ](https://github.com/SteveMartin60/doc/blob/master/device-families/mesh-gw.md ) |
| HX     | [Mesheven Intelligent Machines         ](https://github.com/SteveMartin60/doc/blob/master/device-families/mesh-hx.md ) |
| LC     | [Cloud Connected Light Controllers     ](https://github.com/SteveMartin60/doc/blob/master/device-families/mesh-lc.md ) |
| LM     | [Cloud Connected Lamps                 ](https://github.com/SteveMartin60/doc/blob/master/device-families/mesh-lm.md ) |
| MB     | [Mesheven Peripherals                  ](https://github.com/SteveMartin60/doc/blob/master/device-families/mesh-mb.md ) |
| MCU    | [Mesheven MCUs                         ](https://github.com/SteveMartin60/doc/blob/master/device-families/mesh-mcu.md) |
| MX     | [Device Assembly Platforms (emBoards)  ](https://github.com/SteveMartin60/doc/blob/master/device-families/mesh-mx.md ) |
| RP     | [Real-World Peripherals                ](https://github.com/SteveMartin60/doc/blob/master/device-families/mesh-rp.md ) |
| SD     | [Sensor Devices                        ](https://github.com/SteveMartin60/doc/blob/master/device-families/mesh-sd.md ) |
| SK     | [Mesheven Starter Kits                 ](https://github.com/SteveMartin60/doc/blob/master/device-families/mesh-sk.md ) |
| ST     | [Mesheven Sensor Tags                  ](https://github.com/SteveMartin60/doc/blob/master/device-families/mesh-st.md ) |
| SW     | [Mesheven Smart Control-Panels         ](https://github.com/SteveMartin60/doc/blob/master/device-families/mesh-sw.md ) |
| TS     | [Mesheven Smart Touch-Switches         ](https://github.com/SteveMartin60/doc/blob/master/device-families/mesh-ts.md ) |
| UH     | [Cloud-Controlled Power USB Hubs       ](https://github.com/SteveMartin60/doc/blob/master/device-families/mesh-uh.md ) |
| WG     | [Mesheven WiFi-Gateways                ](https://github.com/SteveMartin60/doc/blob/master/device-families/mesh-wg.md ) |

### Allowed Functional Families 

  - MCU emBoard Plugins with BLE Communications,
  - MCU emBoard Plugins with WiFi Communications,
  - Mesheven MCUs with BLE Communications,
  - Mesheven MCUs with WiFi Communications,
  - emBoard Plugins: AV Interfaces,
  - emBoard Plugins: Communications,
  - emBoard Plugins: Connectors,
  - emBoard Plugins: General Purpose IO,
  - emBoards: Motion Control,
  - emBoard Plugins: Power Supplies,
  - emBoard Plugins: Sensors,
  - Peripherals: AV Interfaces,
  - Peripherals: Communications,
  - Peripherals: General Purpose IO,
  - Peripherals: Motion Control,
  - Peripherals: Power Supplies,
  - Peripherals: Sensors
  
## Device Pages

### Page Sections

The sections in a Device Page are required to be listed in here:

#### Allowed Device Page Section Headings

| Name               | Description                                      | Requirements |
|--------------------|--------------------------------------------------|--------------|
| Features           | Bullet list of key device features               |              |
| Description        | Brief description of device                      |              |
| Block Diagram      | Diagram detailing key functions                  |              |
| Hardware Diagram   | Diagram showing physical hardware features       |              |
| Usage              | Detailed information on how to use the device    |              |
| Sensor Information | Detailed specs for all sensors in the device     |              |
| Pin Table          | Table listing all accessible pins                |              |
| Pin Diagram        | Diagram of the physical layout of listed pins    |              |
| Form Factor        | Shape and dimensions of device                   |              |
| Device Family      | Device Family                                    |              |
| Functional Family  | Family listing of devices with similar functions |              |
| Uses               | List of devices used to assemble the device      |              |
| Used By            | List of devices that use the devices             |              |
| Related Devices    | Devices with related functionality or usage      |              |
| OEM Features       | Features specifically for other manufacturers    |              |
| Images             | Link(s) to device image page(s)                  |              |

#### Required Page Sections

All device pages are required to have a specific set of sections based on the specific device. The sections are also order specific.

Section headers are required to be Heading Level 3.

Section names and order must match the list below for each device type:

##### Auxiliary Boards

- Features
- Description
- Usage
- Pin Table
- Pin Diagram
- Device Family
- Used By
- Images

##### Smart SSR Power Controllers

- Features
- Description
- Block Diagram
- Usage  
- Device Family
- Uses
- Images

##### emBoard Plugins

- Features
- Description
- Block Diagram
- Usage
- Pin Table
- Pin Diagram
- Form Factor
- Device Family
- Functional Family
- Images

##### Mesheven Cloud Managed Devices

- Features
- Description
- Block Diagram
- Usage
- Device Family
- Uses
- Images

##### Core-Subsystem Boards

- Features
- Description
- Block Diagram
- Usage
- Pin Table
- Pin Diagram
- Device Family
- Uses
- Used By
- Related Devices
- Images

# Development Tools

- Features
- Description
- Block Diagram
- Usage
- Pin Table
- Pin Diagram
- Device Family
- Uses
- Related Devices
- Images

##### Mesheven Intelligent Machines

- Features
- Description
- Block Diagram
- Usage
- Device Family
- Uses
- Images

##### Cloud Connected Light Controllers

- Features
- Description
- Block Diagram
- Usage
- Pin Table
- Pin Diagram
- Device Family
- Uses
- Related Devices
- Images

##### Cloud Connected Lamps

- Features
- Description
- Block Diagram
- Usage
- Device Family
- Uses
- Related Devices
- Images

##### Mesheven Peripherals

- Features
- Description
- Block Diagram
- Usage
- Pin Table
- Form Factor
- Device Family
- Functional Family

##### Mesheven MCUs

- Features
- Description
- Device Family
- Functional Family

##### Device Assembly Platforms (emBoards)

- Features
- Description
- Block Diagram
- Usage
- Pin Diagram
- Device Family
- Uses
- Related Devices

##### Real-World Peripherals

- Features
- Description
- Block Diagram
- Usage
- Pin Table
- Pin Diagram
- Form Factor
- Device Family
- Uses
- Used By
- Related Devices
- Images

##### Sensor Devices

- Features
- Description
- Block Diagram
- Usage
- Sensor Information
- Device Family
- Uses
- Images

##### Mesheven Starter Kits

- Features
- Description
- Device Family
- Uses
- Images

##### Mesheven Sensor Tags

- Features
- Description
- Block Diagram
- Usage
- Sensor Information
- Device Family
- Uses
- Images

##### Mesheven Smart Control-Panels

- Features
- Description
- Block Diagram
- Usage
- Pin Table
- Pin Diagram
- Device Family
- Uses
- Related Devices
- Images

##### Mesheven Smart Touch-Switches

- Features
- Description
- Block Diagram
- Usage
- Pin Table
- Pin Diagram
- Device Family
- Uses
- Related Devices
- Images

##### Cloud-Controlled Power USB Hubs

- Features
- Description
- Block Diagram
- Usage
- Device Family
- Uses
- Related Devices
- Images

  
  
  
  

  
  
  
  
        
        
        allowedImageFileExtensions,
        allowedImageWidths,
        diagramFileName,
        bulletListStartChars,
        byNumbersDeviceDeviceTypes,
        deviceByNumbersString,
        directoryNames.deviceFamilies,
        deviceFamilyHeader,
        deviceModelsFolder,
        deviceModelsHeader,
        devicePageFolderPrefix,
        functionalFamilyDeviceTypes,
        functionalFamiliesFolder,
        functionalFamilyHeader,
        gitFolder,
        imageFileExtensions,
        pageSectionHeaderDepth,
        pageSectionHeaderPrefix,
        pageTitleHeaderDepth,
        pinTableRowHeaders,
        readmeFileName,
