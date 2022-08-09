' https://learnopengl.com/

SuperStrict

Framework GLFW.GLFWWindow

Import GLFW.GLFW
Import GLFW.GLFWOpenGL
Import GLFW.GLFWSystem

Import BRL.StandardIO

Local app_name:String = "Shaders Interpolation"

Const SCR_WIDTH:UInt	= 800
Const SCR_HEIGHT:UInt	= 600

Type TGameWindow Extends TGLFWWindow
	
	' whenever the window size changed (by OS or user resize) this callback method executes
	Method OnFrameBufferSize (width:Int, height:Int)
		' make sure the viewport matches the new window dimensions; note that width and 
		' height will be significantly larger than specified on retina displays.
		glViewport (0, 0, width, height)
	EndMethod
	
EndType

' process all input: query GLFW whether relevant keys are pressed/released this frame and react accordingly
Function ProcessInput (window:TGLFWWindow)
	
	If window.IsKeyDown (GLFW_KEY_ESCAPE)
		window.SetShouldClose (True)
	EndIf
	
EndFunction

' glfw: initialize and configure
TGLFWWindow.Hint (GLFW_CONTEXT_VERSION_MAJOR, 3)
TGLFWWindow.Hint (GLFW_CONTEXT_VERSION_MINOR, 3)
TGLFWWindow.Hint (GLFW_OPENGL_PROFILE, GLFW_OPENGL_CORE_PROFILE)

?MacOS ' Ewww...
	TGLFWWindow.Hint (GLFW_OPENGL_FORWARD_COMPAT, GL_TRUE)
?

' glfw window creation
Local window:TGLFWWindow = New TGameWindow.Create (SCR_WIDTH, SCR_HEIGHT, app_name)

If Not window
	Print "Failed to create GLFW window!"
	End
EndIf

window.MakeContextCurrent ()

' glad: load all OpenGL function pointers
gladLoadGL (glfwGetProcAddress)

' build and compile our shader program

Local vertexShaderSource:String

vertexShaderSource :+ "#version 330 core~n"
vertexShaderSource :+ "layout (location = 0) in vec3 aPos;~n"
vertexShaderSource :+ "layout (location = 1) in vec3 aColor;~n"
vertexShaderSource :+ "out vec3 ourColor;~n"
vertexShaderSource :+ "void main()~n"
vertexShaderSource :+ "{~n"
vertexShaderSource :+ "   gl_Position = vec4(aPos, 1.0);~n"
vertexShaderSource :+ "   ourColor = aColor;~n"
vertexShaderSource :+ "}~n"

' vertex shader
Local vertexShader:Int = glCreateShader (GL_VERTEX_SHADER)

glShaderSource (vertexShader, 1, vertexShaderSource)
glCompileShader (vertexShader)

Local success:Int
Local infoLog:String

glGetShaderiv (vertexShader, GL_COMPILE_STATUS, Varptr success)

If Not success
	infoLog = glGetShaderInfoLog(vertexShader)
	Print "Vertex shader compilation failed: " + infoLog
EndIf

Local fragmentShaderSource:String

fragmentShaderSource :+ "#version 330 core~n"
fragmentShaderSource :+ "out vec4 FragColor;~n"
fragmentShaderSource :+ "in vec3 ourColor;~n"
fragmentShaderSource :+ "void main()~n"
fragmentShaderSource :+ "{~n"
fragmentShaderSource :+ "   FragColor = vec4(ourColor, 1.0f);~n"
fragmentShaderSource :+ "}~n"

' fragment shader
Local fragmentShader:Int = glCreateShader (GL_FRAGMENT_SHADER)

glShaderSource (fragmentShader, 1, fragmentShaderSource)
glCompileShader (fragmentShader)

' check for shader compile errors
glGetShaderiv (fragmentShader, GL_COMPILE_STATUS, Varptr success)

If Not success
	infoLog = glGetShaderInfoLog(fragmentShader)
	Print "Fragment shader compilation failed: " + infoLog
EndIf

' link shaders
Local shaderProgram:Int = glCreateProgram ()

glAttachShader (shaderProgram, vertexShader)
glAttachShader (shaderProgram, fragmentShader)

glLinkProgram (shaderProgram)

' check for linking errors
glGetProgramiv (shaderProgram, GL_LINK_STATUS, Varptr success)

If Not success
	infoLog = glGetProgramInfoLog (shaderProgram)
	Print "Shader program linking failed: " + infoLog
EndIf

glDeleteShader (vertexShader)
glDeleteShader (fragmentShader)

' set up vertex data (and buffer(s)) and configure vertex attributes
Local vertices:Float [] = [..
	0.5, -0.5, 0.0, 1.0, 0.0, 0.0, ..
	-0.5, -0.5, 0.0, 0.0, 1.0, 0.0, ..
	0.0, 0.5, 0.0, 0.0, 0.0, 1.0]

Local VBO:UInt
Local VAO:UInt

glGenVertexArrays (1, Varptr VAO)
glGenBuffers (1, Varptr VBO)

' bind the Vertex Array Object first, then bind and set vertex buffer(s), and then configure vertex attributes(s).
glBindVertexArray (VAO)

glBindBuffer (GL_ARRAY_BUFFER, VBO)
glBufferData (GL_ARRAY_BUFFER, Int(vertices.length * SizeOf (0:Float)), vertices, GL_STATIC_DRAW)

' position attribute
glVertexAttribPointer (0, 3, GL_FLOAT, GL_FALSE, Int(6 * SizeOf (0:Float)), 0:Byte Ptr)
glEnableVertexAttribArray (0)

Local attribute_offset:Int = 3 * SizeOf (0:Float)

' color attribute
glVertexAttribPointer (1, 3, GL_FLOAT, GL_FALSE, Int(6 * SizeOf (0:Float)), Byte Ptr (attribute_offset))
glEnableVertexAttribArray (1)

' as we only have a single shader, we could also just activate our shader once beforehand if we want to 
glUseProgram (shaderProgram)

' render loop
' -----------
While Not window.ShouldClose ()
	
	' input
	' -----
	ProcessInput (window)

	' render
	' ------
	glClearColor (0.2, 0.3, 0.3, 1.0)
	glClear (GL_COLOR_BUFFER_BIT)
	
	' render the triangle
	glBindVertexArray (VAO)
	glDrawArrays (GL_TRIANGLES, 0, 3)

	' glfw: swap buffers and poll IO events (keys pressed/released, mouse moved etc.)
	window.SwapBuffers ()
	PollSystem ()
	
Wend

' optional: de-allocate all resources once they've outlived their purpose
glDeleteVertexArrays (1, Varptr VAO)
glDeleteBuffers (1, Varptr VBO)

End
