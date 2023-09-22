# TILT-SHIP-FRAMEWORK-FOR-VALKYRIEN-SKIES-2-AND-COMPUTERCRAFT

## BEFORE YOU USE THIS
MAKE SURE TO USE VS2-Tournament Version **1.1.0** or higher.

Trying to fly any of my ships without it WILL crash the physics thread (and your game).

YOU HAVE BEEN WARNED

It's not out yet since the making of this post

but there is a test build available in the [Valkyrien Skies 2 Discord server](https://discord.com/invite/dWwM8G3)

## HOW TO USE
  1. Copy the contents of the `DEFAULT_10_THRUSTER_TILTSHIP_FRAMEWORK` folder (BOW_COMPONENT_CONTROLLER_COMPUTER,STERN_COMPONENT_CONTROLLER_COMPUTER and MAIN_COMPUTER) to the `computercraft/computer` directory and rename the three folders to their respective Turtle Computer IDs
  2. Edit the `startup.lua` script inside the `BOW_COMPONENT_CONTROLLER_COMPUTER` and `STERN_COMPONENT_CONTROLLER_COMPUTER` folder to start either `V10T_(BOW/STERN).lua` or `H10T_(BOW/STERN).lua` depending on the kind of thruster template used (TenThrusterTemplateHorizontal or TenThrusterTemplateVertical)
  3. Edit the `DRONE_DESIGNATION` and `DRONE_TO_COMPONENT_BROADCAST_CHANNEL` constants in the `(V/H)10T_(BOW/STERN).lua` scripts to serve the correct drone
  4. Edit the `DRONE_ID ` and `COMPONENT_TO_DRONE_CHANNEL` constants in the `MAIN_COMPUTER/firmwareScript.lua` file
  5. Configure the `designated_ship_id` and `designated_player_name` in `MAIN_COMPUTER/firmwareScript.lua`
  6. Run the `(V/H)10T_(BOW/STERN).lua` scripts on both the BOW & STERN Component Controllers (the two turtles around the main turtle). If you hit restart on both of the turtles they should run the script automatically using the `startup.lua` script
  7. Run the `firmwareScript.lua` script in the Main Turtle. If everything goes well your drone should start hovering in place. Test it with an ImpulseGun (VS2-Tournament). It should try and keep its orientation and position after trying to smacking it away. 

## DEFAULT TILT-SHIP FRAMEWORK

* DroneBaseClass

  * RemoteControlDrone (Optional, to use the SWARM UI)
    
    * TenThrusterTemplateHorizontal
  
      * KiteTTTH
    
      * TracerHorizontal
      
    * TenThrusterTemplateVertical
    
      * KiteTTTV
      
      * TracerVertical
      
      * SegmentBody
      
      * HoundTurretDrone

## NOTE
Until Valkyrien Computers releases an update to expose a ships inertia tensors, we need to calculate it manually for each new tilt-ship we build. I made this java project that uses CreateMod Schematic files to do just that:
https://github.com/19PHOBOSS98/TILT_SHIP_MINECRAFT_SCHEMATIC_INERTIA_TENSOR_CALCULATOR/tree/main
