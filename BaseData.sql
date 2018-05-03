CREATE DATABASE omnitrix
GO
USE omnitrix
GO

CREATE TABLE Usuario(
Id_Usuario INT IDENTITY (1,1) PRIMARY KEY,
Nombre NVARCHAR(50) UNIQUE NOT NULL,
Nick NVARCHAR(50) UNIQUE NOT NULL,
Correo NVARCHAR(40) UNIQUE NOT NULL,
Contrasenia NVARCHAR(200) NOT NULL,
Fecha_Nacimiento DATE,
Verificacion_Clave NVARCHAR(300),
Estatus BIT DEFAULT '0',
Imagen_Perfil NVARCHAR(80),
Imagen_Portada NVARCHAR(80),
Telefono NVARCHAR(20),
Telefono_Casa NVARCHAR(20),
Biografia NVARCHAR(300),

)
GO
CREATE TABLE Amistad(
Id_Amistad INT PRIMARY KEY IDENTITY (1,1),
Id_Usuario INT FOREIGN KEY REFERENCES Usuario(Id_Usuario) NOT NULL,
Id_Usuario_Dos INT FOREIGN KEY REFERENCES Usuario(Id_Usuario) NOT NULL
)
GO

CREATE TABLE Publicacion(
Id_Publicacion INT IDENTITY PRIMARY KEY,
Id_Usuario INT FOREIGN KEY REFERENCES Usuario(Id_Usuario) NOT NULL,
Id_Amistad INT FOREIGN KEY REFERENCES Amistad(Id_Amistad),
Titulo NVARCHAR(150),
Imagen NVARCHAR(80),
Fecha_Publicacion DATETIME NOT NULL
)
GO
CREATE TABLE Comentario(
Id_Comentario INT IDENTITY (1,1) PRIMARY KEY,
Id_Usuario INT FOREIGN KEY REFERENCES Usuario(Id_Usuario) NOT NULL,
Id_Publicacion INT FOREIGN KEY REFERENCES Publicacion(Id_Publicacion) NOT NULL,
Comentario NVARCHAR(260)
)
GO

CREATE PROCEDURE [dbo].[sp_UpNombre]
@Variable NVARCHAR(50),
@Id INT
AS
UPDATE Usuario SET Nombre = @Variable 
WHERE Id_Usuario = @Id
GO

CREATE PROCEDURE [dbo].[sp_UpNick]
@Variable NVARCHAR(50),
@Id INT
AS
UPDATE Usuario SET Nick = @Variable 
WHERE Id_Usuario = @Id
GO
CREATE PROCEDURE [dbo].[sp_UpCorreo]
@Variable NVARCHAR(40),
@Id INT
AS
UPDATE Usuario SET Correo = @Variable 
WHERE Id_Usuario = @Id
GO
CREATE PROCEDURE [dbo].[sp_UpContrasenia]
@Variable NVARCHAR(200),
@Id INT
AS
UPDATE Usuario SET Contrasenia = @Variable 
WHERE Id_Usuario = @Id
GO
CREATE PROCEDURE [dbo].[sp_UpImagen_Perfil]
@Variable NVARCHAR(80),
@Id INT
AS
UPDATE Usuario SET Imagen_Perfil = @Variable 
WHERE Id_Usuario = @Id
GO
CREATE PROCEDURE [dbo].[sp_UpImagen_Portada]
@Variable NVARCHAR(80),
@Id INT
AS
UPDATE Usuario SET Imagen_Portada = @Variable 
WHERE Id_Usuario = @Id
GO
CREATE PROCEDURE [dbo].[sp_UpTelefono]
@Variable NVARCHAR(20),
@Id INT
AS
UPDATE Usuario SET Telefono = @Variable 
WHERE Id_Usuario = @Id
GO
CREATE PROCEDURE [dbo].[sp_UpTelefono_Casa]
@Variable NVARCHAR(20),
@Id INT
AS
UPDATE Usuario SET Telefono_Casa = @Variable 
WHERE Id_Usuario = @Id
GO
CREATE PROCEDURE [dbo].[sp_UpBiografia]
@Variable NVARCHAR(300),
@Id INT
AS
UPDATE Usuario SET Biografia = @Variable 
WHERE Id_Usuario = @Id
GO
CREATE PROCEDURE [dbo].[sp_UpComentario]
@Variable NVARCHAR(260),
@Id INT
AS
UPDATE Comentario SET Comentario = @Variable 
WHERE Id_Comentario = @Id
GO
CREATE PROCEDURE[dbo].[sp_InImg_Perfil]
@Variable NVARCHAR(80)
AS
INSERT INTO Usuario(Imagen_Perfil)
Values (@Variable)
GO
CREATE PROCEDURE[dbo].[sp_InImg_Portada]
@Variable NVARCHAR(80)
AS
INSERT INTO Usuario(Imagen_Portada)
Values (@Variable)
GO
CREATE PROCEDURE[dbo].[sp_InAmistad]
@Id1 INT,
@Id2 INT
AS
INSERT INTO Amistad(Id_Usuario, Id_Usuario_Dos)
VALUES(@Id1, @Id2)
GO
CREATE PROCEDURE[dbo].[sp_InPublicacion]
@Id INT,
@Variable NVARCHAR(150),
@Variable2 NVARCHAR(80)
AS
INSERT INTO Publicacion(Id_Usuario, Titulo, Imagen, Fecha_Publicacion)
VALUES(@Id, @Variable, @Variable2, CURRENT_TIMESTAMP)
GO
CREATE PROCEDURE [dbo].[sp_InComentario]
@Id INT,
@Id2 INT,
@Variable NVARCHAR(260)
AS
INSERT INTO Comentario(Id_Usuario, Id_Publicacion, Comentario)
VALUES (@Id, @Id2, @Variable)
GO
CREATE PROCEDURE [dbo].[sp_InUsuario]
@Nombre NVARCHAR(50),
@Correo NVARCHAR(40),
@Contrasenia NVARCHAR(200),
@FechaNacimiento Date
AS
	INSERT INTO Usuario(Nombre, Correo, Contrasenia, Fecha_Nacimiento) VALUES(@Nombre, @Correo, @Contrasenia, @FechaNacimiento)
	DECLARE @lastId INT
	SET @lastId = (SELECT MAX(Id_Usuario) FROM Usuario)
	SELECT * FROM Usuario WHERE Id_Usuario = @lastId
GO
CREATE PROCEDURE [dbo].[sp_LoginUser]
@_Nick NVARCHAR(50),
@_Password NVARCHAR(200)
AS
	SELECT * FROM Usuario WHERE Nick = @_Nick AND Contrasenia = @_Password
GO