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

Module GLFW.GLFWSystem

Import GLFW.GLFW
Import BRL.System

Import "common.bmx"


Type TGLFWSystemDriver Extends TSystemDriver

	Method New()
		bmx_glfw_glfwInit()
		OnEnd(bmx_glfw_glfwTerminate)
	End Method
	
	Method Poll() Override
		bmx_glfw_glfwPollEvents()
	End Method
	
	Method Wait() Override
		bmx_glfw_glfwWaitEvents()
	End Method

	Method Emit( osevent:Byte Ptr,source:Object )
		' TODO
	End Method

	Method SetMouseVisible( visible:Int ) Override

	End Method

	Method MoveMouse( x:Int,y:Int ) Override

	End Method

	Method Notify( Text$,serious:Int ) Override
	End Method
	
	Method Confirm:Int( Text$,serious:Int ) Override
	End Method
	
	Method Proceed:Int( Text$,serious:Int ) Override
	End Method

	Method RequestFile$( Text$,exts$,save:Int,file$ ) Override
		' TODO
	End Method
	
	Method RequestDir$( Text$,path$ ) Override
		' TODO
	End Method

	Method OpenURL:Int( url$ ) Override
		' TODO
	End Method

	Method DesktopWidth:Int() Override
	End Method
	
	Method DesktopHeight:Int() Override
	End Method
	
	Method DesktopDepth:Int() Override
	End Method
	
	Method DesktopHertz:Int() Override
	End Method

	Method Name:String() Override
		Return "GLFWSystemDriver"
	End Method
	
End Type

InitSystemDriver(New TGLFWSystemDriver)
