# Active Directory Homelab Project

## Table of Contents
- [Project Overview](#project-overview)
- [Environment Overview](#environment-overview)
- [Installation & Configuration](#installation--configuration)
- [Organizational Structure](#organizational-structure)
- [Group Policy Objects](#group-policy-objects)
- [IT Helpdesk Scenarios](#it-helpdesk-scenarios)
- [Lessons Learned](#lessons-learned)

---

## Project Overview

### Description
This homelab project demonstrates the design and implementation of an Active Directory environment for a multi-department organization. The lab simulates enterprise-scale user and computer management across Sales, Finance, HR, and IT departments with proper security controls and organizational structure.

### Key Objectives
- Deploy and configure Active Directory Domain Services
- Implement organizational units and group policies
- Simulate real-world IT helpdesk scenarios
- Practice user and computer management

---

## Environment Overview

### Network Diagram
![AD Homelab Network Diagram](AD_Homelab_Network.png)

**Network Configuration:**
- **Subnet:** 172.16.0.0/24
- **Domain Controller IP:** 172.16.0.2 (Static)
- **DHCP scope:** 172.16.0.100 - 172.16.0.200
- **Internal Switch IP:** 172.16.0.1
- **Domain Name:** HELPLAB.local

### Hardware & Virtualization Specifications

#### Host Machine
- **RAM:** 16 GB
- **CPU:** 4 cores / 8 threads
- **Storage:** 1 TB SSD
- **Hypervisor:** Microsoft Hyper-V
- **Operating System:** Windows 11 Pro

#### Domain Controller VM (Windows Server 2022)
- **Hostname:** WIN-MEUJ3KPDEG5
- **Operating System:** Windows Server 2022 Standard
- **RAM:** 4 GB
- **vCPU:** 4 cores
- **Storage:** 60 GB virtual disk
- **Network:** Hyper-V Internal Switch
- **IP Address:** 172.16.0.2/24 (Static, no gateway)

#### Client Workstation VM #1 (Windows 11 Pro)
- **Hostname:** WIN11-CLI-01
- **Operating System:** Windows 11 Pro
- **RAM:** 4 GB
- **vCPU:** 4 cores
- **Storage:** 60 GB virtual disk
- **Network:** Hyper-V Internal Switch
- **IP Address Range:** 172.16.0.100 - 172.16.0.200 (Dynamic - DHCP, no gateway)

#### Client Workstation VM #2 (Windows 11 Pro)
- **Hostname:** WIN11-CLI-02
- **Operating System:** Windows 11 Pro
- **RAM:** 4 GB
- **vCPU:** 4 cores
- **Storage:** 60 GB virtual disk
- **Network:** Hyper-V Internal Switch
- **IP Address Range:** 172.16.0.100 - 172.16.0.200 (Dynamic - DHCP, no gateway)

### Server Roles & Services

The Domain Controller hosts multiple roles:
- **Active Directory Domain Services (AD DS)** - Directory services and domain management
- **DNS Server** - Name resolution for the domain
- **DHCP Server** - Dynamic IP addressing
- **File and Storage Services** - Shared folders and file permissions
- **Group Policy Management** - Centralized policy deployment

---

**Important Update:** Later added the DHCP role and configured DHCP scope. Not included in steps below.

## Installation & Configuration

### 1. Installing Active Directory Domain Services

#### Step 1: Add the AD DS Role
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

#### Final Steps:
*Confirm the installation selections and click "Install".*
*Once installation is successful, proceed to DC promotion.*

---

### 2. Promoting Server to Domain Controller

#### Step 1: Post-Deployment Configuration
![Promote to DC - Notification](screenshots/lab_setup/Promote_DC_01.png)
*Select "Promote this server to a domain controller"*

#### Step 2: Deployment Configuration
![New Forest Configuration](screenshots/lab_setup/Promote_DC_02.png)
*Select "Add a new forest" and enter your root domain name (e.g., homelab.local)*

#### Step 3: Domain Controller Options
![DC Options](screenshots/lab_setup/Promote_DC_03.png)
*Set Forest and Domain functional levels, configure DSRM password*

#### Step 4: Review and Install
*Review all options and click "Next" through prerequisite checks*
*Click "Install" once all checks pass successfully*

**Note:** The server will automatically reboot after promotion. Log in using the domain administrator account (DOMAIN\Administrator).

---

### 3. DNS Configuration

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

---

## Organizational Structure

### Organizational Unit (OU) Design

![OU Structure Diagram](AD_OU_diagram.png)

#### Design Rationale

The OU structure is designed to mirror a typical small business organization.
Three-Tier Organizational Structure:
1. _Users OU
- Contains all user accounts organized by department.
- Enables department specific user configurations (e.g. Drive Mapping)
2. _Groups OU
- Subdivided into DomainLocal OU and Global OU.
- Domain Local Groups (DL_*): Used to assign permissions to resources (e.g. file shares)
- Global Groups (GG_*): Contains user members organized by department/function.
3. _Computers OU
- Contains all workstations organized by department.
- Enables department specific computer configurations (e.g. Security Settings)

This structure avoids directly assigning permissions to individual users and provides a scalable, maintainable approach to access management.

---

### Group Architecture

![Group Architecture Diagram](Group_Architecture_Diagram.png)

#### Design Rationale
This implements the AGDLP (Account, Global, Domain Local, Permission) best practice:
- Accounts (users) -> added to -> Global groups -> nested in -> Domain Local groups -> assigned Permissions.
- Each department has access to its own shared drive, with the exception of the sales department.
- The IT admin can access the shared drive of the IT department and has permission to remote access servers whereas IT support users may only access the shared drive.

This approach simplifies permission management and scales well as the organization grows.

---

## Group Policy Objects

### 1. Account Lockout Policy

![Account Lockout Policy](screenshots/lab_setup/account_lockout_policy.png)

**Purpose:** Protect against brute-force password attacks

**Configuration:**
- **Account lockout threshold:** 5 invalid logon attempts
- **Account lockout duration:** 30 minutes
- **Reset account lockout counter after:** 30 minutes

**Applied to:** Default Domain Policy (all domain users)

---

### 2. Password Policy

![Password Policy](screenshots/lab_setup/password_policy.png)

**Purpose:** Enforce strong password requirements across the domain

**Configuration:**
- **Minimum password length:** 12 characters
- **Password complexity requirements:** Enabled
- **Maximum password age:** 90 days
- **Minimum password age:** 30 days

**Applied to:** Default Domain Policy (all domain users)

---

### 3. Desktop Wallpaper Policy

![Desktop Wallpaper Policy](screenshots/lab_setup/desktop_wallpaper_policy.png)

**Purpose:** Standardize desktop appearance.

**Configuration:**
- **Wallpaper path:** \\\\helplab.local\\SYSVOL\\helplab.local\\scripts\\wallpapers\\company_wallpaper.jpg
- **Wallpaper style:** Center

**Applied to:** _Users OU

---

### 4. Disable USB Storage Devices

![Disable USB Policy](screenshots/lab_setup/disable_usb_policy.png)

**Purpose:** Prevent data exfiltration and malware introduction via USB drives

**Configuration:**
- **All Removable Storage Classes: Deny all access** Enabled

**Applied to:** HR, Finance, and Sales OUs

**Note:** IT department is excluded from this policy to allow administrative tasks.

---

### 5. Restrict Control Panel Access

![Restrict Control Panel Policy](screenshots/lab_setup/restrict_control_panel_policy.png)

**Purpose:** Limit user ability to modify system settings

**Configuration:**
- **Prohibit access to Control Panel and PC Settings:** Enabled

**Applied to:** HR, Finance, and Sales OUs (non-IT staff)

---

### 6. Mapping Shared Drive - Finance

![Drive Mapping Policy](screenshots/lab_setup/Mapping_Shared_Drive_Finance.png)

**Purpose:** Enable Finance users to access shared Finance drive.

**Configuration:**
- **Letter:** F
- **Location:** \\\\WIN-MEUJ3KPDEG5\\Finance
- **Label as:** Finance Department
- **Hide/Show this drive:** No change
- **Hide/Show all drives:** No change

**Applied to:** Finance OU

---

## IT Helpdesk Scenarios

### Scenario 1: Password Reset Request

**Ticket:** hr.user1 forgot their password and is locked out

**Resolution Steps:**
1. Verified user identity through security questions
2. Opened Active Directory Users and Computers (ADUC)
3. Located user account in HR Staff OU
4. Right-clicked account → Reset Password
5. Set temporary password and enabled "User must change password at next logon"
6. Unlocked the account (if locked due to failed attempts)
7. Communicated temporary password securely to user
8. Verified user could log in and change password

**Screenshots:**
![Locked Account Status](screenshots/helpdesk_scenarios/locked_account.png)
*Account showing locked status before reset*

![Reset Password Dialog](screenshots/helpdesk_scenarios/unlock_account.png)
*Resetting password and unlocking account*

![Change Password](screenshots/helpdesk_scenarios/change_password.png)
*User successfully changing password*

---

### Scenario 2: New User Onboarding

**Ticket:** New hire John Smith joining Finance department - needs AD account and access to Finance shared folder

**Resolution Steps:**
1. Opened ADUC and navigated to Finance Staff OU
2. Created new user account:
   - Username: jsmith
   - Full name: John Smith
   - Email: jsmith@homelab.local
   - Initial password set with "must change at next logon"
3. Added user to Finance_Department security group
4. Verified group membership
5. Tested login from client workstation
6. Confirmed access to Finance shared folder
7. Notified manager that account is ready

**Screenshots:**
![Create New User](screenshots/helpdesk_scenarios/new_user_01.png)
*Creating new user account in Finance OU*

![Group Membership](screenshots/helpdesk_scenarios/new_user_02.png)
*Adding user to Finance_Department group*

![Tested login](screenshots/helpdesk_scenarios/new_user_03.png)
*Testing new user login*

![Shared Folder Access](screenshots/helpdesk_scenarios/new_user_04.png)
*Verifying access to Finance shared resources*

---

### Scenario 3: Computer Unable to Join Domain

**Ticket:** New workstation CLIENT02 cannot join the domain - receiving error message

**Resolution Steps:**
1. Verified network connectivity between client and DC (ping test)
2. Used `nslookup` to test domain name resolution from client
3. Corrected DNS server setting to point to DC (172.16.0.2)
5. Successfully joined computer to domain
6. Moved computer object to appropriate OU (IT Department workstations)
7. Restarted computer and verified domain login

**Screenshots:**
![Domain Join Error](screenshots/helpdesk_scenarios/domain_join_01.png)
*Initial domain join failure error. Notice it mentions "error occurred when DNS was queried" hinting that the DNS configuration may be the issue.*

![Ping DC](screenshots/helpdesk_scenarios/domain_join_02.png)
*Ping the domain controller to ensure it is reachable*

![DNS Troubleshooting](screenshots/helpdesk_scenarios/domain_join_03.png)
*Testing DNS resolution with nslookup*

![Change DNS settings](screenshots/helpdesk_scenarios/domain_join_04.png)
*Change DNS settings*

![Successful Domain Join](screenshots/helpdesk_scenarios/domain_join_05.png)
*Computer successfully joined to domain*

---

### Scenario 4: Group Policy Not Applying

**Ticket:** User reports that desktop wallpaper policy is not applying to their workstation

**Resolution Steps:**
1. Logged into affected client workstation
2. Opened Command Prompt
3. Ran `gpupdate /force` to force policy refresh
4. Ran `gpresult /r` to view applied policies
5. Found that user was in wrong OU (not linked to wallpaper GPO)
6. Moved user to correct OU in ADUC
7. Ran `gpupdate /force` again on client
8. Verified policy application with `gpresult /r`
9. Confirmed wallpaper changed after reboot
10. Documented issue and resolution

**Screenshots:**
![GPResult Output](screenshots/helpdesk_scenarios/gpo_troubleshoot_01.png)
*Notice that there are no group policy objects applied to user*

![User Moved to Correct OU](screenshots/helpdesk_scenarios/gpo_troubleshoot_02.png)
*Moving user to OU with proper policy links*

![Policy Successfully Applied](screenshots/helpdesk_scenarios/gpo_troubleshoot_03.png)
*Verified wallpaper policy applied correctly*

**Commands Used:**
```cmd
gpupdate /force
gpresult /r
```

---

### Scenario 5: Shared Folder Permission Issue

**Ticket:** Finance user cannot modify files in Finance shared folder

**Resolution Steps:**
1. Verified user's group membership in ADUC
2. Confirmed user is member of Finance_Department security group
3. Checked Share/NFTS permissions in Server Manager
4. Found that Finance_Department group had Read permissions but user needed Modify
5. Updated Finance_Department permissions to "Modify"
6. Informed user that permissions may take effect after logout/login
7. User logged out and back in
8. Verified user can now read, write, and modify files in shared folder
9. Tested with creating and deleting test file

**Screenshots:**
![Group Membership Verification](screenshots/helpdesk_scenarios/permissions_01.png)
*Confirming user is in correct security group*

![Share Permissions](screenshots/helpdesk_scenarios/permissions_02.png)
*Reviewing and updating folder permissions*

![Successful Access](screenshots/helpdesk_scenarios/permissions_03.png)
*User successfully accessing shared folder*

---

## Lessons Learned

### Technical Skills Gained
- Installed and configured Active Directory Domain Services from scratch
- Designed and implemented OU structure following best practices
- Created and linked Group Policy Objects for security and standardization
- Troubleshot common AD issues using built-in tools (gpresult, nslookup, etc.)

### Challenges Encountered
- Encountered issues with remote access due to installing portable version of OpenSSH.
- Initial DNS configuration issues causing domain join failures - resolved by properly configuring internal network

---

## Conclusion

This Active Directory homelab provided hands-on experience with core identity and access management concepts used in enterprise environments. The combination of setup, configuration, and simulated helpdesk scenarios demonstrates both technical knowledge and practical troubleshooting skills essential for IT support roles.
