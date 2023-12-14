#!/bin/bash
# by @Bl4ckD34thz - x

# Configuration
url="https://htbmachines.github.io/bundle.js"

# Colors for highlighting in the terminal output
greenColour="\e[0;32m\033[1m"
endColour="\033[0m\e[0m"
redColour="\e[0;31m\033[1m"
blueColour="\e[0;34m\033[1m"
yellowColour="\e[0;33m\033[1m"
purpleColour="\e[0;35m\033[1m"
turquoiseColour="\e[0;36m\033[1m"
grayColour="\e[0;37m\033[1m"

# Handling Ctrl+C interruption
function ctrl_c() {
 echo -e "\n${yellowColour}[*]${endColour}${grayColour} Exiting...${endColour}"; sleep 1
 rm "$tmp_file" 2>/dev/null
 tput cnorm
 exit 1
}

# Capture Ctrl+C interruption
trap ctrl_c INT


# Function to display green ASCII art
displayGreenAsciiArt() {
    cat << "EOF"
                       :::!~!!!!!:.
                  .xUHWH!! !!?M88WHX:.
                .X*#M@$!!  !X!M$$$$$$WWx:.
               :!!!!!!?H! :!$!$$$$$$$$$$8X:
              !!~  ~:~!! :~!$!#$$$$$$$$$$8X:
             :!~::!H!<   ~.U$X!?R$$$$$$$$MM!
             ~!~!!!!~~ .:XW$$$U!!?$$$$$$RMM!
               !:~~~ .:!M"T#$$$$WX??#MRRMMM!
               ~?WuxiW*`   `"#$$$$8!!!!??!!!
             :X- M$$$$       `"T#$T~!8$WUXU~
            :%`  ~#$$$m:        ~!~ ?$$$$$$
          :!`.-   ~T$$$$8xx.  .xWW- ~""##*"
.....   -~~:<` !    ~?T#$$@@W@*?$$      /`
W$@@M!!! .!~~ !!     .:XUW$W!~ `"~:    :
#"~~`.:x%`!!  !H:   !WM$$$$Ti.: .!WUn+!`
:::~:!!`:X~ .: ?H.!u "$$$B$$$!W:U!T$$M~
.~~   :X@!.-~   ?@WTWo("*$$$W$TH$! `
Wi.~!X$?!-~    : ?$$$B$Wu("**$RM!
$R@i.~~ !     :   ~$$$$$B$$en:``
?MXT@Wx.~    :     ~"##*$$$$M~ by @Bl4ckD34thz
EOF
}


# Function to display the help message
function helpPanel() {
    displayGreenAsciiArt

    echo -e "\n${yellowColour}[*]${endColour}${grayColour} Usage: ${endColour}";
    echo -e "\t${redColour}-u )${endColour}${blueColour} Download or Update necessary files"${endColour};
    echo -e "\t${redColour}-m )${endColour}${greenColour} Search for Machine name"${endColour};
    echo -e "\t${redColour}-i )${endColour}${greenColour} Search by IP address"${endColour};
    echo -e "\t${redColour}-y )${endColour}${greenColour} Get link to machine resolution"${endColour};
    echo -e "\t${redColour}-d )${endColour}${greenColour} Search by machine difficulty ${purpleColour}(Media)${endColour}, ${greenColour}(Fácil)${endColour}, ${turquoiseColour}(Difícil)${endColour}, ${redColour}(Insane)${endColour}"
    echo -e "\t${redColour}-o )${endColour}${greenColour} Search by operating system${endColour}${purpleColour} Linux${endColour}-${redColour}Windows${endColour}";
    echo -e "\t${redColour}-s )${endColour}${greenColour} Search by Skill"${endColour};
    echo -e "\t${redColour}-h )${endColour}${purpleColour} Display this Help panel"${endColour};
}



# Function to update files
function Updatefiles() {
    # Define local variables for file paths
    local local_file="bundle.js"
    local temp_file="bundle_temp.js"

    # Display message indicating file update check is in progress
    echo -e "\t${redColour}[+]${endColour}${greenColour} Checking for updates in the bundle.js file....\n${enidColour}"

    # Obtain MD5 checksum and formatted content with js-beautify of the local file
    local local_md5_content=$(md5sum "$local_file" 2>/dev/null | awk '{print $1}' || echo "")$(js-beautify "$local_file" 2>/dev/null || exit 1)

    # Download the remote file without overwriting the local file
    curl -s "$url" | js-beautify > "$temp_file"

    # Obtain MD5 checksum and formatted content with js-beautify of the newly downloaded file
    local remote_md5_content=$(md5sum "$temp_file" 2>/dev/null | awk '{print $1}' || echo "")$(js-beautify "$temp_file" 2>/dev/null || exit 1)

    # Compare MD5 checksums and formatted contents
    if [ "$remote_md5_content" != "$local_md5_content" ]; then
        # If MD5 checksums are different or formatted contents are different, overwrite the local file
        mv "$temp_file" "$local_file"
        echo -e "\t${redColour}[+]${endColour}${greenColour} Successfully updated bundle.js file.\n${endColour}"
        echo -e "\t${yellowColour}[*]${endColour}${greenColour} Updates are available!\n${endColour}"
    else
        # If MD5 checksums are the same and formatted contents are the same, delete the temporary file
        rm -f "$temp_file"
        echo -e "\t${yellowColour}[*]${endColour}${greenColour} No updates for the bundle.js file.\n${endColour}"
    fi
}


# Function to search for a machine
function searchMachine() {
  # Get the machine name as a parameter
  machineName="$1"

  # Extract machine properties from bundle.js using awk, grep, tr, and sed
  machineProperties=$(cat bundle.js | awk "/name: \"$machineName\"/,/resuelta:/" | grep -vE "id:|sku:|resuelta" | tr -d '"' | tr -d ',' | sed 's/^ *//')

  # Check if machine properties are empty
  if [ -z "$machineProperties" ]; then
    # Display a message if no properties are found for the machine
    echo -e "\t${yellowColour}[*]${endColour}${redColour} No properties found for the machine ${purpleColour}$machineName${endColour}\n${endColour}"
  else
    # Display machine properties if found
    echo -e "\t${yellowColour}[*]${endColour}${greenColour} Listing properties for machine: ${purpleColour}$machineName${endColour}\n${endColour}"
    echo -e "$machineProperties"
  fi
}

# Function to search for a machine by IP address
function SearchIP() {
  # Get the IP address as a parameter
  ipAddress="$1"

  # Extract machine name associated with the given IP address from bundle.js
  machineName="$(cat bundle.js | grep "ip: \"$ipAddress\"" -B 3 | grep "name: " | awk 'NF{print $NF}' | tr -d '"' | tr -d ',')"

  # Check if machine name is empty
  if [ -z "$machineName" ]; then
    # Display a message if no machine is found for the given IP address
    echo -e "\t${yellowColour}[*]${endColour}${redColour} No machine found for the IP address ${purpleColour}$ipAddress${endColour}\n${endColour}"
  else
    # Display the machine name corresponding to the IP address
    echo -e "\t${yellowColour}[*]${endColour}${greenColour} The corresponding machine for the IP address ${purpleColour}$ipAddress${endColour} is ${redColour}$machineName${endColour}\n${endColour}"
    # Call the searchMachine function to display properties for the found machine
    searchMachine $machineName
  fi
}



# Function to get the YouTube link for a machine
function getYoutubeLink(){

    # Get the machine name as a parameter
    machineName="$1"

    # Extract YouTube link associated with the given machine name from bundle.js
    youtubeLink="$(cat bundle.js | awk "/name: \"$machineName\"/,/resuelta:/" | grep -vE "id:|sku:|resuelta" | tr -d '\n' | tr -d ',' | sed 's/^ *//' | grep youtube | awk '{print $NF}')"

    # Check if a YouTube link is found
    if [ "$youtubeLink" ]; then
        # Display the YouTube link if found
        echo -e "\n${greenColour}[+]${endColour} ${grayColour}The tutorial for this machine is available at the following link:${endColour} ${blueColour}$youtubeLink${endColour}"
    else
        # Display a message if the provided machine does not exist
        echo -e "\n${redColour}[!]${endColour} ${grayColour}The provided machine does not exist${endColour}\n"
    fi
}


# Function to get machines with a specific difficulty level
function getMachinesDifficulty() {
    # Get the difficulty level as a parameter
    difficulty="$1"

    # Extract machine names with the specified difficulty level from bundle.js
    results_check="$(cat bundle.js | grep "dificultad: \"$difficulty\"" -B 5 | grep "name:" | awk 'NF{print $NF}' | tr -d '"' | tr -d ',' | column)"

    # Check if machines with the specified difficulty level are found
    if [ "$results_check" ]; then
        # Display a message and list machines with the specified difficulty level
        echo -e "\n${yellowColour}[+]${endColour}${grayColour} Listing machines with difficulty level${endColour}${blueColour} $difficulty${endColour}${grayColour}:${endColour}\n"
        cat bundle.js | grep "dificultad: \"$difficulty\"" -B 5 | grep "name:" | awk 'NF{print $NF}' | tr -d '"' | tr -d ',' | column
    else
        # Display a message if the specified difficulty level does not exist
        echo -e "\n${redColour}[!]${endColour} ${grayColour}The indicated difficulty level does not exist${endColour}\n"
    fi
}


# Function to get machines with a specific operating system
function getMachineOS(){
    # Get the operating system as a parameter
    operativeso="$1"

    # Display the provided operating system
    echo "$operativeso"

    # Extract machine names with the specified operating system from bundle.js
    os_result="$(cat bundle.js | grep "so: \"$operativeso\"" -B 5 | grep "name: " | awk 'NF{print $NF}' | tr -d '"' | tr -d ',' | column)"

    # Check if machines with the specified operating system are found
    if [ "$os_result" ]; then
        # Display a message and list machines with the specified operating system
        echo -e "\n${yellowColour}[+]${endColour}${grayColour} Listing machines with operating system${endColour}${blueColour} $operativeso${endColour}${grayColour}:${endColour}\n"
        cat bundle.js | grep "so: \"$operativeso\"" -B 5 | grep "name: " | awk 'NF{print $NF}' | tr -d '"' | tr -d ',' | column
    else
        # Display a message if the specified operating system does not exist
        echo -e "\n${redColour}[!]${endColour} ${grayColour}The specified operating system does not exist${endColour}\n"
    fi
}

# Function to get machines with a specific operating system and difficulty level
function getOsDificultyMachines() {
    # Get the difficulty level and operating system as parameters
    difficulty="$1"
    operativeso="$2"

    # Extract machine names with the specified difficulty level and operating system from bundle.js
    osdifi="$(cat bundle.js | grep -i "so: \"$operativeso\"" -C 4 | grep -i "dificultad: \"$difficulty\"" -B 5 | grep "name: " | awk 'NF{print $NF}' | tr -d '"' | tr -d ',' | column)"

    # Check if machines with the specified difficulty level and operating system are found
    if [ "$osdifi" ]; then
        # Display a message and list machines with the specified difficulty level and operating system
        echo -e "\n${yellowColour}[+]${endColour}${grayColour}Searching for difficulty level${endColour}${blueColour} $difficulty${endColour}${grayColour} with OS${endColour}${blueColour} $operativeso${endColour}${grayColour}:${endColour}\n"
        cat bundle.js | grep -i "so: \"$operativeso\"" -C 4 | grep -i "dificultad: \"$difficulty\"" -B 5 | grep "name: " | awk 'NF{print $NF}' | tr -d '"' | tr -d ',' | column
    else
        # Display a message if no results are found for the specified operating system and difficulty level
        echo -e "\n${redColour}[!]${endColour} ${grayColour}No searches found with $operativeso and the specified difficulty $difficulty${endColour}  ${redColour}Usage Example:${endColour} ${blueColour} ./maquinas.sh -d Media -o Linux${endColour}\n"
    fi
}

# Function to get machines with a specific skill
function getSkill(){
  # Get the skill as a parameter
  skill="$1"

  # Extract machine names with the specified skill from bundle.js
  check_skills="$(cat bundle.js | grep "skills: " -B 6 | grep "$skill" -i -B 6 | grep "name: " | awk 'NF{print $NF}' | tr -d '"' | tr -d ',' | column)"

  # Check if machines with the specified skill are found
  if [ "$check_skills" ]; then
    # Display a message and list machines with the specified skill
    echo -e "\n${yellowColour}[+]${endColour}${grayColour} Listing machines with skill${endColour}${blueColour} $skill ${endColour}${grayColour}:${endColour}\n"
    cat bundle.js | grep "skills: " -B 6 | grep "$skill" -i -B 6 | grep "name: " | awk 'NF{print $NF}' | tr -d '"' | tr -d ',' | column
  else
    # Display a message if no machines are found with the specified skill
    echo -e "\n${redColour}[!]${endColour} ${grayColour}[!] No machines found with the skill: ${endColour}${greenColour}$skill${endColour}\n"
  fi
}


# Initialization of variables
declare -i parameter_counter=0
declare -i machine_difficulty=0
declare -i machins_os=0

# Process command-line options using getopts
while getopts "m:ui:y:d:o:s:h" arg; do
    case $arg in
        m) machineName="$OPTARG"; ((parameter_counter+=1));;
        u) ((parameter_counter+=2));;
        i) ipAddress="$OPTARG"; ((parameter_counter+=3));;
        y) machineName="$OPTARG"; ((parameter_counter+=4));;
        d) difficulty="$OPTARG"; machine_difficulty=1; ((parameter_counter+=5));;
        o) operativeso="$OPTARG"; machins_os=1; ((parameter_counter+=6));;
        s) skill="$OPTARG"; ((parameter_counter+=7));;
        h) ;;
    esac
done

# Use a case statement to handle different values of parameter_counter
case $parameter_counter in
    1) searchMachine "$machineName" ;;
    2) Updatefiles ;;
    3) SearchIP "$ipAddress" ;;
    4) getYoutubeLink "$machineName" ;;
    5) getMachinesDifficulty "$difficulty" ;;
    6) getMachineOS "$operativeso" ;;
    7) getSkill "$skill" ;;
    *) [ $machine_difficulty -eq 1 ] && [ $machins_os -eq 1 ] && getOsDificultyMachines "$difficulty" "$operativeso" || helpPanel ;;
esac
