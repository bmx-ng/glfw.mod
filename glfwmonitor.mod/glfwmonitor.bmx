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
bbdoc: GLFW Monitor
End Rem
Module GLFW.GLFWMonitor

Import "common.bmx"

Rem
bbdoc: A GLFW Monitor
End Rem
Type TGLFWMonitor

	Field monitorPtr:Byte Ptr

	Global monitorCallback(monitor:TGLFWMonitor, event:Int)

	Function _create:TGLFWMonitor(monitorPtr:Byte Ptr)
		If monitorPtr Then
			Local this:TGLFWMonitor = New TGLFWMonitor
			this.monitorPtr = monitorPtr
			Return this
		End If
	End Function

	Rem
	bbdoc: Returns an array of handles for all currently connected monitors.
	about: The primary monitor is always first in the returned array. If no monitors were found, this function returns #Null.
	End Rem
	Function GetMonitors:TGLFWMonitor[]()
		Local count:Int
		Local mptrs:Byte Ptr Ptr = bmx_glfw_glfwGetMonitors(count)
		Local monitors:TGLFWMonitor[count]
		For Local i:Int = 0 Until count
			monitors[i] = _create(mptrs[i])
		Next
		Return monitors
	End Function
	
	Rem
	bbdoc: Returns the primary monitor.
	about: This is usually the monitor where elements like the task bar or global menu bar are located.
	End Rem
	Function GetPrimaryMonitor:TGLFWMonitor()
		Return _create(bmx_glfw_glfwGetPrimaryMonitor())
	End Function
	
	Rem
	bbdoc: Returns the position, in screen coordinates, of the upper-left corner of the monitor.
	End Rem
	Method GetPos(x:Int Var, y:Int Var)
		bmx_glfw_glfwGetMonitorPos(monitorPtr, x, y)
	End Method
	
	Rem
	bbdoc: Returns the position, in screen coordinates, of the upper-left corner of the work area of the monitor along with the work area size in screen coordinates.
	about: The work area is defined as the area of the monitor not occluded by the operating system task bar where present.
	If no task bar exists then the work area is the monitor resolution in screen coordinates.
	End Rem
	Method GetWorkarea(x:Int Var, y:Int Var, width:Int Var, height:Int Var)
		bmx_glfw_glfwGetMonitorWorkarea(monitorPtr, x, y, width, height)
	End Method
	
	Rem
	bbdoc: Returns the size, in millimetres, of the display area of the monitor.
	about: Some systems do not provide accurate monitor size information, either because the monitor EDID data is incorrect
	or because the driver does not report it accurately.
	End Rem
	Method GetPhysicalSize(widthMM:Int Var, heightMM:Int Var)
		bmx_glfw_glfwGetMonitorPhysicalSize(monitorPtr, widthMM, heightMM)
	End Method
	
	Rem
	bbdoc: Retrieves the content scale for the monitor.
	about: The content scale is the ratio between the current DPI and the platform's default DPI. This is especially
	important for text and any UI elements. If the pixel dimensions of your UI scaled by this look appropriate on your
	machine then it should appear at a reasonable size on other machines regardless of their DPI and scaling settings.
	This relies on the system DPI and scaling settings being somewhat correct.

	The content scale may depend on both the monitor resolution and pixel density and on user settings. It may be very
	different from the raw DPI calculated from the physical size and current resolution.
	End Rem
	Method GetContentScale(xscale:Float Var, yscale:Float Var)
		bmx_glfw_glfwGetMonitorContentScale(monitorPtr, xscale, yscale)
	End Method
	
	Rem
	bbdoc: Returns a human-readable name of the monitor.
	about: The name typically reflects the make and model of the monitor and is not guaranteed to be unique among the connected monitors.
	End Rem
	Method GetName:String()
		Local b:Byte Ptr = bmx_glfw_glfwGetMonitorName(monitorPtr)
		Return String.FromUTF8String(b)
	End Method
	
	Rem
	bbdoc: Returns an array of all video modes supported by the monitor.
	about: The returned array is sorted in ascending order, first by color bit depth (the sum of all channel depths) and
	then by resolution area (the product of width and height).
	End Rem
	Method GetVideoModes:SGLFWvidmode[]()
		Local count:Int
		Local mptrs:SGLFWvidmode Ptr= bmx_glfw_glfwGetVideoModes(monitorPtr, count)
		Local modes:SGLFWvidmode[count]
		For Local i:Int = 0 Until count
			modes[i] = mptrs[i]
		Next
		Return modes
	End Method
	
	Rem
	bbdoc: Returns the current video mode of the monitor.
	about: If you have created a full screen window for that monitor, the return value will depend on whether that window is iconified.
	End Rem
	Method GetVideoMode:SGLFWvidmode()
		Local mptr:SGLFWvidmode Ptr= bmx_glfw_glfwGetVideoMode(monitorPtr)
		Return mptr[0]
	End Method
	
	Rem
	bbdoc: Generates an appropriately sized gamma ramp from the specified exponent and then calls #SetGammaRamp with it.
	about: The value must be a finite number greater than zero.

	The software controlled gamma ramp is applied in addition to the hardware gamma correction, which today is usually
	an approximation of sRGB gamma. This means that setting a perfectly linear ramp, or gamma 1.0, will produce the
	default (usually sRGB-like) behavior.

	For gamma correct rendering with OpenGL or OpenGL ES, see the #GLFW_SRGB_CAPABLE hint.
	End Rem
	Method SetGamma(Gamma:Float)
		bmx_glfw_glfwSetGamma(monitorPtr, Gamma)
	End Method
	
	Rem
	bbdoc: Returns the current gamma ramp of the monitor.
	End Rem
	Method GetGammaRamp:SGLFWgammaramp()
		Return bmx_glfw_glfwGetGammaRamp(monitorPtr)[0]
	End Method
	
	Rem
	bbdoc: Sets the current gamma ramp for the monitor.
	about: The original gamma ramp for that monitor is saved by GLFW the first time this method is called and is restored by glfwTerminate.

	The software controlled gamma ramp is applied in addition to the hardware gamma correction, which today is usually an approximation
	of sRGB gamma. This means that setting a perfectly linear ramp, or gamma 1.0, will produce the default (usually sRGB-like) behavior.

	For gamma correct rendering with OpenGL or OpenGL ES, see the GLFW_SRGB_CAPABLE hint.
	End Rem
	Method SetGammaRamp(ramp:SGLFWgammaramp)
		bmx_glfw_glfwSetGammaRamp(monitorPtr, Varptr ramp)
	End Method
	
	Rem
	bbdoc: Sets the monitor configuration callback, or removes the currently set callback.
	about: This is called when a monitor is connected to or disconnected from the system.
	End Rem
	Method SetMonitorCallback(callback(monitor:TGLFWMonitor, event:Int))
		monitorCallback = callback
		If callback = Null Then
			bmx_glfw_glfwSetMonitorCallback(Null)
		Else
			bmx_glfw_glfwSetMonitorCallback(_monitorCallback)
		End If
	End Method

	Function _monitorCallback(handle:Byte Ptr, event:Int)
		monitorCallback(_create(handle), event)
	End Function

End Type

Rem
bbdoc: Video mode type.
End Rem
Struct SGLFWvidmode
	Rem
	bbdoc: The width, in screen coordinates, of the video mode.
	End Rem
	Field width:Int
	Rem
	bbdoc: The height, in screen coordinates, of the video mode.
	End Rem
	Field height:Int
	Rem
	bbdoc: The bit depth of the red channel of the video mode.
	End Rem
	Field redBits:Int
	Rem
	bbdoc: The bit depth of the green channel of the video mode.
	End Rem
	Field greenBits:Int
	Rem
	bbdoc: The bit depth of the blue channel of the video mode.
	End Rem
	Field blueBits:Int
	Rem
	bbdoc: The refresh rate, in Hz, of the video mode.
	End Rem
	Field refreshRate:Int
End Struct

Rem
bbdoc: Gamma ramp.
End Rem
Struct SGLFWgammaramp
	Rem
	bbdoc: An array of value describing the response of the red channel.
	End Rem
	Field red:Short Ptr
	Rem
	bbdoc: An array of value describing the response of the green channel.
	End Rem
	Field green:Short Ptr
	Rem
	bbdoc: An array of value describing the response of the blue channel.
	End Rem
	Field blue:Short Ptr
	Rem
	bbdoc: The number of elements in each array.
	End Rem
	Field size:UInt
End Struct

Private

Extern
	Function bmx_glfw_glfwGetVideoModes:SGLFWvidmode Ptr(monitor:Byte Ptr, count:Int Var)="glfwGetVideoModes"
	Function bmx_glfw_glfwGetVideoMode:SGLFWvidmode Ptr(monitor:Byte Ptr)="glfwGetVideoMode"
	Function bmx_glfw_glfwGetGammaRamp:SGLFWgammaramp Ptr(monitor:Byte Ptr)="glfwGetGammaRamp"
	Function bmx_glfw_glfwSetGammaRamp(monitorPtr:Byte Ptr, ramp:SGLFWgammaramp Ptr)="glfwSetGammaRamp"
End Extern
