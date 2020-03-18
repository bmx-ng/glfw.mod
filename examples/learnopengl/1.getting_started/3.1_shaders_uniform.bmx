' https://learnopengl.com/

SuperStrict

Framework GLFW.GLFWWindow

Import GLFW.GLFW
Import GLFW.GLFWOpenGL
Import GLFW.GLFWSystem

Import BRL.StandardIO

Local app_name:String = "Shaders Uniform"

' settings
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

' initialize and configure
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
vertexShaderSource :+ "void main()~n"
vertexShaderSource :+ "{~n"
vertexShaderSource :+ "   gl_Position = vec4(aPos, 1.0);~n"
vertexShaderSource :+ "}~n"

Local fragmentShaderSource:String

fragmentShaderSource :+ "#version 330 core~n"
fragmentShaderSource :+ "out vec4 FragColor;~n"
fragmentShaderSource :+ "uniform vec4 ourColor;~n"
fragmentShaderSource :+ "void main()~n"
fragmentShaderSource :+ "{~n"
fragmentShaderSource :+ "   FragColor = ourColor;~n"
fragmentShaderSource :+ "}~n"

Local vertexShader:Int = glCreateShader (GL_VERTEX_SHADER)

glShaderSource (vertexShader, 1, vertexShaderSource)
glCompileShader (vertexShader)

Local success:Int
Local infoLog:Byte [512]

glGetShaderiv (vertexShader, GL_COMPILE_STATUS, Varptr success)

If Not success
	glGetShaderInfoLog (vertexShader, 512, Null, infoLog)
	Print "Vertex shader compilation failed: " + String.FromCString (infoLog)
EndIf

Local fragmentShader:Int = glCreateShader (GL_FRAGMENT_SHADER)

glShaderSource (fragmentShader, 1, fragmentShaderSource)
glCompileShader (fragmentShader)

glGetShaderiv (fragmentShader, GL_COMPILE_STATUS, Varptr success)

If Not success
	glGetShaderInfoLog (fragmentShader, 512, Null, infoLog)
	Print "Fragment shader compilation failed: " + String.FromCString (infoLog)
EndIf

' link shaders
Local shaderProgram:Int = glCreateProgram ()

glAttachShader (shaderProgram, vertexShader)
glAttachShader (shaderProgram, fragmentShader)
glLinkProgram (shaderProgram)

glGetProgramiv (shaderProgram, GL_LINK_STATUS, Varptr success)

If Not success
	glGetProgramInfoLog (shaderProgram, 512, Null, infoLog)
	Print "Shader program linking failed: " + String.FromCString (infoLog)
EndIf

glDeleteShader (vertexShader)
glDeleteShader (fragmentShader)

' set up vertex data (and buffer(s)) and configure vertex attributes
Local vertices:Float [] = [..
	0.5, -0.5, 0.0, ..
	-0.5, -0.5, 0.0, ..
	0.0, 0.5, 0.0]

Local VBO:UInt
Local VAO:UInt

glGenVertexArrays (1, Varptr VAO)
glGenBuffers (1, Varptr VBO)

' bind the Vertex Array Object first, then bind and set vertex buffer(s), and then configure vertex attributes(s).
glBindVertexArray (VAO)

glBindBuffer (GL_ARRAY_BUFFER, VBO)
glBufferData (GL_ARRAY_BUFFER, vertices.length * SizeOf (0:Float), vertices, GL_STATIC_DRAW)

glVertexAttribPointer (0, 3, GL_FLOAT, GL_FALSE, 3 * SizeOf (0:Float), 0:Byte Ptr)
glEnableVertexAttribArray (0)

' bind the VAO (it was already bound, but just to demonstrate): seeing as we only have a single VAO we can
' just bind it beforehand before rendering the respective triangle; this is another approach.

glBindVertexArray (VAO)

While Not window.ShouldClose ()
	
	' input
	' -----
	ProcessInput (window)

	' render
	' ------
	glClearColor (0.2, 0.3, 0.3, 1.0)
	glClear (GL_COLOR_BUFFER_BIT)
	
	' be sure to activate the shader before any calls to glUniform
	glUseProgram (shaderProgram)

	' update shader uniform
	Local timeValue:Float = GetTime()
	Local greenValue:Float = Sin (timeValue * 57.2958) / 2.0 + 0.5

	Local vertexColorLocation:Int = glGetUniformLocation (shaderProgram, "ourColor")
	glUniform4f (vertexColorLocation, 0.0, greenValue, 0.0, 1.0)

	' render the triangle
	glDrawArrays (GL_TRIANGLES, 0, 3)

	' swap buffers and poll IO events (keys pressed/released, mouse moved etc.)
	window.SwapBuffers ()
	PollSystem ()
	
Wend

' optional: de-allocate all resources once they've outlived their purpose
glDeleteVertexArrays (1, Varptr VAO)
glDeleteBuffers (1, Varptr VBO)

End
