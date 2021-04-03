# Set up the directories and extract files

0. Install 7zip (WinRAR is acceptable if you already have it installed)
    * https://www.7-zip.org/download.html
    * Download the .exe 64-bit x64 7-Zip for 64-bit Windows x64 (Intel 64 or AMD64)
1. Download the current modpack 7z file.
    * Usually from https://www.sweetiebelle.org/files/minecraft/
2. Press the windows button, type in `%appdata%` and head to `.minecraft` folder.
3. Create a folder called `modpacks` in this folder.
4. Inside the `modpacks` folder, create another folder inside. Ideally it should be the name of the modpack, though you can call it anything. Best done if there are no spaces in the foldername.
5. Extract the files from the 7zip file you downloaded within this folder (the one you created in the above step).
    * The 7zip should have folders called `config`, `mods`, optionally `scripts`, and optionally a forge installer.
6. Check if a forge installer is present. If there is, run it.
    * The installer will look something like the following: `forge-1.16.x-a.b.c-shroom-1.16.x-installer.jar`
    * If there is, see the section on [Installing Minecraft Forge](#installing-minecraft-forge) for instructions on how to run this installer.
7. Continue on to [Create the Modpack profile.](#create-the-modpack-profile)

# Create the Modpack profile.
1. Open the vanilla Minecraft Launcher
2. Click the `Installations` tab. ![Screenshot](https://i.imgur.com/Ce0icx2.png)
3. Make sure `Modded` is ticked in the `VERSIONS` section. ![Screenshot](https://i.imgur.com/WWJlRwu.png)
4. Click `+New...` ![Screenshot](https://i.imgur.com/RjK0ecF.png)
5. Name the installation whatever you want. Suggested name is the name of the modpack.
6. Set VERSION to the forge version you installed. It will look something like this ![Screenshot](https://i.imgur.com/nftYAQm.png)
7. Copy the game directory and paste it into the `GAME DIRECTORY` field. ![Screenshot](https://i.imgur.com/BHl3MqT.png)
    * See [Copying your game directory](#copying-your-game-directory) for additional instructions.
8. Click `MORE OPTIONS`. ![Screenshot](https://i.imgur.com/T4wOFeO.png)
9. Under `JVM ARGUMENTS`, change `-Xmx2G` to `-Xmx6G` or `-Xmx8G` depending on how much RAM you have.
    * ![2 Selected](https://i.imgur.com/GQjIGIt.png)
    * ![Value changed](https://i.imgur.com/bwMlZUP.png)
10. Click `Create`. ![Screenshot](https://i.imgur.com/qSnRHhq.png)
11. Click the `Play` button on the installation to launch the modpack! ![Screenshot](https://i.imgur.com/jqo0MGk.png)


# Setting the profile to always play (OPTIONAL)
1. On the `Play` tab, click the profile selector. ![Screenshot](https://i.imgur.com/WSI1eqw.png)
2. Select the desired profile ![Screenshot](https://i.imgur.com/kgcqI1S.png)
3. Click the big green `PLAY` button! ![Screenshot](https://i.imgur.com/gDPRGNT.png)


# Installing Minecraft Forge
1. Double click the Forge installer jar.
2. If it prompts you to pick a program, then you either need to download Java if you haven't already, or associate the Jar file with Java.
    * If your WinRAR/7-zip program opens up instead, then you need to associate Java with it.
3. You can download Java from https://adoptopenjdk.net/?variant=openjdk8&jvmVariant=hotspot
    * Verify `OpenJDK 8 (LTS)` is selected for `Choose a Version`
    * Verify `HotSpot` is selected for `Choose a JVM`
4. Install Java using what you downloaded in step 3.
5. See [Running JarFix](#running-jarfix) for instructions to run JarFix.
6. Install Forge by double clicking the installer jar again.

# Running JarFix
Certain Java archive (JAR) files, such as the Forge installer/launcher JARs, are designed to be self-executing; if double-clicking the file does nothing or opens an archive manager (like WinRAR/7-zip) then you need to adjust the Windows registry to fix the file association.

A program has been created to do this automatically, here: https://johann.loefflmann.net/downloads/jarfix.exe

1. Download the program above.
    * [VirusTotal for .exe](https://www.virustotal.com/gui/file/3a00c5b808954e9dca76418506eacec9cb1cb0fd844318a896ebae787f5eaae2/detection)
    * [VirusTotal for website](https://www.virustotal.com/gui/url/f47cf8195f045c0cbd8cd81d5a7992776868e44743d9ab6ecf60c87683c1d2e7/detection)
    * The two pings for VirusTotal are false positives. It requires Administator permissions in order to edit the proper registry files to fix the assocation.
2. Run the program, and accept the prompt for it to run as Administator.
3. Your JAR file assocations should now be fixed!

# Copying your game directory
1. Press the windows button, type in `%appdata%` and head to `.minecraft` folder.
   * The Windows button is the button that has the Windows icon on it. It's different one every keyboard. Check this [Wikipedia Article](https://en.wikipedia.org/wiki/Windows_key) for some example images.
2. Double click on the `modpacks` folder.
3. Double click on the folder you created earlier for this modpack.
4. Click in some clear space in the address bar in order to be able to select the directory. ![Screenshot](https://i.imgur.com/8IeNyUQ.png)
5. The bar will automatically highlight.
6. Right click and press `Copy`. ![Screenshot](https://i.imgur.com/MBgQxsV.png)
7. You now have it in your clipboard. Return to step 7 in [Create the Modpack profile](#create-the-modpack-profile)
