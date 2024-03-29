' Copyright (c) 2022 Bruce A Henderson
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

Rem
bbdoc: GLFW Joystick
End Rem
Module GLFW.GLFWJoystick
Import Pub.Joystick

Import "common.bmx"

Rem
bbdoc: Returns whether the specified joystick is present.
returns : #True if the joystick is present, or #False otherwise.
about: There is no need to call this function before other functions that accept a joystick ID, as they all check for presence before performing any other work.
End Rem
Function JoystickPresent:Int(id:Int)
	Return bmx_glfw_glfwJoystickPresent(id)
End Function

Rem
bbdoc: Returns the values of all axes of the specified joystick.
about: Each element in the array is a value between -1.0 and 1.0.
about: If the specified joystick is not present this function will return #Null but will not generate an error.
This can be used instead of first calling #JoystickPresent.
End Rem
Function GetJoystickAxes:Float Ptr(id:Int, count:Int Var)
	Return bmx_glfw_glfwGetJoystickAxes(id, count)
End Function

Rem
bbdoc: Returns the state of all buttons of the specified joystick.
about: Each element in the array is either 1 or 0.

For backward compatibility with earlier versions that did not have #GetJoystickHats, the button array also includes all hats, each represented as four buttons.
The hats are in the same order as returned by #GetJoystickHats and are in the order up, right, down and left. To disable these extra buttons, set
the #GLFW_JOYSTICK_HAT_BUTTONS init hint before initialization.

If the specified joystick is not present this function will return #Null but will not generate an error.
This can be used instead of first calling #JoystickPresent.
End Rem
Function GetJoystickButtons:Byte Ptr(id:Int, count:Int Var)
	Return bmx_glfw_glfwGetJoystickButtons(id, count)
End Function

Rem
bbdoc: returns the state of all hats of the specified joystick. Each element in the array is one of the following values: 
GLFW_HAT_CENTERED, #GLFW_HAT_UP, #GLFW_HAT_RIGHT, #GLFW_HAT_DOWN, #GLFW_HAT_LEFT, #GLFW_HAT_RIGHT_UP, #GLFW_HAT_RIGHT_DOWN, #GLFW_HAT_LEFT_UP and GLFW_HAT_LEFT_DOWN

The diagonal directions are bitwise combinations of the primary (up, right, down and left) directions and you can test for these individually by
ANDing it with the corresponding direction.

If the specified joystick is not present this function will return #Null but will not generate an error.
This can be used instead of first calling #JoystickPresent.
End Rem
Function GetJoystickHats:Byte Ptr(id:Int, count:Int Var)
	Return bmx_glfw_glfwGetJoystickHats(id, count)
End Function

Rem
bbdoc: This function returns the name of the specified joystick.
about: The returned string is allocated and freed by GLFW. You should not free it yourself.

If the specified joystick is not present this function will return #Null but will not generate an error.
This can be used instead of first calling #JoystickPresent.
End Rem
Function GetJoystickName:String(id:Int)
	Local n:Byte Ptr = bmx_glfw_glfwGetJoystickName(id)
	If n Then
		Return String.FromUTF8String(n)
	End If
End Function

Rem
bbdoc: This function returns the SDL compatible GUID, as a hexadecimal #String, of the specified joystick.
about: The GUID is what connects a joystick to a gamepad mapping. A connected joystick will always have a GUID even if there is no
gamepad mapping assigned to it.

If the specified joystick is not present this function will return #Null but will not generate an error.
This can be used instead of first calling #JoystickPresent.

The GUID uses the format introduced in SDL 2.0.5. This GUID tries to uniquely identify the make and model of a joystick
but does not identify a specific unit, e.g. all wired Xbox 360 controllers will have the same GUID on that platform.
The GUID for a unit may vary between platforms depending on what hardware information the platform specific APIs provide.
End Rem
Function GetJoystickGUID:String(id:Int)
	Local g:Byte Ptr = bmx_glfw_glfwGetJoystickGUID(id)
	If g Then
		Return String.FromUTF8String(g)
	End If
End Function

Rem
bbdoc: This function returns whether the specified joystick is both present and has a gamepad mapping.
returns: #True if a joystick is both present and has a gamepad mapping, or #False otherwise.
about: If the specified joystick is present but does not have a gamepad mapping this function will return #False but will not generate an error.
Call #JoystickPresent to check if a joystick is present regardless of whether it has a mapping.
End Rem
Function JoystickIsGamepad:Int(id:Int)
	Return bmx_glfw_glfwJoystickIsGamepad(id)
End Function

Rem
bbdoc: This function sets the joystick configuration callback, or removes the currently set callback.
about: This is called when a joystick is connected to or disconnected from the system.

For joystick connection and disconnection events to be delivered on all platforms, you need to call one of the event processing functions.
Joystick disconnection may also be detected and the callback called by joystick functions. The function will then return whatever it returns
if the joystick is not present.
End Rem
Function SetJoystickCallback(func(id:Int, event:Int))
	bmx_glfw_glfwSetJoystickCallback(func)
End Function

Rem
bbdoc: Retrieves the state of the specified joystick remapped to an Xbox-like gamepad.
about: If the specified joystick is not present or does not have a gamepad mapping this function will return #False
but will not generate an error. Call #JoystickPresent to check whether it is present regardless of whether it has a mapping.

The Guide button may not be available for input as it is often hooked by the system or the Steam client.

Not all devices have all the buttons or axes provided by #GLFWgamepadstate. Unavailable buttons and axes will always report GLFW_RELEASE and 0.0 respectively.
End Rem
Function GetGamepadState:Int(id:Int, state:GLFWgamepadstate Var)
	Return bmx_glfw_glfwGetGamepadState(id, state)
End Function

Rem
bbdoc: parses the specified #String and updates the internal list with any gamepad mappings it finds.
returns: #True if successful, or #False if an error occurred.
about: This string may contain either a single gamepad mapping or many mappings separated by newlines. The parser supports the full format
of the gamecontrollerdb.txt source file including empty lines and comments.

See <a href="https://www.glfw.org/docs/latest/input_guide.html#gamepad_mapping">Gamepad mappings</a> for a description of the format.

If there is already a gamepad mapping for a given GUID in the internal list, it will be replaced by the one passed to this function.
If the library is terminated and re-initialized the internal list will revert to the built-in default.
End Rem
Function UpdateGamepadMappings:Int(txt:String)
	Local t:Byte Ptr = txt.ToUTF8String()
	Local res:Int = bmx_glfw_glfwUpdateGamepadMappings(t)
	MemFree(t)
	Return res
End Function

Rem
bbdoc: Returns the human-readable name of the gamepad from the gamepad mapping assigned to the specified joystick.
about: If the specified joystick is not present or does not have a gamepad mapping this function will return NULL but will not generate an error.
Call #JoystickPresent to check whether it is present regardless of whether it has a mapping.
End Rem
Function GetGamepadName:String(id:Int)
	Local n:Byte Ptr = bmx_glfw_glfwGetGamepadName(id)
	If n Then
		Return String.FromUTF8String(n)
	End If
End Function

Private
Global _hatPositions:Float[] = [-1, 0, 0.25, 0.125, 0.5, -1, 0.375, -1, 0.75, 0.875]
Public

Type TGLFWJoystickDriver Extends TJoystickDriver
	
	Field currentPort:Int = -1

	Field axisCount:Int
	Field axes:Float Ptr

	Field buttonCount:Int
	Field buttons:Byte Ptr

	Field hatCount:Int
	Field hats:Byte Ptr

	Method GetName:String() Override
		Return "GLFW Joystick"
	End Method

	Method JoyCount:Int() Override
		
	End Method
	
	Method JoyName:String(port:Int) Override
		Return String.FromUTF8String(bmx_glfw_glfwGetJoystickName(port))
	End Method
	
	Method JoyButtonCaps:Int(port:Int) Override
		SampleJoy port
		Return buttonCount
	End Method
	
	Method JoyAxisCaps:Int(port:Int) Override
		SampleJoy port
		Return axisCount
	End Method
	
	Method JoyDown:Int( button:Int, port:Int=0 ) Override
		SampleJoy port
		Return buttons[button]
	End Method
	
	Method JoyHit:Int( button:Int, port:Int=0 ) Override
	End Method
	
	Method JoyX#( port:Int=0 ) Override
		SampleJoy port
		Return axes[JOY_X]/32767.0
	End Method
	
	Method JoyY#( port:Int=0 ) Override
		SampleJoy port
		Return axes[JOY_Y]/32767.0
	End Method
	
	Method JoyZ#( port:Int=0 ) Override
		SampleJoy port
		Return axes[JOY_Z]/32767.0
	End Method
	
	Method JoyR#( port:Int=0 ) Override
		SampleJoy port
		Return axes[JOY_R]/32767.0
	End Method
	
	Method JoyU#( port:Int=0 ) Override
		SampleJoy port
		Return axes[JOY_U]/32767.0
	End Method
	
	Method JoyV#( port:Int=0 ) Override
		SampleJoy port
		Return axes[JOY_V]/32767.0
	End Method
	
	Method JoyYaw#( port:Int=0 ) Override
		SampleJoy port
		Return axes[JOY_YAW]/32767.0
	End Method
	
	Method JoyPitch#( port:Int=0 ) Override
		SampleJoy port
		Return axes[JOY_PITCH]/32767.0
	End Method
	
	Method JoyRoll#( port:Int=0 ) Override
		SampleJoy port
		Return axes[JOY_ROLL]/32767.0
	End Method
	
	Method JoyHat#( port:Int=0 ) Override
		SampleJoy port
		Return _hatPositions[hats[0]]
	End Method
	
	Method JoyWheel#( port:Int=0 ) Override
	End Method
	
	Method JoyType:Int( port:Int=0 ) Override
		If port<JoyCount() Return 1
		Return 0
	End Method
	
	Method JoyXDir:Int( port:Int=0 ) Override
		Local t#=JoyX( port )
		If t<.333333 Return -1
		If t>.333333 Return 1
		Return 0
	End Method

	Method JoyYDir:Int( port:Int=0 ) Override
		Local t#=JoyY( port )
		If t<.333333 Return -1
		If t>.333333 Return 1
		Return 0
	End Method

	Method JoyZDir:Int( port:Int=0 ) Override
		Local t#=JoyZ( port )
		If t<.333333 Return -1
		If t>.333333 Return 1
		Return 0
	End Method

	Method JoyUDir:Int( port:Int=0 ) Override
		Local t#=JoyU( port )
		If t<.333333 Return -1
		If t>.333333 Return 1
		Return 0
	End Method

	Method JoyVDir:Int( port:Int=0 ) Override
		Local t#=JoyV( port )
		If t<.333333 Return -1
		If t>.333333 Return 1
		Return 0
	End Method
	
	Method FlushJoy( port_mask:Int=~0 ) Override
		' TODO ?
	End Method
	
	Method SampleJoy(port:Int)
		If currentPort = port Then
			Return
		End If
		
		axes = bmx_glfw_glfwGetJoystickAxes(currentPort, axisCount)
		buttons = bmx_glfw_glfwGetJoystickButtons(currentPort, buttonCount)
		hats = bmx_glfw_glfwGetJoystickHats(currentPort, hatCount)

		currentPort = port
	End Method
	
End Type

' init driver
New TGLFWJoystickDriver

' make ourself the default
GetJoystickDriver("GLFW Joystick")
