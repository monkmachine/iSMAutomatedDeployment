Common Stuff™

•	Java install
o	All of this (ISM/BAM/IIT) wants to be running off the back of Java 11 (we’ve been deploying 11.0.16.1 for HCDAg – no specific reason why we couldn’t move to the latest SP on 11, mostly just for consistency across the various environments atm)
o	Would want the environment variable JAVA_HOME set to point to the root of the Java 11 install
o	Add %JAVA_HOME%/bin to the path (common not user version)
o	The cacerts is replaced with one provided by Steve P in the deployment folder
•	Common cacerts and the “main iWay keystore”
o	These are currently either provided as part of the “deploy package” or created in the environment – may want to look at a more robust method in future?
o	Cacerts is basically just a common version of this file used across all machines/java versions – contains the root/intermediate cert for the JDCP environment CA setup
o	The “main iWay keystore” contains :-
	The private/public key pair used to secure the iWay consoles (incl. BAM) and the iWay REST services
	The JDCP root/intermediate CA public certs
	Two Microsoft CA public certs (used while getting a security token for the call to SaS – this may change after SSL inspection gets introduced – may be resigned using a key signed by the JDCP CA “stack”?
•	Add the “SG_NIDESbx_Integration_Services” group (that the iSM service account belongs to – name will vary per environment) to the “local admins” group for the server SM is installed on
o	This may be revisited to provide a lower level of permissions at a later date

Service Manager Install

•	Install pretty much following the doc in the deploy folder (read the other bits first!)
o	There’s tweaks and additional steps – outline below (may be a fair bit of crossover with the first email… light on detail here, will provide closer to the time =)
o	For some reason you need to include the TPM option when installing iSM to have BAM work properly… most likely an installer bug, it’s leaving a JAR out… *shrug*
•	Install to C:\iway9
•	Install the ISM 9 hotfix (found in the software install folder for ISM) – this is basically a JAR replacement
•	Add the following jars to the [iwayhome]/lib folder (found in the “jdbcjars” folder of the DS-IDE content)
o	ojdbc10.jar
o	mssql-jdbc-12.2.0.jre11.jar
•	Add the following jars to the [iwayhome]/etc/manager/extensions folder (found in the “extensions” folder of the DS-IDE content)
o	iwazuremd5.jar
o	iwfullreplace.jar
o	iwmimetype.jar
•	Configure the “base” service to run as the iSM service account (should display as “accountName@domain.com”)
•	Need to create some folders - ensure that the two “iSM groups” (in JDCP Dev - SG_NIDEDev-Integration_Services and SG_NIDEDev-Integration_Admin) have Modify rights to the E:\iway folder, its contents and any subfolders, etc)
o	E:\iway\AppHome
o	E:\iway\Config
o	E:\iway\Security
•	Create a share called “iwayDeploy” to the E:\iway folder (used by IIT as part of the deployment scripts for the various IIAs that make up the actual “project deployment”)
o	Need to give “Change” rights to the share to the two “iSM groups” (in JDCP Dev - SG_NIDEDev-Integration_Services and SG_NIDEDev-Integration_Admin)
o	FullControl rights to the share can be given to the local admin group
•	Will need the “main iWay keystore” in-place – used here to secure the iSM consoles: -
o	E:\iway\Security\iSM.jks
•	Add to the “base” security providers: -
o	Keystore called “base_keystore” – point to the “main iWay keystore”
o	SSL context called “base_ssl” – default settings, point to base_keystore for the keystore and truststore)
•	Add an appropriate LDAP Provider called “HCDAG” to base (if using LDAPS you’ll reference the base_ssl context created above) – which will connect with the “iSM AD” service account (different to the one ISM actually runs as)
•	Add an appropriate Authentication Realm called “HCDAG” to base – ldaprealm type – using the HCDAG LDAP provider
•	Configure the domain whitelist in the “Console Settings” for base to allow: -
o	Localhost
o	Machine name
o	Both fully qualified domain names (thing.cloud.mil.ca and thing.018gc.onmicrosoft.com)
•	Enable “console tracing” in the “Console Settings” for base
•	Configure Trace settings for base to be error, warning, info, debug and deep
•	Configure the Log settings for base to enable logging and allow a thousand 5 meg files
•	Change the security for the iSM console over to use the AD/LDAP provider created earlier
o	This is done in the Console Settings tab for base
o	The Console Admin ID/Password settings need to be changed from the default internal ones to the details for the iSM service account at this time
o	Need to add two “Server Roles” (under Management > Server Management) with full permissions, names must EXACTLY match the AD/LDAP groups… in JDCP Dev this is: -
	SG_NIDEDev-Integration_Services
	SG_NIDEDev-Integration_Admin
•	Change the ISM console (served on port 9000) to require HTTPS connections
o	This is done in the Console Settings tab for base – will directly reference the “main iSM keystore” (it assumes the first private key it finds in here is the one it should use)
•	Change the iBSE/SOAP console (served on port 9999) to require HTTPS connections
o	This is done in the SOAP1 Settings tab for base – will reference the SSL context created earlier

BAM Install

•	Install pretty much following the doc in the deploy folder 
o	However, don’t use the IIA/IIT files from the base iSM install – use the updated pair (in the Software subfolder of the Deploy folder)
o	There’s additional steps for the “adjust the template” section (see below) – few other tweaks (also noted below)
o	As noted elsewhere – you need to include the TPM option when installing iSM to have BAM work properly
•	Need to create some folders: -
o	E:\iway\AppHome\BAM\Persisancetidresubmit\store
o	C:\iway9\BAM\Resubmit
o	C:\iway9\BAM\Destination
•	Will need the “main iWay keystore” in-place – used here to secure the BAM console: -
o	E:\iway\Security\iSM.jks
•	When “adjusting the template” you need to: -
o	Update/check the register AppHome to point to the appropriate spot (drive letter change should be the extent of it)
o	Check the register BAM_SSLPROVIDER is set to BAM_SSL
o	Check the register BAM_SECURE is set to true
o	Create a keystore called BAM_Keystore (point to the “main iWay keystore”)
o	Create a SSL Context called BAM_SSL (default settings, point to BAM_Keystore for the keystore and truststore)
o	Set Trace Settings to info, error and warning
o	Set log settings to allow a hundred 5 meg files
o	Update the data provider BAMDBProvider to have appropriate details to access the BAM repo (created as part of the documented install steps)
•	When deploying the application and template together – be sure to name it “BAM”… this is used in some of the paths (if it’s different it won’t match to the folders you’ve created)
•	Change the BAM service to run as the iSM service account (should display as “accountName@domain.com”… will match with base, etc)
