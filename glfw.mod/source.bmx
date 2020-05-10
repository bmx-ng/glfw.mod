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

Import "glfw/include/*.h"
Import "glfw/deps/*.h"

?macos
Import "glfw/src/cocoa_init.m"
Import "glfw/src/cocoa_joystick.m"
Import "glfw/src/cocoa_monitor.m"
Import "glfw/src/cocoa_time.c"
Import "glfw/src/cocoa_window.m"
Import "glfw/src/nsgl_context.m"
?
Import "glfw/src/context.c"
Import "glfw/src/egl_context.c"
?linux
Import "glfw/src/glx_context.c"
?
Import "glfw/src/init.c"
Import "glfw/src/input.c"
?linux
Import "glfw/src/linux_joystick.c"
Import "glfw/src/posix_time.c"
?
Import "glfw/src/monitor.c"
'Import "glfw/src/null_init.c"
'Import "glfw/src/null_joystick.c"
'Import "glfw/src/null_monitor.c"
'Import "glfw/src/null_window.c"
Import "glfw/src/osmesa_context.c"
?linux Or macos
Import "glfw/src/posix_thread.c"
?
Import "glfw/src/vulkan.c"
?win32
Import "glfw/src/wgl_context.c"
Import "glfw/src/win32_init.c"
Import "glfw/src/win32_joystick.c"
Import "glfw/src/win32_monitor.c"
Import "glfw/src/win32_thread.c"
Import "glfw/src/win32_time.c"
Import "glfw/src/win32_window.c"
?
Import "glfw/src/window.c"
?linux
'Import "glfw/src/wl_init.c"
'Import "glfw/src/wl_monitor.c"
'Import "glfw/src/wl_window.c"
Import "glfw/src/x11_init.c"
Import "glfw/src/x11_monitor.c"
Import "glfw/src/x11_window.c"
Import "glfw/src/xkb_unicode.c"
?

Import "glfw/deps/glad_gl.c"
