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

Import GLFW.GLFWSystem
Import GLFW.GLFWMonitor

Extern

	Function bmx_glfw_glfwDefaultWindowHints()="glfwDefaultWindowHints"
	Function bmx_glfw_glfwWindowHint(hint:Int, value:Int)="glfwWindowHint"
	Function bmx_glfw_glfwWindowHintString(hint:Int, value:Byte Ptr)="glfwWindowHintString"
	Function bmx_glfw_glfwCreateWindow:Byte Ptr(width:Int, height:Int, title:Byte Ptr, monitor:Byte Ptr, share:Byte Ptr)="glfwCreateWindow"
	Function bmx_glfw_glfwDestroyWindow(window:Byte Ptr)="glfwDestroyWindow"
	Function bmx_glfw_glfwWindowShouldClose:Int(window:Byte Ptr)="glfwWindowShouldClose"
	Function bmx_glfw_glfwSetWindowShouldClose(window:Byte Ptr, value:Int)="glfwSetWindowShouldClose"
	Function bmx_glfw_glfwSetWindowTitle(window:Byte Ptr, title:Byte Ptr)="glfwSetWindowTitle"
	Function bmx_glfw_glfwGetWindowPos(window:Byte Ptr, x:Int Var, y:Int Var)="glfwGetWindowPos"
	Function bmx_glfw_glfwSetWindowPos(window:Byte Ptr, x:Int, y:Int)="glfwSetWindowPos"
	Function bmx_glfw_glfwGetWindowSize(window:Byte Ptr, w:Int Var, h:Int Var)="glfwGetWindowSize"
	Function bmx_glfw_glfwSetWindowSizeLimits(window:Byte Ptr, minWidth:Int, minHeight:Int, maxWidth:Int, maxHeight:Int)="glfwSetWindowSizeLimits"
	Function bmx_glfw_glfwSetWindowAspectRatio(window:Byte Ptr, numer:Int, denom:Int)="glfwSetWindowAspectRatio"
	Function bmx_glfw_glfwSetWindowSize(window:Byte Ptr, w:Int, h:Int)="glfwSetWindowSize"
	Function bmx_glfw_glfwGetFramebufferSize(window:Byte Ptr, width:Int Var, height:Int Var)="glfwGetFramebufferSize"
	Function bmx_glfw_glfwGetWindowFrameSize(window:Byte Ptr, Left:Int Var, top:Int Var, Right:Int Var, bottom:Int Var)="glfwGetWindowFrameSize"
	Function bmx_glfw_glfwGetWindowContentScale(window:Byte Ptr, xscale:Float Var, yscale:Float Var)="glfwGetWindowContentScale"
	Function bmx_glfw_glfwGetWindowOpacity:Float(window:Byte Ptr)="glfwGetWindowOpacity"
	Function bmx_glfw_glfwSetWindowOpacity(window:Byte Ptr, opacity:Float)="glfwSetWindowOpacity"
	Function bmx_glfw_glfwIconifyWindow(window:Byte Ptr)="glfwIconifyWindow"
	Function bmx_glfw_glfwRestoreWindow(window:Byte Ptr)="glfwRestoreWindow"
	Function bmx_glfw_glfwMaximizeWindow(window:Byte Ptr)="glfwMaximizeWindow"
	Function bmx_glfw_glfwShowWindow(window:Byte Ptr)="glfwShowWindow"
	Function bmx_glfw_glfwHideWindow(window:Byte Ptr)="glfwHideWindow"
	Function bmx_glfw_glfwFocusWindow(window:Byte Ptr)="glfwFocusWindow"
	Function bmx_glfw_glfwRequestWindowAttention(window:Byte Ptr)="glfwRequestWindowAttention"
	Function bmx_glfw_glfwGetWindowAttrib:Int(window:Byte Ptr, attrib:Int)="glfwGetWindowAttrib"
	Function bmx_glfw_glfwSetWindowAttrib(window:Byte Ptr, attrib:Int, value:Int)="glfwSetWindowAttrib"
	Function bmx_glfw_glfwGetWindowMonitor:Byte Ptr(window:Byte Ptr)="glfwGetWindowMonitor"
	Function bmx_glfw_glfwSetWindowMonitor(window:Byte Ptr, monitor:Byte Ptr, xpos:Int, ypos:Int, width:Int, height:Int, refreshRate:Int)="glfwSetWindowMonitor"

	Function bmx_glfw_glfwMakeContextCurrent(window:Byte Ptr)="glfwMakeContextCurrent"
	Function bmx_glfw_glfwSwapBuffers(window:Byte Ptr)="glfwSwapBuffers"
	
	Function bmx_glfw_glfwGetKey:Int(window:Byte Ptr, key:Int)="glfwGetKey"

	Function bmx_glfw_glfwSetWindowPosCallback:Byte Ptr(window:Byte Ptr, func(win:Byte Ptr, x:Int, y:Int))="glfwSetWindowPosCallback"
	Function bmx_glfw_glfwSetWindowSizeCallback:Byte Ptr(window:Byte Ptr, func(win:Byte Ptr, w:Int, h:Int))="glfwSetWindowSizeCallback"
	Function bmx_glfw_glfwSetWindowCloseCallback:Byte Ptr(window:Byte Ptr, func(win:Byte Ptr))="glfwSetWindowCloseCallback"
	Function bmx_glfw_glfwSetWindowRefreshCallback:Byte Ptr(window:Byte Ptr, func(win:Byte Ptr))="glfwSetWindowRefreshCallback"
	Function bmx_glfw_glfwSetWindowFocusCallback:Byte Ptr(window:Byte Ptr, func(win:Byte Ptr, focused:Int))="glfwSetWindowFocusCallback"
	Function bmx_glfw_glfwSetWindowIconifyCallback:Byte Ptr(window:Byte Ptr, func(win:Byte Ptr, iconified:Int))="glfwSetWindowIconifyCallback"
	Function bmx_glfw_glfwSetWindowMaximizeCallback:Byte Ptr(window:Byte Ptr, func(win:Byte Ptr, maximized:Int))="glfwSetWindowMaximizeCallback"
	Function bmx_glfw_glfwSetFramebufferSizeCallback:Byte Ptr(window:Byte Ptr, func(win:Byte Ptr, w:Int, h:Int))="glfwSetFramebufferSizeCallback"
	Function bmx_glfw_glfwSetWindowContentScaleCallback:Byte Ptr(window:Byte Ptr, func(win:Byte Ptr, xScale:Float, yScale:Float))="glfwSetWindowContentScaleCallback"
	Function bmx_glfw_glfwSetMouseButtonCallback:Byte Ptr(window:Byte Ptr, func(win:Byte Ptr, button:Int, action:Int, mods:Int))="glfwSetMouseButtonCallback"
	Function bmx_glfw_glfwSetCursorPosCallback:Byte Ptr(window:Byte Ptr, func(win:Byte Ptr, x:Double, y:Double))="glfwSetCursorPosCallback"
	Function bmx_glfw_glfwSetCursorEnterCallback:Byte Ptr(window:Byte Ptr, func(win:Byte Ptr, entered:Int))="glfwSetCursorEnterCallback"
	Function bmx_glfw_glfwSetScrollCallback:Byte Ptr(window:Byte Ptr, func(win:Byte Ptr, xOffset:Double, yOffset:Double))="glfwSetScrollCallback"
	Function bmx_glfw_glfwSetKeyCallback:Byte Ptr(window:Byte Ptr, func(win:Byte Ptr, key:Int, scancode:Int, action:Int, mods:Int))="glfwSetKeyCallback"
	Function bmx_glfw_glfwSetCharCallback:Byte Ptr(window:Byte Ptr, func(win:Byte Ptr, char:UInt))="glfwSetCharCallback"
	Function bmx_glfw_glfwSetCharModsCallback:Byte Ptr(window:Byte Ptr, func(win:Byte Ptr, codepoint:UInt, mods:Int))="glfwSetCharModsCallback"
	
End Extern

Const GLFW_RELEASE:Int = 0
Const GLFW_PRESS:Int = 1
Const GLFW_REPEAT:Int = 2

Const GLFW_HAT_CENTERED:Int = 0
Const GLFW_HAT_UP:Int = 1
Const GLFW_HAT_RIGHT:Int = 2
Const GLFW_HAT_DOWN:Int = 4
Const GLFW_HAT_LEFT:Int = 8
Const GLFW_HAT_RIGHT_UP:Int = (GLFW_HAT_RIGHT | GLFW_HAT_UP)
Const GLFW_HAT_RIGHT_DOWN:Int = (GLFW_HAT_RIGHT | GLFW_HAT_DOWN)
Const GLFW_HAT_LEFT_UP:Int = (GLFW_HAT_LEFT  | GLFW_HAT_UP)
Const GLFW_HAT_LEFT_DOWN:Int = (GLFW_HAT_LEFT  | GLFW_HAT_DOWN)

Const GLFW_KEY_UNKNOWN:Int = -1

Const GLFW_KEY_SPACE:Int = 32
Const GLFW_KEY_APOSTROPHE:Int = 39
Const GLFW_KEY_COMMA:Int = 44
Const GLFW_KEY_MINUS:Int = 45
Const GLFW_KEY_PERIOD:Int = 46
Const GLFW_KEY_SLASH:Int = 47
Const GLFW_KEY_0:Int = 48
Const GLFW_KEY_1:Int = 49
Const GLFW_KEY_2:Int = 50
Const GLFW_KEY_3:Int = 51
Const GLFW_KEY_4:Int = 52
Const GLFW_KEY_5:Int = 53
Const GLFW_KEY_6:Int = 54
Const GLFW_KEY_7:Int = 55
Const GLFW_KEY_8:Int = 56
Const GLFW_KEY_9:Int = 57
Const GLFW_KEY_SEMICOLON:Int = 59
Const GLFW_KEY_EQUAL:Int = 61
Const GLFW_KEY_A:Int = 65
Const GLFW_KEY_B:Int = 66
Const GLFW_KEY_C:Int = 67
Const GLFW_KEY_D:Int = 68
Const GLFW_KEY_E:Int = 69
Const GLFW_KEY_F:Int = 70
Const GLFW_KEY_G:Int = 71
Const GLFW_KEY_H:Int = 72
Const GLFW_KEY_I:Int = 73
Const GLFW_KEY_J:Int = 74
Const GLFW_KEY_K:Int = 75
Const GLFW_KEY_L:Int = 76
Const GLFW_KEY_M:Int = 77
Const GLFW_KEY_N:Int = 78
Const GLFW_KEY_O:Int = 79
Const GLFW_KEY_P:Int = 80
Const GLFW_KEY_Q:Int = 81
Const GLFW_KEY_R:Int = 82
Const GLFW_KEY_S:Int = 83
Const GLFW_KEY_T:Int = 84
Const GLFW_KEY_U:Int = 85
Const GLFW_KEY_V:Int = 86
Const GLFW_KEY_W:Int = 87
Const GLFW_KEY_X:Int = 88
Const GLFW_KEY_Y:Int = 89
Const GLFW_KEY_Z:Int = 90
Const GLFW_KEY_LEFT_BRACKET:Int = 91
Const GLFW_KEY_BACKSLASH:Int = 92
Const GLFW_KEY_RIGHT_BRACKET:Int = 93
Const GLFW_KEY_GRAVE_ACCENT:Int = 96
Const GLFW_KEY_WORLD_1:Int = 161
Const GLFW_KEY_WORLD_2:Int = 162

Const GLFW_KEY_ESCAPE:Int = 256
Const GLFW_KEY_ENTER:Int = 257
Const GLFW_KEY_TAB:Int = 258
Const GLFW_KEY_BACKSPACE:Int = 259
Const GLFW_KEY_INSERT:Int = 260
Const GLFW_KEY_DELETE:Int = 261
Const GLFW_KEY_RIGHT:Int = 262
Const GLFW_KEY_LEFT:Int = 263
Const GLFW_KEY_DOWN:Int = 264
Const GLFW_KEY_UP:Int = 265
Const GLFW_KEY_PAGE_UP:Int = 266
Const GLFW_KEY_PAGE_DOWN:Int = 267
Const GLFW_KEY_HOME:Int = 268
Const GLFW_KEY_END:Int = 269
Const GLFW_KEY_CAPS_LOCK:Int = 280
Const GLFW_KEY_SCROLL_LOCK:Int = 281
Const GLFW_KEY_NUM_LOCK:Int = 282
Const GLFW_KEY_PRINT_SCREEN:Int = 283
Const GLFW_KEY_PAUSE:Int = 284
Const GLFW_KEY_F1:Int = 290
Const GLFW_KEY_F2:Int = 291
Const GLFW_KEY_F3:Int = 292
Const GLFW_KEY_F4:Int = 293
Const GLFW_KEY_F5:Int = 294
Const GLFW_KEY_F6:Int = 295
Const GLFW_KEY_F7:Int = 296
Const GLFW_KEY_F8:Int = 297
Const GLFW_KEY_F9:Int = 298
Const GLFW_KEY_F10:Int = 299
Const GLFW_KEY_F11:Int = 300
Const GLFW_KEY_F12:Int = 301
Const GLFW_KEY_F13:Int = 302
Const GLFW_KEY_F14:Int = 303
Const GLFW_KEY_F15:Int = 304
Const GLFW_KEY_F16:Int = 305
Const GLFW_KEY_F17:Int = 306
Const GLFW_KEY_F18:Int = 307
Const GLFW_KEY_F19:Int = 308
Const GLFW_KEY_F20:Int = 309
Const GLFW_KEY_F21:Int = 310
Const GLFW_KEY_F22:Int = 311
Const GLFW_KEY_F23:Int = 312
Const GLFW_KEY_F24:Int = 313
Const GLFW_KEY_F25:Int = 314
Const GLFW_KEY_KP_0:Int = 320
Const GLFW_KEY_KP_1:Int = 321
Const GLFW_KEY_KP_2:Int = 322
Const GLFW_KEY_KP_3:Int = 323
Const GLFW_KEY_KP_4:Int = 324
Const GLFW_KEY_KP_5:Int = 325
Const GLFW_KEY_KP_6:Int = 326
Const GLFW_KEY_KP_7:Int = 327
Const GLFW_KEY_KP_8:Int = 328
Const GLFW_KEY_KP_9:Int = 329
Const GLFW_KEY_KP_DECIMAL:Int = 330
Const GLFW_KEY_KP_DIVIDE:Int = 331
Const GLFW_KEY_KP_MULTIPLY:Int = 332
Const GLFW_KEY_KP_SUBTRACT:Int = 333
Const GLFW_KEY_KP_ADD:Int = 334
Const GLFW_KEY_KP_ENTER:Int = 335
Const GLFW_KEY_KP_EQUAL:Int = 336
Const GLFW_KEY_LEFT_SHIFT:Int = 340
Const GLFW_KEY_LEFT_CONTROL:Int = 341
Const GLFW_KEY_LEFT_ALT:Int = 342
Const GLFW_KEY_LEFT_SUPER:Int = 343
Const GLFW_KEY_RIGHT_SHIFT:Int = 344
Const GLFW_KEY_RIGHT_CONTROL:Int = 345
Const GLFW_KEY_RIGHT_ALT:Int = 346
Const GLFW_KEY_RIGHT_SUPER:Int = 347
Const GLFW_KEY_MENU:Int = 348

Const GLFW_KEY_LAST:Int = GLFW_KEY_MENU

Const GLFW_DONT_CARE:Int = -1

Const GLFW_ARROW_CURSOR:Int = $00036001
Const GLFW_IBEAM_CURSOR:Int = $00036002
Const GLFW_CROSSHAIR_CURSOR:Int = $00036003
Const GLFW_HAND_CURSOR:Int = $00036004
Const GLFW_HRESIZE_CURSOR:Int = $00036005
Const GLFW_VRESIZE_CURSOR:Int = $00036006

' window hints
Rem
bbdoc: Input focus window hint and attribute.
End Rem
Const GLFW_FOCUSED:Int = $00020001
Rem
bbdoc: Window iconification window attribute.
End Rem
Const GLFW_ICONIFIED:Int = $00020002
Rem
bbdoc: Window resize-ability window hint and attribute.
End Rem
Const GLFW_RESIZABLE:Int = $00020003
Rem
bbdoc: Window visibility window hint and attribute.
End Rem
Const GLFW_VISIBLE:Int = $00020004
Rem
bbdoc: Window decoration window hint and attribute.
End Rem
Const GLFW_DECORATED:Int = $00020005
Rem
bbdoc: Window auto-iconification window hint and window attribute.
End Rem
Const GLFW_AUTO_ICONIFY:Int = $00020006
Rem
bbdoc: Window decoration window hint and window attribute.
End Rem
Const GLFW_FLOATING:Int = $00020007
Rem
bbdoc: Window maximization window hint and window attribute.
End Rem
Const GLFW_MAXIMIZED:Int = $00020008
Rem
bbdoc: Cursor centering window hint.
End Rem
Const GLFW_CENTER_CURSOR:Int = $00020009
Rem
bbdoc: Window framebuffer transparency window hint and window attribute.
End Rem
Const GLFW_TRANSPARENT_FRAMEBUFFER:Int = $0002000A
Rem
bbdoc: Mouse cursor hover window attribute.
End Rem
Const GLFW_HOVERED:Int = $0002000B
Rem
bbdoc: Input focus window hint or window attribute.
End Rem
Const GLFW_FOCUS_ON_SHOW:Int = $0002000C
Rem
bbdoc: Framebuffer bit depth hint.
End Rem
Const GLFW_RED_BITS:Int = $00021001
Rem
bbdoc: Framebuffer bit depth hint.
End Rem
Const GLFW_GREEN_BITS:Int = $00021002
Rem
bbdoc: Framebuffer bit depth hint.
End Rem
Const GLFW_BLUE_BITS:Int = $00021003
Rem
bbdoc: Framebuffer bit depth hint.
End Rem
Const GLFW_ALPHA_BITS:Int = $00021004
Rem
bbdoc: Framebuffer bit depth hint.
End Rem
Const GLFW_DEPTH_BITS:Int = $00021005
Rem
bbdoc: Framebuffer bit depth hint.
End Rem
Const GLFW_STENCIL_BITS:Int = $00021006
Rem
bbdoc: Framebuffer bit depth hint.
End Rem
Const GLFW_ACCUM_RED_BITS:Int = $00021007
Rem
bbdoc: Framebuffer bit depth hint.
End Rem
Const GLFW_ACCUM_GREEN_BITS:Int = $00021008
Rem
bbdoc: Framebuffer bit depth hint.
End Rem
Const GLFW_ACCUM_BLUE_BITS:Int = $00021009
Rem
bbdoc: Framebuffer bit depth hint.
End Rem
Const GLFW_ACCUM_ALPHA_BITS:Int = $0002100A
Rem
bbdoc: Framebuffer auxiliary buffer hint.
End Rem
Const GLFW_AUX_BUFFERS:Int = $0002100B
Rem
bbdoc: OpenGL stereoscopic rendering hint.
End Rem
Const GLFW_STEREO:Int = $0002100C
Rem
bbdoc: Framebuffer MSAA samples hint.
End Rem
Const GLFW_SAMPLES:Int = $0002100D
Rem
bbdoc: Framebuffer sRGB hint.
End Rem
Const GLFW_SRGB_CAPABLE:Int = $0002100E
Rem
bbdoc: Monitor refresh rate hint.
End Rem
Const GLFW_REFRESH_RATE:Int = $0002100F
Rem
bbdoc: Framebuffer double buffering hint.
End Rem
Const GLFW_DOUBLEBUFFER:Int = $00021010
Rem
bbdoc: Context client API hint and attribute.
End Rem
Const GLFW_CLIENT_API:Int = $00022001
Rem
bbdoc: Context client API major version hint and attribute.
End Rem
Const GLFW_CONTEXT_VERSION_MAJOR:Int = $00022002
Rem
bbdoc: Context client API minor version hint and attribute.
End Rem
Const GLFW_CONTEXT_VERSION_MINOR:Int = $00022003
Rem
bbdoc: Context client API revision number attribute.
End Rem
Const GLFW_CONTEXT_REVISION:Int = $00022004
Rem
bbdoc: Context client API revision number hint and attribute.
End Rem
Const GLFW_CONTEXT_ROBUSTNESS:Int = $00022005
Rem
bbdoc: OpenGL forward-compatibility hint and attribute.
End Rem
Const GLFW_OPENGL_FORWARD_COMPAT:Int = $00022006
Rem
bbdoc: OpenGL debug context hint and attribute.
End Rem
Const GLFW_OPENGL_DEBUG_CONTEXT:Int = $00022007
Rem
bbdoc: OpenGL profile hint and attribute.
End Rem
Const GLFW_OPENGL_PROFILE:Int = $00022008
Rem
bbdoc: Context flush-on-release hint and attribute.
End Rem
Const GLFW_CONTEXT_RELEASE_BEHAVIOR:Int = $00022009
Rem
bbdoc: Context error suppression hint and attribute.
End Rem
Const GLFW_CONTEXT_NO_ERROR:Int = $0002200A
Rem
bbdoc: Context creation API hint and attribute.
End Rem
Const GLFW_CONTEXT_CREATION_API:Int = $0002200B
Const GLFW_SCALE_TO_MONITOR:Int = $0002200C
Const GLFW_COCOA_RETINA_FRAMEBUFFER:Int = $00023001
Const GLFW_COCOA_FRAME_NAME:Int = $00023002
Const GLFW_COCOA_GRAPHICS_SWITCHING:Int = $00023003
Const GLFW_X11_CLASS_NAME:Int = $00024001
Const GLFW_X11_INSTANCE_NAME:Int = $00024002
