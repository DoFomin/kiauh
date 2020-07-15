#!/bin/bash
clear
set -e

### set some variables
ERROR_MSG=""
green="\e[92m"
yellow="\e[93m"
red="\e[91m"
cyan="\e[96m"
default="\e[39m"

### set some messages
warn_msg(){
  echo -e "${red}<!!!!> $1${default}"
}
status_msg(){
  echo; echo -e "${yellow}###### $1${default}"
}
ok_msg(){
  echo -e "${green}>>>>>> $1${default}"
}
title_msg(){
  echo -e "${cyan}$1${default}"
}
get_date(){
  current_date=`date +"%Y-%m-%d_%H%M%S"`
}

### sourcing all additional scripts
for script in ${HOME}/kiauh/scripts/*; do . $script; done

### set important directories
#klipper
KLIPPER_DIR=${HOME}/klipper
KLIPPY_ENV_DIR=${HOME}/klippy-env
KLIPPER_SERVICE1=/etc/init.d/klipper
KLIPPER_SERVICE2=/etc/default/klipper
#dwc2
DWC2FK_DIR=${HOME}/dwc2-for-klipper
DWC2_DIR=${HOME}/sdcard/dwc2
WEB_DWC2=${HOME}/klipper/klippy/extras/web_dwc2.py
TORNADO_DIR1=${HOME}/klippy-env/lib/python2.7/site-packages/tornado
TORNADO_DIR2=${HOME}/klippy-env/lib/python2.7/site-packages/tornado-5.1.1.dist-info
#mainsail/moonraker
MAINSAIL_DIR=${HOME}/mainsail
MOONRAKER_SERVICE1=/etc/init.d/moonraker
MOONRAKER_SERVICE2=/etc/default/moonraker
#octoprint
OCTOPRINT_DIR=${HOME}/OctoPrint
OCTOPRINT_CFG_DIR=${HOME}/.octoprint
OCTOPRINT_SERVICE1=/etc/init.d/octoprint
OCTOPRINT_SERVICE2=/etc/default/octoprint
#misc
BACKUP_DIR=${HOME}/kiauh-backups
PRINTER_CFG=${HOME}/printer.cfg

### set github repos
KLIPPER_REPO=https://github.com/KevinOConnor/klipper.git
ARKSINE_REPO=https://github.com/Arksine/klipper.git
DMBUTYUGIN_REPO=https://github.com/dmbutyugin/klipper.git
DWC2FK_REPO=https://github.com/Stephan3/dwc2-for-klipper.git
#branches
BRANCH_MOONRAKER=Arksine/work-web_server-20200131
BRANCH_DEV_MOONRAKER=Arksine/dev-moonraker-testing
BRANCH_SCURVE_SMOOTHING=dmbutyugin/scurve-smoothing
BRANCH_SCURVE_SHAPING=dmbutyugin/scurve-shaping

print_error_msg(){
  if [[ "$ERROR_MSG" != "" ]]; then
    echo -e "${red}"
    echo -e "#########################################################"
    echo -e "$ERROR_MSG "
    echo -e "#########################################################"
    echo -e "${default}"
  fi
}

main_menu(){
  print_header
  print_error_msg && ERROR_MSG=""
  #check install status
    klipper_status
    dwc2_status
    mainsail_status
    octoprint_status
    print_branch
  main_ui
  while true; do
    read -p "Perform action: " action; echo
    case "$action" in
      0)
        clear
        print_header
        ERROR_MSG=" Sorry this function is not implemented yet!"
        print_error_msg && ERROR_MSG=""
        main_ui;;
      1)
        clear
        install_menu
        break;;
      2)
        clear
        update_menu
        break;;
      3)
        clear
        remove_menu
        break;;
      4)
        clear
        advanced_menu
        break;;
      5)
        clear
        print_header
        ERROR_MSG=" Sorry this function is not implemented yet!"
        print_error_msg && ERROR_MSG=""
        main_ui;;
      Q|q)
        exit -1;;
      *)
        clear
        print_header
        ERROR_MSG=" Unknown command '$action'"
        print_error_msg && ERROR_MSG=""
        main_ui;;
    esac
  done
  clear; main_menu
}

install_menu(){
  print_header
  install_ui
  while true; do
    read -p "Perform action: " action; echo
    case "$action" in
      1)
        clear
        print_header
        install_klipper
        print_error_msg && ERROR_MSG=""
        install_ui;;
      2)
        clear
        print_header
        dwc2_install_routine
        print_error_msg && ERROR_MSG=""
        install_ui;;
      3)
        clear
        print_header
        mainsail_install_routine
        print_error_msg && ERROR_MSG=""
        install_ui;;
      4)
        clear
        print_header
        octoprint_install_routine
        print_error_msg && ERROR_MSG=""
        install_ui;;
      Q|q)
        clear; main_menu; break;;
      *)
        clear
        print_header
        ERROR_MSG=" Unknown command '$action'"
        print_error_msg && ERROR_MSG=""
        install_ui;;
    esac
  done
  install_menu
}

update_menu(){
  print_header
  read_bb4u_stat
  #compare versions
    ui_print_versions
  update_ui
  while true; do
    read -p "Perform action: " action; echo
    case "$action" in
      0)
        clear
        print_header
        toggle_backups
        print_error_msg && ERROR_MSG=""
        update_ui;;
      1)
        clear
        print_header
        update_klipper && ui_print_versions
        print_error_msg && ERROR_MSG=""
        update_ui;;
      2)
        clear
        print_header
        update_dwc2fk && ui_print_versions
        print_error_msg && ERROR_MSG=""
        update_ui;;
      3)
        clear
        print_header
        update_dwc2 && ui_print_versions
        print_error_msg && ERROR_MSG=""
        update_ui;;
      4)
        clear
        print_header
        update_mainsail && ui_print_versions
        print_error_msg && ERROR_MSG=""
        update_ui;;
      Q|q)
        clear; main_menu; break;;
      *)
        clear
        print_header
        ERROR_MSG=" Unknown command '$action'"
        print_error_msg && ERROR_MSG=""
        ui_print_versions
        update_ui;;
    esac
  done
  update_menu
}

remove_menu(){
  print_header
  remove_ui
  while true; do
    read -p "Perform action: " action; echo
    case "$action" in
      1)
        clear
        print_header
        remove_klipper
        print_error_msg && ERROR_MSG=""
        remove_ui;;
      2)
        clear
        print_header
        remove_dwc2
        print_error_msg && ERROR_MSG=""
        remove_ui;;
      3)
        clear
        print_header
        remove_mainsail
        print_error_msg && ERROR_MSG=""
        remove_ui;;
      4)
        clear
        print_header
        remove_octoprint
        print_error_msg && ERROR_MSG=""
        remove_ui;;
      Q|q)
        clear; main_menu; break;;
      *)
        clear
        print_header
        ERROR_MSG=" Unknown command '$action'"
        print_error_msg && ERROR_MSG=""
        remove_ui;;
    esac
  done
  remove_menu
}

advanced_menu(){
  print_header
  print_error_msg && ERROR_MSG=""
  advanced_ui
  while true; do
    read -p "Perform action: " action; echo
    case "$action" in
      1)
        clear
        switch_menu
        print_error_msg && ERROR_MSG=""
        advanced_ui;;
      2)
        clear
        print_header
        build_fw
        print_error_msg && ERROR_MSG=""
        advanced_ui;;
      3)
        clear
        print_header
        flash_routine
        print_error_msg && ERROR_MSG=""
        advanced_ui;;
      4)
        clear
        print_header
        get_usb_id
        print_error_msg && ERROR_MSG=""
        advanced_ui;;
      5)
        clear
        print_header
        get_usb_id && write_printer_id
        print_error_msg && ERROR_MSG=""
        advanced_ui;;
      6)
        clear
        print_header
        create_dwc2fk_cfg
        print_error_msg && ERROR_MSG=""
        advanced_ui;;
      Q|q)
        clear; main_menu; break;;
      *)
        clear
        print_header
        ERROR_MSG=" Unknown command '$action'"
        print_error_msg && ERROR_MSG=""
        advanced_ui;;
    esac
  done
  advanced_menu
}

switch_menu(){
  print_header
  if [ -d $KLIPPER_DIR ]; then
    read_branch
    print_error_msg && ERROR_MSG=""
    switch_ui
    while true; do
      read -p "Perform action: " action; echo
      case "$action" in
        1)
          clear
          print_header
          switch_to_origin
          read_branch
          print_error_msg && ERROR_MSG=""
          switch_ui;;
        2)
          clear
          print_header
          switch_to_scurve_shaping
          read_branch
          print_error_msg && ERROR_MSG=""
          switch_ui;;
        3)
          clear
          print_header
          switch_to_scurve_smoothing
          read_branch
          print_error_msg && ERROR_MSG=""
          switch_ui;;
        4)
          clear
          print_header
          switch_to_moonraker
          read_branch
          print_error_msg && ERROR_MSG=""
          switch_ui;;
        5)
          clear
          print_header
          switch_to_dev_moonraker
          read_branch
          print_error_msg && ERROR_MSG=""
          switch_ui;;
        Q|q)
          clear; advanced_menu; break;;
      esac
    done
  else
    ERROR_MSG=" No klipper directory found! Download klipper first!"
  fi
}

backup_menu(){
  print_header
  print_error_msg && ERROR_MSG=""
  backup_ui
  while true; do
    read -p "Perform action: " action; echo
    case "$action" in
      1)
        clear
        print_header
        #function goes here
        print_error_msg && ERROR_MSG=""
        backup_ui;;
      Q|q)
        clear; main_menu; break;;
      *)
        clear
        print_header
        ERROR_MSG=" Unknown command '$action'"
        print_error_msg && ERROR_MSG=""
        backup_ui;;
    esac
  done
  backup_menu
}

check_euid
main_menu