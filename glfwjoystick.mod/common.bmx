' Copyright (c) 2020 Bruce A Henderson
'
' This software is provided 'as-is', without any express or implied
' warranty. In no event will the authors be held liable for any damages
' arising from the use of this software.
'
' Permission is granted to anyone to use this software for any purpose,
' including commercial applications, and to alter it and redistribute it
' freely, subject to the following restrictions:
'
'    1. The origin of this software must not be misrepresented; you must not
'    claim that you wrote the original software. If you use this software
'    in a product, an acknowledgment in the product documentation would be
'    appreciated but is not required.
'
'    2. Altered source versions must be plainly marked as such, and must not be
'    misrepresented as being the original software.
'
'    3. This notice may not be removed or altered from any source
'    distribution.
'
SuperStrict

Import GLFW.GLFW

Extern
	Function bmx_glfw_glfwJoystickPresent:Int(id:Int)="glfwJoystickPresent"
	Function bmx_glfw_glfwGetJoystickAxes:Float Ptr(id:Int, count:Int Var)="glfwGetJoystickAxes"
	Function bmx_glfw_glfwGetJoystickButtons:Byte Ptr(id:Int, count:Int Var)="glfwGetJoystickButtons"
	Function bmx_glfw_glfwGetJoystickHats:Byte Ptr(id:Int, count:Int Var)="glfwGetJoystickHats"
	Function bmx_glfw_glfwGetJoystickName:Byte Ptr(id:Int)="glfwGetJoystickName"
	Function bmx_glfw_glfwGetJoystickGUID:Byte Ptr(id:Int)="glfwGetJoystickGUID"
	Function bmx_glfw_glfwJoystickIsGamepad:Int(id:Int)="glfwJoystickIsGamepad"
	Function bmx_glfw_glfwSetJoystickCallback(func(id:Int, event:Int))="glfwSetJoystickCallback"
	
	Function bmx_glfw_glfwGetGamepadState:Int(id:Int, state:GLFWgamepadstate Var)="glfwGetGamepadState"
	Function bmx_glfw_glfwUpdateGamepadMappings:Int(txt:Byte Ptr)="glfwUpdateGamepadMappings"
	Function bmx_glfw_glfwGetGamepadName:Byte Ptr(id:Int)="glfwGetGamepadName"
End Extern

Const GLFW_JOYSTICK_1:Int = 0
Const GLFW_JOYSTICK_2:Int = 1
Const GLFW_JOYSTICK_3:Int = 2
Const GLFW_JOYSTICK_4:Int = 3
Const GLFW_JOYSTICK_5:Int = 4
Const GLFW_JOYSTICK_6:Int = 5
Const GLFW_JOYSTICK_7:Int = 6
Const GLFW_JOYSTICK_8:Int = 7
Const GLFW_JOYSTICK_9:Int = 8
Const GLFW_JOYSTICK_10:Int = 9
Const GLFW_JOYSTICK_11:Int = 10
Const GLFW_JOYSTICK_12:Int = 11
Const GLFW_JOYSTICK_13:Int = 12
Const GLFW_JOYSTICK_14:Int = 13
Const GLFW_JOYSTICK_15:Int = 14
Const GLFW_JOYSTICK_16:Int = 15
Const GLFW_JOYSTICK_LAST:Int = GLFW_JOYSTICK_16


Rem
bbdoc: Describes the input state of a gamepad.
End Rem
Struct GLFWgamepadstate
	Rem
	bbdoc: The states of each gamepad button, #GLFW_PRESS or #GLFW_RELEASE.
	End Rem
	Field StaticArray buttons:Byte[15]
	Rem
	bbdoc: The states of each gamepad axis, in the range -1.0 to 1.0 inclusive.
	End Rem
	Field StaticArray axes:Float[6]
End Struct
