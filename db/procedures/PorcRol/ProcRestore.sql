USE GYM;

GO

CREATE PROC ProcRestoreRol
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
            SET @Mensaje = 'El rol que intenta activar no existe.';
            RETURN;
        END

        IF @exitNameRol = 1
        BEGIN
            ROLLBACK TRANSACTION;
            SET @Mensaje = 'El rol que intenta activar ya esta activo.';
            RETURN;
        END

        UPDATE Rol SET
            EstadoRol = 1,
            DateDelete = NULL
        WHERE CodRol = @CodRol;

        -- Verificar que se actualizo exactamente 1 registro
        IF @@ROWCOUNT <> 1
        BEGIN
            ROLLBACK TRANSACTION;
            SET @Mensaje = 'Error inesperado al actualizar el rol';
            RETURN;
        END

        COMMIT TRANSACTION;
        SET @Mensaje = 'Rol activado correctamente.';

    END TRY
    BEGIN CATCH
        SET @Mensaje = 'Error al validar el nombre del rol: ' + ERROR_MESSAGE();
        RETURN;
    END CATCH
END