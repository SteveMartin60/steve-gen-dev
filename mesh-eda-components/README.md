The Mesheven EDA Component Library for Altium Designer

Located at: https://github.com/mesheven-eda/mesh-eda-components

### Using Altium Designer DBLIB with the Mesh. 
You can connect to this by installing Mesheven-Cloud.DbLib (from the root folder of that repo) into AD
There are two instances of the DBLIB that can be used.
Add both of these to your Altium Designer installation, using the Libraries panel in AD.
- Mesheven-Library-Cloud\Mesheven.DbLib
- Mesheven-Library-LAN\Mesheven.DbLib

Each of the represent a different Postgres SQL server.
- Cloud version is running on a cloud server in AWS Beijing
- Local version is running on an HX-02 machine, in the Mesheven office.

Generally the local server will be faster, but less reliable (we may shut the machine down for changes etc).
So use the local server, and if it doesn't work, switch to the cloud server.

Both database servers are kept up to date by software that monitors the Mesh, looks for changes to components, and updates the DB for those changes.

The DB is fully dynamically built and updated by software, so we never edit the DB manually.
In AD, right-click on a component and choose "Update All" to refresh the view from the database server.

The DBLIB files are both called Mesheven.DbLib 
This is so that when we place components, the libarary will always be listed as Mesheven.DbLib  
So in the library form in AD, should only enable one entry at a time.

### Postgres SQL ODBC Driver
This is required to connect to the Database Servers.
Run the file psqlodbc_x86.msi that is located in the root of this folder.

## Adding and Editing Components
Adding and editing components (except PCBLIB and SCHLIB files) is done in the Mesh Web-App.
https://cxq.mesheven.com.cn/m#item-master/component

Updating of the content of the DB follows the content changes in the component items of Mesheven system.  
Should this should be updated with 2-3 seconds of any change in the Mesh. 
Don't forget to "Update All" in AD to refresh the view with the latest data. 
If you right-click on the component line in the libarary panel in AD and choose References>Mesheven, then this component will be visible in the Mesh-App.

### Editing Component Info
We now keep a very limited set of data in the AD component (in the schematic).

This means we can update this info without updating the schematic sheets. 
Currently we copy over the English description, Comment, Footprint reference, Schematic Symbol reference. 
These can all be edited in the Web-App. 
Many of the current Comments and Descriptions are low-quality so we will update over time. 
No need to fix these on our schematics at the moment, but we will makes sure any new components are done well. 

### Adding Components
New components can be added at https://cxq.mesheven.com.cn/m#item-master/component

See the button in the top right. 
You will be prompted for a new ID, which needs to follow the standard CMP-nnnn-nnnn format.

The system will not allow duplicate entries. 
But choose the entries carefully since they cannot currently be deleted once added. 

Once added, the system will show the view of the component where it can be edited. 
Initially Comment, Footprint and Symbol will be set as "UNKNOWN"

The component will immediatly be availble in AD, but no footprint or symbol will be visible. 
All three of these fields will need to be set before using the component.

### Removing Components
If you accidentally add a component with the wrong ID then it cannot currently be deleted. 
Set the comment field to: "TO BE DELETED". 
Later we will delete these.
