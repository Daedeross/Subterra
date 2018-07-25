# Changelog

## Know Issues
- Other mods that place entities and do not raise the `script_raised_built` event may lead to unintended consequences.
- If a Stairs, Belt-Elevator, or Power transfer entity is destroyed, it will leave a ghost on only one of its two layers.
- There are still some edge cases that need to be tested for creation and deletion of these special entitites

## v0.4.0
### New
- Added configuration to the mod. User can now set Max Depth (min 1, max 4, default 2).
WARNING: reducing this value for existing worlds is not supported, but increasing works (so far in my testing, at least).
- Added technology: Underground levels are now unlocked by successive researches. NOTE: This will prevent you from placing entities
that 'dig' down to a specific layer (i.e. Stairs, Elevator, Power transfer) until the research is completed.
- Added subways: Special, faster locomotives that can only be placed underground. Unlocked by research
- Added recharable batteries: Special 'fuel' for subways. Recharged in a special dedicated machine
- Added faster belt elevators. The three levels of belts in the base game now have equavalent speed elevators.
Unlocked at the same level of logistics as the equivalent belt.
- Added support for ghosts and robots to construct stairs, elevators, and power transfer entities

### Modifeid
- Changed the first underground level, it now spawns water tiles which follow the water in the main surface.
NOTE: will not change already generated chunks in that layer.

### Bugfixes
- Changed chunk generation logic. Possible fix of a logic error in the previous versions, though requires more testing.
- Fixed bug where game would crash if you died. (X_X)
- Game will no longer crash in sandbox or if you manualy type the statement `\c game.player.character = nil`

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
- Subscribes to the `script_raised_built` event to precent non-whitelisted entiteis from being built underground.
- Added some missed vanilla entities to underground whitelist.
- Mod now handles being added to large existing worlds.
  - Note: Loading into a large explored world will cause performace to drop for a
short time while the underground surface generation catches up.

## v0.3.0
### Changes
- "Telepads" renamed to "Stairs"

### New
- Power tansfer.
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
