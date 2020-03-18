' https://learnopengl.com/

SuperStrict

Framework GLFW.GLFWWindow

Import GLFW.GLFW
Import GLFW.GLFWOpenGL
Import GLFW.GLFWSystem

Import BRL.StandardIO

Local app_name:String = "Hello Window"

Const SCR_WIDTH:UInt	= 800
Const SCR_HEIGHT:UInt	= 600

Type TGameWindow Extends TGLFWWindow
	
	Method OnFrameBufferSize (width:Int, height:Int)
		glViewport (0, 0, width, height)
	EndMethod
	
EndType

Function ProcessInput (window:TGLFWWindow)
	
	If window.IsKeyDown (GLFW_KEY_ESCAPE)
		window.SetShouldClose (True)
	EndIf
	
EndFunction

TGLFWWindow.Hint (GLFW_CONTEXT_VERSION_MAJOR, 3)
TGLFWWindow.Hint (GLFW_CONTEXT_VERSION_MINOR, 3)
TGLFWWindow.Hint (GLFW_OPENGL_PROFILE, GLFW_OPENGL_CORE_PROFILE)

?MacOS ' Ewww...
	TGLFWWindow.Hint (GLFW_OPENGL_FORWARD_COMPAT, GL_TRUE)
?

Local window:TGLFWWindow = New TGameWindow.Create(SCR_WIDTH, SCR_HEIGHT, app_name)

If Not window
	Print "Failed to create GLFW window!"
	End
EndIf

window.MakeContextCurrent ()

gladLoadGL (glfwGetProcAddress)

While Not window.ShouldClose ()
	ProcessInput (window)
	window.SwapBuffers ()
	PollSystem ()
Wend

End
