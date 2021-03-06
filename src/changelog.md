# Changelog

## Know Issues
- At this time, when Underground Locomotives, they will always point westward (or north if placed vertically).
See [below](#v050) below for a workaround.
- Other mods that place entities and do not raise the `script_raised_built` event may lead to unintended consequences.
- If a Stairs, Belt-Elevator, or Power transfer entity is destroyed, it will leave a ghost on only one of its layers.
- Endgame testing and balance is incomplete.

## v0.6.2
### Bugfixes:
- Fixed bug where in some cases the game would crash after researching "Ground Penetrating Radar"

## v0.6.1
### Bugfixes:
- Fixed error on player disconnect and on death
- Fixed possible incompatibility with other radar changing mods.

## v0.6.0
### Features:
- Added "Ground Penetrating Radar" technology. Researching this will change all radars to give vision to underground layers. Each level of this research allows radars to "see" one level deeper.
- Added placement help HUD. After researching "Ground Penetrating Radar," if a player has in their hand an item that bridges levels (Belt-Elevators, Stairs, Power-Converters) they will see colored boxes within a moderate radius showing where entities are built on the target layer (below of above, depending if holding an 'up' or 'down' item). Power Converters show all levels, above and below. Current colors are Orange for below layers, Blue for above layers.
- Added additional undergorund whitelist based on entity type. This has default values (see wiki) and can be added to by the startup setting.
- Added undergorund entity blacklist based on entity name. This will override any whitelist entry for that entity. Default is empty, but can be added to via a startup setting.
### Changes:
- Power Converters now bridge all layers. The entire column (from the top to the bottom) now must be clear in order to place the converter. If migrating a save from a previous version, Subterra will try and extend existing power convertes to all layers. If there is a layer that it cannot place on at (usually due to something being in the way), it will skip that layer but then mark the pole (on layers it does exist) with a red circle and exclamation point: **( ! )**. _Removing the entity will remove this warning._
- Renamed and combined "Power Converters - Top" and "- Bottom" to "Power Transfer Column".
- Changed Power Converters' output prioritiy to "tertiary". Input priority is unchanged ("secondary-input").
- Reduced Power Converter buffer size, giving a maximum throughput of MW through each column.
### Graphics:
- Changed the look of the icon for Power Converters (now called "Power Transfer Column").
### Optimization:
- Improved iteration performace for power transfer between layers.
- Added some caching and additional minor performace improvements in some event handlers.
### Bugfixes:
- Added icon and EN Localization for power output and input entities so they show up properly in the Electric network info panel.
- Adding Subterra to an existing save which has researched Logistics 2 or 3 will now also unlock the exhange recipes.

## v0.5.3
- Battery recharge recipes are now hidden until the requisite level of Subways is researched.
- Additional code refactoring and optimization.

## v0.5.2
- Fixed initialization bug.

## v0.5.1
### Modified
- Changes some messages when a 2-layer entity is denied placement.
### BuxFixes
- Picking up a power converter no longer crashes the game.

## v0.5.0
NOTE: Compatibility with saves from previous versions is spotty at best.
### New
- Updated to Factorio v 0.17.x
- Added Gui element to show current Depth. Simple text label for now.
- Added ability to add any entity to the Underground Whitelist via semicolon delimited list in the mod's startup settings.
- Added keyboard shortcut to flip the direction of any rolling stock under the cursor (Default: CONTROL + F). This can
be used to work-around the top know issue above.

### Modified
- Completely changed how underground locomotives are handled. Now there is only one item and recipe that improves in performance the
further underground it is placed. The levels of the Subways technology unlocks the ability to place locomotives deeper.
- Changed the max-depth setting to default to 4, with a max of 5

### Bugfixes
- Removing a belt-elevator now properly picks up the items on its input and output.
- The fifth level of the Underground is now properly generated.
- Fixed numerous entity placement and removal errors.
- `raise_destroy` is now set to true when cleaning up blacklisted entities.
- Major Refactor of code has started, there are multiple large and small bugs that have been fixed that are not noted here.

## v0.4.0
### New
- Added configuration to the mod. User can now set Max Depth (min 1, max 4, default 2).
WARNING: reducing this value for existing worlds is not supported, but increasing works (so far in my testing, at least).
- Added technology: Underground levels are now unlocked by successive researches. NOTE: This will prevent you from placing entities
that 'dig' down to a specific layer (i.e. Stairs, Elevator, Power transfer) until the research is completed. For safety, move to the surface
before updating the Max Depth setting
- Added subways: Special, faster locomotives that can only be placed underground. Unlocked by research
- Added rechargeable batteries: Special 'fuel' for subways. Recharged in a special dedicated machine
- Added faster belt elevators. The three levels of belts in the base game now have equavalent speed elevators.
Unlocked at the same level of logistics as the equivalent belt.
- Added support for ghosts and robots to construct stairs, elevators, and power transfer entities

### Modified
- Changed the first underground level, it now spawns water tiles which follow the water in the main surface.
NOTE: will not change already generated chunks in that layer.

### Bugfixes
- Changed chunk generation logic. Possible fix of a logic error in the previous versions, though requires more testing.
- Fixed bug where game would crash if you died. (X_X)
- Game will no longer crash in sandbox or if you manually type the statement `\c game.player.character = nil`

## v0.3.3
### New
- Added remote calls so other mods can add or remove entities from the underground whitelist
To add an entity: `remote.call("subterra:entities", "add", %NAME%)` - Replace `%NAME` with the name of the entity (i.e. the name of the prototype)
To remove an entity: `remote.call("subterra:entities", "remove", %NAME%)` 

## v0.3.2
### New
- Added some feedback messages for when players are unable to place certain structures
### Bugfixes
- Fixed compatibility with other mods that create additional surfaces (so far tested with Factorissimo2).
- Adjusted the position of a hidden entity so the no-electric-network icon shows in the center of the transfer pole.

## v0.3.1
### Bugfixes
- Subscribes to the `script_raised_built` event to percent non-whitelisted entities from being built underground.
- Added some missed vanilla entities to underground whitelist.
- Mod now handles being added to large existing worlds.
  - Note: Loading into a large explored world will cause performance to drop for a
short time while the underground surface generation catches up.

## v0.3.0
### Changes
- "Telepads" renamed to "Stairs"

### New
- Power transfer.
- Custom graphics for stairs and power transfer structures.
- Added whitelist of vanilla structures able build underground.

### Bugfixes
- updated all api calls to work with Factorio v0.16.x

## v0.1.0
### New
- Belt Elevators
- Teleport pads to transport players between levels

## v0.0.1
### New
- "Underground" surfaces
- chunk-generation for underground layers
- quadtree data structure for faster collision detection