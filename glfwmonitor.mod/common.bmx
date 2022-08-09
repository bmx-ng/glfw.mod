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

Extern

	Function bmx_glfw_glfwGetMonitors:Byte Ptr Ptr(count:Int Var)="glfwGetMonitors"
	Function bmx_glfw_glfwGetPrimaryMonitor:Byte Ptr()="glfwGetPrimaryMonitor"
	Function bmx_glfw_glfwSetGamma(monitor:Byte Ptr, Gamma:Float)="glfwSetGamma"
	Function bmx_glfw_glfwGetMonitorPos(monitor:Byte Ptr, x:Int Var, y:Int Var)="glfwGetMonitorPos"
	Function bmx_glfw_glfwGetMonitorWorkarea(monitor:Byte Ptr, x:Int Var, y:Int Var, width:Int Var, height:Int Var)="glfwGetMonitorWorkarea"
	Function bmx_glfw_glfwGetMonitorPhysicalSize(monitor:Byte Ptr, widthMM:Int Var, heightMM:Int Var)="glfwGetMonitorPhysicalSize"
	Function bmx_glfw_glfwGetMonitorContentScale(monitor:Byte Ptr, xscale:Float Var, yscale:Float Var)="glfwGetMonitorContentScale"
	Function bmx_glfw_glfwGetMonitorName:Byte Ptr(monitor:Byte Ptr)="glfwGetMonitorName"
	Function bmx_glfw_glfwSetMonitorCallback(cb(monitor:Byte Ptr, event:Int))="glfwSetMonitorCallback"

End Extern