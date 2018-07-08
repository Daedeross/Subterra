# Subterra
Factorio mod that adds an underground along with specialized structures.

## Build Instructions

### Configuration
In `config/buildinfo.json` change the value of `output_directory` to point to the `/mods` folder of the Factorio installation you wish to target.

### Windows Build
In Powershell, run `build.ps1`. This will clean out the old mod folder and copy the necessary files to a new mod folder in your specefied factorio installation. It takes care of giving it the proper version suffix to match the `info.json`.

### Windows Deploy
In Powershell reun `deplpy.ps1 -Tag [Tag Name]`. This will checkout the specified Tag (if it exists) and create a zip package ready to drop into a mods folder. The tag name is identical to the version number built.

## License
All files in the repository except artwork in the src/graphics folder are under the MIT License.

&copy; Copyright 2016-2018 Bryan C. Jones
