CREATE DATABASE omnitrix
GO

USE omnitrix
GO

CREATE TABLE Usuario(
Id_Usuario BIGINT IDENTITY (1,1) PRIMARY KEY,
Nombre NVARCHAR(50) NOT NULL,
Nick NVARCHAR(50) NOT NULL,
Correo NVARCHAR(40) NOT NULL,
Contrasenia NVARCHAR(200) NOT NULL,
Fecha_Nacimiento DATE,
Verificacion_Clave NVARCHAR(300),
Estatus BIT DEFAULT '1',
CONSTRAINT UQ_Nick UNIQUE (Nick),
CONSTRAINT UQ_Correo UNIQUE (Correo)
)
GO
SELECT * FROM usuario

CREATE TABLE Datos(
Id_Datos BIGINT IDENTITY (1,1) PRIMARY KEY,
Id_Usuario BIGINT FOREIGN KEY REFERENCES Usuario(Id_Usuario) NOT NULL,
Vocacion NVARCHAR(60),
Ciudad NVARCHAR(30),
Pais NVARCHAR(40),
Estado NVARCHAR(200),
Seguidores BIGINT DEFAULT 0,
Siguiendo BIGINT DEFAULT 0,
NombreArtistico NVARCHAR(100),
Imagen_Perfil NVARCHAR(80) DEFAULT '../recursos/img/logo.png',
Imagen_Portada NVARCHAR(80) DEFAULT '../recursos/img/logo.png',
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
CONSTRAINT UC_Amistad UNIQUE (Id_Usuario,Id_Usuario_Dos)
)
GO

CREATE TABLE Publicacion(
Id_Publicacion BIGINT IDENTITY PRIMARY KEY,
Id_Usuario BIGINT FOREIGN KEY REFERENCES Usuario(Id_Usuario) NOT NULL,
Titulo NVARCHAR(150),
Imagen NVARCHAR(80),
Tipo INT,
Descripcion NVARCHAR(300),
Fuente NVARCHAR(200) NULL,
Fecha_Publicacion DATETIME NOT NULL
)
GO
CREATE TABLE AmistadPublicacion(
Id_AmistadPublicacion BIGINT IDENTITY PRIMARY KEY,
Id_Publicacion BIGINT FOREIGN KEY REFERENCES Publicacion(Id_Publicacion),
Id_Amistad BIGINT FOREIGN KEY REFERENCES Amistad(Id_Amistad),
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
--crear sp para insertar publicacion tipo 1 (solo texto)
CREATE PROCEDURE[dbo].[sp_InPublicacion1]
@Id INT,
@Descripcion NVARCHAR(300),
@Fuente NVARCHAR (200),
@IdAmistad INT
AS
INSERT INTO Publicacion(Id_Usuario, Descripcion, Fecha_Publicacion, Tipo, Fuente)
VALUES(@Id, @Descripcion, CURRENT_TIMESTAMP, 1, @Fuente)
INSERT INTO AmistadPublicacion (Id_Amistad,Id_Publicacion) VALUES (@IdAmistad,(SELECT MAX(Id_Publicacion) FROM Publicacion))
GO
-- Traer las id amistad de cada uno
CREATE PROCEDURE [dbo].[sp_TraerAmistades]
@Id INT
AS
SELECT Id_Amistad FROM Amistad WHERE Id_Usuario = @Id 
GO
EXEC sp_TraerAmistades 1
GO
--crear sp para insertar publicacion tipo 2 (con imagen)
CREATE PROCEDURE[dbo].[sp_InPublicacion2]
@Id INT,
@Descripcion NVARCHAR(300), 
@Imagen NVARCHAR(80),
@Fuente NVARCHAR (200),
@IdAmistad INT
AS
INSERT INTO Publicacion(Id_Usuario, Descripcion, Imagen, Fecha_Publicacion, Tipo, Fuente)
VALUES(@Id, @Descripcion, @Imagen, CURRENT_TIMESTAMP, 2, @Fuente)
INSERT INTO AmistadPublicacion (Id_Amistad,Id_Publicacion) VALUES (@IdAmistad,(SELECT MAX(Id_Publicacion) FROM Publicacion))
GO
--crear sp para insertar publicacion tipo 3 (con imagen y titulo)
CREATE PROCEDURE[dbo].[sp_InPublicacion3]
@Id INT,
@Descripcion NVARCHAR(300), 
@Imagen NVARCHAR(80),
@Titulo NVARCHAR(150),
@Fuente NVARCHAR (200),
@IdAmistad INT
AS
INSERT INTO Publicacion(Id_Usuario, Descripcion, Imagen, Fecha_Publicacion, Tipo, Titulo, Fuente)
VALUES(@Id, @Descripcion, @Imagen, CURRENT_TIMESTAMP, 3, @Titulo, @Fuente)
INSERT INTO AmistadPublicacion (Id_Amistad,Id_Publicacion) VALUES (@IdAmistad,(SELECT MAX(Id_Publicacion) FROM Publicacion))
GO
/*CREATE PROCEDURE [dbo].[sp_InComentario]
@Id INT,
@Id2 INT,
@Variable NVARCHAR(260)
AS
INSERT INTO Comentario(Id_Usuario, Id_Publicacion, Comentario)
VALUES (@Id, @Id2, @Variable)
GO
*/
CREATE PROCEDURE [dbo].[sp_InUsuario]
@Nombre NVARCHAR(50),
@Nick NVARCHAR(50),
@Correo NVARCHAR(40),
@Contrasenia NVARCHAR(200),
@FechaNacimiento Date
AS
	INSERT INTO Usuario(Nombre, Nick, Correo, Contrasenia, Fecha_Nacimiento) VALUES(@Nombre,@Nick, @Correo, @Contrasenia, @FechaNacimiento)
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

---------------------------------
--CREACION DE SP'S COCCHE

--CREACION DE SP DE notificacion
CREATE PROCEDURE [dbo].[sp_UpVocacion]
@Id INT,
@Variable NVARCHAR(60)
AS
UPDATE Datos SET Vocacion=@Variable WHERE Id_Usuario=@Id
GO

--CREACION DE SP para obtener la imagen del usuario actual
CREATE PROCEDURE [dbo].[sp_UpCiudad]
@Id INT,
@Variable NVARCHAR(30)
AS
UPDATE Datos SET Ciudad=@Variable WHERE Id_Usuario=@Id
GO

--CREACION DE SP para obtener la imagen de portada del usuario actual
CREATE PROCEDURE [dbo].[sp_UpPais]
@Id INT,
@Variable NVARCHAR(40)
AS
UPDATE Datos SET Pais=@Variable WHERE Id_Usuario=@Id
GO

--CREACION DE SP para obtener la vocacion del usuario actual
CREATE PROCEDURE [dbo].[sp_UpEstado]
@Id INT,
@Variable NVARCHAR(200)
AS
UPDATE Datos SET Estado=@Variable WHERE Id_Usuario=@Id
GO

--CREACION DE SP para obtener la ubicacion del usuario actual
CREATE PROCEDURE [dbo].[sp_UpSeguidores]
@Id INT,
@Variable BIGINT
AS
UPDATE Datos SET Seguidores=@Variable WHERE Id_Usuario=@Id
GO

--CREACION DE SP para obtener la ubicacion del usuario actual
CREATE PROCEDURE [dbo].[sp_UpSiguiendo]
@Id INT,
@Variable BIGINT
AS
UPDATE Datos SET Siguiendo=@Variable WHERE Id_Usuario=@Id
GO

--CREACION DE SP para obtener los seguidores del usuario actual
CREATE PROCEDURE [dbo].[sp_UpNombreArtistico]
@Id INT,
@Variable NVARCHAR(100)
AS
UPDATE Datos SET NombreArtistico=@Variable WHERE Id_Usuario=@Id
GO

--CREACION DE SP para obtener siguiendo del usuario actual
CREATE PROCEDURE [dbo].[sp_UpImagen_Perfil]
@Id INT,
@Variable NVARCHAR(80)
AS
UPDATE Datos SET Imagen_Perfil=@Variable WHERE Id_Usuario=@Id
GO
SELECT Imagen_Perfil FROM Datos;
GO
--CREACION DE SP para obtener nick, imagen de usuario y vocacion de los amigos del usuario actual
CREATE PROCEDURE [dbo].[sp_UpImagen_Portada]
@Id INT,
@Variable NVARCHAR(80)
AS
UPDATE Datos SET Imagen_Portada=@Variable WHERE Id_Usuario=@Id
GO

--CREACION DE SP para obtener no telefonico del usuario actual
CREATE PROCEDURE [dbo].[sp_UpTelefono]
@Id INT,
@Variable NVARCHAR(20)
AS
UPDATE Datos SET Telefono=@Variable WHERE Id_Usuario=@Id
GO

--CREACION DE SP para obtener no telefonico casa del usuario actual
CREATE PROCEDURE [dbo].[sp_UpTelefono_Casa]
@Id INT,
@Variable NVARCHAR(20)
AS
UPDATE Datos SET Telefono_Casa= @Variable WHERE Id_Usuario=@Id
GO

--CREACION DE SP para obtener la biografia de un usuario
CREATE PROCEDURE [dbo].[sp_UpBiografia]
@Id INT,
@Variable NVARCHAR(300)
AS
UPDATE Datos SET Biografia=@Variable WHERE Id_Usuario=@Id
GO
--CREACION DE SP PARA OBTENER las notificaciones
CREATE PROCEDURE [dbo].[sp_obtenerNotificacion]
@Id INT
AS
	SELECT TOP 3 P.Id_Usuario,D.Imagen_Perfil, U.Nick, SUBSTRING(P.Descripcion,1,15) Descripcion FROM 
	Publicacion P LEFT JOIN Usuario U
	ON P.Id_Usuario = U.Id_Usuario
	INNER JOIN Datos D
	ON D.Id_Usuario = U.Id_Usuario
	INNER JOIN AmistadPublicacion AP
	ON AP.Id_Publicacion = P.Id_Publicacion
	INNER JOIN Amistad A
	ON A.Id_Amistad = AP.Id_Amistad
	INNER JOIN Notificacion N
	ON N.Id_Publicacion = P.Id_Publicacion
	WHERE (A.Id_Usuario_Dos = @Id) AND U.Id_Usuario != @Id
	ORDER BY P.Fecha_Publicacion
GO
--CREACION DE SP para obtener la imagen del usuario actual
CREATE PROCEDURE [dbo].[sp_obtenerImagenPerfil]
@Id INT
AS
	SELECT D.Imagen_Perfil FROM Usuario U
	INNER JOIN Datos D ON D.Id_Usuario = U.Id_Usuario WHERE U.Id_Usuario = @Id
GO

--CREACION DE SP para obtener la imagen de portada del usuario actual
CREATE PROCEDURE [dbo].[sp_obtenerImagenPortadaPerfil]
@Id INT
AS
	SELECT D.Imagen_Portada FROM Usuario U
	INNER JOIN Datos D ON D.Id_Usuario = U.Id_Usuario WHERE U.Id_Usuario = @Id
GO

--CREACION DE SP para obtener el nombre del usuario actual
CREATE PROCEDURE [dbo].[sp_obtenerNombrePerfil]
@Id INT
AS
	SELECT U.Nick Nombre FROM Usuario U WHERE U.Id_Usuario = @Id
GO

--CREACION DE SP para obtener la vocacion del usuario actual
CREATE PROCEDURE [dbo].[sp_obtenerVocacionPerfil]
@Id INT
AS
	SELECT D.Vocacion FROM Usuario U
	INNER JOIN Datos D ON D.Id_Usuario = U.Id_Usuario WHERE U.Id_Usuario = @Id
GO

--CREACION DE SP para obtener la ubicacion del usuario actual
CREATE PROCEDURE [dbo].[sp_obtenerUbicacionPerfil]
@Id INT
AS
	SELECT D.Ciudad, D.Pais FROM Usuario U
	INNER JOIN Datos D ON D.Id_Usuario = U.Id_Usuario WHERE U.Id_Usuario = @Id
GO

--CREACION DE SP para obtener la ubicacion del usuario actual
CREATE PROCEDURE [dbo].[sp_obtenerEstadoPerfil]
@Id INT
AS
	SELECT D.Estado FROM Usuario U
	INNER JOIN Datos D ON D.Id_Usuario = U.Id_Usuario WHERE U.Id_Usuario = @Id
GO

--CREACION DE SP para obtener los seguidores del usuario actual
CREATE PROCEDURE [dbo].[sp_obtenerSeguidoresPerfil]
@Id INT
AS
	SELECT D.Seguidores FROM Usuario U
	INNER JOIN Datos D ON D.Id_Usuario = U.Id_Usuario WHERE U.Id_Usuario = @Id
GO

--CREACION DE SP para obtener siguiendo del usuario actual
CREATE PROCEDURE [dbo].[sp_obtenerSiguiendoPerfil]
@Id INT
AS
	SELECT D.Siguiendo FROM Usuario U
	INNER JOIN Datos D ON D.Id_Usuario = U.Id_Usuario WHERE U.Id_Usuario = @Id
GO

--CREACION DE SP para obtener nick, imagen de usuario y vocacion de los amigos del usuario actual
CREATE PROCEDURE [dbo].[sp_obtenerPerfilAmigos]
@Id INT
AS
	SELECT D.Imagen_Perfil, U.Nick, D.Vocacion FROM Amistad A
	INNER JOIN Datos D ON D.Id_Usuario = A.Id_Usuario_Dos 
	INNER JOIN Usuario U ON U.Id_Usuario = A.Id_Usuario_Dos
	WHERE A.Id_Usuario = @Id
GO

--CREACION DE SP para obtener no telefonico del usuario actual
CREATE PROCEDURE [dbo].[sp_obtenernoTelefonico]
@Id INT
As
	SELECT D.Telefono FROM Datos D WHERE D.Id_Usuario = @Id
GO

--CREACION DE SP para obtener no telefonico casa del usuario actual
CREATE PROCEDURE [dbo].[sp_obtenernoTelefonicoCasa]
@Id INT
As
	SELECT D.Telefono_Casa FROM Datos D WHERE D.Id_Usuario = @Id
GO

--CREACION DE SP para obtener la biografia de un usuario
CREATE PROCEDURE [dbo].[sp_obtenerBiografia]
@Id INT
As
	SELECT D.Biografia FROM Datos D WHERE D.Id_Usuario = @Id
GO

--CREACION DE SP para obtener sin foto Tipo 1
CREATE PROCEDURE [dbo].[sp_obtenerPublicacionTipo1]
@Id INT
As
	SELECT P.Id_Usuario,D.Imagen_Perfil, U.Nick, P.Descripcion FROM Publicacion P LEFT JOIN Usuario U
	ON P.Id_Usuario = P.Id_Usuario
	INNER JOIN Datos D
	ON D.Id_Usuario = U.Id_Usuario
	INNER JOIN AmistadPublicacion AP
	ON AP.Id_Publicacion = P.Id_Publicacion
	INNER JOIN Amistad A
	ON A.Id_Amistad = AP.Id_Amistad
	WHERE P.Id_Usuario = A.Id_Usuario OR P.Id_Usuario = A.Id_Usuario_Dos AND Tipo = 1 AND U.Id_Usuario = @Id
	ORDER BY P.Fecha_Publicacion
GO
--CREACION DE SP para obtener con foto Tipo 2
CREATE PROCEDURE [dbo].[sp_obtenerPublicacionTipo2]
	@Id INT
	As
	SELECT P.Id_Usuario,D.Imagen_Perfil, U.Nick, P.Descripcion, P.Imagen FROM Publicacion P LEFT JOIN Usuario U
	ON P.Id_Usuario = P.Id_Usuario
	INNER JOIN Datos D
	ON D.Id_Usuario = U.Id_Usuario
	INNER JOIN AmistadPublicacion AP
	ON AP.Id_Publicacion = P.Id_Publicacion
	INNER JOIN Amistad A
	ON A.Id_Amistad = AP.Id_Amistad
	WHERE P.Id_Usuario = A.Id_Usuario OR P.Id_Usuario = A.Id_Usuario_Dos AND Tipo = 2 AND U.Id_Usuario = @Id
	ORDER BY P.Fecha_Publicacion
GO
--CREACION DE SP para obtener con foto pero con titulo Tipo 3
CREATE PROCEDURE [dbo].[sp_obtenerPublicacionTipo3]
	@Id INT
	As
	SELECT P.Id_Usuario,D.Imagen_Perfil, U.Nick, P.Descripcion, P.Titulo, P.Imagen FROM Publicacion P LEFT JOIN Usuario U
	ON P.Id_Usuario = P.Id_Usuario
	INNER JOIN Datos D
	ON D.Id_Usuario = U.Id_Usuario
	INNER JOIN AmistadPublicacion AP
	ON AP.Id_Publicacion = P.Id_Publicacion
	INNER JOIN Amistad A
	ON A.Id_Amistad = AP.Id_Amistad
	WHERE P.Id_Usuario = A.Id_Usuario OR P.Id_Usuario = A.Id_Usuario_Dos AND Tipo = 3 AND U.Id_Usuario = @Id
	ORDER BY P.Fecha_Publicacion
GO


--obtener todas las publicaciones de los amigos
CREATE PROCEDURE [dbo].[sp_obtenerPublicaciones] 
@Id INT
AS 
	SELECT P.Tipo,P.Imagen, P.Descripcion, P.Fuente, P.Fecha_Publicacion, D.Imagen_Perfil, P.Titulo FROM Publicacion P LEFT JOIN Usuario U
	ON P.Id_Usuario = U.Id_Usuario
	INNER JOIN Datos D
	ON D.Id_Usuario = U.Id_Usuario
	INNER JOIN AmistadPublicacion AP
	ON AP.Id_Publicacion = P.Id_Publicacion
	INNER JOIN Amistad A
	ON A.Id_Amistad = AP.Id_Amistad
	INNER JOIN Notificacion N
	ON N.Id_Publicacion = P.Id_Publicacion
	WHERE (A.Id_Usuario_Dos = @Id) OR A.Id_Usuario = @Id
	GROUP BY P.Tipo,P.Imagen, P.Descripcion, P.Fuente, P.Fecha_Publicacion, D.Imagen_Perfil, P.Titulo
	ORDER BY P.Fecha_Publicacion DESC
GO
-- Procedimiento para obtener las notificaciones y que no sean del usuario
CREATE PROCEDURE [dbo].[sp_obtenerNotificacionesPrincipal] 
@Id INT
AS 
	SELECT P.Tipo,P.Imagen, P.Descripcion, P.Fuente, P.Fecha_Publicacion, D.Imagen_Perfil, P.Titulo FROM Publicacion P LEFT JOIN Usuario U
	ON P.Id_Usuario = U.Id_Usuario
	INNER JOIN Datos D
	ON D.Id_Usuario = U.Id_Usuario
	INNER JOIN AmistadPublicacion AP
	ON AP.Id_Publicacion = P.Id_Publicacion
	INNER JOIN Amistad A
	ON A.Id_Amistad = AP.Id_Amistad
	INNER JOIN Notificacion N
	ON N.Id_Publicacion = P.Id_Publicacion
	WHERE (A.Id_Usuario_Dos = @Id)
	ORDER BY P.Fecha_Publicacion DESC
GO

CREATE TRIGGER tgr_PonerNotificacion
ON Publicacion 
AFTER INSERT 
AS
	BEGIN
	SET NOCOUNT ON;
	INSERT INTO Notificacion(Id_Publicacion, Estatus) VALUES ((SELECT Id_Publicacion FROM inserted), 1)
END
GO
--obtener amigos con el nombre parecido
CREATE PROCEDURE [dbo].[sp_buscarAmigo] 
@Buscar NVARCHAR(50),
@Id INT
AS	SELECT * FROM(
	SELECT U.Id_Usuario Id,D.Imagen_Perfil, U.Nick, D.Vocacion,D.Seguidores FROM Usuario U
	INNER JOIN Datos D ON D.Id_Usuario = U.Id_Usuario 
	WHERE U.Nick = @Buscar OR U.Nick LIKE @Buscar+'%' OR U.Nick LIKE '%'+@Buscar+'%' OR U.Nick LIKE '%'+@Buscar
	EXCEPT
	SELECT U.Id_Usuario Id,D.Imagen_Perfil, U.Nick, D.Vocacion,D.Seguidores FROM Amistad A
	INNER JOIN Datos D ON D.Id_Usuario = A.Id_Usuario_Dos 
	INNER JOIN Usuario U ON U.Id_Usuario = A.Id_Usuario_Dos
	WHERE A.Id_Usuario = @Id OR U.Id_Usuario = @Id)ex
GO
EXEC sp_buscarAmigo 'a',1
GO
-- Obtener personas no seguidas
CREATE PROCEDURE [dbo].[sp_obtenerPersonas] 
@Id INT
AS	SELECT * FROM(
	SELECT U.Id_Usuario IdBuscado,D.Imagen_Perfil, U.Nick,D.Seguidores FROM Usuario U
	INNER JOIN Datos D ON D.Id_Usuario = U.Id_Usuario 
	WHERE U.Id_Usuario != @Id
	EXCEPT
	SELECT U.Id_Usuario IdBuscado,D.Imagen_Perfil, U.Nick,D.Seguidores FROM Amistad A
	INNER JOIN Datos D ON D.Id_Usuario = A.Id_Usuario_Dos 
	INNER JOIN Usuario U ON U.Id_Usuario = A.Id_Usuario_Dos
	WHERE A.Id_Usuario = @Id)ex
	ORDER BY ex.Seguidores ASC
GO
-- Top m�s seguidores
CREATE PROCEDURE [dbo].[sp_obtenerFamoso]
@Id INT
AS
	SELECT TOP 1 U.Id_Usuario IdBuscado,D.Imagen_Perfil, U.Nick,D.Seguidores, COUNT(P.Id_Publicacion) NoPublicaciones FROM Usuario U
	INNER JOIN Datos D ON D.Id_Usuario = U.Id_Usuario
	INNER JOIN Publicacion P ON P.Id_Usuario = U.Id_Usuario 
	WHERE U.Id_Usuario != @Id
	GROUP BY U.Id_Usuario,D.Imagen_Perfil, U.Nick,D.Seguidores
	ORDER BY D.Seguidores DESC
GO
--obtener todas las publicaciones de los generales
CREATE PROCEDURE [dbo].[sp_obtenerPublicacionesTop] 
@Id INT
AS 
	SELECT TOP 3 P.Tipo,P.Imagen, CONCAT(SUBSTRING(P.Descripcion,1,30),'...') Descripcion, P.Fuente, P.Fecha_Publicacion, D.Imagen_Perfil, P.Titulo, U.Id_Usuario IdBuscado, U.Nick FROM Publicacion P LEFT JOIN Usuario U
	ON P.Id_Usuario = U.Id_Usuario
	INNER JOIN Datos D
	ON D.Id_Usuario = U.Id_Usuario
	INNER JOIN AmistadPublicacion AP
	ON AP.Id_Publicacion = P.Id_Publicacion
	INNER JOIN Amistad A
	ON A.Id_Amistad = AP.Id_Amistad
	INNER JOIN Notificacion N
	ON N.Id_Publicacion = P.Id_Publicacion
	ORDER BY P.Fecha_Publicacion DESC
GO
/*Seguir*/
CREATE PROCEDURE [dbo].[sp_Seguir]
@Id INT,
@IdDos INT
AS
BEGIN TRY
	BEGIN TRANSACTION
		INSERT INTO Amistad (Id_Usuario,Id_Usuario_Dos) VALUES (@Id, @IdDos)
		DECLARE @Siguiendo INT = (SELECT Siguiendo FROM Datos WHERE Id_Usuario = @Id)
		DECLARE @Seguidores INT = (SELECT Seguidores FROM Datos WHERE Id_Usuario = @IdDos)
		UPDATE Datos SET Seguidores = (@Seguidores+1)  WHERE Id_Usuario = @IdDos
		UPDATE Datos SET Siguiendo = (@Siguiendo+1) WHERE Id_Usuario = @Id
		SELECT  Id_Usuario Id, Id_Usuario_Dos IdDos FROM Amistad WHERE Id_Amistad = (SELECT MAX(Id_Amistad) FROM Amistad)
	COMMIT Transaction
	END TRY
	BEGIN CATCH
		ROLLBACK TRANSACTION
	END CATCH
GO
