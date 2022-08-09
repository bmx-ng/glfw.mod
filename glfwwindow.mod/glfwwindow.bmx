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
bbdoc: GLFW Window.
End Rem
Module GLFW.GLFWWindow

Import "common.bmx"

Rem
bbdoc: Returns whether raw mouse motion is supported on the current system.
about: This status does not change after GLFW has been initialized so you only need to check this once.
If you attempt to enable raw motion on a system that does not support it, GLFW_PLATFORM_ERROR will be emitted.

Raw mouse motion is closer to the actual motion of the mouse across a surface. It is not affected by the scaling
and acceleration applied to the motion of the desktop cursor. That processing is suitable for a cursor while
raw motion is better for controlling for example a 3D camera. Because of this, raw mouse motion is only provided
when the cursor is disabled.
End Rem
Function RawMouseMotionSupported:Int()
	Return bmx_glfw_glfwRawMouseMotionSupported()
End Function 

Rem
bbdoc: Returns the name of the specified printable key.
about: This is typically the character that key would produce without any modifier keys, intended for displaying key
bindings to the user. For dead keys, it is typically the diacritic it would add to a character.

Do not use this function for text input. You will break text input for many languages even if it happens to work for yours.

If the key is GLFW_KEY_UNKNOWN, the scancode is used to identify the key, otherwise the scancode is ignored.
If you specify a non-printable key, or GLFW_KEY_UNKNOWN and a scancode that maps to a non-printable key, this
function returns #Null but does not emit an error.

This behavior allows you to always pass in the arguments in the key callback without modification.

Names for printable keys depend on keyboard layout, while names for non-printable keys are the same across
layouts but depend on the application language and should be localized along with other user interface text.
End Rem
Function GetKeyName:String(key:Int, scancode:Int)
	Local k:Byte Ptr = bmx_glfw_glfwGetKeyName(key, scancode)
	If k Then
		Return String.FromUTF8String(k)
	End If
End Function

Rem
bbdoc: Returns the platform-specific scancode of the specified key.
about: If the key is GLFW_KEY_UNKNOWN or does not exist on the keyboard this method will return -1.
End Rem
Function GetKeyScancode:Int(key:Int)
	Return bmx_glfw_glfwGetKeyScancode(key)
End Function

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
	bbdoc: Destroys the window and its context.
	about: On calling this method, no further callbacks will be called for that window.

	If the context of the window is current on the main thread, it is detached before being destroyed.
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
	
	Rem
	bbdoc: Sets the icon for the window.
	about: If passed an array of candidate pixmaps, those of or closest to the sizes desired by the system are
	selected.  If no images are specified, the window reverts to its default icon.

	The pixels are 32-bit, little-endian, non-premultiplied RGBA, i.e. eight bits per channel with the red channel first.
	They are arranged canonically as packed sequential rows, starting from the top-left corner.

	The desired image sizes varies depending on platform and system settings.
	The selected images will be rescaled as needed.  Good sizes include 16x16, 32x32 and 48x48.
	
	> On macOS the GLFW window has no icon, as it is not a document window, so this method does nothing.  The dock icon will be the same as the application bundle's icon.
	
	> On Wayland there is no existing protocol to change an icon, the window will thus inherit the one defined in the application's desktop file. This method always emits #GLFW_PLATFORM_ERROR.
	End Rem
	Method SetIcon(pixmaps:TPixmap[])
		If pixmaps.length = 0 Then
			bmx_glfw_glfwSetWindowIcon(windowPtr, 0, Null)
		Else
			Local images:GLFWimage[pixmaps.length]
			
			Local pixs:TPixmap[pixmaps.length] ' cache
			For Local i:Int = 0 Until pixmaps.length
				Local pix:TPixmap = pixmaps[i]
				If pix.format <> PF_RGBA8888 Then
					pix = pix.Convert(PF_RGBA8888)
				End If
				pixs[i] = pix
				
				images[i] = New GLFWimage(pix.width, pix.height, pix.pixels)
			Next
			
			bmx_glfw_glfwSetWindowIcon(windowPtr, pixmaps.length, images)
			pixs = Null ' refer to cache - prevent compiler optimizing it away because we don't reference it otherwise after the loop
		End If
	End Method
	
	Rem
	bbdoc: Retrieves the position, in screen coordinates, of the upper-left corner of the content area of the window.
	End Rem
	Method GetPos(x:Int Var, y:Int Var)
		bmx_glfw_glfwGetWindowPos(windowPtr, x, y)
	End Method
	
	Rem
	bbdoc: Sets the position, in screen coordinates, of the upper-left corner of the content area of the windowed mode window.
	about: If the window is a full screen window, this method does nothing.

	Do not use this method to move an already visible window unless you have very good reasons for doing so, as it will confuse and annoy the user.

	The window manager may put limits on what positions are allowed. GLFW cannot and should not override these limits.
	End Rem
	Method SetPos(x:Int, y:Int)
		bmx_glfw_glfwSetWindowPos(windowPtr, x, y)
	End Method
	
	Rem
	bbdoc: Retrieves the size, in screen coordinates, of the content area of the window.
	about: If you wish to retrieve the size of the framebuffer of the window in pixels, see #GetFramebufferSize.
	End Rem
	Method GetSize(w:Int Var, h:Int Var)
		bmx_glfw_glfwGetWindowSize(windowPtr, w, h)
	End Method
	
	Rem
	bbdoc: Sets the size limits of the content area of the window.
	about: If the window is full screen, the size limits only take effect once it is made windowed. If the window is not resizable,
	this method does nothing.

	The size limits are applied immediately to a windowed mode window and may cause it to be resized.

	The maximum dimensions must be greater than or equal to the minimum dimensions and all must be greater than or equal to zero.
	End Rem
	Method SetSizeLimits(minWidth:Int, minHeight:Int, maxWidth:Int, maxHeight:Int)
		bmx_glfw_glfwSetWindowSizeLimits(windowPtr, minWidth, minHeight, maxWidth, maxHeight)
	End Method
	
	Rem
	bbdoc: Sets the required aspect ratio of the content area of the window.
	about: If the window is full screen, the aspect ratio only takes effect once it is made windowed. If the window is not resizable,
	this method does nothing.

	The aspect ratio is specified as a numerator and a denominator and both values must be greater than zero. For example, the common 16:9 aspect ratio is specified as 16 and 9, respectively.

	If the numerator and denominator is set to `GLFW_DONT_CARE` then the aspect ratio limit is disabled.

	The aspect ratio is applied immediately to a windowed mode window and may cause it to be resized.
	End Rem
	Method SetAspectRatio(numer:Int, denom:Int)
		bmx_glfw_glfwSetWindowAspectRatio(windowPtr, numer, denom)
	End Method
	
	Rem
	bbdoc: Sets the size, in screen coordinates, of the content area of the window.
	about: For full screen windows, this method updates the resolution of its desired video mode and switches to the video mode closest to it,
	without affecting the window's context. As the context is unaffected, the bit depths of the framebuffer remain unchanged.

	If you wish to update the refresh rate of the desired video mode in addition to its resolution, see #SetMonitor.

	The window manager may put limits on what sizes are allowed. GLFW cannot and should not override these limits.
	End Rem
	Method SetSize(w:Int, h:Int)
		bmx_glfw_glfwSetWindowSize(windowPtr, w, h)
	End Method

	Rem
	bbdoc: Retrieves the size, in pixels, of the framebuffer of the window.
	about: If you wish to retrieve the size of the window in screen coordinates, see #GetSize.
	End Rem
	Method GetFramebufferSize(width:Int Var, height:Int Var)
		bmx_glfw_glfwGetFramebufferSize(windowPtr, width, height)
	End Method
	
	Rem
	bbdoc: Retrieves the size, in screen coordinates, of each edge of the frame of the window.
	about: This size includes the title bar, if the window has one. The size of the frame may vary depending on the window-related hints used to create it.

	Because this method retrieves the size of each window frame edge and not the offset along a particular coordinate axis,
	the retrieved values will always be zero or positive.
	End Rem
	Method GetFrameSize(Left:Int Var, top:Int Var, Right:Int Var, bottom:Int Var)
		bmx_glfw_glfwGetWindowFrameSize(windowPtr, Left, top, Right, bottom)
	End Method
	
	Rem
	bbdoc: Retrieves the content scale for the window.
	about: The content scale is the ratio between the current DPI and the platform's default DPI. This is especially important
	for text and any UI elements. If the pixel dimensions of your UI scaled by this look appropriate on your machine then it should
	appear at a reasonable size on other machines regardless of their DPI and scaling settings. This relies on the system DPI and
	scaling settings being somewhat correct.

	On systems where each monitors can have its own content scale, the window content scale will depend on which monitor
	the system considers the window to be on.
	End Rem
	Method GetContentScale(xscale:Float Var, yscale:Float Var)
		bmx_glfw_glfwGetWindowContentScale(windowPtr, xscale, yscale)
	End Method
	
	Rem
	bbdoc: Returns the opacity of the window, including any decorations.
	about: The opacity (or alpha) value is a positive finite number between zero and one, where zero is fully transparent
	and one is fully opaque. If the system does not support whole window transparency, this method always returns one.

	The initial opacity value for newly created windows is one.
	End Rem
	Method GetOpacity:Float()
		Return bmx_glfw_glfwGetWindowOpacity(windowPtr)
	End Method
	
	Rem
	bbdoc: Sets the opacity of the window, including any decorations.
	about: The opacity (or alpha) value is a positive finite number between zero and one, where zero is fully transparent and one is fully opaque.

	The initial opacity value for newly created windows is one.

	A window created with framebuffer transparency may not use whole window transparency. The results of doing this are undefined.
	End Rem
	Method SetOpacity(opacity:Float)
		bmx_glfw_glfwSetWindowOpacity(windowPtr, opacity)
	End Method
	
	Rem
	bbdoc: Iconifies (minimizes) the window if it was previously restored.
	about: If the window is already iconified, this method does nothing.

	If the window is a full screen window, the original monitor resolution is restored until the window is restored.
	End Rem
	Method Iconify()
		bmx_glfw_glfwIconifyWindow(windowPtr)
	End Method
	
	Rem
	bbdoc: Restores the window if it was previously iconified (minimized) or maximized.
	about: If the window is already restored, this method does nothing.

	If the window is a full screen window, the resolution chosen for the window is restored on the selected monitor.
	End Rem
	Method Restore()
		bmx_glfw_glfwRestoreWindow(windowPtr)
	End Method
	
	Rem
	bbdoc: Maximizes the window if it was previously not maximized.
	
	about: If the window is already maximized, this method does nothing.
	
	If the window is a full screen window, this method does nothing.
	End Rem
	Method Maximize()
		bmx_glfw_glfwMaximizeWindow(windowPtr)
	End Method
	
	Rem
	bbdoc: Makes the window visible if it was previously hidden.
	about: If the window is already visible or is in full screen mode, this method does nothing.

	By default, windowed mode windows are focused when shown Set the GLFW_FOCUS_ON_SHOW window hint to change this behavior
	for all newly created windows, or change the behavior for an existing window with #SetAttrib.
	End Rem
	Method Show()
		bmx_glfw_glfwShowWindow(windowPtr)
	End Method
	
	Rem
	bbdoc: Hides the window if it was previously visible.
	about: If the window is already hidden or is in full screen mode, this method does nothing.
	End Rem
	Method Hide()
		bmx_glfw_glfwHideWindow(windowPtr)
	End Method
	
	Rem
	bbdoc: Brings the window to front and sets input focus.
	about: The window should already be visible and not iconified.

	By default, both windowed and full screen mode windows are focused when initially created. Set the GLFW_FOCUSED to disable this behavior.

	Also by default, windowed mode windows are focused when shown with #Show. Set the GLFW_FOCUS_ON_SHOW to disable this behavior.

	Do not use this method to steal focus from other applications unless you are certain that is what the user wants.
	Focus stealing can be extremely disruptive.

	For a less disruptive way of getting the user's attention, see attention requests.
	End Rem
	Method Focus()
		bmx_glfw_glfwFocusWindow(windowPtr)
	End Method
	
	Rem
	bbdoc: Requests user attention to the window.
	about: On platforms where this is not supported, attention is requested to the application as a whole.

	Once the user has given attention, usually by focusing the window or application, the system will end the request automatically.
	End Rem
	Method RequestAttention()
		bmx_glfw_glfwRequestWindowAttention(windowPtr)
	End Method
	
	Rem
	bbdoc: Returns the monitor that the window is in full screen on.
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
	bbdoc: Returns the value of an attribute of the window or its OpenGL or OpenGL ES context.
	End Rem
	Method GetAttrib:Int(attrib:Int)
		Return bmx_glfw_glfwGetWindowAttrib(windowPtr, attrib)
	End Method
	
	Rem
	bbdoc: Sets the value of an attribute of the specified window.
	about: The supported attributes are GLFW_DECORATED, GLFW_RESIZABLE, GLFW_FLOATING, GLFW_AUTO_ICONIFY and GLFW_FOCUS_ON_SHOW.

	Some of these attributes are ignored for full screen windows. The new value will take effect if the window is later made windowed.

	Some of these attributes are ignored for windowed mode windows. The new value will take effect if the window is later made full screen.
	End Rem
	Method SetAttrib(attrib:Int, value:Int)
		bmx_glfw_glfwSetWindowAttrib(windowPtr, attrib, value)
	End Method
	
	Rem
	bbdoc: Makes the OpenGL or OpenGL ES context of the window current on the calling thread.
	about: A context must only be made current on a single thread at a time and each thread can have only a single current context at a time.

	When moving a context between threads, you must make it non-current on the old thread before making it current on the new one.

	By default, making a context non-current implicitly forces a pipeline flush. On machines that support
	GL_KHR_context_flush_control, you can control whether a context performs this flush by setting the GLFW_CONTEXT_RELEASE_BEHAVIOR hint.

	The window must have an OpenGL or OpenGL ES context. A window without a context will generate a GLFW_NO_WINDOW_CONTEXT error.
	End Rem
	Method MakeContextCurrent()
		bmx_glfw_glfwMakeContextCurrent(windowPtr)
	End Method
	
	Rem
	bbdoc: Swaps the front and back buffers of the window when rendering with OpenGL or OpenGL ES.
	about: If the swap interval is greater than zero, the GPU driver waits the specified number of screen updates before swapping the buffers.

	The specified window must have an OpenGL or OpenGL ES context. Specifying a window without a context will generate a GLFW_NO_WINDOW_CONTEXT error.

	This method does not apply to Vulkan. If you are rendering with Vulkan, see vkQueuePresentKHR instead.
	End Rem
	Method SwapBuffers()
		bmx_glfw_glfwSwapBuffers(windowPtr)
	End Method
	
	Rem
	bbdoc: Returns true if the specified key is in a pressed state.
	End Rem
	Method IsKeyDown:Int(key:Int)
		Return bmx_glfw_glfwGetKey(windowPtr, key) <> GLFW_RELEASE
	End Method

	Rem
	bbdoc: Returns the value of an input option for the window.
	about: The mode must be one of #GLFW_CURSOR, #GLFW_STICKY_KEYS, #GLFW_STICKY_MOUSE_BUTTONS, #GLFW_LOCK_KEY_MODS or #GLFW_RAW_MOUSE_MOTION.
	End Rem
	Method GetInputMode:Int(Mode:Int)
		Return bmx_glfw_glfwGetInputMode(windowPtr, Mode)
	End Method
	
	Rem
	bbdoc: Sets an input mode option for the window.
	about: The mode must be one of #GLFW_CURSOR, #GLFW_STICKY_KEYS, #GLFW_STICKY_MOUSE_BUTTONS, #GLFW_LOCK_KEY_MODS or #GLFW_RAW_MOUSE_MOTION.

	If the mode is #GLFW_CURSOR, the value must be one of the following cursor modes:
* #GLFW_CURSOR_NORMAL makes the cursor visible and behaving normally.
* #GLFW_CURSOR_HIDDEN makes the cursor invisible when it is over the content area of the window but does not restrict the cursor from leaving.
* #GLFW_CURSOR_DISABLED hides and grabs the cursor, providing virtual and unlimited cursor movement. This is useful for implementing for example 3D camera controls.

	If the mode is #GLFW_STICKY_KEYS, the value must be either #True to enable sticky keys, or #False to disable it.
	If sticky keys are enabled, a key press will ensure that #GetKey returns #GLFW_PRESS the next time it is called even if
	the key had been released before the call. This is useful when you are only interested in whether keys have been pressed
	but not when or in which order.

	If the mode is #GLFW_STICKY_MOUSE_BUTTONS, the value must be either #True to enable sticky mouse buttons, or #False to disable it.
	If sticky mouse buttons are enabled, a mouse button press will ensure that #GetMouseButton returns #GLFW_PRESS the next time
	it is called even if the mouse button had been released before the call. This is useful when you are only interested in
	whether mouse buttons have been pressed but not when or in which order.

	If the mode is #GLFW_LOCK_KEY_MODS, the value must be either #True to enable lock key modifier bits, or #False to disable them.
	If enabled, callbacks that receive modifier bits will also have the #GLFW_MOD_CAPS_LOCK bit set when the event was generated
	with Caps Lock on, and the #GLFW_MOD_NUM_LOCK bit when Num Lock was on.

	If the mode is #GLFW_RAW_MOUSE_MOTION, the value must be either #True to enable raw (unscaled and unaccelerated) mouse motion when
	the cursor is disabled, or #False to disable it. If raw motion is not supported, attempting to set this will emit #GLFW_PLATFORM_ERROR.
	Call #RawMouseMotionSupported to check for support.
	End Rem
	Method SetInputMode(Mode:Int, value:Int)
		bmx_glfw_glfwSetInputMode(windowPtr, Mode, value)
	End Method
	
	Rem
	bbdoc: Returns the last state reported for the specified key to the window.
	about: The returned state is one of GLFW_PRESS or GLFW_RELEASE. The higher-level action GLFW_REPEAT is only reported to the key callback.

	If the GLFW_STICKY_KEYS input mode is enabled, this function returns GLFW_PRESS the first time you call it for a key that was pressed,
	even if that key has already been released.

	The key functions deal with physical keys, with key tokens named after their use on the standard US keyboard layout. If you want
	to input text, use the Unicode character callback instead.

	The modifier key bit masks are not key tokens and cannot be used with this function.

	Do not use this method to implement text input.
	End Rem
	Method GetKey:Int(key:Int)
		Return bmx_glfw_glfwGetKey(windowPtr, key)
	End Method
	
	Rem
	bbdoc: Returns the last state reported for the specified mouse button to the window.
	about: The returned state is one of GLFW_PRESS or GLFW_RELEASE.

	If the #GLFW_STICKY_MOUSE_BUTTONS input mode is enabled, this method returns GLFW_PRESS the first time you call it for a mouse button
	that was pressed, even if that mouse button has already been released.
	End Rem
	Method GetMouseButton:Int(button:Int)
		Return bmx_glfw_glfwGetMouseButton(windowPtr, button)
	End Method
	
	Rem
	bbdoc: Returns the position of the cursor, in screen coordinates, relative to the upper-left corner of the content area of the window.
	about: If the cursor is disabled (with #GLFW_CURSOR_DISABLED) then the cursor position is unbounded and limited only by the minimum
	and maximum values of a double.

	The coordinate can be converted to their integer equivalents with the #Floor function. Casting directly to an integer type works
	for positive coordinates, but fails for negative ones.
	End Rem
	Method GetCursorPos(x:Double Var, y:Double Var)
		bmx_glfw_glfwGetCursorPos(windowPtr, x, y)
	End Method
	
	Rem
	bbdoc: Sets the position, in screen coordinates, of the cursor relative to the upper-left corner of the content area of the window.
	about: The window must have input focus. If the window does not have input focus when this method is called, it fails silently.

	Do not use this method to implement things like camera controls. GLFW already provides the #GLFW_CURSOR_DISABLED cursor mode that
	hides the cursor, transparently re-centers it and provides unconstrained cursor motion. See #SetInputMode for more information.

	If the cursor mode is #GLFW_CURSOR_DISABLED then the cursor position is unconstrained and limited only by the minimum and maximum values of a double.
	End Rem
	Method SetCursorPos(x:Double, y:Double)
		bmx_glfw_glfwSetCursorPos(windowPtr, x, y)
	End Method
	
	Rem
	bbdoc: Sets the cursor image to be used when the cursor is over the content area of the window.
	about: The set cursor will only be visible when the cursor mode of the window is #GLFW_CURSOR_NORMAL.

	On some platforms, the set cursor may not be visible unless the window also has input focus.
	End Rem
	Method SetCursor(cursor:GLFWcursor)
		bmx_glfw_glfwSetCursor(windowPtr, cursor.cursorPtr)
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
	bbdoc: Called when the window is iconified or restored.
	End Rem
	Method OnIconify(iconified:Int)
	End Method
	
	Rem
	bbdoc: Called when the window is maximized or restored.
	End Rem
	Method OnMaximize(maximized:Int)
	End Method
	
	Rem
	bbdoc: Called when the framebuffer is resized.
	End Rem
	Method OnFramebufferSize(width:Int, height:Int)
	End Method
	
	Rem
	bbdoc: Called when the content scale of the specified window changes.
	End Rem
	Method OnContentScale(xScale:Float, yScale:Float)
	End Method

	Rem
	bbdoc: Called when a mouse button is pressed or released.
	about:  When a window loses input focus, it will generate synthetic mouse button release events for all pressed mouse buttons.
	You can tell these events from user-generated events by the fact that the synthetic ones are generated after the focus loss
	event has been processed, i.e. after #OnFocus has been called.
	End Rem
	Method OnMouseButton(button:Int, action:Int, mods:Int)
	End Method
	
	Rem
	bbdoc: Called when the cursor is moved.
	about: The callback is provided with the position, in screen coordinates, relative to the upper-left corner of the content area of the window.
	End Rem
	Method OnCursorPosition(x:Double, y:Double)
	End Method
	
	Rem
	bbdoc: Called when the cursor enters or leaves the content area of the window.
	End Rem
	Method OnCursorEnter(entered:Int)
	End Method
	
	Rem
	bbdoc: Called when a scrolling device is used, such as a mouse wheel or scrolling area of a touchpad.
	about: The scroll callback receives all scrolling input, like that from a mouse wheel or a touchpad scrolling area.
	End Rem
	Method OnScroll(xOffset:Double, yOffset:Double)
	End Method
	
	Rem
	bbdoc: Called when a key is pressed, repeated or released.
	about: The key functions deal with physical keys, with layout independent key tokens named after their values in the standard
	US keyboard layout. If you want to input text, use the #OnChar callback instead.

	When a window loses input focus, it will generate synthetic key release events for all pressed keys.
	You can tell these events from user-generated events by the fact that the synthetic ones are generated after the focus
	loss event has been processed, i.e. after the window #OnFocus callback has been called.

	The scancode of a key is specific to that platform or sometimes even to that machine. Scancodes are intended to allow
	users to bind keys that don't have a GLFW key token. Such keys have key set to GLFW_KEY_UNKNOWN, their state is not saved
	and so it cannot be queried with #GetKey.

	Sometimes GLFW needs to generate synthetic key events, in which case the scancode may be zero.
	End Rem
	Method OnKey(key:Int, scancode:Int, action:Int, mods:Int)
	End Method
	
	Rem
	bbdoc: Called when a Unicode character is input.
	about:  The #OnChar callback is intended for Unicode text input. As it deals with characters, it is keyboard
	layout dependent, whereas the #OnKey callback is not. Characters do not map 1:1 to physical keys, as a key may
	produce zero, one or more characters. If you want to know whether a specific physical key was pressed or released, see the #OnKey callback instead.

	The #OnChar callback behaves as system text input normally does and will not be called if modifier keys are held down that
	would prevent normal text input on that platform, for example a Super (Command) key on macOS or Alt key on Windows.
	End Rem
	Method OnChar(char:UInt)
	End Method
	
	Rem
	bbdoc: Called when a Unicode character is input regardless of what modifier keys are used.
	about: The #OnCharMods callback is intended for implementing custom Unicode character input.
	For regular Unicode text input, see the #OnChar callback. Like the #OnChar callback, the #OnCharMods callback deals with characters
	and is keyboard layout dependent. Characters do not map 1:1 to physical keys, as a key may produce zero, one or more characters.
	If you want to know whether a specific physical key was pressed or released, see the #OnKey callback instead.
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

Rem
bbdoc: Image data.
about: This describes a single 2D image.
See the documentation for each related function what the expected pixel format is.
End Rem
Struct GLFWimage
	Rem
	bbdoc: The width, in pixels, of this image.
	End Rem
	Field width:Int
	Rem
	bbdoc: The height, in pixels, of this image.
	End Rem
	Field height:Int
	Rem
	bbdoc: The pixel data of this image, arranged left-to-right, top-to-bottom.
	End Rem
	Field pixels:Byte Ptr
	
	Method New(width:Int, height:Int, pixels:Byte Ptr)
		Self.width = width
		Self.height = height
		Self.pixels = pixels
	End Method
End Struct

Rem
bbdoc: A GLFW cursor
End Rem
Struct GLFWcursor
Private
	Field cursorPtr:Byte Ptr
	Field custom:Int
	
	Method New(cursorPtr:Byte Ptr, custom:Int)
		Self.cursorPtr = cursorPtr
		Self.custom = custom
	End Method
Public
	Rem
	bbdoc: Creates a new custom cursor image that can be set for a window with #SetCursor.
	about: The cursor can be destroyed with #Destroy. Any remaining cursors are destroyed on program termination.

	The cursor hotspot is specified in pixels, relative to the upper-left corner of the cursor image.
	Like all other coordinate systems in GLFW, the X-axis points to the right and the Y-axis points down.
	End Rem
	Function Create:GLFWcursor(pix:TPixmap, xhot:Int, yhot:Int)
		If pix.format <> PF_RGBA8888 Then
			pix = pix.Convert(PF_RGBA8888)
		End If

		Local image:GLFWimage = New GLFWimage(pix.width, pix.height, pix.pixels)
		Local cursor:GLFWcursor = New GLFWcursor(bmx_glfw_glfwCreateCursor(image, xhot, yhot), True)
		pix = Null

		Return cursor
	End Function

	Rem
	bbdoc: Returns a cursor with a standard shape, that can be set for a window with #SetCursor.
	about: Standard shapes include #GLFW_ARROW_CURSOR, #GLFW_IBEAM_CURSOR, #GLFW_CROSSHAIR_CURSOR, #GLFW_HAND_CURSOR, #GLFW_HRESIZE_CURSOR and #GLFW_VRESIZE_CURSOR.
	End Rem
	Function CreateStandard:GLFWcursor(shape:Int)
		Return New GLFWcursor(bmx_glfw_glfwCreateStandardCursor(shape), False)
	End Function

	Rem
	bbdoc: Destroys a cursor previously created with #Create. 
	about: Any remaining cursors will be destroyed on program termination.

	If the specified cursor is current for any window, that window will be reverted to the default cursor. This does not affect the cursor mode.
	End Rem
	Method Destroy()
		If custom Then
			bmx_glfw_glfwDestroyCursor(cursorPtr)
		End If
	End Method
	
End Struct

Private

Extern
	Function bmx_glfw_glfwGetWindowUserPointer:TGLFWWindow(window:Byte Ptr)="glfwGetWindowUserPointer"
	Function bmx_glfw_glfwSetWindowUserPointer(window:Byte Ptr, win:TGLFWWindow)="glfwSetWindowUserPointer"
	Function bmx_glfw_glfwCreateCursor:Byte Ptr(image:GLFWimage Var, xhot:Int, yhot:Int)="glfwCreateCursor"
End Extern
