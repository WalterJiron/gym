CREATE DATABASE GYM;

GO

USE GYM;

GO

-- Tabla de roles del sistema (NO TOCAR)
CREATE TABLE Rol(
    CodRol UNIQUEIDENTIFIER DEFAULT NEWID() PRIMARY KEY NOT NULL,
    NameRol NVARCHAR(50) NOT NULL,
    DescripRol NVARCHAR(500),
    DateCreate DATETIMEOFFSET DEFAULT SYSDATETIMEOFFSET() AT TIME ZONE 'Central America Standard Time',
    DateUpdate DATETIMEOFFSET,
    DateDelete DATETIMEOFFSET,
    EstadoRol BIT DEFAULT 1
);

GO

-- Tabla de usuarios (NO TOCAR)
CREATE TABLE Users(
    CodigoUser UNIQUEIDENTIFIER DEFAULT NEWID() PRIMARY KEY NOT NULL,
    NameUser NVARCHAR(50) NOT NULL,
    Email NVARCHAR(100) UNIQUE NOT NULL,
    Clave VARBINARY(300) NOT NULL,
    Rol UNIQUEIDENTIFIER FOREIGN KEY REFERENCES Rol(CodRol) ON DELETE CASCADE ON UPDATE CASCADE NOT NULL,
    DateCreate DATETIMEOFFSET DEFAULT SYSDATETIMEOFFSET() AT TIME ZONE 'Central America Standard Time',
    DateUpdate DATETIMEOFFSET,   
    DateDelete DATETIMEOFFSET,
    EstadoUser BIT DEFAULT 1
); 

GO

-- Tabla de clientes 
CREATE TABLE Cliente(
    CodCliente UNIQUEIDENTIFIER DEFAULT NEWID() PRIMARY KEY NOT NULL,
    PNCL NVARCHAR(25) NOT NULL,
    SNCL NVARCHAR(25),
    PACL NVARCHAR(25) NOT NULL,
    SACL NVARCHAR(25),
    Genero CHAR(1) CHECK (Genero IN ('M', 'F', 'O')) NOT NULL,
    FechaNacimiento DATE NOT NULL,
    Telefono NVARCHAR(8) NOT NULL CHECK(Telefono LIKE '[2|5|7|8][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'),
    FechaRegistro DATETIMEOFFSET DEFAULT SYSDATETIMEOFFSET() AT TIME ZONE 'Central America Standard Time',
    DateUpdate DATETIMEOFFSET,
    DateDelete DATETIMEOFFSET,
    EstadoCL BIT DEFAULT 1
);

GO

-- Tabla de membresías 
CREATE TABLE Membresia(
    CodMembresia UNIQUEIDENTIFIER DEFAULT NEWID() PRIMARY KEY NOT NULL,
    NameMembresia NVARCHAR(50) NOT NULL,
    DescripMembresia NVARCHAR(500),
    Precio DECIMAL(18, 3) NOT NULL CHECK (Precio >= 0),
    DuracionDias INT NOT NULL CHECK (DuracionDias > 0),
    DateCreate DATETIMEOFFSET DEFAULT SYSDATETIMEOFFSET() AT TIME ZONE 'Central America Standard Time',
    DateUpdate DATETIMEOFFSET,
    DateDelete DATETIMEOFFSET,
    EstadoMembresia BIT DEFAULT 1
);

GO

-- Tabla de Caja
CREATE TABLE Caja(
    CodCaja UNIQUEIDENTIFIER DEFAULT NEWID() PRIMARY KEY NOT NULL,
    CodUser UNIQUEIDENTIFIER NOT NULL FOREIGN KEY REFERENCES Users(CodigoUser),
    FechaApertura DATETIMEOFFSET DEFAULT SYSDATETIMEOFFSET() AT TIME ZONE 'Central America Standard Time',
    FechaCierre DATETIMEOFFSET,
    MontoApertura DECIMAL(18, 3) NOT NULL CHECK (MontoApertura >= 0),
    MontoCierre DECIMAL(18, 3) CHECK (MontoCierre >= 0),
    Observaciones NVARCHAR(200),
    EstadoCaja CHAR(1) DEFAULT 'A' CHECK (EstadoCaja IN ('A', 'C')) -- A=Abierta, C=Cerrada
);

GO

-- Tabla de movimientos de caja
CREATE TABLE MovimientoCaja(
    CodMovimiento UNIQUEIDENTIFIER DEFAULT NEWID() PRIMARY KEY NOT NULL,
    CodCaja UNIQUEIDENTIFIER NOT NULL FOREIGN KEY REFERENCES Caja(CodCaja),
    TipoMovimiento CHAR(1) CHECK (TipoMovimiento IN ('I', 'E')) NOT NULL, -- I=Ingreso, E=Egreso
    Descripcion NVARCHAR(200) NOT NULL,
    Monto DECIMAL(18, 3) NOT NULL CHECK (Monto > 0),
    FechaMovimiento DATETIMEOFFSET DEFAULT SYSDATETIMEOFFSET() AT TIME ZONE 'Central America Standard Time',
    CodUser UNIQUEIDENTIFIER NOT NULL FOREIGN KEY REFERENCES Users(CodigoUser),
    CodVenta UNIQUEIDENTIFIER FOREIGN KEY REFERENCES Venta(CodVenta)
);

GO

-- Tabla de descuentos 
CREATE TABLE Descuento(
    CodDescuento UNIQUEIDENTIFIER DEFAULT NEWID() PRIMARY KEY NOT NULL,
    Nombre NVARCHAR(50) NOT NULL,
    Descripcion NVARCHAR(200),
    Tipo CHAR(1) CHECK (Tipo IN ('P', 'M')) NOT NULL, -- P = Porcentaje, M = Monto total
    Valor DECIMAL(18, 3) NOT NULL CHECK (Valor >= 0),
    FechaInicio DATE NOT NULL,
    FechaFin DATE NOT NULL,
    EstadoDes BIT DEFAULT 1,
    Aplicacion NVARCHAR(20) CHECK (Aplicacion IN ('Global', 'Detalle')) DEFAULT 'Detalle'
);

GO

-- Tabla de ventas 
CREATE TABLE Venta(
    CodVenta UNIQUEIDENTIFIER DEFAULT NEWID() PRIMARY KEY NOT NULL,
    CodCliente UNIQUEIDENTIFIER NOT NULL FOREIGN KEY REFERENCES Cliente(CodCliente),
    CodUser UNIQUEIDENTIFIER NOT NULL FOREIGN KEY REFERENCES Users(CodigoUser),
    FechaVenta DATETIMEOFFSET DEFAULT SYSDATETIMEOFFSET() AT TIME ZONE 'Central America Standard Time',
    DescuentoGlobal UNIQUEIDENTIFIER FOREIGN KEY REFERENCES Descuento(CodDescuento),
    SubTotal DECIMAL(18, 3) NOT NULL CHECK (SubTotal >= 0),
    Total DECIMAL(18, 3) NOT NULL CHECK (Total >= 0),
    EstadoVenta CHAR(1) DEFAULT 'V' CHECK (EstadoVenta IN ('V', 'A')), -- V = vendido, A = anulado
    Observaciones NVARCHAR(200)
);

GO

-- Detalle de ventas 
CREATE TABLE DetalleVenta(
    CodDetalleVenta UNIQUEIDENTIFIER DEFAULT NEWID() PRIMARY KEY NOT NULL,
    CodVenta UNIQUEIDENTIFIER FOREIGN KEY REFERENCES Venta(CodVenta) NOT NULL,
    CodMembresia UNIQUEIDENTIFIER FOREIGN KEY REFERENCES Membresia(CodMembresia) NOT NULL,
    CodDescuento UNIQUEIDENTIFIER FOREIGN KEY REFERENCES Descuento(CodDescuento),
    Cantidad INT NOT NULL DEFAULT 1 CHECK (Cantidad > 0),
    PrecioUnitario DECIMAL(18, 3) NOT NULL CHECK (PrecioUnitario >= 0),
    SubTotal DECIMAL(18, 3) NOT NULL CHECK (SubTotal >= 0),
    Total DECIMAL(18, 3) NOT NULL CHECK (Total >= 0),
    FechaInicio DATE NOT NULL,
    FechaFin DATE NOT NULL,
    EstadoDV CHAR(1) DEFAULT 'A' CHECK (EstadoDV IN ('A', 'C')) -- A = Activo, C = Cancelado
);

GO

-- Pagos (solo efectivo permitido)
CREATE TABLE Pago(
    CodPago UNIQUEIDENTIFIER DEFAULT NEWID() PRIMARY KEY NOT NULL,
    CodVenta UNIQUEIDENTIFIER NOT NULL FOREIGN KEY REFERENCES Venta(CodVenta),
    MetodoPago NVARCHAR(20) DEFAULT 'Efectivo' NOT NULL,
    Monto DECIMAL(18, 3) NOT NULL CHECK (Monto >= 0),
    FechaPago DATETIMEOFFSET DEFAULT SYSDATETIMEOFFSET() AT TIME ZONE 'Central America Standard Time',
    Referencia NVARCHAR(100)
);

GO

-- Registro de membresias activas
CREATE TABLE ClienteMembresia(
    CodClienteMembresia UNIQUEIDENTIFIER DEFAULT NEWID() PRIMARY KEY NOT NULL,
    CodCliente UNIQUEIDENTIFIER NOT NULL FOREIGN KEY REFERENCES Cliente(CodCliente),
    CodDetalleVenta UNIQUEIDENTIFIER NOT NULL FOREIGN KEY REFERENCES DetalleVenta(CodDetalleVenta),
    FechaInicio DATE NOT NULL,
    FechaFin DATE NOT NULL,
    FechaRegistro DATETIMEOFFSET DEFAULT SYSDATETIMEOFFSET() AT TIME ZONE 'Central America Standard Time',
    Estado BIT DEFAULT 1
);

GO

-- Asistencias
CREATE TABLE Asistencia(
    CodAsistencia UNIQUEIDENTIFIER DEFAULT NEWID() PRIMARY KEY NOT NULL,
    CodCliente UNIQUEIDENTIFIER NOT NULL FOREIGN KEY REFERENCES Cliente(CodCliente),
    CodClienteMembresia UNIQUEIDENTIFIER NOT NULL FOREIGN KEY REFERENCES ClienteMembresia(CodClienteMembresia),
    FechaHoraEntrada DATETIMEOFFSET DEFAULT SYSDATETIMEOFFSET() AT TIME ZONE 'Central America Standard Time',
    FechaHoraSalida DATETIMEOFFSET,
    CodUserRegistro UNIQUEIDENTIFIER FOREIGN KEY REFERENCES Users(CodigoUser)
);
