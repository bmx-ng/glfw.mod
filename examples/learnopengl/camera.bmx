SuperStrict

Import BRL.Matrix

' Defines several possible options for camera movement. Used as abstraction to stay away from window-system specific input methods
Enum ECameraMovement
	Forward
	Backward
	Left
	Right
End Enum

' Default camera values
Const DEFAULT_YAW:Float = -90.0
Const DEFAULT_PITCH:Float = 0.0
Const DEFAULT_SPEED:Float = 2.5
Const DEFAULT_SENSITIVITY:Float =  0.1
Const DEFAULT_ZOOM:Float = 45.0


' An abstract camera class that processes input and calculates the corresponding Euler Angles, Vectors and Matrices for use in OpenGL
Type TCamera
	' Camera Attributes
	Field position:SVec3F
	Field front:SVec3F
	Field up:SVec3F
	Field Right:SVec3F
	Field worldUp:SVec3F
	' Euler Angles
	Field yaw:Float
	Field pitch:Float
	' Camera options
	Field movementSpeed:Float
	Field mouseSensitivity:Float
	Field zoom:Float

	' Constructor with vectors
	Method New(position:SVec3F = Null, upX:Float = 0, upY:Float = 1, upZ:Float = 0, yaw:Float = DEFAULT_YAW, pitch:Float = DEFAULT_PITCH)
		front = New SVec3F(0.0, 0.0, -1.0)
		movementSpeed = DEFAULT_SPEED
		mouseSensitivity = DEFAULT_SENSITIVITY
		zoom = DEFAULT_ZOOM
		
		Self.position = position
		worldUp = New SVec3F(upX, upY, upZ)
		Self.yaw = yaw
		Self.pitch = pitch

		updateCameraVectors()
	End Method
	
	' Constructor with scalar values
	Method New(posX:Float, posY:Float, posZ:Float, upX:Float, upY:Float, upZ:Float, yaw:Float, pitch:Float)
		front = New SVec3F(0.0, 0.0, -1.0)
		movementSpeed = DEFAULT_SPEED
		mouseSensitivity = DEFAULT_SENSITIVITY
		zoom = DEFAULT_ZOOM

		position = New SVec3F(posX, posY, posZ)
		worldUp = New SVec3F(upX, upY, upZ)
		Self.yaw = yaw
		Self.pitch = pitch

		updateCameraVectors()
	End Method

	' Returns the view matrix calculated using Euler Angles and the LookAt Matrix
	Method GetViewMatrix:SMat4F()
		Return SMat4F.LookAt(position, position + front, up)
	End Method

	' Processes input received from any keyboard-like input system. Accepts input parameter in the form of camera defined ENUM (to abstract it from windowing systems)
	Method ProcessKeyboard(direction:ECameraMovement, deltaTime:Float)
		Local velocity:Float = movementSpeed * deltaTime
		If direction = ECameraMovement.Forward Then
			position = position + (front * velocity)
		End If
		If direction = ECameraMovement.Backward Then
			position = position - (front * velocity)
		End If
		If direction = ECameraMovement.Left Then
			position = position - (Right * velocity)
		End If
		If direction = ECameraMovement.Right Then
			position = position + (Right * velocity)
		End If
	End Method

	Method ProcessMouseMovement(xoffset:Float, yoffset:Float, constrainPitch:Int = True)
		xoffset :* mouseSensitivity
		yoffset :* mouseSensitivity
		
		yaw :+ xoffset
		pitch :+ yoffset
		
		' Make sure that when pitch is out of bounds, screen doesn't get flipped
		If constrainPitch Then
			If pitch > 89.0 Then
				pitch = 89.0
			End If
			
			If pitch < -89.0 Then
				pitch = -89.0
			End If
		End If
		
		' Update Front, Right and Up Vectors using the updated Euler angles
		updateCameraVectors()
	End Method
	
	' Processes input received from a mouse scroll-wheel event. Only requires input on the vertical wheel-axis
	Method ProcessMouseScroll(yoffset:Float)
		If zoom >= 1.0 And zoom <= 45.0 Then
			zoom :- yoffset
		End If
		
		If zoom <= 1.0 Then
			zoom = 1.0
		End If
		
		If zoom >= 45.0 Then
			zoom = 45.0
		End If
	End Method
	
Private
	' Calculates the front vector from the Camera's (updated) Euler Angles
	Method updateCameraVectors()
		' Calculate the new Front vector
		Local newFront:SVec3F = New SVec3F(Float(Cos(yaw) * Cos(pitch)), Float(Sin(pitch)), Float(Sin(yaw) * Cos(pitch)))
		front = newFront.Normal()
		' Also re-calculate the Right and Up vector
		Right = front.Cross(worldUp).Normal() ' Normalize the vectors, because their length gets closer to 0 the more you look up or down which results in slower movement.
		up = Right.Cross(front).Normal()
	End Method
	
End Type
