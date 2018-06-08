CREATE DATABASE omnitrix
GO


USE omnitrix
GO

CREATE TABLE Usuario(
Id_Usuario BIGINT IDENTITY (1,1) PRIMARY KEY,
Nombre NVARCHAR(50) UNIQUE NOT NULL,
Nick NVARCHAR(50) UNIQUE NOT NULL,
Correo NVARCHAR(40) UNIQUE NOT NULL,
Contrasenia NVARCHAR(200) NOT NULL,
Fecha_Nacimiento DATE,
Verificacion_Clave NVARCHAR(300),
Estatus BIT DEFAULT '0',
)
GO

CREATE TABLE Datos(
Id_Datos BIGINT IDENTITY (1,1) PRIMARY KEY,
Id_Usuario BIGINT FOREIGN KEY REFERENCES Usuario(Id_Usuario) NOT NULL,
Vocacion NVARCHAR(60),
Ciudad NVARCHAR(30),
Pais NVARCHAR(40),
Estado NVARCHAR(200),
Seguidores BIGINT,
Siguiendo BIGINT,
NombreArtistico NVARCHAR(100),
Imagen_Perfil NVARCHAR(80),
Imagen_Portada NVARCHAR(80),
Telefono NVARCHAR(20),
Telefono_Casa NVARCHAR(20),
Biografia NVARCHAR(300)
)
GO


CREATE TRIGGER tgr_Usuario_Datos
ON Usuario
AFTER INSERT
AS
BEGIN
SET NOCOUNT ON;
INSERT INTO Datos(Id_Usuario)
SELECT MAX(Id_Usuario) FROM Usuario
END
GO

CREATE TABLE Amistad(
Id_Amistad BIGINT PRIMARY KEY IDENTITY (1,1),
Id_Usuario BIGINT FOREIGN KEY REFERENCES Usuario(Id_Usuario) NOT NULL,
Id_Usuario_Dos BIGINT FOREIGN KEY REFERENCES Usuario(Id_Usuario) NOT NULL
)
GO

CREATE TABLE Publicacion(
Id_Publicacion BIGINT IDENTITY PRIMARY KEY,
Id_Usuario BIGINT FOREIGN KEY REFERENCES Usuario(Id_Usuario) NOT NULL,
Id_Amistad BIGINT FOREIGN KEY REFERENCES Amistad(Id_Amistad),
Titulo NVARCHAR(150),
Imagen NVARCHAR(80),
Tipo INT,
Descripcion NVARCHAR(300),
Fuente NVARCHAR(200) NULL,
Fecha_Publicacion DATETIME NOT NULL
)
GO
CREATE TABLE Comentario(
Id_Comentario BIGINT IDENTITY (1,1) PRIMARY KEY,
Id_Usuario BIGINT FOREIGN KEY REFERENCES Usuario(Id_Usuario) NOT NULL,
Id_Publicacion BIGINT FOREIGN KEY REFERENCES Publicacion(Id_Publicacion) NOT NULL,
Comentario NVARCHAR(260)
)
GO
CREATE TABLE Notificacion(
Id_Notificacion BIGINT IDENTITY (1,1) PRIMARY KEY,
Id_Publicacion BIGINT FOREIGN KEY REFERENCES Publicacion(Id_Publicacion) NOT NULL,
Estatus INT DEFAULT '1'
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
CREATE PROCEDURE [dbo].[sp_UpComentario]
@Variable NVARCHAR(260),
@Id INT
AS
UPDATE Comentario SET Comentario = @Variable 
WHERE Id_Comentario = @Id
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

CREATE PROCEDURE [dbo].[sp_InComentario]
@Id_Usuario INT,
@Id_Publicacion INT,
@Comentario NVARCHAR(260)
AS
	INSERT INTO Comentario(Id_Usuario, Id_Publicacion, Comentario) VALUES (@Id_Usuario, @Id_Publicacion, @Comentario)
	DECLARE @lastCom INT
	SET @lastCom = (SELECT MAX(Id_Comentario) FROM Comentario)
	SELECT * FROM Comentario WHERE Id_Comentario = @lastCom
GO

CREATE PROCEDURE [dbo].[sp_InAmistad]
@Id_Usuario INT,
@Id_Usuario_Dos INT
AS
	INSERT INTO Amistad(Id_Usuario, Id_Usuario_Dos) VALUES (@Id_Usuario, @Id_Usuario_Dos)
	DECLARE @lastAm INT
	SET @lastAm = (SELECT MAX(Id_Amistad) FROM Amistad)
	SELECT * FROM Amistad WHERE Id_Amistad = @lastAm
GO


CREATE PROCEDURE [dbo].[sp_UpVocacion]
@Id INT,
@Variable NVARCHAR(60)
AS
UPDATE Datos SET @Variable=Vocacion WHERE Id_Usuario=@Id
GO
CREATE PROCEDURE [dbo].[sp_UpCiudad]
@Id INT,
@Variable NVARCHAR(30)
AS
UPDATE Datos SET @Variable=Ciudad WHERE Id_Usuario=@Id
GO
CREATE PROCEDURE [dbo].[sp_UpPais]
@Id INT,
@Variable NVARCHAR(40)
AS
UPDATE Datos SET @Variable=Pais WHERE Id_Usuario=@Id
GO
CREATE PROCEDURE [dbo].[sp_UpEstado]
@Id INT,
@Variable NVARCHAR(200)
AS
UPDATE Datos SET @Variable=Estado WHERE Id_Usuario=@Id
GO
CREATE PROCEDURE [dbo].[sp_UpSeguidores]
@Id INT,
@Variable BIGINT
AS
UPDATE Datos SET @Variable=Seguidores WHERE Id_Usuario=@Id
GO
CREATE PROCEDURE [dbo].[sp_UpSiguiendo]
@Id INT,
@Variable BIGINT
AS
UPDATE Datos SET @Variable=Siguiendo WHERE Id_Usuario=@Id
GO
CREATE PROCEDURE [dbo].[sp_UpNombreArtistico]
@Id INT,
@Variable NVARCHAR(100)
AS
UPDATE Datos SET @Variable=NombreArtistico WHERE Id_Usuario=@Id
GO
CREATE PROCEDURE [dbo].[sp_UpImagen_Perfil]
@Id INT,
@Variable NVARCHAR(80)
AS
UPDATE Datos SET @Variable=Imagen_Perfil WHERE Id_Usuario=@Id
GO
CREATE PROCEDURE [dbo].[sp_UpImagen_Portada]
@Id INT,
@Variable NVARCHAR(80)
AS
UPDATE Datos SET @Variable=Imagen_Portada WHERE Id_Usuario=@Id
GO
CREATE PROCEDURE [dbo].[sp_UpTelefono]
@Id INT,
@Variable NVARCHAR(20)
AS
UPDATE Datos SET @Variable=Telefono WHERE Id_Usuario=@Id
GO
CREATE PROCEDURE [dbo].[sp_UpTelefono_Casa]
@Id INT,
@Variable NVARCHAR(20)
AS
UPDATE Datos SET @Variable=Telefono_Casa WHERE Id_Usuario=@Id
GO
CREATE PROCEDURE [dbo].[sp_UpBiografia]
@Id INT,
@Variable NVARCHAR(300)
AS
UPDATE Datos SET @Variable=Biografia WHERE Id_Usuario=@Id
GO