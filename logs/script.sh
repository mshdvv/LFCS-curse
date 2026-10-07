#!/bin/bash

OPTIND=1 

if [[ "$(id -u)" != "0" ]]; then
  echo -e "\e[1;31mError:\e[0m: Este script debe ser ejecutado como superusuario"
  exit 1
fi

Help(){
  echo -e "\033[1;32mCuser\033[0m, version 1.0\n"
  echo -e "  Sintaxis: cuser -n <nombre> -g <grupo> -s <shell> -m\n"
  echo "  -h      mostrar ayuda"
  echo "  -n      nombre de usuario"
  echo "  -m      crear directorio en /home"
  echo "  -g      grupos"
  echo "  -s      seleccionar shell"
  echo -e "\n"
}

createUser(){

  local user=$1
  local group=$2
  local shell=$3
  local homeDir=$4

  if [[ -z $user ]]; then
    echo -e "\e[1;31mError:\e[0m No se introdujo un nombre de usuario"
  elif [[ $homeDir == "y" ]]; then
    useradd -m -G $group -s $shell $user
    echo -e "\nUsuario creado: \e[1;32m$user\e[0m \nAgregado a grupo(s): \e[1;33m$group\e[0m \nDirectorio en /home: Si\nShell:$shell\n"
  else
    useradd -G $group -s $shell $user
    echo -e "\nUsuario creado: \e[1;32m$user\e[0m \nAgregado a grupo(s): \e[1;33m$group\e[0m \nDirectorio en /home: No\nShell:$shell\n"
  fi
}

if [[ -z $* ]]; then

  i=0

  while [[ $i -lt 1 ]];do
    clear

    echo  "   ______ __  __ _____  ______ ____  "
    echo  "  / ____// / / // ___/ / ____// __ \ "
    echo  " / /    / / / / \__ \ / __/  / /_/ / "
    echo  "/ /___ / /_/ / ___/ // /___ / _, _/  "
    echo  "\____/ \____/ /____//_____//_/ |_|   "
    echo -e "\n"

    echo -n "Nombre de usuario:"
    read nombreUsuario

    echo -n "Añadir a grupos:"
    read addGroup

    cat /etc/shells
    echo -n "Shell:"
    read mainShell

    echo -e "\n"

    echo -n "¿Crear directorio en /home? [y/n]:"
    read directorio

    if [[ -n $nombreUsuario ]]; then
      i=1
    fi

  done

  createUser $nombreUsuario $addGroup $mainShell $directorio

  echo -n "¿Desea asignar una contraseña? [y/n]"
  read password

  if [[ $password == "y" ]]; then
    passwd $nombreUsuario
  fi

  exit 1
fi

while getopts "hn:g:s:mv" opt; do
  case ${opt} in
    h)
      Help
      exit 1
      ;;
    n)
      nombre=${OPTARG}
      ;;
    g)
      grupos=${OPTARG}
      ;;
    s)
      shell=${OPTARG}
      ;;
    m)
      homeDir="y"
      ;;
  esac
done

createUser $nombre $grupos $shell $homeDir
