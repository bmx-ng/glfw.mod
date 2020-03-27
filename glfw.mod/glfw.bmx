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

Module GLFW.GLFW

ModuleInfo "CC_OPTS: -std=c99"

?win32
ModuleInfo "CC_OPTS: -D_GLFW_WIN32"
?osx
ModuleInfo "CC_OPTS: -D_GLFW_COCOA"
?linux And Not raspberrypi
ModuleInfo "CC_OPTS: -D_POSIX_C_SOURCE=199309L"
ModuleInfo "CC_OPTS: -D_GLFW_X11"
?raspberrypi
ModuleInfo "CC_OPTS: -D_GLFW_X11"
?


Import "common.bmx"


Rem
bbdoc: Returns the current GLFW time, in seconds.
about: Unless the time has been set using #glfwSetTime it measures time elapsed since GLFW was initialized.

The resolution of the timer is system dependent, but is usually on the order of a few micro- or nanoseconds.
It uses the highest-resolution monotonic time source on each supported platform.
End Rem
Function GetTime:Double()
	Return bmx_glfw_glfwGetTime()
End Function

Rem
bbdoc: Sets the current GLFW time, in seconds.
about: The value must be a positive finite number less than or equal to 18446744073.0, which is approximately 584.5 years.
End Rem
Function SetTime(time:Double)
	bmx_glfw_glfwSetTime(time)
End Function

Rem
bbdoc: Sets the system clipboard to the specified #String.
End Rem
Function SetClipboard(txt:String)
	Local t:Byte Ptr = txt.ToUTF8String()
	bmx_glfw_glfwSetClipboardString(Null, t)
	MemFree(t)
End Function

Rem
bbdoc: Returns the contents of the system clipboard, if it contains or is convertible to a #String.
about: If the clipboard is empty or if its contents cannot be converted, #Null is returned and a #GLFW_FORMAT_UNAVAILABLE error is generated.
End Rem
Function GetClipboard:String()
	Local t:Byte Ptr = bmx_glfw_glfwGetClipboardString(Null)
	If t Then
		Return String.FromUTF8String(t)
	End If
End Function

