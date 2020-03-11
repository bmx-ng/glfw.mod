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

Import "source.bmx"

Extern
	Function glfwGetProcAddress:Int(name:Byte Ptr)
	Function glfwSwapInterval(interval:Int)
End Extern

Const GLFW_FOCUSED:Int = $00020001
Const GLFW_ICONIFIED:Int = $00020002
Const GLFW_RESIZABLE:Int = $00020003
Const GLFW_VISIBLE:Int = $00020004
Const GLFW_DECORATED:Int = $00020005
Const GLFW_AUTO_ICONIFY:Int = $00020006
Const GLFW_FLOATING:Int = $00020007
Const GLFW_MAXIMIZED:Int = $00020008
Const GLFW_CENTER_CURSOR:Int = $00020009
Const GLFW_TRANSPARENT_FRAMEBUFFER:Int = $0002000A
Const GLFW_HOVERED:Int = $0002000B
Const GLFW_FOCUS_ON_SHOW:Int = $0002000C
Const GLFW_RED_BITS:Int = $00021001
Const GLFW_GREEN_BITS:Int = $00021002
Const GLFW_BLUE_BITS:Int = $00021003
Const GLFW_ALPHA_BITS:Int = $00021004
Const GLFW_DEPTH_BITS:Int = $00021005
Const GLFW_STENCIL_BITS:Int = $00021006
Const GLFW_ACCUM_RED_BITS:Int = $00021007
Const GLFW_ACCUM_GREEN_BITS:Int = $00021008
Const GLFW_ACCUM_BLUE_BITS:Int = $00021009
Const GLFW_ACCUM_ALPHA_BITS:Int = $0002100A
Const GLFW_AUX_BUFFERS:Int = $0002100B
Const GLFW_STEREO:Int = $0002100C
Const GLFW_SAMPLES:Int = $0002100D
Const GLFW_SRGB_CAPABLE:Int = $0002100E
Const GLFW_REFRESH_RATE:Int = $0002100F
Const GLFW_DOUBLEBUFFER:Int = $00021010
Const GLFW_CLIENT_API:Int = $00022001
Const GLFW_CONTEXT_VERSION_MAJOR:Int = $00022002
Const GLFW_CONTEXT_VERSION_MINOR:Int = $00022003
Const GLFW_CONTEXT_REVISION:Int = $00022004
Const GLFW_CONTEXT_ROBUSTNESS:Int = $00022005
Const GLFW_OPENGL_FORWARD_COMPAT:Int = $00022006
Const GLFW_OPENGL_DEBUG_CONTEXT:Int = $00022007
Const GLFW_OPENGL_PROFILE:Int = $00022008
Const GLFW_CONTEXT_RELEASE_BEHAVIOR:Int = $00022009
Const GLFW_CONTEXT_NO_ERROR:Int = $0002200A
Const GLFW_CONTEXT_CREATION_API:Int = $0002200B
Const GLFW_SCALE_TO_MONITOR:Int = $0002200C
Const GLFW_COCOA_RETINA_FRAMEBUFFER:Int = $00023001
Const GLFW_COCOA_FRAME_NAME:Int = $00023002
Const GLFW_COCOA_GRAPHICS_SWITCHING:Int = $00023003
Const GLFW_X11_CLASS_NAME:Int = $00024001
Const GLFW_X11_INSTANCE_NAME:Int = $00024002

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
