USE GYM;

GO

CREATE PROC ProcDeleteRol
    @CodRol UNIQUEIDENTIFIER,
    @Mensaje NVARCHAR(100) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        IF @CodRol IS NULL
        BEGIN
            SET @Mensaje = 'El código del rol no puede ser nulo.';
            RETURN;
        END

        BEGIN TRANSACTION;

        DECLARE @exitNameRol AS BIT;
        SET @exitNameRol = (
            SELECT EstadoRol 
            FROM Rol 
            WHERE CodRol = @CodRol
        );

        IF @exitNameRol IS NULL
        BEGIN
            ROLLBACK TRANSACTION;
            SET @Mensaje = 'El rol que intenta eliminar no existe.';
            RETURN;
        END

        IF @exitNameRol = 0
        BEGIN
            ROLLBACK TRANSACTION;
            SET @Mensaje = 'El rol que intenta eliminar ya esta inactivo.';
            RETURN;
        END

        DECLARE @existUserRol AS INT;
        SET @existUserRol = (
            SELECT 1 
            FROM Users
            WHERE Rol = @CodRol AND EstadoUser = 1
        );

        IF @existUserRol = 1
        BEGIN
            ROLLBACK TRANSACTION;
            SET @Mensaje = 'No se puede eliminar el rol porque hay usuarios asociados a él.';
            RETURN;
        END

        UPDATE Rol SET
            EstadoRol = 0,
            DateDelete = SYSDATETIMEOFFSET() AT TIME ZONE 'Central America Standard Time'
        WHERE CodRol = @CodRol;

        -- Verificar que se actualizo exactamente 1 registro
        IF @@ROWCOUNT <> 1
        BEGIN
            ROLLBACK TRANSACTION;
            SET @Mensaje = 'Error inesperado al actualizar el rol';
            RETURN;
        END

        COMMIT TRANSACTION;
        SET @Mensaje = 'Rol eliminado correctamente.';

    END TRY
    BEGIN CATCH
        SET @Mensaje = 'Error al validar el nombre del rol: ' + ERROR_MESSAGE();
        RETURN;
    END CATCH
END