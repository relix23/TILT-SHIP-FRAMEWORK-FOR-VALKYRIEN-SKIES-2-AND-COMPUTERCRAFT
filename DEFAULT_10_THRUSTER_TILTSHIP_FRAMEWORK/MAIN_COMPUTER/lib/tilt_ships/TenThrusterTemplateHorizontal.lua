local quaternion = require "lib.quaternions"
local utilities = require "lib.utilities"

local RemoteControlDrone = require "lib.tilt_ships.RemoteControlDrone"

local sqrt = math.sqrt
local abs = math.abs
local max = math.max
local min = math.min
local mod = math.fmod
local cos = math.cos
local sin = math.sin
local acos = math.acos
local pi = math.pi
local clamp = utilities.clamp


--only works with the BARE horizontal_ten_thruster_template schematic--
local TenThrusterTemplateHorizontal = RemoteControlDrone:subclass()

function TenThrusterTemplateHorizontal:getOffsetDefaultShipOrientation(default_ship_orientation)
	return quaternion.fromRotation(default_ship_orientation:localPositiveZ(), 45)*default_ship_orientation
end

function TenThrusterTemplateHorizontal:init(instance_configs)
	local configs = instance_configs
	
	configs.ship_constants_config = configs.ship_constants_config or {}
	
	configs.ship_constants_config.DEFAULT_NEW_LOCAL_SHIP_ORIENTATION = quaternion.fromRotation(vector.new(0,0,1), 45)
	
	--REMOVE WHEN VS2-COMPUTERS UPDATE RELEASES--
	--unrotated inertia tensors--
	configs.ship_constants_config.LOCAL_INERTIA_TENSOR = configs.ship_constants_config.LOCAL_INERTIA_TENSOR or
	{
		x=vector.new(50600.0,0.0,0.0),
		y=vector.new(0.0,50600.0,0.0),
		z=vector.new(0.0,0.0,3200.0)
	}
	
	configs.ship_constants_config.LOCAL_INV_INERTIA_TENSOR = configs.ship_constants_config.LOCAL_INV_INERTIA_TENSOR or 
	{
		x=vector.new(1.9762845849802372E-5,-0.0,-0.0),
		y=vector.new(-0.0,1.9762845849802372E-5,-0.0),
		z=vector.new(-0.0,-0.0,3.125E-4)
	}
	--unrotated inertia tensors--
	--REMOVE WHEN VS2-COMPUTERS UPDATE RELEASES--
	
	configs.ship_constants_config.MOD_CONFIGURED_THRUSTER_SPEED = configs.ship_constants_config.MOD_CONFIGURED_THRUSTER_SPEED or 10000
	
	configs.ship_constants_config.THRUSTER_TIER = configs.ship_constants_config.THRUSTER_TIER or 1
	
	configs.ship_constants_config.PID_SETTINGS = configs.ship_constants_config.PID_SETTINGS or
	{
		POS = {
			P = 5,
			I = 0,
			D = 4
		},
		ROT = {
			X = {
				P = 0.15,
				I = 0.08,
				D = 0.15
			},
			Y = {
				P = 0.15,
				I = 0.08,
				D = 0.15
			},
			Z = {
				P = 0.15,
				I = 0.08,
				D = 0.15
			}
		}
	}
	
	--these values are specific for the horizontal 10-thruster template--
	configs.ship_constants_config.INV_ACTIVE_THRUSTERS_PER_LINEAR_MOVEMENT = vector.new(1/4,1/4,1/1)
	configs.ship_constants_config.INV_ACTIVE_THRUSTERS_PER_ANGULAR_MOVEMENT = vector.new(1/4,1/4,1/4)
	
	configs.ship_constants_config.ANGLED_THRUST_COEFFICIENT = vector.new(
																		1/math.sin(math.pi/4),--lateral x-thrusters are at a 45 degree angle
																		1/math.sin(math.pi/4),--lateral z-thrusters are at a 45 degree angle
																		1)--the ship is built vertical and the y-thrusters are aligned to the axis
		
	configs.ship_constants_config.THRUSTER_SPATIALS = 
	{
		THRUSTER_POSITIONS = {
			X_AXIS = vector.new(0,1,2),
			Y_AXIS = vector.new(0,1,2),
			Z_AXIS = vector.new(0,1,2),
		},
		THRUSTER_DIRECTION = {
			X_AXIS = vector.new(-1,0,0),
			Y_AXIS = vector.new(-1,0,0),
			Z_AXIS = vector.new(-1,0,0),
		}
	}
	--these values are specific for the horizontal 10-thruster template--

	TenThrusterTemplateHorizontal.superClass.init(self,configs)
end

function TenThrusterTemplateHorizontal:composeComponentMessage(linear,angular)
	local cct_common = linear.lin_y_p	+	linear.lin_x_n	+	angular.rot_z_p
	local ccb_common = linear.lin_y_n	+	linear.lin_x_p	+	angular.rot_z_p
	local cl_common = linear.lin_y_n	+	linear.lin_x_n	+	angular.rot_z_n
	local cr_common = linear.lin_y_p	+	linear.lin_x_p	+	angular.rot_z_n
	
	local rot_yn_xp = angular.rot_y_n+angular.rot_x_p
	local rot_yp_xn = angular.rot_y_p+angular.rot_x_n
	local rot_yn_xn = angular.rot_y_n+angular.rot_x_n
	local rot_yp_xp = angular.rot_y_p+angular.rot_x_p
	
	local BOW_F = clamp(linear.lin_z_p,0,15)
	local BOW_CCT = clamp(cct_common+rot_yn_xn,0,15)
	local BOW_CCB  = clamp(ccb_common+rot_yp_xp,0,15)
	local BOW_CR  = clamp(cr_common+rot_yp_xn,0,15)
	local BOW_CL  = clamp(cl_common+rot_yn_xp,0,15)
		
	local STERN_B  = clamp(linear.lin_z_n,0,15)
	local STERN_CCT  = clamp(cct_common+rot_yp_xp,0,15)
	local STERN_CCB = clamp(ccb_common+rot_yn_xn,0,15)
	local STERN_CR = clamp(cr_common+rot_yn_xp,0,15)
	local STERN_CL = clamp(cl_common+rot_yp_xn,0,15)

	return {cmd="move",
	drone_designation=self.ship_constants.DRONE_ID,
	BOW={BOW_F,BOW_CCT,BOW_CCB,BOW_CL,BOW_CR},
	STERN={STERN_B,STERN_CCT,STERN_CCB,STERN_CL,STERN_CR}}
end

return TenThrusterTemplateHorizontal