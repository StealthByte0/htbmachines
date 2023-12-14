# # HTB Machines Script!

### Overview
The **`htb-machines.sh`** script interacts with HTB Machines data (Hack The Box Machines), allowing users to search for information related to HTB machines, such as machine details, IP address lookup, YouTube tutorial links, difficulty level, operating system, and skills.


# Usage

**./htb-machines.sh [options]**

`You can rename the file htboxmachins.sh to htb-machines.sh if you wish, or run it with ./htboxmachins.sh. In practical cases, for the first use, it is recommended to use ./htboxmachins.sh -u to download the necessary files for the script to function properly.`


## Options

1.  **Search for Machine Name:**
    `./htb-machines.sh -m <machine_name>`
    
2.  **Download or Update Necessary Files:**
    `./htb-machines.sh -u`
    
3.  **Search by IP Address:**
    `./htb-machines.sh -i <ip_address>`
    
4.  **Get Link to Machine Resolution on YouTube:**
    `./htb-machines.sh -y <machine_name>`

5.  **Search by Machine Difficulty:**
    `./htb-machines.sh -d <difficulty_level>`
    
6.  **Search by Operating System:**
    `./htb-machines.sh -o <operating_system>`
    
7.  **Search by Skill:**
    `./htb-machines.sh -s <skill>`
    
8.  **Display Help Panel:**
    `./htb-machines.sh -h`
    
9. **Search by Difficulty and Operating System:**
`./htb-machines.sh -d <difficulty_level> -o <operating_system>`

    
## Examples

-   **Search for a machine by name:**
    `./htb-machines.sh -m Lame`
    
-   **Update necessary files:**
    `./htb-machines.sh -u`
    
-   **Search for a machine by IP address:**
    `./htb-machines.sh -i 10.10.10.3`
    
-   **Get YouTube link for machine resolution:**
    `./htb-machines.sh -y Lame`
    
-   **Search for machines by difficulty level:**
    `./htb-machines.sh -d Medium`
    
-   **Search for machines by operating system:**
    `./htb-machines.sh -o Linux`
    
-   **Search for machines by skill:**
    `./htb-machines.sh -s ¨Privilege Escalation¨`
    
-   **Display Help Panel:**
    `./htb-machines.sh -h`
    
-   **Search for machines by difficulty and operating system:**
    `./htb-machines.sh -d Media -o Linux`

## Notes

-   The script provides detailed information about machines based on the specified options.
-   Use the help option (`-h`) to display the available options and their usage.
-   Ensure the script has executable permissions (`chmod +x htb-machines.sh`) before running.

**Disclaimer:** Use this script responsibly and ensure compliance with Hack The Box terms of service. The script is intended for educational purposes and ethical hacking practices.
