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

Rem
bbdoc: GLFW Window.
End Rem
Module GLFW.GLFWWindow

Import "common.bmx"

Rem
bbdoc: A GLFW Window.
End Rem
Type TGLFWWindow

	Field windowPtr:Byte Ptr

	Rem
	bbdoc: Resets all window hints to their default values.
	End Rem
	Function DefaultHints()
		bmx_glfw_glfwDefaultWindowHints()
	End Function
	
	Rem
	bbdoc: Sets hints for the next call to #Create.
	about: The hints, once set, retain their values until changed by a call to this function or #DefaultHints, or until the library is terminated.

	Only integer value hints can be set with this function. String value hints are set with #HintString.

	This function does not check whether the specified hint values are valid. If you set hints to invalid values this will
	instead be reported by the next call to #Create.

	Some hints are platform specific. These may be set on any platform but they will only affect their specific platform.
	Other platforms will ignore them. Setting these hints requires no platform specific headers or functions.
	End Rem
	Function Hint(hint:Int, value:Int)
		bmx_glfw_glfwWindowHint(hint, value)
	End Function
	
	Rem
	bbdoc: Sets hints for the next call to #Create.
	about: The hints, once set, retain their values until changed by a call to this function or #DefaultHints, or until the library is terminated.

	Only #String type hints can be set with this function. Integer value hints are set with #Hint.

	This function does not check whether the specified hint values are valid. If you set hints to invalid values this will
	instead be reported by the next call to #Create.

	Some hints are platform specific. These may be set on any platform but they will only affect their specific platform.
	Other platforms will ignore them. Setting these hints requires no platform specific headers or functions.
	End Rem
	Function HintString(hint:Int, value:String)
		Local v:Byte Ptr = value.ToUTF8String()
		bmx_glfw_glfwWindowHintString(hint, v)
		MemFree(v)
	End Function
	
	Rem
	bbdoc: Creates a new TGLFWWindow instance with the specified parameters.
	End Rem
	Method Create:TGLFWWindow(width:Int, height:Int, title:String, monitor:TGLFWMonitor = Null, share:TGLFWWindow = Null)
		Local t:Byte Ptr = title.ToUTF8String()
		If monitor Then
			If share Then
				windowPtr = bmx_glfw_glfwCreateWindow(width, height, title, monitor.monitorPtr, share.windowPtr)
			Else
				windowPtr = bmx_glfw_glfwCreateWindow(width, height, title, monitor.monitorPtr, Null)
			End If
		Else
			If share Then
				windowPtr = bmx_glfw_glfwCreateWindow(width, height, title, Null, share.windowPtr)
			Else
				windowPtr = bmx_glfw_glfwCreateWindow(width, height, title, Null, Null)
			End If
		End If
		
		If Not windowPtr Then
			Return Null
		End If
		
		' data for callbacks
		bmx_glfw_glfwSetWindowUserPointer(windowPtr, Self)
		' callbacks
		bmx_glfw_glfwSetWindowPosCallback(windowPtr, _OnPosition)
		bmx_glfw_glfwSetWindowSizeCallback(windowPtr, _OnSize)
		bmx_glfw_glfwSetWindowCloseCallback(windowPtr, _OnClose)
		bmx_glfw_glfwSetWindowRefreshCallback(windowPtr, _OnRefresh)
		bmx_glfw_glfwSetWindowFocusCallback(windowPtr, _OnFocus)
		bmx_glfw_glfwSetWindowIconifyCallback(windowPtr, _OnIconify)
		bmx_glfw_glfwSetWindowMaximizeCallback(windowPtr, _OnMaximize)
		bmx_glfw_glfwSetFramebufferSizeCallback(windowPtr, _OnFramebufferSize)
		bmx_glfw_glfwSetWindowContentScaleCallback(windowPtr, _OnContentScale)
		bmx_glfw_glfwSetMouseButtonCallback(windowPtr, _OnMouseButton)
		bmx_glfw_glfwSetCursorPosCallback(windowPtr, _OnCursorPosition)
		bmx_glfw_glfwSetCursorEnterCallback(windowPtr, _OnCursorEnter)
		bmx_glfw_glfwSetScrollCallback(windowPtr, _OnScroll)
		bmx_glfw_glfwSetKeyCallback(windowPtr, _OnKey)
		bmx_glfw_glfwSetCharCallback(windowPtr, _OnChar)
		bmx_glfw_glfwSetCharModsCallback(windowPtr, _OnCharMods)
		
		Return Self
	End Method

	Rem
	bbdoc: 
	End Rem
	Method Destroy()
		bmx_glfw_glfwDestroyWindow(windowPtr)
	End Method
	
	Rem
	bbdoc: Returns the value of the close flag of the window.
	End Rem
	Method ShouldClose:Int()
		Return bmx_glfw_glfwWindowShouldClose(windowPtr)
	End Method
	
	Rem
	bbdoc: Sets the value of the close flag of the window.
	about: This can be used to override the user's attempt to close the window, or to signal that it should be closed.
	End Rem
	Method SetShouldClose(value:Int)
		bmx_glfw_glfwSetWindowShouldClose(windowPtr, value)
	End Method
	
	Rem
	bbdoc: Sets the window title.
	End Rem
	Method SetTitle(title:String)
		Local t:Byte Ptr = title.ToUTF8String()
		bmx_glfw_glfwSetWindowTitle(windowPtr, t)
		MemFree(t)
	End Method
	
	'Method SetIcon()
	'End Method
	
	Rem
	bbdoc: 
	End Rem
	Method GetPos(x:Int Var, y:Int Var)
		bmx_glfw_glfwGetWindowPos(windowPtr, x, y)
	End Method
	
	Rem
	bbdoc: 
	End Rem
	Method SetPos(x:Int, y:Int)
		bmx_glfw_glfwSetWindowPos(windowPtr, x, y)
	End Method
	
	Rem
	bbdoc: 
	End Rem
	Method GetSize(w:Int Var, h:Int Var)
		bmx_glfw_glfwGetWindowSize(windowPtr, w, h)
	End Method
	
	Rem
	bbdoc: 
	End Rem
	Method SetSizeLimits(minWidth:Int, minHeight:Int, maxWidth:Int, maxHeight:Int)
		bmx_glfw_glfwSetWindowSizeLimits(windowPtr, minWidth, minHeight, maxWidth, maxHeight)
	End Method
	
	Rem
	bbdoc: 
	End Rem
	Method SetAspectRatio(numer:Int, denom:Int)
		bmx_glfw_glfwSetWindowAspectRatio(windowPtr, numer, denom)
	End Method
	
	Rem
	bbdoc: 
	End Rem
	Method SetSize(w:Int, h:Int)
		bmx_glfw_glfwSetWindowSize(windowPtr, w, h)
	End Method

	Rem
	bbdoc: 
	End Rem
	Method GetFramebufferSize(width:Int Var, height:Int Var)
		bmx_glfw_glfwGetFramebufferSize(windowPtr, width, height)
	End Method
	
	Rem
	bbdoc: 
	End Rem
	Method GetFrameSize(Left:Int Var, top:Int Var, Right:Int Var, bottom:Int Var)
		bmx_glfw_glfwGetWindowFrameSize(windowPtr, Left, top, Right, bottom)
	End Method
	
	Rem
	bbdoc: 
	End Rem
	Method GetContentScale(xscale:Float Var, yscale:Float Var)
		bmx_glfw_glfwGetWindowContentScale(windowPtr, xscale, yscale)
	End Method
	
	Rem
	bbdoc: 
	End Rem
	Method GetOpacity:Float()
		Return bmx_glfw_glfwGetWindowOpacity(windowPtr)
	End Method
	
	Rem
	bbdoc: 
	End Rem
	Method SetOpacity(opacity:Float)
		bmx_glfw_glfwSetWindowOpacity(windowPtr, opacity)
	End Method
	
	Rem
	bbdoc: 
	End Rem
	Method Iconify()
		bmx_glfw_glfwIconifyWindow(windowPtr)
	End Method
	
	Rem
	bbdoc: Restores the specified window if it was previously iconified (minimized) or maximized.
	about: If the window is already restored, this method does nothing.

	If the specified window is a full screen window, the resolution chosen for the window is restored on the selected monitor.
	End Rem
	Method Restore()
		bmx_glfw_glfwRestoreWindow(windowPtr)
	End Method
	
	Rem
	bbdoc: Maximizes the specified window if it was previously not maximized.
	
	about: If the window is already maximized, this method does nothing.
	
	If the specified window is a full screen window, this method does nothing.
	End Rem
	Method Maximize()
		bmx_glfw_glfwMaximizeWindow(windowPtr)
	End Method
	
	Rem
	bbdoc: 
	End Rem
	Method Show()
		bmx_glfw_glfwShowWindow(windowPtr)
	End Method
	
	Rem
	bbdoc: 
	End Rem
	Method Hide()
		bmx_glfw_glfwHideWindow(windowPtr)
	End Method
	
	Rem
	bbdoc: 
	End Rem
	Method Focus()
		bmx_glfw_glfwFocusWindow(windowPtr)
	End Method
	
	Rem
	bbdoc: 
	End Rem
	Method RequestAttention()
		bmx_glfw_glfwRequestWindowAttention(windowPtr)
	End Method
	
	Rem
	bbdoc: Returns the monitor that the specified window is in full screen on.
	End Rem
	Method GetMonitor:TGLFWMonitor()
		Return TGLFWMonitor._create(bmx_glfw_glfwGetWindowMonitor(windowPtr))
	End Method
	
	Rem
	bbdoc: Sets the monitor that the window uses for full screen mode or, if the monitor is #Null, makes it windowed mode.
	about: When setting a monitor, this method updates the width, height and refresh rate of the desired video mode and switches
	to the video mode closest to it. The window position is ignored when setting a monitor.

	When the monitor is #Null, the position, width and height are used to place the window content area. The refresh rate
	is ignored when no monitor is specified.

	If you only wish to update the resolution of a full screen window or the size of a windowed mode window, see #SetSize.

	When a window transitions from full screen to windowed mode, this method restores any previous window settings such as whether
	it is decorated, floating, resizable, has size or aspect ratio limits, etc.
	End Rem
	Method SetMonitor(monitor:TGLFWMonitor, xpos:Int, ypos:Int, width:Int, height:Int, refreshRate:Int)
		If monitor Then
			bmx_glfw_glfwSetWindowMonitor(windowPtr, monitor.monitorPtr, xpos, ypos, width, height, refreshRate)
		Else
			bmx_glfw_glfwSetWindowMonitor(windowPtr, Null, xpos, ypos, width, height, refreshRate)
		End If
	End Method
	
	Rem
	bbdoc: 
	End Rem
	Method GetAttrib:Int(attrib:Int)
		Return bmx_glfw_glfwGetWindowAttrib(windowPtr, attrib)
	End Method
	
	Rem
	bbdoc: 
	End Rem
	Method SetAttrib(attrib:Int, value:Int)
		bmx_glfw_glfwSetWindowAttrib(windowPtr, attrib, value)
	End Method
	
	Rem
	bbdoc: 
	End Rem
	Method MakeContextCurrent()
		bmx_glfw_glfwMakeContextCurrent(windowPtr)
	End Method
	
	Rem
	bbdoc: 
	End Rem
	Method SwapBuffers()
		bmx_glfw_glfwSwapBuffers(windowPtr)
	End Method
	
	Rem
	bbdoc: 
	End Rem
	Method GetKey:Int(key:Int)
		Return bmx_glfw_glfwGetKey(windowPtr, key)
	End Method
	
	Rem
	bbdoc: 
	End Rem
	Method IsKeyDown:Int(key:Int)
		Return bmx_glfw_glfwGetKey(windowPtr, key) <> GLFW_RELEASE
	End Method
	
	Rem
	bbdoc: Called when the window position changes.
	End Rem
	Method OnPosition(x:Int, y:Int)
	End Method
	
	Rem
	bbdoc: Called when the window changes size.
	End Rem
	Method OnSize(width:Int, height:Int)
	End Method
	
	Rem
	bbdoc: Called when the user attempts to close the window, for example by clicking the close widget in the title bar.
	about: The close flag is set before this callback is called, but you can modify it at any time with #SetShouldClose.
	End Rem
	Method OnClose()
	End Method
	
	Rem
	bbdoc: Called when the content area of the window needs to be redrawn, for example if the window has been exposed after having been covered by another window.
	about: On compositing window systems such as Aero, Compiz, Aqua or Wayland, where the window contents are saved
	off-screen, this callback may be called only very infrequently or never at all.
	End Rem
	Method OnRefresh()
	End Method
	
	Rem
	bbdoc: Called when the window gains or loses input focus.
	about: After the focus callback is called for a window that lost input focus, synthetic key and mouse button release events
	will be generated for all such that had been pressed.
	
	For more information, see #OnKey and #OnMouseButton.
	End Rem
	Method OnFocus(focused:Int)
	End Method
	
	Rem
	bbdoc: 
	End Rem
	Method OnIconify(iconified:Int)
	End Method
	
	Rem
	bbdoc: 
	End Rem
	Method OnMaximize(maximized:Int)
	End Method
	
	Rem
	bbdoc: 
	End Rem
	Method OnFramebufferSize(width:Int, height:Int)
	End Method
	
	Rem
	bbdoc: 
	End Rem
	Method OnContentScale(xScale:Float, yScale:Float)
	End Method

	Rem
	bbdoc: 
	End Rem
	Method OnMouseButton(button:Int, action:Int, mods:Int)
	End Method
	
	Rem
	bbdoc: 
	End Rem
	Method OnCursorPosition(x:Double, y:Double)
	End Method
	
	Rem
	bbdoc: 
	End Rem
	Method OnCursorEnter(entered:Int)
	End Method
	
	Rem
	bbdoc: 
	End Rem
	Method OnScroll(xOffset:Double, yOffset:Double)
	End Method
	
	Rem
	bbdoc: 
	End Rem
	Method OnKey(key:Int, scancode:Int, action:Int, mods:Int)
	End Method
	
	Rem
	bbdoc: 
	End Rem
	Method OnChar(char:UInt)
	End Method
	
	Rem
	bbdoc: 
	End Rem
	Method OnCharMods(codepoint:UInt, mods:Int)
	End Method
	
	'Method OnDrop()
	'End Method


Private	
	Function _OnPosition(windowPtr:Byte Ptr, x:Int, y:Int)
		Local window:TGLFWWindow = bmx_glfw_glfwGetWindowUserPointer(windowPtr)
		window.OnPosition(x, y)
	End Function
	
	Function _OnSize(windowPtr:Byte Ptr, width:Int, height:Int)
		Local window:TGLFWWindow = bmx_glfw_glfwGetWindowUserPointer(windowPtr)
		window.OnSize(width, height)
	End Function
	
	Function _OnClose(windowPtr:Byte Ptr)
		Local window:TGLFWWindow = bmx_glfw_glfwGetWindowUserPointer(windowPtr)
		window.OnClose()
	End Function
	
	Function _OnRefresh(windowPtr:Byte Ptr)
		Local window:TGLFWWindow = bmx_glfw_glfwGetWindowUserPointer(windowPtr)
		window.OnRefresh()
	End Function
	
	Function _OnFocus(windowPtr:Byte Ptr, focused:Int)
		Local window:TGLFWWindow = bmx_glfw_glfwGetWindowUserPointer(windowPtr)
		window.OnFocus(focused)
	End Function
	
	Function _OnIconify(windowPtr:Byte Ptr, iconified:Int)
		Local window:TGLFWWindow = bmx_glfw_glfwGetWindowUserPointer(windowPtr)
		window.OnIconify(iconified)
	End Function
	
	Function _OnMaximize(windowPtr:Byte Ptr, maximized:Int)
		Local window:TGLFWWindow = bmx_glfw_glfwGetWindowUserPointer(windowPtr)
		window.OnMaximize(maximized)
	End Function
	
	Function _OnFramebufferSize(windowPtr:Byte Ptr, width:Int, height:Int)
		Local window:TGLFWWindow = bmx_glfw_glfwGetWindowUserPointer(windowPtr)
		window.OnFramebufferSize(width, height)
	End Function
	
	Function _OnContentScale(windowPtr:Byte Ptr, xScale:Float, yScale:Float)
		Local window:TGLFWWindow = bmx_glfw_glfwGetWindowUserPointer(windowPtr)
		window.OnContentScale(xScale, yScale)
	End Function

	Function _OnMouseButton(windowPtr:Byte Ptr, button:Int, action:Int, mods:Int)
		Local window:TGLFWWindow = bmx_glfw_glfwGetWindowUserPointer(windowPtr)
		window.OnMouseButton(button, action, mods)
	End Function
	
	Function _OnCursorPosition(windowPtr:Byte Ptr, x:Double, y:Double)
		Local window:TGLFWWindow = bmx_glfw_glfwGetWindowUserPointer(windowPtr)
		window.OnCursorPosition(x, y)
	End Function
	
	Function _OnCursorEnter(windowPtr:Byte Ptr, entered:Int)
		Local window:TGLFWWindow = bmx_glfw_glfwGetWindowUserPointer(windowPtr)
		window.OnCursorEnter(entered)
	End Function
	
	Function _OnScroll(windowPtr:Byte Ptr, xOffset:Double, yOffset:Double)
		Local window:TGLFWWindow = bmx_glfw_glfwGetWindowUserPointer(windowPtr)
		window.OnScroll(xOffset, yOffset)
	End Function
	
	Function _OnKey(windowPtr:Byte Ptr, key:Int, scancode:Int, action:Int, mods:Int)
		Local window:TGLFWWindow = bmx_glfw_glfwGetWindowUserPointer(windowPtr)
		window.OnKey(key, scancode, action, mods)
	End Function
	
	Function _OnChar(windowPtr:Byte Ptr, char:UInt)
		Local window:TGLFWWindow = bmx_glfw_glfwGetWindowUserPointer(windowPtr)
		window.OnChar(char)
	End Function
	
	Function _OnCharMods(windowPtr:Byte Ptr, codepoint:UInt, mods:Int)
		Local window:TGLFWWindow = bmx_glfw_glfwGetWindowUserPointer(windowPtr)
		window.OnCharMods(codepoint, mods)
	End Function

End Type

Private

Extern
	Function bmx_glfw_glfwGetWindowUserPointer:TGLFWWindow(window:Byte Ptr)="glfwGetWindowUserPointer"
	Function bmx_glfw_glfwSetWindowUserPointer(window:Byte Ptr, win:TGLFWWindow)="glfwSetWindowUserPointer"
End Extern
