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
