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

?linux
Import "-ldl"
Import "-lX11"
?macos
Import "-framework IOKit"
?

Import "source.bmx"

Extern
	Function glfwGetProcAddress:Int(name:Byte Ptr)
	Function glfwSwapInterval(interval:Int)
	Function bmx_glfw_glfwGetTime:Double()="glfwGetTime"
	Function bmx_glfw_glfwSetTime(time:Double)="glfwSetTime"

	Function bmx_glfw_glfwSetClipboardString(window:Byte Ptr, txt:Byte Ptr)="glfwSetClipboardString"
	Function bmx_glfw_glfwGetClipboardString:Byte Ptr(window:Byte Ptr)="glfwGetClipboardString"

End Extern

Const GLFW_NO_API:Int = 0
Const GLFW_OPENGL_API:Int = $00030001
Const GLFW_OPENGL_ES_API:Int = $00030002

Const GLFW_NO_ROBUSTNESS:Int = 0
Const GLFW_NO_RESET_NOTIFICATION:Int = $00031001
Const GLFW_LOSE_CONTEXT_ON_RESET:Int = $00031002

Const GLFW_OPENGL_ANY_PROFILE:Int = 0
Const GLFW_OPENGL_CORE_PROFILE:Int = $00032001
Const GLFW_OPENGL_COMPAT_PROFILE:Int = $00032002

Const GLFW_CURSOR:Int = $00033001
Const GLFW_STICKY_KEYS:Int = $00033002
Const GLFW_STICKY_MOUSE_BUTTONS:Int = $00033003
Const GLFW_LOCK_KEY_MODS:Int = $00033004
Const GLFW_RAW_MOUSE_MOTION:Int = $00033005

Const GLFW_CURSOR_NORMAL:Int = $00034001
Const GLFW_CURSOR_HIDDEN:Int = $00034002
Const GLFW_CURSOR_DISABLED:Int = $00034003

Const GLFW_ANY_RELEASE_BEHAVIOR:Int = 0
Const GLFW_RELEASE_BEHAVIOR_FLUSH:Int = $00035001
Const GLFW_RELEASE_BEHAVIOR_NONE:Int = $00035002

Const GLFW_NATIVE_CONTEXT_API:Int = $00036001
Const GLFW_EGL_CONTEXT_API:Int = $00036002
Const GLFW_OSMESA_CONTEXT_API:Int = $00036003
