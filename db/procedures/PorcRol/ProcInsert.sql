USE GYM;

GO

CREATE PROC ProcInsertRol
    @NameRol NVARCHAR(50),
    @DescripRol NVARCHAR(500),
    @Mensaje NVARCHAR(100) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        -- Validamos los campos necesarios
        IF @NameRol IS NULL OR @NameRol = ''
        BEGIN
            SET @Mensaje = 'El nombre no puede ser nulo o estar vacio.';
            RETURN;
        END

        IF LEN(TRIM(@NameRol)) < 3 OR LEN(TRIM(@NameRol)) >= 50
        BEGIN
            SET @Mensaje = 'El nombre del rol debe tener entre 3 y 50 caracteres.';
            RETURN;
        END

        IF LEN(TRIM(@DescripRol)) < 5 OR LEN(TRIM(@DescripRol)) >= 500
        BEGIN
            SET @Mensaje = 'La descripción del rol debe tener entre 5 y 500 caracteres.';
            RETURN;
        END

        BEGIN TRANSACTION;

        DECLARE @exitNameRol AS BIT;
        SET @exitNameRol = (
            SELECT EstadoRol 
            FROM Rol 
            WHERE NameRol = @NameRol AND EstadoRol = 1
        );

        IF @exitNameRol IS NOT NULL
        BEGIN
            ROLLBACK TRANSACTION;
            SET @Mensaje = 'El nombre del rol ya existe.';
            RETURN;
        END

        INSERT INTO Rol(NameRol, DescripRol)
        VALUES(TRIM(@NameRol), TRIM(@DescripRol));

        -- Verificar que se actualizo exactamente 1 registro
        IF @@ROWCOUNT <> 1
        BEGIN
            ROLLBACK TRANSACTION;
            SET @Mensaje = 'Error inesperado al actualizar el rol';
            RETURN;
        END

        COMMIT TRANSACTION;
        SET @Mensaje = 'Rol insertado correctamente.';

    END TRY
    BEGIN CATCH
        SET @Mensaje = 'Error al validar el nombre del rol: ' + ERROR_MESSAGE();
        RETURN;
    END CATCH
END