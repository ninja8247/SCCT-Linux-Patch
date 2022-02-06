#!/bin/bash

if test -f "System/d3d9.dll"; then
	if test -f "SplinterCellChaosTheory.WidescreenFix.zip"; then
		rm "SplinterCellChaosTheory.WidescreenFix.zip"
	fi
	echo "Removing old files..."
	cd System

	rm d3d9.dll d3d9.ini msacm32.dll msvfw32.dll scripts/SplinterCellChaosTheory.WidescreenFix.asi scripts/SplinterCellChaosTheory.WidescreenFix.ini

	rmdir scripts
	cd ..
fi


function refreshExecutables {
rm splintercell3.exe.MOD
cp splintercell3.exe splintercell3.exe.MOD
}

echo "Downloading true widescreen patch..."
wget -q "https://github.com/ThirteenAG/WidescreenFixesPack/releases/download/scct/SplinterCellChaosTheory.WidescreenFix.zip"

echo "Installing true widescreen patch..."
unzip -q SplinterCellChaosTheory.WidescreenFix.zip

# Zip file uses different capitalization for system folder
mv system/* System
rmdir system
rm SplinterCellChaosTheory.WidescreenFix.zip

echo "Done installing true widescreen patch!"

echo "Removing mouse acceleration..."

cd System

# Make backup and temp copies
cp SplinterCell3Settings.ini SplinterCell3Settings.ini.bak
cp SplinterCell3Settings.ini SplinterCell3Settings.ini.mod

cat SplinterCell3Settings.ini.mod | sed -e 's:biasCut=\t\t\t\t*v=\.*:biasCut=\t\t\t\tv=0.0\n:' > SplinterCell3Settings.ini
rm SplinterCell3Settings.ini.mod

echo "Patching executable..."


# Make backup and temp copies
cp splintercell3.exe splintercell3.exe.bak
cp splintercell3.exe splintercell3.exe.MOD

# Doing all the patching in one big line doesn't seem to work.
hexdump -v -e '1/1 "%02X "' splintercell3.exe.MOD | sed 's/68 00 08 00 00 68 00 08 00 00/68 00 20 00 00 68 00 20 00 00/' | xxd -r -p > splintercell3.exe
refreshExecutables

hexdump -v -e '1/1 "%02X "' splintercell3.exe.MOD | sed 's/89 8C 24 E0 00 00 00 B9 00 01 00 00/89 8C 24 E0 00 00 00 B9 00 00 01 00/' | xxd -r -p > splintercell3.exe
refreshExecutables

hexdump -v -e '1/1 "%02X "' splintercell3.exe.MOD | sed 's/BB 9A 99 99 3F/BB 00 00 80 3E/' | xxd -r -p > splintercell3.exe
refreshExecutables

hexdump -v -e '1/1 "%02X "' splintercell3.exe.MOD | sed 's/C7 86 C8 07 00 00 9A 99 99 BE/C7 86 C8 07 00 00 9A 99 19 BE/' | xxd -r -p > splintercell3.exe


rm splintercell3.exe.MOD

echo "Done patching!"

cd ..

echo -e "\nPut this line inside of your steam launch options:\n"
echo -e "WINEDLLOVERRIDES=\"d3d9,msacm32,msvfw32=n,b\" %command% -nointro\n"
echo -e "If you have already created a profile in the game, create a new one\n and use that instead."