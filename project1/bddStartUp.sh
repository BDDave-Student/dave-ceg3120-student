#! /bin/bash
##  Brandon Dave
##  CEG3120
##  Project 1
#
#

init () { # Initial install of project repo
  git clone https://github.com/BDDave-Student/dave-ceg3120-student.git
  if [ -d $PWD/dave-ceg-3120-student/ ] ;then
    echo "Student repo created in $PWD"
  fi
}

initPath () { # Create PATH if not exist for script directory
##  Prioritize previous PATH before /scripts
  if [ ! -d $HOME/scripts ] ;then
    mkdir $HOME/scripts;
  fi
  if ! grep -q "~/scripts" ~/.profile ;then
		echo "export PATH="$PATH:~/scripts"" >> ~/.profile
		echo "\$PATH created"
	fi
## Copy script to directory
	cp $0 $HOME/scripts/bddStartUp.sh
  chmod +x $HOME/scripts/bddStartUp.sh # allows execution perms
	echo "Copying bddStartUp.sh to $HOME/scripts"

}

initAlias () { # Create custom alias if necessary
##  If grep returns true, alias is made
##  Else create alias and store in .bashrc
##  Requires refresh on .bashrc file
	if ! grep -q "aws-ssh" ~/.bashrc ;then
    echo alias aws-ssh="'ssh -i BDD-Student_CEG3120_key.pem ubuntu@107.20.210.5'" >> ~/.bashrc
	fi
## Re-alias used to remove unstored aliases
## and refresh alias list from .bashrc
	if ! grep -q "re-alias" ~/.bashrc ;then
		echo alias re-alias="'unalias -a && . ~/.bashrc && alias'" >> ~/.bashrc
	fi
## clearHistory used to reset .bash_history
	if ! grep -q "clearHistory" ~/.bashrc ;then
		echo alias clearHistory="'echo \"\" > .bash_history'" >> ~/.bashrc
	fi
}

initVim ()  { # Initialize preferences while using VIM
## Copies project repo's VIM preference to system
  if [ -f ./vimrc ] ;then
	  sudo cp vimrc /etc/vim/vimrc
    echo "Configuration file has been updated."
  else
    echo "No config file was found for VIM.  Using system settings."
  fi
}

initMotd () { # Initialize Log-in Message/MotD
	if [ ! -f /etc/update-motd.d/01-bdd-motd ] ;then
    sudo touch /etc/update-motd.d/01-bdd-motd		
		sudo chown ubuntu /etc/update-motd.d/01-bdd-motd
    sudo echo "#! /bin/bash " >> /etc/update-motd.d/01-bdd-motd	
		sudo echo "echo \"Welcome to the Ubuntu machine hosted by \"" >> /etc/update-motd.d/01-bdd-motd
    sudo echo "echo \"AWS.  This machine is used for CEG3120.\"" >> /etc/update-motd.d/01-bdd-motd
    sudo chmod -x /etc/update-motd.d/* # Disable all MOTD
    sudo chmod 755 /etc/update-motd.d/01-bdd-motd # Enable Custom Message
    sudo chmod 755 /etc/update-motd.d/50-landscape-sysinfo
  fi
}

modifyMotd (){ # Modifies MOTD after initial run
	echo 	"Would you like to [v]iew your available messages or	"
	read -p "		   [e]dit your custom message?		" motdQuery
  case $motdQuery in
    v) chmodMotd 
      ;;
    e) customMotd
      ;;
    *) echo "Invalid entry. Please run the script again."
  esac

}

chmodMotd () { # Utilize pre-configured motd scripts
  echo "Available MOTD to Enable/Disable: "
  ls -lah /etc/update-motd.d/
  read -p "Append bash script to your current motd? " append
  if [ -f /etc/update-motd.d/$append ] ;then
    sudo chmod +x /etc/update-motd.d/$append 
	fi
}

customMotd () { # Prompts user to motd changes
  echo "Current custom motd:"
  cat /run/motd.dynamic
  echo "Changes to your motd will override the existing message."
	read -p "Enter in a new MOTD:	 " customMotd
	echo "#! /bin/bash" > /etc/update-motd.d/01-bdd-motd
	echo "echo \"$customMotd\" " >> /etc/update-motd.d/01-bdd-motd
	echo "Re-login to see your new motd."
}

refreshBash () { # Refreshes the .bashrc file
	. ~/.bashrc
	echo ".bashrc reloaded"
	userRefresh
}

userRefresh () { # Prompts user to refresh .bashrc
	read -p "Would you like to refresh the .bashrc [y] or [n]: "  userInput
	case $userInput in
		y)	. ~/.bashrc;
		echo "You have refreshed the .bashrc";
		;;
		n)	echo "You chose not to refresh the .bashrc.";
			;;
		*)
		echo "An invalid entry was keyed: $userInput";
		userRefresh;
		;;
	esac
	echo "Users should still run \"source .bashrc \" after the script runs."
}

install () { # Clean Install of all preferences
  init
  initPath
  initAlias
  initVim
  initMotd
  refreshBash
}

usage (){ # Usage Guide
	echo "Usage: $0 [-p Export a Scripts Directory]"
	echo "		[-a Set Up Aliases]"	
	echo "		[-v Install VIM plug-ins and preferences]"
	echo "		[-m View/Edit the Message of the Day]	[-r Refresh the .bashrc]" 
	echo "		[-i Clean install on to system]"
	echo "For additional help, use -h to access the manual."
}

helpPage () { # Help Page
	echo "NAME:"
	echo "	bddStartUp"
	echo "SYNOPSIS"
	echo "	bddStartUp [ OPTION ]"
	echo "DESCRIPTION"
	echo "	Running bddStartUp.sh will set a user's system up with predefined "
	echo "	aliases and export a scripting directory to the environment variable's "
	echo "	\$PATH.  A .bashrc reload is automatically ran, but can also be done by "
	echo "	the user's request during and after running the BASH script."
	echo "OPTIONS"
  echo "Usage: 	[-p Export a Scripts Directory]"
  echo "        [-a Set Up Aliases]"
  echo "		    [-v Install VIM plug ins and preferences]"
	echo "		    [-m View/Edit the Message of the Day]"
	echo "		    [-r Refresh the .bashrc]"
  echo "        [-i Clean install on to system]"
  echo "For additional help, use -h to access [THIS] manual."

}

## handles no arguments
if [ -z $1 ] ;then
	usage
fi

unset options ## Unaffected by Env Var

reqArgs='hpavmri'
while getopts $reqArgs options
do
	case $options in
		h) helpPage 
		;;	
		p) initPath
		;;
		a) initAlias
		;;
		v) initVim
		;;
		m) modifyMotd
		;;
		r) refreshBash
		;;
		i) install
		;;
		\? )usage
		;;
	esac
done
shift $((OPTIND-1)) ## Options handler
