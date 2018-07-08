# Changelog

## v0.0.1
### New
- "Underground" surfaces
- chunk-generation for underground layers
- quadtree data structure for faster collision detection

## v0.1.0
### New
- Belt Elevators
- Teleport pads to transport players between levels

## v0.3.0
### Changes
- "Telepads" renamed to "Stairs"

### New
- Power tansfer
- Custom graphics for stairs and power transfer structures
- Added whitelist of vanilla structures able build underground:

### Bugfixes
- updated all api calls to work with Factorio v0.16.x

## v0.3.1
### Bugfixes
- Subscribes to the `script_raised_built` event to precent non-whitelisted entiteis from being built underground
- Added some missed vanilla entities to underground whitelist.
- Mod now handles being added to large existing worlds.
  - Note: Loading into a large explored world will cause performace to drop for a
short time while the underground surface generation catches up
## Know Issues
- Does not function yet with other mods that add surfaces to the world (eg. Factorissimo)
- Other mods that place entities and do not raise the `script_raised_built` event may lead to unintended consequences.
