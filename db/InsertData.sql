USE GYM;

GO

DECLARE @Mensaje NVARCHAR(100);

EXEC ProcInsertRol 
    @NameRol = 'Vendedor',
    @DescripRol = 'Solo puede vender.',
    @Mensaje = @Mensaje OUTPUT;

PRINT @Mensaje;

SELECT * FROM Rol


DECLARE @Mensaje NVARCHAR(100);

EXEC ProcUpdateRol 
    @CodRol = 'c98a33fb-9caa-4040-89a5-6ded8500a4dc',
    @NameRol = 'vendedor',
    @DescripRol = 'Rol con acceso total.',
    @Mensaje = @Mensaje OUTPUT;

PRINT @Mensaje;

DECLARE @Mensaje NVARCHAR(100);

EXEC ProcDeleteRol 
    @CodRol = 'c98a33fb-9caa-4040-89a5-6ded8500a4dc',
    @Mensaje = @Mensaje OUTPUT;

PRINT @Mensaje;

DECLARE @Mensaje NVARCHAR(100);

EXEC ProcRestoreRol 
    @CodRol = 'c98a33fb-9caa-4040-89a5-6ded8500a4dc',
    @Mensaje = @Mensaje OUTPUT;

PRINT @Mensaje;

INSERT INTO Users (NameUser, Email, Clave, Rol)
VALUES('Walter', 'Walter@gmail.com', 
    HASHBYTES('SHA2_512','1234'),(
        SELECT CodRol 
        FROM Rol 
        WHERE NameRol = 'Administrador'
    )
);

UPDATE Users SET
    EstadoUser = 1
WHERE NameUser = 'Walter';

SELECT * FROM Users;