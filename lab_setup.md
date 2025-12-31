# Lab Installation & Configuration

**Important Update:** Later added the DHCP role and configured DHCP scope. Not included in steps below.

## 1. Installing Active Directory Domain Services

### Step 1: Add the AD DS Role
![Open Server Manager](screenshots/lab_setup/Install_AD_01.png)
*Open Server Manager and click "Add roles and features"*

![Click Manage](screenshots/lab_setup/Install_AD_02.png)
*Click Manage in the upper right-hand corner and select "Add roles and features"*

![Before you Begin](screenshots/lab_setup/Install_AD_03.png)
*Select Next*

![Installation Type](screenshots/lab_setup/Install_AD_04.png)
*Select "Role-based or feature-based installation" and click "Next"*

![Server Selection](screenshots/lab_setup/Install_AD_05.png)
*Click "Select a server from server pool" and select intended server from server pool. Click "Next"*

![Server Roles](screenshots/lab_setup/Install_AD_06.png)
*Ensure both roles: "Active Directory Domain Services" and "DNS Server" are checked. Click "Next"*

![Features](screenshots/lab_setup/Install_AD_07.png)
*Ensure that "Group Policy Management" is checked. Click "Next".*

### Final Steps:
*Confirm the installation selections and click "Install".*
*Once installation is successful, proceed to DC promotion.*

---

## 2. Promoting Server to Domain Controller

### Step 1: Post-Deployment Configuration
![Promote to DC - Notification](screenshots/lab_setup/Promote_DC_01.png)
*Select "Promote this server to a domain controller"*

### Step 2: Deployment Configuration
![New Forest Configuration](screenshots/lab_setup/Promote_DC_02.png)
*Select "Add a new forest" and enter your root domain name (e.g., homelab.local)*

### Step 3: Domain Controller Options
![DC Options](screenshots/lab_setup/Promote_DC_03.png)
*Set Forest and Domain functional levels, configure DSRM password*

### Step 4: Review and Install
*Review all options and click "Next" through prerequisite checks*
*Click "Install" once all checks pass successfully*

**Note:** The server will automatically reboot after promotion. Log in using the domain administrator account (DOMAIN\Administrator).

---

## 3. DNS Configuration

To configure the DC as the primary DNS server for the network:

![Control Panel - Network Connections](screenshots/lab_setup/DNS_setup_01.png)
*Navigate to Control Panel > Network and Internet*

![Adapter Properties](screenshots/lab_setup/DNS_setup_02.png)
*Navigate to Network and Sharing Center*

![IPv4 Properties](screenshots/lab_setup/DNS_setup_03.png)
*Select "Change adapter settings" in the side panel*

![DNS Server Settings](screenshots/lab_setup/DNS_setup_04.png)
*Double-click "Ethernet"*

![Verify DNS Settings](screenshots/lab_setup/DNS_setup_05.png)
*Select "Properties"*

![Test DNS Resolution](screenshots/lab_setup/DNS_setup_06.png)
*Select "Internet Protocol Version 4 (TCP/IPv4)" and click "Properties"*

![DNS Manager Console](screenshots/lab_setup/DNS_setup_07.png)
*Enter in desired static ip address and subnet mask. Leave default gateway empty. Set preferred DNS server to 127.0.0.1 .*
*Click "OK" and run `nslookup` in command prompt to verify DNS resolution*