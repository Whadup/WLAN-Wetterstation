#!/bin/bash

UPDATE_VER=V1.6.0

###  Farbdefinition
      GR='\e[1;32m'
      GE='\e[1;33m'
      WE='\e[1;37m'
      BL='\e[1;36m'
      RE='\e[1;31m'

 #Test ob bc und jq installiert sind
         if [ $(which bc) ]; then
           echo -e "\n $GR'bc'$WE installiert: $GR\u2713"
          else
           echo -e "\n $GR'bc'$WE installiert: $RE\u2717"
         fi
         if [ $(which jq) ]; then
           echo -e " $GR'jq'$WE installiert: $GR\u2713\n"
          else
           echo -e " $GR'jq'$WE installiert: $RE\u2717\n"
         fi


backup() {
 echo -e "\n Lege Sicherungskopie der wetterstation.conf an..."
 cp ./wetterstation.conf ./wetterstation.conf.backup
}

FEHLER() {
 if [ "$UPDATE_VER" == "$VERSION" ]; then echo -e "\n$WE Version ist aktuell, nothing to do...\n"; exit 0; fi
 echo -e "\n  Updater ist ${RE}nur\e[0m für Versionen ab V1.4.0 !\n"
 exit 1
}

########################################################################################
#Patch Version V1.4.0 auf V1.5.0
PATCH140() {
 backup
 echo -e "\n Patche wetterstation.conf auf V1.5.0 ..."
 sed -i '/^.#Port der Wetterstation/i \ #Protokoll (HTTP oder HTTPS) \/ default: HTTP\n  WEB=HTTP\n\n #User-Authentifizierung falls benutzt; sonst leer lassen\n  AUTH_USER=\n  AUTH_PASS=\n' ./wetterstation.conf
 sed -i 's/### Settings V1.4.0/### Settings V1.5.0/' ./wetterstation.conf
 echo -e " Fertig...\n"
}

#Patch Version V1.5.0 auf V1.6.0
PATCH150() {
 backup
 echo -e "\n Patche wetterstation.conf auf V1.6.0 ..."
 sed -i 's/### Settings V1.5.0/### Settings V1.6.0/' ./wetterstation.conf
 echo -e " Fertig...\n"
}




 VERSION=$(cat ./wetterstation.conf|grep "### Settings V"|cut -d" " -f3)


 case ${VERSION} in
           V1.4.0) PATCH140 ;;
           V1.5.0) PATCH150 ;;
           *)      FEHLER
 esac
 exit 0
