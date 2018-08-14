#!/bin/bash
# Script pra fazer funcinar o Mac OS X Sierra na Máquina Virtual no Linux
VBoxManage modifyvm "MacOSX" --cpuidset 00000001 000106e5 00100800 0098e3fd bfebfbff
VBoxManage setextradata "MacOSX" "VBoxInternal/Devices/efi/0/Config/DmiSystemProduct" "iMac11,3"
VBoxManage setextradata "MacOSX" "VBoxInternal/Devices/efi/0/Config/DmiSystemVersion" "1.0"
VBoxManage setextradata "MacOSX" "VBoxInternal/Devices/efi/0/Config/DmiBoardProduct" "Iloveapple"
VBoxManage setextradata "MacOSX" "VBoxInternal/Devices/smc/0/Config/DeviceKey" "ourhardworkbythesewordsguardedpleasedontsteal(c)AppleComputerInc"
VBoxManage setextradata "MacOSX" "VBoxInternal/Devices/smc/0/Config/GetKeyFromRealSMC" 1
