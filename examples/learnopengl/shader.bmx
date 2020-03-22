SuperStrict

Import GLFW.GLFWOpenGL
Import BRL.Matrix
Import BRL.StandardIO

Type TShader

	Field id:Int
	
	Method New(vertexPath:String, fragmentPath:String, geometryPath:String = Null)
		' retrieve the vertex/fragment source code from filePath
		Local vertexCode:String
		Local fragmentCode:String
		Local geometryCode:String
		
		Try
			vertexCode = LoadText(vertexPath)
			fragmentCode = LoadText(fragmentPath)
			If geometryPath Then
				geometryCode = LoadText(geometryPath)
			End If
		Catch e:TStreamReadException
			Print "ERROR::SHADER::FILE_NOT_SUCCESFULLY_READ"
		End Try
		
		' compile shaders

		' vertex shader
		Local vertex:Int = glCreateShader(GL_VERTEX_SHADER)
        glShaderSource(vertex, 1, vertexCode)
        glCompileShader(vertex)
        checkCompileErrors(vertex, "VERTEX")
		
		' fragment Shader
		Local fragment:Int = glCreateShader(GL_FRAGMENT_SHADER)
        glShaderSource(fragment, 1, fragmentCode)
        glCompileShader(fragment)
        checkCompileErrors(fragment, "FRAGMENT")

		' if geometry shader is given, compile geometry shader
		Local geometry:Int
		If geometryPath Then
			geometry = glCreateShader(GL_GEOMETRY_SHADER)
			glShaderSource(geometry, 1, geometryCode)
			glCompileShader(geometry)
			checkCompileErrors(geometry, "GEOMETRY")
		End If
		
		' shader Program
		id = glCreateProgram()
		glAttachShader(id, vertex)
		glAttachShader(id, fragment)

		If geometryPath Then
			glAttachShader(id, geometry)
		End If

		glLinkProgram(id)
		checkCompileErrors(id, "PROGRAM")
		
		' delete the shaders as they're linked into our program now and no longer necessary
		glDeleteShader(vertex)
		glDeleteShader(fragment)
		If geometryPath Then
			glDeleteShader(geometry)
		End If
	End Method
	
	' activate the shader
	Method use()
		glUseProgram(id)
	End Method
	
	' utility uniform method
	Method setBool(name:String, value:Int)
		glUniform1i(glGetUniformLocation(id, name), value)
	End Method
	
	Method setInt(name:String, value:Int)
		glUniform1i(glGetUniformLocation(id, name), value)
	End Method
	
	Method SetFloat(name:String, value:Float)
		glUniform1f(glGetUniformLocation(id, name), value)
	End Method

	Method setVec2(name:String, value:SVec2F)
		glUniform2fv(glGetUniformLocation(id, name), 1, Varptr value.x) 
	End Method
	
	Method setVec2(name:String, x:Float, y:Float)
		glUniform2f(glGetUniformLocation(id, name), x, y)
	End Method

	Method setVec3(name:String, value:SVec3F)
		glUniform3fv(glGetUniformLocation(id, name), 1, Varptr value.x) 
	End Method
	
	Method setVec3(name:String, x:Float, y:Float, z:Float)
		glUniform3f(glGetUniformLocation(id, name), x, y, z)
	End Method

	Method setVec4(name:String, x:Float, y:Float, z:Float, w:Float)
		glUniform4f(glGetUniformLocation(id, name), x, y, z, w)
	End Method

	Method setMat2(name:String, mat:SMat2F)
		glUniformMatrix2fv(glGetUniformLocation(id, name), 1, False, Varptr mat.a)
	End Method

	Method setMat3(name:String, mat:SMat3F)
		glUniformMatrix3fv(glGetUniformLocation(id, name), 1, False, Varptr mat.a)
	End Method

	Method setMat4(name:String, mat:SMat4F)
		glUniformMatrix4fv(glGetUniformLocation(id, name), 1, False, Varptr mat.a)
	End Method
	
	' utility method for checking shader compilation/linking errors.
	Method checkCompileErrors(shader:Int, shaderType:String)
		Local success:Int
		If shaderType <> "PROGRAM" Then
			glGetShaderiv(shader, GL_COMPILE_STATUS, Varptr success)
			If Not success Then
				Local infoLog:String = glGetShaderInfoLog(shader)
				Print "ERROR::SHADER_COMPILATION_ERROR of type: " + shaderType + "~n" + infoLog + "~n -- --------------------------------------------------- -- "
			End If
		Else
			glGetProgramiv(shader, GL_LINK_STATUS, Varptr success)
			If Not success Then
				Local infoLog:String = glGetProgramInfoLog(shader)
				Print "ERROR::PROGRAM_LINKING_ERROR of type: " + shaderType + "~n" + infoLog + "~n -- --------------------------------------------------- -- "
			End If
		End If
		
	End Method
	
End Type
