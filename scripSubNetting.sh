#!/bin/bash

#Para utilizar este sript debes tener el binario ipcalc

#Paleta de colores para utilizar
greenColour="\e[0;32m\033[1m"
endColour="\033[0m\e[0m"
redColour="\e[0;31m\033[1m"
blueColour="\e[0;34m\033[1m"
yellowColour="\e[0;33m\033[1m"
purpleColour="\e[0;35m\033[1m"
turquoiseColour="\e[0;36m\033[1m"
grayColour="\e[0;37m\033[1m"

################################## Funciones

function ctrl_c(){
	echo -e "${redColour}[!] Saliendo del sistema${endColour}"
	exit 1
}

function helpPanel(){
	echo -e "\n${grayColour}[?] Panel de ayuda${endColour}"
	echo -e "\n\t${yellowColour}m) Conocer tu netmask y sus parametros relevantes${endColour}"
	echo -e "\n\t${yellowColour}h) Abrir el panel de ayuda${endColour}"
}


function conocerNetMask(){
	IpLocal="$(ip addr | grep "inet " | awk '{print $2}' | head -n 1)"
	if [[ $IpLocal =~ ^([0-9]+\.[0-9]+\.[0-9]+\.[0-9]+)/([0-9]+)$ ]]; then
	    ip="${BASH_REMATCH[1]}"
	    cidr="${BASH_REMATCH[2]}"
	    echo "IP: $ip"
	    echo "CIDR: $cidr"

	    #Calculamos los totalHosts
	    elevadoA="$((32-$cidr))"
	    totalHosts="$((2**$elevadoA))"
		
	    #Desencriptamos la clase a traves del CIDR
    		if [ $cidr -lt 9 ]; then
			echo -e "\n${grayColour}[+] Tu netmask es de clase A${endColour}"
		elif [ $cidr -lt 24 ]; then
			echo -e "\n${grayColour}[+] Tu netmask es de clase B${endColour}"
		else
			echo -e "\n${grayColour}[+] Tu netmask es de clase C${endColour}"	
		fi
		
	     echo -e "\n${grayColour}[+] Dispones de ${endColour}${blueColour}$(($totalHosts-2))${endColour}${grayColour} hosts disponibles${endColour}"

	fi	
	netMask="$(ipcalc $IpLocal | grep "Netmask: " | awk '{print $2}')"
	echo -e "\n${grayColour}[+] Tu mascara de red es: ${endColour}${blueColour}$netMask${endColour}"
	NetworkId="$(ipcalc $IpLocal | grep "Network: " | awk '{print $2}')"
	BroadCast="$(ipcalc $IpLocal | grep "Broadcast: " | awk '{print $2}')"
	echo -e "\n${grayColour}[+] Tu network ID es: ${endColour}${blueColour}$NetworkId${endColour}"
	echo -e "\n${grayColour}[+] Tu Broadcast addres es: ${endColour}${blueColour}$BroadCast${endColour}"

}

##################################

trap ctrl_c INT

#Indicador de comando
declare -i parameter_counter=0

while getopts "mh" arg; do
	case $arg in
		m) let parameter_counter+=1;;
		h) ;;
	esac
done

if [ $parameter_counter -eq 1 ]; then
	conocerNetMask
else
	helpPanel
fi
