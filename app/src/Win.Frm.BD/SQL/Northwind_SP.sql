USE [Northwind]
GO
/****** Object:  UserDefinedDataType [dbo].[empid]    Script Date: 15/11/2018 17:50:07 ******/
CREATE TYPE [dbo].[empid] FROM [char](9) NOT NULL
GO
/****** Object:  UserDefinedDataType [dbo].[id]    Script Date: 15/11/2018 17:50:07 ******/
CREATE TYPE [dbo].[id] FROM [varchar](11) NOT NULL
GO
/****** Object:  UserDefinedDataType [dbo].[tid]    Script Date: 15/11/2018 17:50:07 ******/
CREATE TYPE [dbo].[tid] FROM [varchar](6) NOT NULL
GO
/****** Object:  UserDefinedFunction [dbo].[Desencriptar_Clave]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
Exec Ingreso_Sistema 'C0001','C0001'
go
select dbo.Encriptar_Clave('C0001','SQL2005')
go
select dbo.Desencriptar_Clave('C0001')
*/

------------------------------------------------------------------
CREATE function [dbo].[Desencriptar_Clave]
(@codigo char(20))
returns varchar(100)
as
begin
declare @desencriptado varchar(100)
declare @clave varbinary(1000)

select @clave=clave from clientes where cli_codigo=@codigo

select @desencriptado=
       convert(varchar(100),decryptbypassphrase('SQL2005',@clave))

return @desencriptado
end


GO
/****** Object:  UserDefinedFunction [dbo].[Encriptar_Clave]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create function [dbo].[Encriptar_Clave]
(@codigo varchar(20),@clave varchar(20))
returns varbinary(1000)
as
begin
	declare @encriptado varbinary(1000)
	select @encriptado=
		encryptbypassphrase(@clave,@codigo)
	return @encriptado
end
GO
/****** Object:  UserDefinedFunction [dbo].[Fn_Format]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE function [dbo].[Fn_Format](@CampoFormat sql_variant, @Formato as varchar(20)=NULL) 
RETURNS VARCHAR(8000)
---***************************************************************************************************************************************************************
-- Formatos Soportados
        -- Fecha 
        --('d', 'dd', 'dddd', 'm', 'mm', 'mmm', 'mmmm' , 'yy', 'yyyy'
        -- 'd mm', 'd-mm', 'd/mm', 'd.mm', 'dd mm', 'dd-mm', 'dd/mm', 'dd.mm', 'ddd mm', 'ddd-mm', 'ddd/mm', 'ddd.mm' 
        -- 'dddd mm', 'dddd-mm', 'dddd/mm', 'dddd.mm', 'dd mmm', 'dd-mmm', 'dd/mmm', 'dd.mmm', 'dd mmmm' 'dd-mmmm', 'dd/mmmm', 'dd.mmmm' 
        -- 'm yy', 'm-yy', 'm/yy', 'm.yy', 'mm yy', 'mm-yy', 'mm/yy', 'mm.yy', 
        -- 'mmm yy', 'mmm-yy', 'mmm/yy', 'mmm.yy', 'mmmm yy', 
        -- 'mmmm-yy', 'mmmm/yy', 'mmmm.yy', 'mmmm yy', 'mmmm-yy', 'mmmm/yy', 'mmmm.yy', 
        -- 'mmm yyyy', 'mmm-yyyy', 'mmm/yyyy', 'mmm.yyyy',  
        -- 'mmmm yyyy', 'mmmm-yyyy' 'mmmm/yyyy' 'mmmm.yyyy' ,
        -- 'd m yy', 'd-m-yy', 'd/m/yy', 'd.m.yy', 'd mm yy', 'd-mm-yy', 
        -- 'd/mm/yy', 'd.mm.yy' ,  'dd mm yy' ,'dd-mm-yy' ,'dd/mm/yy' ,'dd.mm.yy',
        -- 'd m yyyy' ,'d-m-yyyy' ,'d/m/yyyy' ,'d.m.yyyy'  , 'd mm yyyy' ,
        -- 'd-mm-yyyy' ,'d/mm/yyyy' ,'d.mm.yyyy' ,  'dd mm yyyy' ,'dd-mm-yyyy' ,
        -- 'dd/mm/yyyy' ,'dd.mm.yyyy','ddd mmm y' ,'ddd-mmm-y' ,'dddd/mmm/y' ,'ddd.mmm.y' ,'ddd mmm yy' ,
        -- 'ddd-mmm-yy' ,'ddd/mmm/yy' ,'ddd.mmm.yy' ,'ddd mmm yyyy', 'ddd-mmm-yyyy' ,
        -- 'dddd/mmm/yyyy' ,'dddd.mmmm.yyyy' ,'dddd mmmm yyyy' ,'dddd-mmmm-yyyy' ,'dddd/mmmm/yyyy' ,'dddd.mmmm.yyyy' 
        -- Numeros 
        --("###,###.#0", "###,###")
--
-- Funcion Creada por Jimmy Poma e-mail jdak67@hotmail.com  Fecha 18/agos/2004 
-- Modificado Por Jimmy Fecha 19/Agosto/2004 ora 13:25 para que acepte El Formato Null y devuelva tal como lo envio
-- Modificado Por Jimmy Fecha 20/Agosto/2004 ora 13:25 para que acepte todos los Formatos Fecha o almenos casi todos :)
-- Todos los derechos reservados :) no, menrita jeje
-- SI LE REALIZAN ALGUN CAMBIO ME AVISAS PARA TENERLO ACTUALIZADO AL jdak67@hotmail.com
-- MODIFICADO POR JIMMY FECHA 19/ENE/2010 SE AGREGO EL FORMATO DDD, DD-MM-YY
---***************************************************************************************************************************************************************
as 
begin
        --Declaracion de Variables
        Declare @Trim SQL_VARIANT
        Declare @PosIni as int
        Declare @CantPos as int

        Declare @CantDecimales  as int

        Declare @TipoFecha as int
        Declare @Devuelve as varchar(8000)
        Declare @TipoFormato as int
        Declare @Separador as char(1)

        Declare @Dia as varchar(50)
        Declare @Mes as varchar(50)
        Declare @Anio as varchar(50)
        

        DECLARE @Primero as bit
        DECLARE @LOOP as bit

        --VALIDA EL FORMATO SI ES NUMERICO, FECHA O CUALQUIER OTRO TIPO
        IF @Formato IS NULL 
        BEGIN
                SET @Devuelve = CONVERT(VARCHAR(8000), @CampoFormat)
                GOTO Salir
        END
        If PATINDEX('%#%',@Formato)<=0
        BEGIN   

                If @Formato = 'd'  or @Formato = 'dd'  
                Begin
                        --Va a mostrar dia
                        SET @TipoFormato  = 1
                        SET @TipoFecha = 103
                End

                If @Formato = 'ddd'  
                Begin
                        --Va a mostrar Lun
                        SET @TipoFormato  = 2
                        SET @TipoFecha = 103
                End

                If @Formato = 'dddd'  
                Begin
                        --Va a mostrar Lunes
                        SET @TipoFormato  = 3
                        SET @TipoFecha = 103
                End

                If @Formato = 'm'  or @Formato = 'mm'  
                Begin
                        --Va a mostrar 01
                        SET @TipoFormato  = 4
                        SET @TipoFecha = 101
                End

                If @Formato = 'mmm'  
                Begin
                        --Va a mostrar Ene
                        SET @TipoFormato  = 5
                        SET @TipoFecha = 103
                End

                If @Formato = 'mmmm'  
                Begin
                        --Va a mostrar Enero
                        SET @TipoFormato  = 6
                        SET @TipoFecha = 103
                End

                If @Formato = 'y'  or @Formato = 'yy'  
                Begin
                        --Va a mostrar 79
                        SET @TipoFormato  = 7
                        SET @TipoFecha = 2
                End

                If @Formato = 'yyy'  or @Formato = 'yyyy'  
                Begin
                        --Va a mostrar 1979
                        SET @TipoFormato  = 8
                        SET @TipoFecha = 102
                End


                --PARA LOS DIAS

                If @Formato = 'd mm'  or @Formato = 'd-mm'  or @Formato = 'd/mm'  or @Formato = 'd.mm'  or 
                   @Formato = 'dd mm' or  @Formato = 'dd-mm'  or @Formato = 'dd/mm' or @Formato = 'dd.mm' 
                Begin
                        --Va a mostrar 01-01
                        SET @TipoFormato  = 9
                        SET @TipoFecha = 103
                End

                If @Formato = 'ddd mm' or  @Formato = 'ddd-mm'  or @Formato = 'ddd/mm' or @Formato = 'ddd.mm' 
                Begin
                        --Va a mostrar en dias Jue 02
                        SET @TipoFormato  = 10
                        SET @TipoFecha = 103
                End

                If @Formato = 'dddd mm' or  @Formato = 'dddd-mm'  or @Formato = 'dddd/mm' or @Formato = 'dddd.mm' 
                Begin
                        --Va a mostrar en dias Jueves 02
                        SET @TipoFormato  = 11
                        SET @TipoFecha = 103
                End

                --PARA LOS MESES
                If @Formato = 'dd mmm' or  @Formato = 'dd-mmm'  or @Formato = 'dd/mmm' or @Formato = 'dd.mmm' 
                Begin
                        --Va a mostrar en dias 01 Dic
                        SET @TipoFormato  = 12
                        SET @TipoFecha = 103
                End


                If @Formato = 'dd mmmm' or  @Formato = 'dd-mmmm'  or @Formato = 'dd/mmmm' or @Formato = 'dd.mmmm' 
                Begin
                        --Va a mostrar en dias 01 Diciembre
                        SET @TipoFormato  = 13
                        SET @TipoFecha = 103
                End


                If @Formato = 'm yy' or  @Formato = 'm-yy'  or @Formato = 'm/yy' or @Formato = 'm.yy' or 
                   @Formato = 'mm yy' or  @Formato = 'mm-yy'  or @Formato = 'mm/yy' or @Formato = 'mm.yy' 
                Begin
                        --Va a mostrar en dias 01 79
                        SET @TipoFormato  =14
                        SET @TipoFecha = 3
                End


                If @Formato = 'mmm yy' or  @Formato = 'mmm-yy'  or @Formato = 'mmm/yy' or @Formato = 'mmm.yy' 
                Begin
                        --Va a mostrar en  Dic 02
                        SET @TipoFormato  =15
                        SET @TipoFecha = 3
                End

                If @Formato = 'mmmm yy' or  @Formato = 'mmmm-yy'  or @Formato = 'mmmm/yy' or @Formato = 'mmmm.yy' 
                Begin
                        --Va a mostrar en  Diciembre 02
                        SET @TipoFormato  =16
                        SET @TipoFecha = 3
                End
                   

                If @Formato = 'mmm yyyy' or @Formato = 'mmm-yyyy' or @Formato = 'mmm/yyyy' or @Formato = 'mmm.yyyy'  
                Begin
                        --Va a mostrar en  Dic 2002
                        SET @TipoFormato  = 17
                        SET @TipoFecha = 103
                End

                If @Formato = 'mmmm yyyy' or  @Formato = 'mmmm-yyyy'  or @Formato = 'mmmm/yyyy' or @Formato = 'mmmm.yyyy' 
                Begin
                        --Va a mostrar en  Diciembre 2002
                        SET @TipoFormato  = 18
                        SET @TipoFecha = 103
                End

                If @Formato = 'd m yy' or @Formato = 'd-m-yy' or @Formato = 'd/m/yy' or @Formato = 'd.m.yy'   or 
                   @Formato = 'd mm yy' or @Formato = 'd-mm-yy' or @Formato = 'd/mm/yy' or @Formato = 'd.mm.yy'   or 
                   @Formato = 'dd mm yy' or @Formato = 'dd-mm-yy' or @Formato = 'dd/mm/yy' or @Formato = 'dd.mm.yy'
                Begin
                        --Va a mostrar en  01 02 79
                        SET @TipoFormato = 19
                        SET @TipoFecha = 3              --es el punto
                End


                If @Formato = 'd m yyyy' or @Formato = 'd-m-yyyy' or @Formato = 'd/m/yyyy' or @Formato = 'd.m.yyyy'   or 
                   @Formato = 'd mm yyyy' or @Formato = 'd-mm-yyyy' or @Formato = 'd/mm/yyyy' or @Formato = 'd.mm.yyyy'   or 
                   @Formato = 'dd mm yyyy' or @Formato = 'dd-mm-yyyy' or @Formato = 'dd/mm/yyyy' or @Formato = 'dd.mm.yyyy'
                Begin
                        --Va a mostrar en  01 02 1979
                        SET @TipoFormato = 20
                        SET @TipoFecha = 103            --es el punto
                End
        
                If @Formato = 'ddd mmm y' or @Formato = 'ddd-mmm-y' or @Formato = 'dddd/mmm/y' or @Formato = 'ddd.mmm.y' or 
                   @Formato = 'ddd mmm yy' or @Formato = 'ddd-mmm-yy' or @Formato = 'ddd/mmm/yy' or @Formato = 'ddd.mmm.yy' 
                Begin
                        --Va a mostrar en  lun Dic 79
                        SET @TipoFormato = 21
                        SET @TipoFecha = 3              --es el punto
                End

                If @Formato = 'ddd mmm yyyy' or @Formato = 'ddd-mmm-yyyy' or @Formato = 'dddd/mmm/yyyy' or @Formato = 'dddd.mmmm.yyyy' 
                Begin
                        --Va a mostrar en  lun Dic 1979
                        SET @TipoFormato = 22
                        SET @TipoFecha = 103            --es el punto
                End

                If @Formato = 'dddd mmmm yyyy' or @Formato = 'dddd-mmmm-yyyy' or @Formato = 'dddd/mmmm/yyyy' or @Formato = 'dddd.mmmm.yyyy' 
                Begin
                        --Va a mostrar en  lunes Diciembre 1979
                        SET @TipoFormato = 23
                        SET @TipoFecha = 103            --es el punto
                End
                
                
                If @Formato = 'ddd, dd mm yy' or @Formato = 'ddd, dd-mm-yy' or @Formato = 'ddd, dd/mm/yy' or @Formato = 'ddd, dd.mm.yy' 
                Begin
                        --Va a mostrar en  lun, 17 12 79
                        SET @TipoFormato = 24
                        SET @TipoFecha = 103            --es el punto
                End

                If @Formato = 'ddd, dd mmm yyyy' or @Formato = 'ddd, dd-mmm-yyyy' or @Formato = 'ddd, dd/mmm/yyyy' or @Formato = 'ddd, dd.mmm.yyyy' 
                Begin
                        --Va a mostrar en  lun, 17 Dic 1979
                        SET @TipoFormato = 25
                        SET @TipoFecha = 103            --es el punto
                End


				--ESTA PARTE FALTA
                If @Formato = 'dddd mmmm yyyy' or @Formato = 'dddd-mmmm-yyyy' or @Formato = 'dddd/mmmm/yyyy' or @Formato = 'dddd.mmmm.yyyy' 
                Begin
                        --Va a mostrar en  lunes Diciembre 1979
                        SET @TipoFormato = 26
                        SET @TipoFecha = 103            --es el punto
                End


                If @Formato = 'ddd, DD MM YY' or @Formato = 'ddd, DD-MM-YY' or @Formato = 'ddd, DD/MM/YY' or @Formato = 'ddd, DD.MM.YY' 
                Begin
                        --Va a mostrar en  lun, 17 12 79
                        SET @TipoFormato = 27
                        SET @TipoFecha = 103            --es el punto
                End



                set  @Devuelve  = CASE @TipoFormato 
                       WHEN 1 THEN SUBSTRING(CONVERT(VARCHAR(10),@CampoFormat,@TipoFecha),1,2)  
                       WHEN 2 THEN SUBSTRING(DATENAME(dw,CONVERT(VARCHAR(20),@CampoFormat)),1,3)
                       WHEN 3 THEN DATENAME(dw,CONVERT(VARCHAR(20),@CampoFormat))
                       WHEN 4 THEN SUBSTRING(CONVERT(VARCHAR(10),@CampoFormat,@TipoFecha),1,2)
                       WHEN 5 THEN SUBSTRING(DATENAME(mm,CONVERT(VARCHAR(20),@CampoFormat)),1,3)
                       WHEN 6 THEN DATENAME(mm,CONVERT(VARCHAR(20),@CampoFormat))
                       WHEN 7 THEN SUBSTRING(CONVERT(VARCHAR(10),@CampoFormat,@TipoFecha),1,2)  
                       WHEN 8 THEN SUBSTRING(CONVERT(VARCHAR(10),@CampoFormat,@TipoFecha),1,4)  
                       WHEN 9 THEN SUBSTRING(CONVERT(VARCHAR(10),@CampoFormat,@TipoFecha),1,2) + SUBSTRING(@Formato,PATINDEX('%m%',@Formato)-1,1)  + SUBSTRING(CONVERT(VARCHAR(10),@CampoFormat,@TipoFecha),4,2)
                       WHEN 10 THEN SUBSTRING(DATENAME(dw,CONVERT(VARCHAR(20),@CampoFormat)),1,3) + SUBSTRING(@Formato,4,1)   + SUBSTRING(CONVERT(VARCHAR(10),@CampoFormat,@TipoFecha),4,2)
                       WHEN 11 THEN DATENAME(dw,CONVERT(VARCHAR(20),@CampoFormat)) + SUBSTRING(@Formato,5,1)   + SUBSTRING(CONVERT(VARCHAR(10),@CampoFormat,@TipoFecha),4,2)
                       WHEN 12 THEN SUBSTRING(CONVERT(VARCHAR(10),@CampoFormat,@TipoFecha),1,2)  + SUBSTRING(@Formato,3,1)   + SUBSTRING(DATENAME(mm,CONVERT(VARCHAR(20),@CampoFormat)),1,3)
                       WHEN 13 THEN SUBSTRING(CONVERT(VARCHAR(10),@CampoFormat,@TipoFecha),1,2)  + SUBSTRING(@Formato,3,1)   + DATENAME(mm,CONVERT(VARCHAR(20),@CampoFormat))
                       WHEN 14 THEN SUBSTRING(CONVERT(VARCHAR(10),@CampoFormat,@TipoFecha),4,2)  + SUBSTRING(@Formato,PATINDEX('%y%',@Formato)-1,1)   + SUBSTRING(CONVERT(VARCHAR(10),@CampoFormat,@TipoFecha),7,2) 
                       WHEN 15 THEN SUBSTRING(DATENAME(mm,CONVERT(VARCHAR(20),@CampoFormat)),1,3)  + SUBSTRING(@Formato,4,1)   + SUBSTRING(CONVERT(VARCHAR(10),@CampoFormat,@TipoFecha),7,2) 
                       WHEN 16 THEN DATENAME(mm,CONVERT(VARCHAR(20),@CampoFormat))  + SUBSTRING(@Formato,5,1)   + SUBSTRING(CONVERT(VARCHAR(10),@CampoFormat,@TipoFecha),7,2) 
                       WHEN 17 THEN SUBSTRING(DATENAME(mm,CONVERT(VARCHAR(20),@CampoFormat)),1,3)  + SUBSTRING(@Formato,4,1)   + SUBSTRING(CONVERT(VARCHAR(10),@CampoFormat,@TipoFecha),7,4) 
                       WHEN 18 THEN DATENAME(mm,CONVERT(VARCHAR(20),@CampoFormat))  + SUBSTRING(@Formato,5,1)   + SUBSTRING(CONVERT(VARCHAR(10),@CampoFormat,@TipoFecha),7,4) 
                       WHEN 19 THEN SUBSTRING(CONVERT(VARCHAR(10),@CampoFormat,@TipoFecha),1,2)  + SUBSTRING(@Formato,PATINDEX('%m%',@Formato)-1,1)   +  SUBSTRING(CONVERT(VARCHAR(10),@CampoFormat,@TipoFecha),4,2) +  SUBSTRING(@Formato,PATINDEX('%m%',@Formato)-1,1)  + SUBSTRING(CONVERT(VARCHAR(10),@CampoFormat,@TipoFecha),7,2) 
                       WHEN 20 THEN SUBSTRING(CONVERT(VARCHAR(10),@CampoFormat,@TipoFecha),1,2)  + SUBSTRING(@Formato,PATINDEX('%m%',@Formato)-1,1)   +  SUBSTRING(CONVERT(VARCHAR(10),@CampoFormat,@TipoFecha),4,2) +  SUBSTRING(@Formato,PATINDEX('%m%',@Formato)-1,1)  + SUBSTRING(CONVERT(VARCHAR(10),@CampoFormat,@TipoFecha),7,4) 
                       WHEN 21 THEN SUBSTRING(DATENAME(dw,CONVERT(VARCHAR(20),@CampoFormat)),1,3) + SUBSTRING(@Formato,PATINDEX('%m%',@Formato)-1,1)   +  SUBSTRING(DATENAME(mm,CONVERT(VARCHAR(20),@CampoFormat)),1,3) +  SUBSTRING(@Formato,PATINDEX('%m%',@Formato)-1,1)  + SUBSTRING(CONVERT(VARCHAR(10),@CampoFormat,@TipoFecha),7,2) 
                       WHEN 22 THEN SUBSTRING(DATENAME(dw,CONVERT(VARCHAR(20),@CampoFormat)),1,3) + SUBSTRING(@Formato,PATINDEX('%m%',@Formato)-1,1)   +  SUBSTRING(DATENAME(mm,CONVERT(VARCHAR(20),@CampoFormat)),1,3) +  SUBSTRING(@Formato,PATINDEX('%m%',@Formato)-1,1)  + SUBSTRING(CONVERT(VARCHAR(10),@CampoFormat,@TipoFecha),7,4) 
                       WHEN 23 THEN DATENAME(dw,CONVERT(VARCHAR(20),@CampoFormat)) + SUBSTRING(@Formato,PATINDEX('%m%',@Formato)-1,1)   +  DATENAME(mm,CONVERT(VARCHAR(20),@CampoFormat)) +  SUBSTRING(@Formato,PATINDEX('%m%',@Formato)-1,1)  + SUBSTRING(CONVERT(VARCHAR(10),@CampoFormat,@TipoFecha),7,4)  
					   WHEN 24 THEN SUBSTRING(DATENAME(dw,CONVERT(VARCHAR(20),@CampoFormat)),1,3) + ', ' + SUBSTRING(CONVERT(VARCHAR(10),@CampoFormat,@TipoFecha),1,2)  + SUBSTRING(@Formato,PATINDEX('%m%',@Formato)-1,1)   +  SUBSTRING(CONVERT(VARCHAR(10),@CampoFormat,@TipoFecha),4,2) +  SUBSTRING(@Formato,PATINDEX('%m%',@Formato)-1,1)  + SUBSTRING(CONVERT(VARCHAR(10),@CampoFormat,@TipoFecha),9,2) 
					   WHEN 25 THEN SUBSTRING(DATENAME(dw,CONVERT(VARCHAR(20),@CampoFormat)),1,3) + ', ' + SUBSTRING(CONVERT(VARCHAR(10),@CampoFormat,@TipoFecha),1,2)  + SUBSTRING(@Formato,PATINDEX('%m%',@Formato)-1,1) +  SUBSTRING(DATENAME(mm,CONVERT(VARCHAR(20),@CampoFormat)),1,3)  + SUBSTRING(@Formato,PATINDEX('%m%',@Formato)-1,1)  + SUBSTRING(CONVERT(VARCHAR(10),@CampoFormat,@TipoFecha),7,4) 

                       ELSE CONVERT(VARCHAR(50),@CampoFormat)
                        


                                                END     

                GOTO SALIR


        END
        ELSE
        BEGIN
        
                If @Formato = '###,###.#0'
                Begin
                        SET @CantDecimales = 2
                        SET @CantPos= 15 
                        SET @TipoFecha = 101
                        Set @Devuelve = CONVERT( DECIMAL(26,2), @CampoFormat )
                End

                If @Formato = '###,###'
                Begin
                        SET @CantDecimales = 0
                        SET @PosIni = 1 
                        SET @CantPos= 15 
                        SET @TipoFecha = 101
                        Set @Devuelve = CONVERT( DECIMAL(26,0), @CampoFormat )
                End

                set @Primero  = 1
                SET @LOOP = 1
                

                WHILE @LOOP=1
                BEGIN 
                        If @Primero = 1 
                        BEGIN
                                SET @Primero = 0
                                If len(@Devuelve) > 6
                                BEGIN
                                        if CHARINDEX('.',@Devuelve)> 0 
                                        BEGIN
                                                SET @Devuelve = STUFF(@Devuelve,CHARINDEX('.',@Devuelve)-3, 0, ',')
                                        END
                                        ELSE
                                        BEGIN
                                                SET @Devuelve = STUFF(@Devuelve,LEN(@Devuelve)-2, 0, ',')
                                        END
                                END
                                ELSE
                                BEGIN   
                                        SET @LOOP = 0
                                        BREAK                   
                                END
                        END
                        ELSE
                        BEGIN
                                IF CHARINDEX(',',@Devuelve) <= 4
                                BEGIN
                                        SET @LOOP = 0
                                        BREAK
                                END
                                ELSE
                                BEGIN
                                        SET @Devuelve = STUFF(@Devuelve,CHARINDEX(',',@Devuelve)-3, 0, ',')
                                END --IF
                        END     --IF
                        
                END             --WHILE
                

        END
Salir:
        Return(@Devuelve)
        /*
select dbo.fn_format(getdate(),'ddd, dd/mmm/yyyy')
select dbo.fn_format('123456.8','###,###.#0')
*/

end
GO
/****** Object:  UserDefinedFunction [dbo].[fnColocaClave]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*

--El campo a cifrar es contrasena y se guarda el valor sqlPsyKrest.
INSERT INTO USUARIO_CUR (nombre, apellidos, email, contrasena, activo, fecha_add)
VALUES('Ivan','Rangel','ir@email.com',dbo.fnColocaClave('sqlPsyKrest'),1,GETDATE())
GO
SELECT id, nombre, apellidos, email, contrasena
FROM USUARIO_CUR
GO
CREATE FUNCTION fnLeeClave
(
    @clave VARBINARY(8000)
)
RETURNS VARCHAR(25)
AS
BEGIN

    DECLARE @pass AS VARCHAR(25)
    ------------------------------------
    ------------------------------------
    --Se descifra el campo aplicandole la misma llave con la que se cifro dbCurso09
    SET @pass = DECRYPTBYPASSPHRASE('dbCurso09',@clave)
    ------------------------------------
    ------------------------------------
    RETURN @pass

END
SELECT id, nombre, apellidos, email, dbo.fnLeeClave(contrasena)
FROM USUARIO_CUR

*/


CREATE FUNCTION [dbo].[fnColocaClave]
(
    @clave VARCHAR(25)
)
RETURNS VarBinary(8000)
AS
BEGIN

    DECLARE @pass AS VarBinary(8000)
    ------------------------------------
    ------------------------------------
    SET @pass = ENCRYPTBYPASSPHRASE('dbCurso09',@clave)--dbCurso09 es la llave para cifrar el campo.
    ------------------------------------
    ------------------------------------
    RETURN @pass

END
GO
/****** Object:  View [dbo].[Product Sales for 1997]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create view [dbo].[Product Sales for 1997] AS
SELECT Categories.CategoryName, Products.ProductName, 
Sum(CONVERT(money,("Order Details".UnitPrice*Quantity*(1-Discount)/100))*100) AS ProductSales
FROM (Categories INNER JOIN Products ON Categories.CategoryID = Products.CategoryID) 
	INNER JOIN (Orders 
		INNER JOIN "Order Details" ON Orders.OrderID = "Order Details".OrderID) 
	ON Products.ProductID = "Order Details".ProductID
WHERE (((Orders.ShippedDate) Between '19970101' And '19971231'))
GROUP BY Categories.CategoryName, Products.ProductName
GO
/****** Object:  View [dbo].[Category Sales for 1997]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create view [dbo].[Category Sales for 1997] AS
SELECT "Product Sales for 1997".CategoryName, Sum("Product Sales for 1997".ProductSales) AS CategorySales
FROM "Product Sales for 1997"
GROUP BY "Product Sales for 1997".CategoryName
GO
/****** Object:  View [dbo].[Order Details Extended]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create view [dbo].[Order Details Extended] AS
SELECT "Order Details".OrderID, "Order Details".ProductID, Products.ProductName, 
	"Order Details".UnitPrice, "Order Details".Quantity, "Order Details".Discount, 
	(CONVERT(money,("Order Details".UnitPrice*Quantity*(1-Discount)/100))*100) AS ExtendedPrice
FROM Products INNER JOIN "Order Details" ON Products.ProductID = "Order Details".ProductID
--ORDER BY "Order Details".OrderID
GO
/****** Object:  View [dbo].[Sales by Category]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create view [dbo].[Sales by Category] AS
SELECT Categories.CategoryID, Categories.CategoryName, Products.ProductName, 
	Sum("Order Details Extended".ExtendedPrice) AS ProductSales
FROM 	Categories INNER JOIN 
		(Products INNER JOIN 
			(Orders INNER JOIN "Order Details Extended" ON Orders.OrderID = "Order Details Extended".OrderID) 
		ON Products.ProductID = "Order Details Extended".ProductID) 
	ON Categories.CategoryID = Products.CategoryID
WHERE Orders.OrderDate BETWEEN '19970101' And '19971231'
GROUP BY Categories.CategoryID, Categories.CategoryName, Products.ProductName
--ORDER BY Products.ProductName
GO
/****** Object:  View [dbo].[Order Subtotals]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create view [dbo].[Order Subtotals] AS
SELECT "Order Details".OrderID, Sum(CONVERT(money,("Order Details".UnitPrice*Quantity*(1-Discount)/100))*100) AS Subtotal
FROM "Order Details"
GROUP BY "Order Details".OrderID
GO
/****** Object:  View [dbo].[Sales Totals by Amount]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create view [dbo].[Sales Totals by Amount] AS
SELECT "Order Subtotals".Subtotal AS SaleAmount, Orders.OrderID, Customers.CompanyName, Orders.ShippedDate
FROM 	Customers INNER JOIN 
		(Orders INNER JOIN "Order Subtotals" ON Orders.OrderID = "Order Subtotals".OrderID) 
	ON Customers.CustomerID = Orders.CustomerID
WHERE ("Order Subtotals".Subtotal >2500) AND (Orders.ShippedDate BETWEEN '19970101' And '19971231')
GO
/****** Object:  View [dbo].[Summary of Sales by Quarter]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create view [dbo].[Summary of Sales by Quarter] AS
SELECT Orders.ShippedDate, Orders.OrderID, "Order Subtotals".Subtotal
FROM Orders INNER JOIN "Order Subtotals" ON Orders.OrderID = "Order Subtotals".OrderID
WHERE Orders.ShippedDate IS NOT NULL
--ORDER BY Orders.ShippedDate
GO
/****** Object:  View [dbo].[Summary of Sales by Year]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create view [dbo].[Summary of Sales by Year] AS
SELECT Orders.ShippedDate, Orders.OrderID, "Order Subtotals".Subtotal
FROM Orders INNER JOIN "Order Subtotals" ON Orders.OrderID = "Order Subtotals".OrderID
WHERE Orders.ShippedDate IS NOT NULL
--ORDER BY Orders.ShippedDate
GO
/****** Object:  View [dbo].[Alphabetical list of products]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create view [dbo].[Alphabetical list of products] AS
SELECT Products.*, Categories.CategoryName
FROM Categories INNER JOIN Products ON Categories.CategoryID = Products.CategoryID
WHERE (((Products.Discontinued)=0))
GO
/****** Object:  View [dbo].[Current Product List]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create view [dbo].[Current Product List] AS
SELECT Product_List.ProductID, Product_List.ProductName
FROM Products AS Product_List
WHERE (((Product_List.Discontinued)=0))
--ORDER BY Product_List.ProductName
GO
/****** Object:  View [dbo].[Customer and Suppliers by City]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create view [dbo].[Customer and Suppliers by City] AS
SELECT City, CompanyName, ContactName, 'Customers' AS Relationship 
FROM Customers
UNION SELECT City, CompanyName, ContactName, 'Suppliers'
FROM Suppliers
--ORDER BY City, CompanyName
GO
/****** Object:  View [dbo].[Invoices]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create view [dbo].[Invoices] AS
SELECT Orders.ShipName, Orders.ShipAddress, Orders.ShipCity, Orders.ShipRegion, Orders.ShipPostalCode, 
	Orders.ShipCountry, Orders.CustomerID, Customers.CompanyName AS CustomerName, Customers.Address, Customers.City, 
	Customers.Region, Customers.PostalCode, Customers.Country, 
	(FirstName + ' ' + LastName) AS Salesperson, 
	Orders.OrderID, Orders.OrderDate, Orders.RequiredDate, Orders.ShippedDate, Shippers.CompanyName As ShipperName, 
	"Order Details".ProductID, Products.ProductName, "Order Details".UnitPrice, "Order Details".Quantity, 
	"Order Details".Discount, 
	(CONVERT(money,("Order Details".UnitPrice*Quantity*(1-Discount)/100))*100) AS ExtendedPrice, Orders.Freight
FROM 	Shippers INNER JOIN 
		(Products INNER JOIN 
			(
				(Employees INNER JOIN 
					(Customers INNER JOIN Orders ON Customers.CustomerID = Orders.CustomerID) 
				ON Employees.EmployeeID = Orders.EmployeeID) 
			INNER JOIN "Order Details" ON Orders.OrderID = "Order Details".OrderID) 
		ON Products.ProductID = "Order Details".ProductID) 
	ON Shippers.ShipperID = Orders.ShipVia
GO
/****** Object:  View [dbo].[Orders Qry]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create view [dbo].[Orders Qry] AS
SELECT Orders.OrderID, Orders.CustomerID, Orders.EmployeeID, Orders.OrderDate, Orders.RequiredDate, 
	Orders.ShippedDate, Orders.ShipVia, Orders.Freight, Orders.ShipName, Orders.ShipAddress, Orders.ShipCity, 
	Orders.ShipRegion, Orders.ShipPostalCode, Orders.ShipCountry, 
	Customers.CompanyName, Customers.Address, Customers.City, Customers.Region, Customers.PostalCode, Customers.Country
FROM Customers INNER JOIN Orders ON Customers.CustomerID = Orders.CustomerID
GO
/****** Object:  View [dbo].[Products Above Average Price]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create view [dbo].[Products Above Average Price] AS
SELECT Products.ProductName, Products.UnitPrice
FROM Products
WHERE Products.UnitPrice>(SELECT AVG(UnitPrice) From Products)
--ORDER BY Products.UnitPrice DESC
GO
/****** Object:  View [dbo].[Products by Category]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create view [dbo].[Products by Category] AS
SELECT Categories.CategoryName, Products.ProductName, Products.QuantityPerUnit, Products.UnitsInStock, Products.Discontinued
FROM Categories INNER JOIN Products ON Categories.CategoryID = Products.CategoryID
WHERE Products.Discontinued <> 1
--ORDER BY Categories.CategoryName, Products.ProductName
GO
/****** Object:  View [dbo].[Quarterly Orders]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create view [dbo].[Quarterly Orders] AS
SELECT DISTINCT Customers.CustomerID, Customers.CompanyName, Customers.City, Customers.Country
FROM Customers RIGHT JOIN Orders ON Customers.CustomerID = Orders.CustomerID
WHERE Orders.OrderDate BETWEEN '19970101' And '19971231'
GO
/****** Object:  View [dbo].[suma]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[suma]
as
select total=sum(od.UnitPrice*Quantity)
from products p ,[order details] od
where od.ProductID=p.ProductID and  p.ProductID = 1
GO
/****** Object:  View [dbo].[V_CLIENTE]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[V_CLIENTE] AS
SELECT CustomerID,CompanyName FROM customers
GO
/****** Object:  View [dbo].[VentaTotalDeOrdenesS9]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[VentaTotalDeOrdenesS9]
as
select OrderId,VentaTotal=Sum(UnitPrice* Quantity)
from [Order Details] group By OrderId
GO
/****** Object:  View [dbo].[vista1]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[vista1]
as
select T_Final=sum(unitprice*quantity)from [order details]
GO
/****** Object:  StoredProcedure [dbo].[A_ACTUALIZAR_URL]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
use prueba
go
sp_help acceso
select * from USUARIO_acceso
select * from USUARIO
select flag_web,* from prueba.dbo.acceso where flag_web='1'
select flag_web,* from netdat.dbo.acceso where flag_web='1'
select * from acceso where id_acceso LIKE ('8920%') AND ID_ESTADO ='01'
select * from acceso where id_acceso LIKE ('8930%') AND ID_ESTADO ='01'
go
select * from acceso where id_acceso LIKE ('88%') AND ID_ESTADO ='01'
A_ACTUALIZAR_URL 1, '892040' , 'Orden Servicio Tecnico'
A_ACTUALIZAR_URL 3, '892040' , 'Sistema/Operaciones/webOrdenServicioTecnico.aspx'
A_ACTUALIZAR_URL 4, '8820' , '88'
A_ACTUALIZAR_URL 5, '8820' , '2'
A_ACTUALIZAR_URL 7, '892030' , '01'
A_ACTUALIZAR_URL 2, '88' , 'AS - ADMINISTRACION SISTEMA'
A_ACTUALIZAR_URL 6, '891010' , '3'
A_ACTUALIZAR_URL 5, '862060' , '60'
A_ACTUALIZAR_URL 11, '01','891020'
*/
CREATE PROC [dbo].[A_ACTUALIZAR_URL]
@VALOR	INT,@ID_ACCESO VARCHAR(MAX),@NOMBRE_EXE VARCHAR(MAX)
AS
IF(@VALOR=1)	-- ACTUALIZAR DESCRIPCION  ----------------------------------------------
BEGIN
	UPDATE	ACCESO	SET	DESCRIPCION=@NOMBRE_EXE			WHERE	ID_ACCESO=@ID_ACCESO
END
------------------------------------------------------------------------------------------------
IF(@VALOR=2)	-- ACTUALIZAR DESCRIPCION_CORTA  ----------------------------------------------
BEGIN				
	UPDATE	ACCESO	SET	DESCRIPCION_CORTA=@NOMBRE_EXE	WHERE	ID_ACCESO=@ID_ACCESO
END
------------------------------------------------------------------------------------------------
IF(@VALOR=3)	-- ACTUALIZAR URL  ----------------------------------------------
BEGIN
	UPDATE	ACCESO	SET		NOMBRE_EXE=@NOMBRE_EXE		WHERE	ID_ACCESO=@ID_ACCESO
END
------------------------------------------------------------------------------------------------
IF(@VALOR=4)	-- ACTUALIZAR ID_ACCESO_SUPERIOR  ----------------------------------------------
BEGIN
	UPDATE	ACCESO	SET	ID_ACCESO_SUPERIOR=@NOMBRE_EXE	WHERE	ID_ACCESO=@ID_ACCESO
END
------------------------------------------------------------------------------------------------
IF(@VALOR=5)	-- ACTUALIZAR ORDEN  ----------------------------------------------
BEGIN
	UPDATE	ACCESO	SET	ORDEN=@NOMBRE_EXE				WHERE	ID_ACCESO=@ID_ACCESO 
END
------------------------------------------------------------------------------------------------
IF(@VALOR=6)	-- ACTUALIZAR FLAG_TIPO  ----------------------------------------------
BEGIN
	UPDATE	ACCESO	SET	FLAG_TIPO=@NOMBRE_EXE				WHERE	ID_ACCESO=@ID_ACCESO
END
------------------------------------------------------------------------------------------------
IF(@VALOR=7)	-- ACTUALIZAR ID_ESTADO  ----------------------------------------------
BEGIN
	UPDATE	ACCESO	SET	ID_ESTADO=@NOMBRE_EXE			WHERE	ID_ACCESO=@ID_ACCESO
END
------------------------------------------------------------------------------------------------
IF(@VALOR=8)	-- ACTUALIZAR FLAg  ----------------------------------------------
BEGIN
	UPDATE	ACCESO	SET	FLAG_WEB=@NOMBRE_EXE			WHERE	ID_ACCESO=@ID_ACCESO
END
------------------------------------------------------------------------------------------------
IF(@VALOR=9)	-- ELIMINAR ID_ACCESO  ----------------------------------------------
BEGIN
	DELETE	FROM ACCESO	WHERE cia=@NOMBRE_EXE and ID_ACCESO =@ID_ACCESO
END
------------------------------------------------------------------------------------------------
GO
/****** Object:  StoredProcedure [dbo].[A_NETDAT]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE [dbo].[A_NETDAT](@sCia char(2), @sMoneda char(2), @sTabla varchar(30), @sFiltro varchar(2000))

AS

SET NOCOUNT ON
--DECLARE @sCia char(2), @sAnio char(4), @sMes char(2), @sMoneda char(2), @sTabla varchar(30), @sFiltro varchar(2000)
DECLARE @sLibro char(3), @sAgrupadoPor char(2)
DECLARE @sSelect varchar(1000), @sGroupBy varchar(1000), @sSelect2 varchar(1000), @sGroupBy2 varchar(1000), @sSelect3 varchar(1000), @sGroupBy3 varchar(1000)
--SELECT @sCia='01', @sAnio='2008', @sMes='01', @sMoneda='02', @sTabla='tas123', @sFiltroLibro='700'
--SELECT @sCia='01', @sMoneda='02', @sTabla='tas123', @sFiltro=' and a.anio=''2009'' and a.mes=''08'' and a.id_libro=''700'' '
--SELECT @sCia='01', @sMoneda='02', @sTabla='TAS20090722203800', @sFiltro=' and (a.fecha_contable>=''2009-08-18 00:00:00'' and a.fecha_contable<=''2009-08-18 23:59:59'') and a.id_libro=''700'' '
SELECT @sSelect='', @sGroupBy=''

DECLARE sql1 CURSOR FOR
SELECT id_libro, id_agrupado_por
FROM libro_auxiliar
WHERE cia=@sCia --and id_libro=@sFiltroLibro
ORDER BY id_libro
OPEN sql1
FETCH NEXT FROM sql1 INTO @sLibro, @sAgrupadoPor
WHILE @@FETCH_STATUS = 0
BEGIN
 SELECT @sSelect='', @sGroupBy=''
--creando las cadenas para insertar data
 IF @sAgrupadoPor='00' --GENERAL
  BEGIN
   SELECT @sSelect='a.cia, a.sede, a.id_asiento, null, a.fecha_contable, l.id_libro,
    ad.id_cuenta, ad.id_centro_costo, ad.id_actividad,
    ad.id_tipo_analitica, ad.id_analitica,
    ad.id_tipo_doc, ad.serie_doc, ad.nro_doc, null, ad.tipo_cambio,
    case when a.id_estado=''01'' then ad.glosa else ''***** ANULADO *****'' end,
    a.uc, a.um, a.id_estado,
    (convert(decimal(19,2),case when a.id_estado=''01'' and ad.id_estado=''01'' then ad.debe_01 else 0 end)),
    (convert(decimal(19,2),case when a.id_estado=''01'' and ad.id_estado=''01'' then ad.haber_01 else 0 end)),
    (convert(decimal(19,2),case when a.id_estado=''01'' and ad.id_estado=''01'' then ad.debe_'+@sMoneda+' else 0 end)),
    (convert(decimal(19,2),case when a.id_estado=''01'' and ad.id_estado=''01'' then ad.haber_'+@sMoneda+' else 0 end))'
   SELECT @sGroupBy=''
  END
 IF @sAgrupadoPor='01' --FECHA
  BEGIN
   SELECT @sSelect='a.cia, a.sede, min(a.id_asiento), max(a.id_asiento), a.fecha_contable, l.id_libro,
    ad.id_cuenta, null, null,
    null, null,
    null, null, null, null, null, null,
    null, null, ''01'',
    sum(convert(decimal(19,2),case when a.id_estado=''01'' and ad.id_estado=''01'' then ad.debe_01 else 0 end)),
    sum(convert(decimal(19,2),case when a.id_estado=''01'' and ad.id_estado=''01'' then ad.haber_01 else 0 end)),
    sum(convert(decimal(19,2),case when a.id_estado=''01'' and ad.id_estado=''01'' then ad.debe_'+@sMoneda+' else 0 end)),
    sum(convert(decimal(19,2),case when a.id_estado=''01'' and ad.id_estado=''01'' then ad.haber_'+@sMoneda+' else 0 end))'
   SELECT @sGroupBy='GROUP BY a.cia, a.sede, a.fecha_contable, l.id_libro, ad.id_cuenta'
  END
 IF @sAgrupadoPor='02' --FECHA - ANALITICA
  BEGIN
   SELECT @sSelect='a.cia, a.sede, min(a.id_asiento), max(a.id_asiento), a.fecha_contable, l.id_libro,
    ad.id_cuenta, null, null,
    ad.id_tipo_analitica, ad.id_analitica,
    null, null, null, null, null, null,
    null, null, ''01'',
    sum(convert(decimal(19,2),case when a.id_estado=''01'' and ad.id_estado=''01'' then ad.debe_01 else 0 end)),
    sum(convert(decimal(19,2),case when a.id_estado=''01'' and ad.id_estado=''01'' then ad.haber_01 else 0 end)),
    sum(convert(decimal(19,2),case when a.id_estado=''01'' and ad.id_estado=''01'' then ad.debe_'+@sMoneda+' else 0 end)),
    sum(convert(decimal(19,2),case when a.id_estado=''01'' and ad.id_estado=''01'' then ad.haber_'+@sMoneda+' else 0 end))'
   SELECT @sGroupBy='GROUP BY a.cia, a.sede, a.fecha_contable, l.id_libro, ad.id_cuenta, ad.id_tipo_analitica, ad.id_analitica'
  END
 IF @sAgrupadoPor='03' --FECHA - DOCUMENTO
  BEGIN
   --min(a.id_asiento)+''-''+max(substring(a.id_asiento,10,10)), min(ad.nro_doc)+''-''+max(ad.nro_doc)
   SELECT @sSelect='a.cia, a.sede, min(a.id_asiento), max(a.id_asiento), a.fecha_contable, l.id_libro,
    ad.id_cuenta, null, null,
    null, null,
    ad.id_tipo_doc, ad.serie_doc, min(ad.nro_doc), max(ad.nro_doc), null, null,
    null, null, ''01'',
    sum(convert(decimal(19,2),case when a.id_estado=''01'' and ad.id_estado=''01'' then ad.debe_01 else 0 end)),
    sum(convert(decimal(19,2),case when a.id_estado=''01'' and ad.id_estado=''01'' then ad.haber_01 else 0 end)),
    sum(convert(decimal(19,2),case when a.id_estado=''01'' and ad.id_estado=''01'' then ad.debe_'+@sMoneda+' else 0 end)),
    sum(convert(decimal(19,2),case when a.id_estado=''01'' and ad.id_estado=''01'' then ad.haber_'+@sMoneda+' else 0 end))'
   SELECT @sGroupBy='GROUP BY a.cia, a.sede, a.fecha_contable, l.id_libro, ad.id_cuenta, ad.id_tipo_doc, ad.serie_doc'
  END
 IF @sAgrupadoPor='04' --FECHA - DOCUMENTO X INTERVALO
 ----------------------------------------------------------------------------------------------------
 ----------------------------------------------------------------------------------------------------
  BEGIN ----------------------------------------------------------------------------------------------------
-- SE QUITO ESTE QUERY  and ad.item=(case when a.id_estado=''01'' then ad.item else 1 end)
EXEC('
DECLARE @sSede char(2), @dtFecha datetime, @sCuenta varchar(20), @sTipoDoc char(2), @sSerieDoc char(4), @sNroDoc varchar(20), @sTipoAnalitica char(2), @sAnalitica varchar(20), @sEstado char(2), @sAsiento varchar(20), @sCentroCosto varchar(20), @sActividad varchar(20), @nTipoCambio decimal(19,6), @sGlosa varchar(100), @sUC varchar(10), @sUM varchar(10), @nDebe01 decimal(19,2), @nHaber01 decimal(19,2), @nDebe02 decimal(19,2), @nHaber02 decimal(19,2)
DECLARE @sSede2 char(2), @dtFecha2 datetime, @sCuenta2 varchar(20), @sTipoDoc2 char(2), @sSerieDoc2 char(4), @sNroDoc2 varchar(20), @sTipoAnalitica2 char(2), @sAnalitica2 varchar(20), @sEstado2 char(2), @sAsiento2 varchar(20), @sCentroCosto2 varchar(20), @sActividad2 varchar(20), @nTipoCambio2 decimal(19,6), @sGlosa2 varchar(100), @sUC2 varchar(10), @sUM2 varchar(10), @nDebe201 decimal(19,2), @nHaber201 decimal(19,2), @nDebe202 decimal(19,2), @nHaber202 decimal(19,2)
DECLARE @sNroDocIni varchar(20), @sAsientoIni varchar(20), @nDebe01Suma decimal(19,2), @nHaber01Suma decimal(19,2), @nDebe02Suma decimal(19,2), @nHaber02Suma decimal(19,2)
DECLARE sql2 CURSOR FOR
 SELECT a.sede, a.id_asiento, a.fecha_contable, ad.id_cuenta, ad.id_centro_costo, ad.id_actividad,
  isnull(ad.id_tipo_analitica,''''), isnull(ad.id_analitica,''''),
  isnull(ad.id_tipo_doc,''''), isnull(ad.serie_doc,''''), isnull(ad.nro_doc,''''), ad.tipo_cambio, ad.glosa, a.uc, a.um, a.id_estado,
  (convert(decimal(19,2),case when a.id_estado=''01'' and ad.id_estado=''01'' then ad.debe_01 else 0 end)) as ''debe_01'',
  (convert(decimal(19,2),case when a.id_estado=''01'' and ad.id_estado=''01'' then ad.haber_01 else 0 end)) as ''haber_01'',
  (convert(decimal(19,2),case when a.id_estado=''01'' and ad.id_estado=''01'' then ad.debe_'+@sMoneda+' else 0 end)) as ''debe_02'',
  (convert(decimal(19,2),case when a.id_estado=''01'' and ad.id_estado=''01'' then ad.haber_'+@sMoneda+' else 0 end)) as ''haber_02''
 FROM asiento a
 INNER JOIN asiento_detalle ad ON ad.cia=a.cia and ad.sede=a.sede and ad.id_asiento=a.id_asiento
  and ad.item=(case when a.id_estado=''01'' then ad.item else 1 end)
 INNER JOIN libro_auxiliar l ON l.cia=a.cia  and l.id_libro=a.id_libro and isnull(l.id_agrupado_por,''00'')='''+@sAgrupadoPor+'''
 WHERE a.cia='''+@sCia+''' and a.id_libro='''+@sLibro+'''
 '+@sFiltro+'
 ORDER BY a.sede, a.fecha_contable, ad.id_cuenta, ad.id_tipo_doc, ad.serie_doc, ad.nro_doc
OPEN sql2
FETCH NEXT FROM sql2 INTO @sSede, @sAsiento, @dtFecha, @sCuenta, @sCentroCosto, @sActividad, @sTipoAnalitica, @sAnalitica, @sTipoDoc, @sSerieDoc, @sNroDoc, @nTipoCambio, @sGlosa, @sUC, @sUM, @sEstado, @nDebe01, @nHaber01, @nDebe02, @nHaber02
SELECT @sNroDocIni=null, @nDebe01Suma=0, @nHaber01Suma=0, @nDebe02Suma=0, @nHaber02Suma=0
WHILE @@FETCH_STATUS = 0
BEGIN
 IF (not @sNroDocIni is null) and (@sSede2!=@sSede or @dtFecha2!=@dtFecha or @sCuenta2!=@sCuenta or @sTipoDoc2!=@sTipoDoc or @sSerieDoc2!=@sSerieDoc or @sTipoAnalitica2!=@sTipoAnalitica or @sAnalitica2!=@sAnalitica or @sEstado2!=@sEstado or @sEstado=''02'')
  BEGIN
   IF @sNroDocIni!=@sNroDoc2
    SELECT @sCentroCosto2=null, @sActividad2=null, @nTipoCambio2=abs(case when (@nDebe02Suma-@nHaber02Suma)!=0 then (@nDebe01Suma-@nHaber01Suma)/(@nDebe02Suma-@nHaber02Suma) else 0 end), @sGlosa2=''***** CONSOLIDADO *****'', @sUC2=null, @sUM2=null
   IF @sEstado2=''02''
    SELECT @sGlosa2=''***** ANULADO *****''
   INSERT INTO '+@sTabla+'(cia, sede, id_asiento_min, id_asiento_max, fecha_contable, id_libro, id_cuenta, id_centro_costo, id_actividad, id_tipo_analitica, id_analitica, id_tipo_doc, serie_doc, nro_doc_min, nro_doc_max, tipo_cambio, glosa, uc, um, id_estado, debe_01, haber_01, debe_02, haber_02)
   VALUES('''+@sCia+''', @sSede2, @sAsientoIni, @sAsiento2, @dtFecha2, '''+@sLibro+''', @sCuenta2, @sCentroCosto2, @sActividad2, @sTipoAnalitica2, @sAnalitica2, @sTipoDoc2, @sSerieDoc2, @sNroDocIni, @sNroDoc2, @nTipoCambio2, @sGlosa2, @sUC2, @sUM2, @sEstado2, @nDebe01Suma, @nHaber01Suma, @nDebe02Suma, @nHaber02Suma)
   SELECT @sNroDocIni=@sNroDoc, @sAsientoIni=@sAsiento, @nDebe01Suma=0, @nHaber01Suma=0, @nDebe02Suma=0, @nHaber02Suma=0
 END
   SELECT @sSede2=@sSede, @sAsiento2=@sAsiento, @dtFecha2=@dtFecha, @sCuenta2=@sCuenta, @sCentroCosto2=@sCentroCosto, @sActividad2=@sActividad, @sTipoAnalitica2=@sTipoAnalitica, @sAnalitica2=@sAnalitica, @sTipoDoc2=@sTipoDoc, @sSerieDoc2=@sSerieDoc, @sNroDoc2=@sNroDoc, @nTipoCambio2=@nTipoCambio, @sGlosa2=@sGlosa, @sUC2=@sUC, @sUM2=@sUM, @sEstado2=@sEstado, @sEstado2=@sEstado, @nDebe201=@nDebe01, @nHaber201=@nHaber01, @nDebe202=@nDebe02, @nHaber202=@nHaber02
   SELECT @nDebe01Suma=@nDebe01Suma+@nDebe01, @nHaber01Suma=@nHaber01Suma+@nHaber01, @nDebe02Suma=@nDebe02Suma+@nDebe02, @nHaber02Suma=@nHaber02Suma+@nHaber02
   IF @sNroDocIni is null
    SELECT @sNroDocIni=@sNroDoc, @sAsientoIni=@sAsiento
 FETCH NEXT FROM sql2 INTO @sSede, @sAsiento, @dtFecha, @sCuenta, @sCentroCosto, @sActividad, @sTipoAnalitica, @sAnalitica, @sTipoDoc, @sSerieDoc, @sNroDoc, @nTipoCambio, @sGlosa, @sUC, @sUM, @sEstado, @nDebe01, @nHaber01, @nDebe02, @nHaber02
END
CLOSE sql2
DEALLOCATE sql2
IF @sNroDocIni!=@sNroDoc2
 SELECT @sCentroCosto2=null, @sActividad2=null, @nTipoCambio2=abs(case when (@nDebe02Suma-@nHaber02Suma)!=0 then (@nDebe01Suma-@nHaber01Suma)/(@nDebe02Suma-@nHaber02Suma) else 0 end), @sGlosa2=''***** CONSOLIDADO *****'', @sUC2=null, @sUM2=null
IF @sEstado2=''02''
 SELECT @sGlosa2=''***** ANULADO *****''
INSERT INTO '+@sTabla+'(cia, sede, id_asiento_min, id_asiento_max, fecha_contable, id_libro, id_cuenta, id_centro_costo, id_actividad, id_tipo_analitica, id_analitica, id_tipo_doc, serie_doc, nro_doc_min, nro_doc_max, tipo_cambio, glosa, uc, um, id_estado, debe_01, haber_01, debe_02, haber_02)
VALUES('''+@sCia+''', @sSede2, @sAsientoIni, @sAsiento2, @dtFecha2, '''+@sLibro+''', @sCuenta2, @sCentroCosto2, @sActividad2, @sTipoAnalitica2, @sAnalitica2, @sTipoDoc2, @sSerieDoc2, @sNroDocIni, @sNroDoc2, @nTipoCambio2, @sGlosa2, @sUC2, @sUM2, @sEstado2, @nDebe01Suma, @nHaber01Suma, @nDebe02Suma, @nHaber02Suma)
')
  END ----------------------------------------------------------------------------------------------------
 ----------------------------------------------------------------------------------------------------
 ----------------------------------------------------------------------------------------------------
 IF @sAgrupadoPor='05' --ANALITICA
  BEGIN
   SELECT @sSelect='a.cia, a.sede, min(a.id_asiento), max(a.id_asiento), null, l.id_libro,
    ad.id_cuenta, null, null,
    ad.id_tipo_analitica, ad.id_analitica,
    null, null, null, null, null, null,
    null, null, ''01'',
    sum(convert(decimal(19,2),case when a.id_estado=''01'' and ad.id_estado=''01'' then ad.debe_01 else 0 end)),
    sum(convert(decimal(19,2),case when a.id_estado=''01'' and ad.id_estado=''01'' then ad.haber_01 else 0 end)),
    sum(convert(decimal(19,2),case when a.id_estado=''01'' and ad.id_estado=''01'' then ad.debe_'+@sMoneda+' else 0 end)),
    sum(convert(decimal(19,2),case when a.id_estado=''01'' and ad.id_estado=''01'' then ad.haber_'+@sMoneda+' else 0 end))'
   SELECT @sGroupBy='GROUP BY a.cia, a.sede, l.id_libro, ad.id_cuenta, ad.id_tipo_analitica, ad.id_analitica'
  END
 IF @sAgrupadoPor='06' --DOCUMENTO
  BEGIN
   SELECT @sSelect='a.cia, a.sede, min(a.id_asiento), max(a.id_asiento), null, l.id_libro,
    ad.id_cuenta, null, null,
    null, null,
    ad.id_tipo_doc, ad.serie_doc, min(ad.nro_doc), max(ad.nro_doc), null, null,
    null, null, ''01'',
    sum(convert(decimal(19,2),case when a.id_estado=''01'' and ad.id_estado=''01'' then ad.debe_01 else 0 end)),
    sum(convert(decimal(19,2),case when a.id_estado=''01'' and ad.id_estado=''01'' then ad.haber_01 else 0 end)),
    sum(convert(decimal(19,2),case when a.id_estado=''01'' and ad.id_estado=''01'' then ad.debe_'+@sMoneda+' else 0 end)),
    sum(convert(decimal(19,2),case when a.id_estado=''01'' and ad.id_estado=''01'' then ad.haber_'+@sMoneda+' else 0 end))'
   SELECT @sGroupBy='GROUP BY a.cia, a.sede, l.id_libro, ad.id_cuenta, ad.id_tipo_doc, ad.serie_doc'
  END
 IF @sAgrupadoPor='07' --DOCUMENTO X INTERVALO
 ----------------------------------------------------------------------------------------------------
 ----------------------------------------------------------------------------------------------------
  BEGIN ----------------------------------------------------------------------------------------------------
-- SE QUITO ESTE QUERY  and ad.item=(case when a.id_estado=''01'' then ad.item else 1 end)
EXEC('
DECLARE @sSede char(2), @dtFecha datetime, @sCuenta varchar(20), @sTipoDoc char(2), @sSerieDoc char(4), @sNroDoc varchar(20), @sTipoAnalitica char(2), @sAnalitica varchar(20), @sEstado char(2), @sAsiento varchar(20), @sCentroCosto varchar(20), @sActividad varchar(20), @nTipoCambio decimal(19,6), @sGlosa varchar(100), @sUC varchar(10), @sUM varchar(10), @nDebe01 decimal(19,2), @nHaber01 decimal(19,2), @nDebe02 decimal(19,2), @nHaber02 decimal(19,2)
DECLARE @sSede2 char(2), @dtFecha2 datetime, @sCuenta2 varchar(20), @sTipoDoc2 char(2), @sSerieDoc2 char(4), @sNroDoc2 varchar(20), @sTipoAnalitica2 char(2), @sAnalitica2 varchar(20), @sEstado2 char(2), @sAsiento2 varchar(20), @sCentroCosto2 varchar(20), @sActividad2 varchar(20), @nTipoCambio2 decimal(19,6), @sGlosa2 varchar(100), @sUC2 varchar(10), @sUM2 varchar(10), @nDebe201 decimal(19,2), @nHaber201 decimal(19,2), @nDebe202 decimal(19,2), @nHaber202 decimal(19,2)
DECLARE @sNroDocIni varchar(20), @sAsientoIni varchar(20), @nDebe01Suma decimal(19,2), @nHaber01Suma decimal(19,2), @nDebe02Suma decimal(19,2), @nHaber02Suma decimal(19,2)
DECLARE sql2 CURSOR FOR
 SELECT a.sede, a.id_asiento, a.fecha_contable, ad.id_cuenta, ad.id_centro_costo, ad.id_actividad, ad.id_tipo_analitica, ad.id_analitica, ad.id_tipo_doc, ad.serie_doc, ad.nro_doc, ad.tipo_cambio, ad.glosa, a.uc, a.um, a.id_estado,
  (convert(decimal(19,2),case when a.id_estado=''01'' and ad.id_estado=''01'' then ad.debe_01 else 0 end)) as ''debe_01'',
  (convert(decimal(19,2),case when a.id_estado=''01'' and ad.id_estado=''01'' then ad.haber_01 else 0 end)) as ''haber_01'',
  (convert(decimal(19,2),case when a.id_estado=''01'' and ad.id_estado=''01'' then ad.debe_'+@sMoneda+' else 0 end)) as ''debe_02'',
  (convert(decimal(19,2),case when a.id_estado=''01'' and ad.id_estado=''01'' then ad.haber_'+@sMoneda+' else 0 end)) as ''haber_02''
 FROM asiento a
 INNER JOIN asiento_detalle ad ON ad.cia=a.cia and ad.sede=a.sede and ad.id_asiento=a.id_asiento
  and ad.item=(case when a.id_estado=''01'' then ad.item else 1 end)
 INNER JOIN libro_auxiliar l ON l.cia=a.cia  and l.id_libro=a.id_libro and isnull(l.id_agrupado_por,''00'')='''+@sAgrupadoPor+'''
 WHERE a.cia='''+@sCia+''' and a.id_libro='''+@sLibro+'''
 '+@sFiltro+'
 ORDER BY a.sede, a.fecha_contable, ad.id_cuenta, ad.id_tipo_doc, ad.serie_doc, ad.nro_doc
OPEN sql2
FETCH NEXT FROM sql2 INTO @sSede, @sAsiento, @dtFecha, @sCuenta, @sCentroCosto, @sActividad, @sTipoAnalitica, @sAnalitica, @sTipoDoc, @sSerieDoc, @sNroDoc, @nTipoCambio, @sGlosa, @sUC, @sUM, @sEstado, @nDebe01, @nHaber01, @nDebe02, @nHaber02
SELECT @sNroDocIni=null, @nDebe01Suma=0, @nHaber01Suma=0, @nDebe02Suma=0, @nHaber02Suma=0
WHILE @@FETCH_STATUS = 0
BEGIN
 IF (not @sNroDocIni is null) and (@sSede2!=@sSede or @dtFecha2!=@dtFecha or @sCuenta2!=@sCuenta or @sTipoDoc2!=@sTipoDoc or @sSerieDoc2!=@sSerieDoc or @sEstado2!=@sEstado or @sEstado=''02'')
  BEGIN
   IF @sNroDocIni!=@sNroDoc2
    SELECT @sCentroCosto2=null, @sActividad2=null, @sTipoAnalitica2=null, @sAnalitica2=null, @nTipoCambio2=abs(case when (@nDebe02Suma-@nHaber02Suma)!=0 then (@nDebe01Suma-@nHaber01Suma)/(@nDebe02Suma-@nHaber02Suma) else 0 end), @sGlosa2=''***** CONSOLIDADO *****'', @sUC2=null, @sUM2=null
   IF @sEstado2=''02''
    SELECT @sGlosa2=''***** ANULADO *****''
   INSERT INTO '+@sTabla+'(cia, sede, id_asiento_min, id_asiento_max, fecha_contable, id_libro, id_cuenta, id_centro_costo, id_actividad, id_tipo_analitica, id_analitica, id_tipo_doc, serie_doc, nro_doc_min, nro_doc_max, tipo_cambio, glosa, uc, um, id_estado, debe_01, haber_01, debe_02, haber_02)
   VALUES('''+@sCia+''', @sSede2, @sAsientoIni, @sAsiento2, @dtFecha2, '''+@sLibro+''', @sCuenta2, @sCentroCosto2, @sActividad2, @sTipoAnalitica2, @sAnalitica2, @sTipoDoc2, @sSerieDoc2, @sNroDocIni, @sNroDoc2, @nTipoCambio2, @sGlosa2, @sUC2, @sUM2, @sEstado2, @nDebe01Suma, @nHaber01Suma, @nDebe02Suma, @nHaber02Suma)
   SELECT @sNroDocIni=@sNroDoc, @sAsientoIni=@sAsiento, @nDebe01Suma=0, @nHaber01Suma=0, @nDebe02Suma=0, @nHaber02Suma=0
 END
   SELECT @sSede2=@sSede, @sAsiento2=@sAsiento, @dtFecha2=@dtFecha, @sCuenta2=@sCuenta, @sCentroCosto2=@sCentroCosto, @sActividad2=@sActividad, @sTipoAnalitica2=@sTipoAnalitica, @sAnalitica2=@sAnalitica, @sTipoDoc2=@sTipoDoc, @sSerieDoc2=@sSerieDoc, @sNroDoc2=@sNroDoc, @nTipoCambio2=@nTipoCambio, @sGlosa2=@sGlosa, @sUC2=@sUC, @sUM2=@sUM, @sEstado2=@sEstado, @sEstado2=@sEstado, @nDebe201=@nDebe01, @nHaber201=@nHaber01, @nDebe202=@nDebe02, @nHaber202=@nHaber02
   SELECT @nDebe01Suma=@nDebe01Suma+@nDebe01, @nHaber01Suma=@nHaber01Suma+@nHaber01, @nDebe02Suma=@nDebe02Suma+@nDebe02, @nHaber02Suma=@nHaber02Suma+@nHaber02
   IF @sNroDocIni is null
    SELECT @sNroDocIni=@sNroDoc, @sAsientoIni=@sAsiento
 FETCH NEXT FROM sql2 INTO @sSede, @sAsiento, @dtFecha, @sCuenta, @sCentroCosto, @sActividad, @sTipoAnalitica, @sAnalitica, @sTipoDoc, @sSerieDoc, @sNroDoc, @nTipoCambio, @sGlosa, @sUC, @sUM, @sEstado, @nDebe01, @nHaber01, @nDebe02, @nHaber02
END
CLOSE sql2
DEALLOCATE sql2
IF @sNroDocIni!=@sNroDoc2
 SELECT @sCentroCosto2=null, @sActividad2=null, @sTipoAnalitica2=null, @sAnalitica2=null, @nTipoCambio2=abs(case when (@nDebe02Suma-@nHaber02Suma)!=0 then (@nDebe01Suma-@nHaber01Suma)/(@nDebe02Suma-@nHaber02Suma) else 0 end), @sGlosa2=''***** CONSOLIDADO *****'', @sUC2=null, @sUM2=null
IF @sEstado2=''02''
 SELECT @sGlosa2=''***** ANULADO *****''
INSERT INTO '+@sTabla+'(cia, sede, id_asiento_min, id_asiento_max, fecha_contable, id_libro, id_cuenta, id_centro_costo, id_actividad, id_tipo_analitica, id_analitica, id_tipo_doc, serie_doc, nro_doc_min, nro_doc_max, tipo_cambio, glosa, uc, um, id_estado, debe_01, haber_01, debe_02, haber_02)
VALUES('''+@sCia+''', @sSede2, @sAsientoIni, @sAsiento2, @dtFecha2, '''+@sLibro+''', @sCuenta2, @sCentroCosto2, @sActividad2, @sTipoAnalitica2, @sAnalitica2, @sTipoDoc2, @sSerieDoc2, @sNroDocIni, @sNroDoc2, @nTipoCambio2, @sGlosa2, @sUC2, @sUM2, @sEstado2, @nDebe01Suma, @nHaber01Suma, @nDebe02Suma, @nHaber02Suma)
')
  END ----------------------------------------------------------------------------------------------------
 ----------------------------------------------------------------------------------------------------
 ----------------------------------------------------------------------------------------------------

 IF @sAgrupadoPor='16' --FECHA - ASIENTO - GLOSA
  BEGIN
   SELECT @sSelect='a.cia, a.sede, a.id_asiento, a.id_asiento, a.fecha_contable, l.id_libro,
    ad.id_cuenta, null, null,
    null, null,
    null, null, null, null, null, ad.glosa,
    null, null, ''01'',
    sum(convert(decimal(19,2),case when a.id_estado=''01'' and ad.id_estado=''01'' then ad.debe_01 else 0 end)),
    sum(convert(decimal(19,2),case when a.id_estado=''01'' and ad.id_estado=''01'' then ad.haber_01 else 0 end)),
    sum(convert(decimal(19,2),case when a.id_estado=''01'' and ad.id_estado=''01'' then ad.debe_'+@sMoneda+' else 0 end)),
    sum(convert(decimal(19,2),case when a.id_estado=''01'' and ad.id_estado=''01'' then ad.haber_'+@sMoneda+' else 0 end))'
   SELECT @sGroupBy='GROUP BY a.cia, a.sede, a.id_asiento, a.fecha_contable, l.id_libro, ad.id_cuenta, ad.glosa '
  END

 IF len(@sSelect)>0 and @sAgrupadoPor!='04' and @sAgrupadoPor!='07'-- and @sAgrupadoPor!='01'
  BEGIN
-- SE QUITO ESTE QUERY  and ad.item=(case when a.id_estado=''01'' then ad.item else 1 end)
--   PRINT @sLibro + ' - ' + @sFiltro
   EXEC ('INSERT INTO '+@sTabla+'
          SELECT '+@sSelect+'
          FROM asiento a
          INNER JOIN asiento_detalle ad ON ad.cia=a.cia and ad.sede=a.sede and ad.id_asiento=a.id_asiento
           and ad.item=(case when a.id_estado=''01'' then ad.item else 1 end)
          INNER JOIN libro_auxiliar l ON l.cia=a.cia  and l.id_libro=a.id_libro and isnull(l.id_agrupado_por,''00'')='''+@sAgrupadoPor+'''
          WHERE a.cia='''+@sCia+''' and a.id_libro='''+@sLibro+'''
          '+@sFiltro+'
          '+@sGroupBy)
--           and (convert(decimal(19,2),ad.debe_'+@sMoneda+')+convert(decimal(19,2),ad.haber_'+@sMoneda+'))!=0
  END

 IF @sAgrupadoPor in ('01','02','03','04')
  BEGIN

   EXEC ('UPDATE a SET a.id_asiento_min=x.id_asiento_min, a.id_asiento_max=x.id_asiento_max
          FROM '+@sTabla+' a
          INNER JOIN
          (SELECT cia, sede, min(id_asiento_min) as ''id_asiento_min'', max(id_asiento_max) as ''id_asiento_max'', fecha_contable, id_libro
           FROM '+@sTabla+'
           WHERE cia='''+@sCia+''' and id_libro='''+@sLibro+'''
           GROUP BY cia, sede, fecha_contable, id_libro
          ) x ON x.cia=a.cia and x.sede=a.sede and x.id_libro=a.id_libro and x.fecha_contable=a.fecha_contable')

  END

 EXEC ('DELETE ad
        FROM '+@sTabla+' ad
        WHERE ad.cia='''+@sCia+''' and ad.id_libro='''+@sLibro+'''
         and ((convert(decimal(19,2),ad.debe_01)+convert(decimal(19,2),ad.haber_01))=0
         or (convert(decimal(19,2),ad.debe_'+@sMoneda+')+convert(decimal(19,2),ad.haber_'+@sMoneda+'))=0)')

 FETCH NEXT FROM sql1 INTO @sLibro, @sAgrupadoPor
END

CLOSE sql1
DEALLOCATE sql1

SET NOCOUNT OFF

GO
/****** Object:  StoredProcedure [dbo].[A_PROCEDIMIENTOS]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
sp_helptext		SP_OCURRENCIA_MANTENIMIENTO
sp_helpdb		NET
sp_helpuser
sp_helptrigger
sp_helpindex	SP_OCURRENCIA_MANTENIMIENTO
sp_help_job
sp_helprotect

	select * from master..sysdatabases 
	select * from dbo.sysobjects 
	select name  from dbo.sysobjects where xtype = 'P' and name like 'sp%'

	select * from information_schema.tables 
	select * from information_schema.columns order by table_name	
--	A_PROCEDIMIENTOS 1,'SP_'
--	A_PROCEDIMIENTOS 2,'SP_'
--	A_PROCEDIMIENTOS 3,'filtro'
--	A_PROCEDIMIENTOS 5,'A'
--	A_PROCEDIMIENTOS 6,'mp_DataAsiento'
*/
CREATE proc [dbo].[A_PROCEDIMIENTOS]
@INDICADOR INT,@DESC VARCHAR(max)
AS
DECLARE @sSelect varchar(MAX),@sFiltroID varchar(MAX), @sFiltroEstado varchar(MAX),
 @sOrderBy varchar(MAX), @sGroupBy varchar(MAX), @sExecute varchar(MAX), @SPs Nvarchar(max)
 SET @SPs = ''
----------------------------------------------------------------------------------------------------------------------
SELECT @sSelect='',  @sFiltroID='', @sFiltroEstado ='',@sOrderBy='',@sGroupBy='',@sExecute=''
-----------------------------------------------------------------------------------------------------------------	
IF(@INDICADOR =1)		--			LISTAR TODOS LOS PROCEDIMIENTOS ALMACENADOS FILA X FILA
BEGIN
	select name  from dbo.sysobjects where xtype = 'P' and name like '%'+@DESC+'%'
	--SELECT @sSelect=' name  from dbo.sysobjects where xtype = ''P'' and name like ''%'' +'''+@DEC+''' +''%'' '					
	--SELECT @sExecute = @sSelect  +''+  @sGroupBy +''+@sOrderBy
	--	PRINT @sExecute
	--EXEC ('SELECT '+ @sExecute )

END
----------------------------------------------------------------------------------------------------------------------------------
IF(@INDICADOR =2)			--		LISTAR TODOS LOS PROCEDIMIENTOS ALMACENADOS EN UNA FILA
BEGIN
	 SELECT @SPs = @SPs + name + ',' FROM sys.objects  WHERE type = 'P' AND name LIKE  @DESC+'%' 
	 SELECT @SPs
END
----------------------------------------------------------------------------------------------------------------------------------
IF(@INDICADOR =3)			--		ELIMINAR  TODOS LOS PROCEDIMIENTOS ALMACENADOS 
BEGIN
	SELECT @SPs = @SPs + [name] + ',' FROM sys.objects  WHERE type = 'P' AND name LIKE @DESC+'%'  
	SELECT @SPs 
	set @SPs=SUBSTRING(@SPs, 1, LEN(@SPs) - 1)
	exec ('drop proc ' + @SPs )
END
----------------------------------------------------------------------------------------------------------------------------------
IF(@INDICADOR =4) 			--		ELIMINAR  TODOS LAS TABLAS CON UN FILTRADO 
BEGIN
	select  @SPs = @SPs + table_name + ','  from information_schema.tables WHERE table_name  LIKE @DESC+'%'  ORDER BY table_name  
	SELECT @SPs 
	set @SPs=SUBSTRING(@SPs, 1, LEN(@SPs) - 1)
	exec ('drop table ' + @SPs )
END
----------------------------------------------------------------------------------------------------------------------------------
IF(@INDICADOR =5)  		--		LISTAR  TODOS LAS TABLAS CON UN FILTRADO 
BEGIN
	select  @SPs = @SPs + table_name + ','  from information_schema.tables WHERE table_name  LIKE @DESC+'%'  ORDER BY table_name 
	set @SPs=SUBSTRING(@SPs, 1, LEN(@SPs) - 1)
	PRINT @SPs 
END
----------------------------------------------------------------------------------------------------------------------------------
IF(@INDICADOR =6)  		--		ACTUALIZA EL NOMBRE  DE TODOS LOS PROC ALMACENADOS 
BEGIN
	SELECT @SPs = @SPs + [name] + ',' FROM sys.objects  WHERE type = 'P' AND name LIKE @DESC+'%'  
	SELECT @SPs 
	set @SPs=UPPER(SUBSTRING(@SPs, 1, LEN(@SPs) - 1))
	PRINT @SPs
	exec ('SELECT proc ' + @SPs )
END
GO
/****** Object:  StoredProcedure [dbo].[A_PROCEDURE]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--select 'drop procedure_' + name from sysobjects where type = 'P' 

/*
[ANRKO_PROCEDURE] 1,'A'
*/
CREATE PROC [dbo].[A_PROCEDURE]
@IND  INT,
@NAME VARCHAR(MAX)
AS
IF(@IND=1)
begin
select  UPPER(name) AS '[ NAME ]' from sysobjects where type = 'P' 
AND NAME LIKE @NAME+'%'
END
IF(@IND=2)
begin
EXEC('drop procedure '+ @NAME+ ' from sysobjects where type = "P" ')
--AND NAME LIKE @NAME+'%'
END
--IF(@IND=3)
--begin
-- UPDATE procedure @NAME+'%' from sysobjects where type = 'P' 
----AND NAME LIKE @NAME+'%'
--END
GO
/****** Object:  StoredProcedure [dbo].[A_SETEAR]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
A_SETEAR	'2'	
A_SETEAR	'3'	
A_SETEAR	'1'
*/
CREATE PROC [dbo].[A_SETEAR]
@INDICADOR CHAR(1)
AS
-------------------------------------------------------------------------------------------------------------
IF(@INDICADOR='1')
BEGIN
		DELETE DOC_GESTION_FA WHERE ID_TIPO_DOC IN ('21')  AND SERIE_DOC='2010' AND NRO_DOC > 00000229 
		DELETE DOC_GESTION_FA_DETALLE WHERE ID_TIPO_DOC IN('21') AND SERIE_DOC='2010' AND NRO_DOC > 00000229
		update TIPO_DOCUMENTO_SERIE set correlativo='229' where ID_TIPO_DOC IN ('21') AND SERIE='2010' 
		delete FROM OCURRENCIA WHERE ID_OCURRENCIA >291
		DELETE DOC_GESTION_FA WHERE ID_TIPO_DOC IN ('26') AND SERIE_DOC='0001' AND NRO_DOC > 00000000 
		DELETE DOC_GESTION_FA_DETALLE WHERE ID_TIPO_DOC IN('26') AND SERIE_DOC='0001' AND NRO_DOC > 00000000 
		update TIPO_DOCUMENTO_SERIE set correlativo='0' where ID_TIPO_DOC IN ('26') 
		DELETE FROM CRONOGRAMA_OPER_PEDIDO --WHERE ID_TIPO_DOC IN ('86') AND SERIE_DOC='0000' AND NRO_DOC = 00000008 
		DELETE FROM CRONOGRAMA_OPER  WHERE ID_TIPO_DOC IN ('86') AND SERIE_DOC='0000' AND NRO_DOC > 00000007 
		DELETE FROM CRONOGRAMA_OPER_DETALLE  WHERE ID_TIPO_DOC IN ('86') AND SERIE_DOC='0000' AND NRO_DOC > 00000007 
		DELETE FROM SERVICIO_TECNICo   WHERE ID_TIPO_DOC IN ('28') AND SERIE_DOC='0001' AND NRO_DOC > 00088887
		DELETE FROM SERVICIO_TECNICo_DETALLE   WHERE ID_TIPO_DOC IN ('28') AND SERIE_DOC='0001' AND NRO_DOC > 00088887
END
-------------------------------------------------------------------------------------------------------------
IF(@INDICADOR='2')
BEGIN
		SELECT COUNT(ID_OCURRENCIA) FROM OCURRENCIA	
		SELECT id_estado 'DOC_GESTION_FA_21',*  FROM  DOC_GESTION_FA	WHERE ID_TIPO_DOC='21' AND SERIE_DOC='2010' AND NRO_DOC > 00000229 	
		SELECT id_estado 'DOC_GESTION_FA_26',*  FROM  DOC_GESTION_FA	WHERE ID_TIPO_DOC='26'		
		SELECT id_estado 'OCURRENCIA',* FROM OCURRENCIA	WHERE ID_OCURRENCIA >291		
		SELECT correlativo,* FROM TIPO_DOCUMENTO_SERIE	WHERE ID_TIPO_DOC IN ('21') AND FECHA_VENCE=(SELECT MAX(FECHA_VENCE) FROM TIPO_DOCUMENTO_SERIE WHERE ID_TIPO_DOC IN ('21'))		
		SELECT correlativo,* FROM TIPO_DOCUMENTO_SERIE	WHERE ID_TIPO_DOC IN ('26')
END
IF(@INDICADOR='3')
BEGIN
	SELECT ID_ESTADO 'CRO',FLAG_ST,* FROM CRONOGRAMA_OPER WHERE ID_TIPO_DOC IN ('86') AND SERIE_DOC='0000' AND NRO_DOC > 00000007 
	SELECT ID_ESTADO 'ST',* FROM SERVICIO_TECNICo  WHERE ID_TIPO_DOC IN ('28') AND SERIE_DOC='0001' AND NRO_DOC > 00088887
	SELECT ID_ESTADO 'CRO_D',* FROM CRONOGRAMA_OPER_DETALLE WHERE ID_TIPO_DOC IN ('86') AND SERIE_DOC='0000' AND NRO_DOC > 00000007 	
--	SELECT ID_ESTADO 'ST',* FROM SERVICIO_TECNICo_DETALLE   WHERE ID_TIPO_DOC IN ('28') AND SERIE_DOC='0001' AND NRO_DOC > 00088887
	SELECT ID_ESTADO 'CRO_OP',*  FROM CRONOGRAMA_OPER_PEDIDO
END
IF(@INDICADOR='4')
BEGIN
	
	UPDATE CRONOGRAMA_OPER SET FLAG_ST='0'  WHERE ID_TIPO_DOC IN ('86') AND SERIE_DOC='0000' AND NRO_DOC > 00000007 
	SELECT ID_ESTADO 'CRO_OP',*  FROM CRONOGRAMA_OPER_PEDIDO
	SELECT ID_ESTADO 'ST',* FROM SERVICIO_TECNICo  WHERE ID_TIPO_DOC IN ('28') AND SERIE_DOC='0001' AND NRO_DOC IN('00088888','00088889')
	SELECT ID_ESTADO 'ST',* FROM SERVICIO_TECNICo_DETALLE  WHERE ID_TIPO_DOC IN ('28') AND SERIE_DOC='0001' AND NRO_DOC IN('00088888','00088889')
END
---------------------------------------------------------------------------------------------
--DELETE DOC_GESTION_FA WHERE ID_TIPO_DOC IN ('26')  AND SERIE_DOC='0001' AND NRO_DOC > 00000000 
--DELETE DOC_GESTION_FA_DETALLE WHERE ID_TIPO_DOC IN('26') AND SERIE_DOC='0001' AND NRO_DOC > 00000000
--update TIPO_DOCUMENTO_SERIE set correlativo='0' where ID_TIPO_DOC IN ('26') AND SERIE='0001'
---------------------------------------------------------------------------------------------

--delete cronograma_oper
--delete cronograma_oper_detalle
--delete CRONOGRAMA_OPER_PEDIDO
--delete articulo_temp
--update TIPO_DOCUMENTO_SERIE set correlativo='230' where ID_TIPO_DOC='21' AND SERIE='2010'
--update TIPO_DOCUMENTO_SERIE set correlativo='0' where ID_TIPO_DOC='28' AND SERIE='0001' AND ID_ESTADO = '01'
--delete SERVICIO_TECNICo where cia='01' and sede='01' and  id_tipo_doc='28' and serie_doc='0001' 
--delete SERVICIO_TECNICo_detalle where cia='01' and sede='01' and  id_tipo_doc='28' and serie_doc='0001'
--update  CRONOGRAMA_OPER SET ID_ESTADO='11',flag_st='0' WHERE cia='01' AND sede='01' 
--update  cronograma_oper_detalle SET ID_ESTADO='01' WHERE cia='01' AND sede='01' 
/*
	SELECT *  FROM  DOC_GESTION_FA	WHERE ID_TIPO_DOC='21' AND nro_doc> 00000134
	SELECT *  FROM  DOC_GESTION_FA	WHERE ID_TIPO_DOC='26'
	SELECT id_estado,* FROM OCURRENCIA	WHERE ID_OCURRENCIA >291
	SELECT ID_ESTADO,* FROM SERVICIO_TECNICo
	SELECT ID_ESTADO,* FROM CRONOGRAMA_OPER
	SELECT  ID_ESTADO,*FROM SERVICIO_TECNICo_detalle
	SELECT   ID_ESTADO,* FROM cronograma_oper_detalle
	SELECT  * FROM CRONOGRAMA_OPER_PEDIDO
	SELECT * FROM articulo_temp where id_articulo='PROACC0000000037'
*/
GO
/****** Object:  StoredProcedure [dbo].[ACTUALIZAR_URL]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
select * from acceso where flag_web='1'
select * from acceso where id_acceso LIKE ('8610%') AND ID_ESTADO ='01'
[ACTUALIZAR_URL] 1, '861010' , 'Sistema/Mantenimientos/Mantenimiento_Isla.aspx'
[ACTUALIZAR_URL] 1, '861030' , 'Sistema/Mantenimientos/Mantenimiento_Cara.aspx'
[ACTUALIZAR_URL] 1, '862020' , 'Sistema/Articulo/webListaArticulo.aspx'
[ACTUALIZAR_URL] 1, '862030' , 'Sistema/Articulo/webListaArticulo.aspx'
[ACTUALIZAR_URL] 1, '861030' , 'Sistema/Mantenimientos/Mantenimiento_Impresora.aspx'
[ACTUALIZAR_URL] 1, '862030' , 'Sistema/Cliente/webListaClientes.aspx'
[ACTUALIZAR_URL] 2, '862020' , 'Articulo'
[ACTUALIZAR_URL] 2, '862030' , 'Clientes'
*/
CREATE PROC [dbo].[ACTUALIZAR_URL]
@VALOR	INT,@id_acceso VARCHAR(250),@nombre_exe VARCHAR(250)
AS
IF(@VALOR=1)
begin
	UPDATE	acceso
	SET		nombre_exe=@nombre_exe	
	WHERE	id_acceso=@id_acceso
END
IF(@VALOR=2)
begin
	UPDATE	acceso
		SET	DESCRIPCION=@nombre_exe	
	WHERE	id_acceso=@id_acceso
END
IF(@VALOR=2)
begin
	UPDATE	acceso
		SET	DESCRIPCION_CORTA=@nombre_exe	
	WHERE	id_acceso=@id_acceso
END


/*
---LEFT---
SELECT LEFT('012345679',3)AS TEXTO

--RIGHT
SELECT RIGHT('012345679',2)AS TEXTO

--SUBSTRING
SELECT SUBSTRING('012345679',7,2)AS TEXTO
*/
GO
/****** Object:  StoredProcedure [dbo].[ANRKO]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[ANRKO]
AS
SELECT	EmployeeID , FirstName , LastName ,reportsTO REGION, BIRTHDATE
   into #employees FROM employees
   /*
**********************************************************************************************************************************
declare @cod INT
DECLARE @ID_ARTICULO VARCHAR(100)
SET @ID_ARTICULO = 'SERCOM'
SET    @cod	=  CONVERT(INT,(SELECT ISNULL ((SELECT max(RIGHT(ID_ARTICULO,10)) FROM ARTICULO WHERE LEFT(ID_ARTICULO,6) =@ID_ARTICULO ),0)))
IF(@cod = 0)
BEGIN		
	SET	@ID_ARTICULO =@ID_ARTICULO + REPLICATE('0', (10 - LEN(@COD))) + CONVERT(VARCHAR(10),(@cod+1)) -- @id_articulo+'0000000001'
END
ELSE
BEGIN
	SET @ID_ARTICULO = @ID_ARTICULO + REPLICATE('0', (10 - LEN(@COD))) +CONVERT(VARCHAR(10),(@cod + 1))
	--PRINT @ID_ARTICULO
END
PROLUB0000000011
SERCOM0000000001
********************************************************************************************************************
DECLARE	@FECHA_ACTUAL	DATETIME
--------------------------------------------
--SET    @ID_CLASIFICA1='PRODUCTOS'
--SET    @ID_CLASIFICA2='FLETE'
SET	   @FECHA_ACTUAL	=	GETDATE()
--SET	   @ID_CLASIFICA1=(SELECT ID_CLASIFICA1 FROM clasificacion1 WHERE ABREVIATURA=LEFT(@ID_CLASIFICA1,3))
--SET	   @ID_CLASIFICA2=(SELECT ID_CLASIFICA2 FROM clasificacion2 WHERE ABREVIATURA=LEFT(@ID_CLASIFICA2,3))
--SELECT @ID_CLASIFICA1
--SELECT @ID_CLASIFICA2
***********************************************************************************************************************
   ----------------------- MIGRAR DATOS ------------------------------------
		INSERT INTO NETDAT.DBO.E_VENTA_DOCUMENTO
(
	CIA, SEDE, ID_VENTA, ID_TIPO_DOC, SERIE_DOC, NRO_DOC, RUC, ID_CLIENTE, FLAG_ANULA, ID_ESTADO, FLAG_ENVIO, LOTE_ENVIO, SE, FE, UE, FC, 
    UC, FM, UM, FA, UA, AA, ID_TIPO_GUIA, SERIE_GUIA, NRO_GUIA, FECHA_GUIA, FECHA_TRASLADO_GUIA, DIR_PARTIDA_GUIA, FLAG_MODIF_DIR_PARTIDA_GUIA, 
	ID_DESTINATARIO, ID_DESTINATARIO_PV, ID_DESTINATARIO_PV_DIRECCION, ID_REMITENTE, ID_REMITENTE_PV, ID_REMITENTE_PV_DIRECCION, 
	ID_TRANSPORTISTA, ID_CONDUCTOR, ID_VEHICULO
)
SELECT	  Prefijo, Numero, SerialImpresora, Recibo, RucCliente, EsAnulado, IdTipoDocumento
FROM  HADICLEAN.dbo.Documento 

INSERT INTO PRUEBA.DBO.deposito
(
	[CIA]      ,[SEDE]      ,[ID_DEPOSITO]      ,[ID_CAJA_BANCO]      ,[ID_MONEDA]      ,[TOTAL_DEPOSITO]
      ,[FECHA_ENVIO]      ,[TIPO_CAMBIO]      ,[ID_TIPO_DOC_CB]      ,[NRO_DOC_CB]      ,[NRO_OPERACION]
      ,[FECHA_DEPOSITO]      ,[ID_ESTADO]      ,[FLAG_ENVIO]      ,[LOTE_ENVIO]      ,[SE]      ,[FE]      ,[UE]
      ,[FC]      ,[UC]      ,[FM]      ,[UM]      ,[FA]      ,[UA]      ,[AA]
)
SELECT	  *
FROM  NEDATA.dbo.deposito 
*/

 
GO
/****** Object:  StoredProcedure [dbo].[ANRKO_#FUNCIONES]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[ANRKO_#FUNCIONES]
as
/*
-- FUNCIONES DE CADENA
-- CONVERT:--------------------------------------------------------------
SELECT * FROM ORDERS
SELECT CONVERT(CHAR(10),ORDERDATE,103) AS Fecha
FROM Orders

SELECT CONVERT(CHAR(10),ORDERDATE,105) AS Fecha
FROM Orders
SELECT CONVERT(CHAR(10),GETDATE(),103) AS FECHA

-- CAST:------------------------------------------------------------------
declare @x as varchar(2)
set @x='10'
SELECT cast(@x as int)+ 5

SELECT '00'+ CAST(ORDERID AS CHAR(5)) AS ORDEN
FROM ORDERS

-- LEFT:------------------------------------------------------------------
SELECT LEFT('0123456789',3) AS TEXTO

-- RIGHT:--------------------------------------------------------------
SELECT RIGHT('0123456789',2) AS TEXTO
-- SUBSTRING:--------------------------------------------------------------
SELECT SUBSTRING('0123456789',7,2) AS TEXTO

-- DATEPART:--------------------------------------------------------------
SELECT DATEPART(DAY,ORDERDATE) as DIA from Orders
SELECT DATEPART(YEAR,ORDERDATE) as AÑO from Orders
SELECT DATEPART(MONTH,ORDERDATE) as MES from Orders
SELECT DATEPART(YEAR,GETDATE()) as AÑO 
-- REVERSE
SELECT REVERSE('ROMA') AS TEXTO
---------------------------------------------------------------------------------



Create Table Personas(
  id_Persona	int	Identity(1,1),
  Nombre	varchar(30)
)

Create Table Cursos(
  id_Curso	int	Identity(1,1),
  Descripcion	varchar(30)
)

Create Table PersonaCurso(
  id_Persona	int	Not NULL,
  id_Curso	int	Not NULL
)

Alter Table Personas
Add Constraint PK_Persona Primary Key(id_Persona)

Alter Table Cursos
Add Constraint PK_Curso Primary Key(id_Curso)

Alter Table PersonaCurso
Add Constraint FK_ConPersona Foreign Key(id_Persona)
 References Personas(id_Persona),
Constraint FK_ConCurso Foreign Key(id_Curso) 
References Cursos(id_Curso)

-- Insertando registros en la tabla Personas
Insert Personas Values('Juan Pérez')
Insert Personas Values('Ana Gutiérrez')
Insert Personas Values('Jorge Risco')

-- Insertando registros en la tabla Cursos
Insert Cursos Values('Visual Basic Fundamentals')
Insert Cursos Values('Visual Basic Programming')
Insert Cursos Values('SQL Server')

-- Insertando registros en la tabla PersonaCurso
Declare @idP	int
Declare @idC	int
Select  @idP= (Select id_Persona From Personas Where Nombre like 'Juan Pérez')
Select 	@idC= (Select id_Curso From Cursos 
Where Descripcion like 'Visual Basic Fundamentals')
Insert PersonaCurso Values(@idP, @idC)



*/
select * from customers
GO
/****** Object:  StoredProcedure [dbo].[ANRKO_Cambio_Clave]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

Create Proc [dbo].[ANRKO_Cambio_Clave]
@cod_cli char(5),@nva_clave varchar(20)
as
update clientes 
    set Clave=dbo.Encriptar_Clave(@nva_clave,'SQL2005')
  where cli_codigo=@cod_cli
GO
/****** Object:  StoredProcedure [dbo].[ANRKO_CREAR_BACKUP]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
--	SP_CREAR_BACKUP_NETDAT 'NETDAT','NETDAT','F:\PUBLICO\DESARROLLONET\BACKUP_NETDAT'
--	NETDAT_230610_12_35_AM.BAK
*/
CREATE PROC [dbo].[ANRKO_CREAR_BACKUP]
AS
DECLARE	@BD VARCHAR(MAX),@RUTA_ARCHIVO	VARCHAR(MAX),@ARCBACKUP	NVARCHAR(MAX),@FECHA VARCHAR(MAX)
-----------------------------------------------
SET @BD	=	'NORTHWIND'
SET @RUTA_ARCHIVO	=	'F:\PUBLICO\DESARROLLONET'
SET @FECHA			=	CONVERT(VARCHAR(10),GETDATE(),105)
------------------------------------------------------------
SET @ARCBACKUP = @RUTA_ARCHIVO + N'\' + @BD + '_' + @FECHA + N'.BAK'
		BACKUP	 DATABASE	  @BD 
		TO			 DISK	= @ARCBACKUP
		WITH	NOFORMAT, 
		INIT,		 NAME	= @BD	
PRINT @ARCBACKUP
--		F:\PUBLICO\DESARROLLONET\NORTHWIND_11-08-2010.BAK
GO
/****** Object:  StoredProcedure [dbo].[ANRKO_CURSOR]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
ANRKO_CURSOR '1'
*/
CREATE PROC [dbo].[ANRKO_CURSOR]
@INDICADOR CHAR(1)
AS
-----------------------------------------------------------------------
IF(@INDICADOR='1')	BEGIN
	--	1.
	DECLARE @ProductID INT,@Name NVARCHAR(25)
	--	2.
	DECLARE products CURSOR FAST_FORWARD FOR
		SELECT productId,ProductName from dbo.Products
	--	3.
	OPEN products
	--	4.
	FETCH NEXT FROM Products INTO @ProductID,@Name
	--	5.
	WHILE @@FETCH_STATUS =0 BEGIN
		--5.1.							
		PRINT  @ProductID 
		PRINT  @Name
		--5.2.
		FETCH NEXT FROM Products INTO @ProductID,@Name
	END
	--	6.
	CLOSE products
	DEALLOCATE products
END

GO
/****** Object:  StoredProcedure [dbo].[ANRKO_CURSOR_AUTHORS]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROC [dbo].[ANRKO_CURSOR_AUTHORS]
AS
SET QUOTED_IDENTIFIER OFF
--	ABRIR UN CURSOR E IMPRIMIR SU CONTENIDO 
SET NOCOUNT ON 
DECLARE 
	@AU_ID VARCHAR(11),		@AU_FNAME VARCHAR(20), @AU_LNAME VARCHAR(40),
	@MESSAGE VARCHAR(80),	@TITLE VARCHAR(80) 
		PRINT "*******************  UTAH AUTHORS REPORT *******************" 
	DECLARE AUTHORS_CURSOR CURSOR FOR 
		SELECT AU_ID, AU_FNAME, AU_LNAME FROM AUTHORS  WHERE STATE = "UT"  ORDER BY AU_ID 
-----------------------------------------------------------------------
OPEN AUTHORS_CURSOR 
FETCH NEXT FROM AUTHORS_CURSOR 
INTO @AU_ID, @AU_FNAME, @AU_LNAME 
-----------------------------------------------------------------------
WHILE @@FETCH_STATUS = 0 
	BEGIN 
		PRINT " " 
		SELECT @MESSAGE = "-----> BOOKS BY AUTHOR: " + @AU_FNAME + " " + @AU_LNAME + " " +"<-----"
		PRINT @MESSAGE 
		DECLARE TITLES_CURSOR CURSOR FOR 
			SELECT T.TITLE  FROM TITLEAUTHOR TA, TITLES T WHERE TA.TITLE_ID=T.TITLE_ID AND TA.AU_ID=AU_ID 
	-----------------------------------------------------------------------------------------
		OPEN TITLES_CURSOR 
		FETCH NEXT FROM TITLES_CURSOR INTO @TITLE 
			IF @@FETCH_STATUS <> 0 
				PRINT " <<NO BOOKS>>" 
			WHILE @@FETCH_STATUS = 0 
					BEGIN 
						SELECT @MESSAGE = " " + @TITLE 
					PRINT @MESSAGE 
					FETCH NEXT FROM TITLES_CURSOR INTO @TITLE 
					END 
					CLOSE TITLES_CURSOR 
					DEALLOCATE TITLES_CURSOR 
					FETCH NEXT FROM AUTHORS_CURSOR
					INTO @AU_ID, @AU_FNAME, @AU_LNAME 
	END
CLOSE AUTHORS_CURSOR 
DEALLOCATE AUTHORS_CURSOR 
GO
/****** Object:  StoredProcedure [dbo].[ANRKO_CURSOR_AUTHORS_CURSOR]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROC [dbo].[ANRKO_CURSOR_AUTHORS_CURSOR]
AS
Set Quoted_identifier off
--Recorrer un cursor 
DECLARE authors_cursor CURSOR FOR 
SELECT au_lname FROM authors WHERE au_lname LIKE "B%" ORDER BY au_lname 
-------------------------------------------------------------------------------------------
OPEN authors_cursor 
FETCH NEXT FROM authors_cursor 
	WHILE @@FETCH_STATUS = 0 
	BEGIN 
		FETCH NEXT FROM authors_cursor 
	END 
	CLOSE authors_cursor 
	DEALLOCATE authors_cursor 
--Recorrer un cursor guardando los valores en variables 
DECLARE @au_lname varchar(40) 
DECLARE @au_fname varchar(20) 
DECLARE authors_cursor CURSOR FOR 
SELECT au_lname, au_fname FROM authors  WHERE au_lname LIKE "B%" ORDER BY au_lname, au_fname 
-------------------------------------------------------------------------------------------
OPEN authors_cursor 
	FETCH NEXT FROM authors_cursor INTO @au_lname, @au_fname 
	WHILE @@FETCH_STATUS = 0 
BEGIN 
	PRINT "Author: " + @au_fname + " " + @au_lname 
	FETCH NEXT FROM authors_cursor 
	INTO @au_lname, @au_fname 
END 
	CLOSE authors_cursor 
	DEALLOCATE authors_cursor 

GO
/****** Object:  StoredProcedure [dbo].[ANRKO_CURSOR_EMPLOYEES]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[ANRKO_CURSOR_EMPLOYEES]
AS
Set Quoted_identifier off
DECLARE Employee_Cursor CURSOR FOR 
	SELECT LastName, FirstName FROM Northwind.dbo.Employees WHERE LastName like 'B%' 
OPEN Employee_Cursor 
	FETCH NEXT FROM Employee_Cursor 
WHILE @@FETCH_STATUS = 0 
	BEGIN 
		FETCH NEXT FROM Employee_Cursor 
	END 
CLOSE Employee_Cursor 
DEALLOCATE Employee_Cursor 
GO
/****** Object:  StoredProcedure [dbo].[ANRKO_CURSOR_LEER]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[ANRKO_CURSOR_LEER]
AS
/*
En algunos SGDB es posible la abertura de cursores de datos desde
 el propio entorno de trabajo, para ello se utilizan, normalmente 
 procedimientos almacenados. La sintaxis para definir un cursor es la siguiente: 
DECLARE 
nombre-cursor 
FOR 
especificacion-consulta 
[ORDER BY] 
--	Por ejemplo: 
DECLARE 
    Mi_Cursor 
FOR 
   SELECT num_emp, nombre, puesto, salario 
   FROM empleados 
   WHERE num_dept = 'informatica' 

Este comando es meramente declarativo, simplemente especifica las filas y 
columnas que se van a recuperar. La consulta se ejecuta cuando se abre o 
se activa el cursor. La cláusula [ORDER BY] es opcional y especifica una 
ordenación para las filas del cursor; si no se especifica, la ordenación
 de las filas es definida el gestor de SGBD. 
Para abrir o activar un cursor se utiliza el comando OPEN del SQL, la sintaxis en la siguiente: 
OPEN 
nombre-cursor 
[USING lista-variables] 
Al abrir el cursor se evalúa la consulta que aparece en su definición,
utilizando los valores actuales de cualquier parámetro referenciado en la consulta,
 para producir una colección de filas. El puntero se posiciona delante de la primera 
 fila de datos (registro actual), esta sentencia no recupera ninguna fila. 
Una vez abierto el cursos se utiliza la cláusula FETCH para recuperar las filas del cursor,
 la sintaxis es la siguiente: 
FETCH 
nombre-cursor 
INTO 
lista-variables 
Lista - variables son las variables que van a contener los datos recuperados de la fila del cursor,
 en la definición deben ir separadas por comas. En la lista de variables se deben definir tantas
  variables como columnas tenga la fila a recuperar. 
Para cerrar un cursor se utiliza el comando CLOSE, este comando hace desaparecer el puntero sobre 
el registro actual. La sintaxis es: 
CLOSE 
nombre-cursor 
Por último, y para eliminar el cursor se utiliza el comando DROP CURSOR. Su sintaxis es la siguiente: 
DROP CURSOR 
nombre-cursor 
Ejemplo (sobre SQL-SERVER): 
Abrir un cursor y recorrelo 
*/
SELECT * FROM EMPLOYEES
GO
/****** Object:  StoredProcedure [dbo].[ANRKO_DECIMALES_LISTAR]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[ANRKO_DECIMALES_LISTAR]
as
select * from decimales
GO
/****** Object:  StoredProcedure [dbo].[ANRKO_FUNCIONES]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
ANRKO_FUNCIONES '1'
*/
CREATE PROC [dbo].[ANRKO_FUNCIONES]
@INDICADOR CHAR(1)
AS
-----------------------------------------------------------------------
IF(@INDICADOR='1')	BEGIN
	SELECT OrderDate,DATEADD(YEAR,1,orderdate)'OneMoreYear',
	DATEADD(MONTH,1,orderdate)'OneMoreMonth' ,
	DATEADD(DAY,-1,orderdate)'OneLessday'	FROM dbo.Orders
--	SELECT dateadd(MONTH,1,'1/29/2009')
END
-----------------------------------------------------------------------
IF(@INDICADOR='2')	BEGIN
	SELECT orderdate,GETDATE() 'CurrenDateTime',
	DATEDIFF(year,orderdate,GETDATE())'YearDiff',
	DATEDIFF(month,orderdate,GETDATE())'MonthDiff',
	DATEDIFF(day,orderdate,GETDATE())'DayDiff'	FROM dbo.Orders
END
-----------------------------------------------------------------------
--		SELECT DATEDIFF(year,'12/31/2008','1/01/2009')'YearDiff',
--		DATEDIFF(month,'12/31/2008','1/01/2009')'MonthDiff',
--		DATEDIFF(day,'12/31/2008','1/01/2009')'DayDiff'	FROM dbo.Orders
-----------------------------------------------------------------------
IF(@INDICADOR='3')	BEGIN
	SELECT orderdate,DATEPART(YEAR,Orderdate) 'OrderYear',
	DATEPART(month,orderdate)'OrderMonth',
	DATEPART(day,orderdate)'OrderDay',
	DATEPART(weekday,orderdate)'OrderWeekDay'	FROM dbo.Orders
END
-----------------------------------------------------------------------
IF(@INDICADOR='4')	BEGIN
	SELECT orderdate,DATEPART(YEAR,Orderdate) 'OrderYear',
	datename(month,orderdate) 'OrderMonth',
	datename(day,orderdate) 'OrderDay',
	datename(weekday,orderdate) 'OrderWeekDay'	FROM dbo.Orders
END
-----------------------------------------------------------------------
IF(@INDICADOR='5')	BEGIN
	SELECT orderdate,YEAR(Orderdate) 'OrderYear',
	MONTH(orderdate) 'OrderMonth',
	DAY(orderdate) 'OrderDay'	FROM dbo.Orders
END
-----------------------------------------------------------------------
IF(@INDICADOR='6')	BEGIN
	SELECT CAST(DATEPART(YYYY,GETDATE()) as varchar) +'/'+
	CAST(DATEPART(mm,GETDATE())as varchar) +'/'+
	 CAST(DATEPART(dd,GETDATE())AS varchar) FROM dbo.Orders
END
-----------------------------------------------------------------------
IF(@INDICADOR='7')	BEGIN
	SELECT CONVERT(VARCHAR,GETDATE(),111)	
	SELECT CONVERT(VARCHAR,orderdate,1) '1',
	CONVERT(VARCHAR,orderdate,101) '101',
	CONVERT(VARCHAR,orderdate,2) '2',
	CONVERT(VARCHAR,orderdate,102) '102' FROM dbo.Orders
END
-----------------------------------------------------------------------
IF(@INDICADOR='8')	BEGIN
	SELECT ABS(2)AS '2',ABS(-2) AS '-2'
	SELECT POWER(10,1)AS 'Ten To The First',POWER(10,2) AS 'Ten To The Second',POWER(10,3) AS 'Ten To The Third'
	SELECT SQUARE(10)AS 'Square Of 10', SQRT(10)AS 'Square Root Of 10',SQRT(SQUARE(10)) AS 'The Square Root Of The SQUARE OF 10'
	SELECT ROUND(1234.1294,2)AS '2 Places On The Right',ROUND(1234.1294,-2)AS '2 Places On The Left',
		   ROUND(1234.1294,2,1)AS 'Trunctae 2',ROUND(1234.1294,-2,1)AS 'Truncate -2'
	SELECT CAST(RAND ()*100 AS INT)+ 1 AS '1 To 100',CAST(RAND ()*1000 AS INT)+ 900 AS '90 to 1900',
			CAST(RAND ()*5 AS INT)+ 1 AS '1 To 5'
END
-----------------------------------------------------------------------
IF(@INDICADOR='8')	BEGIN
	SELECT Lastname+ SPACE(2) +FirstName AS 'Name',Title,titleOfCourtesy,
		CASE titleOfCourtesy 
		WHEN 'Mr.'  THEN 'Male'
		WHEN 'Ms.'  THEN 'Female'
		WHEN 'Mrs.'  THEN 'Female'
		WHEN 'Miss'  THEN 'Female'	
		ELSE  'Unknown' END AS Gender	FROM dbo.Employees	
	SELECT titleOfCourtesy,CASE WHEN titleOfCourtesy IN ('Ms.','Mrs.','Miss') THEN 'Female'
		WHEN titleOfCourtesy ='Mr.' THEN 'Male'
		ELSE 'Unknown' END AS Gender	FROM dbo.Employees 		
END
-----------------------------------------------------------------------
IF(@INDICADOR='9')	BEGIN
	SELECT ProductID,Size,Color,COALESCE(Size,Color,'NO Color OR Size')'Description' 
	FROM AdventureWorks.Production.Product
	SELECT DB_NAME() 'Database Name',HOST_NAME() 'Host Name',
		CURRENT_USER 'Current User',USER_NAME() 'User Name',APP_NAME() 'App Name'
END
-----------------------------------------------------------------------
IF(@INDICADOR='10')	BEGIN
	SELECT FirstName FROM dbo.Employees WHERE CHARINDEX('an',FirstName)>0
	SELECT LastName,REVERSE(LastName)'REVERSE' FROM dbo.Employees  ORDER BY REVERSE(LastName)
	SELECT FirstName,LastName,CONVERT(VARCHAR(10),birthDate,103) FROM dbo.Employees ORDER BY YEAR(birthDate)
END
-----------------------------------------------------------------------
IF(@INDICADOR='11')	BEGIN
	SELECT o.OrderID,CONVERT(VARCHAR(10),o.OrderDate,103) 'OrderDate',o.Freight,
	SUM(od.UnitPrice*od.Quantity) 'Cantidad',p.ProductID,p.ProductName FROM dbo.Orders o 	
	 INNER JOIN [Order Details] od ON od.OrderID=o.OrderID
	 INNER JOIN Products p ON p.ProductID=od.ProductID WHERE YEAR(o.OrderDate)='1996' 
	 GROUP BY o.OrderID,o.OrderDate,o.Freight,p.ProductID,p.ProductName 
	-------------------------------------------------------------------
	SELECT o.OrderID,CONVERT(VARCHAR(10),o.OrderDate,103) 'OrderDate',o.Freight,
	SUM(od.UnitPrice*od.Quantity) 'Cantidad',p.ProductID,p.ProductName FROM dbo.Orders o 	
	 LEFT outer JOIN [Order Details] od ON od.OrderID=o.OrderID
	 LEFT outer JOIN  Products p ON p.ProductID=od.ProductID	WHERE YEAR(o.OrderDate)='1996'
	 GROUP BY o.OrderID,o.OrderDate,o.Freight,p.ProductID,p.ProductName 
	-------------------------------------------------------------------
	SELECT o.OrderID,CONVERT(VARCHAR(10),o.OrderDate,103) 'OrderDate',o.Freight,
	SUM(od.UnitPrice*od.Quantity) 'Cantidad',p.ProductID,p.ProductName FROM dbo.Orders o 	
	 RIGHT outer JOIN [Order Details] od ON od.OrderID=o.OrderID
	 RIGHT outer JOIN  Products p ON p.ProductID=od.ProductID	WHERE YEAR(o.OrderDate)='1996'
	 GROUP BY o.OrderID,o.OrderDate,o.Freight,p.ProductID,p.ProductName 
	 	-------------------------------------------------------------------
	SELECT o.OrderID,CONVERT(VARCHAR(10),o.OrderDate,103) 'OrderDate',o.Freight,
	SUM(od.UnitPrice*od.Quantity) 'Cantidad',p.ProductID,p.ProductName FROM dbo.Orders o 	
	 full outer JOIN [Order Details] od ON od.OrderID=o.OrderID
	 full outer JOIN  Products p ON p.ProductID=od.ProductID	WHERE YEAR(o.OrderDate)='1996'
	 GROUP BY o.OrderID,o.OrderDate,o.Freight,p.ProductID,p.ProductName 
	-------------------------------------------------------------------
	SELECT p.ProductID,od.OrderID FROM dbo.Products AS p 
	CROSS JOIN dbo.[Order Details] AS od
	ORDER BY Productid
END
-----------------------------------------------------------------------
IF(@INDICADOR='12')	BEGIN
	--SELECT c.CustomerID,c.CompanyName FROM dbo.Customers c
	--WHERE c.CustomerID IN (SELECT CustomerID FROM Orders)
	--go
	WITH orders AS (SELECT orderid,CustomerID FROM dbo.Orders)
	SELECT c.CustomerID,orders.OrderID FROM dbo.Customers AS c
	INNER JOIN orders ON c.CustomerID=orders.CustomerID
	--go
	--SELECT  c.CustomerID,o.OrderID,o.orderdate FROM dbo.Customers AS c
	--LEFT OUTER JOIN dbo.Orders AS o ON o.CustomerID=c.CustomerID
	--WHERE CONVERT(VARCHAR(10), o.OrderDate,103)='04/07/1996'
	
	--WITH Orderss AS (SELECT  OrderID,CustomerID,orderdate FROM Orders
	--			WHERE CONVERT(VARCHAR(10), OrderDate,103)='04/07/1996'	)
	--SELECT c.CustomerID,Orders.OrderID,Orders.orderdate FROM dbo.Customers AS c
	--LEFT OUTER JOIN dbo.Orders ON c.CustomerID=Orders.CustomerID
	--ORDER BY orders.OrderDate desc
END
-----------------------------------------------------------------------
IF(@INDICADOR='13')	BEGIN
	SELECT COUNt(*) 'CountOfRows',MAX(Quantity) 'MaxTotal' ,min(Quantity) 'MinTotal',
		Sum(Quantity) 'SumOfTotal',AVG(Quantity) 'AvgTotal'	FROM dbo.[Order Details]
		
	SELECT min(ProductName) 'MinName' ,MAX(ProductName) 'MaxName',
		min(UnitPrice) 'MinSellStartDate'	FROM dbo.Products	
END
-----------------------------------------------------------------------
IF(@INDICADOR='14')	BEGIN 
	SELECT CustomerID,SUM(freight)'Total' FROM Orders
	GROUP BY CustomerID HAVING COUNT(*)=10 AND SUM(freight)>10	
END
-----------------------------------------------------------------------
IF(@INDICADOR='15')	BEGIN 
	SELECT OrderID,CustomerID,Freight,
	AVG(Freight) OVER(PARTITION BY OrderID)'AVG',
	SUM(Freight) OVER(PARTITION BY OrderID)'SUM',
	Freight/(SUM(Freight)OVER (PARTITION BY CustomerID))*100 'SalePercent',
	SUM(Freight) OVER() 'SalesoverAll' 	 FROM  dbo.Orders
END
-----------------------------------------------------------------------
IF(@INDICADOR='16')	BEGIN 
	SELECT EmployeeID,FirstName,LastName,title, FirstName+ISNULL(''+title,'') from Employees 
	--INTO #prueba from Employees 
END
-----------------------------------------------------------------------
IF(@INDICADOR='17')	BEGIN 
	--DECLARE @OuterCount INT=1
	--DECLARE @innerCount  INT
	--WHILE @OuterCount < 10 begin
	--	PRINT 'Outer Loop'
	--	SET @innerCount = 1
	--	WHILE @innerCount<5 BEGIN
	--		PRINT '		Inner Loop'
	--		SET @innerCount +=1
	--	END
	--	SET @OuterCount+=1
	--END
	DECLARE @errorNo INT
	PRINT 1/0
	SET @errorNo =@@ERROR
	IF @errorNo>0 BEGIN
		PRINT 'An Error Has Occurred.'
		PRINT @errorNo
	end
	--**********************************
	--DECLARE @errorNo INT
	--DROP TABLE testtable
	--SET @errorNo =@@ERROR
	--**********************************
	DECLARE @errorNoo INT
	IF @errorNoo > 0 BEGIN
		PRINT 'An Error Has Occurred.'
		PRINT @errorNoo
		PRINT @@error
	end
	--**********************************
	--DECLARE @errorNo INT
	--PRINT 'Beginnig Of Code'
	--PRINT 1/0
	--SET @errorNo=@@ERROR
	--IF @errorNo > 0 GOTO ERR_LABEL
	--PRINT 'No Error.'	
	--ERR_LABEL
	--PRINT 'At ERR_LABEL'
END
-----------------------------------------------------------------------
IF(@INDICADOR='17')	BEGIN 
	/*
	ERROR_NUMBER()
	ERROR_SEVERITY()
	ERROR_STATE()
	ERROR_PROCEDURE()
	ERROR_LINE()
	ERROR_MESSAGE()
	*/
	--BEGIN try
	--	PRINT 1/0
	--END try
	/*
	BEGIN CATCH
		PRINT 'Inside The Catch Block'
		PRINT ERROR_NUMBER()
		PRINT ERROR_MESSAGE()
		PRINT ERROR_NUMBER()
	END CATCH
	PRINT 'OutSide The Catch Block'
	PRINT ERROR_NUMBER()
	*/
	/*
	PRINT 'Syntax Error.'
	go
	BEGIN TRY	
		SELECT * FROM dbo.Customers
	END TRY
	BEGIN CATCH
		PRINT ERROR_NUMBER()
	END CATCH
	*/
		SELECT * FROM dbo.Customers
END
GO
/****** Object:  StoredProcedure [dbo].[ANRKO_Ingreso_Sistema]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


Create Proc [dbo].[ANRKO_Ingreso_Sistema]
@Codigo Char(5), @Clave Varchar(20)
As
    Declare @Clave_Desencriptada Varchar(1000)
	Select @Clave_Desencriptada=
		dbo.Desencriptar_Clave(@Codigo)
  	If @Clave_Desencriptada=@Clave
		Select rpta=1
    else
		Select rpta=0
GO
/****** Object:  StoredProcedure [dbo].[ANRKO_INSERTAR_DECIMAL]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
sp_help decimales
select * from decimales
[SP_INSERTAR_DECIMAL] 15.00,0.19
[SP_INSERTAR_DECIMAL] 15,0.19
*/
CREATE Proc [dbo].[ANRKO_INSERTAR_DECIMAL]
 @Precio Decimal(18,2), @IGV Decimal(18,2), @float float
As
Begin
 Insert Into decimales(Precio,IGV,[float])Values(@Precio,@IGV,convert(decimal(18,2),@float))
End
/*
 Dim cmd As New SqlCommand("UspInsertarDecimal", ConectarCon)
      cmd.CommandType = CommandType.StoredProcedure
      Dim Param(1) As SqlParameter

      Param(0) = New SqlParameter("@Precio", SqlDbType.Decimal)
      Param(0).Value = BE.Precio

      Param(1) = New SqlParameter("@IGV", SqlDbType.Decimal)
      Param(1).Value = BE.IGV
*/
GO
/****** Object:  StoredProcedure [dbo].[ANRKO_PROCEDURE]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--select 'drop procedure_' + name from sysobjects where type = 'P' 

/*
[ANRKO_PROCEDURE] 1,'A'
*/
CREATE PROC [dbo].[ANRKO_PROCEDURE]
@IND  INT,
@NAME VARCHAR(MAX)
AS
IF(@IND=1)
begin
select  UPPER(name) AS '[ NAME ]' from sysobjects where type = 'P' 
AND NAME LIKE @NAME+'%'
END
IF(@IND=2)
begin
EXEC('drop procedure '+ @NAME+ ' from sysobjects where type = "P" ')
--AND NAME LIKE @NAME+'%'
END
--IF(@IND=3)
--begin
-- UPDATE procedure @NAME+'%' from sysobjects where type = 'P' 
----AND NAME LIKE @NAME+'%'
--END
GO
/****** Object:  StoredProcedure [dbo].[ANRKO_RecibirParametros]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[ANRKO_RecibirParametros] @Parametros varchar(1000)
--@Parametros es la cadena de entrada
AS
--Creamos una tabla temporal por simplificar el trabajo
--y almacenar los parametros que vayamos obteniendo
CREATE TABLE #parametros (parametro varchar(1000))
SET NOCOUNT ON
--El separador de nuestros parametros sera una ,
DECLARE @Posicion int
--@Posicion es la posicion de cada uno de nuestros separadores
DECLARE @Parametro varchar(1000)
--@Parametro es cada uno de los valores obtenidos
--que almacenaremos en #parametros
SET @Parametros = @Parametros + ','
--Colocamos un separador al final de los parametros
--para que funcione bien nuestro codigo
--Hacemos un bucle que se repite mientras haya separadores
WHILE patindex('%,%' , @Parametros) <> 0
--patindex busca un patron en una cadena y nos devuelve su posicion
BEGIN
  SELECT @Posicion =  patindex('%,%' , @Parametros)
  --Buscamos la posicion de la primera ,
  SELECT @Parametro = left(@Parametros, @Posicion - 1)
  --Y cogemos los caracteres hasta esa posicion
  INSERT INTO #parametros values (@Parametro)
  --y ese parámetro lo guardamos en la tabla temporal
  --Reemplazamos lo procesado con nada con la funcion stuff
  SELECT @Parametros = stuff(@Parametros, 1, @Posicion, '')
END
--Y cuando se han recorrido todos los parametros sacamos por pantalla el resultado
SELECT * FROM #parametros
SET NOCOUNT OFF
GO
/****** Object:  StoredProcedure [dbo].[ANRKO_TRANSACIONES]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
ANRKO_FUNCIONES '1'
*/
CREATE PROC [dbo].[ANRKO_TRANSACIONES]
@INDICADOR CHAR(1)
AS
-----------------------------------------------------------------------
IF(@INDICADOR='1')	BEGIN
	/*
	IF EXISTS(SELECT * FROM SYS.OBJECTS
				WHERE OBJECT_ID=OBJECT_ID(N'[dbo].[demoTransaction]') AND TYPE IN (N'U'))
				DROP TABLE [dbo].[demoTransaction]
	GO
	CREATE TABLE [dbo].[demoTransaction](col1 INT NOT null)
	GO
	
	BEGIN TRAN
		INSERT INTO dbo.demoTransaction(col1)VALUES (1)
		INSERT INTO dbo.demoTransaction(col1)VALUES (2)
	COMMIT TRAN
	BEGIN TRAN
		INSERT INTO dbo.demoTransaction(col1)VALUES (3)
		INSERT INTO dbo.demoTransaction(col1)VALUES ('a')
	COMMIT TRAN
	GO
	BEGIN TRAN
		INSERT INTO dbo.demoTransaction(col1)VALUES (3)
		INSERT INTO dbo.demoTransaction(col1)VALUES ('a')
	ROLLBACK TRAN
	*/
		SELECT * FROM dbo.demoTransaction
END
-----------------------------------------------------------------------
IF(@INDICADOR='2')	BEGIN
	/*
	IF OBJECT_ID('dbo.Demo')IS NOT NULL BEGIN
		DROP TABLE dbo.demo										
	END
	GO
	CREATE TABLE dbo.demo(ID int primary KEY,NAME VARCHAR(25))
	*/
	--	Create Table Work
		/*
	IF EXISTS(SELECT * FROM sys.objects 
		WHERE OBJECT_ID=OBJECT_ID(N'[dbo].[demoPerformance]') AND TYPE IN (N'U'))
		DROP TABLE [dbo].[demoPerformance]
	GO
	CREATE TABLE [dbo].[demoPerformance](
		[SalesOrderID][INT] NOT NULL,
		[SalesOrderDetailID][INT] NOT NULL,
		CONSTRAINT [PK_demoPerformance] PRIMARY KEY CLUSTERED
		(
			[SalesOrderID]ASC,
			[SalesOrderDetailID]ASC
		)WITH(PAD_INDEX = OFF,STATISTICS_NORECOMPUTE = OFF , IGNORE_DUP_KEY=OFF,
			ALLOW_ROW_LOCKS = ON,ALLOW_PAGE_LOCKS = ON ) ON [PRIMARY]
		)ON [PRIMARY]
		go
		PRINT 'Insert All Rows Start'
		PRINT GETDATE()
		GO	
		INSERT INTO dbo.demoPerformance (SalesOrderID,SalesOrderDetailID)
		SELECT OrderID,ProductID FROM dbo.[Order Details]
		PRINT 'Insert All Rows End'
		PRINT GETDATE()
		*/
	SELECT * FROM dbo.demoPerformance
	--TRUNCATE TABLE dbo.demoPerformance

	--	PRINT 'Insert rows One At a Time Begin'
	--	PRINT GETDATE()
		--	Set
END
-----------------------------------------------------------------------
GO
/****** Object:  StoredProcedure [dbo].[CODSP_CodigoGeneradoAlumno]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[CODSP_CodigoGeneradoAlumno]
as
declare @alu_cod char(5)
set @alu_cod=(select max(alu_cod)from alumnos_2)
set @alu_cod='A'+right('0000'+ltrim(right(isnull(@alu_cod,'0000'),4)+1),4)
select @alu_cod
GO
/****** Object:  StoredProcedure [dbo].[CODSP_GeneraCodigoDocente]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  PROC [dbo].[CODSP_GeneraCodigoDocente]
@codigo CHAR(6) OUTPUT
AS
SET @codigo=(SELECT max(codigo) FROM docentes)
SET @codigo='D'+RIGHT ('00000'+ltrim(RIGHT(isnull(@codigo,'00000'),5)+1),5)
GO
/****** Object:  StoredProcedure [dbo].[CODSP_GeneraCodigoEmpleado]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[CODSP_GeneraCodigoEmpleado]
@Emp_cod CHAR(5) OUTPUT
AS
SET @Emp_cod=(SELECT max(Emp_cod) FROM Empleados)
SET @Emp_cod='E'+RIGHT ('0000'+ltrim(RIGHT(isnull(@Emp_cod,'0000'),4)+1),4)
GO
/****** Object:  StoredProcedure [dbo].[CODSP_GeneraCodigoProductos]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[CODSP_GeneraCodigoProductos]
@ProductID CHAR(5) OUTPUT
AS
SET @ProductID=(SELECT max(ProductID)+1 FROM productos)
GO
/****** Object:  StoredProcedure [dbo].[CODSP_GenerarCodigo]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create proc [dbo].[CODSP_GenerarCodigo]
As
Declare @codigo char(6)
Set @codigo=(select max(codigo) from Docentes)
Set @codigo='D'+right('00000'+
				ltrim(right(isnull(@codigo,'00000'),5)+1),5)
Select @codigo
GO
/****** Object:  StoredProcedure [dbo].[CODSP_GenerarCodigoFactura]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[CODSP_GenerarCodigoFactura]
As
Declare @factura char(5)
Set @factura=(Select max(fac_num) from fac_cabe)
Set @factura='F'+right('0000'+ltrim(right(isnull(@factura,'0000'),4)+1),4)
Select @factura
GO
/****** Object:  StoredProcedure [dbo].[FIDESP__BUSCAR_CLIENTE_PREMIO]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*

EXEC SP_BUSCAR_CLIENTE_PREMIO '01', '0000000001', ''

*/
---------------------------------------------------
---------------------------------------------------
CREATE	PROCEDURE	[dbo].[FIDESP__BUSCAR_CLIENTE_PREMIO]
@CIA			char(2),
@NRO_TARJETA	varchar(20),
@ID_CLIENTE		varchar(20)
AS
---------------------------------------------------
DECLARE	@CODIGO varchar(20)
---------------------------------------------------
IF(LEN(@NRO_TARJETA)> 0)
BEGIN
	SET @CODIGO = (SELECT ISNULL ((SELECT id_Cliente FROM F_CLIENTE_TARJETA WHERE cia = @CIA AND nro_tarjeta = @NRO_TARJETA AND id_estado = '01'),''))
END
---------------------------------------------------
BEGIN
	SELECT	ID_ANALITICA, DESCRIPCION, NRO_DOC,
			[PUNTOS] = (SELECT ISNULL((SELECT CONVERT(INT,puntos_acumulados) FROM F_CLIENTE_CAMPANIA WHERE cia = @CIA AND Id_Cliente = CASE WHEN LEN(@NRO_TARJETA) > 0 THEN @CODIGO ELSE @ID_CLIENTE END AND Id_Estado = '01'),0))
	FROM	ANALITICA
	WHERE   CIA				= @CIA 
	AND		ID_ANALITICA	= CASE WHEN LEN(@NRO_TARJETA) > 0 THEN @CODIGO ELSE @ID_CLIENTE END
	AND		ID_ESTADO		= '01'
END
GO
/****** Object:  StoredProcedure [dbo].[FIDESP_ANALITICA_CLIENTE_TRAER_TODOS]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*

EXEC SP_ANALITICA_CLIENTE_TRAER_TODOS '01', '%', '%', '%', '%'

*/
---------------------------------------------------
---------------------------------------------------
CREATE	PROCEDURE	[dbo].[FIDESP_ANALITICA_CLIENTE_TRAER_TODOS]
@CIA				CHAR(2),
@ID_ANALITICA		VARCHAR(20),
@DESCRIPCION		VARCHAR(300),
@FLAG_TIPO_PERSONA	CHAR(1),
@ID_ESTADO			VARCHAR(2)
AS
---------------------------------------------------
---------------------------------------------------
SELECT	ID_ANALITICA,	
		DESCRIPCION AS 'DESCRIPCION', 
		CASE FLAG_TIPO_PERSONA
			WHEN '0' THEN 'JURIDICA'
			ELSE 'NATURAL'
		END AS 'TIPO PERSONA',
		CASE ID_ESTADO
			WHEN '01' THEN 'ACTIVO'
			WHEN '02' THEN 'INACTIVO'
		END AS 'ESTADO'
FROM	ANALITICA
WHERE	CIA				= @CIA
AND		ID_ANALITICA	LIKE '%' +	CASE @ID_ANALITICA
										WHEN '' THEN '%' 
										ELSE @ID_ANALITICA
									END + '%'
AND		DESCRIPCION		LIKE '%' +	CASE @DESCRIPCION
										WHEN '' THEN '%'
										ELSE @DESCRIPCION
									END + '%'
AND		FLAG_TIPO_PERSONA LIKE '%' + @FLAG_TIPO_PERSONA + '%'
AND		ID_ESTADO LIKE '%' + @ID_ESTADO + '%'
GO
/****** Object:  StoredProcedure [dbo].[FIDESP_buscar_tarjeta_cliente]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[FIDESP_buscar_tarjeta_cliente]
@cia char(2),@filtro varchar(500)
AS
EXEC('
SELECT a.id_analitica ''CODIGO'',a.nro_doc ''DOCUMENTO'',a.descripcion ''DESCRIPCION'',ct.nro_tarjeta ''TARJETA''
FROM analitica a
INNER JOIN F_CLIENTE_TARJETA ct ON ct.id_cliente=a.id_analitica and ct.cia=a.cia
WHERE (a.cia='''+@cia+''') '+@filtro+'
')
GO
/****** Object:  StoredProcedure [dbo].[FIDESP_CREAR_DIRECCION]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*

SELECT * FROM ANALITICA
SELECT * FROM PAIS
SELECT * FROM UBICACION
SELECT * FROM TIPO_VIA
SELECT * FROM TIPO_ZONA

DECLARE @DESCRIP VARCHAR(300)
EXEC SP_CREAR_DIRECCION '01','01','26 DE NOVIEMBRE','1952','2 B','01','VIRGEN DE LOURDES','FRENTE AL PARQUE','001','15','01','43', @DESCRIP OUTPUT
PRINT @DESCRIP

*/
--------------------------------------------
--------------------------------------------
/*
CREATE	PROCEDURE	[dbo].[SP_CREAR_DIRECCION]
@CIA			CHAR(2),
@TIPO_VIA		CHAR(2),
@NOMBRE_VIA		VARCHAR(60),
@NRO			VARCHAR(10),
@INTERIOR		VARCHAR(10),
@TIPO_ZONA		CHAR(20),
@NOMBRE_ZONA	VARCHAR(60),
@REFERENCIA		VARCHAR(60),
@ID_PAIS		VARCHAR(3),
@ID_DPTO		CHAR(2),
@ID_PROVINCIA	CHAR(2),
@ID_DISTRITO	CHAR(2),
@DIRECCION		VARCHAR(300)OUTPUT
AS
--------------------------------------------
DECLARE @ABR_VIA	VARCHAR(20)
DECLARE @ABR_ZONA	VARCHAR(20)
DECLARE @NOM_PAIS	VARCHAR(30)
DECLARE	@NOM_DPTO	VARCHAR(30)
DECLARE	@NOM_PROV	VARCHAR(30)
DECLARE	@NOM_DIST	VARCHAR(30)
--------------------------------------------
SET	@ABR_VIA	= ( SELECT ISNULL ((
								SELECT abreviatura FROM tipo_via WHERE cia = @CIA AND id_tipo_via = @TIPO_VIA ),''))
SET	@ABR_ZONA	= ( SELECT ISNULL ((
								SELECT abreviatura FROM tipo_zona WHERE cia = @CIA AND id_tipo_zona = @TIPO_ZONA ),''))
SET	@NOM_PAIS	= ( SELECT ISNULL ((
								SELECT descripcion FROM pais WHERE cia = @CIA AND id_pais = @ID_PAIS ),''))
SET @NOM_DPTO	= ( SELECT ISNULL ((
								SELECT top(1)des_dpto FROM ubicacion WHERE cia = @CIA AND id_pais = @ID_PAIS AND id_dpto = @ID_DPTO ),''))
SET @NOM_PROV	= ( SELECT ISNULL ((
								SELECT top(1)des_provincia FROM ubicacion WHERE cia = @CIA AND id_pais = @ID_PAIS AND id_dpto = @ID_DPTO AND id_provincia = @ID_PROVINCIA ),''))
SET @NOM_DIST	= ( SELECT ISNULL ((
								SELECT top(1)des_distrito FROM ubicacion WHERE cia = @CIA AND id_pais = @ID_PAIS AND id_dpto = @ID_DPTO AND id_provincia = @ID_PROVINCIA AND id_distrito = @ID_DISTRITO ),''))
---------------------------------------------
SET @DIRECCION = @ABR_VIA + ' ' + @NOMBRE_VIA + ' ' + 'Nro.' + @NRO + ' Int.' + @INTERIOR + ' - ' + @ABR_ZONA + ' ' + @NOMBRE_ZONA + ' - ' + @REFERENCIA + ' - ' + @NOM_DIST + ' - ' + @NOM_PROV + ' - ' + @NOM_DPTO + ' - ' + @NOM_PAIS*/
CREATE	PROCEDURE	[dbo].[FIDESP_CREAR_DIRECCION]
AS
SELECT * FROM CUSTOMERS
GO
/****** Object:  StoredProcedure [dbo].[INSERTA_MOVIMIENTO]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[INSERTA_MOVIMIENTO]
@num_cta char(12),@tip_mov char(1),
@saldo_ant money,@monto money,@saldo_nue money
AS
INSERT INTO Movimientos VALUES(@num_cta,getdate(),
  @tip_mov,@saldo_ant,@monto,@saldo_nue)
GO
/****** Object:  StoredProcedure [dbo].[LISTA_TOP_10_MOVIMIENTOS]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
select * from MOVIMIENTOS
LISTA_TOP_10_MOVIMIENTOS '191-12507-09'
select * from #TMP1
*/
CREATE PROC [dbo].[LISTA_TOP_10_MOVIMIENTOS]
@NUM_CTA CHAR(12)
AS
SELECT TOP 10 * 
  INTO #TMP1
FROM MOVIMIENTOS WHERE NUM_CTA=@NUM_CTA
	ORDER BY FECHA DESC
GO
/****** Object:  StoredProcedure [dbo].[Listado_Alumnos_Especialidad]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[Listado_Alumnos_Especialidad]
@espec varchar(30)
as
select a.idalumno,a.ApeAlumno +' ,'+ space(1)+ a.NomAlumno as 'Nombre 'from alumno a
inner join especialidad e on e.Idesp = a.Idesp and e.Nomesp = @espec 
GO
/****** Object:  StoredProcedure [dbo].[Listado_Notas_Alumnos]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[Listado_Notas_Alumnos]
@idalumno varchar (30)
as
select c.NomCurso, n.ExaParcial,n.ExaFinal,Promedio=round(((ExaParcial+(n.ExaFinal*2))/3),2),
CASE WHEN (round(((ExaParcial+(n.ExaFinal*2))/3),2))>10.5 
 THEN 'aprobado'ELSE 'desaprobado' END as 'Obervacion'
from notas n
inner join alumno a on a.IdAlumno=n.IdAlumno 
inner join curso c on c.IdCurso= n.IdCurso 
where a.idalumno = @idalumno
GO
/****** Object:  StoredProcedure [dbo].[LISTAR_CUENTAS]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[LISTAR_CUENTAS]
@cli_codigo CHAR(5)
AS
SELECT num_cta,desc_cta,saldo
FROM Cuentas CTA INNER JOIN Tipo_Cuentas TC
ON CTA.cod_cta=TC.cod_cta
AND CTA.cli_codigo=@cli_codigo --'C0001'
GO
/****** Object:  StoredProcedure [dbo].[LISTAR_MOVIMIENTOS]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[LISTAR_MOVIMIENTOS]
@num_cta char(12)
AS
SELECT fecha=convert(char(10),fecha,103),
	Tipo_Mov=case tip_mov
		when 'D' then 'Depósito'
		when 'R' then 'Retiro'
	end,
	saldo_ant, monto, saldo_nue
FROM movimientos
	WHERE num_cta=@num_cta
GO
/****** Object:  StoredProcedure [dbo].[LISTAR_ORD_CLI_PROD_AÑO]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[LISTAR_ORD_CLI_PROD_AÑO]
@CLIENTE CHAR(5), @PRODUCTO INT ,@AÑO INT
AS
	SELECT O.ORDERID,ORDERDATE=convert(varchar(30),O.ORDERDATE,103),
		CANT=D.QUANTITY
	FROM ORDERS O,[ORDER DETAILS] D
	WHERE O.ORDERID =D.ORDERID
		AND O.CUSTOMERID=@CLIENTE
		AND D.PRODUCTID=@PRODUCTO
		AND YEAR(O.ORDERDATE)=@AÑO
GO
/****** Object:  StoredProcedure [dbo].[MENUSP_ObtenerOpcionesMenu]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[MENUSP_ObtenerOpcionesMenu]
AS

SET NOCOUNT ON

SELECT MenuId, Descripcion, Posicion, PadreId, Icono, Habilitado, Url
FROM dbo.Menu
WHERE Habilitado = 1

SET NOCOUNT OFF

GO
/****** Object:  StoredProcedure [dbo].[MENUSP_uspListarOpcionesUsuario]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[MENUSP_uspListarOpcionesUsuario]
@idUsuario int
AS
	SET NOCOUNT ON
	
	select idModulo, Modulo, idGrupo, Grupo, idOpcion, Opcion, url
	from Opciones
	
RETURN
GO
/****** Object:  StoredProcedure [dbo].[mp_DataAsiento]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE [dbo].[mp_DataAsiento](@sCia char(2), @sMoneda char(2), @sTabla varchar(30), @sFiltro varchar(2000))

AS

SET NOCOUNT ON
--DECLARE @sCia char(2), @sAnio char(4), @sMes char(2), @sMoneda char(2), @sTabla varchar(30), @sFiltro varchar(2000)
DECLARE @sLibro char(3), @sAgrupadoPor char(2)
DECLARE @sSelect varchar(1000), @sGroupBy varchar(1000), @sSelect2 varchar(1000), @sGroupBy2 varchar(1000), @sSelect3 varchar(1000), @sGroupBy3 varchar(1000)
--SELECT @sCia='01', @sAnio='2008', @sMes='01', @sMoneda='02', @sTabla='tas123', @sFiltroLibro='700'
--SELECT @sCia='01', @sMoneda='02', @sTabla='tas123', @sFiltro=' and a.anio=''2009'' and a.mes=''08'' and a.id_libro=''700'' '
--SELECT @sCia='01', @sMoneda='02', @sTabla='TAS20090722203800', @sFiltro=' and (a.fecha_contable>=''2009-08-18 00:00:00'' and a.fecha_contable<=''2009-08-18 23:59:59'') and a.id_libro=''700'' '
SELECT @sSelect='', @sGroupBy=''

DECLARE sql1 CURSOR FOR
SELECT id_libro, id_agrupado_por
FROM libro_auxiliar
WHERE cia=@sCia --and id_libro=@sFiltroLibro
ORDER BY id_libro
OPEN sql1
FETCH NEXT FROM sql1 INTO @sLibro, @sAgrupadoPor
WHILE @@FETCH_STATUS = 0
BEGIN
 SELECT @sSelect='', @sGroupBy=''
--creando las cadenas para insertar data
 IF @sAgrupadoPor='00' --GENERAL
  BEGIN
   SELECT @sSelect='a.cia, a.sede, a.id_asiento, null, a.fecha_contable, l.id_libro,
    ad.id_cuenta, ad.id_centro_costo, ad.id_actividad,
    ad.id_tipo_analitica, ad.id_analitica,
    ad.id_tipo_doc, ad.serie_doc, ad.nro_doc, null, ad.tipo_cambio,
    case when a.id_estado=''01'' then ad.glosa else ''***** ANULADO *****'' end,
    a.uc, a.um, a.id_estado,
    (convert(decimal(19,2),case when a.id_estado=''01'' and ad.id_estado=''01'' then ad.debe_01 else 0 end)),
    (convert(decimal(19,2),case when a.id_estado=''01'' and ad.id_estado=''01'' then ad.haber_01 else 0 end)),
    (convert(decimal(19,2),case when a.id_estado=''01'' and ad.id_estado=''01'' then ad.debe_'+@sMoneda+' else 0 end)),
    (convert(decimal(19,2),case when a.id_estado=''01'' and ad.id_estado=''01'' then ad.haber_'+@sMoneda+' else 0 end))'
   SELECT @sGroupBy=''
  END
 IF @sAgrupadoPor='01' --FECHA
  BEGIN
   SELECT @sSelect='a.cia, a.sede, min(a.id_asiento), max(a.id_asiento), a.fecha_contable, l.id_libro,
    ad.id_cuenta, null, null,
    null, null,
    null, null, null, null, null, null,
    null, null, ''01'',
    sum(convert(decimal(19,2),case when a.id_estado=''01'' and ad.id_estado=''01'' then ad.debe_01 else 0 end)),
    sum(convert(decimal(19,2),case when a.id_estado=''01'' and ad.id_estado=''01'' then ad.haber_01 else 0 end)),
    sum(convert(decimal(19,2),case when a.id_estado=''01'' and ad.id_estado=''01'' then ad.debe_'+@sMoneda+' else 0 end)),
    sum(convert(decimal(19,2),case when a.id_estado=''01'' and ad.id_estado=''01'' then ad.haber_'+@sMoneda+' else 0 end))'
   SELECT @sGroupBy='GROUP BY a.cia, a.sede, a.fecha_contable, l.id_libro, ad.id_cuenta'
  END
 IF @sAgrupadoPor='02' --FECHA - ANALITICA
  BEGIN
   SELECT @sSelect='a.cia, a.sede, min(a.id_asiento), max(a.id_asiento), a.fecha_contable, l.id_libro,
    ad.id_cuenta, null, null,
    ad.id_tipo_analitica, ad.id_analitica,
    null, null, null, null, null, null,
    null, null, ''01'',
    sum(convert(decimal(19,2),case when a.id_estado=''01'' and ad.id_estado=''01'' then ad.debe_01 else 0 end)),
    sum(convert(decimal(19,2),case when a.id_estado=''01'' and ad.id_estado=''01'' then ad.haber_01 else 0 end)),
    sum(convert(decimal(19,2),case when a.id_estado=''01'' and ad.id_estado=''01'' then ad.debe_'+@sMoneda+' else 0 end)),
    sum(convert(decimal(19,2),case when a.id_estado=''01'' and ad.id_estado=''01'' then ad.haber_'+@sMoneda+' else 0 end))'
   SELECT @sGroupBy='GROUP BY a.cia, a.sede, a.fecha_contable, l.id_libro, ad.id_cuenta, ad.id_tipo_analitica, ad.id_analitica'
  END
 IF @sAgrupadoPor='03' --FECHA - DOCUMENTO
  BEGIN
   --min(a.id_asiento)+''-''+max(substring(a.id_asiento,10,10)), min(ad.nro_doc)+''-''+max(ad.nro_doc)
   SELECT @sSelect='a.cia, a.sede, min(a.id_asiento), max(a.id_asiento), a.fecha_contable, l.id_libro,
    ad.id_cuenta, null, null,
    null, null,
    ad.id_tipo_doc, ad.serie_doc, min(ad.nro_doc), max(ad.nro_doc), null, null,
    null, null, ''01'',
    sum(convert(decimal(19,2),case when a.id_estado=''01'' and ad.id_estado=''01'' then ad.debe_01 else 0 end)),
    sum(convert(decimal(19,2),case when a.id_estado=''01'' and ad.id_estado=''01'' then ad.haber_01 else 0 end)),
    sum(convert(decimal(19,2),case when a.id_estado=''01'' and ad.id_estado=''01'' then ad.debe_'+@sMoneda+' else 0 end)),
    sum(convert(decimal(19,2),case when a.id_estado=''01'' and ad.id_estado=''01'' then ad.haber_'+@sMoneda+' else 0 end))'
   SELECT @sGroupBy='GROUP BY a.cia, a.sede, a.fecha_contable, l.id_libro, ad.id_cuenta, ad.id_tipo_doc, ad.serie_doc'
  END
 IF @sAgrupadoPor='04' --FECHA - DOCUMENTO X INTERVALO
 ----------------------------------------------------------------------------------------------------
 ----------------------------------------------------------------------------------------------------
  BEGIN ----------------------------------------------------------------------------------------------------
-- SE QUITO ESTE QUERY  and ad.item=(case when a.id_estado=''01'' then ad.item else 1 end)
EXEC('
DECLARE @sSede char(2), @dtFecha datetime, @sCuenta varchar(20), @sTipoDoc char(2), @sSerieDoc char(4), @sNroDoc varchar(20), @sTipoAnalitica char(2), @sAnalitica varchar(20), @sEstado char(2), @sAsiento varchar(20), @sCentroCosto varchar(20), @sActividad varchar(20), @nTipoCambio decimal(19,6), @sGlosa varchar(100), @sUC varchar(10), @sUM varchar(10), @nDebe01 decimal(19,2), @nHaber01 decimal(19,2), @nDebe02 decimal(19,2), @nHaber02 decimal(19,2)
DECLARE @sSede2 char(2), @dtFecha2 datetime, @sCuenta2 varchar(20), @sTipoDoc2 char(2), @sSerieDoc2 char(4), @sNroDoc2 varchar(20), @sTipoAnalitica2 char(2), @sAnalitica2 varchar(20), @sEstado2 char(2), @sAsiento2 varchar(20), @sCentroCosto2 varchar(20), @sActividad2 varchar(20), @nTipoCambio2 decimal(19,6), @sGlosa2 varchar(100), @sUC2 varchar(10), @sUM2 varchar(10), @nDebe201 decimal(19,2), @nHaber201 decimal(19,2), @nDebe202 decimal(19,2), @nHaber202 decimal(19,2)
DECLARE @sNroDocIni varchar(20), @sAsientoIni varchar(20), @nDebe01Suma decimal(19,2), @nHaber01Suma decimal(19,2), @nDebe02Suma decimal(19,2), @nHaber02Suma decimal(19,2)
DECLARE sql2 CURSOR FOR
 SELECT a.sede, a.id_asiento, a.fecha_contable, ad.id_cuenta, ad.id_centro_costo, ad.id_actividad,
  isnull(ad.id_tipo_analitica,''''), isnull(ad.id_analitica,''''),
  isnull(ad.id_tipo_doc,''''), isnull(ad.serie_doc,''''), isnull(ad.nro_doc,''''), ad.tipo_cambio, ad.glosa, a.uc, a.um, a.id_estado,
  (convert(decimal(19,2),case when a.id_estado=''01'' and ad.id_estado=''01'' then ad.debe_01 else 0 end)) as ''debe_01'',
  (convert(decimal(19,2),case when a.id_estado=''01'' and ad.id_estado=''01'' then ad.haber_01 else 0 end)) as ''haber_01'',
  (convert(decimal(19,2),case when a.id_estado=''01'' and ad.id_estado=''01'' then ad.debe_'+@sMoneda+' else 0 end)) as ''debe_02'',
  (convert(decimal(19,2),case when a.id_estado=''01'' and ad.id_estado=''01'' then ad.haber_'+@sMoneda+' else 0 end)) as ''haber_02''
 FROM asiento a
 INNER JOIN asiento_detalle ad ON ad.cia=a.cia and ad.sede=a.sede and ad.id_asiento=a.id_asiento
  and ad.item=(case when a.id_estado=''01'' then ad.item else 1 end)
 INNER JOIN libro_auxiliar l ON l.cia=a.cia  and l.id_libro=a.id_libro and isnull(l.id_agrupado_por,''00'')='''+@sAgrupadoPor+'''
 WHERE a.cia='''+@sCia+''' and a.id_libro='''+@sLibro+'''
 '+@sFiltro+'
 ORDER BY a.sede, a.fecha_contable, ad.id_cuenta, ad.id_tipo_doc, ad.serie_doc, ad.nro_doc
OPEN sql2
FETCH NEXT FROM sql2 INTO @sSede, @sAsiento, @dtFecha, @sCuenta, @sCentroCosto, @sActividad, @sTipoAnalitica, @sAnalitica, @sTipoDoc, @sSerieDoc, @sNroDoc, @nTipoCambio, @sGlosa, @sUC, @sUM, @sEstado, @nDebe01, @nHaber01, @nDebe02, @nHaber02
SELECT @sNroDocIni=null, @nDebe01Suma=0, @nHaber01Suma=0, @nDebe02Suma=0, @nHaber02Suma=0
WHILE @@FETCH_STATUS = 0
BEGIN
 IF (not @sNroDocIni is null) and (@sSede2!=@sSede or @dtFecha2!=@dtFecha or @sCuenta2!=@sCuenta or @sTipoDoc2!=@sTipoDoc or @sSerieDoc2!=@sSerieDoc or @sTipoAnalitica2!=@sTipoAnalitica or @sAnalitica2!=@sAnalitica or @sEstado2!=@sEstado or @sEstado=''02'')
  BEGIN
   IF @sNroDocIni!=@sNroDoc2
    SELECT @sCentroCosto2=null, @sActividad2=null, @nTipoCambio2=abs(case when (@nDebe02Suma-@nHaber02Suma)!=0 then (@nDebe01Suma-@nHaber01Suma)/(@nDebe02Suma-@nHaber02Suma) else 0 end), @sGlosa2=''***** CONSOLIDADO *****'', @sUC2=null, @sUM2=null
   IF @sEstado2=''02''
    SELECT @sGlosa2=''***** ANULADO *****''
   INSERT INTO '+@sTabla+'(cia, sede, id_asiento_min, id_asiento_max, fecha_contable, id_libro, id_cuenta, id_centro_costo, id_actividad, id_tipo_analitica, id_analitica, id_tipo_doc, serie_doc, nro_doc_min, nro_doc_max, tipo_cambio, glosa, uc, um, id_estado, debe_01, haber_01, debe_02, haber_02)
   VALUES('''+@sCia+''', @sSede2, @sAsientoIni, @sAsiento2, @dtFecha2, '''+@sLibro+''', @sCuenta2, @sCentroCosto2, @sActividad2, @sTipoAnalitica2, @sAnalitica2, @sTipoDoc2, @sSerieDoc2, @sNroDocIni, @sNroDoc2, @nTipoCambio2, @sGlosa2, @sUC2, @sUM2, @sEstado2, @nDebe01Suma, @nHaber01Suma, @nDebe02Suma, @nHaber02Suma)
   SELECT @sNroDocIni=@sNroDoc, @sAsientoIni=@sAsiento, @nDebe01Suma=0, @nHaber01Suma=0, @nDebe02Suma=0, @nHaber02Suma=0
 END
   SELECT @sSede2=@sSede, @sAsiento2=@sAsiento, @dtFecha2=@dtFecha, @sCuenta2=@sCuenta, @sCentroCosto2=@sCentroCosto, @sActividad2=@sActividad, @sTipoAnalitica2=@sTipoAnalitica, @sAnalitica2=@sAnalitica, @sTipoDoc2=@sTipoDoc, @sSerieDoc2=@sSerieDoc, @sNroDoc2=@sNroDoc, @nTipoCambio2=@nTipoCambio, @sGlosa2=@sGlosa, @sUC2=@sUC, @sUM2=@sUM, @sEstado2=@sEstado, @sEstado2=@sEstado, @nDebe201=@nDebe01, @nHaber201=@nHaber01, @nDebe202=@nDebe02, @nHaber202=@nHaber02
   SELECT @nDebe01Suma=@nDebe01Suma+@nDebe01, @nHaber01Suma=@nHaber01Suma+@nHaber01, @nDebe02Suma=@nDebe02Suma+@nDebe02, @nHaber02Suma=@nHaber02Suma+@nHaber02
   IF @sNroDocIni is null
    SELECT @sNroDocIni=@sNroDoc, @sAsientoIni=@sAsiento
 FETCH NEXT FROM sql2 INTO @sSede, @sAsiento, @dtFecha, @sCuenta, @sCentroCosto, @sActividad, @sTipoAnalitica, @sAnalitica, @sTipoDoc, @sSerieDoc, @sNroDoc, @nTipoCambio, @sGlosa, @sUC, @sUM, @sEstado, @nDebe01, @nHaber01, @nDebe02, @nHaber02
END
CLOSE sql2
DEALLOCATE sql2
IF @sNroDocIni!=@sNroDoc2
 SELECT @sCentroCosto2=null, @sActividad2=null, @nTipoCambio2=abs(case when (@nDebe02Suma-@nHaber02Suma)!=0 then (@nDebe01Suma-@nHaber01Suma)/(@nDebe02Suma-@nHaber02Suma) else 0 end), @sGlosa2=''***** CONSOLIDADO *****'', @sUC2=null, @sUM2=null
IF @sEstado2=''02''
 SELECT @sGlosa2=''***** ANULADO *****''
INSERT INTO '+@sTabla+'(cia, sede, id_asiento_min, id_asiento_max, fecha_contable, id_libro, id_cuenta, id_centro_costo, id_actividad, id_tipo_analitica, id_analitica, id_tipo_doc, serie_doc, nro_doc_min, nro_doc_max, tipo_cambio, glosa, uc, um, id_estado, debe_01, haber_01, debe_02, haber_02)
VALUES('''+@sCia+''', @sSede2, @sAsientoIni, @sAsiento2, @dtFecha2, '''+@sLibro+''', @sCuenta2, @sCentroCosto2, @sActividad2, @sTipoAnalitica2, @sAnalitica2, @sTipoDoc2, @sSerieDoc2, @sNroDocIni, @sNroDoc2, @nTipoCambio2, @sGlosa2, @sUC2, @sUM2, @sEstado2, @nDebe01Suma, @nHaber01Suma, @nDebe02Suma, @nHaber02Suma)
')
  END ----------------------------------------------------------------------------------------------------
 ----------------------------------------------------------------------------------------------------
 ----------------------------------------------------------------------------------------------------
 IF @sAgrupadoPor='05' --ANALITICA
  BEGIN
   SELECT @sSelect='a.cia, a.sede, min(a.id_asiento), max(a.id_asiento), null, l.id_libro,
    ad.id_cuenta, null, null,
    ad.id_tipo_analitica, ad.id_analitica,
    null, null, null, null, null, null,
    null, null, ''01'',
    sum(convert(decimal(19,2),case when a.id_estado=''01'' and ad.id_estado=''01'' then ad.debe_01 else 0 end)),
    sum(convert(decimal(19,2),case when a.id_estado=''01'' and ad.id_estado=''01'' then ad.haber_01 else 0 end)),
    sum(convert(decimal(19,2),case when a.id_estado=''01'' and ad.id_estado=''01'' then ad.debe_'+@sMoneda+' else 0 end)),
    sum(convert(decimal(19,2),case when a.id_estado=''01'' and ad.id_estado=''01'' then ad.haber_'+@sMoneda+' else 0 end))'
   SELECT @sGroupBy='GROUP BY a.cia, a.sede, l.id_libro, ad.id_cuenta, ad.id_tipo_analitica, ad.id_analitica'
  END
 IF @sAgrupadoPor='06' --DOCUMENTO
  BEGIN
   SELECT @sSelect='a.cia, a.sede, min(a.id_asiento), max(a.id_asiento), null, l.id_libro,
    ad.id_cuenta, null, null,
    null, null,
    ad.id_tipo_doc, ad.serie_doc, min(ad.nro_doc), max(ad.nro_doc), null, null,
    null, null, ''01'',
    sum(convert(decimal(19,2),case when a.id_estado=''01'' and ad.id_estado=''01'' then ad.debe_01 else 0 end)),
    sum(convert(decimal(19,2),case when a.id_estado=''01'' and ad.id_estado=''01'' then ad.haber_01 else 0 end)),
    sum(convert(decimal(19,2),case when a.id_estado=''01'' and ad.id_estado=''01'' then ad.debe_'+@sMoneda+' else 0 end)),
    sum(convert(decimal(19,2),case when a.id_estado=''01'' and ad.id_estado=''01'' then ad.haber_'+@sMoneda+' else 0 end))'
   SELECT @sGroupBy='GROUP BY a.cia, a.sede, l.id_libro, ad.id_cuenta, ad.id_tipo_doc, ad.serie_doc'
  END
 IF @sAgrupadoPor='07' --DOCUMENTO X INTERVALO
 ----------------------------------------------------------------------------------------------------
 ----------------------------------------------------------------------------------------------------
  BEGIN ----------------------------------------------------------------------------------------------------
-- SE QUITO ESTE QUERY  and ad.item=(case when a.id_estado=''01'' then ad.item else 1 end)
EXEC('
DECLARE @sSede char(2), @dtFecha datetime, @sCuenta varchar(20), @sTipoDoc char(2), @sSerieDoc char(4), @sNroDoc varchar(20), @sTipoAnalitica char(2), @sAnalitica varchar(20), @sEstado char(2), @sAsiento varchar(20), @sCentroCosto varchar(20), @sActividad varchar(20), @nTipoCambio decimal(19,6), @sGlosa varchar(100), @sUC varchar(10), @sUM varchar(10), @nDebe01 decimal(19,2), @nHaber01 decimal(19,2), @nDebe02 decimal(19,2), @nHaber02 decimal(19,2)
DECLARE @sSede2 char(2), @dtFecha2 datetime, @sCuenta2 varchar(20), @sTipoDoc2 char(2), @sSerieDoc2 char(4), @sNroDoc2 varchar(20), @sTipoAnalitica2 char(2), @sAnalitica2 varchar(20), @sEstado2 char(2), @sAsiento2 varchar(20), @sCentroCosto2 varchar(20), @sActividad2 varchar(20), @nTipoCambio2 decimal(19,6), @sGlosa2 varchar(100), @sUC2 varchar(10), @sUM2 varchar(10), @nDebe201 decimal(19,2), @nHaber201 decimal(19,2), @nDebe202 decimal(19,2), @nHaber202 decimal(19,2)
DECLARE @sNroDocIni varchar(20), @sAsientoIni varchar(20), @nDebe01Suma decimal(19,2), @nHaber01Suma decimal(19,2), @nDebe02Suma decimal(19,2), @nHaber02Suma decimal(19,2)
DECLARE sql2 CURSOR FOR
 SELECT a.sede, a.id_asiento, a.fecha_contable, ad.id_cuenta, ad.id_centro_costo, ad.id_actividad, ad.id_tipo_analitica, ad.id_analitica, ad.id_tipo_doc, ad.serie_doc, ad.nro_doc, ad.tipo_cambio, ad.glosa, a.uc, a.um, a.id_estado,
  (convert(decimal(19,2),case when a.id_estado=''01'' and ad.id_estado=''01'' then ad.debe_01 else 0 end)) as ''debe_01'',
  (convert(decimal(19,2),case when a.id_estado=''01'' and ad.id_estado=''01'' then ad.haber_01 else 0 end)) as ''haber_01'',
  (convert(decimal(19,2),case when a.id_estado=''01'' and ad.id_estado=''01'' then ad.debe_'+@sMoneda+' else 0 end)) as ''debe_02'',
  (convert(decimal(19,2),case when a.id_estado=''01'' and ad.id_estado=''01'' then ad.haber_'+@sMoneda+' else 0 end)) as ''haber_02''
 FROM asiento a
 INNER JOIN asiento_detalle ad ON ad.cia=a.cia and ad.sede=a.sede and ad.id_asiento=a.id_asiento
  and ad.item=(case when a.id_estado=''01'' then ad.item else 1 end)
 INNER JOIN libro_auxiliar l ON l.cia=a.cia  and l.id_libro=a.id_libro and isnull(l.id_agrupado_por,''00'')='''+@sAgrupadoPor+'''
 WHERE a.cia='''+@sCia+''' and a.id_libro='''+@sLibro+'''
 '+@sFiltro+'
 ORDER BY a.sede, a.fecha_contable, ad.id_cuenta, ad.id_tipo_doc, ad.serie_doc, ad.nro_doc
OPEN sql2
FETCH NEXT FROM sql2 INTO @sSede, @sAsiento, @dtFecha, @sCuenta, @sCentroCosto, @sActividad, @sTipoAnalitica, @sAnalitica, @sTipoDoc, @sSerieDoc, @sNroDoc, @nTipoCambio, @sGlosa, @sUC, @sUM, @sEstado, @nDebe01, @nHaber01, @nDebe02, @nHaber02
SELECT @sNroDocIni=null, @nDebe01Suma=0, @nHaber01Suma=0, @nDebe02Suma=0, @nHaber02Suma=0
WHILE @@FETCH_STATUS = 0
BEGIN
 IF (not @sNroDocIni is null) and (@sSede2!=@sSede or @dtFecha2!=@dtFecha or @sCuenta2!=@sCuenta or @sTipoDoc2!=@sTipoDoc or @sSerieDoc2!=@sSerieDoc or @sEstado2!=@sEstado or @sEstado=''02'')
  BEGIN
   IF @sNroDocIni!=@sNroDoc2
    SELECT @sCentroCosto2=null, @sActividad2=null, @sTipoAnalitica2=null, @sAnalitica2=null, @nTipoCambio2=abs(case when (@nDebe02Suma-@nHaber02Suma)!=0 then (@nDebe01Suma-@nHaber01Suma)/(@nDebe02Suma-@nHaber02Suma) else 0 end), @sGlosa2=''***** CONSOLIDADO *****'', @sUC2=null, @sUM2=null
   IF @sEstado2=''02''
    SELECT @sGlosa2=''***** ANULADO *****''
   INSERT INTO '+@sTabla+'(cia, sede, id_asiento_min, id_asiento_max, fecha_contable, id_libro, id_cuenta, id_centro_costo, id_actividad, id_tipo_analitica, id_analitica, id_tipo_doc, serie_doc, nro_doc_min, nro_doc_max, tipo_cambio, glosa, uc, um, id_estado, debe_01, haber_01, debe_02, haber_02)
   VALUES('''+@sCia+''', @sSede2, @sAsientoIni, @sAsiento2, @dtFecha2, '''+@sLibro+''', @sCuenta2, @sCentroCosto2, @sActividad2, @sTipoAnalitica2, @sAnalitica2, @sTipoDoc2, @sSerieDoc2, @sNroDocIni, @sNroDoc2, @nTipoCambio2, @sGlosa2, @sUC2, @sUM2, @sEstado2, @nDebe01Suma, @nHaber01Suma, @nDebe02Suma, @nHaber02Suma)
   SELECT @sNroDocIni=@sNroDoc, @sAsientoIni=@sAsiento, @nDebe01Suma=0, @nHaber01Suma=0, @nDebe02Suma=0, @nHaber02Suma=0
 END
   SELECT @sSede2=@sSede, @sAsiento2=@sAsiento, @dtFecha2=@dtFecha, @sCuenta2=@sCuenta, @sCentroCosto2=@sCentroCosto, @sActividad2=@sActividad, @sTipoAnalitica2=@sTipoAnalitica, @sAnalitica2=@sAnalitica, @sTipoDoc2=@sTipoDoc, @sSerieDoc2=@sSerieDoc, @sNroDoc2=@sNroDoc, @nTipoCambio2=@nTipoCambio, @sGlosa2=@sGlosa, @sUC2=@sUC, @sUM2=@sUM, @sEstado2=@sEstado, @sEstado2=@sEstado, @nDebe201=@nDebe01, @nHaber201=@nHaber01, @nDebe202=@nDebe02, @nHaber202=@nHaber02
   SELECT @nDebe01Suma=@nDebe01Suma+@nDebe01, @nHaber01Suma=@nHaber01Suma+@nHaber01, @nDebe02Suma=@nDebe02Suma+@nDebe02, @nHaber02Suma=@nHaber02Suma+@nHaber02
   IF @sNroDocIni is null
    SELECT @sNroDocIni=@sNroDoc, @sAsientoIni=@sAsiento
 FETCH NEXT FROM sql2 INTO @sSede, @sAsiento, @dtFecha, @sCuenta, @sCentroCosto, @sActividad, @sTipoAnalitica, @sAnalitica, @sTipoDoc, @sSerieDoc, @sNroDoc, @nTipoCambio, @sGlosa, @sUC, @sUM, @sEstado, @nDebe01, @nHaber01, @nDebe02, @nHaber02
END
CLOSE sql2
DEALLOCATE sql2
IF @sNroDocIni!=@sNroDoc2
 SELECT @sCentroCosto2=null, @sActividad2=null, @sTipoAnalitica2=null, @sAnalitica2=null, @nTipoCambio2=abs(case when (@nDebe02Suma-@nHaber02Suma)!=0 then (@nDebe01Suma-@nHaber01Suma)/(@nDebe02Suma-@nHaber02Suma) else 0 end), @sGlosa2=''***** CONSOLIDADO *****'', @sUC2=null, @sUM2=null
IF @sEstado2=''02''
 SELECT @sGlosa2=''***** ANULADO *****''
INSERT INTO '+@sTabla+'(cia, sede, id_asiento_min, id_asiento_max, fecha_contable, id_libro, id_cuenta, id_centro_costo, id_actividad, id_tipo_analitica, id_analitica, id_tipo_doc, serie_doc, nro_doc_min, nro_doc_max, tipo_cambio, glosa, uc, um, id_estado, debe_01, haber_01, debe_02, haber_02)
VALUES('''+@sCia+''', @sSede2, @sAsientoIni, @sAsiento2, @dtFecha2, '''+@sLibro+''', @sCuenta2, @sCentroCosto2, @sActividad2, @sTipoAnalitica2, @sAnalitica2, @sTipoDoc2, @sSerieDoc2, @sNroDocIni, @sNroDoc2, @nTipoCambio2, @sGlosa2, @sUC2, @sUM2, @sEstado2, @nDebe01Suma, @nHaber01Suma, @nDebe02Suma, @nHaber02Suma)
')
  END ----------------------------------------------------------------------------------------------------
 ----------------------------------------------------------------------------------------------------
 ----------------------------------------------------------------------------------------------------

 IF @sAgrupadoPor='16' --FECHA - ASIENTO - GLOSA
  BEGIN
   SELECT @sSelect='a.cia, a.sede, a.id_asiento, a.id_asiento, a.fecha_contable, l.id_libro,
    ad.id_cuenta, null, null,
    null, null,
    null, null, null, null, null, ad.glosa,
    null, null, ''01'',
    sum(convert(decimal(19,2),case when a.id_estado=''01'' and ad.id_estado=''01'' then ad.debe_01 else 0 end)),
    sum(convert(decimal(19,2),case when a.id_estado=''01'' and ad.id_estado=''01'' then ad.haber_01 else 0 end)),
    sum(convert(decimal(19,2),case when a.id_estado=''01'' and ad.id_estado=''01'' then ad.debe_'+@sMoneda+' else 0 end)),
    sum(convert(decimal(19,2),case when a.id_estado=''01'' and ad.id_estado=''01'' then ad.haber_'+@sMoneda+' else 0 end))'
   SELECT @sGroupBy='GROUP BY a.cia, a.sede, a.id_asiento, a.fecha_contable, l.id_libro, ad.id_cuenta, ad.glosa '
  END

 IF len(@sSelect)>0 and @sAgrupadoPor!='04' and @sAgrupadoPor!='07'-- and @sAgrupadoPor!='01'
  BEGIN
-- SE QUITO ESTE QUERY  and ad.item=(case when a.id_estado=''01'' then ad.item else 1 end)
--   PRINT @sLibro + ' - ' + @sFiltro
   EXEC ('INSERT INTO '+@sTabla+'
          SELECT '+@sSelect+'
          FROM asiento a
          INNER JOIN asiento_detalle ad ON ad.cia=a.cia and ad.sede=a.sede and ad.id_asiento=a.id_asiento
           and ad.item=(case when a.id_estado=''01'' then ad.item else 1 end)
          INNER JOIN libro_auxiliar l ON l.cia=a.cia  and l.id_libro=a.id_libro and isnull(l.id_agrupado_por,''00'')='''+@sAgrupadoPor+'''
          WHERE a.cia='''+@sCia+''' and a.id_libro='''+@sLibro+'''
          '+@sFiltro+'
          '+@sGroupBy)
--           and (convert(decimal(19,2),ad.debe_'+@sMoneda+')+convert(decimal(19,2),ad.haber_'+@sMoneda+'))!=0
  END

 IF @sAgrupadoPor in ('01','02','03','04')
  BEGIN

   EXEC ('UPDATE a SET a.id_asiento_min=x.id_asiento_min, a.id_asiento_max=x.id_asiento_max
          FROM '+@sTabla+' a
          INNER JOIN
          (SELECT cia, sede, min(id_asiento_min) as ''id_asiento_min'', max(id_asiento_max) as ''id_asiento_max'', fecha_contable, id_libro
           FROM '+@sTabla+'
           WHERE cia='''+@sCia+''' and id_libro='''+@sLibro+'''
           GROUP BY cia, sede, fecha_contable, id_libro
          ) x ON x.cia=a.cia and x.sede=a.sede and x.id_libro=a.id_libro and x.fecha_contable=a.fecha_contable')

  END

 EXEC ('DELETE ad
        FROM '+@sTabla+' ad
        WHERE ad.cia='''+@sCia+''' and ad.id_libro='''+@sLibro+'''
         and ((convert(decimal(19,2),ad.debe_01)+convert(decimal(19,2),ad.haber_01))=0
         or (convert(decimal(19,2),ad.debe_'+@sMoneda+')+convert(decimal(19,2),ad.haber_'+@sMoneda+'))=0)')

 FETCH NEXT FROM sql1 INTO @sLibro, @sAgrupadoPor
END

CLOSE sql1
DEALLOCATE sql1

SET NOCOUNT OFF
GO
/****** Object:  StoredProcedure [dbo].[NETSP_BUSCAR_EMPLEADO]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
NORSP_BUSCAR_EMPLEADO 1
*/
CREATE PROC [dbo].[NETSP_BUSCAR_EMPLEADO]
@EMP_COD int
AS
SELECT * FROM EMPLEADOS WHERE IDEMPLEADO=@EMP_COD
GO
/****** Object:  StoredProcedure [dbo].[NETSP_BUSCAR_PRODUCTOS_IDPRODUCTO]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
[NETSP_BUSCAR_PRODUCTOS_IDPRODUCTO]  1
*/
CREATE PROC [dbo].[NETSP_BUSCAR_PRODUCTOS_IDPRODUCTO]
@IDPRODUCTO INT
AS
SELECT * FROM PRODUCTOS WHERE IDPRODUCTO=@IDPRODUCTO
GO
/****** Object:  StoredProcedure [dbo].[NETSP_CATEGORIA_ELIMINAR]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
--CREAR UN PROCEDIMIENTO ALMACENADO QUE PERMITA ELIMINAR UNA 
--CATEGORÍA CUALQUIERA. SE ENVIARÁ COMO PARÁMETRO EL IDCATEGORIA.
*/
CREATE PROC [dbo].[NETSP_CATEGORIA_ELIMINAR]
@IDCATEGORIA INT
AS
DELETE FROM CATEGORIAS WHERE IDCATEGORIA=@IDCATEGORIA
--		NETSP_CATEGORIA_ELIMINAR 9
GO
/****** Object:  StoredProcedure [dbo].[NETSP_CATEGORIA_INSERTAR]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
--CREAR UN PROCEDIMIENTO QUE PERMITA INSERTAR UN NUEVO REGISTRO EN LA TABLA CATEGORIAS. SE ENVIARÁ 
	COMO PARÁMETROS LOS CAMPOS QUE SE DESEA INSERTAR. (EN EL CAMPO IMAGEN SE PUEDE INSERTAR NULL). 
*/
CREATE PROC [dbo].[NETSP_CATEGORIA_INSERTAR]
	@NOMBRECATEGORIA VARCHAR(MAX),	@DESCRIPCION VARCHAR(MAX),	@IMAGEN IMAGE
AS
DECLARE @IDCATEGORIA INT
SET @IDCATEGORIA=(SELECT  MAX(IDCATEGORIA)+1 FROM CATEGORIAS)
	INSERT INTO CATEGORIAS VALUES(@IDCATEGORIA,@NOMBRECATEGORIA,@DESCRIPCION,@IMAGEN)
--		NETSP_CATEGORIA_INSERTAR 'PAÑAL','PAÑALES','AA'
--			SP_HELP CATEGORIAS
--			SELECT * FROM CATEGORIAS 
GO
/****** Object:  StoredProcedure [dbo].[NETSP_EMPLEADOS_EDAD_TIEMPO_SERVICIO]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
--USANDO LA TABLA EMPLEADOS MOSTRAR LOS CAMPOS: IDEMPLEADO, EDAD (CALCULAR) Y TIEMPO_SERVICIO (CALCULAR).
*/
CREATE PROC [dbo].[NETSP_EMPLEADOS_EDAD_TIEMPO_SERVICIO]
AS
select IdEmpleado,
datediff(year,fechanacimiento,getdate())as[edad],
datediff(year,fechacontratacion,getdate())as[tiempo_servicio]
 from Empleados  
--select * from  Empleados 
--NETSP_EMPLEADOS_EDAD_TIEMPO_SERVICIO
GO
/****** Object:  StoredProcedure [dbo].[NETSP_PEDIDOS_EMPLEADOS_CANTPED]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
--MOSTRAR LA CANTIDAD DE PEDIDOS EMITIDOS POR UN EMPLEADO. SE ENVIARÁ COMO PARÁMETRO 
--EL CÓDIGO DEL EMPLEADO Y SE MOSTRARÁN LOS CAMPOS IDEMPLEADO, NOMBRE, APELLIDOS Y [CANTIDAD DE PEDIDOS].
*/
CREATE PROC [dbo].[NETSP_PEDIDOS_EMPLEADOS_CANTPED]
AS
SELECT E.IDEMPLEADO, NOMBRE+SPACE(2)+ APELLIDOS AS EMPLEADO,COUNT(IDPEDIDO)AS [CANTIDAD DE PEDIDOS]
 FROM  EMPLEADOS E
LEFT JOIN PEDIDOS P ON P.IDEMPLEADO=E.IDEMPLEADO
GROUP BY E.IDEMPLEADO, NOMBRE, APELLIDOS
GO
/****** Object:  StoredProcedure [dbo].[NETSP_PEDIDOS_MESES_IMPARES]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
--MOSTRAR TODOS LOS PEDIDOS QUE SE ENTREGARON EN LOS MESES IMPARES.
*/
CREATE PROC [dbo].[NETSP_PEDIDOS_MESES_IMPARES]
AS
SELECT IdPedido,IdCliente,IdEmpleado,
 FechaPedido=CONVERT(VARCHAR(30),FechaPedido,103),
 FechaEntrega=CONVERT(VARCHAR(30),FechaEntrega,103),
 FechaEnvio=CONVERT(VARCHAR(30),FechaEnvio,103),
 FormaEnvio,Cargo,Destinatario , DireccionDestinatario,
 CiudadDestinatario,RegionDestinatario, CodPostalDestinatario,PaisDestinatario
 FROM PEDIDOS WHERE MONTH(FECHAENTREGA)%2<>0--/2= 0
 --	SELECT * FROM PEDIDOS
GO
/****** Object:  StoredProcedure [dbo].[NETSP_PEDIDOS_PAR_MESES_IMPARES]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
--ELABORAR UN PROCEDMIENTO ALMACENADO QUE MUESTRE LOS CAMPOS IDPEDIDO Y FECHAPEDIDO 
	DE LOS PEDIDOS CUYO IDPEDIDO SEA PAR Y QUE SALIERON EN LOS MESES IMPARES.
*/
CREATE PROC [dbo].[NETSP_PEDIDOS_PAR_MESES_IMPARES]
AS 
SELECT IDPEDIDO,FECHAPEDIDO=CONVERT(VARCHAR(10),FECHAPEDIDO,103),
FECHAENVIO=CONVERT(VARCHAR(10),FECHAENVIO,103)
 FROM PEDIDOS WHERE IDPEDIDO%2=0 AND MONTH(FECHAENVIO)%2<>0--%2=0
 -- SP_HELP PEDIDOS -- SELECT * FROM PEDIDOS
GO
/****** Object:  StoredProcedure [dbo].[NETSP_PRODUCTOS_ACTUALIZAR]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
--CREAR UN PROCEDIMIENTO QUE PERMITA ACTUALIZAR LOS CAMPOS 
NOMBREPRODUCTO, PRECIOUNIDAD Y UNIDADESENEXISTENCIA DE LA TABLA PRODUCTOS.
*/
CREATE PROC [dbo].[NETSP_PRODUCTOS_ACTUALIZAR]
@IDPRODUCTO INT,@NOMBREPRODUCTO VARCHAR(100),@PRECIOUNIDAD MONEY,
@UNIDADESENEXISTENCIA SMALLINT
AS
UPDATE PRODUCTOS SET NOMBREPRODUCTO=@NOMBREPRODUCTO,PRECIOUNIDAD=@PRECIOUNIDAD,
	UNIDADESENEXISTENCIA=@UNIDADESENEXISTENCIA WHERE  IDPRODUCTO=@IDPRODUCTO
--			NETSP_PRODUCTOS_ACTUALIZAR '1','PAÑAL',15,555
--			SP_HELP PRODUCTOS
--			SELECT * FROM PRODUCTOS
GO
/****** Object:  StoredProcedure [dbo].[NETSP_PRODUCTOS_INSERT]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
NETSP_PRODUCTOS_INSERT 'AAA',150
--	SELECT * FROM PRODUCTO
*/
CREATE PROC [dbo].[NETSP_PRODUCTOS_INSERT]
	@PRODUCTNAME NVARCHAR (40),@UNITPRICE MONEY
AS
DECLARE @PRODUCTID INT
SET @PRODUCTID=(SELECT  MAX(PRODUCTID)+1 FROM PRODUCTO)
INSERT INTO PRODUCTO VALUES(@PRODUCTID,@PRODUCTNAME,@UNITPRICE)
GO
/****** Object:  StoredProcedure [dbo].[NETSP_PRODUCTOS_UPDATE]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[NETSP_PRODUCTOS_UPDATE]
@PRODUCTID INT,@PRODUCTNAME VARCHAR(40),@UNITPRICE MONEY
AS
UPDATE PRODUCTS SET PRODUCTNAME=PRODUCTNAME,
	@UNITPRICE=@UNITPRICE WHERE PRODUCTID=@PRODUCTID
--SELECT * FROM PRODUCTS
GO
/****** Object:  StoredProcedure [dbo].[NORSP_BUSCAR_CATEGORIAS_CATEGORYID]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
NORSP_BUSCAR_CATEGORIAS_CATEGORYID 1
SELECT * FROM CATEGORIES
*/
CREATE PROC [dbo].[NORSP_BUSCAR_CATEGORIAS_CATEGORYID]
@CATEGORYID INT
AS
SELECT CATEGORYNAME ,PICTURE 
FROM CATEGORIES 
WHERE CATEGORYID=@CATEGORYID
GO
/****** Object:  StoredProcedure [dbo].[NORSP_BUSCAR_CATEGORIAS_CATEGORYNAME]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/*

NORSP_BUSCAR_CATEGORIAS_CATEGORYNAME 'Beverages'
SELECT * FROM CATEGORIES
*/
CREATE PROC [dbo].[NORSP_BUSCAR_CATEGORIAS_CATEGORYNAME]
@CATEGORYNAME VARCHAR(10)
AS
SELECT C.CATEGORYID,C.CATEGORYNAME,PRODUCTNAME 
FROM CATEGORIES C
LEFT JOIN PRODUCTS P ON P.CATEGORYID=C.CATEGORYID 
WHERE  C.CATEGORYNAME=@CATEGORYNAME 
ORDER BY C.CATEGORYID
--SELECT * FROM PRODUCTS WHERE CATEGORYID=1
GO
/****** Object:  StoredProcedure [dbo].[NORSP_BUSCAR_CUSTOMERS_ANIO_NAME]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/*
NORSP_BUSCAR_CUSTOMERS_ANIO_NAME 1998,'Alfreds Futterkiste'
SELECT * FROM CUSTOMERS
*/
CREATE PROC [dbo].[NORSP_BUSCAR_CUSTOMERS_ANIO_NAME]
	@AÑO INT,@COMPANYNAME VARCHAR(30)
AS
SELECT DISTINCT O.ORDERID ,
FECHA_ORDEN=CONVERT(VARCHAR(10),O.ORDERDATE ,103),
FECHA_ENVIO=CONVERT(VARCHAR(10),O.SHIPPEDDATE ,103),
--DIAS_ENVIO = DAY(O.SHIPPEDDATE ) -DAY(O.ORDERDATE)
DIAS_ENVIO = DATEDIFF(DAY,ORDERDATE,SHIPPEDDATE)
  FROM ORDERS O 
  INNER JOIN [ORDER DETAILS] OD ON OD.ORDERID = O.ORDERID 
  INNER JOIN CUSTOMERS C ON C.CUSTOMERID = O.CUSTOMERID 
WHERE  YEAR(ORDERDATE)>=@AÑO 
	AND C.COMPANYNAME = @COMPANYNAME 
	AND O.ORDERID %2=0
ORDER BY O.ORDERID 
GO
/****** Object:  StoredProcedure [dbo].[NORSP_BUSCAR_CUSTOMERS_COMPANYNAME]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
NORSP_BUSCAR_CUSTOMERS_COMPANYNAME 'ALFREDS FUTTERKISTE'
*/
CREATE PROC [dbo].[NORSP_BUSCAR_CUSTOMERS_COMPANYNAME]
@COMPANYNAME VARCHAR(30)
AS
SELECT CUSTOMERID,COMPANYNAME FROM CUSTOMERS
WHERE COMPANYNAME LIKE @COMPANYNAME+'%'
GO
/****** Object:  StoredProcedure [dbo].[NORSP_BUSCAR_CUSTOMERS_CUSTOMERID]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
DROP PROC USP_CODCLIENTE
NORSP_BUSCAR_CUSTOMERS_CUSTOMERID ALFKI
*/
CREATE PROC [dbo].[NORSP_BUSCAR_CUSTOMERS_CUSTOMERID]
@CUSTOMERID VARCHAR(30)
AS
SELECT CUSTOMERID,COMPANYNAME AS COMPAÑIA,COUNTRY  AS CIUDAD
FROM CUSTOMERS WHERE  CUSTOMERID=@CUSTOMERID
GO
/****** Object:  StoredProcedure [dbo].[NORSP_BUSCAR_EMPLOYEES_CITY]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
NORSP_BUSCAR_EMPLOYEES_CITY 'Seattle'
SELECT *FROM EMPLOYEES E
*/
CREATE PROC [dbo].[NORSP_BUSCAR_EMPLOYEES_CITY]
@CITY  VARCHAR(10)
AS
SELECT EMPLEADOS= E.LASTNAME + SPACE(2)+ E.FIRSTNAME  
FROM EMPLOYEES E
 WHERE E.CITY=@CITY
GO
/****** Object:  StoredProcedure [dbo].[NORSP_BUSCAR_ORDENES_FECHA]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
SELECT * FROM CUSTOMERS
SELECT * FROM ORDERS WHERE ORDERDATE BETWEEN '1996-07-04'AND '1997-07-04'
[NORSP_BUSCAR_ORDENES_FECHA] '1996-07-04', '1997-07-04'
*/
CREATE PROC [dbo].[NORSP_BUSCAR_ORDENES_FECHA]
@FECHA1 DATETIME,@FECHA2 DATETIME
AS
SELECT O.ORDERID,COMPANYNAME,
	ORDERDATE=CONVERT(VARCHAR(10),O.ORDERDATE,103)
FROM ORDERS AS O
	INNER JOIN [ORDER DETAILS]  OD ON OD.ORDERID = O.ORDERID 
	INNER JOIN CUSTOMERS	   C ON C.CUSTOMERID = O.CUSTOMERID
WHERE ORDERDATE BETWEEN @FECHA1 AND @FECHA2 
	GROUP BY O.ORDERID,COMPANYNAME,O.ORDERDATE
GO
/****** Object:  StoredProcedure [dbo].[NORSP_BUSCAR_ORDENES_FECHA_ENTREGA]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
[NORSP_BUSCAR_ORDENES_FECHA_ENTREGA] '1996-07-04', '1997-07-04'
*/
CREATE PROC [dbo].[NORSP_BUSCAR_ORDENES_FECHA_ENTREGA]
@FECHA1 DATETIME,@FECHA2 DATETIME
AS
SELECT O.ORDERID ,
 FECHA_ENTREGA=CONVERT(VARCHAR(10) ,SHIPPEDDATE,101) ,
 DESTINATARIO=SHIPNAME ,
CANT_PRODUCTOS=SUM(QUANTITY)
FROM  ORDERS O 
INNER JOIN [ORDER DETAILS] OD ON OD.ORDERID =O.ORDERID 
WHERE  SHIPPEDDATE BETWEEN  @FECHA1 AND @FECHA2  
GROUP BY O.ORDERID,SHIPPEDDATE,SHIPNAME
GO
/****** Object:  StoredProcedure [dbo].[NORSP_BUSCAR_ORDENES_POR_ANIO]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/*
NORSP_BUSCAR_ORDENES_POR_ANIO 	1998
*/
CREATE PROC [dbo].[NORSP_BUSCAR_ORDENES_POR_ANIO]
@AÑO INT
AS
SELECT O.ORDERID,C.COMPANYNAME ,
ORDERDATE=CONVERT(VARCHAR(10),O.ORDERDATE,103),
TOTAL=SUM(OD.UNITPRICE*OD.QUANTITY )
FROM ORDERS O,[ORDER DETAILS] OD,CUSTOMERS C ,PRODUCTS P
WHERE O.ORDERID=OD.ORDERID AND O.CUSTOMERID =C.CUSTOMERID 
AND YEAR(O.ORDERDATE)=@AÑO 
GROUP BY O.ORDERID,C.COMPANYNAME ,ORDERDATE
ORDER BY O.ORDERID
GO
/****** Object:  StoredProcedure [dbo].[NORSP_BUSCAR_ORDENES_POR_ANIO_MES]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
NORSP_BUSCAR_ORDENES_POR_ANIO_MES 	1998,'ENERO'
SELECT DATENAME(MONTH ,ORDERDATE),* FROM ORDERS
*/
CREATE PROC [dbo].[NORSP_BUSCAR_ORDENES_POR_ANIO_MES]
	@AÑO INT, @MES VARCHAR(30)
AS
SELECT O.ORDERID, ORDERDATE=CONVERT(VARCHAR(10),O.ORDERDATE,103),
O.FREIGHT,SUM(OD.UNITPRICE *OD.QUANTITY )AS [VENTAS POR ORDEN],
COUNT(OD.ORDERID) AS [CANTIDAD_PROD]
FROM ORDERS O 
INNER JOIN  [ORDER DETAILS] OD ON OD.ORDERID=O.ORDERID 
WHERE YEAR(O.ORDERDATE)=@AÑO
  AND DATENAME(MONTH ,O.ORDERDATE)=@MES
GROUP BY O.ORDERID ,ORDERDATE,O.FREIGHT
	ORDER BY O.ORDERID 
GO
/****** Object:  StoredProcedure [dbo].[NORSP_BUSCAR_ORDERID]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[NORSP_BUSCAR_ORDERID]
@ORDERID VARCHAR(max)
AS
SELECT * FROM [ORDER DETAILS] 
WHERE ORDERID like @ORDERId +'%'
GO
/****** Object:  StoredProcedure [dbo].[NORSP_BUSCAR_ORDERS_CUSTOMERS]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
[NORSP_BUSCAR_ORDERS_CUSTOMERS] 'ALFKI'
SELECT * FROM CUSTOMERS ''
*/
CREATE PROC [dbo].[NORSP_BUSCAR_ORDERS_CUSTOMERS]
@CUSTOMERID CHAR(5)
AS
SELECT TOP 5 O.ORDERID,
	ORDERDATE=CONVERT(VARCHAR(10),ORDERDATE,103),
	SHIPPEDDATE=CONVERT(VARCHAR(10),SHIPPEDDATE,103),
	VENTA=SUM(UNITPRICE * QUANTITY) 
FROM ORDERS O
LEFT JOIN [ORDER DETAILS] OD ON  OD.ORDERID=O.ORDERID
	WHERE CUSTOMERID=@CUSTOMERID 
	GROUP BY O.ORDERID,ORDERDATE,SHIPPEDDATE 
	ORDER BY SUM(UNITPRICE * QUANTITY) DESC
GO
/****** Object:  StoredProcedure [dbo].[NORSP_BUSCAR_ORDERS_POR_CUSTOMERS]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
SELECT * FROM PRODUCTS 
SELECT * FROM CUSTOMERS 
[USP_PRODPORORDEN] 
NORSP_BUSCAR_PRODUCTS_POR_ORDERS 10248
NORSP_BUSCAR_ORDERS_POR_CUSTOMERS ALFKI
*/
CREATE PROC [dbo].[NORSP_BUSCAR_ORDERS_POR_CUSTOMERS]
@CUSTOMERID VARCHAR(30)
AS
SELECT ORDERID, ORDERDATE=CONVERT(VARCHAR(30),ORDERDATE,103),FREIGHT
FROM ORDERS O 
INNER JOIN CUSTOMERS C ON  C.CUSTOMERID=O.CUSTOMERID
	AND O.CUSTOMERID=@CUSTOMERID 
ORDER BY ORDERID
GO
/****** Object:  StoredProcedure [dbo].[NORSP_BUSCAR_ORDERS_POR_FECHAS]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
NORSP_BUSCAR_ORDERS_POR_FECHAS '1996-07-04','1997-01-01'
SELECT * FROM ORDERS
*/
CREATE PROC [dbo].[NORSP_BUSCAR_ORDERS_POR_FECHAS]
	@FECHAINICIAL SMALLDATETIME ,	@FECHAFINAL SMALLDATETIME 
AS
SELECT O.ORDERID ,C.COMPANYNAME ,
	ORDERDATE=CONVERT(VARCHAR(10),O.ORDERDATE,103),
	CANT_PRODUCTOS=COUNT(OD.PRODUCTID),
	VENTA_ORDEN=SUM(OD.UNITPRICE*OD.QUANTITY)
FROM ORDERS O
INNER JOIN CUSTOMERS C ON  C.CUSTOMERID=O.CUSTOMERID 
INNER JOIN [ORDER DETAILS] OD ON OD.ORDERID=O.ORDERID
	WHERE  O.ORDERDATE BETWEEN @FECHAINICIAL AND @FECHAFINAL
GROUP BY O.ORDERID ,C.COMPANYNAME ,O.ORDERDATE 
	ORDER BY VENTA_ORDEN DESC 
GO
/****** Object:  StoredProcedure [dbo].[NORSP_BUSCAR_ORDERS_POR_MES]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
NORSP_BUSCAR_ORDERS_POR_MES 'Julio'
SELECT  DATENAME(MONTH,ORDERDATE) FROM ORDERS
*/
CREATE PROCEDURE [dbo].[NORSP_BUSCAR_ORDERS_POR_MES]
@MES VARCHAR(20)
AS
SELECT O.ORDERID,DIAS=DATEDIFF(DAY,ORDERDATE,SHIPPEDDATE) ,
 SHIPCITY,TOTAL=SUM(QUANTITY * UNITPRICE)  ,
 CANT_PRODUCTOS=COUNT(PRODUCTID) 
FROM ORDERS O,[ORDER DETAILS] OD  WHERE O.ORDERID=OD.ORDERID
	AND DATENAME(MONTH,ORDERDATE)=@MES 
	AND YEAR(ORDERDATE)%2<>0 
GROUP BY O.ORDERID,ORDERDATE,SHIPPEDDATE,SHIPCITY
 ORDER BY TOTAL DESC
GO
/****** Object:  StoredProcedure [dbo].[NORSP_BUSCAR_ORDERS_POR_PRODUCTS]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/*
NORSP_BUSCAR_ORDERS_POR_PRODUCTS Chai
SELECT * FROM PRODUCTS
NORSP_BUSCAR_ORDERS_POR_CUSTOMERS
*/
CREATE PROC [dbo].[NORSP_BUSCAR_ORDERS_POR_PRODUCTS]
@PRODUCTNAME VARCHAR(20)
AS
SELECT O.ORDERID,C.COMPANYNAME ,
ORDERDATE=CONVERT(VARCHAR(10),O.ORDERDATE,103),
TOTAL=SUM(OD.UNITPRICE*OD.QUANTITY)
FROM ORDERS O
INNER JOIN [ORDER DETAILS] OD ON OD.ORDERID=O.ORDERID
INNER JOIN CUSTOMERS C ON C.CUSTOMERID =O.CUSTOMERID 
INNER JOIN PRODUCTS P ON P.PRODUCTID=OD.PRODUCTID
WHERE   P.PRODUCTNAME = @PRODUCTNAME 
	GROUP BY O.ORDERID,C.COMPANYNAME ,ORDERDATE
ORDER BY O.ORDERID
GO
/****** Object:  StoredProcedure [dbo].[NORSP_BUSCAR_PRODUCTS_ID]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
NORSP_BUSCAR_PRODUCTS_ID 1
NORSP_BUSCAR_PRODUCTS_ID 2
NORSP_BUSCAR_PRODUCTS_ID 3
NORSP_BUSCAR_PRODUCTS_ID 4
NORSP_BUSCAR_PRODUCTS_ID 5
*/
CREATE PROC [dbo].[NORSP_BUSCAR_PRODUCTS_ID]
@PRODUCTO INT
AS
IF  (@PRODUCTO=1)
BEGIN
	SELECT TOP 1 PRODUCTID,PRODUCTNAME,UNITPRICE FROM PRODUCTS 
	ORDER BY UNITPRICE DESC
END
IF  (@PRODUCTO=2)
BEGIN
	SELECT TOP 1 PRODUCTID,PRODUCTNAME,UNITPRICE FROM PRODUCTS 
	ORDER BY UNITPRICE ASC
END
IF  (@PRODUCTO=3)
BEGIN
	SELECT  PRODUCTID, PRODUCTNAME, UNITPRICE FROM PRODUCTS
	WHERE  UNITPRICE>(SELECT SUM(UNITPRICE)/COUNT(PRODUCTID) AS 'PROM' FROM PRODUCTS)
ORDER BY  UNITPRICE DESC
END
IF  (@PRODUCTO=4)
BEGIN
	SELECT  PRODUCTID, PRODUCTNAME, UNITPRICE FROM PRODUCTS
	WHERE  PRODUCTID%2=0
END
IF  (@PRODUCTO=5)
BEGIN
	SELECT PRODUCTID,PRODUCTNAME,UNITPRICE FROM PRODUCTS 
END

GO
/****** Object:  StoredProcedure [dbo].[NORSP_BUSCAR_PRODUCTS_ORDERID]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
SELECT * FROM PRODUCTS 
SELECT * FROM ORDERS 
NORSP_BUSCAR_PRODUCTS_ORDERID 10248
*/
CREATE PROC [dbo].[NORSP_BUSCAR_PRODUCTS_ORDERID]
@ORDERID INT
AS
SELECT P.PRODUCTID ,P.PRODUCTNAME,OD.UNITPRICE,OD.QUANTITY ,
SUM(OD.UNITPRICE*OD.QUANTITY)AS TOTAL
FROM ORDERS O
INNER JOIN [ORDER DETAILS] OD on  O.ORDERID=OD.ORDERID 
INNER JOIN  PRODUCTS P on P.PRODUCTID = OD.PRODUCTID
	WHERE  O.ORDERID=@ORDERID --AND  P.PRODUCTID =13
GROUP BY P.PRODUCTID,P.PRODUCTNAME,OD.UNITPRICE,OD.QUANTITY
	ORDER BY TOTAL

GO
/****** Object:  StoredProcedure [dbo].[NORSP_BUSCAR_PRODUCTS_ORDERID_TOTAL]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
NORSP_BUSCAR_PRODUCTS_ORDERID_TOTAL 1
SELECT * FROM PRODUCTS
SELECT * FROM VENTATOTALDEORDENESS9
*/
CREATE PROC [dbo].[NORSP_BUSCAR_PRODUCTS_ORDERID_TOTAL]
@PRODUCTID INT
AS
SELECT O.ORDERID,ORDERDATE=CONVERT(VARCHAR(10),ORDERDATE,103),
SHIPCITY,SUM(UNITPRICE*QUANTITY)AS [TOTAL POR ORDEN]
FROM [ORDER DETAILS] OD
INNER JOIN ORDERS O ON  OD.ORDERID=O.ORDERID
 WHERE PRODUCTID=@PRODUCTID 
 AND O.ORDERID%2=0
  GROUP BY O.ORDERID,ORDERDATE,SHIPCITY
HAVING SUM(UNITPRICE * QUANTITY)<(SELECT AVG(VENTATOTAL)FROM VENTATOTALDEORDENESS9)
ORDER BY [TOTAL POR ORDEN] DESC
GO
/****** Object:  StoredProcedure [dbo].[NORSP_BUSCAR_PRODUCTS_PAR]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
NORSP_BUSCAR_PRODUCTS_PAR  1
SELECT * FROM ORDERS
*/
CREATE PROC [dbo].[NORSP_BUSCAR_PRODUCTS_PAR]
@PRODUCTID INT
AS
SELECT O.ORDERID,ORDERDATE=CONVERT(VARCHAR(30),ORDERDATE,103),
SHIPCITY,TOTALPORORDEN=SUM(UNITPRICE*QUANTITY)
FROM [ORDER DETAILS] OD
INNER JOIN ORDERS O ON  O.ORDERID=OD.ORDERID
WHERE PRODUCTID=@PRODUCTID 
AND O.ORDERID%2=0 
GROUP BY O.ORDERID,ORDERDATE,SHIPCITY
HAVING SUM(UNITPRICE * QUANTITY)<(SELECT AVG(VENTATOTAL) FROM VENTATOTALDEORDENESS9)
GO
/****** Object:  StoredProcedure [dbo].[NORSP_BUSCAR_PRODUCTS_POR_CATEGORIES]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
NORSP_BUSCAR_PRODUCTS_POR_CATEGORIES Beverages
select * from categories
*/
CREATE PROC [dbo].[NORSP_BUSCAR_PRODUCTS_POR_CATEGORIES]
@CATEGORYNAME VARCHAR(30)
AS
SELECT PRODUCTID , PRODUCTNAME,UNITPRICE
FROM PRODUCTS P 
INNER JOIN CATEGORIES C ON  C.CATEGORYID=P.CATEGORYID
	AND	CATEGORYNAME='Beverages'
 ORDER BY PRODUCTID

GO
/****** Object:  StoredProcedure [dbo].[NORSP_BUSCAR_PRODUCTS_POR_CATEGORIES_STOCK]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
NORSP_BUSCAR_PRODUCTS_POR_CATEGORIES_STOCK 'Beverages',50
SELECT * FROM CATEGORIES
*/
CREATE PROC [dbo].[NORSP_BUSCAR_PRODUCTS_POR_CATEGORIES_STOCK] 
@CATEGORYNAME VARCHAR(20),
@STOCK INT
AS
SELECT C.CATEGORYNAME, P.CATEGORYID,P.PRODUCTID,PRODUCTNAME,UNITSINSTOCK 
FROM PRODUCTS P
INNER JOIN CATEGORIES C ON C.CATEGORYID=P.CATEGORYID 
WHERE C.CATEGORYNAME  = @CATEGORYNAME 
	 AND P.UNITSINSTOCK > @STOCK
	 ORDER BY P.UNITSINSTOCK DESC
GO
/****** Object:  StoredProcedure [dbo].[NORSP_BUSCAR_PRODUCTS_POR_ORDERS]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
SELECT * FROM PRODUCTS 
SELECT * FROM ORDERS 
[USP_PRODPORORDEN] 
NORSP_BUSCAR_PRODUCTS_POR_ORDERS 10248
*/
CREATE PROC [dbo].[NORSP_BUSCAR_PRODUCTS_POR_ORDERS] 
@ORDERID INT
AS
SELECT P.PRODUCTID ,P.PRODUCTNAME,OD.UNITPRICE,OD.QUANTITY ,
TOTAL= SUM(OD.UNITPRICE*OD.QUANTITY )
FROM ORDERS O
INNER JOIN [ORDER DETAILS] OD ON OD.ORDERID=O.ORDERID 
INNER JOIN PRODUCTS P ON P.PRODUCTID=OD.PRODUCTID 
AND  O.ORDERID=@ORDERID 
GROUP BY P.PRODUCTID,P.PRODUCTNAME,OD.UNITPRICE,OD.QUANTITY
ORDER BY TOTAL DESC
GO
/****** Object:  StoredProcedure [dbo].[NORSP_BUSCAR_PRODUCTS_PRODUCTID]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--------------------------------
/*
[NORSP_BUSCAR_PRODUCTS_PRODUCTID] 1
SELECT * FROM PRODUCTS
*/
CREATE PROC [dbo].[NORSP_BUSCAR_PRODUCTS_PRODUCTID]
@PRODUCTID INT 
AS
SELECT PRODUCTID, PRODUCTNAME,UNITPRICE,UNITSINSTOCK 
FROM PRODUCTS
WHERE PRODUCTID=@PRODUCTID
GO
/****** Object:  StoredProcedure [dbo].[NORSP_BUSCAR_REGION]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
SELECT * FROM TERRITORIES
NORSP_BUSCAR_REGION 1
*/
CREATE PROC [dbo].[NORSP_BUSCAR_REGION]
@REGIONID NVARCHAR(20)
AS
SELECT TERRITORYID ,TERRITORYDESCRIPTION 
FROM TERRITORIES
WHERE REGIONID=@REGIONID
ORDER BY TERRITORYID
GO
/****** Object:  StoredProcedure [dbo].[NORSP_EXEC_BUSCAR_EMPLOYEES_ORDERID]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/*
NORSP_EXEC_BUSCAR_EMPLOYEES_ORDERID '1'
NORSP_EXEC_BUSCAR_EMPLOYEES_ORDERID '1,2'
*/
CREATE PROC [dbo].[NORSP_EXEC_BUSCAR_EMPLOYEES_ORDERID]
@EMPLOYEEID VARCHAR(100)
AS
EXEC('
	SELECT EMPLOYEEID,O.ORDERID,
	TOTAL=(UNITPRICE *QUANTITY)
	FROM ORDERS O
	INNER JOIN [ORDER DETAILS] OD ON OD.ORDERID=O.ORDERID
	WHERE EMPLOYEEID IN('+@EMPLOYEEID+')
	ORDER BY EMPLOYEEID,O.ORDERID') 
GO
/****** Object:  StoredProcedure [dbo].[NORSP_EXEC_BUSCAR_LIMITE_REG_ORDENES]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/*
NORSP_EXEC_BUSCAR_LIMITE_REG_ORDENES 5,5
*/
CREATE PROC [dbo].[NORSP_EXEC_BUSCAR_LIMITE_REG_ORDENES]
@NUMREG INT,@CANTIDAD INT
AS
DECLARE @LIMITE VARCHAR(50)
IF(@NUMREG=0)
  	SET @LIMITE=""
ELSE
	SET @LIMITE="TOP "+ CONVERT(VARCHAR(50),@NUMREG)  
EXEC("SELECT "+ @LIMITE +" O.ORDERID,
	ORDERDATE=CONVERT(VARCHAR(10),ORDERDATE,103),
	SHIPPEDDATE=CONVERT(VARCHAR(10),SHIPPEDDATE,103),
	DIAS=DATEDIFF(DAY,ORDERDATE,SHIPPEDDATE) ,
	CANT_PRODUCTOS=COUNT(PRODUCTID) 
 FROM ORDERS O
 INNER JOIN [ORDER DETAILS] OD ON OD.ORDERID=O.ORDERID 
 WHERE YEAR(ORDERDATE)%2=0 
	AND MONTH(ORDERDATE)%2<>0 
 GROUP BY O.ORDERID,ORDERDATE,SHIPPEDDATE 
 HAVING COUNT(PRODUCTID)>"+ @CANTIDAD +" 
 ORDER BY CANT_PRODUCTOS DESC")
GO
/****** Object:  StoredProcedure [dbo].[NORSP_EXEC_BUSCAR_ORDERS_DETALLES]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/*
[NORSP_EXEC_BUSCAR_ORDERS_DETALLES] 10248
*/
CREATE PROC [dbo].[NORSP_EXEC_BUSCAR_ORDERS_DETALLES]
	@ORDERID VARCHAR(MAX)
AS
EXEC('
	SELECT O.ORDERID,P.PRODUCTID,P.PRODUCTNAME,OD.QUANTITY
	FROM [ORDER DETAILS] OD
INNER JOIN ORDERS O ON	  O.ORDERID=OD.ORDERID
INNER JOIN PRODUCTS P ON  P.PRODUCTID=OD.PRODUCTID
	WHERE OD.ORDERID IN ('+ @ORDERID  +') 
	ORDER BY OD.QUANTITY	DESC
	') 
GO
/****** Object:  StoredProcedure [dbo].[NORSP_EXEC_BUSCAR_ORDERS_PARES]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/*
Set Quoted_identifier off
NORSP_EXEC_BUSCAR_ORDERS_PARES  'ALFKI'
SELECT * FROM CUSTOMERS
*/
CREATE  PROC [dbo].[NORSP_EXEC_BUSCAR_ORDERS_PARES]
@CUSTOMERID VARCHAR(50) 
AS
EXEC('
SELECT  O.ORDERID, O.CUSTOMERID,
ORDERDATE=CONVERT(VARCHAR(10),ORDERDATE,103),
FREIGHT=CONVERT(VARCHAR(10),FREIGHT,103),
VENTASPORORDEN=SUM(OD.QUANTITY*OD.UNITPRICE) 
FROM ORDERS O
INNER JOIN [ORDER DETAILS] OD ON OD.ORDERID=O.ORDERID
INNER JOIN CUSTOMERS C  ON  C.CUSTOMERID=O.CUSTOMERID 
WHERE  O.ORDERID%2=0 
		AND C.CUSTOMERID IN ('+@CUSTOMERID+' )
GROUP BY O.ORDERID,O.CUSTOMERID ,ORDERDATE,O.FREIGHT 
ORDER BY  VENTASPORORDEN  DESC ')
GO
/****** Object:  StoredProcedure [dbo].[NORSP_EXEC_BUSCAR_PRODUCTS_FILTRO]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
SELECT * FROM PRODUCTS
NORSP_BUSCAR_PRODUCTS_FILTRO 'C'
SELECT PRODUCTID,PRODUCTNAME,UNITPRICE,CATEGORYID FROM PRODUCTS
NORSP_BUSCAR_CUSTOMERS_FILTRO
*/
CREATE PROC [dbo].[NORSP_EXEC_BUSCAR_PRODUCTS_FILTRO]
@LETRAS VARCHAR(MAX)
AS
EXEC('SELECT PRODUCTID,PRODUCTNAME,UNITPRICE,CATEGORYID 
FROM PRODUCTS
 WHERE LEFT(PRODUCTNAME,1) IN('+@LETRAS+')
ORDER BY PRODUCTID')
GO
/****** Object:  StoredProcedure [dbo].[NORSP_EXEC_BUSCAR_PRODUCTS_PRODUCTID]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
NORSP_EXEC_BUSCAR_PRODUCTS_PRODUCTID '1,2'
NORSP_EXEC_BUSCAR_PRODUCTS_PRODUCTID '1,2,3,4'
*/
CREATE PROCEDURE [dbo].[NORSP_EXEC_BUSCAR_PRODUCTS_PRODUCTID]
@PRODUCTID VARCHAR(100)
AS
EXEC('SELECT O.ORDERID,
ORDERDATE=CONVERT(VARCHAR(10),ORDERDATE,103),
AÑO=YEAR(ORDERDATE) ,MES=DATENAME(MONTH,ORDERDATE),
 VENTAPORPEDIDO=SUM(UNITPRICE*QUANTITY) 
 FROM ORDERS O
 INNER JOIN [ORDER DETAILS] OD ON OD.ORDERID=O.ORDERID 
 WHERE O.ORDERID%2=0 
 AND MONTH(ORDERDATE)%2=1 AND YEAR(ORDERDATE)%2=0 
 AND PRODUCTID IN('+@PRODUCTID+')
 GROUP BY O.ORDERID,ORDERDATE 
 ORDER BY VENTAPORPEDIDO DESC')
GO
/****** Object:  StoredProcedure [dbo].[NORSP_EXEC_LISTAR_PRODUCTOS]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/*
SELECT * FROM PRODUCTS
SELECT * FROM PRODUCTS
NORSP_EXEC_LISTAR_PRODUCTOS '0','1,2,3',50
*/
CREATE PROC [dbo].[NORSP_EXEC_LISTAR_PRODUCTOS]
@PROD VARCHAR(100),@TOTAL INT,@VAR CHAR(1)
AS
IF (@VAR='0')
EXEC("SELECT O.ORDERID,ORDERDATE=CONVERT(VARCHAR(10),O.ORDERDATE ,103),
AÑO=YEAR(O.ORDERDATE),MES=DATENAME(MONTH,O.ORDERDATE),
VENTAPORPEDIDO=SUM(OD.QUANTITY*OD.UNITPRICE)
FROM ORDERS O
LEFT JOIN [ORDER DETAILS] OD ON OD.ORDERID = O.ORDERID
	WHERE OD.PRODUCTID IN(" + @PROD +")
GROUP BY O.ORDERID,O.ORDERDATE
HAVING SUM(OD.QUANTITY*OD.UNITPRICE) > "+ @TOTAL+" ")
ELSE IF (@VAR='1')
EXEC("SELECT O.ORDERID,O.ORDERDATE,YEAR(O.ORDERDATE),DATENAME(MONTH,O.ORDERDATE),
VENTAPORPEDIDO=SUM(OD.QUANTITY*OD.UNITPRICE)
FROM ORDERS O
LEFT JOIN [ORDER DETAILS] OD ON OD.ORDERID = O.ORDERID
	WHERE OD.PRODUCTID IN(" + @PROD +")
GROUP BY O.ORDERID,O.ORDERDATE
HAVING SUM(OD.QUANTITY*OD.UNITPRICE)< "+ @TOTAL+" ")
ELSE IF (@VAR='2')
EXEC("SELECT O.ORDERID,O.ORDERDATE,YEAR(O.ORDERDATE),DATENAME(MONTH,O.ORDERDATE),
VENTAPORPEDIDO=SUM(OD.QUANTITY*OD.UNITPRICE)
FROM ORDERS O
LEFT JOIN [ORDER DETAILS] OD ON OD.ORDERID = O.ORDERID
	WHERE OD.PRODUCTID IN(" + @PROD +")
GROUP BY O.ORDERID,O.ORDERDATE
HAVING SUM(OD.QUANTITY*OD.UNITPRICE)> "+ @TOTAL+" ")
GO
/****** Object:  StoredProcedure [dbo].[NORSP_FILTRAR_CATEGORIES]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
DROP PROC [USP_CATEGORIASLETRAS] 'CON'
NORSP_FILTRAR_EMPLOYEES 'N'
*/
CREATE PROC [dbo].[NORSP_FILTRAR_CATEGORIES]
@LETRA VARCHAR(10)
AS 
SELECT CATEGORYID,CATEGORYNAME
FROM CATEGORIES 
WHERE CATEGORYNAME LIKE '['+@LETRA+']%'
--SELECT * FROM CATEGORIES WHERE CATEGORYNAME LIKE @LETRA+'%'
--SELECT * FROM CATEGORIES WHERE CATEGORYNAME LIKE 'B%'
GO
/****** Object:  StoredProcedure [dbo].[NORSP_FILTRAR_CUSTOMERS_ANIO_COMPANYNAME]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/*
NORSP_FILTRAR_CUSTOMERS_ANIO_COMPANYNAME '1998','B'

*/
CREATE PROC [dbo].[NORSP_FILTRAR_CUSTOMERS_ANIO_COMPANYNAME]
@AÑO INT,@LETRA VARCHAR(50)
AS
SELECT DISTINCT  COMPANYNAME
 FROM CUSTOMERS C
 INNER JOIN ORDERS O ON O.CUSTOMERID= C.CUSTOMERID 
 WHERE  YEAR(O.ORDERDATE)=@AÑO
 AND COMPANYNAME LIKE '['+@LETRA+']%'
GO
/****** Object:  StoredProcedure [dbo].[NORSP_FILTRAR_EMPLOYEES]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
NORSP_FILTRAR_EMPLOYEES 'N'
*/
CREATE PROCEDURE [dbo].[NORSP_FILTRAR_EMPLOYEES]
@EMPLEADO VARCHAR(100)
AS
SELECT EMPLEADO=FIRSTNAME+SPACE(2)+LASTNAME ,EMPLOYEEID 
FROM EMPLOYEES 
WHERE FIRSTNAME+SPACE(2)+LASTNAME LIKE @EMPLEADO +'%'
ORDER BY EMPLEADO
GO
/****** Object:  StoredProcedure [dbo].[NORSP_Final01]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROC [dbo].[NORSP_Final01]
AS
DECLARE @P MONEY
SET @P=(SELECT SUM(UNITPRICE*UNITSINSTOCK)*100 FROM PRODUCTS)
SELECT C.CATEGORYID , CATEGORYNAME ,
PORCENTAJE=CONVERT(VARCHAR(20),((SUM( UNITSINSTOCK)*100)/@P)) +SPACE(2)+'%'
FROM CATEGORIES C, PRODUCTS P ,ORDERS O,  [ORDER DETAILS] OD
 WHERE C.CATEGORYID=P.CATEGORYID AND O.ORDERID=OD.ORDERID
GROUP BY  C.CATEGORYID , CATEGORYNAME ORDER BY   C.CATEGORYID
GO
/****** Object:  StoredProcedure [dbo].[NORSP_Final02]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROC [dbo].[NORSP_Final02]
@CATEGORIA VARCHAR(100) 
AS
EXEC('
SELECT PRODUCTID,PRODUCTNAME,P.CATEGORYID,UNITSINSTOCK,UNITPRICE
FROM CATEGORIES C, PRODUCTS P 
WHERE C.CATEGORYID=P.CATEGORYID AND
	C.CATEGORYID IN ('+ @CATEGORIA +')
GROUP BY  PRODUCTID , PRODUCTNAME ,P.CATEGORYID,UNITSINSTOCK,UNITPRICE
ORDER BY   PRODUCTID ')
GO
/****** Object:  StoredProcedure [dbo].[NORSP_Final03]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROC [dbo].[NORSP_Final03]
@PRODUCTID INT ,@UNITSINSTOCK INT, @UNITPRICE MONEY
AS 
UPDATE PRODUCTS SET 
UNITSINSTOCK=@UNITSINSTOCK,UNITPRICE=@UNITPRICE
WHERE PRODUCTID=@PRODUCTID
GO
/****** Object:  StoredProcedure [dbo].[NORSP_LISTAR_CATEGORIAS]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[NORSP_LISTAR_CATEGORIAS]
AS
SELECT CATEGORYID,CATEGORYNAME,[DESCRIPTION],PICTURE FROM CATEGORIES
GO
/****** Object:  StoredProcedure [dbo].[NORSP_LISTAR_CATEGORIAS_CANTIDAD]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
NORSP_LISTAR_CUSTOMERS
SELECT * FROM SUPPLIERS
SELECT * FROM PRODUCTS
*/
---------------------------------------------
CREATE PROCEDURE [dbo].[NORSP_LISTAR_CATEGORIAS_CANTIDAD]
AS
SELECT S.SUPPLIERID,COMPANYNAME,COUNT(CATEGORYID) AS CANTIDAD
FROM SUPPLIERS S
LEFT JOIN PRODUCTS P ON P.SUPPLIERID = S.SUPPLIERID

GROUP BY S.SUPPLIERID,COMPANYNAME
GO
/****** Object:  StoredProcedure [dbo].[NORSP_LISTAR_CATEGORIAS_CATEGORYNAME]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[NORSP_LISTAR_CATEGORIAS_CATEGORYNAME]
AS
SELECT CATEGORYNAME FROM CATEGORIES
GO
/****** Object:  StoredProcedure [dbo].[NORSP_LISTAR_CLIENTES_PRODUCTOS_POR_ANIO]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--	LISTA DE CLIENTES QUE HAN COMPRADO UN PRODUCTO
--	EN UN AÑO ESPECIFICO
/*
SELECT * FROM CUSTOMERS
SELECT * FROM ORDERS
SELECT * FROM [ORDER DETAILS]
SELECT * FROM PRODUCTS
NORSP_LISTAR_CLIENTES_PRODUCTOS_POR_ANIO 1,1996
*/
CREATE PROC [dbo].[NORSP_LISTAR_CLIENTES_PRODUCTOS_POR_ANIO]
@PRODUCTID INT,@AÑO INT
AS
	SELECT C.CUSTOMERID, COMPANYNAME
	FROM CUSTOMERS C 
	LEFT JOIN ORDERS O ON O.CUSTOMERID=C.CUSTOMERID
	LEFT JOIN [ORDER DETAILS] OD ON OD.ORDERID=O.ORDERID
	LEFT JOIN PRODUCTS P ON P.PRODUCTID=OD.PRODUCTID
	WHERE  YEAR(O.ORDERDATE)=@AÑO
	AND P.PRODUCTID=@PRODUCTID
GO
/****** Object:  StoredProcedure [dbo].[NORSP_LISTAR_CUSTOMERS]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
NORSP_LISTAR_CUSTOMERS
*/
CREATE PROCEDURE [dbo].[NORSP_LISTAR_CUSTOMERS]
AS
SELECT	DISTINCT(COUNTRY), 
      CONTACTNAME, COMPANYNAME,  CITY,REGION
FROM CUSTOMERS
GROUP BY COUNTRY,CONTACTNAME, COMPANYNAME, CITY,REGION
--		SELECT * FROM CUSTOMERS ORDER BY COUNTRY
GO
/****** Object:  StoredProcedure [dbo].[NORSP_LISTAR_CUSTOMERS_CIUDAD]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  PROC [dbo].[NORSP_LISTAR_CUSTOMERS_CIUDAD]
AS
select CustomerID ,CompanyName , City FROM Customers 
GO
/****** Object:  StoredProcedure [dbo].[NORSP_LISTAR_CUSTOMERS_COMPANYNAME]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[NORSP_LISTAR_CUSTOMERS_COMPANYNAME]
AS
SELECT CUSTOMERID,COMPANYNAME FROM CUSTOMERS
GO
/****** Object:  StoredProcedure [dbo].[NORSP_LISTAR_CUSTOMERS_PAIS]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
[NORSP_LISTAR_CUSTOMERS_PAIS] 'MEXICO'
SELECT * FROM CUSTOMERS
2. MOSTRAR LOS CLIENTES POR PAIS
*/

CREATE PROCEDURE [dbo].[NORSP_LISTAR_CUSTOMERS_PAIS]
@COUNTRY VARCHAR(30)
AS
SELECT CUSTOMERID, COMPANYNAME 
FROM CUSTOMERS
WHERE COUNTRY=@COUNTRY
GO
/****** Object:  StoredProcedure [dbo].[NORSP_LISTAR_CUSTOMERS_PAISES]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
[NORSP_LISTAR_CUSTOMERS_COUNTRY]
SELECT * FROM CUSTOMERS ''		ALTER
*/
CREATE PROCEDURE [dbo].[NORSP_LISTAR_CUSTOMERS_PAISES]
AS
SELECT DISTINCT UPPER(COUNTRY) AS [COUNTRY] FROM CUSTOMERS
GO
/****** Object:  StoredProcedure [dbo].[NORSP_LISTAR_EMPLOYEES_CITY]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[NORSP_LISTAR_EMPLOYEES_CITY]
AS
SELECT CITY=UPPER(CITY) FROM EMPLOYEES E
GO
/****** Object:  StoredProcedure [dbo].[NORSP_LISTAR_EMPLOYEES_PORCENTAJE]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*

*/
CREATE PROC [dbo].[NORSP_LISTAR_EMPLOYEES_PORCENTAJE]
AS
-----------------------------------------------------------
DECLARE @POR MONEY
SET @POR=(SELECT SUM(UNITPRICE*QUANTITY) FROM [ORDER DETAILS])
-----------------------------------------------------------
SELECT E.EMPLOYEEID ,LASTNAME ,CANT_ORDENES=COUNT(O.ORDERID),
TOTAL=SUM( UNITPRICE *QUANTITY),
PORCENTAJE= CONVERT(VARCHAR(10),((SUM( UNITPRICE *QUANTITY)*100)/@POR)) +SPACE(2)+'%'
FROM EMPLOYEES E
INNER JOIN ORDERS O ON  O.EMPLOYEEID= E.EMPLOYEEID 
INNER JOIN [ORDER DETAILS] OD ON OD.ORDERID=O.ORDERID
--WHERE  E.EMPLOYEEID = @VALOR
GROUP BY  E.EMPLOYEEID ,LASTNAME ORDER BY E.EMPLOYEEID

GO
/****** Object:  StoredProcedure [dbo].[NORSP_LISTAR_ORDENES]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
SELECT * FROM PRODUCTS
SELECT * FROM ORDERS
SELECT * FROM [ORDER DETAILS]
*/
CREATE PROC [dbo].[NORSP_LISTAR_ORDENES]
AS
-------------------------------------
--DECLARE @DISCOUNT DECIMAL(18,2)
--SET	@DISCOUNT=(SELECT CONVERT(DECIMAL(18,2),[DISCOUNT]) FROM  [ORDER DETAILS] )
-------------------------------------
SELECT OD.[ORDERID], [PRODUCTNAME], OD.[UNITPRICE], OD.[QUANTITY],
	DISCOUNT=CONVERT(DECIMAL(18,2),[DISCOUNT])--+SPACE(1)+'%'
 FROM ORDERS O
INNER JOIN [ORDER DETAILS] OD ON OD.ORDERID=O.[ORDERID]
INNER JOIN PRODUCTS P ON P.PRODUCTID=OD.PRODUCTID
GO
/****** Object:  StoredProcedure [dbo].[NORSP_LISTAR_ORDERID]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[NORSP_LISTAR_ORDERID]
AS
SELECT ORDERID FROM ORDERS
GO
/****** Object:  StoredProcedure [dbo].[NORSP_LISTAR_ORDERS_ANIOS]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  PROC [dbo].[NORSP_LISTAR_ORDERS_ANIOS]
AS
SELECT DISTINCT YEAR(ORDERDATE)AS ANIO FROM  ORDERS
GO
/****** Object:  StoredProcedure [dbo].[NORSP_LISTAR_PRODUCTOS_PROVEEDOR]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
NORSP_LISTAR_PRODUCTOS_PROVEEDOR 2
*/

CREATE PROCEDURE [dbo].[NORSP_LISTAR_PRODUCTOS_PROVEEDOR]
@IDPROVEEDOR VARCHAR(2)
AS
SELECT --P.PRODUCTID,S.SUPPLIERID,
COMPANYNAME,
UNITPRICE=SUM(UNITPRICE),
 DISCONTINUED =CONVERT(DECIMAL(18,2),DISCONTINUED)
 FROM PRODUCTS P
 LEFT JOIN SUPPLIERS S  ON S.SUPPLIERID=P.SUPPLIERID
  WHERE S.SUPPLIERID = @IDPROVEEDOR
  -- AND UNITPRICE >(SELECT AVG(UNITPRICE) FROM PRODUCTS)  
   GROUP BY COMPANYNAME,DISCONTINUED
 
--   SELECT * FROM SUPPLIERS
GO
/****** Object:  StoredProcedure [dbo].[NORSP_LISTAR_PRODUCTS]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[NORSP_LISTAR_PRODUCTS]
AS
SELECT PRODUCTID, PRODUCTNAME
		FROM PRODUCTS
GO
/****** Object:  StoredProcedure [dbo].[NORSP_LISTAR_PRODUCTS_ORDERS]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
SELECT * FROM ORDERS
NORSP_LISTAR_PRODUCTS_ORDERS '10248'
*/
CREATE PROC [dbo].[NORSP_LISTAR_PRODUCTS_ORDERS]
@ORDERID INT
AS
SELECT P.PRODUCTID,P.PRODUCTNAME,OD.UNITPRICE,OD.QUANTITY,
TOTAL=SUM(OD.UNITPRICE*OD.QUANTITY )
FROM PRODUCTS AS P
LEFT JOIN[ORDER DETAILS]  OD  ON OD.PRODUCTID=P.PRODUCTID 
	WHERE  OD.ORDERID=@ORDERID
	GROUP BY P.PRODUCTID,P.PRODUCTNAME,OD.UNITPRICE,OD.QUANTITY
	ORDER BY TOTAL DESC
GO
/****** Object:  StoredProcedure [dbo].[NORSP_LISTAR_PRODUCTS_SUPPLIERS]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
NORSP_LISTAR_PRODUCTS_SUPPLIERS '1'
SELECT * FROM Products
SELECT * FROM Suppliers
*/
CREATE PROCEDURE [dbo].[NORSP_LISTAR_PRODUCTS_SUPPLIERS]
@SUPPLIERID VARCHAR(100)
AS
EXEC('
SELECT PRODUCTID,S.SUPPLIERID,COMPANYNAME,UNITPRICE, DISCONTINUED 
FROM PRODUCTS P
LEFT JOIN SUPPLIERS S ON S.SUPPLIERID=P.SUPPLIERID
WHERE UNITPRICE >(SELECT AVG(UNITPRICE) FROM PRODUCTS)
 AND  S.SUPPLIERID IN('+@SUPPLIERID+')')
GO
/****** Object:  StoredProcedure [dbo].[NORSP_LISTAR_PRODUCTS_VENDIDOS_POR_ANIO]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
[NORSP_LISTAR_PRODUCTS_VENDIDOS_POR_ANIO] 1998
SELECT * FROM PRODUCTS
SELECT * FROM ORDERS
SELECT * FROM [ORDER DETAILS]			CREATE
*/
CREATE PROC [dbo].[NORSP_LISTAR_PRODUCTS_VENDIDOS_POR_ANIO] 
@AÑO INT ,--=1990,
@CANTIDAD INT =0
AS
SELECT P.PRODUCTID ,PRODUCTNAME ,SUM(QUANTITY)AS CANTIDADVENDIDA
 FROM PRODUCTS P 
  LEFT JOIN [ORDER DETAILS] OD ON OD.PRODUCTID=P.PRODUCTID --AND OD.ORDERID = O.ORDERID 
  LEFT JOIN ORDERS O ON O.ORDERID = OD.ORDERID 
 WHERE  YEAR(O.ORDERDATE)=@AÑO
 GROUP BY P.PRODUCTID,PRODUCTNAME 
 HAVING  SUM(QUANTITY)> @CANTIDAD 
 ORDER BY P.PRODUCTID ASC
GO
/****** Object:  StoredProcedure [dbo].[NORSP_LISTAR_REGION]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
SELECT * FROM REGION
NORSP_LISTAR_PRODUCTS
*/
CREATE PROC [dbo].[NORSP_LISTAR_REGION]
AS
SELECT REGIONID AS C1,REGIONDESCRIPTION AS C2 FROM REGION
GO
/****** Object:  StoredProcedure [dbo].[NORSP_LISTAR_SUPPLIERS]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
NORSP_LISTAR_SUPPLIERS
GO
DROP PROC [LISTARCUSTOMERS]
*/
 CREATE PROCEDURE [dbo].[NORSP_LISTAR_SUPPLIERS]
AS
SELECT DISTINCT(COUNTRY), 
  CONTACTNAME, COMPANYNAME, CITY,REGION
FROM SUPPLIERS
GROUP BY COUNTRY,CONTACTNAME, COMPANYNAME, CITY,REGION

GO
/****** Object:  StoredProcedure [dbo].[NORSP_LISTAR_TERRITORIES]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
NORSP_LISTAR_TERRITORIES '01581'
SP_HELP TERRITORIES
*/
CREATE PROC [dbo].[NORSP_LISTAR_TERRITORIES]
@REGIONID NVARCHAR(40)
AS
SELECT TERRITORYID,TERRITORYDESCRIPTION FROM TERRITORIES
WHERE REGIONID=@REGIONID
GO
/****** Object:  StoredProcedure [dbo].[NORSP_ORDERS_MESES]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[NORSP_ORDERS_MESES]
AS
SELECT DISTINCT DATENAME(MONTH,ORDERDATE) AS MESES FROM ORDERS
GO
/****** Object:  StoredProcedure [dbo].[NORSP_PARCIAL01_LISTAR_CLIENTE]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
SELECT * FROM ORDERS
SELECT * FROM [ORDER DETAILS]
SELECT * FROM CUSTOMERS
NORSP_PARCIAL01_LISTAR_CLIENTE 'Alfreds Futterkiste','1996-07-04','1996-07-30'
*/
CREATE PROC [dbo].[NORSP_PARCIAL01_LISTAR_CLIENTE]
	@CLIENTE VARCHAR(30),@FECHA_INICIO VARCHAR(10),	@FECHA_FINAL VARCHAR(10)
AS
SELECT O.ORDERID,O.SHIPPEDDATE,
TOTALVENTA=SUM(OD.UNITPRICE*OD.QUANTITY),
DIASENVIO=DATEDIFF(D,O.ORDERDATE,O.SHIPPEDDATE),
ESTADO_ENVIO=
CASE 
	WHEN(DATEDIFF(D,O.ORDERDATE,O.SHIPPEDDATE)>=10)
		THEN	'FUERA DE FECHA' 
	ELSE 
				'ENTREGA INMEDIATA'
	END
FROM ORDERS AS O
	LEFT JOIN [ORDER DETAILS] OD ON OD.ORDERID=O.ORDERID
	LEFT JOIN CUSTOMERS  C  ON C.CUSTOMERID=O.CUSTOMERID
WHERE C.COMPANYNAME=@CLIENTE 
	AND ORDERDATE BETWEEN @FECHA_INICIO AND @FECHA_FINAL
	GROUP BY O.ORDERID,O.SHIPPEDDATE,DATEDIFF("D",O.ORDERDATE,O.SHIPPEDDATE) 
GO
/****** Object:  StoredProcedure [dbo].[NORSP_PIVOT]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
NORSP_PIVOT	'1'
NORSP_PIVOT	'2'
SELECT * FROM Products
SELECT * FROM [Order Details]
SELECT * FROM Orders

SELECT * FROM CUSTOMERS
SELECT * FROM EMPLOYEES
SELECT * FROM CATEGORIES

*/
CREATE PROC [dbo].[NORSP_PIVOT]
@INDICADOR CHAR(1)
AS
---------------------------------------------------------------------------------------------------------------
IF(@INDICADOR='1')
BEGIN				--	PRODUCTOS X MESES	
	-----------------------------------------------------------------------------------------------------------
	SELECT Producto, [1] Ene, [2] Feb, [3] Mar, [4] Abr, [5] May,[6] Jun, [7] Jul, [8] Ago, [9] Sep, [10] Oct, [11] Nov, [12] Dic 
	FROM 
	(  -- select inicial, a pivotar. Podría ser una tabla
	SELECT P.ProductName 'Producto', month(O.OrderDate) 'Mes', D.Quantity 'Cantidad'
	FROM [Order Details] D 
	inner join Orders O ON D.OrderID = O.OrderID
	inner join Products P ON D.ProductID = P.ProductID
    WHERE O.OrderDate between '19970101' and '19971231'
    )
   V PIVOT ( sum(Cantidad) FOR Mes IN ([1], [2], [3], [4], [5],  [6], [7], [8], [9], [10], [11], [12]) ) AS PT
   ------------------------------------------------------------------------------------------------------------
END
---------------------------------------------------------------------------------------------------------------
IF(@INDICADOR='2')
BEGIN	
------------------------------------------------------------------------------------------------------------
	SELECT Empleado, [Alice Mutton],ISNULL([Filo Mix],0) [Filo Mix],[Flotemysost],[Geitost],[Konbu], [Maxilaku],[Pavlova],[Tofu],[Vegie-spread]	
	FROM 
	(
	SELECT Empleado, 
		  (SELECT PRoducts.Productname FROM Products  WHERE Products.Productid=Ventas.Productid)'Producto',
		  SUM (ventas.ValorVendido) 'Total'
	  ------------------------------------------------------------------------------------------------------------			
		FROM (
		-------------------------------------------------------------------------------------------------------------------------------------------------
		SELECT (E.lastname+ space(1) + E.firstname) 'Empleado', ProductID 'ProductID', (OD.Unitprice*OD.Quantity) 'ValorVendido' FROM [Order Details] OD
        -------------------------------------------------------------------------------------------------------------------------------------------------
            INNER JOIN (
						[Orders] O INNER JOIN Employees E ON O.EmployeeID=E.EmployeeID
						)
						ON OD.OrderID=O.OrderID
			) Ventas	--Where Empleado='Buchaman Steven' and ProductID='31'
	GROUP BY Empleado,Productid)ventas1 
	PIVOT(SUM(total) FOR [Producto] IN ([Alice Mutton],[Filo Mix],[Flotemysost],[Geitost],[Konbu],[Maxilaku],[Pavlova],[Tofu],[Vegie-spread])) AS pvt
------------------------------------------------------------------------------------------------------------
END
---------------------------------------------------------------------------------------------------------------


GO
/****** Object:  StoredProcedure [dbo].[NORSP_Porcentaje]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[NORSP_Porcentaje]
as       
SELECT  c.CategoryId,c.CategoryName ,Porcentaje=
convert(CHAR(5),convert(DECIMAL(18,2),round((sum(p.UnitsInStock)*100.0) /
(SELECT sum(UnitsInStock) FROM  Products),2))) + '% ' 
FROM Products p,Categories  c WHERE p.CategoryID=c.CategoryID 
GROUP BY c.CategoryID,c.CategoryName 
GO
/****** Object:  StoredProcedure [dbo].[NORSP_PRODUCTS_INSERT]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[NORSP_PRODUCTS_INSERT]
	@NOM VARCHAR(50),	@PRECIO MONEY,	@STOCK INT,	@CAT INT
AS
SET NOCOUNT ON
BEGIN TRANSACTION	-- INICIO DE TRANSACCION
---------------------------------------------------------------------
	INSERT PRODUCTS(PRODUCTNAME,CATEGORYID,UNITPRICE,UNITSINSTOCK)
	VALUES (@NOM,@CAT,@PRECIO,@STOCK)
IF(@@ERROR<>0)
BEGIN
ROLLBACK TRANSACTION
SET NOCOUNT OFF
---------------------------------------------------------------------
SELECT EXITO=0,
	   MENSAJE='ERROR AL GRABAR'
RETURN
END
ELSE
COMMIT TRANSACTION	--	TERMINO DE LA TRANSACCION
---------------------------------------------------------------------
SELECT EXITO=@@IDENTITY,
	   MENSAJE='GRABADO SATISFACTORIAMENTE'
SET NOCOUNT OFF
GO
/****** Object:  StoredProcedure [dbo].[NORSP_REGISTROS]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE  PROC [dbo].[NORSP_REGISTROS]
@CANT INT ,
@AÑO INT
AS
EXEC('SELECT TOP '+ @CANT +'
C.CUSTOMERID,C.COMPANYNAME,C.CONTACTNAME ,
CANTIDADPEDIDOS=COUNT(C.CUSTOMERID)
FROM CUSTOMERS C,ORDERS O
WHERE O.CUSTOMERID =C.CUSTOMERID AND
YEAR(O.ORDERDATE)= '+@AÑO+'
GROUP BY C.CUSTOMERID,C.COMPANYNAME,C.CONTACTNAME
ORDER BY CANTIDADPEDIDOS  DESC ')
GO
/****** Object:  StoredProcedure [dbo].[PR_crosstab]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
---Creamos el procedimiento almacenado.
/*
EXEC PR_crosstab TABLA , CAMPO PIVOT , CAMPO O CAMPOS AGRUPACION , CAMPO A CALCULAR , , TIPO DE CALCULO (AVG, COUNT, MAX, ETC)
PR_crosstab 'Products','sum(Cantidad)','productname','productname','sum'
select * from employees
*/
CREATE PROCEDURE [dbo].[PR_crosstab]
@TABLA varchar(max),
@PIVOT VARCHAR(max),
@AGRUPACION varchar(max),
@CAMPO varchar(max),
@CALCULO varchar(max)
AS
--Declaramos las variables que nos permitirán crear el sql con los "CASES"
DECLARE @STRG AS VARCHAR(max) DECLARE @SQL AS VARCHAR(max) CREATE TABLE #PIVOT ( [PIVOT] VARCHAR (max) )
-- limpiamos las variables por si a caso
SET @STRG='' SET @SQL=''
-- ALMA MATTER DEL PIVOT TABLE
/* En el siguiente código realizamos un "select distinct" del campo que usaremos como pivote, a cada registro le concatenamos su 
correspondiente "CASE" y lo almacenamos en una tabla temporal llamada #PIVOT
*/
SET @STRG=@STRG + 'INSERT INTO #PIVOT 
	SELECT DISTINCT ''' + @CALCULO + '(CASE WHEN ' + @PIVOT + '=''''''+ RTRIM(CAST(' + @PIVOT + ' AS VARCHAR(500))) + '''''' THEN ' + 
	@CAMPO + ' ELSE NULL END) AS ''''' + @CALCULO + '_'' + RTRIM(CAST(' + @PIVOT + ' AS VARCHAR(500))) + '''''', '' AS [PIVOT]
	FROM ' + @TABLA + ' WHERE ' + @PIVOT + ' IS NOT NULL' EXECUTE (@STRG) /*
--el sql dinámico de más arriba genera un script similar a éste,
-- (cambia según los parámetros que se ingresen) 
INSERT INTO #PIVOT
SELECT DISTINCT 'AVG(CASE WHEN campo_pivote=''' + RTRIM(CAST(campo_pivote AS VARCHAR(500))) + ''' THEN precio ELSE 0 END) AS ''' +
RTRIM(CAST(campo_pivote AS VARCHAR(500))) + ''',' AS PIVOT
FROM tu_tabla WHERE campo_pivote IS NOT NULL 
--Con el cual se obtienen los valores de los registros que queremos que se conviertan en campos de nuestra nueva tabla. 
--A continuación generamos la consulta final, donde seleccionamos las columnas según la tabla #PIVOT y realizamos la agrupación correspondiente. 
*/ 
SET @SQL ='SELECT '	SELECT @SQL= @SQL + RTRIM(convert(varchar(max), [pivot]))	FROM #PIVOT ORDER BY [PIVOT]
---------------------------------------------------------------------------------------------------------------------
IF @AGRUPACION<>'*'
BEGIN
	SET @SQL=@SQL + @AGRUPACION + ' FROM ' + @TABLA + ' GROUP BY ' + @AGRUPACION
END
ELSE
BEGIN
	SET @SQL=@SQL + '''TODOS'' AS T FROM ' + @TABLA
END   
/* Ejecutamos la consulta, si quieres ver como queda, cambia el: EXECUTE(@SQL) por PRINT(@SQL) */ 
---------------------------------------------------------------------------------------------------------------------
PRINT (@SQL)
EXECUTE (@SQL) 
/* OJO: Si la consulta resultante en @SQL tiene más de 8000 caracteres el script dará un error ya que el sql no quedará completo  . */ 
-- FIN DE SP
GO
/****** Object:  StoredProcedure [dbo].[PUBSSP_byroyalty]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[PUBSSP_byroyalty] @percentage int
AS
select au_id from titleauthor
where titleauthor.royaltyper = @percentage
GO
/****** Object:  StoredProcedure [dbo].[PUBSSP_CustOrderHist]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
[CustOrderHist]'ALFKI'
SELECT * FROM CUSTOMERS
*/
CREATE PROCEDURE [dbo].[PUBSSP_CustOrderHist] @CustomerID nchar(5)
AS
SELECT ProductName, Total=SUM(Quantity)
FROM Products P, [Order Details] OD, Orders O, Customers C
WHERE C.CustomerID = @CustomerID
AND C.CustomerID = O.CustomerID AND O.OrderID = OD.OrderID AND OD.ProductID = P.ProductID
GROUP BY ProductName
GO
/****** Object:  StoredProcedure [dbo].[PUBSSP_CustOrdersDetail]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
SELECT * FROM ORDERS
[CustOrdersDetail]	10248
*/
CREATE PROCEDURE [dbo].[PUBSSP_CustOrdersDetail] 
@OrderID int
AS
SELECT ProductName,
    UnitPrice=ROUND(Od.UnitPrice, 2),
    Quantity,
    Discount=CONVERT(int, Discount * 100), 
    ExtendedPrice=ROUND(CONVERT(money, Quantity * (1 - Discount) * Od.UnitPrice), 2)
FROM Products P
LEFT JOIN [Order Details] Od ON Od.ProductID = P.ProductID
WHERE   Od.OrderID = @OrderID
ORDER BY ExtendedPrice DESC
GO
/****** Object:  StoredProcedure [dbo].[PUBSSP_CustOrdersOrders]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
[CustOrdersOrders] 'ALFKI'
SELECT * FROM CUSTOMERS
*/
CREATE PROCEDURE [dbo].[PUBSSP_CustOrdersOrders] 
@CustomerID nchar(5)
AS
SELECT OrderID, 
	OrderDate,
	RequiredDate,
	ShippedDate
FROM Orders
WHERE CustomerID = @CustomerID
ORDER BY OrderID
GO
/****** Object:  StoredProcedure [dbo].[PUBSSP_Employee Sales by Country]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[PUBSSP_Employee Sales by Country] 
@Beginning_Date DateTime, @Ending_Date DateTime AS
SELECT Employees.Country, Employees.LastName, Employees.FirstName, Orders.ShippedDate, Orders.OrderID, "Order Subtotals".Subtotal AS SaleAmount
FROM Employees INNER JOIN 
	(Orders INNER JOIN "Order Subtotals" ON Orders.OrderID = "Order Subtotals".OrderID) 
	ON Employees.EmployeeID = Orders.EmployeeID
WHERE Orders.ShippedDate Between @Beginning_Date And @Ending_Date
GO
/****** Object:  StoredProcedure [dbo].[PUBSSP_libros]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[PUBSSP_libros]
as
select title_id,title from titles
GO
/****** Object:  StoredProcedure [dbo].[PUBSSP_Sales by Year]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[PUBSSP_Sales by Year] 
	@Beginning_Date DateTime, @Ending_Date DateTime AS
SELECT Orders.ShippedDate, Orders.OrderID, "Order Subtotals".Subtotal, DATENAME(yy,ShippedDate) AS Year
FROM Orders INNER JOIN "Order Subtotals" ON Orders.OrderID = "Order Subtotals".OrderID
WHERE Orders.ShippedDate Between @Beginning_Date And @Ending_Date
GO
/****** Object:  StoredProcedure [dbo].[PUBSSP_SalesByCategory]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[PUBSSP_SalesByCategory]
    @CategoryName nvarchar(15), @OrdYear nvarchar(4) = '1998'
AS
IF @OrdYear != '1996' AND @OrdYear != '1997' AND @OrdYear != '1998' 
BEGIN
	SELECT @OrdYear = '1998'
END

SELECT ProductName,
	TotalPurchase=ROUND(SUM(CONVERT(decimal(14,2), OD.Quantity * (1-OD.Discount) * OD.UnitPrice)), 0)
FROM [Order Details] OD, Orders O, Products P, Categories C
WHERE OD.OrderID = O.OrderID 
	AND OD.ProductID = P.ProductID 
	AND P.CategoryID = C.CategoryID
	AND C.CategoryName = @CategoryName
	AND SUBSTRING(CONVERT(nvarchar(22), O.OrderDate, 111), 1, 4) = @OrdYear
GROUP BY ProductName
ORDER BY ProductName
GO
/****** Object:  StoredProcedure [dbo].[PUBSSP_Ten Most Expensive Products]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[PUBSSP_Ten Most Expensive Products] AS
SET ROWCOUNT 10
SELECT Products.ProductName AS TenMostExpensiveProducts, Products.UnitPrice
FROM Products
ORDER BY Products.UnitPrice DESC
GO
/****** Object:  StoredProcedure [dbo].[SP_ANALITICA_CLIENTE_ACTUALIZAR]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*



*/
---------------------------------------------
---------------------------------------------
create PROCEDURE [dbo].[SP_ANALITICA_CLIENTE_ACTUALIZAR]
@CIA char(2),
@ID_ANALITICA varchar(20),
@DESCRIPCION varchar(100),
@FLAG_TIPO_PERSONA char(1),
@ID_TIPO_DOC_ID char(2),
@NRO_DOC varchar(20),
@APELLIDO_PATERNO varchar(60),
@APELLIDO_MATERNO varchar(60),
@NOMBRES varchar(60),
@ID_CATEGORIA char(2),
@ID_TIPO_VIA char(2),
@NOMBRE_VIA varchar(60),
@ID_TIPO_ZONA varchar(20),
@NOMBRE_ZONA varchar(60),
@NRO_DIRECCION varchar(10),
@INTERIOR_DIRECCION varchar(10),
@REFERENCIA_ZONA varchar(60),
@DIRECCION varchar(300),
@TELEFONO varchar(30),
@TELEFONO2 varchar(30),
@E_MAIL varchar(60),
@ID_PAIS varchar(3),
@ID_DPTO char(2),
@ID_PROVINCIA char(2),
@ID_DISTRITO char(2),
@ID_ESTADO char(2),
@FLAG_ENVIO char(1),
@UM varchar(10),
@OBSERVACION varchar(300),
@FECHA_NACIMIENTO varchar(10),
@FLAG_CON_CONTRATO char(1),
@ID_ANALITICA_OUT varchar(20)output
AS
---------------------------------------------
DECLARE @VARMSG	VARCHAR(200)
DECLARE	@FECHA	DATETIME
---------------------------------------------
IF(@ID_TIPO_VIA = '')BEGIN SET @ID_TIPO_VIA = NULL END
IF(@ID_TIPO_ZONA = '')BEGIN SET @ID_TIPO_ZONA = NULL END
IF(@ID_PAIS = '')BEGIN SET @ID_PAIS = NULL END
IF(@ID_DPTO = '')BEGIN SET @ID_DPTO = NULL END
IF(@ID_PROVINCIA = '')BEGIN SET @ID_PROVINCIA = NULL END
IF(@ID_DISTRITO = '')BEGIN SET @ID_DISTRITO = NULL END
IF((SELECT ISDATE(@FECHA_NACIMIENTO)) = 1) BEGIN SET @FECHA = CONVERT(DATETIME,@FECHA_NACIMIENTO) END ELSE BEGIN SET @FECHA  = NULL END
---------------------------------------------
SET NOCOUNT ON
BEGIN TRANSACTION
	-------------------------------------------
	UPDATE	[ANALITICA]
	SET		[DESCRIPCION]		= @DESCRIPCION,
			[FLAG_TIPO_PERSONA] = @FLAG_TIPO_PERSONA,
			[ID_TIPO_DOC_ID]	= @ID_TIPO_DOC_ID,
			[NRO_DOC]			= @NRO_DOC,
			[APELLIDO_PATERNO]	= @APELLIDO_PATERNO,
			[APELLIDO_MATERNO]	= @APELLIDO_MATERNO,
			[NOMBRES]			= @NOMBRES,
			[ID_CATEGORIA]		= @ID_CATEGORIA,
			[ID_TIPO_VIA]		= @ID_TIPO_VIA,
			[NOMBRE_VIA]		= @NOMBRE_VIA,
			[ID_TIPO_ZONA]		= @ID_TIPO_ZONA,
			[NOMBRE_ZONA]		= @NOMBRE_ZONA,
			[NRO_DIRECCION]		= @NRO_DIRECCION,
			[INTERIOR_DIRECCION]= @INTERIOR_DIRECCION,
			[REFERENCIA_ZONA]	= @REFERENCIA_ZONA,
			[DIRECCION]			= @DIRECCION,
			[TELEFONO]			= @TELEFONO,
			[TELEFONO2]			= @TELEFONO2,
			[E_MAIL]			= @E_MAIL,
			[ID_PAIS]			= @ID_PAIS,
			[ID_DPTO]			= @ID_DPTO,
			[ID_PROVINCIA]		= @ID_PROVINCIA,
			[ID_DISTRITO]		= @ID_DISTRITO,
			[ID_ESTADO]			= @ID_ESTADO,
			[FLAG_ENVIO]		= @FLAG_ENVIO,
			[FM]				= GETDATE(),
			[UM]				= @UM,
			[FECHA_NACIMIENTO]	= @FECHA,
			[OBSERVACION]		= @OBSERVACION
	WHERE	[CIA]			= @CIA	
	AND		[ID_ANALITICA]	= @ID_ANALITICA
	-------------------------------------------
	IF @@ERROR <> 0 OR @@ROWCOUNT <> 1
	BEGIN
		---------------------------------------
		SET		@VARMSG	= 'SE PRODUJO UN ERROR DURANTE EL PROCESO DE ACTUALIZACION DEL CLIENTE. NO SE ACTUALIZARON LOS DATOS.'
		GOTO	MSGERROR
		----------------------------------------
	END 
	ELSE
	BEGIN
		----------------------------------------
		SET	@VARMSG				= 'DATOS ACTUALIZADOS.'
		SET	@ID_ANALITICA_OUT	= @ID_ANALITICA
		----------------------------------------
	END
	--------------------------------------------
	
	
	-------------------------------------------
	UPDATE	[ANALITICA_TIPO]
	SET		FLAG_CON_CONTRATO	= @FLAG_CON_CONTRATO,
			[ID_ESTADO]			= @ID_ESTADO,
			[FLAG_ENVIO]		= @FLAG_ENVIO,
			[FM]				= GETDATE(),
			[UM]				= @UM	
	WHERE	[CIA]				= @CIA	
	AND		[ID_ANALITICA]		= @ID_ANALITICA
	AND     ID_TIPO_ANALITICA	=	'01'
	-------------------------------------------
	IF @@ERROR <> 0 OR @@ROWCOUNT <> 1
	BEGIN
		---------------------------------------
		SET		@VARMSG	= 'SE PRODUJO UN ERROR DURANTE EL PROCESO DE ACTUALIZACION DEL ANALITICA_TIPO. NO SE ACTUALIZARON LOS DATOS.'
		GOTO	MSGERROR
		----------------------------------------
	END 
COMMIT TRANSACTION
------------------------------------------------
RETURN
MSGERROR:
		ROLLBACK TRANSACTION
		----------------------------------------
		RAISERROR	(@VARMSG, 15, 1)
		SET			@ID_ANALITICA_OUT = ''
		RETURN
GO
/****** Object:  StoredProcedure [dbo].[SP_ANALITICA_CLIENTE_ELIMINAR]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*



*/
----------------------------------------------
----------------------------------------------
create PROCEDURE [dbo].[SP_ANALITICA_CLIENTE_ELIMINAR]
@CIA char(2),
@ID_ANALITICA varchar(20),
@ID_ESTADO char(2),
@FLAG_ENVIO char(1),
@UA varchar(10),
@AA varchar(60)
AS
----------------------------------------------
DECLARE @VARMSG			VARCHAR(200)
----------------------------------------------
SET NOCOUNT ON
BEGIN TRANSACTION
	-------------------------------------------
	UPDATE	[ANALITICA]
	SET		[ID_ESTADO]	= @ID_ESTADO,
			[FLAG_ENVIO]= @FLAG_ENVIO,
			[FA]		= GETDATE(),
			[UA]		= @UA,
			[AA]		= @AA
	WHERE	[CIA]			= @CIA	
	AND		[ID_ANALITICA]	= @ID_ANALITICA
	-------------------------------------------
	IF @@ERROR <> 0 OR @@ROWCOUNT <> 1
	BEGIN
		---------------------------------------
		SET		@VARMSG	= 'SE PRODUJO UN ERROR DURANTE EL PROCESO DE ELIMINACION DEL CLIENTE. NO SE ELIMINO EL REGISTRO.'
		GOTO	MSGERROR
		----------------------------------------
	END 
	ELSE
	BEGIN
		----------------------------------------
		SET	@VARMSG	= 'REGISTRO ELIMINADO.'
		----------------------------------------
	END
	--------------------------------------------	
		
	-------------------------------------------
	UPDATE	[ANALITICA_TIPO]
	SET		[ID_ESTADO]			= @ID_ESTADO,
			[FLAG_ENVIO]		= @FLAG_ENVIO,
			[FA]				= GETDATE(),
			[UA]				= @UA			
	WHERE	[CIA]				= @CIA	
	AND		[ID_ANALITICA]		= @ID_ANALITICA
	AND     ID_TIPO_ANALITICA	=	'01'
	-------------------------------------------
	IF @@ERROR <> 0 OR @@ROWCOUNT <> 1
	BEGIN
		---------------------------------------
		SET		@VARMSG	= 'SE PRODUJO UN ERROR DURANTE EL PROCESO DE ELIMINACION DEL ANALITICA_TIPO. NO SE ACTUALIZARON LOS DATOS.'
		GOTO	MSGERROR
		----------------------------------------
	END 
COMMIT TRANSACTION
------------------------------------------------
RETURN
MSGERROR:
		ROLLBACK TRANSACTION
		----------------------------------------
		RAISERROR	(@VARMSG, 15, 1)
		RETURN
GO
/****** Object:  StoredProcedure [dbo].[SP_ANALITICA_CLIENTE_INSERTAR]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*



*/
---------------------------------------------
---------------------------------------------
create PROCEDURE	[dbo].[SP_ANALITICA_CLIENTE_INSERTAR]
@CIA char(2),
@ID_ANALITICA varchar(20),
@DESCRIPCION varchar(100),
@FLAG_TIPO_PERSONA char(1),
@ID_TIPO_DOC_ID char(2),
@NRO_DOC varchar(20),
@APELLIDO_PATERNO varchar(60),
@APELLIDO_MATERNO varchar(60),
@NOMBRES varchar(60),
@ID_CATEGORIA char(2),
@ID_TIPO_VIA char(2),
@NOMBRE_VIA varchar(60),
@ID_TIPO_ZONA varchar(20),
@NOMBRE_ZONA varchar(60),
@NRO_DIRECCION varchar(10),
@INTERIOR_DIRECCION varchar(10),
@REFERENCIA_ZONA varchar(60),
@DIRECCION varchar(300),
@TELEFONO varchar(30),
@TELEFONO2 varchar(30),
@E_MAIL varchar(60),
@ID_PAIS varchar(3),
@ID_DPTO char(2),
@ID_PROVINCIA char(2),
@ID_DISTRITO char(2),
@ID_ESTADO char(2),
@FLAG_ENVIO char(1),
@UC varchar(10),
@OBSERVACION varchar(300),
@FECHA_NACIMIENTO varchar(10),
@FLAG_CON_CONTRATO char(1),
@ID_ANALITICA_OUT varchar(20)output
AS
---------------------------------------------
DECLARE @VARMSG			VARCHAR(200)
DECLARE	@FECHA	DATETIME
---------------------------------------------
IF(@ID_TIPO_VIA = '')BEGIN SET @ID_TIPO_VIA = NULL END
IF(@ID_TIPO_ZONA = '')BEGIN SET @ID_TIPO_ZONA = NULL END
IF(@ID_PAIS = '')BEGIN SET @ID_PAIS = NULL END
IF(@ID_DPTO = '')BEGIN SET @ID_DPTO = NULL END
IF(@ID_PROVINCIA = '')BEGIN SET @ID_PROVINCIA = NULL END
IF(@ID_DISTRITO = '')BEGIN SET @ID_DISTRITO = NULL END
SET @ID_ANALITICA = @NRO_DOC
IF((SELECT ISDATE(@FECHA_NACIMIENTO)) = 1) BEGIN SET @FECHA = CONVERT(DATETIME,@FECHA_NACIMIENTO) END ELSE BEGIN SET @FECHA  = NULL END
---------------------------------------------
SET NOCOUNT ON
BEGIN TRANSACTION
	-----------------------------------------
	INSERT INTO [ANALITICA]
	(
		[CIA], [ID_ANALITICA], [DESCRIPCION], [FLAG_TIPO_PERSONA], [ID_TIPO_DOC_ID], [NRO_DOC], [APELLIDO_PATERNO], [APELLIDO_MATERNO], [NOMBRES], [ID_CATEGORIA], [ID_TIPO_VIA],
		[NOMBRE_VIA], [ID_TIPO_ZONA], [NOMBRE_ZONA], [NRO_DIRECCION], [INTERIOR_DIRECCION], [REFERENCIA_ZONA], [DIRECCION], [TELEFONO], [TELEFONO2], [E_MAIL], [ID_PAIS], [ID_DPTO],
		[ID_PROVINCIA], [ID_DISTRITO], [ID_ESTADO], [FLAG_ENVIO], [FC], [UC], [OBSERVACION], [FECHA_NACIMIENTO]
	)
	VALUES
	(
		@CIA, @ID_ANALITICA, @DESCRIPCION, @FLAG_TIPO_PERSONA, @ID_TIPO_DOC_ID, @NRO_DOC, @APELLIDO_PATERNO, @APELLIDO_MATERNO, @NOMBRES, @ID_CATEGORIA, @ID_TIPO_VIA,
		@NOMBRE_VIA, @ID_TIPO_ZONA, @NOMBRE_ZONA, @NRO_DIRECCION, @INTERIOR_DIRECCION, @REFERENCIA_ZONA, @DIRECCION, @TELEFONO, @TELEFONO2, @E_MAIL, @ID_PAIS, @ID_DPTO,
		@ID_PROVINCIA, @ID_DISTRITO, @ID_ESTADO, @FLAG_ENVIO, GETDATE(), @UC, @OBSERVACION, @FECHA
	)
	-----------------------------------------
	IF @@ERROR <> 0 OR @@ROWCOUNT <> 1
	BEGIN
		---------------------------------------
		SET		@VARMSG	= 'SE PRODUJO UN ERROR DURANTE EL PROCESO DE GRABACION DEL CLIENTE. NO SE GRABARON LOS DATOS.'
		GOTO	MSGERROR
		----------------------------------------
	END 
	ELSE
	BEGIN
		----------------------------------------
		SET	@VARMSG				= 'DATOS GRABADOS.'
		SET	@ID_ANALITICA_OUT	= @ID_ANALITICA
		----------------------------------------
	END
	-----------------------------------------
	-----------------------------------------
	INSERT INTO [dbo].[ANALITICA_TIPO]
	(
		CIA,ID_ANALITICA,ID_TIPO_ANALITICA,ID_ESTADO,FLAG_ENVIO,SE,FC,UC,FLAG_CON_CONTRATO

	)
	VALUES			--		SELECT *FROM dbo.ANALITICA_TIPO
	(
		@CIA,@ID_ANALITICA,'01',@ID_ESTADO,@FLAG_ENVIO,'01',GETDATE(),@UC,@FLAG_CON_CONTRATO
	)	
	-----------------------------------------
	IF @@ERROR <> 0 OR @@ROWCOUNT <> 1
	BEGIN
		---------------------------------------
		SET		@VARMSG	= 'SE PRODUJO UN ERROR DURANTE EL PROCESO DE GRABACION DEL ANALITICA_TIPO. NO SE GRABARON LOS DATOS.'
		GOTO	MSGERROR
		----------------------------------------
	END 
	-----------------------------------------
COMMIT TRANSACTION
---------------------------------------------
RETURN
MSGERROR:
		ROLLBACK TRANSACTION
		-------------------------------------
		RAISERROR	(@VARMSG, 15, 1)
		SET			@ID_ANALITICA_OUT = ''
		RETURN
GO
/****** Object:  StoredProcedure [dbo].[SP_ANALITICA_CLIENTE_TRAER_CLIENTE]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*

SELECT * FROM CATEGORIA_ANALITICA

EXEC	SP_ANALITICA_CLIENTE_TRAER_CLIENTE '01', '43766685'

*/
--------------------------------------------
--------------------------------------------
create PROCEDURE [dbo].[SP_ANALITICA_CLIENTE_TRAER_CLIENTE]
@CIA char(2),
@ID_ANALITICA varchar(20)
AS
--------------------------------------------
--------------------------------------------

SET NOCOUNT ON

SELECT	ANALITICA.CIA, ANALITICA.ID_ANALITICA, ANALITICA.DESCRIPCION, ANALITICA.FLAG_TIPO_PERSONA, ANALITICA.ID_TIPO_DOC_ID, ANALITICA.NRO_DOC, ANALITICA.APELLIDO_PATERNO, 
		ANALITICA.APELLIDO_MATERNO, ANALITICA.NOMBRES, ANALITICA.ID_CATEGORIA, ANALITICA.ID_TIPO_VIA, ANALITICA.NOMBRE_VIA, ANALITICA.ID_TIPO_ZONA, 
		ANALITICA.NOMBRE_ZONA, ANALITICA.NRO_DIRECCION, ANALITICA.INTERIOR_DIRECCION, ANALITICA.REFERENCIA_ZONA, ANALITICA.DIRECCION, 
		ANALITICA.TELEFONO, ANALITICA.TELEFONO2, ANALITICA.E_MAIL, ANALITICA.ID_PAIS, PAIS.DESCRIPCION AS 'PAIS', ANALITICA.ID_DPTO, 
		DEPARTAMENTO.DES_DPTO AS 'DPTO', ANALITICA.ID_PROVINCIA, PROVINCIA.DES_PROVINCIA AS 'PROVINCIA', ANALITICA.ID_DISTRITO, DISTRITO.DES_DISTRITO AS 'DISTRITO', 
		ANALITICA.ID_ESTADO, ANALITICA.OBSERVACION, CONVERT(varchar(10),FECHA_NACIMIENTO,103) AS 'FECHA', UPPER(CA.DESCRIPCION),AT.FLAG_CON_CONTRATO
FROM	ANALITICA 
INNER JOIN ANALITICA_TIPO AT ON at.cia=ANALITICA.cia AND at.id_analitica=ANALITICA.id_analitica 
LEFT JOIN PAIS ON PAIS.ID_PAIS = ANALITICA.ID_PAIS AND PAIS.CIA = ANALITICA.CIA 
LEFT JOIN UBICACION AS DEPARTAMENTO ON DEPARTAMENTO.CIA = ANALITICA.CIA AND DEPARTAMENTO.ID_PAIS = ANALITICA.ID_PAIS AND DEPARTAMENTO.ID_DPTO = ANALITICA.ID_DPTO AND DEPARTAMENTO.ID_PROVINCIA = ANALITICA.ID_PROVINCIA AND DEPARTAMENTO.ID_DISTRITO = ANALITICA.ID_DISTRITO
LEFT JOIN UBICACION AS PROVINCIA ON PROVINCIA.CIA = ANALITICA.CIA AND PROVINCIA.ID_PAIS = ANALITICA.ID_PAIS AND PROVINCIA.ID_DPTO = ANALITICA.ID_DPTO AND PROVINCIA.ID_PROVINCIA = ANALITICA.ID_PROVINCIA AND PROVINCIA.ID_DISTRITO = ANALITICA.ID_DISTRITO
LEFT JOIN UBICACION AS DISTRITO ON DISTRITO.CIA =ANALITICA.CIA  AND DISTRITO.ID_PAIS = ANALITICA.ID_PAIS AND DISTRITO.ID_DPTO = ANALITICA.ID_DPTO AND DISTRITO.ID_PROVINCIA = ANALITICA.ID_PROVINCIA AND DISTRITO.ID_DISTRITO = ANALITICA.ID_DISTRITO
LEFT JOIN CATEGORIA_ANALITICA AS CA ON CA.CIA = ANALITICA.CIA AND CA.ID_CATEGORIA = ANALITICA.ID_CATEGORIA

WHERE	ANALITICA.CIA			= @CIA
AND		ANALITICA.ID_ANALITICA	= @ID_ANALITICA
GO
/****** Object:  StoredProcedure [dbo].[SP_ANALITICA_CLIENTE_TRAER_TODOS]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*

SELECT * FROM ANALITICA

SELECT * FROM ANALITICA_TIPO

SELECT * FROM TIPO_ANALITICA

EXEC SP_ANALITICA_CLIENTE_TRAER_TODOS '01', '%', '%', '%', '%'

*/
---------------------------------------------------
---------------------------------------------------
create	PROCEDURE	[dbo].[SP_ANALITICA_CLIENTE_TRAER_TODOS]
@CIA				CHAR(2),
@ID_ANALITICA		VARCHAR(20),
@DESCRIPCION		VARCHAR(300),
@FLAG_TIPO_PERSONA	CHAR(1),
@ID_ESTADO			VARCHAR(2)
AS
---------------------------------------------------
---------------------------------------------------
SELECT	ANA.ID_ANALITICA, ANA.DESCRIPCION, CASE ANA.FLAG_TIPO_PERSONA WHEN '1' THEN 'JURIDICA' ELSE 'NATURAL' END AS 'TIPO PERSONA', 
		EST.ABREVIATURA AS 'ESTADO'
FROM    ANALITICA AS ANA 
INNER JOIN ESTADO AS EST ON ANA.CIA = EST.CIA AND ANA.ID_ESTADO = EST.ID_ESTADO 
INNER JOIN ANALITICA_TIPO AS ANAT ON ANA.CIA = ANAT.CIA AND ANA.ID_ANALITICA = ANAT.ID_ANALITICA 
INNER JOIN TIPO_ANALITICA AS TANA ON ANAT.CIA = TANA.CIA AND ANAT.ID_TIPO_ANALITICA = TANA.ID_TIPO_ANALITICA
WHERE	ANA.CIA					= @CIA
AND		ANA.ID_ANALITICA		LIKE '%' +	CASE @ID_ANALITICA WHEN '' THEN '%' ELSE @ID_ANALITICA END + '%'
AND		TANA.ID_TIPO_ANALITICA	= '01'
AND		ANA.DESCRIPCION			LIKE '%' +	CASE @DESCRIPCION WHEN '' THEN '%' ELSE @DESCRIPCION END + '%'
AND		ANA.FLAG_TIPO_PERSONA	LIKE '%' + @FLAG_TIPO_PERSONA + '%'
AND		ANA.ID_ESTADO			LIKE '%' + @ID_ESTADO + '%'
GO
/****** Object:  StoredProcedure [dbo].[SP_ARTICULO_ACTUALIZAR]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*		
SP_HELP ARTICULO
SELECT * FROM ARTICULO WHERE ID_ARTICULO='PROCOM0000000003'
SELECT * FROM ARTICULO WHERE CONVERT(VARCHAR(10),FC,103)='24/08/2010'
DELETE FROM ARTICULO WHERE CONVERT(VARCHAR(10),FC,103)='24/08/2010'
DELETE FROM ARTICULO WHERE id_articulo ='9999990000000002'
[SP_ARTICULO_ACTUALIZAR]
'01','SERALQ0000000004','ra','ra2','02','002','002','88888','002','111','333','222','admin'
*/
-----------------------------------------------
create	PROC	[dbo].[SP_ARTICULO_ACTUALIZAR]
@CIA					CHAR(2), 
@ID_ARTICULO			VARCHAR(20),  
@DESCRIPCION			VARCHAR(100), 
@DESCRIPCION_LARGA		VARCHAR(255), 
@ID_UNIDAD				CHAR(2), 
@ID_CLASIFICA1			CHAR(3),  
@ID_CLASIFICA2			CHAR(3),
@NRO_PARTE			   	VARCHAR(60), 
@ID_MARCA				CHAR(3),
@STOCK					DECIMAL(13,2),
@STOCK_MINIMO			DECIMAL(13,2), 
@STOCK_MAXIMO			DECIMAL(13,2),
@ESTADO					char(2),
@UM						VARCHAR(25)
AS
-----------------------------------------------
DECLARE @VARMSG			VARCHAR(MAX)
DECLARE	@COUNT			INT
DECLARE	@FECHA_ACTUAL	DATETIME
--------------------------------------------
SET	   @FECHA_ACTUAL	=	GETDATE()
-----------------------------------------------
SET NOCOUNT ON
BEGIN TRANSACTION	
	-------------------------------------------
	UPDATE	ARTICULO
	SET		DESCRIPCION			= @DESCRIPCION, 
			DESCRIPCION_LARGA	= @DESCRIPCION_LARGA, 
			ID_UNIDAD			= @ID_UNIDAD, 
			ID_CLASIFICA1		= @ID_CLASIFICA1, 
			ID_CLASIFICA2		= @ID_CLASIFICA2, 
			NRO_PARTE			= @NRO_PARTE, 
			ID_MARCA			= @ID_MARCA, 
			STOCK				= @STOCK, 
			STOCK_MINIMO		= @STOCK_MINIMO, 
			STOCK_MAXIMO		= @STOCK_MAXIMO	,			
			ID_ESTADO			= @ESTADO,		
			FM					= @FECHA_ACTUAL, 
			UM					= @UM
	WHERE	CIA					= @CIA 
	AND		ID_ARTICULO			= @ID_ARTICULO 
	-------------------------------------------
	IF @@ERROR <> 0 OR @@ROWCOUNT <> 1
	BEGIN
		---------------------------------------
		SET		@VARMSG	= 'SE PRODUJO UN ERROR DURANTE EL PROCESO DE ACTUALIZAR EL ARTICULO. NO SE ACTUALIZARON LOS DATOS.'
		GOTO	MSGERROR
		----------------------------------------
	END 
	ELSE
	BEGIN
		----------------------------------------
		SET	@VARMSG				= 'DATOS ACTUALIZADOS.'		
		----------------------------------------
	END	
	   --------------------------------------------
COMMIT TRANSACTION
------------------------------------------------
RETURN
MSGERROR:
		ROLLBACK TRANSACTION
		----------------------------------------
		RAISERROR	(@VARMSG, 15, 1)		
		RETURN
GO
/****** Object:  StoredProcedure [dbo].[SP_ARTICULO_ELIMINAR]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
[SP_ARTICULO_ELIMINAR] '01','PROCOM0000000011','ADMIN'
EXEC	SP_LISTAR_ARTICULO '01', '','%', '%'
*/
-----------------------------------------------
-----------------------------------------------
create	PROCEDURE	[dbo].[SP_ARTICULO_ELIMINAR]
@CIA			CHAR(2), 
@ID_ARTICULO	VARCHAR(20),
@UA				VARCHAR(10)
AS
-----------------------------------------------
DECLARE @VARMSG			VARCHAR(MAX)
DECLARE	@FECHA_ACTUAL	DATETIME
DECLARE @ID_ESTADO		CHAR(2)
----------------------------------------------
SET		@FECHA_ACTUAL	=	GETDATE()
SET		 @ID_ESTADO		=  '02'	
-----------------------------------------------
BEGIN TRANSACTION
	-------------------------------------------
	UPDATE	ARTICULO
	SET		ID_ESTADO	= @ID_ESTADO,	
			FA			= @FECHA_ACTUAL, 
			UA			= @UA			
	WHERE	CIA			= @CIA 
	AND		ID_ARTICULO	= @ID_ARTICULO 
	-------------------------------------------
	IF @@ERROR <> 0 OR @@ROWCOUNT <> 1
	BEGIN
		---------------------------------------
		SET		@VARMSG	= 'SE PRODUJO UN ERROR DURANTE EL PROCESO DE ELIMINACION DEL ARTICULO. NO SE ELIMINO EL REGISTRO.'
		GOTO	MSGERROR
		----------------------------------------
	END 
	ELSE
	BEGIN
		----------------------------------------
		SET	@VARMSG	= 'REGISTRO ELIMINADO.'
		----------------------------------------
	END	
COMMIT TRANSACTION
------------------------------------------------
RETURN
MSGERROR:
		ROLLBACK TRANSACTION
		----------------------------------------
		RAISERROR	(@VARMSG, 15, 1)
		RETURN
GO
/****** Object:  StoredProcedure [dbo].[SP_ARTICULO_INSERTAR]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*		
sp_help ARTICULO
SELECT * FROM ARTICULO where convert(varchar(10),fc,103)='24/08/2010'
delete FROM ARTICULO where convert(varchar(10),fc,103)='24/08/2010'
*/
-----------------------------------------------
-----------------------------------------------
create	PROC	[dbo].[SP_ARTICULO_INSERTAR]
@CIA					CHAR(2), 
@ID_ARTICULO			VARCHAR(20),  
@DESCRIPCION			VARCHAR(100),
@DESCRIPCION_LARGA		VARCHAR(255), 
@ID_UNIDAD				CHAR(2), 
@ID_CLASIFICA1			CHAR(3),	
@ID_CLASIFICA2			CHAR(3),
@NRO_PARTE			   	VARCHAR(60), 
@ID_MARCA				CHAR(3),
@STOCK					float,		
@STOCK_MINIMO			float,		
@STOCK_MAXIMO			float, 
@UC						VARCHAR(30)
AS
-----------------------------------------------
DECLARE @VARMSG	VARCHAR(MAX)		DECLARE	@COUNT	INT			declare @cod INT
----------------------------------------------
--DECLARE @ID_ARTICULO VARCHAR(100)
--SET @ID_ARTICULO = 'SERCOM'
SET @cod=CONVERT(INT,(SELECT ISNULL((
			SELECT max(RIGHT(ID_ARTICULO,10))FROM ARTICULO WHERE LEFT(ID_ARTICULO,6)=@ID_ARTICULO ),0))
				)
IF(@cod = 0)
BEGIN		
	SET	@ID_ARTICULO =@ID_ARTICULO + REPLICATE('0', (10 - LEN(@COD))) + CONVERT(VARCHAR(10),(@cod+1))
END
ELSE
BEGIN
	SET @ID_ARTICULO = @ID_ARTICULO + REPLICATE('0', (10 - LEN(@COD))) +CONVERT(VARCHAR(10),(@cod + 1))	
END
--PRINT @ID_ARTICULO
------------------------------------------------
SET NOCOUNT ON
BEGIN TRANSACTION
	-------------------------------------------
	INSERT	INTO ARTICULO
	(
	CIA,ID_ARTICULO,DESCRIPCION,DESCRIPCION_LARGA,ID_UNIDAD,ID_CLASIFICA1,ID_CLASIFICA2,
	NRO_PARTE,ID_MARCA,STOCK,STOCK_MINIMO,STOCK_MAXIMO,GENERA_CI,ID_ESTADO,FLAG_ENVIO,FC,UC
	)
	VALUES	
	(
	@CIA,@ID_ARTICULO,@DESCRIPCION,@DESCRIPCION_LARGA,@ID_UNIDAD,@ID_CLASIFICA1,@ID_CLASIFICA2,
	@NRO_PARTE,@ID_MARCA,@STOCK,@STOCK_MINIMO,@STOCK_MAXIMO,'1','01','1',GETDATE(),@UC		
	)	
	-------------------------------------------
	IF @@ERROR <> 0 OR @@ROWCOUNT <> 1
	BEGIN
		---------------------------------------
		SET		@VARMSG	= 'SE PRODUJO UN ERROR DURANTE EL PROCESO DE GRABACION DEL ARTICULO. NO SE GRABARON LOS DATOS.'
		GOTO	MSGERROR
		----------------------------------------
	END 
	ELSE
	BEGIN
		----------------------------------------
		SET	@VARMSG				= 'DATOS GRABADOS.'
		----------------------------------------
	END
	--------------------------------------------
COMMIT TRANSACTION
------------------------------------------------
RETURN
MSGERROR:
		ROLLBACK TRANSACTION
		----------------------------------------
		RAISERROR	(@VARMSG, 15, 1)	
		RETURN
GO
/****** Object:  StoredProcedure [dbo].[SP_ARTICULO_LISTAR]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
sp_help articulo
select * from dbo.articulo  where id_estado='01'and cia ='01' order by id_marca desc
select * from dbo. unidad_medida 
select * from dbo.clasificacion1
select * from dbo. clasificacion2 
select * from dbo.marca_articulo 
EXEC [SP_ARTICULO_LISTAR] '1','01', '', '', '', '', '', '', '', '', '', '', '',''
EXEC [SP_ARTICULO_LISTAR] '2','01', '', '', '', '', '', '', '', '', '', '', '',''
EXEC [SP_ARTICULO_LISTAR] '3','01', '', '', '', '', '', '', '', '', '', '', '',''
*/
--------------------------------------------
CREATE PROCEDURE [dbo].[SP_ARTICULO_LISTAR]
@INDICADOR CHAR(1),@CIA char(2),@id_articulo varchar(100),@descripcion	varchar(100),@descripcion_larga	varchar(100),
@id_unidad CHAR(2),@id_clasifica1 CHAR(3),@id_clasifica2 CHAR(3),@nro_parte varchar(60),@id_marca char(3),@stock FLOAT,
@id_estado CHAR(2),@FEC1 datetime,@FEC2 datetime
AS
-----------------------------------------------------------------------------------------------------------------------
DECLARE @FECHA1 VARCHAR(8),@FECHA2 VARCHAR(8),@sOrderBy varchar(MAX), @sGroupBy varchar(MAX), @sExecute varchar(MAX),
 @sSelect varchar(MAX),@sFiltroIdArticulo varchar(MAX),@sFiltroDescripcion varchar(MAX),@sFiltroDescripcionLarga varchar(MAX),
 @sFiltroIdUnidad varchar(MAX),@sFiltroIdclasifica1 varchar(MAX),@sFiltroIdclasifica2 varchar(MAX),@sFiltroNroParte varchar(MAX),
 @sFiltroIdMarca varchar(MAX), @sFiltroStock varchar(MAX),@sFiltroEstado varchar(MAX),@sFiltroFecha varchar(MAX)
----------------------------------------------------------------------------------------------------------------------
SET @FECHA1 = CONVERT(VARCHAR(8),@fec1,112)
SET @FECHA2 = CONVERT(VARCHAR(8),@fec2,112)
SELECT @sSelect='',  @sFiltroIdArticulo='', @sFiltroDescripcion='', @sFiltroIdUnidad='',@sFiltroIdclasifica1 ='', @sFiltroIdclasifica2 ='',
		@sFiltroNroParte ='',@sFiltroIdMarca ='',@sFiltroStock ='',@sFiltroEstado ='',@sFiltroFecha ='',@sOrderBy='',@sGroupBy='',@sExecute=''
-----------------------------------------------------------------------------------------------------------------
IF(@INDICADOR='1')
BEGIN
	SELECT @sSelect= '
	a.id_articulo,upper(a.descripcion) ''descripcion_articulo'',upper(descripcion_larga) ''descripcion_larga'',
	A.id_unidad,upper(um.descripcion) ''descripcion_um'',um.abreviatura ''abrev_um'',
	a.id_clasifica1,upper(c.descripcion) ''descripcion_c1'',upper(c.abreviatura) ''abrev_c1'',
	a.id_clasifica2,upper(cc.descripcion) ''descripcion_c2'',upper(cc.abreviatura) ''abrev_c2'',
	upper(a.nro_parte) ''nro_parte'',a.id_marca,upper(ma.descripcion) ''descripcion_marca'',
	stock,stock_minimo,stock_maximo,e.abreviatura ''estado'',a.id_estado ''id_estado'',E.descripcion ''descripcion_estado'',
	fecha_hora=CONVERT(VARCHAR(10),a.fc,103) +space(2)+convert(char(5),a.fc, 114),
	fecha=CONVERT(VARCHAR(10),a.fc,103),hora=convert(char(5),a.fc, 114)	
	FROM articulo as a 
	INNER JOIN estado e ON e.cia=a.cia and e.id_estado=a.id_estado 
	INNER JOIN unidad_medida um on um.cia=a.cia and um.id_unidad=a.id_unidad
	INNER JOIN clasificacion1 c on c.cia=a.cia and c.id_clasifica1=a.id_clasifica1
	INNER JOIN clasificacion2 cc on cc.cia=a.cia and cc.id_clasifica1=a.id_clasifica1 and cc.id_clasifica2=a.id_clasifica2
	INNER JOIN marca_articulo ma on ma.cia=a.cia and ma.id_marca=a.id_marca
		WHERE a.CIA='''+@CIA+'''	'		
	------------------------------------------------------------------------------------------------------------------
	IF  LEN(ISNULL(@id_articulo,''))>0 
			BEGIN    SELECT @sFiltroIdArticulo	=' and a.id_articulo like ''%''+'''+@id_articulo+''' +''%'' ' END
	ELSE	BEGIN   SELECT @sFiltroIdArticulo	=''		END
	--------------------------------------------------------------------------------------------
	IF  LEN(ISNULL(@descripcion,''))>0 
			BEGIN    SELECT @sFiltroDescripcion	=' and a.descripcion like ''%''+'''+@descripcion+''' +''%'' ' END
	ELSE	BEGIN    SELECT @sFiltroDescripcion	=''	END
	--------------------------------------------------------------------------------------------
	IF  LEN(ISNULL(@descripcion_larga,''))>0 
			BEGIN    SELECT @sFiltroDescripcionLarga =' and a.descripcion_larga like ''%''+'''+@descripcion_larga+''' +''%'' ' END
	ELSE	BEGIN    SELECT @sFiltroDescripcionLarga =''	END
	--------------------------------------------------------------------------------------------
	IF  LEN(ISNULL(@id_unidad,''))>0 AND  @id_unidad<>'%' 
			BEGIN    SELECT @sFiltroIdUnidad	=' and A.id_unidad in('''+@id_unidad+''')' 	 END
	ELSE	BEGIN    SELECT @sFiltroIdUnidad	=''	END
	--------------------------------------------------------------------------------------------
	IF  LEN(ISNULL(@id_clasifica1,''))>0 AND  @id_clasifica1<>'%' 
			BEGIN    SELECT @sFiltroIdclasifica1	=' and a.id_clasifica1 in('''+@id_clasifica1+''')' 	 END
	ELSE	BEGIN    SELECT @sFiltroIdclasifica1	=''	END
	--------------------------------------------------------------------------------------------	
	IF  LEN(ISNULL(@id_clasifica2,''))>0 AND @id_clasifica2<>'%' 
			BEGIN    SELECT @sFiltroIdclasifica2	=' and a.id_clasifica2 in('''+@id_clasifica2+''')' 	 END
	ELSE	BEGIN    SELECT @sFiltroIdclasifica2	=''	END
	--------------------------------------------------------------------------------------------
	IF  LEN(ISNULL(@nro_parte,''))>0 
			BEGIN    SELECT @sFiltroNroParte	=' and a.nro_parte like ''%''+'''+@nro_parte+''' +''%'' ' END
	ELSE	BEGIN    SELECT @sFiltroNroParte	=''	END
	--------------------------------------------------------------------------------------------
	IF  LEN(ISNULL(@id_unidad,''))>0 AND @id_unidad<>'%' 
			BEGIN    SELECT @sFiltroIdMarca	=' and A.id_unidad in('''+@id_unidad+''')' 	 END
	ELSE	BEGIN    SELECT @sFiltroIdMarca	=''	END
		--------------------------------------------------------------------------------------------	
	IF  LEN(ISNULL(@id_marca,''))>0 AND @id_marca<>'%' 
			BEGIN    SELECT @sFiltroIdMarca	=' and a.id_marca in('''+@id_marca+''')' 	 END
	ELSE	BEGIN    SELECT @sFiltroIdMarca	=''	END
	--------------------------------------------------------------------------------------------
	IF  ISNULL(@FECHA1,'19000101') <> '19000101'  AND  ISNULL(@FECHA2,'19000101') <> '19000101'
			BEGIN 	SELECT @sFiltroFecha=' and convert(varchar(8),a.fc,112) between  '''+@FECHA1+'''  and  '''+@FECHA2+''''	END
	ELSE	BEGIN  	SELECT @sFiltroFecha	=''		END	
	--------------------------------------------------------------------------------------------
	IF  LEN(ISNULL(@id_estado,''))>0 AND @id_estado<>'%' 
			BEGIN   SELECT @sFiltroEstado	=' and a.ID_ESTADO  in('''+@id_estado+''') ' END
	ELSE	BEGIN	SELECT @sFiltroEstado	=''	END
	--------------------------------------------------------------------------------------------
	SELECT @sOrderBy	=' order by  a.id_articulo'
	---------------------------------------------------------------------------------------------
	SELECT @sExecute = @sSelect +''+ @sFiltroIdArticulo +''+ @sFiltroDescripcion +''+  @sFiltroDescripcion +''+ @sFiltroIdUnidad +''+
			@sFiltroIdclasifica1  +''+	 @sFiltroIdclasifica2 +''+ @sFiltroNroParte+''+ @sFiltroIdMarca+''+ @sFiltroStock+''+
			 @sFiltroEstado+''+ @sFiltroFecha+''+  @sOrderBy
 	PRINT @sExecute
	EXEC ('SELECT '+ @sExecute )	 
 	--------------------------------------------------------------------------------------------
END
----------------------------------------------------------------------------------------------------------------
IF(@INDICADOR='2')
BEGIN
	SELECT @sSelect=' a.id_articulo,upper(a.descripcion) ''descripcion_articulo''
		 FROM articulo A WHERE cia='''+@CIA+''' '
	--------------------------------------------------------------------------------------------
	SELECT @sOrderBy	=' order by  a.id_articulo'
	-------------------------------------------------------------------------------------------
	SELECT @sExecute = @sSelect
	PRINT @sExecute
	EXEC ('SELECT '+ @sExecute )	
END
----------------------------------------------------------------------------------------------------------------
IF(@INDICADOR='3')
BEGIN
	SELECT @sSelect=' TOP 1   fc,id_articulo FROM articulo WHERE cia='''+@CIA+''' ORDER BY fc DESC '
	SELECT @sExecute = @sSelect
	PRINT @sExecute
	EXEC ('SELECT '+ @sExecute )	
END
GO
/****** Object:  StoredProcedure [dbo].[SP_ARTICULO_TRAER_ARTICULO]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
sp_help articulo
EXEC	SP_ARTICULO_TRAER_ARTICULO '01', 'PMAHEL0000000001'
EXEC	SP_ARTICULO_TRAER_ARTICULO '01', 'PROCOM0000000003'
select * from articulo where id_estado='02'
select * from ARTICULO_NRO_PARTE
select * from clasificacion1
select * from clasificacion2
*/
--------------------------------------------
create PROCEDURE [dbo].[SP_ARTICULO_TRAER_ARTICULO]
@cia				char(2),
@id_articulo		varchar(100)
AS
-------------------------------------------
SELECT a.id_articulo as 'Codigo',
upper(a.descripcion) as 'Nombre Articulo',
upper(descripcion_larga)as 'descripcion_larga',
upper(um.descripcion) as 'unidad_medida' ,
upper(c.descripcion) as 'clasifica1',
upper(cc.descripcion) as 'clasifica2',
upper(a.nro_parte) as 'nro_parte',
upper(ma.descripcion) as 'marca_articulo',
stock,stock_minimo,stock_maximo,		
upper(e.id_estado)	as 'Estado'		
FROM articulo as a 
LEFT JOIN estado e ON e.cia=a.cia and e.id_estado=a.id_estado 
LEFT JOIN unidad_medida um on um.cia=a.cia and um.id_unidad=a.id_unidad
LEFT JOIN clasificacion1 c on c.cia=a.cia and c.id_clasifica1=a.id_clasifica1
LEFT JOIN clasificacion2 cc on cc.cia=a.cia and cc.id_clasifica1=a.id_clasifica1 
	                                        and cc.id_clasifica2=a.id_clasifica2 and cc.id_clasifica1=c.id_clasifica1
LEFT JOIN articulo_nro_parte anp on anp.cia=a.cia and anp.id_articulo=a.id_articulo
LEFT JOIN marca_articulo ma on ma.cia=a.cia and ma.id_marca=a.id_marca
WHERE a.cia=@cia AND	a.id_articulo=@id_articulo
ORDER BY  a.id_articulo
GO
/****** Object:  StoredProcedure [dbo].[SP_ARTICULOS_TEMP]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
SELECT * FROM articulo_temp
DELETE	FROM articulo_temp

[SP_ARTICULOS_TEMP] 
	'1','81fd6a7d-91cf-47ff-ada2-330734990d42','01','02','','PROCOM0000000004','G90','GASOLINA 90 - GRIFO','GALoN',0,'VISTONY'

[SP_ARTICULOS_TEMP]
	'2','81fd6a7d-91cf-47ff-ada2-330734990d42','01','02','1','PROCOM0000000004','G90','GASOLINA 90 - GRIFO','GALoN',100,'VISTONY'

[SP_ARTICULOS_TEMP] 
	'3','81fd6a7d-91cf-47ff-ada2-330734990d42','01','02','1','','','','','',''	
	
[SP_ARTICULOS_TEMP] 
	'4','81fd6a7d-91cf-47ff-ada2-330734990d42','01','02','1','','','','','',''
		
[SP_ARTICULOS_TEMP]	'5','','','','','','','','','',''

*/
-----------------------------------------------
-----------------------------------------------
CREATE	PROCEDURE	[dbo].[SP_ARTICULOS_TEMP]
@INDICADOR	 CHAR(1),	   @SESION	  VARCHAR(MAX), @CIA CHAR(2),  @SEDE CHAR(2),@ITEM INT,
@ID_ARTICULO VARCHAR(100), @NRO_PARTE VARCHAR(100), @DESCRIPCION	VARCHAR(100),
@UNIDAD		 VARCHAR(100), @CANTIDAD FLOAT, @MARCA VARCHAR(20)
AS
----------------------------------------------------------------------------------------------
DECLARE @CORRELATIVO INT, @VARMSG	VARCHAR(MAX),@COUNT	INT
----------------------------------------------------------------------------------------------
BEGIN TRANSACTION
----------------------------------------------------------------------------------------------
	IF(@INDICADOR='1')			/*				INSERTAR			*/
	BEGIN
		SET @CORRELATIVO =	( SELECT ISNULL ((SELECT max(ITEM) FROM ARTICULO_TEMP WHERE SESION = @SESION),0) )
		IF(@CORRELATIVO > 0) BEGIN SET @CORRELATIVO = @CORRELATIVO + 1 END ELSE BEGIN SET @CORRELATIVO = 1 END
		----------------------------------------------			
		INSERT INTO ARTICULO_TEMP	
		(		
			SESION,CIA,SEDE,ITEM,ID_ARTICULO,NRO_PARTE,DESCRIPCION,UNIDAD,CANTIDAD,MARCA,ID_ESTADO
		)
		VALUES
		(
			@SESION,@CIA,@SEDE,@CORRELATIVO,@ID_ARTICULO,@NRO_PARTE,@DESCRIPCION,@UNIDAD,@CANTIDAD,@MARCA,'01'
		)
		-------------------------------------------
		IF @@ERROR <> 0 OR @@ROWCOUNT <> 1
		BEGIN
			---------------------------------------
			SET		@VARMSG	= 'SE PRODUJO UN ERROR DURANTE EL PROCESO DE GRABACION DEL ARTICULO_TEMP. NO SE GRABARON LOS DATOS.'
			GOTO	MSGERROR
			----------------------------------------
		END 				
	END
	----------------------------------------------------------------------------------------------
	----------------------------------------------------------------------------------------------
	IF(@INDICADOR='2')		/*		ACTUALIZAR	*/
	BEGIN
		UPDATE	ARTICULO_TEMP
			SET		CANTIDAD			= @CANTIDAD				
			WHERE	SESION				= @SESION
			AND		CIA					= @CIA 
			AND		SEDE				= @SEDE
			AND		ITEM				= @ITEM
			and     ID_ARTICULO			= @ID_ARTICULO
		-------------------------------------------
		IF @@ERROR <> 0 OR @@ROWCOUNT <> 1
		BEGIN
			---------------------------------------
			SET		@VARMSG	= 'SE PRODUJO UN ERROR DURANTE EL PROCESO DE ACTUALIZAR LA INVENTARIO_DET_MOV_TEMP. NO SE ACTUALIZARON LOS DATOS.'
			GOTO	MSGERROR
			----------------------------------------
		END 
	END
	----------------------------------------------------------------------------------------------
	----------------------------------------------------------------------------------------------
	IF(@INDICADOR='3')		/*		ELIMINAR	*/
	BEGIN		
		--DELETE	FROM ARTICULO_TEMP WHERE	SESION = @SESION AND CIA=@CIA AND SEDE=@SEDE AND ITEM=@ITEM		
		UPDATE	ARTICULO_TEMP
			SET		ID_ESTADO			='02'			
			WHERE	SESION				= @SESION
			AND		CIA					= @CIA 
			AND		SEDE				= @SEDE
			AND		ITEM				= @ITEM		
		-------------------------------------------
		IF @@ERROR <> 0 OR @@ROWCOUNT <> 1
		BEGIN
			---------------------------------------
			SET		@VARMSG	= 'SE PRODUJO UN ERROR DURANTE EL PROCESO DE ELIMINACION DE LA ARTICULO_TEMP. NO SE ELIMINO EL REGISTRO.'
			GOTO	MSGERROR
			----------------------------------------
		END 
	END
	----------------------------------------------------------------------------------------------
	----------------------------------------------------------------------------------------------
	IF(@INDICADOR='4')		/*		LIMPIAR		*/
	BEGIN
		DELETE	FROM ARTICULO_TEMP	WHERE	CIA=@CIA AND SEDE=@SEDE and SESION=@SESION
	END	
	----------------------------------------------------------------------------------------------
	----------------------------------------------------------------------------------------------
	IF(@INDICADOR='5')		/*		BORRAR TODOSO		*/
	BEGIN
		DELETE	FROM ARTICULO_TEMP	
	END
	----------------------------------------------------------------------------------------------
	----------------------------------------------------------------------------------------------

COMMIT TRANSACTION
------------------------------------------------
RETURN
MSGERROR:
		ROLLBACK TRANSACTION
		----------------------------------------
		RAISERROR	(@VARMSG, 15, 1)
		RETURN
GO
/****** Object:  StoredProcedure [dbo].[sp_asignar_tarjeta_cliente]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE [dbo].[sp_asignar_tarjeta_cliente]
@cia char(2),@idcli varchar(20),@item int,@id_articulo varchar(20),@nro_tarjeta varchar(20),@uc varchar(10)
AS

UPDATE F_CLIENTE_TARJETA SET id_estado='02',fm=getdate(),uc=@uc
WHERE (cia=@cia) and (id_cliente=@idcli) and (id_estado='01')

INSERT INTO F_CLIENTE_TARJETA (cia,id_cliente,item,id_articulo,nro_tarjeta,id_estado,fc,uc) 
VALUES (@cia,@idcli,@item,@id_articulo,@nro_tarjeta,'01',getdate(),@uc)
GO
/****** Object:  StoredProcedure [dbo].[SP_B_TRANSACCION]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-----------------BUSCAR TRANSACCION----------------------------*/

-- SP_B_TRANSACCION '01','01','0000','00000031'

CREATE PROCEDURE [dbo].[SP_B_TRANSACCION]
@CIA CHAR(2),
@SEDE CHAR(2),
@SERIE_DOC CHAR(4),
@TRANSAC VARCHAR(20)
AS
SELECT CO.CIA,CO.SEDE,CO.NRO_DOC,CO.ID_MOTIVO_SERVICIO,CO.FECHA,convert(varchar(10),CO.FECHA_INICIO,103) 'fece',convert(varchar(10),CO.FECHA_FIN,103) 'fecf',
convert(varchar(10),CO.FECHA_INICIO,108) 'horae',
CO.TIEMPO_DURACION,CO.ID_CLIENTE,CO.ID_PUNTO_VENTA,CO.ID_CONTACTO,CO.ID_TECNICO,CO.OBSERVACION,COD.NRO_FAE,COD.PLACA,CO.ID_ESTADO,
CO.ID_TECNICO_2,CO.ID_TECNICO_3,CO.ID_TECNICO_4
FROM CRONOGRAMA_OPER CO
INNER JOIN CRONOGRAMA_OPER_DETALLE COD ON COD.CIA=CO.CIA AND COD.SEDE=CO.SEDE AND 
COD.ID_TIPO_DOC=CO.ID_TIPO_DOC AND COD.SERIE_DOC=CO.SERIE_DOC AND COD.NRO_DOC=CO.NRO_DOC
WHERE CO.CIA=@CIA AND CO.SEDE=@SEDE AND CO.SERIE_DOC=@SERIE_DOC AND CO.NRO_DOC=@TRANSAC --AND COD.ID_ESTADO='01' AND CO.ID_ESTADO='11'


-- SP_B_TRANSACCION_DET '01','01','0000','00000001'
GO
/****** Object:  StoredProcedure [dbo].[SP_B_TRANSACCION_DET]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_B_TRANSACCION_DET]
@CIA CHAR(2),
@SEDE CHAR(2),
@SERIE_DOC CHAR(4),
@TRANSAC VARCHAR(20)
AS
SELECT COD.ITEM,COD.ID_ARTICULO 'id_articulo',COD.CANTIDAD 'cantidad',COD.DES_ARTICULO 'descripcion',um.ABREVIATURA 'unidad',
AR.nro_parte,upper(MA.DESCRIPCION) 'marca'
FROM CRONOGRAMA_OPER CO
INNER JOIN CRONOGRAMA_OPER_DETALLE COD ON COD.CIA=CO.CIA AND COD.SEDE=CO.SEDE AND 
COD.ID_TIPO_DOC=CO.ID_TIPO_DOC AND COD.SERIE_DOC=CO.SERIE_DOC AND COD.NRO_DOC=CO.NRO_DOC
INNER JOIN dbo.ARTICULO AR ON COD.CIA = AR.CIA AND COD.ID_ARTICULO = AR.ID_ARTICULO
LEFT JOIN dbo.MARCA_ARTICULO MA ON MA.CIA=AR.CIA AND MA.ID_MARCA=AR.ID_MARCA
INNER JOIN dbo.UNIDAD_MEDIDA UM ON AR.CIA = UM.CIA AND AR.ID_UNIDAD = UM.ID_UNIDAD
WHERE CO.CIA=@CIA AND CO.SEDE=@SEDE AND CO.SERIE_DOC=@SERIE_DOC AND CO.NRO_DOC=@TRANSAC
ORDER BY ITEM

------------------------------------------------------------------------------------------------------
GO
/****** Object:  StoredProcedure [dbo].[SP_BUSCAR_ALMACEN]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*

EXEC SP_BUSCAR_ALMACEN '01', '01'

*/
--------------------------------------------
--------------------------------------------
create	PROCEDURE	[dbo].[SP_BUSCAR_ALMACEN]
@CIA		CHAR(2),
@SEDE		CHAR(2),
@ID_ALMACEN	CHAR(2)
AS
--------------------------------------------
--------------------------------------------
SELECT	ID_ALMACEN, DESCRIPCION 
FROM	ALMACEN
WHERE	CIA			= @CIA
AND		SEDE		= @SEDE
AND		ID_ALMACEN	= @ID_ALMACEN
GO
/****** Object:  StoredProcedure [dbo].[SP_BUSCAR_CLI_V]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*------------BUSCAR CORRELATIVO DE CLIENTE_VEHICULO-----------------*/

--SP_BUSCAR_CLI_V '01','20131191040','',''

CREATE PROCEDURE [dbo].[SP_BUSCAR_CLI_V]
@CIA CHAR(2),
@ID_CLIENTE VARCHAR(20),
@NRO_DOC VARCHAR(20),
@PLACA VARCHAR(20)
AS
SELECT CIA,ID_TIPO_DOC,NRO_DOC,ID_CLIENTE,PLACA,ID_ESTADO FROM CLIENTE_VEHICULO WHERE CIA=@CIA AND 
ID_CLIENTE=@ID_CLIENTE AND (NRO_DOC LIKE @NRO_DOC+'%') AND (PLACA LIKE @PLACA+'%')
GO
/****** Object:  StoredProcedure [dbo].[SP_BUSCAR_CLIENTE_PREMIO]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*

EXEC SP_BUSCAR_CLIENTE_PREMIO '01', '0000000001', ''

*/
---------------------------------------------------
---------------------------------------------------
create	PROCEDURE	[dbo].[SP_BUSCAR_CLIENTE_PREMIO]
@CIA			char(2),
@NRO_TARJETA	varchar(20),
@ID_CLIENTE		varchar(20)
AS
---------------------------------------------------
DECLARE	@CODIGO varchar(20)
---------------------------------------------------
IF(LEN(@NRO_TARJETA)> 0)
BEGIN
	SET @CODIGO = (SELECT ISNULL ((SELECT id_Cliente FROM F_CLIENTE_TARJETA WHERE cia = @CIA AND nro_tarjeta = @NRO_TARJETA AND id_estado = '01'),''))
END
---------------------------------------------------
BEGIN
	SELECT	ID_ANALITICA, DESCRIPCION, NRO_DOC
	FROM	ANALITICA
	WHERE   CIA				= @CIA 
	AND		ID_ANALITICA	= CASE WHEN LEN(@NRO_TARJETA) > 0 THEN @CODIGO ELSE @ID_CLIENTE END
	AND		ID_ESTADO		= '01'
END
GO
/****** Object:  StoredProcedure [dbo].[SP_BUSCAR_CRONOGRAMA_OP]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*

SP_BUSCAR_CRONOGRAMA_OP '01','01','0000','00000008'

*/


CREATE PROCEDURE [dbo].[SP_BUSCAR_CRONOGRAMA_OP]
@CIA CHAR(2),@SEDE CHAR(2),@SERIE_DOC VARCHAR(20),@NRO_DOC VARCHAR(20)
AS
SELECT CIA,SEDE,ID_TIPO_DOC,SERIE_DOC,NRO_DOC,ITEM,ID_TIPO_DOC_REF,SERIE_DOC_REF,NRO_DOC_REF,ITEM_REF,ID_ESTADO 
FROM CRONOGRAMA_OPER_PEDIDO 
WHERE CIA=@CIA AND SEDE=@SEDE AND SERIE_DOC=@SERIE_DOC AND  NRO_DOC=@NRO_DOC
GO
/****** Object:  StoredProcedure [dbo].[SP_BUSCAR_DEPARTAMENTO]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*

DECLARE @DESCRIPCION VARCHAR(40)
EXEC USP_BUSCAR_DEPARTAMENTO '01','001','15', @DESCRIPCION OUTPUT
PRINT @DESCRIPCION

*/
---------------------------------------------
---------------------------------------------
create	PROCEDURE	[dbo].[SP_BUSCAR_DEPARTAMENTO]
@CIA			CHAR(2),
@ID_PAIS		VARCHAR(3),
@ID_DPTO		CHAR(2),
@DESCRIPCION	VARCHAR(40) OUTPUT
AS
---------------------------------------------
---------------------------------------------
SET	@DESCRIPCION	=	(
							SELECT ISNULL ((
									SELECT	TOP(1)des_dpto
									FROM	ubicacion			
									WHERE	cia		= @CIA 
									AND		id_pais = @ID_PAIS
									AND		id_dpto	= @ID_DPTO),'')
						)
GO
/****** Object:  StoredProcedure [dbo].[SP_BUSCAR_DISTRITO]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*

DECLARE @DESCRIPCION VARCHAR(40)
EXEC USP_BUSCAR_DISTRITO '01','001','15','01','43', @DESCRIPCION OUTPUT
PRINT @DESCRIPCION

*/
---------------------------------------------
---------------------------------------------
create	PROCEDURE	[dbo].[SP_BUSCAR_DISTRITO]
@CIA			CHAR(2),
@ID_PAIS		VARCHAR(3),
@ID_DPTO		CHAR(2),
@ID_PROVINCIA	CHAR(2),
@ID_DISTRITO	CHAR(2),
@DESCRIPCION	VARCHAR(40) OUTPUT
AS
---------------------------------------------
---------------------------------------------
SET	@DESCRIPCION	=	(
							SELECT ISNULL ((
									SELECT	TOP(1)des_distrito
									FROM	ubicacion			
									WHERE	cia		= @CIA 
									AND		id_pais = @ID_PAIS
									AND		id_dpto	= @ID_DPTO
									AND		id_provincia = @ID_PROVINCIA
									AND		id_distrito	= @ID_DISTRITO),'')
						)
GO
/****** Object:  StoredProcedure [dbo].[SP_BUSCAR_MOTIVO_ALMACEN]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*

EXEC SP_BUSCAR_MOTIVO_ALMACEN '01', 'EE'

*/
----------------------------------------
----------------------------------------
create	PROCEDURE	[dbo].[SP_BUSCAR_MOTIVO_ALMACEN]
@CIA				CHAR(2),
@ID_MOTIVO_ALMACEN	CHAR(2)
AS
----------------------------------------
----------------------------------------
SELECT	ID_MOTIVO_ALMACEN, DESCRIPCION
FROM	MOTIVO_ALMACEN
WHERE	CIA					= @CIA
AND		ID_MOTIVO_ALMACEN	= @ID_MOTIVO_ALMACEN
GO
/****** Object:  StoredProcedure [dbo].[SP_BUSCAR_PROVINCIA]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*

DECLARE @DESCRIPCION VARCHAR(40)
EXEC USP_BUSCAR_PROVINCIA '01','001','15','01', @DESCRIPCION OUTPUT
PRINT @DESCRIPCION

*/
---------------------------------------------
---------------------------------------------
create	PROCEDURE	[dbo].[SP_BUSCAR_PROVINCIA]
@CIA			CHAR(2),
@ID_PAIS		VARCHAR(3),
@ID_DPTO		CHAR(2),
@ID_PROVINCIA	CHAR(2),
@DESCRIPCION	VARCHAR(40) OUTPUT
AS
---------------------------------------------
---------------------------------------------
SET	@DESCRIPCION	=	(
							SELECT ISNULL ((
									SELECT	TOP(1)des_provincia
									FROM	ubicacion			
									WHERE	cia		= @CIA 
									AND		id_pais = @ID_PAIS
									AND		id_dpto	= @ID_DPTO
									AND		id_provincia = @ID_PROVINCIA),'')
						)
GO
/****** Object:  StoredProcedure [dbo].[sp_buscar_tarjeta_cliente]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*

--[SP_BUSCAR_TARJETA_CLIENTE] '01','','','01','001'

[SP_BUSCAR_TARJETA_CLIENTE] '01','01'

*/

CREATE PROCEDURE [dbo].[sp_buscar_tarjeta_cliente]
@cia char(2),@documento varchar(20),@descripcion varchar(200),@estado varchar(2),@tarjeta varchar(20)
AS
-------------------------------------------------------------------------------
DECLARE @sExecute varchar(max),@sSelect varchar(max),@sCliente varchar(max),@sDescli varchar(max),
@sTarjeta varchar(max),@sGroupby varchar(max),@sOrderby varchar(max)
-------------------------------------------------------------------------------
SELECT @sExecute='',@sSelect='',@sCliente='',@sDescli='',@sTarjeta='',@sGroupby='',@sOrderby=''
-------------------------------------------------------------------------------
SELECT @sSelect='
a.nro_doc ''documento'',a.descripcion ''descripcion'',ct.nro_tarjeta ''tarjeta'',a.id_analitica ''cliente'',
ct.id_articulo ''articulo'',ct.item ''item'',avg(ct.item) ''contador'',ct.id_estado
FROM analitica a
LEFT JOIN F_CLIENTE_TARJETA ct ON ct.id_cliente=a.id_analitica and ct.cia=a.cia
WHERE (a.cia='''+@cia+''') 
and ((ct.id_estado = '''+@estado+''')
or ct.nro_tarjeta is null)'
-------------------------------------------------------------------------------

IF LEN(@documento)>0 BEGIN SELECT @sCliente='and a.nro_doc='''+@documento+'''' END ELSE BEGIN SELECT @sCliente='' END
-------------------------------------------------------------------------------
IF LEN(@descripcion)>0 BEGIN SELECT @sDescli='and a.descripcion='''+@descripcion+'''' END ELSE BEGIN SELECT @sDescli='' END
-------------------------------------------------------------------------------
IF LEN(@tarjeta)>0 BEGIN SELECT @sTarjeta='and ct.nro_tarjeta='''+@tarjeta+'''' END ELSE BEGIN SELECT @sTarjeta='' END

-------------------------------------------------------------------------------
SELECT @sGroupby='GROUP BY a.nro_doc,a.descripcion,ct.nro_tarjeta,a.id_analitica,ct.id_articulo,ct.item,ct.id_estado'
------------------------------------------------------------------------------------------------------------------
SELECT @sExecute = @sSelect +' '+ @sCliente+' '+@sDescli+' '+@sTarjeta +' '+ @sGroupby
-------------------------------------------------------------------------------
--PRINT @sExecute
EXEC ('SELECT '+ @sExecute )
GO
/****** Object:  StoredProcedure [dbo].[SP_BUSCAR_TIPO_DOCUMENTO]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*

EXEC SP_BUSCAR_TIPO_DOCUMENTO '01', 'NE'
select * from TIPO_DOCUMENTO
*/
----------------------------------------
----------------------------------------
create	PROCEDURE	[dbo].[SP_BUSCAR_TIPO_DOCUMENTO]
@CIA			CHAR(2),
@ID_TIPO_DOC	CHAR(2)
AS
----------------------------------------
----------------------------------------
SELECT	ID_TIPO_DOC, DESCRIPCION
FROM	TIPO_DOCUMENTO
WHERE	CIA			= @CIA
AND		ID_TIPO_DOC	= @ID_TIPO_DOC
GO
/****** Object:  StoredProcedure [dbo].[sp_combo_tarjetas_fidelizacion]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE [dbo].[sp_combo_tarjetas_fidelizacion]
@cia CHAR(2)
AS
SELECT id_articulo,descripcion FROM articulo 
WHERE cia='01' and id_clasifica1='017' and id_clasifica2='001'
GO
/****** Object:  StoredProcedure [dbo].[SP_CRONO_HISTORIAL]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- SP_CRONO_HISTORIAL '01','01','20100111838','19-10-2007','24-10-2010'

create PROCEDURE [dbo].[SP_CRONO_HISTORIAL]
@CIA CHAR(2),
@SEDE CHAR(2),
@CLIENTE VARCHAR(20),
@FECHA1 DATETIME,
@FECHA2 DATETIME
AS
SELECT ST.NRO_DOC 'documento',A.DESCRIPCION 'cliente',MS.DESCRIPCION 'motivo',
		ST.INFORMACION_TECNICA 'solucion',ST.INICIO_SERVICIO,ST.FIN_SERVICIO
FROM SERVICIO_TECNICO ST
INNER JOIN MOTIVO_SERVICIO MS ON MS.CIA=ST.CIA AND MS.ID_MOTIVO_SERVICIO=ST.ID_MOTIVO_SERVICIO
INNER JOIN ANALITICA A ON A.CIA=ST.CIA AND A.ID_ANALITICA=ST.ID_CLIENTE
WHERE ST.CIA=@CIA AND ST.SEDE=@SEDE AND ST.ID_CLIENTE=@CLIENTE AND ST.ID_ESTADO!='12' AND  
((CONVERT(VARCHAR(8),ST.INICIO_SERVICIO,112) BETWEEN CONVERT(VARCHAR(8),@FECHA1,112) AND CONVERT(VARCHAR(8),@FECHA2,112))
OR
(CONVERT(VARCHAR(8),ST.FIN_SERVICIO,112) BETWEEN CONVERT(VARCHAR(8),@FECHA1,112) AND CONVERT(VARCHAR(8),@FECHA2,112)))
ORDER BY ST.INICIO_SERVICIO
GO
/****** Object:  StoredProcedure [dbo].[SP_CUADRO_DIARIO]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROC [dbo].[SP_CUADRO_DIARIO]
@CIA CHAR(2),@SEDE CHAR(2),@ID_TURNO CHAR(2),@F_INI DATETIME ,	@F_FIN DATETIME
AS
---------------------------------------------------
DECLARE @F_INICIAL VARCHAR(10)
DECLARE @F_FINAL VARCHAR(10)
DECLARE @TOTAL NUMERIC(15,0)
DECLARE @DEPOSITO NUMERIC(15,0)
DECLARE @DIFERENCIA NUMERIC(15,0)
---------------------------------------------------
SET @F_INICIAL = CONVERT(VARCHAR(10),@F_INI,112)
SET @F_FINAL   = CONVERT(VARCHAR(10),@F_FIN,112)
---------------------------------------------------
SELECT CO.DESCRIPCION 'CIA',SE.DESCRIPCION 'SEDE',EV.UC,
(SELECT CONVERT(INT,SUM(V.TOTAL)) FROM E_VENTA V WHERE V.UC=EV.UC AND (CONVERT(VARCHAR(10),V.FECHA,112) BETWEEN @F_INICIAL AND @F_FINAL)) 'MONTO',
(SELECT CONVERT(INT,SUM(DCB.TOTAL)) FROM DOCUMENTO_CB DCB WHERE DCB.USR_DESPACHADOR=EV.UC AND (CONVERT(VARCHAR(10),FECHA,112) BETWEEN @F_INICIAL AND @F_FINAL)) 'DEPOSITO',
(SELECT CONVERT(INT,SUM(TOTAL)) FROM E_VENTA WHERE UC=EV.UC AND (CONVERT(VARCHAR(10),FECHA,112) BETWEEN @F_INICIAL AND @F_FINAL))-
(SELECT CONVERT(INT,SUM(TOTAL)) FROM DOCUMENTO_CB WHERE USR_DESPACHADOR=EV.UC AND (CONVERT(VARCHAR(10),FECHA,112) BETWEEN @F_INICIAL AND @F_FINAL)) 'DIFERENCIA'
FROM E_VENTA EV
INNER JOIN COMPANIA CO ON CO.CIA=EV.CIA
INNER JOIN SEDE SE ON SE.CIA=EV.CIA AND SE.SEDE=EV.SEDE
---------------------------------------------------
WHERE EV.CIA=@CIA AND EV.SEDE=@SEDE AND EV.ID_TURNO=@ID_TURNO AND (CONVERT(VARCHAR(10),EV.FECHA,112) BETWEEN @F_INICIAL AND @F_FINAL)
---------------------------------------------------
GROUP BY CO.DESCRIPCION,SE.DESCRIPCION,EV.UC
GO
/****** Object:  StoredProcedure [dbo].[SP_CUADRO_DIARIO_02]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROC [dbo].[SP_CUADRO_DIARIO_02]
@CIA CHAR(2),@SEDE CHAR(2),@ID_TURNO CHAR(2),@F_INI DATETIME ,	@F_FIN DATETIME
AS
---------------------------------------------------
DECLARE @F_INICIAL VARCHAR(10)
DECLARE @F_FINAL VARCHAR(10)
---------------------------------------------------
SET @F_INICIAL = CONVERT(VARCHAR(10),@F_INI,112)
SET @F_FINAL   = CONVERT(VARCHAR(10),@F_FIN,112)
---------------------------------------------------
SELECT A.DESCRIPCION 'ARTICULO',EV.ID_SURTIDOR 'SURTIDOR',EV.ID_MANGUERA 'MANGUERA',MIN(EVD.NRO_DOC) 'DOC INICIAL',MAX(EVD.NRO_DOC) 'DOC FINAL',
SUM(EV.CANTIDAD) 'CANTIDAD',EV.PRECIO 'PRECIO',(SUM(EV.CANTIDAD)*EV.PRECIO) 'TOTAL'
FROM E_VENTA EV
INNER JOIN E_VENTA_DOCUMENTO EVD ON EV.CIA=EVD.CIA AND EV.SEDE=EVD.SEDE AND EV.ID_VENTA=EVD.ID_VENTA
INNER JOIN ARTICULO A ON A.CIA=EV.CIA AND A.ID_ARTICULO=EV.ID_ARTICULO
INNER JOIN E_TURNO_CONTROL ETC ON ETC.CIA=EV.CIA AND ETC.SEDE=EV.SEDE AND ETC.ID_TURNO_CONTROL=EV.ID_TURNO_CONTROL
---------------------------------------------------
WHERE EV.CIA=@CIA AND EV.SEDE=@SEDE AND EV.ID_TURNO=@ID_TURNO AND (CONVERT(VARCHAR(10),EV.FECHA,112) BETWEEN @F_INICIAL AND @F_FINAL)
---------------------------------------------------
GROUP BY A.DESCRIPCION,EV.ID_SURTIDOR,EV.ID_MANGUERA,EV.PRECIO
--ORDER BY A.DESCRIPCION,EV.ID_SURTIDOR,EV.ID_MANGUERA
GO
/****** Object:  StoredProcedure [dbo].[SP_DEPOSITO_LISTAR]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
SP_LISTAR_COMBO_MONEDA '01'
SP_DEPOSITO_LISTAR '1','01','01','','','','','','','','','','','','','',''
SP_DEPOSITO_LISTAR '1','01','01','','87','0000','00000002','','','','','','','','','',''
SP_DEPOSITO_LISTAR '1','01','01','','','','','','','','','','01','','','',''
	sp_help DOCUMENTO_CB
select * from  dbo.DOCUMENTO_CB	 order by tipo_cambio				select * from  DOCUMENTO_CB_DETALLE 
select * from  E_turno				select * from  E_SURTIDOR	select * from moneda		select * from  usuario	
select * from netdat.dbo.caja_banco  where CIA='01' AND id_caja_banco like 'bov' +'%'

SELECT * FROM TIPO_DOCUMENTO_SERIE 
*/
---------------------------------------------------
CREATE	PROC	[dbo].[SP_DEPOSITO_LISTAR]
@indicador	CHAR(1),@cia CHAR(2),@sede	CHAR(2),@id_caja_banco	VARCHAR(5),
@id_tipo_doc CHAR(2),@serie_doc CHAR(4),@nro_doc varchar(100),
@fec1 datetime,@fec2 datetime,@nro_operacion VARCHAR(20),@glosa VARCHAR(100),@anio VARCHAR(4),@mes CHAR(2),
@id_estado CHAR(2),@UD VARCHAR(20),@id_turno VARCHAR(100),@id_surtidor VARCHAR(100)
AS
-----------------------------------------------------------------------------------------------------------------------
DECLARE @FECHA1 VARCHAR(8),@FECHA2 VARCHAR(8),@sSelect varchar(MAX)
DECLARE	@sFiltroIdCajaBanco varchar(MAX),@sFiltroIdTipoDoc varchar(MAX),@sFiltroSerieDoc varchar(MAX),@sFiltroNroDoc varchar(MAX)
DECLARE @sFiltroFecha varchar(MAX), @sFiltroTotal varchar(MAX),@sFiltroGlosa varchar(MAX), @sFiltroAnio varchar(MAX),@sFiltroMes varchar(MAX)
DECLARE @sFiltroEstado varchar(MAX),@sFiltroTipoCambio varchar(MAX),@sFiltroIdTurno varchar(MAX),@sFiltroNroTurno varchar(MAX)
DECLARE @sFiltroDespachador varchar(MAX),@sFiltroIdSurtidor varchar(MAX),@sOrderBy varchar(MAX), @sGroupBy varchar(MAX), @sExecute varchar(MAX)
----------------------------------------------------------------------------------------------------------------------
SET @FECHA1 = CONVERT(VARCHAR(8),@fec1,112)
SET @FECHA2 = CONVERT(VARCHAR(8),@fec2,112)
SELECT @sSelect='', @sFiltroIDCajaBanco='',@sFiltroSerieDoc='', @sFiltroNroDoc='', @sFiltroFecha='',@sFiltroTotal ='', @sFiltroGlosa ='',@sFiltroAnio ='',@sFiltroMes=''
SELECT @sFiltroEstado='', @sFiltroTipoCambio='', @sFiltroIdTurno='', @sFiltroNroTurno='',@sFiltroDespachador ='', @sFiltroIdSurtidor =''
SELECT @sOrderBy='',@sGroupBy='',@sExecute=''
-----------------------------------------------------------------------------------------------------------------
IF(@INDICADOR='1')
BEGIN
	SELECT @sSelect='dcb.id_tipo_doc,tds.serie ''serie_doc'',nro_doc,tds.serie +''-''+ dcb.nro_doc AS ''numero-doc'',
		dcb.id_caja_banco,cb.descripcion ''descripcion_caja'',fecha_hora=CONVERT(VARCHAR(10),dcb.fecha,103) +space(2)+convert(char(5),dcb.fecha, 114),
		dcb.nro_operacion,dcb.id_motivo,convert(decimal(15,2),dcb.total) as ''total'',
		dcb.glosa,dcb.flag_es,dcb.anio,dcb.mes,	DATENAME(MONTH,dcb.FECHA) ''nom_mes'',(e.abreviatura) ''estado'',dcb.id_estado,
		convert(numeric(15,3),dcb.tipo_cambio) ''tipo_cambio'',	usr_despachador,u.descripcion ''descripcion_usuario'',
		dcb.id_turno,t.descripcion  ''descripcion_turno'',dcb.id_surtidor,es.descripcion ''descripcion_surtidor'',
		fecha=CONVERT(VARCHAR(10),dcb.fecha,103),hora=convert(char(5),dcb.fecha, 114),
		cb.id_moneda,UPPER(m.descripcion) ''descripcion_moneda'',m.abreviatura
		from	DOCUMENTO_CB dcb
		LEFT JOIN estado e      ON e.cia=dcb.cia and e.id_estado=dcb.id_estado 
		LEFT JOIN E_turno t on t.cia=dcb.cia and t.id_turno=dcb.id_turno --and t.id_estado=dcb.id_estado 
		LEFT JOIN e_surtidor es on es.cia=dcb.cia and  es.id_surtidor=dcb.id_surtidor
		LEFT JOIN TIPO_DOCUMENTO_SERIE tds ON tds.cia=dcb.cia AND tds.id_tipo_doc=dcb.id_tipo_doc
		LEFT join caja_banco cb on cb.cia=dcb.cia and cb.id_caja_banco=dcb.id_caja_banco
		LEFT join moneda m on m.cia=cb.cia and m.id_moneda=cb.id_moneda
		LEFT join usuario u on u.cia=dcb.cia AND u.id_usuario=dcb.usr_despachador
		WHERE	dcb.CIA='''+@CIA+'''  AND SEDE='''+@SEDE+'''				'		
	SELECT @sGroupBy=' GROUP BY
		dcb.id_tipo_doc,tds.serie ,nro_doc,tds.serie +''-''+ dcb.nro_doc,dcb.id_caja_banco,cb.descripcion,
		CONVERT(VARCHAR(10),dcb.fecha,103) +space(2)+convert(char(5),dcb.fecha, 114),dcb.nro_operacion,
		dcb.id_motivo,convert(decimal(15,2),dcb.total),dcb.glosa,dcb.flag_es,dcb.anio,dcb.mes,DATENAME(MONTH,dcb.FECHA),
		(e.abreviatura),dcb.id_estado,convert(numeric(15,3),dcb.tipo_cambio),usr_despachador,u.descripcion,dcb.id_turno,t.descripcion,
		dcb.id_surtidor,es.descripcion,CONVERT(VARCHAR(10),dcb.fecha,103),convert(char(5),dcb.fecha, 114),cb.id_moneda,m.descripcion,m.abreviatura '
	--------------------------------------------------------------------------------------------
	IF  LEN(ISNULL(@id_caja_banco,''))>0  AND @id_caja_banco<>'%'
			BEGIN  SELECT @sFiltroIDCajaBanco=' and dcb.id_caja_banco in('''+@id_caja_banco+''') 'END
	ELSE	BEGIN  SELECT @sFiltroIDCajaBanco	=''	END
--------------------------------------------------------------------------------------------
	IF  LEN(ISNULL(@serie_doc,''))>0  AND @serie_doc<>'%'
			BEGIN  SELECT @sFiltroSerieDoc=' and tds.serie in('''+@serie_doc+''') 'END
	ELSE	BEGIN  SELECT @sFiltroSerieDoc	=''	END
--------------------------------------------------------------------------------------------
	IF  LEN(ISNULL(@id_tipo_doc,''))>0  AND @id_tipo_doc<>'%'
			BEGIN  SELECT @sFiltroIdTipoDoc=' and dcb.id_tipo_doc in('''+@id_tipo_doc+''') 'END
	ELSE	BEGIN  SELECT @sFiltroIdTipoDoc	=''	END
	--------------------------------------------------------------------------------------------
	IF  LEN(ISNULL(@NRO_DOC,''))>0 
			BEGIN  SELECT @sFiltroNroDoc=' and dcb.nro_doc like ''%''+'''+@NRO_DOC +''' +''%'' ' END
	ELSE	BEGIN  SELECT @sFiltroNroDoc	=''	END
	--------------------------------------------------------------------------------------------	
	IF  ISNULL(@FECHA1,'19000101') <> '19000101'  AND  ISNULL(@FECHA2,'19000101') <> '19000101'
			BEGIN 	SELECT @sFiltroFecha=' and convert(varchar(8),dcb.fecha,112) between  '''+@FECHA1+'''  and  '''+@FECHA2+''''	END
	ELSE	BEGIN  	SELECT @sFiltroFecha	=''		END	
	--------------------------------------------------------------------------------------------
	IF  LEN(ISNULL(@anio,''))>0  AND @anio<>'%'
			BEGIN  SELECT @sFiltroAnio=' and dcb.ANIO in('''+@anio+''') 'END
	ELSE	BEGIN  SELECT @sFiltroAnio	=''END
		--------------------------------------------------------------------------------------------
	IF  LEN(ISNULL(@mes,''))>0  AND @mes<>'%'
			BEGIN  SELECT @sFiltroMes=' and dcb.MES  in('''+@mes+''') 'END
	ELSE	BEGIN  SELECT @sFiltroMes	=''END
		--------------------------------------------------------------------------------------------
	IF  LEN(ISNULL(@id_estado,''))>0 AND @id_estado<>'%' 
			BEGIN   SELECT @sFiltroEstado=' and dcb.ID_ESTADO  in('''+@id_estado+''') ' END
	ELSE	BEGIN	SELECT @sFiltroEstado=''	END
	--------------------------------------------------------------------------------------------
	IF  LEN(ISNULL(@id_turno,''))>0 
			BEGIN  SELECT @sFiltroIdTurno=' and dcb.id_turno like ''%''+'''+@id_turno+''' +''%'' '	 END
	ELSE	BEGIN  SELECT @sFiltroIdTurno	=''END
		--------------------------------------------------------------------------------------------
	IF  LEN(ISNULL(@id_surtidor,''))>0 
			BEGIN SELECT @sFiltroIdSurtidor=' and dcb.id_surtidor like ''%''+'''+@id_surtidor+''' +''%'' '	 END
	ELSE	BEGIN SELECT @sFiltroIdSurtidor	=''	END
	----------------------------------------------------
	IF  LEN(ISNULL(@GLOSA,''))>0 AND @GLOSA<>'%' 
			BEGIN  SELECT @sFiltroTipoCambio=' and dcb.glosa  in('''+@GLOSA+''') 'END
	ELSE	BEGIN  SELECT @sFiltroTipoCambio	=''	END
	--------------------------------------------------------------------------------------------
	SELECT @sOrderBy	=' order by nro_doc'
	---------------------------------------------------------------------------------------------
	 SELECT @sExecute = @sSelect +''+ @sFiltroIDCajaBanco +''+ @sFiltroIdTipoDoc+''+ @sFiltroSerieDoc  +''+@sFiltroNroDoc +''+
			@sFiltroFecha +''+ 	@sFiltroAnio +''+@sFiltroMes+''+@sFiltroEstado+''+
			@sFiltroTipoCambio +''+ @sFiltroIdTurno  +''+ @sFiltroIdSurtidor+''+ @sGroupBy+''+ @sOrderBy
	PRINT @sExecute
	EXEC ('SELECT '+ @sExecute )	 
--------------------------------------------------------------------------------------------
END
----------------------------------------------------------------------------------------------------------------
IF(@INDICADOR='2')
BEGIN
	SELECT @sSelect=''
end
GO
/****** Object:  StoredProcedure [dbo].[SP_DEPOSITO_MANTENIMIENTO]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
sp_help DOCUMENTO_CB					sp_help DOCUMENTO_CB_DETALLE		sp_help	caja_banco
select * from  DOCUMENTO_CB	
select * from  DOCUMENTO_CB_DETALLE 

SELECT * FROM DBO.TIPO_DOCUMENTO 28
SELECT * FROM DBO.TIPO_DOCUMENTO_SERIE where id_tipo_doc ='DB'

select * from netdat.dbo.caja_banco  where CIA='01' AND id_caja_banco like 'bov' +'%'
select * from tipo_cta_bco
select * from banco
-----------------------------------------
delete from DOCUMENTO_CB	
delete from DOCUMENTO_CB_DETALLE 
update TIPO_DOCUMENTO_SERIE set correlativo='0' where CIA= '01' AND ID_TIPO_DOC IN('DB')  

------------------------------				------------
[SP_TRAER_SERIE_DOCUMENTO] '01','DB'

[SP_DEPOSITO_MANTENIMIENTO]
'1','01','02','DB','0000','','02','95626','65656565.00','3.800','admin','DOLARES AMERICANOS','02',
	'01','02','SISTEMAS','01','1','01'
	
[SP_DEPOSITO_MANTENIMIENTO]
'2','01','02','DB','0000','00000001','02','95626','65656565.00','3.800','admin','DOLARES AMERICANOS','02',
	'01','02','SISTEMAS','01','1','01'
	
[SP_DEPOSITO_MANTENIMIENTO]	'4','01','01','28','','','','','','','','','','','','','','',''
GO
[SP_DEPOSITO_MANTENIMIENTO]	'5','01','','','','','','','','','','','','','','','','',''

*/

-----------------------------------------------
CREATE	PROCEDURE	[dbo].[SP_DEPOSITO_MANTENIMIENTO]
@INDICADOR				CHAR(1),
@CIA					CHAR(2), 
@SEDE					CHAR(2),
@ID_TIPO_DOC			CHAR(2), 
@SERIE_DOC				VARCHAR(4),
@NRODOC					varchar(20),
@ID_CAJA_BANCO			CHAR(2),
@NRO_OPERACION			VARCHAR(20),
@TOTAL					FLOAT,
@TIPO_CAMBIO			FLOAT,
@UC						VARCHAR(25),
@GLOSA					VARCHAR(100),
@ID_ESTADO				CHAR(2),
@ID_TURNO				CHAR(2),
@NRO_TURNO				CHAR(2),	
@USR_DESPACHADOR		VARCHAR(100),		
@ID_SURTIDOR			CHAR(2),
@ITEM					char(1),
@ID_MOTIVO				char(2)
AS
-----------------------------------------------
DECLARE @VARMSG	VARCHAR(MAX),@COUNT	INT,@NRO_DOC VARCHAR(25),@MES CHAR(2),@CORRELATIVO	INT, @ID_MONEDA	VARCHAR(5)
-----------------------------------------------------------------------------------------
SET	@MES = REPLICATE('0', (2 - LEN(MONTH(GETDATE())))) + CONVERT(VARCHAR(2),MONTH(GETDATE()))
SET	@ID_MONEDA=(SELECT ID_CAJA_BANCO FROM CAJA_BANCO WHERE CIA=@CIA AND ID_MONEDA=@ID_CAJA_BANCO AND ID_CAJA_BANCO  LIKE 'BOV' + '%')
	-------------------------------------------------------------------------------------------
SET	@NRO_DOC=(SELECT ISNULL((SELECT	(REPLICATE('0',(8 - LEN(CORRELATIVO + 1))) + CONVERT(VARCHAR(8),(CORRELATIVO + 1)))
	FROM TIPO_DOCUMENTO_SERIE WHERE CIA=@CIA AND ID_TIPO_DOC=@ID_TIPO_DOC AND SERIE=@SERIE_DOC AND ID_ESTADO='01'),'00000001'))	
	----------------------------------------------------------------------------------------
BEGIN TRANSACTION
	---------------------------------------
IF (@INDICADOR = '1')	--		INSERTAR
BEGIN	
	---------------------------------------
	INSERT INTO DOCUMENTO_CB
	(
		CIA, SEDE,ID_CAJA_BANCO,ID_TIPO_DOC,NRO_DOC, FECHA, NRO_OPERACION, TOTAL, GLOSA, FLAG_ES, ANIO, MES,
		ID_ESTADO,TIPO_CAMBIO,FLAG_ENVIO, SE, FC, UC, ID_TURNO, NRO_TURNO , USR_DESPACHADOR, ID_SURTIDOR
	)
	VALUES
	(
		@CIA,@SEDE,@ID_MONEDA,@ID_TIPO_DOC,@NRO_DOC, GETDATE(),@NRO_OPERACION, @TOTAL, @GLOSA,'1',year( GETDATE()),@MES,
		'01', @TIPO_CAMBIO,'1', @SEDE, GETDATE(),@UC,@ID_TURNO, @NRO_TURNO , @USR_DESPACHADOR, @ID_SURTIDOR
	)
	------------------------------------------
	IF @@ERROR <> 0 OR @@ROWCOUNT <> 1
	BEGIN
		---------------------------------------
		SET		@VARMSG	= 'SE PRODUJO UN ERROR DURANTE EL PROCESO DE GRABACION DEL DOCUMENTO_CB. NO SE GRABARON LOS DATOS.'
		GOTO	MSGERROR
		----------------------------------------
	END		
	------------------------------------------------------
	INSERT INTO DOCUMENTO_CB_DETALLE
	(
		CIA,SEDE,ID_CAJA_BANCO,ID_TIPO_DOC,NRO_DOC,ITEM,ID_MOTIVO,MONTO,gLOSA,ID_ESTADO,FLAG_ENVIO,SE,FC,UC,TIPO_CAMBIO
	)
	VALUES
	(
		@CIA,@SEDE,@ID_MONEDA,@ID_TIPO_DOC,@NRO_DOC,@ITEM,@ID_MOTIVO,@TOTAL,@GLOSA,'01','1',@SEDE,GETDATE(),@UC,@TIPO_CAMBIO		
	)	
	------------------------------------------
	IF @@ERROR <> 0 OR @@ROWCOUNT <> 1
	BEGIN
		---------------------------------------
		SET		@VARMSG	= 'SE PRODUJO UN ERROR DURANTE EL PROCESO DE GRABACION DEL DOCUMENTO_CB. NO SE GRABARON LOS DATOS.'
		GOTO	MSGERROR
		----------------------------------------
	END
	-------------------------------------------			
		UPDATE	TIPO_DOCUMENTO_SERIE			/*		select * from TIPO_DOCUMENTO_SERIE */
			SET		CORRELATIVO			= CONVERT(INT, @NRO_DOC)		
			WHERE	CIA					= @CIA 	
			AND		ID_TIPO_DOC			= @ID_TIPO_DOC
			AND		SERIE				= @SERIE_DOC	
		IF @@ERROR <> 0 OR @@ROWCOUNT <> 1
		BEGIN
			---------------------------------------
			SET		@VARMSG	= 'SE PRODUJO UN ERROR DURANTE EL PROCESO DE ACTUALIZAR DEL TIPO_DOCUMENTO_SERIE. NO SE ACTUALIZARON LOS DATOS.'
			GOTO	MSGERROR
			----------------------------------------
		END	
----------------------------------------------------------------------------------------	
END	
								
IF (@INDICADOR = '2')	------- ACTUALIZAR
BEGIN	
	UPDATE	DOCUMENTO_CB		
	SET		TOTAL			=	@TOTAL,
			TIPO_CAMBIO		=	@TIPO_CAMBIO,
			FM				=	GETDATE(),
			UM				=	@UC,
			GLOSA			=	@GLOSA,
			ID_TURNO		=	@ID_TURNO,
			NRO_TURNO		=	@NRO_TURNO,
			USR_DESPACHADOR	=	@USR_DESPACHADOR,
			ID_SURTIDOR		=	@ID_SURTIDOR,
			ID_ESTADO		=	@ID_ESTADO								
	WHERE	CIA				=	@CIA 
	AND		SEDE			=	@SEDE 
	AND		ID_TIPO_DOC		=	@ID_TIPO_DOC	
	AND		NRO_DOC			=	@NRODOC	
	-------------------------------------------
	IF @@ERROR <> 0 OR @@ROWCOUNT <> 1
	BEGIN
		---------------------------------------
		SET		@VARMSG	= 'SE PRODUJO UN ERROR DURANTE EL PROCESO DE ACTUALIZAR EL DOCUMENTO_CB. NO SE ACTUALIZARON LOS DATOS.'
		GOTO	MSGERROR
		----------------------------------------
	END 
	-----------------------------------------------------------------
	UPDATE	DOCUMENTO_CB_DETALLE		/*		select * from  DOCUMENTO_CB_DETALLE		*/
	SET		MONTO			=	@TOTAL,	
			GLOSA			=	@GLOSA,	
			FM				=	GETDATE(),
			UM				=	@UC,			
			TIPO_CAMBIO		=	@TIPO_CAMBIO,
			ID_ESTADO		=	@ID_ESTADO									
	WHERE	CIA				=	@CIA 
	AND		SEDE			=	@SEDE 
	AND		ID_TIPO_DOC		=	@ID_TIPO_DOC
	AND		NRO_DOC			=	@NRODOC
	-------------------------------------------
	IF @@ERROR <> 0 OR @@ROWCOUNT <> 1
	BEGIN
		---------------------------------------
		SET		@VARMSG	= 'SE PRODUJO UN ERROR DURANTE EL PROCESO DE ACTUALIZAR EL DOCUMENTO_CB_DETALLE. NO SE ACTUALIZARON LOS DATOS.'
		GOTO	MSGERROR
		----------------------------------------
	END 	
END

IF (@INDICADOR = '3')	-------	ELIMINAR
BEGIN
		UPDATE	DOCUMENTO_CB
		SET		ID_ESTADO		= '02',	
				FA				= GETDATE(), 
				UA				= @Uc			
		WHERE	CIA				= @CIA 
		AND		SEDE			= @SEDE 
		AND		ID_TIPO_DOC		= @ID_TIPO_DOC
		AND		NRO_DOC			= @NRODOC
		-------------------------------------------
		IF @@ERROR <> 0 OR @@ROWCOUNT <> 1
		BEGIN
			---------------------------------------
			SET		@VARMSG	= 'SE PRODUJO UN ERROR DURANTE EL PROCESO DE ELIMINACION DEL DOCUMENTO_CB. NO SE ELIMINO EL REGISTRO.'
			GOTO	MSGERROR
			----------------------------------------
		END 
		UPDATE	DOCUMENTO_CB_DETALLE
		SET		ID_ESTADO		= '02',	
				FA				= GETDATE(),  
				UA				= @Uc			
		WHERE	CIA				= @CIA 
		AND		SEDE			= @SEDE 
		AND		ID_TIPO_DOC		= @ID_TIPO_DOC
		AND		NRO_DOC			= @NRODOC
		-------------------------------------------
		IF @@ERROR <> 0 OR @@ROWCOUNT <> 1
		BEGIN
			---------------------------------------
			SET		@VARMSG	= 'SE PRODUJO UN ERROR DURANTE EL PROCESO DE ELIMINACION DEL DOCUMENTO_CB_DETALLE. NO SE ELIMINO EL REGISTRO.'
			GOTO	MSGERROR
			----------------------------------------
		END 
END


-------------------------------------------------------------------------------------------
IF (@INDICADOR = '4')	--	TRAE ULTIMO DOCUMENTO
BEGIN	
	SELECT @NRO_DOC	
END

-------------------------------------------------------------------------------------------
IF (@INDICADOR = '5')	--	TRAE MONEDA
BEGIN	
	SELECT id_moneda,UPPER(m.descripcion) 'descripcion'	from moneda m
	left join estado e on e.cia=m.cia and E.id_estado=m.id_estado
	where m.cia=@CIA 	 AND m.id_estado='01'
END

------------------------------------------------------------------------------------------------	
COMMIT TRANSACTION
------------------------------------------------
RETURN
MSGERROR:
		ROLLBACK TRANSACTION
		----------------------------------------
		RAISERROR	(@VARMSG, 15, 1)
		RETURN
GO
/****** Object:  StoredProcedure [dbo].[SP_DIAS_SEMANA]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE [dbo].[SP_DIAS_SEMANA]
AS
DECLARE @dt_LUNES DATETIME
DECLARE @s_LUNES VARCHAR(20)

DECLARE @dt_MARTES DATETIME
DECLARE @s_MARTES VARCHAR(20)

DECLARE @dt_MIERCOLES DATETIME
DECLARE @s_MIERCOLES VARCHAR(20)

DECLARE @dt_JUEVES DATETIME
DECLARE @s_JUEVES VARCHAR(20)

DECLARE @dt_VIERNES DATETIME
DECLARE @s_VIERNES VARCHAR(20)

DECLARE @dt_SABADO DATETIME
DECLARE @s_SABADO VARCHAR(20)

DECLARE @dt_DOMINGO DATETIME
DECLARE @s_DOMINGO VARCHAR(20)

SET @dt_LUNES = (SELECT DATEADD(wk, DATEDIFF(wk,0,getdate()), 0))
SET @s_LUNES = 'LUNES ' + CONVERT(VARCHAR(10),@dt_LUNES,103)

SET @dt_MARTES = (SELECT DATEADD(wk, DATEDIFF(wk,1,getdate()), 1))
SET @s_MARTES = 'MARTES ' + CONVERT(VARCHAR(10),@dt_MARTES,103)

SET @dt_MIERCOLES = (SELECT DATEADD(wk, DATEDIFF(wk,2,getdate()), 2))
SET @s_MIERCOLES = 'MIERCOLES ' + CONVERT(VARCHAR(10),@dt_MIERCOLES,103)

SET @dt_JUEVES = (SELECT DATEADD(wk, DATEDIFF(wk,3,getdate()), 3))
SET @s_JUEVES = 'JUEVES ' + CONVERT(VARCHAR(10),@dt_JUEVES,103)

SET @dt_VIERNES = (SELECT DATEADD(wk, DATEDIFF(wk,4,getdate()), 4))
SET @s_VIERNES = 'VIERNES ' + CONVERT(VARCHAR(10),@dt_VIERNES,103)

SET @dt_SABADO = (SELECT DATEADD(wk, DATEDIFF(wk,5,getdate()), 5))
SET @s_SABADO = 'SABADO ' + CONVERT(VARCHAR(10),@dt_SABADO,103)

SET @dt_DOMINGO = (SELECT DATEADD(wk, DATEDIFF(wk,5,getdate()), 5))
SET @s_DOMINGO = 'DOMINGO ' + CONVERT(VARCHAR(10),@dt_DOMINGO + 1,103)


SELECT @s_LUNES 'lunes',@s_MARTES 'martes', @s_MIERCOLES 'miercoles',@s_JUEVES 'jueves', @s_VIERNES 'viernes',@s_SABADO 'sabado',@s_DOMINGO 'domingo'

--PRINT @s_LUNES + ' , ' + @s_MARTES + ' , ' + @s_MIERCOLES + ' , ' + @s_JUEVES + ' , ' + @s_VIERNES + ' , ' + @s_SABADO + ' , ' + @s_DOMINGO
GO
/****** Object:  StoredProcedure [dbo].[SP_DOCUMENTO_CC_IMPRESIONTICKET]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*

EXEC SP_DOCUMENTO_CC_IMPRESIONTICKET '01', '01', '07', '0001', '00000004'

SELECT * FROM CONDICION_PAGO

*/
-------------------------------------------
-------------------------------------------
create	PROCEDURE	[dbo].[SP_DOCUMENTO_CC_IMPRESIONTICKET]
@CIA			CHAR(2),
@SEDE			CHAR(2),
@ID_TIPO_DOC	CHAR(2),
@SERIE_DOC		CHAR(4),
@NRO_DOC		VARCHAR(20)
AS
-------------------------------------------
-------------------------------------------
/*	EL DOCUMENTO DEBE TENER UN TOTAL DE 40 CARACTERES COMO MAXMO POR LINEA*/
SELECT	REPLICATE(' ',CONVERT(INT,((40 - (LEN(COM.DESCRIPCION)))/2))) + COM.DESCRIPCION AS 'DESCRIPCION',
		REPLICATE(' ',CONVERT(INT,((40 - (LEN(LEFT(COM.DIRECCION,34))))/2))) + LEFT(COM.DIRECCION,34)AS 'DIRECCION',
		REPLICATE(' ',CONVERT(INT,((40 - (LEN(SUBSTRING(COM.DIRECCION,36,(LEN(COM.DIRECCION) - 35)))))/2))) + SUBSTRING(COM.DIRECCION,35,(LEN(COM.DIRECCION) - 34)) AS 'DIRECCION2', 
		REPLICATE(' ',CONVERT(INT,((40 - (LEN('Telefono: ' + COM.FONO1)))/2))) + 'Telefono: ' + COM.FONO1 AS 'FONO1',
		REPLICATE(' ',CONVERT(INT,((40 - (LEN('RUC: ' + COM.NIT)))/2))) + 'RUC: ' + COM.NIT AS 'NIT',
		REPLICATE(' ',CONVERT(INT,((40 - (LEN(TD.ABREVIATURA + '/' + DCC.SERIE_DOC + '-' + DCC.NRO_DOC)))/2))) + TD.ABREVIATURA + '/' + DCC.SERIE_DOC + '-' + DCC.NRO_DOC AS 'T_SERIE', 
		'Fecha:  ' + CONVERT(VARCHAR(10),DCC.FECHA_DOCUMENTO, 103) + '      Hora:  ' + CONVERT(VARCHAR(10), DCC.FECHA_DOCUMENTO, 108) AS 'FECHA', 
		'Numero: ' + DCC.NRO_DOC + '        Serie: ' + DCC.SERIE_DOC AS 'DOCUMENTO', 
		LEFT(ART.DESCRIPCION,16) + '  ' + REPLICATE(' ',(3 - LEN(DCCD.CANTIDAD))) + CONVERT(VARCHAR(3),CONVERT(INT,DCCD.CANTIDAD)) + '  ' + REPLICATE(' ',(6 - LEN(DCCD.PRECIO))) + CONVERT(VARCHAR(6),CONVERT(NUMERIC(15,2),DCCD.PRECIO)) + '  ' + REPLICATE(' ',(7 - LEN(DCCD.TOTAL))) + CONVERT(VARCHAR(7),CONVERT(NUMERIC(15,2),DCCD.TOTAL)) AS 'ARTICULO',
		'Total a Pagar:            ' + REPLICATE(' ',4 - LEN(MONEDA.ABREVIATURA)) + MONEDA.ABREVIATURA + REPLICATE(' ',(9 - LEN(DCC.TOTAL))) + CONVERT(VARCHAR(9),CONVERT(NUMERIC(15,2),DCC.TOTAL)) AS 'NETO', 
		'Tipo Pago:          ' + CP.DESCRIPCION AS 'PAGO', 
		'Paga con: ' + CONVERT(VARCHAR(7),CONVERT(NUMERIC(15,2),DCC.MONTO_PAGA_CON)) + '      Vuelto: ' + CONVERT(VARCHAR(7),CONVERT(NUMERIC(15,2),DCC.MONTO_VUELTO)) AS 'MONTO_VUELTO', 
		DCCD.ITEM
FROM	DOCUMENTO_CC AS DCC 
INNER JOIN TIPO_DOCUMENTO AS TD ON DCC.CIA = TD.CIA AND DCC.ID_TIPO_DOC = TD.ID_TIPO_DOC 
INNER JOIN COMPANIA AS COM ON DCC.CIA = COM.CIA 
INNER JOIN DOCUMENTO_CC_DETALLE AS DCCD ON DCC.CIA = DCCD.CIA AND DCC.SEDE = DCCD.SEDE AND DCC.ID_TIPO_DOC = DCCD.ID_TIPO_DOC AND DCC.SERIE_DOC = DCCD.SERIE_DOC AND DCC.NRO_DOC = DCCD.NRO_DOC 
INNER JOIN ARTICULO AS ART ON DCCD.CIA = ART.CIA AND DCCD.CIA = ART.CIA AND DCCD.ID_ARTICULO = ART.ID_ARTICULO 
INNER JOIN MONEDA ON DCC.CIA = MONEDA.CIA AND DCC.ID_MONEDA = MONEDA.ID_MONEDA
INNER JOIN CONDICION_PAGO AS CP ON DCC.CIA = CP.CIA AND DCC.ID_CONDICION_PAGO = CP.ID_CONDICION_PAGO
WHERE	DCC.CIA			= @CIA
AND		DCC.SEDE		= @SEDE
AND		DCC.ID_TIPO_DOC	= @ID_TIPO_DOC
AND		DCC.SERIE_DOC	= @SERIE_DOC
AND		DCC.NRO_DOC		= @NRO_DOC
ORDER	BY DCCD.ITEM
GO
/****** Object:  StoredProcedure [dbo].[SP_DOCUMENTO_CC_PVD_ELIMINAR]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*

SELECT * FROM DOCUMENTO_CC

DECLARE @MENSAJE_ERROR VARCHAR(100)
EXEC	[SP_DOCUMENTO_CC_PVD_ELIMINAR] '01', '01', '07', '0001', '00000025', 'ADMIN', '01', 'PUNTO DE VENTA', @MENSAJE_ERROR OUTPUT
PRINT @MENSAJE_ERROR

*/
-------------------------------------------
-------------------------------------------
create	PROCEDURE	[dbo].[SP_DOCUMENTO_CC_PVD_ELIMINAR]
@CIA				CHAR(2),
@SEDE				CHAR(2),
@ID_TIPO_DOC		CHAR(2),
@SERIE_DOC			CHAR(4),
@NRO_DOC			VARCHAR(20),
@ID_USUARIO			VARCHAR(10),
@ID_ALMACEN			CHAR(2),
@AA					VARCHAR(60),
@MENSAJE_ERROR		VARCHAR(100)OUTPUT
AS
-------------------------------------------
DECLARE	@COUNT		INT
DECLARE	@NRODOC		VARCHAR(20)
-------------------------------------------
BEGIN TRANSACTION
	---------------------------------------
	/*	CREAR EL NUEVO DOCUMENTO NEGATIVO	*/
	SET	@NRODOC	=	(	SELECT ISNULL((SELECT	(REPLICATE('0',(8 - LEN(CORRELATIVO + 1))) + CONVERT(VARCHAR(8),(CORRELATIVO + 1)))
						FROM	TIPO_DOCUMENTO_SERIE
						WHERE	CIA			= @CIA
						AND		ID_TIPO_DOC	= @ID_TIPO_DOC
						AND		SERIE		= @SERIE_DOC
						AND		ID_ESTADO	= '01'),'00000001')
					)
	---------------------------------------
	
	---------------------------------------
	/*	INSERTAMOS NUEVA CABECERA	*/
	INSERT	INTO DOCUMENTO_CC
	(
		CIA, SEDE, ID_TIPO_DOC, SERIE_DOC, NRO_DOC, ID_CLIENTE, ID_PUNTO_VENTA, ID_MONEDA, FECHA_DOCUMENTO, TIPO_CAMBIO, SUBTOTAL,
		IMPUESTO, TOTAL, ID_CAJA_BANCO, ID_ALMACEN, ID_LISTA_PRECIO, ID_CONDICION_PAGO, OBSERVACION, ID_ESTADO, FLAG_ENVIO, SE, FE, UE,  FC, UC, 
		DIRECCION_CLIENTE, MONTO_PAGA_CON, MONTO_VUELTO, ID_TIPO_DOC_REF, SERIE_DOC_REF, NRO_DOC_REF
	)
	SELECT 	CIA, SEDE, ID_TIPO_DOC, SERIE_DOC, @NRODOC, ID_CLIENTE, ID_PUNTO_VENTA, ID_MONEDA, GETDATE(), TIPO_CAMBIO, (-1 * SUBTOTAL),
			(-1 * IMPUESTO), (-1 * TOTAL), ID_CAJA_BANCO, ID_ALMACEN, ID_LISTA_PRECIO, ID_CONDICION_PAGO, OBSERVACION, ID_ESTADO, FLAG_ENVIO, @SEDE, GETDATE(), @ID_USUARIO,  GETDATE(), @ID_USUARIO, 
			DIRECCION_CLIENTE, MONTO_PAGA_CON, MONTO_VUELTO, @ID_TIPO_DOC, @SERIE_DOC, @NRO_DOC
	FROM	DOCUMENTO_CC
	WHERE	CIA			= @CIA
	AND		SEDE		= @SEDE
	AND		ID_TIPO_DOC	= @ID_TIPO_DOC
	AND		SERIE_DOC	= @SERIE_DOC
	AND		NRO_DOC		= @NRO_DOC
	/*	COMPROBAMOS SI HAY ERRORES	*/
	IF @@ERROR <> 0 OR @@ROWCOUNT <> 1
	BEGIN
		-------------------------------------------
		SET		@MENSAJE_ERROR	= 'SE PRODUJO UN ERROR DURANTE EL PROCESO DE INSERCION DE LA VENTA NEGATIVA. NO SE GRABARON LOS DATOS.'
		GOTO	MSGERROR
		--------------------------------------------
	END
	---------------------------------------
	/*	OBTENEMOS LA CANTIDAD DE ITEM QUE INSERTAREMOS EN EL DETALLE	*/
	SET	@COUNT	= (	SELECT	ISNULL((SELECT	COUNT(*)
					FROM	DOCUMENTO_CC_DETALLE
					WHERE	CIA			= @CIA
					AND		SEDE		= @SEDE
					AND		ID_TIPO_DOC	= @ID_TIPO_DOC
					AND		SERIE_DOC	= @SERIE_DOC
					AND		NRO_DOC		= @NRO_DOC),0)
				  )
	/*	INSERTAMOS NUEVO DETALLE	*/
	INSERT	INTO DOCUMENTO_CC_DETALLE
	(
		CIA, SEDE, ID_TIPO_DOC, SERIE_DOC, NRO_DOC, ITEM, ITEM_DIGITADO, ID_ARTICULO, CANTIDAD, CANTIDAD_USADA, PRECIO, SUB_TOTAL, 
		IMPUESTO, TOTAL, ID_ESTADO, FLAG_ENVIO, SE, FE, UE, FC, UC
	)
	SELECT	CIA, SEDE, ID_TIPO_DOC, SERIE_DOC, @NRODOC, ITEM, ITEM_DIGITADO, ID_ARTICULO, (-1 * CANTIDAD), CANTIDAD_USADA, PRECIO, (-1 * SUB_TOTAL), 
			(-1 * IMPUESTO), (-1 * TOTAL), ID_ESTADO, FLAG_ENVIO, @SEDE, GETDATE(), @ID_USUARIO, GETDATE(), @ID_USUARIO
	FROM	DOCUMENTO_CC_DETALLE
	WHERE	CIA			= @CIA
	AND		SEDE		= @SEDE
	AND		ID_TIPO_DOC	= @ID_TIPO_DOC
	AND		SERIE_DOC	= @SERIE_DOC
	AND		NRO_DOC		= @NRO_DOC
	/*	COMPROBAMOS SI HAY ERRORES	*/
	IF @@ERROR <> 0 OR @@ROWCOUNT < @COUNT
	BEGIN
		-----------------------------------
		SET		@MENSAJE_ERROR	= 'SE PRODUJO UN ERROR DURANTE EL PROCESO DE INSERCION DE LA VENTA DETALLE NEGATIVO. NO SE GRABARON LOS DATOS.'
		GOTO	MSGERROR
		-----------------------------------
	END
	---------------------------------------
	/*	INSERTAMOS CABECERA EN INVENTARIO_MOV	*/
	INSERT	INTO INVENTARIO_MOV
	(
		CIA, SEDE, ID_TIPO_DOC, SERIE_DOC, NRO_DOC, ID_MOTIVO_ALMACEN, FECHA, ID_MONEDA, ID_ALMACEN, ID_ANALITICA, FLAG_INGRESO, ID_MODULO, 
		ANIO, MES, ID_ESTADO, FLAG_ENVIO, SE, FE, UE, FC, UC, TIPO_CAMBIO
	)
	SELECT	CIA, SEDE, ID_TIPO_DOC, SERIE_DOC, @NRODOC, '06', GETDATE(), ID_MONEDA, ID_ALMACEN, ID_ANALITICA, FLAG_INGRESO, ID_MODULO,
			ANIO, MES, '11', FLAG_ENVIO, @SEDE, GETDATE(), @ID_USUARIO, GETDATE(), @ID_USUARIO, TIPO_CAMBIO
	FROM	INVENTARIO_MOV
	WHERE	CIA			= @CIA
	AND		SEDE		= @SEDE
	AND		ID_TIPO_DOC	= @ID_TIPO_DOC
	AND		SERIE_DOC	= @SERIE_DOC
	AND		NRO_DOC		= @NRO_DOC
	/*	COMPROBAMOS SI HAY ERRORES	*/
	IF @@ERROR <> 0 OR @@ROWCOUNT <> 1
	BEGIN
		---------------------------------------
		SET		@MENSAJE_ERROR	= 'SE PRODUJO UN ERROR DURANTE EL PROCESO DE GRABACION DEL INVENTARIO_MOV. NO SE GRABARON LOS DATOS.'
		GOTO	MSGERROR
		----------------------------------------
	END
	--------------------------------------------
	/*	OBTENEMOS LA CANTIDAD DE ITEM QUE INSERTAREMOS EN EL DETALLE	*/
	SET	@COUNT	= (	SELECT	ISNULL((SELECT	COUNT(*)
					FROM	DOCUMENTO_CC_DETALLE
					WHERE	CIA			= @CIA
					AND		SEDE		= @SEDE
					AND		ID_TIPO_DOC	= @ID_TIPO_DOC
					AND		SERIE_DOC	= @SERIE_DOC
					AND		NRO_DOC		= @NRO_DOC),0)
				  )
	---------------------------------------------
	INSERT INTO INVENTARIO_MOV_DET
	(
		CIA, SEDE, ID_TIPO_DOC, SERIE_DOC, NRO_DOC, ITEM, ITEM_DIGITADO, ID_ARTICULO, CANTIDAD, CANTIDAD_USADA, ID_ESTADO, FLAG_ENVIO,
		SE, FE, UE, FC, UC
	)
	SELECT	CIA, SEDE, ID_TIPO_DOC, SERIE_DOC, @NRODOC, ITEM, ITEM_DIGITADO, ID_ARTICULO, CANTIDAD, CANTIDAD_USADA, ID_ESTADO, FLAG_ENVIO,
			@SEDE, GETDATE(), @ID_USUARIO, GETDATE(), @ID_USUARIO
	FROM	INVENTARIO_MOV_DET
	WHERE	CIA			= @CIA
	AND		SEDE		= @SEDE
	AND		ID_TIPO_DOC	= @ID_TIPO_DOC
	AND		SERIE_DOC	= @SERIE_DOC
	AND		NRO_DOC		= @NRO_DOC
	---------------------------------------------
	/*	ACTUALIZAMOS STOCK	*/
	UPDATE	EX_S
	SET		EX_S.CANT_DISPONIBLE = (EX_S.CANT_DISPONIBLE + DCCD.CANTIDAD)
	FROM	EXISTENCIA_SEDE EX_S 
	INNER JOIN DOCUMENTO_CC_DETALLE DCCD ON EX_S.CIA = DCCD.CIA AND EX_S.SEDE = DCCD.SEDE AND EX_S.ID_ARTICULO = DCCD.ID_ARTICULO
	WHERE	EX_S.CIA		= @CIA
	AND		EX_S.SEDE		= @SEDE
	AND		DCCD.ID_TIPO_DOC= @ID_TIPO_DOC
	AND		DCCD.SERIE_DOC	= @SERIE_DOC
	AND		DCCD.NRO_DOC	= @NRO_DOC
	------------------------------------------------
	IF (@@ERROR <> 0)
	BEGIN
		--------------------------------------------
		SET		@MENSAJE_ERROR	= 'SE PRODUJO UN ERROR DURANTE EL PROCESO DE ACTUALIZACION EXISTENCIA SEDE. NO SE GRABARON LOS DATOS.'
		GOTO	MSGERROR
		--------------------------------------------
	END
	------------------------------------------------
	UPDATE	EX_A
	SET		EX_A.CANT_DISPONIBLE = (EX_A.CANT_DISPONIBLE + DCCD.CANTIDAD)
	FROM	EXISTENCIA_ALMACEN EX_A 
	INNER JOIN DOCUMENTO_CC_DETALLE DCCD ON EX_A.CIA = DCCD.CIA AND EX_A.SEDE = DCCD.SEDE AND EX_A.ID_ARTICULO = DCCD.ID_ARTICULO
	WHERE	EX_A.CIA		= @CIA
	AND		EX_A.SEDE		= @SEDE
	AND		EX_A.ID_ALMACEN	= @ID_ALMACEN
	AND		DCCD.ID_TIPO_DOC= @ID_TIPO_DOC
	AND		DCCD.SERIE_DOC	= @SERIE_DOC
	AND		DCCD.NRO_DOC	= @NRO_DOC
	------------------------------------------------
	IF (@@ERROR <> 0)
	BEGIN
		--------------------------------------------
		SET		@MENSAJE_ERROR	= 'SE PRODUJO UN ERROR DURANTE EL PROCESO DE ACTUALIZACION EXISTENCIA ALMACEN. NO SE GRABARON LOS DATOS.'
		GOTO	MSGERROR
		--------------------------------------------
	END
	------------------------------------------------
	UPDATE	TIPO_DOCUMENTO_SERIE
	SET		CORRELATIVO = CONVERT(INT,@NRODOC)
	WHERE	CIA			= @CIA
	AND		ID_TIPO_DOC	= @ID_TIPO_DOC
	AND		SERIE		= @SERIE_DOC
	------------------------------------------------
	IF (@@ERROR <> 0 OR @@ROWCOUNT <> 1)
	BEGIN
		--------------------------------------------
		SET		@MENSAJE_ERROR	= 'SE PRODUJO UN ERROR DURANTE EL PROCESO DE ACTUALIZACION TIPO DOCUMENTO SERIE. NO SE GRABARON LOS DATOS.'
		GOTO	MSGERROR
		--------------------------------------------
	END
	------------------------------------------------
	SET		@MENSAJE_ERROR	= @CIA + ',' + @SEDE + ',' + @ID_TIPO_DOC + ',' + @SERIE_DOC + ',' + @NRODOC
	---------------------------------------
COMMIT TRANSACTION
-------------------------------------------
RETURN
MSGERROR:
		ROLLBACK TRANSACTION
		------------------------------------
		RAISERROR	(@MENSAJE_ERROR, 15, 1)
		RETURN
GO
/****** Object:  StoredProcedure [dbo].[SP_DOCUMENTO_CC_PVD_INSERTAR]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*

SELECT * FROM TIPO_DOCUMENTO_SERIE

SELECT * FROM DOCUMENTO_CC WHERE ID_TIPO_DOC = '07'

*/
----------------------------------------------------
----------------------------------------------------
create	PROCEDURE	[dbo].[SP_DOCUMENTO_CC_PVD_INSERTAR]
@SESION				VARCHAR(100),
@ID_USUARIO			VARCHAR(10),
@CIA				CHAR(2),
@SEDE				CHAR(2),
@ID_TIPO_DOC		CHAR(2),
@SERIE_DOC			CHAR(4),
@NRO_DOC			VARCHAR(20),
@ID_CLIENTE			VARCHAR(20),
@ID_PUNTO_VENTA		VARCHAR(20),
@ID_MONEDA			CHAR(2),
@TIPO_CAMBIO		FLOAT,
@SUBTOTAL			FLOAT,
@IMPUESTO			FLOAT,
@TOTAL				FLOAT,
@ID_CAJA_BANCO		VARCHAR(5),
@ID_ALMACEN			CHAR(2),
@ID_LISTA_PRECIO	CHAR(3),
@FLAG_PAGO			CHAR(2),
@OBSERVACION		VARCHAR(100),	
@ID_ESTADO			CHAR(2),
@DIRECCION_CLIENTE	VARCHAR(300),
@MONTO_PAGA_CON		FLOAT,
@MONTO_VUELTO		FLOAT,
@MENSAJE_ERROR		VARCHAR(100)OUTPUT
AS
----------------------------------------------------
DECLARE	@COUNT		INT
----------------------------------------------------
/*	GENERAMOS EL CORRELATIVO DEL DOCUMENTO	 */
SET	@NRO_DOC	=	(	SELECT ISNULL((SELECT	(REPLICATE('0',(8 - LEN(CORRELATIVO + 1))) + CONVERT(VARCHAR(8),(CORRELATIVO + 1)))
						FROM	TIPO_DOCUMENTO_SERIE
						WHERE	CIA			= @CIA
						AND		ID_TIPO_DOC	= @ID_TIPO_DOC
						AND		SERIE		= @SERIE_DOC
						AND		ID_ESTADO	= '01'),'00000001')
					)
BEGIN TRANSACTION
	------------------------------------------------
	/*	INSERTAMOS CABECERA EN DOCUMENTO_CC	*/
	INSERT	INTO DOCUMENTO_CC
	(
		CIA, SEDE, ID_TIPO_DOC, SERIE_DOC, NRO_DOC, ID_CLIENTE, ID_PUNTO_VENTA, ID_MONEDA, FECHA_DOCUMENTO, TIPO_CAMBIO, SUBTOTAL,
		IMPUESTO, TOTAL, ID_CAJA_BANCO, ID_ALMACEN, ID_LISTA_PRECIO, ID_CONDICION_PAGO, OBSERVACION, ID_ESTADO, FLAG_ENVIO, SE, FE, UE,  FC, UC, 
		DIRECCION_CLIENTE, MONTO_PAGA_CON, MONTO_VUELTO
	)
	VALUES
	(
		@CIA, @SEDE, @ID_TIPO_DOC, @SERIE_DOC, @NRO_DOC, @ID_CLIENTE, @ID_PUNTO_VENTA, @ID_MONEDA, GETDATE(), @TIPO_CAMBIO, @SUBTOTAL,
		@IMPUESTO, @TOTAL, @ID_CAJA_BANCO, @ID_ALMACEN, @ID_LISTA_PRECIO, @FLAG_PAGO, @OBSERVACION, @ID_ESTADO, '1', @SEDE, GETDATE(), @ID_USUARIO,
		GETDATE(), @ID_USUARIO, @DIRECCION_CLIENTE, @MONTO_PAGA_CON, @MONTO_VUELTO
	)
	/*	COMPROBAMOS SI HAY ERRORES	*/
	IF @@ERROR <> 0 OR @@ROWCOUNT <> 1
	BEGIN
		-------------------------------------------
		SET		@MENSAJE_ERROR	= 'SE PRODUJO UN ERROR DURANTE EL PROCESO DE GRABACION DE LA VENTA. NO SE GRABARON LOS DATOS.'
		GOTO	MSGERROR
		--------------------------------------------
	END
	------------------------------------------------
	/*	OBTENEMOS LA CANTIDAD DE ITEM QUE INSERTAREMOS EN EL DETALLE	*/
	SET	@COUNT	= (	SELECT	ISNULL((SELECT	COUNT(*)
					FROM	PUNTO_VENTA_TEMP
					WHERE	SESION	= @SESION
					AND		CIA		= @CIA
					AND		SEDE	= @SEDE),0)
				  )
	------------------------------------------------
	INSERT	INTO DOCUMENTO_CC_DETALLE
	(
		CIA, SEDE, ID_TIPO_DOC, SERIE_DOC, NRO_DOC, ITEM, ITEM_DIGITADO, ID_ARTICULO, CANTIDAD, CANTIDAD_USADA, PRECIO, SUB_TOTAL, 
		IMPUESTO, TOTAL, ID_ESTADO, FLAG_ENVIO, SE, FE, UE, FC, UC
	)
	SELECT	CIA, SEDE, @ID_TIPO_DOC, @SERIE_DOC, @NRO_DOC, ITEM, ITEM, ID_ARTICULO,	CANTIDAD, 0, PRECIO, TOTAL, 
			(TOTAL * 0.19), TOTAL, @ID_ESTADO, '1', @SEDE, GETDATE(), @ID_USUARIO, GETDATE(), @ID_USUARIO
	FROM	PUNTO_VENTA_TEMP
	WHERE	SESION	= @SESION
	AND		CIA		= @CIA
	AND		SEDE	= @SEDE
	/*	COMPROBAMOS SI HAY ERRORES	*/
	IF @@ERROR <> 0 OR @@ROWCOUNT < @COUNT
	BEGIN
		-------------------------------------------
		SET		@MENSAJE_ERROR	= 'SE PRODUJO UN ERROR DURANTE EL PROCESO DE GRABACION DE LA VENTA DETALLE . NO SE GRABARON LOS DATOS.'
		GOTO	MSGERROR
		--------------------------------------------
	END
	------------------------------------------------
	/*	INSERTAMOS CABECERA EN INVENTARIO_MOV	*/
	INSERT	INTO INVENTARIO_MOV
	(
		CIA, SEDE, ID_TIPO_DOC, SERIE_DOC, NRO_DOC, ID_MOTIVO_ALMACEN, FECHA, ID_MONEDA, ID_ALMACEN, ID_ANALITICA, FLAG_INGRESO, ID_MODULO, 
		ANIO, MES, ID_ESTADO, FLAG_ENVIO, SE, FE, UE, FC, UC, TIPO_CAMBIO
	)
	VALUES
	(
		@CIA, @SEDE, @ID_TIPO_DOC, @SERIE_DOC, @NRO_DOC, '01', GETDATE(), @ID_MONEDA, @ID_ALMACEN, @ID_CLIENTE, '0', 'CE',
		YEAR(GETDATE()), MONTH(GETDATE()), @ID_ESTADO, '1', @SEDE, GETDATE(), @ID_USUARIO, GETDATE(), @ID_USUARIO, @TIPO_CAMBIO
	)
	/*	COMPROBAMOS SI HAY ERRORES	*/
	IF @@ERROR <> 0 OR @@ROWCOUNT <> 1
	BEGIN
		---------------------------------------
		SET		@MENSAJE_ERROR	= 'SE PRODUJO UN ERROR DURANTE EL PROCESO DE GRABACION DEL INVENTARIO_MOV. NO SE GRABARON LOS DATOS.'
		GOTO	MSGERROR
		----------------------------------------
	END
	------------------------------------------------
	/*	OBTENEMOS LA CANTIDAD DE ITEM QUE INSERTAREMOS EN EL DETALLE	*/
	SET	@COUNT	= (	SELECT	ISNULL((SELECT	COUNT(*)
					FROM	PUNTO_VENTA_TEMP
					WHERE	SESION	= @SESION
					AND		CIA		= @CIA
					AND		SEDE	= @SEDE),0)
				  )
	------------------------------------------------
	INSERT INTO INVENTARIO_MOV_DET
	(
		CIA, SEDE, ID_TIPO_DOC, SERIE_DOC, NRO_DOC, ITEM, ITEM_DIGITADO, ID_ARTICULO, CANTIDAD, CANTIDAD_USADA, ID_ESTADO, FLAG_ENVIO,
		SE, FE, UE, FC, UC
	)
	SELECT	CIA, SEDE, @ID_TIPO_DOC, @SERIE_DOC, @NRO_DOC, ITEM, ITEM, ID_ARTICULO, CANTIDAD, 0, @ID_ESTADO, '1', 
			SEDE, GETDATE(), @ID_USUARIO, GETDATE(), @ID_USUARIO
	FROM	PUNTO_VENTA_TEMP
	WHERE	SESION = @SESION
	AND		CIA		= @CIA
	AND		SEDE	= @SEDE
	------------------------------------------------
	/*	COMPROBAMOS SI HAY ERRORES	*/
	IF @@ERROR <> 0 OR @@ROWCOUNT < @COUNT
	BEGIN
		--------------------------------------------
		SET		@MENSAJE_ERROR	= 'SE PRODUJO UN ERROR DURANTE EL PROCESO DE GRABACION DEL INVENTARIO MOV DET. NO SE GRABARON LOS DATOS.'
		GOTO	MSGERROR
		--------------------------------------------
	END
	------------------------------------------------
	/*	ACTUALIZAMOS STOCK	*/
	UPDATE	EX_S
	SET		EX_S.CANT_DISPONIBLE = (EX_S.CANT_DISPONIBLE - PDV.CANTIDAD)
	FROM	EXISTENCIA_SEDE EX_S 
	INNER JOIN PUNTO_VENTA_TEMP PDV ON EX_S.CIA	= PDV.CIA AND EX_S.SEDE = PDV.SEDE AND EX_S.ID_ARTICULO = PDV.ID_ARTICULO
	WHERE	EX_S.CIA	= @CIA
	AND		EX_S.SEDE	= @SEDE
	AND		PDV.SESION	= @SESION
	------------------------------------------------
	IF (@@ERROR <> 0)
	BEGIN
		--------------------------------------------
		SET		@MENSAJE_ERROR	= 'SE PRODUJO UN ERROR DURANTE EL PROCESO DE ACTUALIZACION EXISTENCIA SEDE. NO SE GRABARON LOS DATOS.'
		GOTO	MSGERROR
		--------------------------------------------
	END
	------------------------------------------------
	UPDATE	EX_A
	SET		EX_A.CANT_DISPONIBLE = (EX_A.CANT_DISPONIBLE - PDV.CANTIDAD)
	FROM	EXISTENCIA_ALMACEN EX_A 
	INNER JOIN PUNTO_VENTA_TEMP PDV ON EX_A.CIA	= PDV.CIA AND EX_A.SEDE = PDV.SEDE AND EX_A.ID_ARTICULO = PDV.ID_ARTICULO
	WHERE	EX_A.CIA		= @CIA
	AND		EX_A.SEDE		= @SEDE
	AND		EX_A.ID_ALMACEN	= @ID_ALMACEN
	AND		PDV.SESION		= @SESION
	------------------------------------------------
	IF (@@ERROR <> 0)
	BEGIN
		--------------------------------------------
		SET		@MENSAJE_ERROR	= 'SE PRODUJO UN ERROR DURANTE EL PROCESO DE ACTUALIZACION EXISTENCIA ALMACEN. NO SE GRABARON LOS DATOS.'
		GOTO	MSGERROR
		--------------------------------------------
	END
	------------------------------------------------
	UPDATE	TIPO_DOCUMENTO_SERIE
	SET		CORRELATIVO = CONVERT(INT,@NRO_DOC)
	WHERE	CIA			= @CIA
	AND		ID_TIPO_DOC	= @ID_TIPO_DOC
	AND		SERIE		= @SERIE_DOC
	------------------------------------------------
	IF (@@ERROR <> 0 OR @@ROWCOUNT <> 1)
	BEGIN
		--------------------------------------------
		SET		@MENSAJE_ERROR	= 'SE PRODUJO UN ERROR DURANTE EL PROCESO DE ACTUALIZACION TIPO DOCUMENTO SERIE. NO SE GRABARON LOS DATOS.'
		GOTO	MSGERROR
		--------------------------------------------
	END
	------------------------------------------------
	DELETE	FROM PUNTO_VENTA_TEMP
	WHERE	SESION	= @SESION
	AND		CIA		= @CIA
	------------------------------------------------
	SET	@MENSAJE_ERROR = @CIA + ',' + @SEDE + ',' + @ID_TIPO_DOC + ',' + @SERIE_DOC + ',' + @NRO_DOC
	------------------------------------------------
COMMIT TRANSACTION
----------------------------------------------------
RETURN
MSGERROR:
		ROLLBACK TRANSACTION
		--------------------------------------------
		RAISERROR	(@MENSAJE_ERROR, 15, 1)
		RETURN
GO
/****** Object:  StoredProcedure [dbo].[SP_DOCUMENTO_CC_PVD_TRAER_DETALLE]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*



*/
-----------------------------------------------------
-----------------------------------------------------
create	PROCEDURE	[dbo].[SP_DOCUMENTO_CC_PVD_TRAER_DETALLE]
@CIA			CHAR(2),
@SEDE			CHAR(2),
@ID_TIPO_DOC	CHAR(2),
@SERIE_DOC		CHAR(4),
@NRO_DOC		VARCHAR(20)
AS
-----------------------------------------------------
-----------------------------------------------------
SELECT	DCCD.ITEM, DCCD.ID_ARTICULO, ART.NRO_PARTE AS 'NRO-PARTE', ART.DESCRIPCION, UM.ABREVIATURA AS 'UNIDAD', 0 AS 'STOCK', DCCD.CANTIDAD, LPD.PRECIO_VENTA AS 'PRECIO', DCCD.TOTAL
FROM	DOCUMENTO_CC AS DCC 
INNER JOIN DOCUMENTO_CC_DETALLE AS DCCD ON DCC.CIA = DCCD.CIA AND DCC.SEDE = DCCD.SEDE AND DCC.ID_TIPO_DOC = DCCD.ID_TIPO_DOC AND DCC.SERIE_DOC = DCCD.SERIE_DOC AND DCC.NRO_DOC = DCCD.NRO_DOC 
INNER JOIN ARTICULO AS ART ON DCCD.CIA = ART.CIA AND DCCD.CIA = ART.CIA AND DCCD.ID_ARTICULO = ART.ID_ARTICULO 
INNER JOIN UNIDAD_MEDIDA AS UM ON ART.CIA = UM.CIA AND ART.ID_UNIDAD = UM.ID_UNIDAD 
INNER JOIN LISTA_PRECIO AS LP ON DCC.CIA = LP.CIA AND DCC.ID_LISTA_PRECIO = LP.ID_LISTA_PRECIO 
INNER JOIN LISTA_PRECIO_DET AS LPD ON ART.CIA = LPD.CIA AND ART.ID_ARTICULO = LPD.ID_ARTICULO AND LP.CIA = LPD.CIA AND LP.ID_LISTA_PRECIO = LPD.ID_LISTA_PRECIO
WHERE	DCC.CIA			= @CIA 
AND		DCC.SEDE		= @SEDE 
AND		DCC.ID_TIPO_DOC = @ID_TIPO_DOC 
AND		DCC.SERIE_DOC	= @SERIE_DOC 
AND		DCC.NRO_DOC		= @NRO_DOC
GO
/****** Object:  StoredProcedure [dbo].[SP_DOCUMENTO_CC_PVD_TRAER_DOCUMENTO]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*



*/
-----------------------------------------------------
-----------------------------------------------------
create	PROCEDURE	[dbo].[SP_DOCUMENTO_CC_PVD_TRAER_DOCUMENTO]
@CIA			CHAR(2),
@SEDE			CHAR(2),
@ID_TIPO_DOC	CHAR(2),
@SERIE_DOC		CHAR(4),
@NRO_DOC		VARCHAR(20)
AS
-----------------------------------------------------
-----------------------------------------------------
SELECT	CIA, SEDE, ID_TIPO_DOC, SERIE_DOC, NRO_DOC, ID_CLIENTE, ID_PUNTO_VENTA, ID_MONEDA, CONVERT(VARCHAR(10),FECHA_DOCUMENTO,103) AS 'FECHA', TIPO_CAMBIO, SUBTOTAL, 
		IMPUESTO, TOTAL, ID_CAJA_BANCO, ID_ALMACEN, ID_LISTA_PRECIO, FLAG_PAGO, OBSERVACION, ID_ESTADO, UC, DESCRIPCION_CLIENTE, MONTO_PAGA_CON, MONTO_VUELTO
FROM	DOCUMENTO_CC
WHERE	CIA			= @CIA
AND		SEDE		= @SEDE
AND		ID_TIPO_DOC	= @ID_TIPO_DOC
AND		SERIE_DOC	= @SERIE_DOC
AND		NRO_DOC		= @NRO_DOC
GO
/****** Object:  StoredProcedure [dbo].[SP_DOCUMENTO_CC_PVD_TRAER_TODOS]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*



*/
---------------------------------------
---------------------------------------
create	PROCEDURE	[dbo].[SP_DOCUMENTO_CC_PVD_TRAER_TODOS]
@CIA			CHAR(2),
@SEDE			CHAR(2),
@ID_TIPO_DOC	CHAR(2),
@SERIE_DOC		CHAR(4),
@NRO_DOC		VARCHAR(20),
@DESCRIPCION	VARCHAR(100),
@ID_ESTADO		VARCHAR(2),
@FECHA1			VARCHAR(12),
@FECHA2			VARCHAR(12)
AS
---------------------------------------
DECLARE @FECHA_1 DATETIME
DECLARE @FECHA_2 DATETIME
---------------------------------------
SET	@FECHA_1 = CONVERT(DATETIME,@FECHA1)
SET	@FECHA_2 = CONVERT(DATETIME,@FECHA2)
---------------------------------------
SELECT	DCC.ID_TIPO_DOC, DCC.SERIE_DOC, DCC.NRO_DOC, DCC.SERIE_DOC + ' - ' + DCC.NRO_DOC AS 'SERIE',
		UPPER(TD.DESCRIPCION) AS 'TIPO-DOC', UPPER(SEDE.DESCRIPCION) AS 'SEDE', UPPER(ANA.DESCRIPCION) AS 'CLIENTE', CONVERT(VARCHAR(10),DCC.FECHA_DOCUMENTO, 103) AS 'FECHA', 
		CONVERT(NUMERIC(15,2),DCC.TOTAL) AS 'TOTAL'
FROM	DOCUMENTO_CC AS DCC 
INNER JOIN ANALITICA AS ANA ON DCC.CIA = ANA.CIA AND DCC.CIA = ANA.CIA AND DCC.ID_CLIENTE = ANA.ID_ANALITICA 
INNER JOIN TIPO_DOCUMENTO AS TD ON DCC.CIA = TD.CIA AND DCC.ID_TIPO_DOC = TD.ID_TIPO_DOC 
INNER JOIN SEDE ON DCC.CIA = SEDE.CIA AND DCC.SEDE = SEDE.SEDE
WHERE	DCC.CIA		= @CIA 
AND		DCC.SEDE		= @SEDE 
AND		DCC.ID_TIPO_DOC	= '07'
AND		DCC.SERIE_DOC	LIKE CASE WHEN LEN(@SERIE_DOC) > 0 THEN '%' + @SERIE_DOC + '%' ELSE '%' END
AND		DCC.NRO_DOC		LIKE CASE WHEN LEN(@NRO_DOC) > 0 THEN '%' + @NRO_DOC + '%' ELSE '%' END
AND		ANA.DESCRIPCION	LIKE CASE WHEN LEN(@DESCRIPCION) > 0 THEN '%' + ANA.DESCRIPCION + '%' ELSE '%' END
AND		DCC.ID_ESTADO	LIKE '%' + @ID_ESTADO + '%'
AND		CONVERT(VARCHAR(8),DCC.FECHA_DOCUMENTO,112) >= CONVERT(VARCHAR(8),@FECHA_1,112)
AND		CONVERT(VARCHAR(8),DCC.FECHA_DOCUMENTO,112) <= CONVERT(VARCHAR(8),@FECHA_2,112)
GO
/****** Object:  StoredProcedure [dbo].[SP_DOCUMENTO_CIERRE_PAGO]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*

EXEC	[SP_DOCUMENTO_CIERRE_PAGO] '01', '01', 'ADMIN', 'M1', '01', 25

*/
----------------------------------------------
----------------------------------------------
CREATE	PROCEDURE	[dbo].[SP_DOCUMENTO_CIERRE_PAGO]
@CIA			CHAR(2),
@SEDE			CHAR(2),
@USUARIO		VARCHAR(20),
@ID_SURTIDOR	VARCHAR(2),
@ID_TURNO		VARCHAR(2),
@ID_CONTROL		INT
AS
----------------------------------------------
DECLARE	@FECHA_INICIO	DATETIME
DECLARE	@FECHA_FIN		DATETIME
DECLARE	@TOTAL_NETO		NUMERIC(15,2)
----------------------------------------------------
SET	@FECHA_INICIO	= (SELECT APERTURA FROM E_TURNO_CONTROL WHERE CIA = @CIA AND SEDE = @SEDE AND ID_TURNO_CONTROL = @ID_CONTROL AND ID_SURTIDOR = @ID_SURTIDOR AND ID_TURNO = @ID_TURNO AND ID_USUARIO = @USUARIO)
SET	@FECHA_FIN		= (SELECT CIERRE FROM E_TURNO_CONTROL WHERE CIA = @CIA AND SEDE = @SEDE AND ID_TURNO_CONTROL = @ID_CONTROL AND ID_SURTIDOR = @ID_SURTIDOR AND ID_TURNO = @ID_TURNO AND ID_USUARIO = @USUARIO)
SET	@TOTAL_NETO		= (SELECT SUM(TOTAL) FROM DOCUMENTO_CC WHERE CIA = @CIA AND SEDE = @SEDE AND UC = @USUARIO AND FECHA_DOCUMENTO	>= @FECHA_INICIO AND FECHA_DOCUMENTO <= @FECHA_FIN)
----------------------------------------------
SELECT	LEFT(CP.DESCRIPCION + ':               ',25)  + REPLICATE(' ',4 - LEN(MONEDA.ABREVIATURA)) + MONEDA.ABREVIATURA + CONVERT(VARCHAR(7),CONVERT(NUMERIC(15,2),SUM(DCC.TOTAL))),
		'Total venta segun Condicon de Pago:      ' + REPLICATE(' ',4 - LEN(MONEDA.ABREVIATURA)) + MONEDA.ABREVIATURA + REPLICATE(' ',(9 - LEN(@TOTAL_NETO))) + CONVERT(VARCHAR(9), @TOTAL_NETO) AS 'NETO' 
FROM    DOCUMENTO_CC AS DCC 
LEFT JOIN CONDICION_PAGO AS CP ON DCC.CIA = CP.CIA AND DCC.ID_CONDICION_PAGO = CP.ID_CONDICION_PAGO
INNER JOIN MONEDA ON DCC.CIA = MONEDA.CIA AND DCC.ID_MONEDA = MONEDA.ID_MONEDA
WHERE	DCC.CIA			= @CIA
AND		DCC.SEDE		= @SEDE
AND		DCC.UC			= @USUARIO
AND		DCC.ID_TIPO_DOC	= '07'
AND		DCC.FECHA_DOCUMENTO	>= @FECHA_INICIO AND DCC.FECHA_DOCUMENTO <= @FECHA_FIN
GROUP	BY CP.DESCRIPCION, MONEDA.ABREVIATURA
GO
/****** Object:  StoredProcedure [dbo].[SP_DOCUMENTO_CIERRE_PAGO_TOTAL]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create	PROCEDURE	[dbo].[SP_DOCUMENTO_CIERRE_PAGO_TOTAL]
@CIA			CHAR(2),
@SEDE			CHAR(2),
@ID_SURTIDOR	VARCHAR(2),
@FECHA			DATETIME
AS
----------------------------------------------
DECLARE	@FECHA_INICIO	DATETIME
DECLARE	@FECHA_FIN		DATETIME
DECLARE	@TOTAL_NETO		NUMERIC(15,2)
----------------------------------------------------
SET	@FECHA_INICIO	= (SELECT TOP 1 APERTURA FROM E_TURNO_CONTROL WHERE CIA = @CIA AND SEDE = @SEDE AND ID_SURTIDOR = @ID_SURTIDOR AND CONVERT(VARCHAR(10),APERTURA,103)=@FECHA ORDER BY APERTURA asc)
SET	@FECHA_FIN		= (SELECT TOP 1 CIERRE FROM E_TURNO_CONTROL WHERE CIA = @CIA AND SEDE = @SEDE  AND ID_SURTIDOR = @ID_SURTIDOR AND CONVERT(VARCHAR(10),APERTURA,103)=@FECHA ORDER BY CIERRE desc)
SET	@TOTAL_NETO		= (SELECT SUM(TOTAL) FROM DOCUMENTO_CC WHERE CIA = @CIA AND SEDE = @SEDE AND FECHA_DOCUMENTO	>= @FECHA_INICIO AND FECHA_DOCUMENTO <= @FECHA_FIN)
----------------------------------------------
SELECT	LEFT(CP.DESCRIPCION + ':               ',25)  + REPLICATE(' ',4 - LEN(MONEDA.ABREVIATURA)) + MONEDA.ABREVIATURA + CONVERT(VARCHAR(7),CONVERT(NUMERIC(15,2),SUM(DCC.TOTAL))),
		'Total venta segun Condicon de Pago:      ' + REPLICATE(' ',4 - LEN(MONEDA.ABREVIATURA)) + MONEDA.ABREVIATURA + REPLICATE(' ',(9 - LEN(@TOTAL_NETO))) + CONVERT(VARCHAR(9), @TOTAL_NETO) AS 'NETO' 
FROM    DOCUMENTO_CC AS DCC 
LEFT JOIN CONDICION_PAGO AS CP ON DCC.CIA = CP.CIA AND DCC.ID_CONDICION_PAGO = CP.ID_CONDICION_PAGO
INNER JOIN MONEDA ON DCC.CIA = MONEDA.CIA AND DCC.ID_MONEDA = MONEDA.ID_MONEDA
WHERE	DCC.CIA			= @CIA
AND		DCC.SEDE		= @SEDE
AND		DCC.ID_TIPO_DOC	= '07'
AND		DCC.ID_SURTIDOR=@ID_SURTIDOR
AND		DCC.FECHA_DOCUMENTO	>= @FECHA_INICIO AND DCC.FECHA_DOCUMENTO <= @FECHA_FIN
GROUP	BY CP.DESCRIPCION, MONEDA.ABREVIATURA
GO
/****** Object:  StoredProcedure [dbo].[SP_DOCUMENTO_CIERRE_PRODUCTO]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*

EXEC	[SP_DOCUMENTO_CIERRE_PRODUCTO] '01', '01', 'ADMIN', 'M1', '01', 25

*/
----------------------------------------------
----------------------------------------------
CREATE	PROCEDURE	[dbo].[SP_DOCUMENTO_CIERRE_PRODUCTO]
@CIA			CHAR(2),
@SEDE			CHAR(2),
@USUARIO		VARCHAR(20),
@ID_SURTIDOR	VARCHAR(2),
@ID_TURNO		VARCHAR(2),
@ID_CONTROL		INT
AS
----------------------------------------------
DECLARE	@FECHA_INICIO	DATETIME
DECLARE	@FECHA_FIN		DATETIME
DECLARE	@TOTAL_NETO		NUMERIC(15,2)
----------------------------------------------------
SET	@FECHA_INICIO	= (SELECT APERTURA FROM E_TURNO_CONTROL WHERE CIA = @CIA AND SEDE = @SEDE AND ID_TURNO_CONTROL = @ID_CONTROL AND ID_SURTIDOR = @ID_SURTIDOR AND ID_TURNO = @ID_TURNO AND ID_USUARIO = @USUARIO)
SET	@FECHA_FIN		= (SELECT CIERRE FROM E_TURNO_CONTROL WHERE CIA = @CIA AND SEDE = @SEDE AND ID_TURNO_CONTROL = @ID_CONTROL AND ID_SURTIDOR = @ID_SURTIDOR AND ID_TURNO = @ID_TURNO AND ID_USUARIO = @USUARIO)
SET	@TOTAL_NETO		= (	SELECT	SUM(DCCD.TOTAL) 
						FROM	DOCUMENTO_CC AS DCC 
						INNER JOIN DOCUMENTO_CC_DETALLE AS DCCD ON DCC.CIA = DCCD.CIA AND DCC.SEDE = DCCD.SEDE AND DCC.ID_TIPO_DOC = DCCD.ID_TIPO_DOC AND DCC.SERIE_DOC = DCCD.SERIE_DOC AND DCC.NRO_DOC = DCCD.NRO_DOC
						WHERE	DCC.CIA		= @CIA 
						AND		DCC.SEDE	= @SEDE 
						AND		DCC.UC		= @USUARIO 
						AND		DCC.FECHA_DOCUMENTO >= @FECHA_INICIO AND DCC.FECHA_DOCUMENTO <= @FECHA_FIN)
----------------------------------------------
SELECT	LEFT(ART.DESCRIPCION,16) + '  ' + REPLICATE(' ',(3 - LEN(SUM(DCCD.CANTIDAD)))) + CONVERT(VARCHAR(3),CONVERT(INT,SUM(DCCD.CANTIDAD))) + '  ' + REPLICATE(' ',(7 - LEN(SUM(DCCD.TOTAL)))) + CONVERT(VARCHAR(7),CONVERT(NUMERIC(15,2),SUM(DCCD.TOTAL))) AS 'ARTICULO',
		'Total Venta por Producto:     ' + REPLICATE(' ',4 - LEN(MONEDA.ABREVIATURA)) + MONEDA.ABREVIATURA + REPLICATE(' ',(9 - LEN(@TOTAL_NETO))) + CONVERT(VARCHAR(9), @TOTAL_NETO) AS 'NETO' 
FROM	DOCUMENTO_CC AS DCC
INNER JOIN DOCUMENTO_CC_DETALLE AS DCCD ON DCC.CIA = DCCD.CIA AND DCC.SEDE = DCCD.SEDE AND DCC.ID_TIPO_DOC = DCCD.ID_TIPO_DOC AND DCC.SERIE_DOC = DCCD.SERIE_DOC AND DCC.NRO_DOC = DCCD.NRO_DOC 
INNER JOIN ARTICULO AS ART ON DCCD.CIA = ART.CIA AND DCCD.CIA = ART.CIA AND DCCD.ID_ARTICULO = ART.ID_ARTICULO 
INNER JOIN MONEDA ON DCC.CIA = MONEDA.CIA AND DCC.ID_MONEDA = MONEDA.ID_MONEDA
WHERE	DCC.CIA			= @CIA
AND		DCC.SEDE		= @SEDE
AND		DCC.UC			= @USUARIO
AND		DCC.ID_TIPO_DOC	= '07'
AND		DCC.FECHA_DOCUMENTO	>= @FECHA_INICIO AND DCC.FECHA_DOCUMENTO <= @FECHA_FIN
GROUP	BY ART.DESCRIPCION, MONEDA.ABREVIATURA
ORDER	BY ART.DESCRIPCION
GO
/****** Object:  StoredProcedure [dbo].[SP_DOCUMENTO_CIERRE_PRODUCTO_TOTAL]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create	PROCEDURE	[dbo].[SP_DOCUMENTO_CIERRE_PRODUCTO_TOTAL]
@CIA			CHAR(2),
@SEDE			CHAR(2),
@ID_SURTIDOR	VARCHAR(2),
@FECHA DATETIME
AS
----------------------------------------------
DECLARE	@FECHA_INICIO	DATETIME
DECLARE	@FECHA_FIN		DATETIME
DECLARE	@TOTAL_NETO		NUMERIC(15,2)
----------------------------------------------------
SET	@FECHA_INICIO	= (SELECT TOP 1 APERTURA FROM E_TURNO_CONTROL WHERE CIA = @CIA AND SEDE = @SEDE AND ID_SURTIDOR = @ID_SURTIDOR AND CONVERT(VARCHAR(10),APERTURA,103)=@FECHA ORDER BY APERTURA asc)
SET	@FECHA_FIN		= (SELECT TOP 1 CIERRE FROM E_TURNO_CONTROL WHERE CIA = @CIA AND SEDE = @SEDE  AND ID_SURTIDOR = @ID_SURTIDOR AND CONVERT(VARCHAR(10),APERTURA,103)=@FECHA ORDER BY CIERRE desc)
SET	@TOTAL_NETO		= (	SELECT	SUM(DCCD.TOTAL) 
						FROM	DOCUMENTO_CC AS DCC 
						INNER JOIN DOCUMENTO_CC_DETALLE AS DCCD ON DCC.CIA = DCCD.CIA AND DCC.SEDE = DCCD.SEDE AND DCC.ID_TIPO_DOC = DCCD.ID_TIPO_DOC AND DCC.SERIE_DOC = DCCD.SERIE_DOC AND DCC.NRO_DOC = DCCD.NRO_DOC
						WHERE	DCC.CIA		= @CIA 
						AND		DCC.SEDE	= @SEDE 
						AND		DCC.FECHA_DOCUMENTO >= @FECHA_INICIO AND DCC.FECHA_DOCUMENTO <= @FECHA_FIN)
----------------------------------------------
SELECT	LEFT(ART.DESCRIPCION,16) + '  ' + REPLICATE(' ',(3 - LEN(SUM(DCCD.CANTIDAD)))) + CONVERT(VARCHAR(3),CONVERT(INT,SUM(DCCD.CANTIDAD))) + '  ' + REPLICATE(' ',(7 - LEN(SUM(DCCD.TOTAL)))) + CONVERT(VARCHAR(7),CONVERT(NUMERIC(15,2),SUM(DCCD.TOTAL))) AS 'ARTICULO',
		'Total Venta por Producto:     ' + REPLICATE(' ',4 - LEN(MONEDA.ABREVIATURA)) + MONEDA.ABREVIATURA + REPLICATE(' ',(9 - LEN(@TOTAL_NETO))) + CONVERT(VARCHAR(9), @TOTAL_NETO) AS 'NETO' 
FROM	DOCUMENTO_CC AS DCC
INNER JOIN DOCUMENTO_CC_DETALLE AS DCCD ON DCC.CIA = DCCD.CIA AND DCC.SEDE = DCCD.SEDE AND DCC.ID_TIPO_DOC = DCCD.ID_TIPO_DOC AND DCC.SERIE_DOC = DCCD.SERIE_DOC AND DCC.NRO_DOC = DCCD.NRO_DOC 
INNER JOIN ARTICULO AS ART ON DCCD.CIA = ART.CIA AND DCCD.CIA = ART.CIA AND DCCD.ID_ARTICULO = ART.ID_ARTICULO 
INNER JOIN MONEDA ON DCC.CIA = MONEDA.CIA AND DCC.ID_MONEDA = MONEDA.ID_MONEDA
WHERE	DCC.CIA			= @CIA
AND		DCC.SEDE		= @SEDE
AND		DCC.ID_TIPO_DOC	= '07'
AND		DCC.ID_SURTIDOR=@ID_SURTIDOR
AND		DCC.FECHA_DOCUMENTO	>= @FECHA_INICIO AND DCC.FECHA_DOCUMENTO <= @FECHA_FIN
GROUP	BY ART.DESCRIPCION, MONEDA.ABREVIATURA
ORDER	BY ART.DESCRIPCION
GO
/****** Object:  StoredProcedure [dbo].[SP_DOCUMENTO_CIERRE_TICKET]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*

EXEC [SP_DOCUMENTO_CIERRE_TICKET] '01', '01', 'ADMIN','M1', '01', 25

*/
----------------------------------------------------
----------------------------------------------------
CREATE	PROCEDURE	[dbo].[SP_DOCUMENTO_CIERRE_TICKET]
@CIA			CHAR(2),
@SEDE			CHAR(2),
@USUARIO		VARCHAR(20),
@ID_SURTIDOR	VARCHAR(2),
@ID_TURNO		VARCHAR(2),
@ID_CONTROL		INT
AS
----------------------------------------------------
DECLARE	@FECHA_INICIO	DATETIME
DECLARE	@FECHA_FIN		DATETIME
DECLARE	@TOTAL_NETO		NUMERIC(15,2)
----------------------------------------------------
SET	@FECHA_INICIO	= (SELECT APERTURA FROM E_TURNO_CONTROL WHERE CIA = @CIA AND SEDE = @SEDE AND ID_TURNO_CONTROL = @ID_CONTROL AND ID_SURTIDOR = @ID_SURTIDOR AND ID_TURNO = @ID_TURNO AND ID_USUARIO = @USUARIO)
SET	@FECHA_FIN		= (SELECT CIERRE FROM E_TURNO_CONTROL WHERE CIA = @CIA AND SEDE = @SEDE AND ID_TURNO_CONTROL = @ID_CONTROL AND ID_SURTIDOR = @ID_SURTIDOR AND ID_TURNO = @ID_TURNO AND ID_USUARIO = @USUARIO)
SET	@TOTAL_NETO		= (SELECT SUM(TOTAL) FROM DOCUMENTO_CC WHERE CIA = @CIA AND SEDE = @SEDE AND UC = @USUARIO AND FECHA_DOCUMENTO	>= @FECHA_INICIO AND FECHA_DOCUMENTO <= @FECHA_FIN)
--------------------------------------------------
SELECT	REPLICATE(' ',CONVERT(INT,((40 - (LEN(COM.DESCRIPCION)))/2))) + COM.DESCRIPCION AS 'DESCRIPCION',
		REPLICATE(' ',CONVERT(INT,((40 - (LEN(LEFT(COM.DIRECCION,34))))/2))) + LEFT(COM.DIRECCION,34)AS 'DIRECCION',
		REPLICATE(' ',CONVERT(INT,((40 - (LEN(SUBSTRING(COM.DIRECCION,36,(LEN(COM.DIRECCION) - 35)))))/2))) + SUBSTRING(COM.DIRECCION,35,(LEN(COM.DIRECCION) - 34)) AS 'DIRECCION2', 
		REPLICATE(' ',CONVERT(INT,((40 - (LEN('Telefono: ' + COM.FONO1)))/2))) + 'Telefono: ' + COM.FONO1 AS 'FONO1',
		REPLICATE(' ',CONVERT(INT,((40 - (LEN('RUC: ' + COM.NIT)))/2))) + 'RUC: ' + COM.NIT AS 'NIT',
		'Usuario: ' + DCC.UC as 'USUARIO',
		'Fecha:   ' + CONVERT(VARCHAR(10),DCC.FECHA_DOCUMENTO, 103) + '     Hora:  ' + CONVERT(VARCHAR(10), DCC.FECHA_DOCUMENTO, 108) AS 'FECHA', 
		'Caja:    ' + CONVERT(VARCHAR(2),DCC.ID_SURTIDOR) AS 'CAJA',
		TD.ABREVIATURA + '/' + DCC.SERIE_DOC + '-' + DCC.NRO_DOC +  REPLICATE(' ',(15 - LEN(DCC.TOTAL))) + CONVERT(VARCHAR(15),CONVERT(NUMERIC(15,2),DCC.TOTAL)) AS 'TICKET',
		'Total Venta por Ticket:     ' + REPLICATE(' ',4 - LEN(MONEDA.ABREVIATURA)) + MONEDA.ABREVIATURA + REPLICATE(' ',(9 - LEN(@TOTAL_NETO))) + CONVERT(VARCHAR(9), @TOTAL_NETO) AS 'NETO' 
FROM	DOCUMENTO_CC AS DCC 
INNER JOIN TIPO_DOCUMENTO AS TD ON DCC.CIA = TD.CIA AND DCC.ID_TIPO_DOC = TD.ID_TIPO_DOC 
INNER JOIN COMPANIA AS COM ON DCC.CIA = COM.CIA 
INNER JOIN MONEDA ON DCC.CIA = MONEDA.CIA AND DCC.ID_MONEDA = MONEDA.ID_MONEDA
WHERE	DCC.CIA			= @CIA
AND		DCC.SEDE		= @SEDE
AND		DCC.ID_TIPO_DOC	= '07'
AND		DCC.UC			= @USUARIO
AND		DCC.FECHA_DOCUMENTO	>= @FECHA_INICIO AND DCC.FECHA_DOCUMENTO <= @FECHA_FIN
ORDER	BY DCC.NRO_DOC, FECHA_DOCUMENTO
GO
/****** Object:  StoredProcedure [dbo].[SP_DOCUMENTO_CIERRE_TICKET_TOTAL]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create	PROCEDURE	[dbo].[SP_DOCUMENTO_CIERRE_TICKET_TOTAL]
@CIA			CHAR(2),
@SEDE			CHAR(2),
@ID_SURTIDOR	VARCHAR(2),
@FECHA DATETIME
AS
----------------------------------------------------
DECLARE	@FECHA_INICIO	DATETIME
DECLARE	@FECHA_FIN		DATETIME
DECLARE	@TOTAL_NETO		NUMERIC(15,2)
----------------------------------------------------
SET	@FECHA_INICIO	= (SELECT TOP 1 APERTURA FROM E_TURNO_CONTROL WHERE CIA = @CIA AND SEDE = @SEDE AND ID_SURTIDOR = @ID_SURTIDOR AND CONVERT(VARCHAR(10),APERTURA,103)=@FECHA ORDER BY APERTURA asc)
SET	@FECHA_FIN		= (SELECT TOP 1 CIERRE FROM E_TURNO_CONTROL WHERE CIA = @CIA AND SEDE = @SEDE  AND ID_SURTIDOR = @ID_SURTIDOR AND CONVERT(VARCHAR(10),APERTURA,103)=@FECHA ORDER BY CIERRE desc)
SET	@TOTAL_NETO		= (SELECT SUM(TOTAL) FROM DOCUMENTO_CC WHERE CIA = @CIA AND SEDE = @SEDE AND FECHA_DOCUMENTO	>= @FECHA_INICIO AND FECHA_DOCUMENTO <= @FECHA_FIN)
----------------------------------------------
SELECT	REPLICATE(' ',CONVERT(INT,((40 - (LEN(COM.DESCRIPCION)))/2))) + COM.DESCRIPCION AS 'DESCRIPCION',
		REPLICATE(' ',CONVERT(INT,((40 - (LEN(LEFT(COM.DIRECCION,34))))/2))) + LEFT(COM.DIRECCION,34)AS 'DIRECCION',
		REPLICATE(' ',CONVERT(INT,((40 - (LEN(SUBSTRING(COM.DIRECCION,36,(LEN(COM.DIRECCION) - 35)))))/2))) + SUBSTRING(COM.DIRECCION,35,(LEN(COM.DIRECCION) - 34)) AS 'DIRECCION2', 
		REPLICATE(' ',CONVERT(INT,((40 - (LEN('Telefono: ' + COM.FONO1)))/2))) + 'Telefono: ' + COM.FONO1 AS 'FONO1',
		REPLICATE(' ',CONVERT(INT,((40 - (LEN('RUC: ' + COM.NIT)))/2))) + 'RUC: ' + COM.NIT AS 'NIT',
		'Usuario: ' + DCC.UC as 'USUARIO',
		'Fecha:   ' + CONVERT(VARCHAR(10),DCC.FECHA_DOCUMENTO, 103) + '     Hora:  ' + CONVERT(VARCHAR(10), DCC.FECHA_DOCUMENTO, 108) AS 'FECHA', 
		'Caja:    ' + CONVERT(VARCHAR(2),DCC.ID_SURTIDOR) AS 'CAJA',
		TD.ABREVIATURA + '/' + DCC.SERIE_DOC + '-' + DCC.NRO_DOC +  REPLICATE(' ',(15 - LEN(DCC.TOTAL))) + CONVERT(VARCHAR(15),CONVERT(NUMERIC(15,2),DCC.TOTAL)) AS 'TICKET',
		'Total Venta por Ticket:     ' + REPLICATE(' ',4 - LEN(MONEDA.ABREVIATURA)) + MONEDA.ABREVIATURA + REPLICATE(' ',(9 - LEN(@TOTAL_NETO))) + CONVERT(VARCHAR(9), @TOTAL_NETO) AS 'NETO' 
FROM	DOCUMENTO_CC AS DCC 
INNER JOIN TIPO_DOCUMENTO AS TD ON DCC.CIA = TD.CIA AND DCC.ID_TIPO_DOC = TD.ID_TIPO_DOC 
INNER JOIN COMPANIA AS COM ON DCC.CIA = COM.CIA 
INNER JOIN MONEDA ON DCC.CIA = MONEDA.CIA AND DCC.ID_MONEDA = MONEDA.ID_MONEDA
WHERE	DCC.CIA			= @CIA
AND		DCC.SEDE		= @SEDE
AND		DCC.ID_TIPO_DOC	= '07'
AND		DCC.ID_SURTIDOR=@ID_SURTIDOR
AND		DCC.FECHA_DOCUMENTO	>= @FECHA_INICIO AND DCC.FECHA_DOCUMENTO <= @FECHA_FIN
ORDER	BY DCC.NRO_DOC, FECHA_DOCUMENTO
GO
/****** Object:  StoredProcedure [dbo].[SP_E_CARA_ACTUALIZAR]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
SELECT * FROM E_CARA
[SP_E_CARA_ACTUALIZAR] 
'01', '01', 'CARA DE PRUEBA 111', '01','1','01/07/2012 12:00:00 a.m.', '01/08/2010 12:00:00 a.m.','ADMIN'

*/
-----------------------------------------------
-----------------------------------------------
create	PROCEDURE	[dbo].[SP_E_CARA_ACTUALIZAR]
@CIA					CHAR(2), 
@ID_CARA				CHAR(2),
@DESCRIPCION			VARCHAR(100), 
@ID_ESTADO				CHAR(2), 
@FLAG_ENVIO				CHAR(1), 
@UM						VARCHAR(25)
AS
-----------------------------------------------
DECLARE @VARMSG			VARCHAR(MAX)
DECLARE	@COUNT			INT
-----------------------------------------------
/*		INSERTAMOS LOS DATOS EN LA TABLA	*/
BEGIN TRANSACTION
	-------------------------------------------
	UPDATE	E_CARA
	SET		DESCRIPCION			= @DESCRIPCION, 
			ID_ESTADO			= @ID_ESTADO, 
			FLAG_ENVIO			= @FLAG_ENVIO, 					
			FM					= GETDATE(), 
			UM					= @UM
	WHERE	CIA					= @CIA 
	AND		ID_CARA				= @ID_CARA 
	-------------------------------------------
	IF @@ERROR <> 0 OR @@ROWCOUNT <> 1
	BEGIN
		---------------------------------------
		SET		@VARMSG	= 'SE PRODUJO UN ERROR DURANTE EL PROCESO DE ACTUALIZAR LA CARA. NO SE ACTUALIZARON LOS DATOS.'
		GOTO	MSGERROR
		----------------------------------------
	END 
	ELSE
	BEGIN
		----------------------------------------
		SET	@VARMSG				= 'DATOS ACTUALIZADOS.'		
		----------------------------------------
	END
	--------------------------------------------
COMMIT TRANSACTION
------------------------------------------------
RETURN
MSGERROR:
		ROLLBACK TRANSACTION
		----------------------------------------
		RAISERROR	(@VARMSG, 15, 1)		
		RETURN
GO
/****** Object:  StoredProcedure [dbo].[SP_E_CARA_ELIMINAR]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
SELECT * FROM E_CARA
[SP_E_CARA_ELIMINAR2] '01','01','admin'
SP_LISTAR_CARA '01'
delete E_CARA where id_cara in('12')
select * from E_CARA
*/
-----------------------------------------------
-----------------------------------------------
create	PROCEDURE	[dbo].[SP_E_CARA_ELIMINAR]
@CIA			CHAR(2), 
@ID_CARA		INT,
@UA				VARCHAR(10)--,
--@AA				VARCHAR(60)
AS
-----------------------------------------------
DECLARE @VARMSG			VARCHAR(MAX)
DECLARE	@FECHA_ACTUAL	DATETIME
DECLARE @ID_ESTADO		CHAR(2)
----------------------------------------------
SET		@FECHA_ACTUAL	=	GETDATE()
SET		 @ID_ESTADO		=  '02'	
-----------------------------------------------
/*		INSERTAMOS LOS DATOS EN LA TABLA	*/
BEGIN TRANSACTION
	-------------------------------------------
	UPDATE	E_CARA
	SET		ID_ESTADO	= @ID_ESTADO,	
			FA			= @FECHA_ACTUAL, 
			UA			= @UA--,
		--	AA			= @AA
	WHERE	CIA			= @CIA 
	AND		ID_CARA		= @ID_CARA 
	-------------------------------------------
	IF @@ERROR <> 0 OR @@ROWCOUNT <> 1
	BEGIN
		---------------------------------------
		SET		@VARMSG	= 'SE PRODUJO UN ERROR DURANTE EL PROCESO DE ELIMINACION DE LA CARA. NO SE ELIMINO EL REGISTRO.'
		GOTO	MSGERROR
		----------------------------------------
	END 
	ELSE
	BEGIN
		----------------------------------------
		SET	@VARMSG	= 'REGISTRO ELIMINADO.'
		----------------------------------------
	END	
COMMIT TRANSACTION
------------------------------------------------
RETURN
MSGERROR:
		ROLLBACK TRANSACTION
		----------------------------------------
		RAISERROR	(@VARMSG, 15, 1)
		RETURN
GO
/****** Object:  StoredProcedure [dbo].[SP_E_CARA_INSERTAR]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*		
[SP_E_CARA_INSERTAR] '01', '15', 'ISLA 0111', '01'	,'1'	,'admin'
SELECT * FROM E_CARA
*/
-----------------------------------------------
-----------------------------------------------
create	PROCEDURE	[dbo].[SP_E_CARA_INSERTAR]
@CIA					CHAR(2), 
@ID_CARA				CHAR(2),  
@DESCRIPCION			VARCHAR(100), 
@ID_ESTADO				CHAR(2), 
@FLAG_ENVIO				CHAR(1), 
@UC						VARCHAR(30)
AS
-----------------------------------------------
DECLARE @VARMSG			VARCHAR(MAX)
DECLARE	@COUNT			INT
DECLARE	@FECHA_ACTUAL	DATETIME
----------------------------------------------
SET		@FECHA_ACTUAL	=	GETDATE()
-----------------------------------------------
/*		INSERTAMOS LOS DATOS EN LA TABLA	*/
BEGIN TRANSACTION
	-------------------------------------------
	INSERT	INTO E_CARA
	(
		CIA, ID_CARA,  DESCRIPCION, ID_ESTADO, FLAG_ENVIO, FC, UC
	)
	VALUES		/*		SELECT * FROM E_CARA		*/
	(
		@CIA, @ID_CARA, @DESCRIPCION, @ID_ESTADO, @FLAG_ENVIO, @FECHA_ACTUAL, @UC
	)
	-------------------------------------------
	IF @@ERROR <> 0 OR @@ROWCOUNT <> 1
	BEGIN
		---------------------------------------
		SET		@VARMSG	= 'SE PRODUJO UN ERROR DURANTE EL PROCESO DE GRABACION DE LA CARA. NO SE GRABARON LOS DATOS.'
		GOTO	MSGERROR
		----------------------------------------
	END 
	ELSE
	BEGIN
		----------------------------------------
		SET	@VARMSG				= 'DATOS GRABADOS.'
		----------------------------------------
	END
	--------------------------------------------
COMMIT TRANSACTION
------------------------------------------------
RETURN
MSGERROR:
		ROLLBACK TRANSACTION
		----------------------------------------
		RAISERROR	(@VARMSG, 15, 1)	
		RETURN
GO
/****** Object:  StoredProcedure [dbo].[SP_E_DISPLAY_MOSTRAR_DATOS]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*

SELECT * FROM E_DISPLAY

EXEC [SP_E_DISPLAY_MOSTRAR_DATOS] '01', '02', '01'

*/
----------------------------------------------
----------------------------------------------
CREATE	PROCEDURE	[dbo].[SP_E_DISPLAY_MOSTRAR_DATOS]
@CIA			CHAR(2),
@SEDE			CHAR(2),
@ID_SURTIDOR	CHAR(2)
AS
----------------------------------------------
----------------------------------------------
SELECT	ES.ID_SURTIDOR, UPPER(ES.DESCRIPCION), UPPER(ED.TURNO), CONVERT(NUMERIC(15,2),ED.CANTIDAD)AS 'CANTIDAD', CONVERT(NUMERIC(15,2),ED.TOTAL)AS'TOTAL', UPPER(ED.ARTICULO), CONVERT(NUMERIC(15,2),ED.PRECIO)AS'PRECIO', UPPER(ED.ESTADO), 
		UPPER(ED.PLACA), UPPER(EC.DESCRIPCION) AS 'CARA', UPPER(ED.UNIDAD), CASE ED.ESTADO
														WHEN 'ABAJO' THEN '~/imagenes/Surtidor/E_Esperando.gif'
														WHEN 'ESPERANDO' THEN '~/imagenes/Surtidor/E_Esperando.gif'
														WHEN 'CLIENTE' THEN '~/imagenes/Surtidor/E_Esperando.gif'
														WHEN 'DESPACHANDO' THEN '~/imagenes/Surtidor/E_Despachando.gif'
														WHEN 'FINALIZADO' THEN '~/imagenes/Surtidor/E_Esperando.gif'
														WHEN 'PAUSA' THEN '~/imagenes/Surtidor/E_Pause.gif'
														WHEN 'AUTORIZANDO' THEN '~/imagenes/Surtidor/E_Autorizando.gif'
														ELSE '~/imagenes/Surtidor/E_Error.gif'
													   END AS 'IMAGEN',
		UPPER(ED.DESPACHADOR)
FROM	E_DISPLAY AS ED 
INNER JOIN E_MANGUERA AS EM ON ED.CIA = EM.CIA AND ED.SEDE = EM.SEDE AND ED.ID_MANGUERA = EM.ID_MANGUERA 
INNER JOIN E_SURTIDOR AS ES ON EM.CIA = ES.CIA AND EM.ID_SURTIDOR = ES.ID_SURTIDOR 
INNER JOIN E_CARA AS EC ON EM.CIA = EC.CIA AND EM.ID_CARA = EC.ID_CARA
WHERE	ED.CIA			= @CIA
AND		ED.SEDE			= @SEDE
AND		ES.ID_SURTIDOR	= @ID_SURTIDOR
AND     ED.ESTADO <> 'FINALIZADO'
ORDER BY ES.ID_SURTIDOR ASC, EC.DESCRIPCION ASC
GO
/****** Object:  StoredProcedure [dbo].[SP_E_DISPLAY_MOSTRAR_SURTIDORES]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*



*/
----------------------------------------------
----------------------------------------------
create	PROCEDURE	[dbo].[SP_E_DISPLAY_MOSTRAR_SURTIDORES]
@CIA			CHAR(2),
@SEDE			CHAR(2)
AS
----------------------------------------------
----------------------------------------------
SELECT	DISTINCT E_SURTIDOR.ID_SURTIDOR
FROM	E_DISPLAY 
INNER JOIN E_MANGUERA ON E_DISPLAY.CIA = E_MANGUERA.CIA AND E_DISPLAY.SEDE = E_MANGUERA.SEDE AND E_DISPLAY.ID_MANGUERA = E_MANGUERA.ID_MANGUERA 
INNER JOIN E_SURTIDOR ON E_MANGUERA.CIA = E_SURTIDOR.CIA AND E_MANGUERA.ID_SURTIDOR = E_SURTIDOR.ID_SURTIDOR 
INNER JOIN E_CARA ON E_MANGUERA.CIA = E_CARA.CIA AND E_MANGUERA.ID_CARA = E_CARA.ID_CARA
WHERE	E_DISPLAY.CIA			= @CIA
AND		E_DISPLAY.SEDE			= @SEDE
ORDER BY E_SURTIDOR.ID_SURTIDOR ASC
GO
/****** Object:  StoredProcedure [dbo].[SP_E_DISPLAY_TRAER_COMPANIA]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*


*/
------------------------------------------
------------------------------------------
create	PROCEDURE [dbo].[SP_E_DISPLAY_TRAER_COMPANIA]
@CIA	CHAR(2)
AS
------------------------------------------
------------------------------------------
SELECT	COMPANIA.CIA, COMPANIA.DESCRIPCION, COMPANIA.NIT, COMPANIA.DIRECCION, COMPANIA.FONO1, DEPART.DES_DPTO + ' - ' + DIST.DES_DISTRITO
FROM	COMPANIA 
INNER JOIN UBICACION AS DEPART ON COMPANIA.CIA = DEPART.CIA AND COMPANIA.ID_PAIS = DEPART.ID_PAIS AND COMPANIA.ID_DPTO = DEPART.ID_DPTO AND 
           COMPANIA.ID_PROVINCIA = DEPART.ID_PROVINCIA AND COMPANIA.ID_DISTRITO = DEPART.ID_DISTRITO 
INNER JOIN UBICACION AS DIST ON COMPANIA.CIA = DIST.CIA AND COMPANIA.ID_PAIS = DIST.ID_PAIS AND COMPANIA.ID_DPTO = DIST.ID_DPTO AND 
           COMPANIA.ID_PROVINCIA = DIST.ID_PROVINCIA AND COMPANIA.ID_DISTRITO = DIST.ID_DISTRITO
WHERE	COMPANIA.CIA = @CIA
------------------------------------------
GO
/****** Object:  StoredProcedure [dbo].[SP_E_IMPRESORA_ACTUALIZAR]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
DELETE E_IMPRESORA WHERE ID_IMPRESORA IN('2','3','4')
SELECT * FROM E_IMPRESORA

[SP_E_IMPRESORA_ACTUALIZAR]
  '01', '02' , '02', '02' , 'IMPRESORA 02', 'FF9999999001' , 'A000-000-1112', 
  '05' , 1 , 999999 , '5' , 36 , '01' , '1' ,  'ADMIN' 
  */
-----------------------------------------------
create	PROCEDURE	[dbo].[SP_E_IMPRESORA_ACTUALIZAR]
@CIA					CHAR(2), 
@SEDE					CHAR(2),
@ID_IMPRESORA			CHAR(2), 
@SEDEACT				CHAR(2),
@DESCRIPCION			VARCHAR(100), 
@SERIE_EQUIPO			VARCHAR(20), 
@AUTORIZACION			VARCHAR(20), 
--@ID_TIPO_DOC			CHAR(2), 
@NRO_DOC_DEL			INT,
@NRO_DOC_AL				INT,
@SERIE_DOC				CHAR(4),
@CORRELATIVO			INT,
@ID_ESTADO				CHAR(2), 
@FLAG_ENVIO				CHAR(1), 
@UM						VARCHAR(25)
AS
-----------------------------------------------
DECLARE @VARMSG			VARCHAR(MAX)
DECLARE	@COUNT			INT
DECLARE	@FECHA_ACTUAL	DATETIME
----------------------------------------------
SET		@FECHA_ACTUAL	=	GETDATE()
-----------------------------------------------
/*		INSERTAMOS LOS DATOS EN LA TABLA	*/
BEGIN TRANSACTION
	-------------------------------------------
	UPDATE	E_IMPRESORA
	SET		SEDE				= @SEDEACT,
			DESCRIPCION			= @DESCRIPCION, 
			SERIE_EQUIPO		= @SERIE_EQUIPO,
			AUTORIZACION		= @AUTORIZACION,
			--ID_TIPO_DOC			= @ID_TIPO_DOC,
			NRO_DOC_DEL			= @NRO_DOC_DEL,
			NRO_DOC_AL			= @NRO_DOC_AL,
			SERIE_DOC			= @SERIE_DOC,
			CORRELATIVO			= @CORRELATIVO,
			ID_ESTADO			= @ID_ESTADO, 
			FLAG_ENVIO			= @FLAG_ENVIO, 					
			FM					= @FECHA_ACTUAL, 
			UM					= @UM
	WHERE	CIA					= @CIA 				
	AND		SEDE				= @SEDE
	AND		ID_IMPRESORA		= @ID_IMPRESORA 
	-------------------------------------------
	IF @@ERROR <> 0 OR @@ROWCOUNT <> 1
	BEGIN
		---------------------------------------
		SET		@VARMSG	= 'SE PRODUJO UN ERROR DURANTE EL PROCESO DE ACTUALIZAR LA IMPRESORA. NO SE ACTUALIZARON LOS DATOS.'
		GOTO	MSGERROR
		----------------------------------------
	END 
	ELSE
	BEGIN
		----------------------------------------
		SET	@VARMSG				= 'DATOS ACTUALIZADOS.'	
		----------------------------------------
	END
	--------------------------------------------
		/*	INSERTAR LAS POLITICAS	*/
	--------------------------------------------
COMMIT TRANSACTION
------------------------------------------------
RETURN
MSGERROR:
		ROLLBACK TRANSACTION
		----------------------------------------
		RAISERROR	(@VARMSG, 15, 1)	
		RETURN
GO
/****** Object:  StoredProcedure [dbo].[SP_E_IMPRESORA_ELIMINAR]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
SELECT * FROM E_impresora
[SP_E_IMPRESORA_ELIMINAR] '01','01','01','ADMIN'
*/
-----------------------------------------------
-----------------------------------------------
create	PROCEDURE	[dbo].[SP_E_IMPRESORA_ELIMINAR]
@CIA			CHAR(2), 
@SEDE			CHAR(2), 
@ID_IMPRESORA	CHAR(2),
@UA				VARCHAR(20)--,
--@AA				VARCHAR(60)
AS
-----------------------------------------------
DECLARE @VARMSG			VARCHAR(MAX)
------------------------------------------------
/*		INSERTAMOS LOS DATOS EN LA TABLA	*/
BEGIN TRANSACTION
	-------------------------------------------
	UPDATE	E_IMPRESORA
	SET		ID_ESTADO	= '02',	
			FA			= GETDATE(), 
			UA			= @UA--,
		--	AA			= @AA
	WHERE	CIA			= @CIA 
	AND		SEDE = @SEDE 
	AND		ID_IMPRESORA = @ID_IMPRESORA 
	-------------------------------------------
	IF @@ERROR <> 0 OR @@ROWCOUNT <> 1
	BEGIN
		---------------------------------------
		SET		@VARMSG	= 'SE PRODUJO UN ERROR DURANTE EL PROCESO DE ELIMINACION DE IMPRESORA. NO SE ELIMINO EL REGISTRO.'
		GOTO	MSGERROR
		----------------------------------------
	END 
	ELSE
	BEGIN
		----------------------------------------
		SET	@VARMSG	= 'REGISTRO ELIMINADO.'
		----------------------------------------
	END	
COMMIT TRANSACTION
------------------------------------------------
RETURN
MSGERROR:
		ROLLBACK TRANSACTION
		----------------------------------------
		RAISERROR	(@VARMSG, 15, 1)
		RETURN
GO
/****** Object:  StoredProcedure [dbo].[SP_E_IMPRESORA_INSERTAR]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
select * from e_impresora
*/
-----------------------------------------------
-----------------------------------------------
create	PROCEDURE	[dbo].[SP_E_IMPRESORA_INSERTAR]
@CIA					CHAR(2), 
@SEDE					CHAR(2),
@ID_IMPRESORA			CHAR(2), 
@DESCRIPCION			VARCHAR(100), 
@SERIE_EQUIPO			VARCHAR(100), 
@AUTORIZACION			VARCHAR(100), 
@ID_TIPO_DOC			CHAR(2), 
@NRO_DOC_DEL			INT,
@NRO_DOC_AL				INT,
@SERIE_DOC				CHAR(4),
@CORRELATIVO			INT,
@ID_ESTADO				CHAR(2), 
@FLAG_ENVIO				CHAR(1), 
@UC						VARCHAR(25)
AS
-----------------------------------------------
DECLARE @VARMSG			VARCHAR(MAX)
DECLARE	@COUNT			INT
DECLARE	@FECHA_ACTUAL	DATETIME
----------------------------------------------
SET		@FECHA_ACTUAL	=	GETDATE()
-----------------------------------------------
/*		INSERTAMOS LOS DATOS EN LA TABLA	*/
BEGIN TRANSACTION
		-------------------------------------------
	INSERT	INTO E_IMPRESORA
	(
		CIA, SEDE, ID_IMPRESORA, DESCRIPCION, SERIE_EQUIPO, AUTORIZACION , ID_TIPO_DOC , 
		NRO_DOC_DEL, NRO_DOC_AL, SERIE_DOC, CORRELATIVO ,ID_ESTADO, FLAG_ENVIO, FC, UC
	)
	VALUES		/*		SELECT * FROM E_IMPRESORA		*/
	(
		@CIA, @SEDE, @ID_IMPRESORA, @DESCRIPCION, @SERIE_EQUIPO, @AUTORIZACION , @ID_TIPO_DOC , 
		@NRO_DOC_DEL, @NRO_DOC_AL, @SERIE_DOC, @CORRELATIVO, @ID_ESTADO, @FLAG_ENVIO, @FECHA_ACTUAL, @UC
	)
	-------------------------------------------
	IF @@ERROR <> 0 OR @@ROWCOUNT <> 1
	BEGIN
		---------------------------------------
		SET		@VARMSG	= 'SE PRODUJO UN ERROR DURANTE EL PROCESO DE GRABACION DE LA IMPRESORA. NO SE GRABARON LOS DATOS.'
		GOTO	MSGERROR
		----------------------------------------
	END 
	ELSE
	BEGIN
		----------------------------------------
		SET	@VARMSG					= 'DATOS GRABADOS.'
		----------------------------------------
	END
	--------------------------------------------
COMMIT TRANSACTION
------------------------------------------------
RETURN
MSGERROR:
		ROLLBACK TRANSACTION
		----------------------------------------
		RAISERROR	(@VARMSG, 15, 1)		
		RETURN
GO
/****** Object:  StoredProcedure [dbo].[SP_E_ISLA_ACTUALIZAR]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
SELECT * FROM E_ISLA
[SP_E_ISLA_ACTUALIZAR] '01', '01', 'ISLA 0111', '01','01/07/2010 12:00:00 a.m.', '01/08/2010 12:00:00 a.m.','ADMIN'
 

 DELETE E_ISLA WHERE ID_ISLA IN('4')
*/
-----------------------------------------------
-----------------------------------------------
create	PROCEDURE	[dbo].[SP_E_ISLA_ACTUALIZAR]
@CIA					CHAR(2), 
@ID_ISLA				CHAR(2), 
@DESCRIPCION			VARCHAR(100), 
@ID_ESTADO				CHAR(2), 
@FLAG_ENVIO				CHAR(1), 
@UM						VARCHAR(25)
AS
-----------------------------------------------
DECLARE @VARMSG			VARCHAR(MAX)
DECLARE	@COUNT			INT
DECLARE	@FECHA_ACTUAL	DATETIME
----------------------------------------------
SET		@FECHA_ACTUAL	=	GETDATE()
-----------------------------------------------
/*		INSERTAMOS LOS DATOS EN LA TABLA	*/
BEGIN TRANSACTION
	-------------------------------------------
	UPDATE	E_ISLA
	SET		DESCRIPCION			= @DESCRIPCION, 
			ID_ESTADO			= @ID_ESTADO, 
			FLAG_ENVIO			= @FLAG_ENVIO, 					
			FM					= @FECHA_ACTUAL, 
			UM					= @UM
	WHERE	CIA					= @CIA 
	AND		ID_ISLA				= @ID_ISLA 
	-------------------------------------------
	IF @@ERROR <> 0 OR @@ROWCOUNT <> 1
	BEGIN
		---------------------------------------
		SET		@VARMSG	= 'SE PRODUJO UN ERROR DURANTE EL PROCESO DE ACTUALIZAR LA ISLA. NO SE ACTUALIZARON LOS DATOS.'
		GOTO	MSGERROR
		----------------------------------------
	END 
	ELSE
	BEGIN
		----------------------------------------
		SET	@VARMSG				= 'DATOS ACTUALIZADOS.'
		
		----------------------------------------
	END
	--------------------------------------------
	
COMMIT TRANSACTION
------------------------------------------------
RETURN
MSGERROR:
		ROLLBACK TRANSACTION
		----------------------------------------
		RAISERROR	(@VARMSG, 15, 1)		
		RETURN
GO
/****** Object:  StoredProcedure [dbo].[SP_E_ISLA_ELIMINAR]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
[SP_E_ISLA_ELIMINAR] '01','12','admin'
select ID_ESTADO,* from e_isla
*/
-----------------------------------------------
-----------------------------------------------
CREATE	PROCEDURE	[dbo].[SP_E_ISLA_ELIMINAR]
@CIA CHAR(2), @ID_ISLA CHAR(2),@UA	VARCHAR(10)
AS
-----------------------------------------------
DECLARE @VARMSG			VARCHAR(MAX)
-----------------------------------------------
BEGIN TRANSACTION
	-------------------------------------------
	UPDATE	E_ISLA
	SET		ID_ESTADO	= '02'	,
			FA			= GETDATE(), 
			UA			= @UA
	WHERE	CIA			= @CIA 
	AND		ID_ISLA		= @ID_ISLA 
	-------------------------------------------
	IF @@ERROR <> 0 OR @@ROWCOUNT <> 1
	BEGIN
		---------------------------------------
		SET		@VARMSG	= 'SE PRODUJO UN ERROR DURANTE EL PROCESO DE ELIMINACION DE LA ISLA. NO SE ELIMINO EL REGISTRO.'
		GOTO	MSGERROR
		----------------------------------------
	END 
	ELSE
	BEGIN SET	@VARMSG	= 'REGISTRO ELIMINADO.'	END	
COMMIT TRANSACTION
------------------------------------------------
RETURN
MSGERROR:
		ROLLBACK TRANSACTION
		----------------------------------------
		RAISERROR	(@VARMSG, 15, 1)
		RETURN
GO
/****** Object:  StoredProcedure [dbo].[SP_E_ISLA_INSERTAR]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*


[SP_E_ISLA_INSERTAR] '01', '04', 'ISLA 0111', '01','1','admin'
SELECT * FROM E_isla

*/
-----------------------------------------------
-----------------------------------------------
create	PROCEDURE	[dbo].[SP_E_ISLA_INSERTAR]
@CIA					CHAR(2), 
@ID_ISLA				CHAR(2), 
@DESCRIPCION			VARCHAR(100), 
@ID_ESTADO				CHAR(2), 
@FLAG_ENVIO				CHAR(1), 
@UC						VARCHAR(25)
AS
-----------------------------------------------
DECLARE @VARMSG			VARCHAR(MAX)
DECLARE	@COUNT			INT
DECLARE	@FECHA_ACTUAL	DATETIME
----------------------------------------------
SET		@FECHA_ACTUAL	=	GETDATE()
-----------------------------------------------
BEGIN TRANSACTION
	-------------------------------------------
	INSERT	INTO E_ISLA
	(
		CIA, ID_ISLA, DESCRIPCION, ID_ESTADO, FLAG_ENVIO, FC, UC
	)
	VALUES		/*		SELECT * FROM E_ISLA		*/
	(
		@CIA, @ID_ISLA, @DESCRIPCION, @ID_ESTADO, @FLAG_ENVIO, @FECHA_ACTUAL, @UC
	)
	-------------------------------------------
	IF @@ERROR <> 0 OR @@ROWCOUNT <> 1
	BEGIN
		---------------------------------------
		SET		@VARMSG	= 'SE PRODUJO UN ERROR DURANTE EL PROCESO DE GRABACION DE LA ISLA. NO SE GRABARON LOS DATOS.'
		GOTO	MSGERROR
		----------------------------------------
	END 
	ELSE
	BEGIN
		----------------------------------------
		SET	@VARMSG				= 'DATOS GRABADOS.'
	---------------------------------------
	END
COMMIT TRANSACTION
------------------------------------------------
RETURN
MSGERROR:
		ROLLBACK TRANSACTION
		----------------------------------------
		RAISERROR	(@VARMSG, 15, 1)
		RETURN
GO
/****** Object:  StoredProcedure [dbo].[SP_E_MANGUERA_ACTUALIZAR]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
SELECT * FROM E_MANGUERA
SELECT * FROM articulo
SP_E_MANGUERA_ACTUALIZAR '01','02','16','MANGUERA 04','02','04','08','02','PROCOM0000000003','01','1','ADMIN'
*/
-----------------------------------------------
create	PROC	[dbo].[SP_E_MANGUERA_ACTUALIZAR]
@CIA					CHAR(2),	@SEDE					CHAR(2),
@ID_MANGUERA			CHAR(2),	@DESCRIPCION			VARCHAR(100), 
@ID_ISLA				CHAR(2),	@ID_SURTIDOR			CHAR(2),
@ID_CARA				CHAR(2),	@ID_IMPRESORA			char(2),
@ID_ARTICULO			CHAR(255),	@ID_ESTADO				CHAR(2), 
@UM						VARCHAR(25)
AS
-----------------------------------------------
DECLARE @VARMSG			VARCHAR(MAX)
DECLARE	@COUNT			INT
DECLARE	@FECHA_ACTUAL	DATETIME
----------------------------------------------
SET		@FECHA_ACTUAL	=	GETDATE()
-----------------------------------------------
BEGIN TRANSACTION
	-------------------------------------------
	UPDATE	E_MANGUERA
	SET		DESCRIPCION		= @DESCRIPCION, 
			ID_ISLA			= @ID_ISLA,
			ID_SURTIDOR		= @ID_SURTIDOR,
			ID_CARA			= @ID_CARA,
			ID_IMPRESORA	= @ID_IMPRESORA,
			ID_ARTICULO		= @ID_ARTICULO,
			ID_ESTADO		= @ID_ESTADO, 							
			FM				= @FECHA_ACTUAL, 
			UM				= @UM
	WHERE	CIA				= @CIA 
	AND		SEDE			= @SEDE
	AND		ID_MANGUERA		= @ID_MANGUERA 
	-------------------------------------------
	IF @@ERROR <> 0 OR @@ROWCOUNT <> 1
	BEGIN
		---------------------------------------
		SET		@VARMSG	= 'SE PRODUJO UN ERROR DURANTE EL PROCESO DE ACTUALIZAR LA MANGUERA. NO SE ACTUALIZARON LOS DATOS.'
		GOTO	MSGERROR
		----------------------------------------
	END 
	ELSE
	BEGIN
		----------------------------------------
		SET	@VARMSG				= 'DATOS ACTUALIZADOS.'
		
		----------------------------------------
	END
	--------------------------------------------	
COMMIT TRANSACTION
------------------------------------------------
RETURN
MSGERROR:
		ROLLBACK TRANSACTION
		----------------------------------------
		RAISERROR	(@VARMSG, 15, 1)		
		RETURN		---------------------------------------
GO
/****** Object:  StoredProcedure [dbo].[SP_E_MANGUERA_ELIMINAR]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
SELECT * FROM E_MANGUERA
SP_listar_MANGUERA  '01','02'
SP_E_MANGUERA_ELIMINAR '01','02','admin'
*/
-----------------------------------------------
-----------------------------------------------
create	PROCEDURE	[dbo].[SP_E_MANGUERA_ELIMINAR]
@CIA			CHAR(2), @SEDE			CHAR(2),
@ID_MANGUERA	CHAR(2), @UA				VARCHAR(10)--,
--@AA				VARCHAR(60)
AS
-----------------------------------------------
DECLARE @VARMSG			VARCHAR(MAX)
DECLARE	@FECHA_ACTUAL	DATETIME
DECLARE @ID_ESTADO		CHAR(2)
----------------------------------------------
SET		@FECHA_ACTUAL	=	GETDATE()
SET		 @ID_ESTADO		=  '02'	
-----------------------------------------------
/*		INSERTAMOS LOS DATOS EN LA TABLA	*/
BEGIN TRANSACTION
	-------------------------------------------
	UPDATE	E_MANGUERA
	SET		ID_ESTADO	 = @ID_ESTADO,	
			FA			 = @FECHA_ACTUAL, 
			UA			 = @UA--,
		--	AA			 = @AA
	WHERE	CIA			 = @CIA 
	AND		SEDE		 = @SEDE
	AND		ID_MANGUERA  = @ID_MANGUERA
	-------------------------------------------
	IF @@ERROR <> 0 OR @@ROWCOUNT <> 1
	BEGIN
		---------------------------------------
		SET		@VARMSG	= 'SE PRODUJO UN ERROR DURANTE EL PROCESO DE ELIMINACION DE MANGUERA. NO SE ELIMINO EL REGISTRO.'
		GOTO	MSGERROR
		----------------------------------------
	END 
	ELSE
	BEGIN
		----------------------------------------
		SET	@VARMSG	= 'REGISTRO ELIMINADO.'
		----------------------------------------
	END	
COMMIT TRANSACTION
------------------------------------------------
RETURN
MSGERROR:
		ROLLBACK TRANSACTION
		----------------------------------------
		RAISERROR	(@VARMSG, 15, 1)
		RETURN
GO
/****** Object:  StoredProcedure [dbo].[SP_E_MANGUERA_INSERTAR]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*		
SELECT * FROM E_MANGUERA
*/
-----------------------------------------------
create	PROC	[dbo].[SP_E_MANGUERA_INSERTAR]
@CIA					CHAR(2), 
@SEDE					CHAR(2), 
@ID_MANGUERA			CHAR(2),
@DESCRIPCION			VARCHAR(100), 
@ID_ISLA				CHAR(2),
@ID_SURTIDOR			CHAR(2),
@ID_CARA				CHAR(2),
@ID_IMPRESORA			CHAR(2),
@ID_ARTICULO			VARCHAR(100),
@UC						VARCHAR(30)
AS
-----------------------------------------------
declare @varmsg			varchar(max)
declare	@count			int
declare	@fecha_actual	datetime
----------------------------------------------
set		@fecha_actual	=	getdate()
-----------------------------------------------
/*		INSERTAMOS LOS DATOS EN LA TABLA	*/
BEGIN TRANSACTION
	-------------------------------------------
	INSERT	INTO e_manguera
	(
		CIA,SEDE,ID_MANGUERA,DESCRIPCION,ID_ISLA,ID_SURTIDOR,ID_CARA,ID_IMPRESORA,ID_ARTICULO,ID_ESTADO,FLAG_ENVIO,FC,UC
	)
	VALUES		/*		SELECT * FROM E_MANGUERA		*/
	(
		@CIA,@SEDE,@ID_MANGUERA,@DESCRIPCION,@ID_ISLA,@ID_SURTIDOR,@ID_CARA,@ID_IMPRESORA,@ID_ARTICULO,'01','1',@FECHA_ACTUAL,@UC
	)
	-------------------------------------------
	IF @@ERROR <> 0 OR @@ROWCOUNT <> 1
	BEGIN
		---------------------------------------
		SET		@varmsg	= 'SE PRODUJO UN ERROR DURANTE EL PROCESO DE GRABACION DE LA MANGUERA. NO SE GRABARON LOS DATOS.'
		GOTO	msgerror
		----------------------------------------
	END 
	ELSE
	BEGIN
		----------------------------------------
		SET	@varmsg				= 'DATOS GRABADOS.'
		----------------------------------------
	END
	--------------------------------------------
COMMIT TRANSACTION
------------------------------------------------
RETURN
MSGERROR:
		ROLLBACK TRANSACTION
		----------------------------------------
		RAISERROR	(@varmsg, 15, 1)	
		RETURN
GO
/****** Object:  StoredProcedure [dbo].[SP_E_SURTIDOR_ACTUALIZAR]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*

SELECT * FROM E_SURTIDOR

select ES.ID_ESTADO from E_SURTIDOR ES
INNER JOIN estado e ON e.cia=ES.cia and e.id_estado=ES.id_estado 
WHERE ABREVIATURA='IN' AND ID_SURTIDOR='05'
SELECT * FROM ESTADO WHERE ABREVIATURA IN ('AC','IN')
select
*/
-----------------------------------------------
-----------------------------------------------
create	PROCEDURE	[dbo].[SP_E_SURTIDOR_ACTUALIZAR]
@CIA					CHAR(2), 
@ID_SURTIDOR			CHAR(2),  
@DESCRIPCION			VARCHAR(100), 
@ID_ESTADO				CHAR(2), 
@FLAG_ENVIO				CHAR(1), 
@UM						VARCHAR(25)
AS
-----------------------------------------------
DECLARE @VARMSG			VARCHAR(MAX)
DECLARE	@COUNT			INT
--DECLARE @ESTADO			CHAR(2)
----------------------------------------------------------------
--SET		@ESTADO=(select ES.ID_ESTADO from E_SURTIDOR ES
--		INNER JOIN estado e ON e.cia=ES.cia and e.id_estado=ES.id_estado 
--		WHERE ID_SURTIDOR=@ID_SURTIDOR AND ABREVIATURA=@ID_ESTADO )
---------------------------------------------------------------
BEGIN TRANSACTION
	-------------------------------------------
	UPDATE	E_SURTIDOR
		SET	DESCRIPCION			= @DESCRIPCION, 
			ID_ESTADO			= @ID_ESTADO, 
			FLAG_ENVIO			= @FLAG_ENVIO, 					
			FM					= GETDATE(), 
			UM					= @UM
	WHERE	CIA					= @CIA 
	AND		ID_SURTIDOR			= @ID_SURTIDOR 
	-------------------------------------------
	IF @@ERROR <> 0 OR @@ROWCOUNT <> 1
	BEGIN
		---------------------------------------
		SET		@VARMSG	= 'SE PRODUJO UN ERROR DURANTE EL PROCESO DE ACTUALIZAR EL SURTIDOR. NO SE ACTUALIZARON LOS DATOS.'
		GOTO	MSGERROR
		----------------------------------------
	END 
	ELSE
	BEGIN
		----------------------------------------
		SET	@VARMSG				= 'DATOS ACTUALIZADOS.'

		----------------------------------------
	END
	--------------------------------------------
		/*	INSERTAR LAS POLITICAS	*/
	--------------------------------------------
COMMIT TRANSACTION
------------------------------------------------
RETURN
MSGERROR:
		ROLLBACK TRANSACTION
		----------------------------------------
		RAISERROR	(@VARMSG, 15, 1)	
		RETURN
GO
/****** Object:  StoredProcedure [dbo].[SP_E_SURTIDOR_ELIMINAR]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
SELECT id_estado,* FROM E_SURTIDOR
[SP_E_SURTIDOR_ELIMINAR] '01','01','admin'
delete E_SURTIDOR where ID_SURTIDOR in('M1')
select * from E_SURTIDOR
*/
-----------------------------------------------
-----------------------------------------------
create	PROCEDURE	[dbo].[SP_E_SURTIDOR_ELIMINAR]
@CIA			CHAR(2), 
@ID_SURTIDOR	CHAR(2),
@UA				VARCHAR(10)--,
--@AA				VARCHAR(60)
AS
-----------------------------------------------
DECLARE @VARMSG			VARCHAR(MAX)
-----------------------------------------------
/*		INSERTAMOS LOS DATOS EN LA TABLA	*/
BEGIN TRANSACTION
	-------------------------------------------
	UPDATE	E_SURTIDOR
	SET		ID_ESTADO	='02',
			FA			= GETDATE(), 
			UA			= @UA--,
		--	AA			= @AA
	WHERE	CIA			= @CIA 
	AND		ID_SURTIDOR	= @ID_SURTIDOR 
	-------------------------------------------
	IF @@ERROR <> 0 OR @@ROWCOUNT <> 1
	BEGIN
		---------------------------------------
		SET		@VARMSG	= 'SE PRODUJO UN ERROR DURANTE EL PROCESO DE ELIMINACION DEL SURTIDOR. NO SE ELIMINO EL REGISTRO.'
		GOTO	MSGERROR
		----------------------------------------
	END 
	ELSE
	BEGIN
		----------------------------------------
		SET	@VARMSG	= 'REGISTRO ELIMINADO.'
		----------------------------------------
	END	
COMMIT TRANSACTION
------------------------------------------------
RETURN
MSGERROR:
		ROLLBACK TRANSACTION
		----------------------------------------
		RAISERROR	(@VARMSG, 15, 1)
		RETURN
GO
/****** Object:  StoredProcedure [dbo].[SP_E_SURTIDOR_INSERTAR]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*

[SP_E_SURTIDOR_INSERTAR] '01', '07', 'SURTIDOR 0111', '01','1','admin'
SELECT * FROM E_SURTIDOR
DELETE FROM E_SURTIDOR WHERE ID_SURTIDOR IN(10)
*/
-----------------------------------------------
-----------------------------------------------
create	PROCEDURE	[dbo].[SP_E_SURTIDOR_INSERTAR]
@CIA					CHAR(2), 
@ID_SURTIDOR			CHAR(2),
@DESCRIPCION			VARCHAR(100), 
@ID_ESTADO				CHAR(2), 
@FLAG_ENVIO				CHAR(1), 
@UC						VARCHAR(25)
AS
-----------------------------------------------
DECLARE @VARMSG			VARCHAR(MAX)
DECLARE	@COUNT			INT
DECLARE	@FECHA_ACTUAL	DATETIME
----------------------------------------------
SET		@FECHA_ACTUAL	=	GETDATE()
-----------------------------------------------
/*		INSERTAMOS LOS DATOS EN LA TABLA	*/
BEGIN TRANSACTION
	-------------------------------------------
	INSERT	INTO E_SURTIDOR
	(
		CIA,  ID_SURTIDOR,  DESCRIPCION,  ID_ESTADO,  FLAG_ENVIO,  FC,			 UC
	)
	VALUES		/*		SELECT * FROM E_SURTIDOR		*/
	(
		@CIA, @ID_SURTIDOR, @DESCRIPCION, @ID_ESTADO, @FLAG_ENVIO, @FECHA_ACTUAL, @UC
	)
	-------------------------------------------
	IF @@ERROR <> 0 OR @@ROWCOUNT <> 1
	BEGIN
		---------------------------------------
		SET		@VARMSG	= 'SE PRODUJO UN ERROR DURANTE EL PROCESO DE GRABACION DEL SURTIDOR. NO SE GRABARON LOS DATOS.'
		GOTO	MSGERROR
		----------------------------------------
	END 
	ELSE
	BEGIN
		----------------------------------------
		SET	@VARMSG					= 'DATOS GRABADOS.'	
		----------------------------------------
	END
	--------------------------------------------
COMMIT TRANSACTION
------------------------------------------------
RETURN
MSGERROR:
		ROLLBACK TRANSACTION
		----------------------------------------
		RAISERROR	(@VARMSG, 15, 1)
		RETURN
GO
/****** Object:  StoredProcedure [dbo].[SP_E_TURNO_CONTROL_ABRIR_TURNO_MARKET]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*

SELECT * FROM E_TURNO
SELECT * FROM E_SURTIDOR
SELECT * FROM E_TURNO_CONTROL

*/
-------------------------------------------------
-------------------------------------------------
create	PROCEDURE	[dbo].[SP_E_TURNO_CONTROL_ABRIR_TURNO_MARKET]
@CIA			CHAR(2),
@SEDE			CHAR(2),
@ID_SURTIDOR	CHAR(2),
@ID_TURNO		CHAR(2),
@ID_USUARIO		VARCHAR(10),
@MENSAJE_ERROR	VARCHAR(300)OUTPUT
AS
-------------------------------------------------
DECLARE	@COUNT INT
DECLARE	@COUNT_2 INT
DECLARE	@COUNT_3 INT
DECLARE	@COUNT_4 INT
DECLARE	@NRO_TURNO INT
-------------------------------------------------
BEGIN	TRANSACTION
	---------------------------------------------
	SET	@COUNT	=	(SELECT ISNULL((SELECT COUNT(*) FROM E_SURTIDOR WHERE CIA = @CIA AND ID_SURTIDOR = @ID_SURTIDOR AND ID_ESTADO = '01'),0))
	IF(@COUNT <> 1)
	BEGIN
		-----------------------------------------
		SET		@MENSAJE_ERROR = 'Numero de Caja no Existe.'
		-----------------------------------------
	END
	---------------------------------------------
	SET	@COUNT_2	=	(SELECT ISNULL((SELECT COUNT(*) FROM E_TURNO WHERE CIA = @CIA AND ID_TURNO = @ID_TURNO AND ID_ESTADO = '01'),0))
	IF(@COUNT_2 <> 1) 
	BEGIN
		-----------------------------------------
		SET		@MENSAJE_ERROR = 'Turno no Existe.'
		-----------------------------------------
	END
	---------------------------------------------
	SET	@COUNT_3	=	(SELECT ISNULL((SELECT COUNT(*) FROM E_TURNO_CONTROL WHERE CIA = @CIA AND SEDE = @SEDE AND ID_SURTIDOR = @ID_SURTIDOR AND ID_TURNO = @ID_TURNO AND ID_USUARIO <> @ID_USUARIO AND CIERRE IS NULL),0))
	IF(@COUNT_3 > 0) 
	BEGIN
		-----------------------------------------
		SET		@MENSAJE_ERROR = 'La caja: ' + @ID_SURTIDOR + ' ya esta Aperturada por otro Usuario.'
		-----------------------------------------
	END
	---------------------------------------------
	SET	@COUNT_4	=	(SELECT ISNULL((SELECT COUNT(*) FROM E_TURNO_CONTROL WHERE CIA = @CIA AND SEDE = @SEDE AND ID_SURTIDOR = @ID_SURTIDOR AND ID_TURNO <> @ID_TURNO AND ID_USUARIO <> @ID_USUARIO AND CIERRE IS NULL),0))
	IF(@COUNT_4 > 0) 
	BEGIN
		-----------------------------------------
		SET		@MENSAJE_ERROR = 'La caja: ' + @ID_SURTIDOR + ' ya esta Aperturada por otro Usuario.'
		-----------------------------------------
	END
	---------------------------------------------
	IF(@COUNT = 1 AND @COUNT_2 = 1 AND @COUNT_3 = 0 AND @COUNT_4 = 0)
	BEGIN
		-----------------------------------------
		IF(LEFT((CONVERT(VARCHAR(14),GETDATE(),108)),2) >= LEFT((SELECT CONVERT(VARCHAR(10),HORA_INICIO,108) FROM E_TURNO WHERE CIA = @CIA AND ID_TURNO = @ID_TURNO),2))
		BEGIN
			-------------------------------------
			SET	@NRO_TURNO	=	(SELECT ISNULL((SELECT MAX(ID_TURNO_CONTROL) FROM E_TURNO_CONTROL WHERE CIA = @CIA AND SEDE = @SEDE),0)) + 1
			-------------------------------------
			INSERT	INTO	E_TURNO_CONTROL
			(
				CIA, SEDE, ID_TURNO_CONTROL, ID_SURTIDOR, ID_TURNO, ID_USUARIO, APERTURA,ID_ESTADO, FLAG_ENVIO, SE, FE, UE, FC, UC
			)
			VALUES
			(
				@CIA, @SEDE, @NRO_TURNO, @ID_SURTIDOR, @ID_TURNO, @ID_USUARIO, GETDATE(), '01', '1', @SEDE, GETDATE(), @ID_USUARIO, GETDATE(), @ID_USUARIO
			)
			-------------------------------------
			SET @MENSAJE_ERROR = ''
			-------------------------------------
		END
		ELSE
		BEGIN
			-------------------------------------
			SET @MENSAJE_ERROR = 'Error: no se puede Abrir el Turno. Horario de apertura incorrecto.'
			-------------------------------------
		END
		-----------------------------------------
	END
	---------------------------------------------
COMMIT	TRANSACTION
-------------------------------------------------
RETURN
MSGERROR:
		ROLLBACK TRANSACTION
		------------------------------------
		RAISERROR	(@MENSAJE_ERROR, 15, 1)
		RETURN
GO
/****** Object:  StoredProcedure [dbo].[SP_E_TURNO_CONTROL_CERRAR_TURNO_MARKET]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*

SELECT * FROM E_TURNO_CONTROL

DECLARE @MENSAJE_ERROR VARCHAR(100)
EXEC	[SP_E_TURNO_CONTROL_CERRAR_TURNO_MARKET] '01', '01', 'M2', '02', 'ADMIN', @MENSAJE_ERROR OUTPUT
PRINT @MENSAJE_ERROR

*/
------------------------------------------------
------------------------------------------------
create	PROCEDURE	[dbo].[SP_E_TURNO_CONTROL_CERRAR_TURNO_MARKET]
@CIA			CHAR(2),
@SEDE			CHAR(2),
@ID_SURTIDOR	CHAR(2),
@ID_TURNO		CHAR(2),
@ID_USUARIO		VARCHAR(10),
@MENSAJE_ERROR	VARCHAR(300)OUTPUT
AS
------------------------------------------------
DECLARE	@COUNT INT
DECLARE	@COUNT_2 INT
DECLARE	@COUNT_3 INT
DECLARE	@COUNT_4 INT
DECLARE	@CONTROL INT
DECLARE	@NRO_TURNO INT
-------------------------------------------------
BEGIN	TRANSACTION
	---------------------------------------------
	SET	@COUNT	=	(SELECT ISNULL((SELECT COUNT(*) FROM E_SURTIDOR WHERE CIA = @CIA AND ID_SURTIDOR = @ID_SURTIDOR AND ID_ESTADO = '01'),0))
	IF(@COUNT <> 1) 
	BEGIN
		-----------------------------------------
		SET		@MENSAJE_ERROR = 'Numero de Caja no Existe.'
		-----------------------------------------
	END
	---------------------------------------------
	SET	@COUNT_2	=	(SELECT ISNULL((SELECT COUNT(*) FROM E_TURNO WHERE CIA = @CIA AND ID_TURNO = @ID_TURNO AND ID_ESTADO = '01'),0))
	IF(@COUNT_2 <> 1) 
	BEGIN
		-----------------------------------------
		SET		@MENSAJE_ERROR = 'Turno no Existe.'
		-----------------------------------------
	END
	---------------------------------------------
	SET	@COUNT_3	=	(SELECT ISNULL((SELECT COUNT(*) FROM E_TURNO_CONTROL WHERE CIA = @CIA AND SEDE = @SEDE AND ID_SURTIDOR = @ID_SURTIDOR AND ID_TURNO = @ID_TURNO AND ID_USUARIO <> @ID_USUARIO AND NOT CIERRE IS NULL),0))
	IF(@COUNT_3 > 0) 
	BEGIN
		-----------------------------------------
		SET		@MENSAJE_ERROR = 'La caja: ' + @ID_SURTIDOR + ' ya esta Cerrada por otro Usuario.'
		-----------------------------------------
	END
	---------------------------------------------
	SET	@COUNT_4	=	(SELECT ISNULL((SELECT COUNT(*) FROM E_TURNO_CONTROL WHERE CIA = @CIA AND SEDE = @SEDE AND ID_SURTIDOR = @ID_SURTIDOR AND ID_TURNO <> @ID_TURNO AND ID_USUARIO <> @ID_USUARIO AND NOT CIERRE IS NULL),0))
	IF(@COUNT_4 > 0) 
	BEGIN
		-----------------------------------------
		SET		@MENSAJE_ERROR = 'La caja: ' + @ID_SURTIDOR + ' ya esta Cerrada por otro Usuario.'
		-----------------------------------------
	END
	---------------------------------------------
	SET	@CONTROL	=	(SELECT ISNULL((SELECT MAX(ID_TURNO_CONTROL) FROM E_TURNO_CONTROL WHERE CIA = @CIA AND SEDE = @SEDE AND ID_SURTIDOR = @ID_SURTIDOR AND ID_TURNO = @ID_TURNO AND ID_USUARIO = @ID_USUARIO AND CIERRE IS NULL),0))
	IF(@CONTROL = 0)
	BEGIN
		-----------------------------------------
		SET		@MENSAJE_ERROR = 'No se Puede Cerrar Turno Datos Erroneos.'
		-----------------------------------------
	END
	---------------------------------------------
	IF(@COUNT = 1 AND @COUNT_2 = 1 AND @CONTROL <> 0 AND @COUNT_3 = 0 AND @COUNT_4 = 0)
	BEGIN
		-----------------------------------------
		IF(LEFT((CONVERT(VARCHAR(14),GETDATE(),108)),2) >= LEFT((SELECT CONVERT(VARCHAR(10),HORA_FIN,108) FROM E_TURNO WHERE CIA = @CIA AND ID_TURNO = @ID_TURNO),2))
		BEGIN
			-------------------------------------
			UPDATE	E_TURNO_CONTROL
			SET		CIERRE	= GETDATE(),
					FM		= GETDATE(),
					UM		= @ID_USUARIO
			WHERE	CIA				= @CIA
			AND		SEDE			= @SEDE
			AND		ID_TURNO_CONTROL= @CONTROL
			AND		ID_SURTIDOR		= @ID_SURTIDOR
			AND		ID_TURNO		= @ID_TURNO
			AND		ID_USUARIO		= @ID_USUARIO
			-------------------------------------
			SET @MENSAJE_ERROR = CONVERT(VARCHAR(10),@CONTROL)
			-------------------------------------
		END
		ELSE
		BEGIN
			-------------------------------------
			SET @MENSAJE_ERROR = 'Error: no se puede Cerrar el Turno. Horario de cierre incorrecto.'
			-------------------------------------
		END
		-----------------------------------------
	END
	---------------------------------------------
COMMIT	TRANSACTION
-------------------------------------------------
RETURN
MSGERROR:
		ROLLBACK TRANSACTION
		------------------------------------
		RAISERROR	(@MENSAJE_ERROR, 15, 1)
		RETURN
GO
/****** Object:  StoredProcedure [dbo].[SP_E_TURNO_CONTROL_VERIFICAR_APERTURA]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*

SELECT * FROM E_TURNO_CONTROL

EXEC SP_E_TURNO_CONTROL_VERIFICAR_APERTURA '01', '01', 'ADMIN'

*/
----------------------------------------------------
----------------------------------------------------
create	PROCEDURE	[dbo].[SP_E_TURNO_CONTROL_VERIFICAR_APERTURA]
@CIA		CHAR(2),
@SEDE		CHAR(2),
@ID_USUARIO	VARCHAR(10)
AS
----------------------------------------------------
----------------------------------------------------
SELECT	ID_USUARIO 
FROM	E_TURNO_CONTROL
WHERE	CIA			= @CIA
AND		SEDE		= @SEDE
AND		ID_USUARIO	= @ID_USUARIO
AND		CONVERT(VARCHAR(8), APERTURA,112) = CONVERT(VARCHAR(8),GETDATE(),112)
AND		CIERRE IS NULL
GO
/****** Object:  StoredProcedure [dbo].[SP_E_VENTA_DOCUMENTO_Fechas]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[SP_E_VENTA_DOCUMENTO_Fechas] 
@FechaInicial datetime,
@FechaFinal datetime
as
SELECT Edv.Cia, 
		Edv.Sede,
		Edv.Id_Venta,
		Edv.Id_Tipo_Doc,
		Edv.Serie_Doc,
		Edv.Nro_Doc,
		Edv.Ruc, 
		Edv.ID_Cliente
		UE,
		FechaCreacion=convert(varchar(30),FC,103)	
FROM E_VENTA_DOCUMENTO Edv 
where FC between @FechaInicial and @FechaFinal
GO
/****** Object:  StoredProcedure [dbo].[SP_EJECUTAR_EDISPLAY]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create	PROCEDURE [dbo].[SP_EJECUTAR_EDISPLAY]
@VALOR VARCHAR(2)
AS

/*
'ABAJO'
'AUTORIZANDO'
'ESPERANDO'
'CLIENTE'
'DESPACHANDO'
'FINALIZANDO'
'PAUSA'
'AUTORIZANDO'
'ERROR'
*/
IF(@VALOR = '1')
BEGIN
	EXEC	SP_INSERTAR_DATOS_E_DISPLAY '01', 'ABAJO', null, ''
	EXEC	SP_INSERTAR_DATOS_E_DISPLAY '02', 'ABAJO', null, ''
	EXEC	SP_INSERTAR_DATOS_E_DISPLAY '03', 'ABAJO', null, ''
	EXEC	SP_INSERTAR_DATOS_E_DISPLAY '03', 'ABAJO', null, ''
	EXEC	SP_INSERTAR_DATOS_E_DISPLAY '09', 'ABAJO', null, ''
	EXEC	SP_INSERTAR_DATOS_E_DISPLAY '10', 'ABAJO', null, ''
	EXEC	SP_INSERTAR_DATOS_E_DISPLAY '13', 'ABAJO', null, ''
	EXEC	SP_INSERTAR_DATOS_E_DISPLAY '14', 'ABAJO', null, ''
END

IF(@VALOR = '2')
BEGIN
	EXEC	SP_INSERTAR_DATOS_E_DISPLAY '01', 'ESPERANDO', 0, ''
	EXEC	SP_INSERTAR_DATOS_E_DISPLAY '02', 'ESPERANDO', 0, ''
	EXEC	SP_INSERTAR_DATOS_E_DISPLAY '03', 'ESPERANDO', 0, ''
	EXEC	SP_INSERTAR_DATOS_E_DISPLAY '04', 'ESPERANDO', 0, ''
	EXEC	SP_INSERTAR_DATOS_E_DISPLAY '09', 'ESPERANDO', 0, ''
	EXEC	SP_INSERTAR_DATOS_E_DISPLAY '10', 'ESPERANDO', 0, ''
	EXEC	SP_INSERTAR_DATOS_E_DISPLAY '13', 'ESPERANDO', 0, ''
	EXEC	SP_INSERTAR_DATOS_E_DISPLAY '14', 'ESPERANDO', 0, ''
END

IF(@VALOR = '3')
BEGIN
	EXEC	SP_INSERTAR_DATOS_E_DISPLAY '01', 'CLIENTE', 0, 'FDG-174'
	EXEC	SP_INSERTAR_DATOS_E_DISPLAY '02', 'CLIENTE', 0, 'DER-854'
	EXEC	SP_INSERTAR_DATOS_E_DISPLAY '03', 'CLIENTE', 0, 'ÑLK-874'
	EXEC	SP_INSERTAR_DATOS_E_DISPLAY '04', 'CLIENTE', 0, 'QWK-924'
	EXEC	SP_INSERTAR_DATOS_E_DISPLAY '09', 'CLIENTE', 0, 'MNB-530'
	EXEC	SP_INSERTAR_DATOS_E_DISPLAY '10', 'CLIENTE', 0, 'FQI-800'
	EXEC	SP_INSERTAR_DATOS_E_DISPLAY '13', 'CLIENTE', 0, 'EQW-874'
	EXEC	SP_INSERTAR_DATOS_E_DISPLAY '14', 'CLIENTE', 0, 'BVC-831'
END

IF(@VALOR = '4')
BEGIN
	EXEC	SP_INSERTAR_DATOS_E_DISPLAY '01', 'DESPACHANDO', 10, 'FDG-174'
	EXEC	SP_INSERTAR_DATOS_E_DISPLAY '02', 'DESPACHANDO', 5, 'DER-854'
	EXEC	SP_INSERTAR_DATOS_E_DISPLAY '03', 'DESPACHANDO', 2, 'ÑLK-874'
	EXEC	SP_INSERTAR_DATOS_E_DISPLAY '04', 'DESPACHANDO', 1, 'QWK-924'
	EXEC	SP_INSERTAR_DATOS_E_DISPLAY '09', 'DESPACHANDO', 5, 'MNB-530'
	EXEC	SP_INSERTAR_DATOS_E_DISPLAY '10', 'DESPACHANDO', 7, 'FQI-800'
	EXEC	SP_INSERTAR_DATOS_E_DISPLAY '13', 'DESPACHANDO', 10, 'EQW-874'
	EXEC	SP_INSERTAR_DATOS_E_DISPLAY '14', 'DESPACHANDO', 5, 'BVC-831'
END

IF(@VALOR = '5')
BEGIN
	EXEC	SP_INSERTAR_DATOS_E_DISPLAY '01', 'DESPACHANDO', 15, 'FDG-174'
	EXEC	SP_INSERTAR_DATOS_E_DISPLAY '02', 'DESPACHANDO', 10, 'DER-854'
	EXEC	SP_INSERTAR_DATOS_E_DISPLAY '03', 'DESPACHANDO', 4, 'ÑLK-874'
	EXEC	SP_INSERTAR_DATOS_E_DISPLAY '04', 'DESPACHANDO', 4, 'QWK-924'
	EXEC	SP_INSERTAR_DATOS_E_DISPLAY '09', 'DESPACHANDO', 10, 'MNB-530'
	EXEC	SP_INSERTAR_DATOS_E_DISPLAY '10', 'DESPACHANDO', 14, 'FQI-800'
	EXEC	SP_INSERTAR_DATOS_E_DISPLAY '13', 'DESPACHANDO', 20, 'EQW-874'
	EXEC	SP_INSERTAR_DATOS_E_DISPLAY '14', 'DESPACHANDO', 15, 'BVC-831'
END

IF(@VALOR = '6')
BEGIN
	EXEC	SP_INSERTAR_DATOS_E_DISPLAY '01', 'DESPACHANDO', 20, 'FDG-174'
	EXEC	SP_INSERTAR_DATOS_E_DISPLAY '02', 'DESPACHANDO', 15, 'DER-854'
	EXEC	SP_INSERTAR_DATOS_E_DISPLAY '03', 'DESPACHANDO', 6, 'ÑLK-874'
	EXEC	SP_INSERTAR_DATOS_E_DISPLAY '04', 'DESPACHANDO', 8, 'QWK-924'
	EXEC	SP_INSERTAR_DATOS_E_DISPLAY '09', 'DESPACHANDO', 15, 'MNB-530'
	EXEC	SP_INSERTAR_DATOS_E_DISPLAY '10', 'DESPACHANDO', 21, 'FQI-800'
	EXEC	SP_INSERTAR_DATOS_E_DISPLAY '13', 'DESPACHANDO', 30, 'EQW-874'
	EXEC	SP_INSERTAR_DATOS_E_DISPLAY '14', 'DESPACHANDO', 25, 'BVC-831'
END

IF(@VALOR = '7')
BEGIN
	EXEC	SP_INSERTAR_DATOS_E_DISPLAY '01', 'DESPACHANDO', 25, 'FDG-174'
	EXEC	SP_INSERTAR_DATOS_E_DISPLAY '02', 'DESPACHANDO', 20, 'DER-854'
	EXEC	SP_INSERTAR_DATOS_E_DISPLAY '03', 'DESPACHANDO', 8, 'ÑLK-874'
	EXEC	SP_INSERTAR_DATOS_E_DISPLAY '04', 'DESPACHANDO', 12, 'QWK-924'
	EXEC	SP_INSERTAR_DATOS_E_DISPLAY '09', 'DESPACHANDO', 20, 'MNB-530'
	EXEC	SP_INSERTAR_DATOS_E_DISPLAY '10', 'DESPACHANDO', 28, 'FQI-800'
	EXEC	SP_INSERTAR_DATOS_E_DISPLAY '13', 'DESPACHANDO', 40, 'EQW-874'
	EXEC	SP_INSERTAR_DATOS_E_DISPLAY '14', 'DESPACHANDO', 35, 'BVC-831'
END

IF(@VALOR = '8')
BEGIN
	EXEC	SP_INSERTAR_DATOS_E_DISPLAY '01', 'DESPACHANDO', 30, 'FDG-174'
	EXEC	SP_INSERTAR_DATOS_E_DISPLAY '02', 'DESPACHANDO', 25, 'DER-854'
	EXEC	SP_INSERTAR_DATOS_E_DISPLAY '03', 'DESPACHANDO', 10, 'ÑLK-874'
	EXEC	SP_INSERTAR_DATOS_E_DISPLAY '04', 'DESPACHANDO', 14, 'QWK-924'
	EXEC	SP_INSERTAR_DATOS_E_DISPLAY '09', 'DESPACHANDO', 25, 'MNB-530'
	EXEC	SP_INSERTAR_DATOS_E_DISPLAY '10', 'DESPACHANDO', 35, 'FQI-800'
	EXEC	SP_INSERTAR_DATOS_E_DISPLAY '13', 'DESPACHANDO', 50, 'EQW-874'
	EXEC	SP_INSERTAR_DATOS_E_DISPLAY '14', 'DESPACHANDO', 45, 'BVC-831'
END

IF(@VALOR = '9')
BEGIN
	EXEC	SP_INSERTAR_DATOS_E_DISPLAY '01', 'DESPACHANDO', 35, 'FDG-174'
	EXEC	SP_INSERTAR_DATOS_E_DISPLAY '02', 'DESPACHANDO', 30, 'DER-854'
	EXEC	SP_INSERTAR_DATOS_E_DISPLAY '03', 'DESPACHANDO', 12, 'ÑLK-874'
	EXEC	SP_INSERTAR_DATOS_E_DISPLAY '03', 'DESPACHANDO', 18, 'QWK-924'
	EXEC	SP_INSERTAR_DATOS_E_DISPLAY '09', 'DESPACHANDO', 30, 'MNB-530'
	EXEC	SP_INSERTAR_DATOS_E_DISPLAY '10', 'DESPACHANDO', 42, 'FQI-800'
	EXEC	SP_INSERTAR_DATOS_E_DISPLAY '13', 'DESPACHANDO', 60, 'EQW-874'
	EXEC	SP_INSERTAR_DATOS_E_DISPLAY '14', 'DESPACHANDO', 55, 'BVC-831'
END

IF(@VALOR = '10')
BEGIN
	EXEC	SP_INSERTAR_DATOS_E_DISPLAY '01', 'DESPACHANDO', 40, 'FDG-174'
	EXEC	SP_INSERTAR_DATOS_E_DISPLAY '02', 'DESPACHANDO', 35, 'DER-854'
	EXEC	SP_INSERTAR_DATOS_E_DISPLAY '03', 'DESPACHANDO', 14, 'ÑLK-874'
	EXEC	SP_INSERTAR_DATOS_E_DISPLAY '04', 'DESPACHANDO', 22, 'QWK-924'
	EXEC	SP_INSERTAR_DATOS_E_DISPLAY '09', 'DESPACHANDO', 35, 'MNB-530'
	EXEC	SP_INSERTAR_DATOS_E_DISPLAY '10', 'DESPACHANDO', 49, 'FQI-800'
	EXEC	SP_INSERTAR_DATOS_E_DISPLAY '13', 'DESPACHANDO', 70, 'EQW-874'
	EXEC	SP_INSERTAR_DATOS_E_DISPLAY '14', 'DESPACHANDO', 65, 'BVC-831'
END

IF(@VALOR = '11')
BEGIN
	EXEC	SP_INSERTAR_DATOS_E_DISPLAY '01', 'FINALIZANDO', 45, 'FDG-174'
	EXEC	SP_INSERTAR_DATOS_E_DISPLAY '02', 'FINALIZANDO', 40, 'DER-854'
	EXEC	SP_INSERTAR_DATOS_E_DISPLAY '03', 'FINALIZANDO', 16, 'ÑLK-874'
	EXEC	SP_INSERTAR_DATOS_E_DISPLAY '04', 'FINALIZANDO', 26, 'QWK-924'
	EXEC	SP_INSERTAR_DATOS_E_DISPLAY '09', 'FINALIZANDO', 40, 'MNB-530'
	EXEC	SP_INSERTAR_DATOS_E_DISPLAY '10', 'FINALIZANDO', 56, 'FQI-800'
	EXEC	SP_INSERTAR_DATOS_E_DISPLAY '13', 'FINALIZANDO', 80, 'EQW-874'
	EXEC	SP_INSERTAR_DATOS_E_DISPLAY '14', 'FINALIZANDO', 75, 'BVC-831'
END

IF(@VALOR = '12')
BEGIN
	EXEC	SP_INSERTAR_DATOS_E_DISPLAY '01', 'PAUSA', 0, 'FDG-174'
	EXEC	SP_INSERTAR_DATOS_E_DISPLAY '02', 'PAUSA', 0, 'DER-854'
	EXEC	SP_INSERTAR_DATOS_E_DISPLAY '03', 'PAUSA', 0, 'ÑLK-874'
	EXEC	SP_INSERTAR_DATOS_E_DISPLAY '04', 'PAUSA', 0, 'QWK-924'
	EXEC	SP_INSERTAR_DATOS_E_DISPLAY '09', 'PAUSA', 0, 'MNB-530'
	EXEC	SP_INSERTAR_DATOS_E_DISPLAY '10', 'PAUSA', 0, 'FQI-800'
	EXEC	SP_INSERTAR_DATOS_E_DISPLAY '13', 'PAUSA', 0, 'EQW-874'
	EXEC	SP_INSERTAR_DATOS_E_DISPLAY '14', 'PAUSA', 0, 'BVC-831'
END

IF(@VALOR = '13')
BEGIN
	EXEC	SP_INSERTAR_DATOS_E_DISPLAY '01', 'ABAJO', 0, ''
	EXEC	SP_INSERTAR_DATOS_E_DISPLAY '02', 'ABAJO', 0, ''
	EXEC	SP_INSERTAR_DATOS_E_DISPLAY '03', 'ABAJO', 0, ''
	EXEC	SP_INSERTAR_DATOS_E_DISPLAY '04', 'ABAJO', 0, ''
	EXEC	SP_INSERTAR_DATOS_E_DISPLAY '09', 'ABAJO', 0, ''
	EXEC	SP_INSERTAR_DATOS_E_DISPLAY '10', 'ABAJO', 0, ''
	EXEC	SP_INSERTAR_DATOS_E_DISPLAY '13', 'ABAJO', 0, ''
	EXEC	SP_INSERTAR_DATOS_E_DISPLAY '14', 'ABAJO', 0, ''
END

IF(@VALOR = '14')
BEGIN
	EXEC	SP_INSERTAR_DATOS_E_DISPLAY '01', 'AUTORIZANDO', 0, ''
	EXEC	SP_INSERTAR_DATOS_E_DISPLAY '02', 'AUTORIZANDO', 0, ''
	EXEC	SP_INSERTAR_DATOS_E_DISPLAY '03', 'AUTORIZANDO', 0, ''
	EXEC	SP_INSERTAR_DATOS_E_DISPLAY '04', 'AUTORIZANDO', 0, ''
	EXEC	SP_INSERTAR_DATOS_E_DISPLAY '09', 'AUTORIZANDO', 0, ''
	EXEC	SP_INSERTAR_DATOS_E_DISPLAY '10', 'AUTORIZANDO', 0, ''
	EXEC	SP_INSERTAR_DATOS_E_DISPLAY '13', 'AUTORIZANDO', 0, ''
	EXEC	SP_INSERTAR_DATOS_E_DISPLAY '14', 'AUTORIZANDO', 0, ''
END

IF(@VALOR = '15')
BEGIN
	EXEC	SP_INSERTAR_DATOS_E_DISPLAY '01', 'ERROR', 0, ''
	EXEC	SP_INSERTAR_DATOS_E_DISPLAY '02', 'ERROR', 0, ''
	EXEC	SP_INSERTAR_DATOS_E_DISPLAY '03', 'ERROR', 0, ''
	EXEC	SP_INSERTAR_DATOS_E_DISPLAY '04', 'ERROR', 0, ''
	EXEC	SP_INSERTAR_DATOS_E_DISPLAY '09', 'ERROR', 0, ''
	EXEC	SP_INSERTAR_DATOS_E_DISPLAY '10', 'ERROR', 0, ''
	EXEC	SP_INSERTAR_DATOS_E_DISPLAY '13', 'ERROR', 0, ''
	EXEC	SP_INSERTAR_DATOS_E_DISPLAY '14', 'ERROR', 0, ''
END

IF(@VALOR = '16')
BEGIN
	EXEC	SP_INSERTAR_DATOS_E_DISPLAY '01', 'AUTORIZANDO', 0, ''
	EXEC	SP_INSERTAR_DATOS_E_DISPLAY '02', 'AUTORIZANDO', 0, ''
	EXEC	SP_INSERTAR_DATOS_E_DISPLAY '03', 'AUTORIZANDO', 0, ''
	EXEC	SP_INSERTAR_DATOS_E_DISPLAY '04', 'AUTORIZANDO', 0, ''
	EXEC	SP_INSERTAR_DATOS_E_DISPLAY '09', 'AUTORIZANDO', 0, ''
	EXEC	SP_INSERTAR_DATOS_E_DISPLAY '10', 'AUTORIZANDO', 0, ''
	EXEC	SP_INSERTAR_DATOS_E_DISPLAY '13', 'AUTORIZANDO', 0, ''
	EXEC	SP_INSERTAR_DATOS_E_DISPLAY '14', 'AUTORIZANDO', 0, ''
END
GO
/****** Object:  StoredProcedure [dbo].[SP_ESTACIONES_COTIZACION]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SP_ESTACIONES_COTIZACION]
@INDICADOR CHAR(1),@CIA  CHAR(2),@sede char(2),@ID_ANALITICA  VARCHAR(20),@ID_TIPO_DOC CHAR(2),@SERIE_DOC VARCHAR(4),@nro_doc VARCHAR(20)	
AS
--------------------------------------------------------------------------------------------
DECLARE @sSelect varchar(MAX),@sFiltroID varchar(MAX),@sFiltroSerie varchar(MAX),@sFiltroNro varchar(MAX),@sExecute varchar(MAX),@sGroupBy varchar(MAX),@sOrderBy varchar(MAX)
--------------------------------------------------------------------------------------------
SELECT @sSelect='', @sFiltroID='', @sFiltroSerie='',@sFiltroNro='', @sExecute='',@sGroupBy='',@sOrderBy=''
-------------------------------				COTIZACION				-------------------------------
IF(@INDICADOR='1') BEGIN  		--	   SP_ESTACIONES_COTIZACION '1','01','01','20100111838','20','2010','' --20100111838
	SELECT @sSelect=	'tdc.descripcion ''desc_cot'',dgf.id_tipo_doc,dgf.serie_doc,dgf.nro_doc,a.id_analitica,a.descripcion,
	fecha_documento=CONVERT(VARCHAR(10),dgf.fecha_documento,103),fecha_vencimiento=CONVERT(VARCHAR(10),dgf.fecha_vencimiento,103),
	dgf.tipo_cambio,dgf.subtotal,dgf.subtotal_con_dscto,dgf.impuesto,dgf.total,dgf.otros,
	convert(varchar(100), convert(decimal(15,2),dgf.total_final)) +space(2)+ m.abreviatura ''total_final'',dgf.anio,dgf.mes,
	tdf.descripcion ''desc_fac'',dgf.id_tipo_doc_ref,dgf.serie_doc_ref,dgf.nro_doc_ref,dgf.id_moneda,m.descripcion ''desc_moneda'',m.abreviatura,
	e.descripcion ''des_estado'',DGF.id_estado,e.abreviatura 	FROM DOC_GESTION_FA DGF
	left join estado e on e.cia=DGF.cia and e.id_estado=DGF.id_estado
	INNER JOIN analitica a on a.cia=DGF.cia and a.ID_ANALITICA=DGF.id_cliente 
	INNER JOIN analitica_TIPO AT on AT.cia=a.cia and AT.ID_ANALITICA=A.ID_ANALITICA 	
	left join tipo_documento tdc on tdc.cia=DGF.cia and tdc.id_tipo_doc=DGF.id_tipo_doc	
	left join tipo_documento tdf on tdf.cia=dgf.cia and tdf.id_tipo_doc=dgf.id_tipo_doc_ref	
	LEFT JOIN MONEDa m on m.cia=dgf.cia and m.id_moneda =dgf.id_moneda 
	where DGF.cia='''+@CIA+''' and  DGF.sede='''+@sede+''' and at.ID_TIPO_ANALITICA=''01''  AND DGF.ID_TIPO_DOC='''+@ID_TIPO_DOC+'''  and  DGF.id_estado=''03'' '
	 ---------------------------------------------------------------------------------------------
	IF  LEN(ISNULL(@ID_ANALITICA,''))>0 AND  @ID_ANALITICA<>'%' 
			BEGIN    SELECT @sFiltroID	=' and a.ID_ANALITICA in('''+@ID_ANALITICA+''')' 	 END
	ELSE	BEGIN    SELECT @sFiltroID	=''	END			
	---------------------------------------------------------------------------------------------
	IF  LEN(ISNULL(@SERIE_DOC,''))>0 AND  @SERIE_DOC<>'%' 
			BEGIN    SELECT @sFiltroSerie	=' and DGF.SERIE_DOC in('''+@SERIE_DOC+''')' 	 END
	ELSE	BEGIN    SELECT @sFiltroSerie	=''	END		
	-----------------------------------------------------------------------------------------------		 
	IF  LEN(ISNULL(@nro_doc,''))>0 AND  @nro_doc<>'%' 
			BEGIN    SELECT @sFiltroNro	=' and DGF.nro_doc IN ('''+@nro_doc+''')' 	 END
	ELSE	BEGIN    SELECT @sFiltroNro	=''	END		
	-----------------------------------------------------------------------------------------------
	SELECT @sGroupBy=' group by dgf.nro_doc,dgf.serie_doc,dgf.id_tipo_doc,a.id_analitica,a.descripcion,tdc.descripcion,tdF.descripcion,dgf.fecha_documento,
	dgf.fecha_vencimiento,dgf.tipo_cambio,dgf.subtotal,dgf.subtotal_con_dscto,dgf.impuesto,dgf.total,dgf.otros,dgf.total_final,dgf.anio,dgf.mes,
	tdf.descripcion,dgf.id_tipo_doc_ref,dgf.serie_doc_ref,dgf.nro_doc_ref,dgf.id_moneda,m.descripcion,m.abreviatura,e.descripcion,DGF.id_estado,e.abreviatura'
	SELECT @sOrderBy	=' order by  DGF.serie_doc,dgf.nro_doc'	
	---------------------------------------------------------------------------------------------
	SELECT @sExecute = @sSelect +''+ @sFiltroID +''+@sFiltroSerie+''+  @sFiltroNro+''+  @sGroupBy+''+@sOrderBy
 	PRINT @sExecute
	EXEC ('SELECT '+ @sExecute )	 
 	--------------------------------------------------------------------------------------------
end
--------------------------------------------------------------------------------
IF(@INDICADOR='2') BEGIN  --	   SP_ESTACIONES_COTIZACION '2','01','01','','20','2010',''		 --20100111838   	
	SELECT @sSelect=	'DGF.NRO_DOC,DGF.NRO_DOC	FROM analitica A
		INNER JOIN analitica_TIPO AT on AT.cia=a.cia and AT.ID_ANALITICA=A.ID_ANALITICA 
		INNER JOIN DOC_GESTION_FA DGF on DGF.cia=a.cia and DGF.id_cliente=A.ID_ANALITICA 		
		where DGF.cia='''+@CIA+''' and  DGF.sede='''+@sede+''' and at.ID_TIPO_ANALITICA=''01''  AND DGF.ID_TIPO_DOC='''+@ID_TIPO_DOC+'''  and  DGF.id_estado=''03'' '
	 ---------------------------------------------------------------------------------------------
	IF  LEN(ISNULL(@ID_ANALITICA,''))>0 AND  @ID_ANALITICA<>'%' 
			BEGIN    SELECT @sFiltroID	=' and a.ID_ANALITICA in('''+@ID_ANALITICA+''')' 	 END
	ELSE	BEGIN    SELECT @sFiltroID	=''	END		
	---------------------------------------------------------------------------------------------
	IF  LEN(ISNULL(@SERIE_DOC,''))>0 AND  @SERIE_DOC<>'%' 
			BEGIN    SELECT @sFiltroSerie	=' and DGF.SERIE_DOC in('''+@SERIE_DOC+''')' 	 END
	ELSE	BEGIN    SELECT @sFiltroSerie	=''	END		
	-----------------------------------------------------------------------------------------------		 
	IF  LEN(ISNULL(@nro_doc,''))>0 AND  @nro_doc<>'%' 
			BEGIN    SELECT @sFiltroNro	=' and DGF.nro_doc IN ('''+@nro_doc+''')' 	 END
	ELSE	BEGIN    SELECT @sFiltroNro	=''	END		
	-----------------------------------------------------------------------------------------------
	SELECT @sGroupBy	=' group by DGF.NRO_DOC,DGF.NRO_DOC,DGF.serie_doc	 '
	SELECT @sOrderBy	=' order by  DGF.serie_doc'		
	---------------------------------------------------------------------------------------------
	SELECT @sExecute = @sSelect +''+ @sFiltroID +''+@sFiltroSerie+''+  @sGroupBy+''+@sOrderBy
 	PRINT @sExecute
	EXEC ('SELECT '+ @sExecute )	 
	---------------------------------------------------------
END

-------------------				FACTURA		
IF(@INDICADOR='3') BEGIN	--	SP_ESTACIONES_COTIZACION '3','01','01','20100111838','01','0001',''	--20100111838 
	SELECT @sSelect=	'td.descripcion ''desc_fac'',dc.id_tipo_doc,dc.serie_doc,dc.nro_doc,dc.id_cliente,a.descripcion,dc.id_punto_venta,
		fecha_documento=CONVERT(VARCHAR(10),dc.fecha_documento,103),fecha_vencimiento=CONVERT(VARCHAR(10),dc.fecha_vencimiento,103),
		dc.subtotal,dc.subtotal_con_dscto,dc.impuesto,dc.total,dc.otros,
		convert(varchar(100), convert(decimal(15,2),dc.total_final)) +space(2)+ m.abreviatura ''total_final'',		
		dc.deuda,dc.anio,dc.mes,dc.id_estado,dc.id_moneda,m.descripcion ''desc_moneda'',m.abreviatura,
		e.descripcion ''des_estado'',dc.id_estado,e.abreviatura 		FROM documento_cc dc
		left join estado e on e.cia=dc.cia and e.id_estado=dc.id_estado
		INNER JOIN analitica a on a.cia=dc.cia and a.id_analitica=dc.id_cliente 	
		INNER JOIN analitica_TIPO AT on AT.cia=a.cia and AT.ID_ANALITICA=A.ID_ANALITICA 			
		left join tipo_documento td on td.cia=dc.cia and td.id_tipo_doc=dc.id_tipo_doc		
		LEFT JOIN MONEDa m on m.cia=dc.cia and m.id_moneda =dc.id_moneda 
		where dc.cia='''+@CIA+''' and  dc.sede='''+@sede+'''  and at.ID_TIPO_ANALITICA=''01''  AND dc.ID_TIPO_DOC='''+@ID_TIPO_DOC+'''   '
	 -------------------------------------------------------------------------------------------
	IF  LEN(ISNULL(@ID_ANALITICA,''))>0 AND  @ID_ANALITICA<>'%'  -- and dc.id_estado=''13''
			BEGIN    SELECT @sFiltroID	=' and a.ID_ANALITICA in('''+@ID_ANALITICA+''')' 	 END
	ELSE	BEGIN    SELECT @sFiltroID	=''	END		
	-------------------------------------------------------------------------------------------
	IF  LEN(ISNULL(@SERIE_DOC,''))>0 AND  @SERIE_DOC<>'%' 
			BEGIN    SELECT @sFiltroSerie	=' and DC.SERIE_DOC in('''+@SERIE_DOC+''')' 	 END
	ELSE	BEGIN    SELECT @sFiltroSerie	=''	END		
	-----------------------------------------------------------------------------------------------
		IF  LEN(ISNULL(@nro_doc,''))>0 AND  @nro_doc<>'%' 
			BEGIN    SELECT @sFiltroNro	=' and dc.nro_doc IN ('''+@nro_doc+''')' 	 END
	ELSE	BEGIN    SELECT @sFiltroNro	=''	END		
	-----------------------------------------------------------------------------------------------
	SELECT @sGroupBy	=' group by td.descripcion,dc.id_tipo_doc,dc.serie_doc,dc.nro_doc,dc.id_cliente,a.descripcion,dc.id_punto_venta,
		dc.fecha_documento,dc.fecha_vencimiento,dc.subtotal,dc.subtotal_con_dscto,dc.impuesto,dc.total,dc.otros,dc.total_final,dc.deuda,
		dc.anio,dc.mes,dc.id_estado,dc.id_moneda,m.descripcion,m.abreviatura,e.descripcion,dc.id_estado,e.abreviatura  '
	SELECT @sOrderBy	=' order by  dc.NRO_DOC'	
	---------------------------------------------------------------------------------------------
	SELECT @sExecute = @sSelect +''+ @sFiltroID +''+@sFiltroSerie+''+ @sFiltroNro +''+@sGroupBy+''+@sOrderBy
 	PRINT @sExecute
	EXEC ('SELECT '+ @sExecute )	 
 	--------------------------------------------------------------------------------------------
end
--------------------------------------------------------------------------------
IF(@INDICADOR='4') BEGIN
		SELECT @sSelect=	'dc.NRO_DOC,dc.NRO_DOC		FROM analitica A
		INNER JOIN analitica_TIPO AT on AT.cia=a.cia and AT.ID_ANALITICA=A.ID_ANALITICA 
		INNER JOIN documento_cc dc on dc.cia=a.cia and dc.id_cliente=A.ID_ANALITICA 			
		where dc.cia='''+@CIA+''' and  dc.sede='''+@sede+'''  and at.ID_TIPO_ANALITICA=''01''  AND dc.ID_TIPO_DOC='''+@ID_TIPO_DOC+'''   '	
	 ---------------------------------------------------------------------------------------------
	IF  LEN(ISNULL(@ID_ANALITICA,''))>0 AND  @ID_ANALITICA<>'%' 
			BEGIN    SELECT @sFiltroID	=' and a.ID_ANALITICA in('''+@ID_ANALITICA+''')' 	 END
	ELSE	BEGIN    SELECT @sFiltroID	=''	END		
	---------------------------------------------------------------------------------------------
	IF  LEN(ISNULL(@SERIE_DOC,''))>0 AND  @SERIE_DOC<>'%' 
				BEGIN    SELECT @sFiltroSerie	=' and  DC.SERIE_DOC in('''+@SERIE_DOC+''')' 	 END
	ELSE	BEGIN    SELECT @sFiltroSerie	=''	END		
	-----------------------------------------------------------------------------------------------
	SELECT @sGroupBy	=' group by dc.NRO_DOC,dc.SERIE_DOC,a.ID_ANALITICA,a.DESCRIPCION		 '
	SELECT @sOrderBy	=' order by  dc.NRO_DOC'	
	---------------------------------------------------------------------------------------------
	SELECT @sExecute = @sSelect +''+ @sFiltroID +''+@sFiltroSerie+''+  @sGroupBy+''+@sOrderBy
 	PRINT @sExecute
	EXEC ('SELECT '+ @sExecute )	 
 	--------------------------------------------------------------------------------------------
END




-------------------				GUIA 				-------------------------
IF(@INDICADOR='5') BEGIN --	SP_ESTACIONES_COTIZACION '5','01','01','20100111838','30','',''	 --00000231
	SELECT @sSelect='im.id_tipo_doc ''id_tipo_doc_guia'',im.serie_doc ''serie_doc_guia'',im.nro_doc ''nro_doc_guia'',
				dc.id_tipo_doc ''id_tipo_doc_fac'',dc.serie_doc ''serie_doc_fac'',dc.nro_doc ''nro_doc_fac'',dc.id_cliente,a.descripcion,
		fecha_documento=CONVERT(VARCHAR(10),dc.fecha_documento,103),fecha_vencimiento=CONVERT(VARCHAR(10),dc.fecha_vencimiento,103),
		dc.subtotal,dc.subtotal_con_dscto,dc.impuesto,dc.total,dc.otros,dc.total_final,dc.deuda,dc.anio,dc.mes	
		---------		GUIA				---------
		from  INVENTARIO_MOV_DOC_CC_REF 	im	
		--------		GUIA CON FACTURA	---------	
		--LEFT JOIN INVENTARIO_MOV_DOC_CC_REF imd ON imd.cia=im.cia AND  imd.sede=im.sede and 
		--imd.id_tipo_doc=im.id_tipo_doc AND imd.serie_doc=im.serie_doc  AND imd.nro_doc = im.nro_doc					
		---------		FACTURA				---------
		 LEFT JOIN  documento_cc DC	on 	DC.cia=im.cia AND  dc.sede=im.sede and 
		dc.id_tipo_doc=im.id_tipo_doc_ref AND dc.serie_doc=im.serie_doc_ref  AND dc.nro_doc = im.nro_doc_ref		
		INNER JOIN analitica  A on A.cia=dc.cia and A.ID_ANALITICA=DC.id_cliente 	
		INNER JOIN analitica_TIPO AT on AT.cia=a.cia and AT.ID_ANALITICA=A.ID_ANALITICA 				
		where IM.cia='''+@CIA+''' and  IM.sede='''+@sede+''' and at.ID_TIPO_ANALITICA=''01''   AND IM.ID_TIPO_DOC='''+@ID_TIPO_DOC+'''			'
	 ---------------------------------------------------------------------------------------------
	IF  LEN(ISNULL(@ID_ANALITICA,''))>0 AND  @ID_ANALITICA<>'%' 
			BEGIN    SELECT @sFiltroID	=' and a.ID_ANALITICA in('''+@ID_ANALITICA+''')' 	 END
	ELSE	BEGIN    SELECT @sFiltroID	=''	END		
	---------------------------------------------------------------------------------------------
	IF  LEN(ISNULL(@SERIE_DOC,''))>0 AND  @SERIE_DOC<>'%' 
			BEGIN    SELECT @sFiltroSerie	=' AND  IM.SERIE_DOC in('''+@SERIE_DOC+''')' 	 END
	ELSE	BEGIN    SELECT @sFiltroSerie	=''	END		
	-----------------------------------------------------------------------------------------------		 
	IF  LEN(ISNULL(@nro_doc,''))>0 AND  @nro_doc<>'%' 
			BEGIN    SELECT @sFiltroNro	=' and IM.nro_doc IN ('''+@nro_doc+''')' 	 END
	ELSE	BEGIN    SELECT @sFiltroNro	=''	END		
	-----------------------------------------------------------------------------------------------
	SELECT @sOrderBy	=' order by  im.NRO_DOC'	
	---------------------------------------------------------------------------------------------
	SELECT @sExecute = @sSelect +''+ @sFiltroID +''+ @sFiltroSerie+''+@sFiltroNro+''+  @sGroupBy+''+@sOrderBy
 	PRINT @sExecute
	EXEC ('SELECT '+ @sExecute )
 	--------------------------------------------------------------------------------------------
END

--------------------------------------------------------------------------------
IF(@INDICADOR='6') BEGIN

SELECT @sSelect='im.NRO_DOC,im.NRO_DOC					
		---------		GUIA				---------
		from  INVENTARIO_MOV_DOC_CC_REF 	im	
		--------		GUIA CON FACTURA	---------	
		--LEFT JOIN INVENTARIO_MOV_DOC_CC_REF imd ON imd.cia=im.cia AND  imd.sede=im.sede and 
		--imd.id_tipo_doc=im.id_tipo_doc AND imd.serie_doc=im.serie_doc  AND imd.nro_doc = im.nro_doc					
		---------		FACTURA				---------
		 LEFT JOIN  documento_cc DC	on 	DC.cia=im.cia AND  dc.sede=im.sede and 
		dc.id_tipo_doc=im.id_tipo_doc_ref AND dc.serie_doc=im.serie_doc_ref  AND dc.nro_doc = im.nro_doc_ref		
		INNER JOIN analitica  A on A.cia=dc.cia and A.ID_ANALITICA=DC.id_cliente 	
		INNER JOIN analitica_TIPO AT on AT.cia=a.cia and AT.ID_ANALITICA=A.ID_ANALITICA 				
		where IM.cia='''+@CIA+''' and  IM.sede='''+@sede+''' and at.ID_TIPO_ANALITICA=''01''   AND IM.ID_TIPO_DOC='''+@ID_TIPO_DOC+'''			'
	 ---------------------------------------------------------------------------------------------
	IF  LEN(ISNULL(@ID_ANALITICA,''))>0 AND  @ID_ANALITICA<>'%' 
			BEGIN    SELECT @sFiltroID	=' and a.ID_ANALITICA in('''+@ID_ANALITICA+''')' 	 END
	ELSE	BEGIN    SELECT @sFiltroID	=''	END		
	---------------------------------------------------------------------------------------------
	IF  LEN(ISNULL(@SERIE_DOC,''))>0 AND  @SERIE_DOC<>'%' 
			BEGIN    SELECT @sFiltroSerie	=' AND  IM.SERIE_DOC in('''+@SERIE_DOC+''')' 	 END
	ELSE	BEGIN    SELECT @sFiltroSerie	=''	END		
	-----------------------------------------------------------------------------------------------		 
	IF  LEN(ISNULL(@nro_doc,''))>0 AND  @nro_doc<>'%' 
			BEGIN    SELECT @sFiltroNro	=' and IM.nro_doc IN ('''+@nro_doc+''')' 	 END
	ELSE	BEGIN    SELECT @sFiltroNro	=''	END		
	-----------------------------------------------------------------------------------------------
	SELECT @sOrderBy	=' order by  im.NRO_DOC'	
	---------------------------------------------------------------------------------------------
	SELECT @sExecute = @sSelect +''+ @sFiltroID +''+ @sFiltroSerie+''+@sFiltroNro+''+  @sGroupBy+''+@sOrderBy
 	PRINT @sExecute
	EXEC ('SELECT '+ @sExecute )
 	-------------------------------------------------------------------------------------------- 	
end
GO
/****** Object:  StoredProcedure [dbo].[SP_ESTACIONES_COTIZACION_INSERTAR]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*		
DOC_GESTION_FA_REF_DOC_CC – enlaza cotizacion con facturas
DOC_GESTION_FA_REF_INV_MOV – enlaza cotizacion con inventario

sp_help DOC_GESTION_FA_REF_DOC_CC	--	REFERENCES RCIDAT.dbo.DOC_GESTION_FA (CIA, SEDE, ID_TIPO_DOC, SERIE_DOC, NRO_DOC)
									--	REFERENCES RCIDAT.dbo.DOCUMENTO_CC (CIA, SEDE, ID_TIPO_DOC, SERIE_DOC, NRO_DOC)
sp_help DOC_GESTION_FA_REF_INV_MOV	--	REFERENCES RCIDAT.dbo.INVENTARIO_MOV (CIA, SEDE, ID_TIPO_DOC, SERIE_DOC, NRO_DOC)
									--	REFERENCES RCIDAT.dbo.INVENTARIO_MOV (CIA, SEDE, ID_TIPO_DOC, SERIE_DOC, NRO_DOC)


SELECT * FROM  DOC_GESTION_FA WHERE CIA='01' AND SEDE='01'  AND ID_TIPO_DOC='20' AND SERIE_DOC='2011'--and nro_doc='00000268'
SELECT * FROM INVENTARIO_MOV  WHERE CIA='01' AND SEDE='01' AND ID_TIPO_DOC='30' and nro_doc='00002436'
SELECT ID_TIPO_DOC_REF,* FROM INVENTARIO_MOV  WHERE CIA='01' AND SEDE='01' AND ID_TIPO_DOC='30' ORDER BY ID_TIPO_DOC_REF DESC
SELECT * FROM DOCUMENTO_CC  WHERE CIA='01' AND SEDE='01' AND ID_TIPO_DOC='01' and serie_doc='0001' and nro_doc='00003110'
ORDER BY ID_TIPO_DOC_REF DESC

SELECT * FROM  DOC_GESTION_FA WHERE CIA='01' AND SEDE='01'  AND ID_TIPO_DOC='20'  and id_cliente='20127765279'
sp_help DOC_GESTION_FA_REF_DOC_CC
sp_help DOC_GESTION_FA_REF_INV_MOV

SELECT * FROM DOC_GESTION_FA_REF_DOC_CC		--->	20-01
SELECT * FROM DOC_GESTION_FA_REF_INV_MOV	--->	20-30	
TRUNCATE TABLE DOC_GESTION_FA_REF_DOC_CC
TRUNCATE TABLE DOC_GESTION_FA_REF_INV_MOV

SP_ESTACIONES_COTIZACION_INSERTAR '1','01','01','20','2010','00000696', '01','0001','00002918','SISTEMAS', '30','0001','00002436'
SP_ESTACIONES_COTIZACION_INSERTAR '01','01','20','2010','00000696', '01','0001','00002918','SISTEMAS', '','',''
*/
-----------------------------------------------
CREATE	PROC	[dbo].[SP_ESTACIONES_COTIZACION_INSERTAR]
	@INDICADOR CHAR(1),@CIA CHAR(2),@SEDE CHAR(2),@ID_TIPO_DOC CHAR(2),@SERIE_DOC VARCHAR(4),@NRO_DOC varchar(20),
	@ID_TIPO_DOC_FAC CHAR(2),@SERIE_DOC_FAC VARCHAR(4),@NRO_DOC_FAC varchar(20),@UC VARCHAR(30),
	@ID_TIPO_DOC_GR CHAR(2),@SERIE_DOC_GR  VARCHAR(4),@NRO_DOC_GR  varchar(20)
AS
DECLARE @VARMSG VARCHAR(MAX),@COUNT INT
-----------------------------------------------
BEGIN TRANSACTION
	-------------------------------------------
	IF(@INDICADOR='1')BEGIN			--	GRABAR  FACURA Y GUIA
			INSERT	INTO DOC_GESTION_FA_REF_DOC_CC
			(	CIA,SEDE,ID_TIPO_DOC,SERIE_DOC,NRO_DOC,ID_TIPO_DOC_REF,SERIE_DOC_REF,NRO_DOC_REF,ID_ESTADO,FLAG_ENVIO,LOTE_ENVIO,FC,UC	)
			VALUES		
			(	@CIA,@SEDE,@ID_TIPO_DOC,@SERIE_DOC,@NRO_DOC,@ID_TIPO_DOC_FAC,@SERIE_DOC_FAC,@NRO_DOC_FAC,'01','1','1',GETDATE(),@UC			)
			-------------------------------------------
			IF @@ERROR <> 0 OR @@ROWCOUNT <> 1	BEGIN
				---------------------------------------
				SET		@varmsg	= 'SE PRODUJO UN ERROR DURANTE EL PROCESO DE GRABACION DE LA DOC_GESTION_FA_REF_DOC_CC. NO SE GRABARON LOS DATOS.'
				GOTO	msgerror
				----------------------------------------
			END 
			INSERT	INTO DOC_GESTION_FA_REF_INV_MOV
			(	CIA,SEDE,ID_TIPO_DOC,SERIE_DOC,NRO_DOC,ID_TIPO_DOC_REF,SERIE_DOC_REF,NRO_DOC_REF,ID_ESTADO,FLAG_ENVIO,LOTE_ENVIO,FC,UC	)
			VALUES		
			(	@CIA,@SEDE,@ID_TIPO_DOC,@SERIE_DOC,@NRO_DOC,@ID_TIPO_DOC_GR,@SERIE_DOC_GR,@NRO_DOC_GR,'01','1','1',GETDATE(),@UC	)
			-------------------------------------------
			IF @@ERROR <> 0 OR @@ROWCOUNT <> 1	BEGIN
				---------------------------------------
				SET		@varmsg	= 'SE PRODUJO UN ERROR DURANTE EL PROCESO DE GRABACION DE LA DOC_GESTION_FA_REF_INV_MOV. NO SE GRABARON LOS DATOS.'
				GOTO	msgerror
				----------------------------------------
			END 		
	END
	----------------------------------------------------------------------------------------
	IF(@INDICADOR='2')BEGIN			--	GRABAR SOLO FACURA
			INSERT	INTO DOC_GESTION_FA_REF_DOC_CC
			(	CIA,SEDE,ID_TIPO_DOC,SERIE_DOC,NRO_DOC,ID_TIPO_DOC_REF,SERIE_DOC_REF,NRO_DOC_REF,ID_ESTADO,FLAG_ENVIO,LOTE_ENVIO,FC,UC	)
			VALUES		
			(	@CIA,@SEDE,@ID_TIPO_DOC,@SERIE_DOC,@NRO_DOC,@ID_TIPO_DOC_FAC,@SERIE_DOC_FAC,@NRO_DOC_FAC,'01','1','1',GETDATE(),@UC			)
			-------------------------------------------
			IF @@ERROR <> 0 OR @@ROWCOUNT <> 1	BEGIN
				---------------------------------------
				SET		@varmsg	= 'SE PRODUJO UN ERROR DURANTE EL PROCESO DE GRABACION DE LA DOC_GESTION_FA_REF_DOC_CC. NO SE GRABARON LOS DATOS.'
				GOTO	msgerror
				----------------------------------------
			END 
	END
	----------------------------------------------------------------------------------------
	IF(@INDICADOR='3')BEGIN			--	GRABAR SOLO GUIA
			INSERT	INTO DOC_GESTION_FA_REF_INV_MOV
			(	CIA,SEDE,ID_TIPO_DOC,SERIE_DOC,NRO_DOC,ID_TIPO_DOC_REF,SERIE_DOC_REF,NRO_DOC_REF,ID_ESTADO,FLAG_ENVIO,LOTE_ENVIO,FC,UC	)
			VALUES		
			(	@CIA,@SEDE,@ID_TIPO_DOC,@SERIE_DOC,@NRO_DOC,@ID_TIPO_DOC_GR,@SERIE_DOC_GR,@NRO_DOC_GR,'01','1','1',GETDATE(),@UC	)
			-------------------------------------------
			IF @@ERROR <> 0 OR @@ROWCOUNT <> 1	BEGIN
				---------------------------------------
				SET		@varmsg	= 'SE PRODUJO UN ERROR DURANTE EL PROCESO DE GRABACION DE LA DOC_GESTION_FA_REF_INV_MOV. NO SE GRABARON LOS DATOS.'
				GOTO	msgerror
				----------------------------------------
			END 
	END
COMMIT TRANSACTION
------------------------------------------------
RETURN
MSGERROR:
		ROLLBACK TRANSACTION
		----------------------------------------
		RAISERROR	(@varmsg, 15, 1)	
		RETURN
GO
/****** Object:  StoredProcedure [dbo].[SP_ESTACIONES_COTIZACION_LISTAR]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
SELECT * FROM DOC_GESTION_FA_REF_DOC_CC		--->	20-01
SELECT * FROM DOC_GESTION_FA_REF_INV_MOV	--->	20-30	
TRUNCATE TABLE DOC_GESTION_FA_REF_DOC_CC
TRUNCATE TABLE DOC_GESTION_FA_REF_INV_MOV
[SP_ESTACIONES_COTIZACION_LISTAR] '1','01','01','20','','','','','','','','','',''							
GO
[SP_ESTACIONES_COTIZACION_LISTAR] '2','01','01','20','','','','','','','','','',''
go
[SP_ESTACIONES_COTIZACION_LISTAR] '3','01','01','20','2010','00000696','01','0001','00000201','30','0001','00000597','',''	
GO
[SP_ESTACIONES_COTIZACION_LISTAR] '4','01','01','20','','','','','','','','','',''
*/
CREATE PROC [dbo].[SP_ESTACIONES_COTIZACION_LISTAR]
@INDICADOR CHAR(1),@CIA  CHAR(2),@sede CHAR(2),@ID_TIPO_DOC CHAR(2),@SERIE_DOC CHAR(4),@NRO_DOC  VARCHAR(20),
	@ID_TIPO_DOC_FAC CHAR(2),@SERIE_DOC_FAC CHAR(4),@NRO_DOC_FAC  VARCHAR(20),
	@ID_TIPO_DOC_GUIA CHAR(2),@SERIE_DOC_GUIA CHAR(4),@NRO_DOC_GUIA  VARCHAR(20),@FEC1 datetime,@FEC2 datetime
AS
--------------------------------------------------------------------------------------------
DECLARE @sSelect varchar(MAX),@sFiltroID varchar(MAX),@sFiltroSerie varchar(MAX),@sExecute varchar(MAX),@sGroupBy varchar(MAX),@sOrderBy varchar(MAX),
		@sFecha1 varchar(8),@sFecha2 varchar(8),@sFiltroFecha varchar(MAX)
--------------------------------------------------------------------------------------------
SET @sFecha1 = CONVERT(VARCHAR(8),@FEC1,112)
SET @sFecha2 = CONVERT(VARCHAR(8),@FEC2,112)
--------------------------------------------------------------------------------------------
SELECT @sSelect='', @sFiltroID='',  @sExecute='',@sGroupBy='',@sOrderBy='',@sFiltroFecha=''
-----------------------------------------------------------------------------------------------------------------
IF(@INDICADOR='1') BEGIN	--	COTIZACION	FACTURA
	SELECT @sSelect='dgf.id_tipo_doc,dgf.serie_doc,dgf.nro_doc,dgf.SERIE_DOC + ''-'' + dgf.nro_doc ''numero-doc'',	
		dgf.id_tipo_doc_ref,dgf.serie_doc_ref,dgf.nro_doc_ref,dgf.SERIE_DOC_ref + ''-'' + dgf.nro_doc_ref ''numero-doc_ref'',
		dgf.id_estado,e.abreviatura ''estado'',e.descripcion ''desc_estado'',fc=CONVERT(VARCHAR(10),dgf.fc,103)+space(2)+convert(char(5),dgf.fc, 114),
		dgf.uc,tdc.descripcion ''desc_cot'',tdf.descripcion ''desc_fac''	 from  doc_gestion_fa_ref_doc_cc dgf	
	 INNER JOIN ESTADO E ON E.CIA=dgf.CIA AND E.ID_ESTADO=dgf.ID_ESTADO
	 left join tipo_documento tdc on tdc.cia=dgf.cia and tdc.id_tipo_doc=dgf.id_tipo_doc
	 left join tipo_documento tdf on tdf.cia=dgf.cia and tdf.id_tipo_doc=dgf.id_tipo_doc_ref
	where dgf.cia='''+@CIA+'''  AND dgf.sede='''+@sede+''' AND dgf.ID_TIPO_DOC='''+@ID_TIPO_DOC+'''  '
	 ---------------------------------------------------------------------------------------------
	IF  LEN(ISNULL(@SERIE_DOC,''))>0 AND  @SERIE_DOC<>'%' BEGIN
					 SELECT @sFiltroSerie	=' and dgf.SERIE_DOC in('''+@SERIE_DOC+''')' 	 END
	ELSE	BEGIN    SELECT @sFiltroSerie	=''	END			
	 ---------------------------------------------------------------------------------------------
	IF  LEN(ISNULL(@NRO_DOC,''))>0 AND  @NRO_DOC<>'%' 
			BEGIN    SELECT @sFiltroID	=' and dgf.NRO_DOC in('''+@NRO_DOC+''')' 	 END
	ELSE	BEGIN    SELECT @sFiltroID	=''	END		
	-----------------------------------------------------------------------------------------------
	IF  ISNULL(@sFecha1,'19000101') <> '19000101'  AND  ISNULL(@sFecha2,'19000101') <> '19000101'
			BEGIN 	SELECT @sFiltroFecha=' and convert(varchar(8),dgf.fc,112) between  '''+@sFecha1+'''  and  '''+@sFecha2+''''	END
	ELSE	BEGIN  	SELECT @sFiltroFecha	=''		END	
	--------------------------------------------------------------------------------------------
	SELECT @sOrderBy	=' order by  dgf.FC DESC'	
	---------------------------------------------------------------------------------------------
	SELECT @sExecute = @sSelect +''+ @sFiltroID +''+ @sFiltroSerie +''+ @sFiltroFecha+''+@sGroupBy+''+@sOrderBy
 	PRINT @sExecute
	EXEC ('SELECT '+ @sExecute )	 
 	--------------------------------------------------------------------------------------------
END
-----------------------------------------------------------------------------------------------------------------
IF(@INDICADOR='2') BEGIN	--	COTIZACION	GUIA
	SELECT @sSelect='dgf.id_tipo_doc,dgf.serie_doc,dgf.nro_doc,dgf.SERIE_DOC + ''-'' + dgf.nro_doc ''numero-doc'',	
		dgf.id_tipo_doc_ref,dgf.serie_doc_ref,dgf.nro_doc_ref,dgf.SERIE_DOC_ref + ''-'' + dgf.nro_doc_ref ''numero-doc_ref'',
		dgf.id_estado,e.abreviatura ''estado'',e.descripcion ''desc_estado'',fc=CONVERT(VARCHAR(10),dgf.fc,103)+space(2)+convert(char(5),dgf.fc, 114),
		dgf.uc,tdc.descripcion ''desc_cot'',tdf.descripcion ''desc_guia'' from  doc_gestion_fa_ref_inv_mov dgf	
	 INNER JOIN ESTADO E ON E.CIA=dgf.CIA AND E.ID_ESTADO=dgf.ID_ESTADO
	 left join tipo_documento tdc on tdc.cia=dgf.cia and tdc.id_tipo_doc=dgf.id_tipo_doc
	 left join tipo_documento tdf on tdf.cia=dgf.cia and tdf.id_tipo_doc=dgf.id_tipo_doc_ref
	where dgf.cia='''+@CIA+'''  AND dgf.sede='''+@sede+''' AND dgf.ID_TIPO_DOC='''+@ID_TIPO_DOC+'''  '
	 ---------------------------------------------------------------------------------------------
	IF  LEN(ISNULL(@SERIE_DOC,''))>0 AND  @SERIE_DOC<>'%' BEGIN
					 SELECT @sFiltroSerie	=' and dgf.SERIE_DOC in('''+@SERIE_DOC+''')' 	 END
	ELSE	BEGIN    SELECT @sFiltroSerie	=''	END			
	 ---------------------------------------------------------------------------------------------
	IF  LEN(ISNULL(@NRO_DOC,''))>0 AND  @NRO_DOC<>'%' 
			BEGIN    SELECT @sFiltroID	=' and dgf.NRO_DOC in('''+@NRO_DOC+''')' 	 END
	ELSE	BEGIN    SELECT @sFiltroID	=''	END		
	-----------------------------------------------------------------------------------------------
	IF  ISNULL(@sFecha1,'19000101') <> '19000101'  AND  ISNULL(@sFecha2,'19000101') <> '19000101'
			BEGIN 	SELECT @sFiltroFecha=' and convert(varchar(8),dgf.fc,112) between  '''+@sFecha1+'''  and  '''+@sFecha2+''''	END
	ELSE	BEGIN  	SELECT @sFiltroFecha	=''		END	
	--------------------------------------------------------------------------------------------
	SELECT @sOrderBy	=' order by  dgf.FC DESC'	
	---------------------------------------------------------------------------------------------
	SELECT @sExecute = @sSelect +''+ @sFiltroID +''+ @sFiltroSerie  +''+ @sFiltroFecha+''+@sGroupBy+''+@sOrderBy
 	PRINT @sExecute
	EXEC ('SELECT '+ @sExecute )	 
 	--------------------------------------------------------------------------------------------
END
-----------------------------------------------------------------------------------------------------------------
IF(@INDICADOR='3')BEGIN  --	VALIDAR COTIZACION FACTURA 
	SELECT @sSelect='dgf.id_tipo_doc,dgf.serie_doc,dgf.nro_doc,dgf.SERIE_DOC + ''-'' + dgf.nro_doc ''numero-doc'',	
		dgf.id_tipo_doc_ref,dgf.serie_doc_ref,dgf.nro_doc_ref,dgf.SERIE_DOC_ref + ''-'' + dgf.nro_doc_ref ''numero-doc_ref'',
		dgf.id_estado,e.abreviatura ''estado'',e.descripcion ''desc_estado'',
		fc=CONVERT(VARCHAR(10),dgf.fc,103),dgf.uc,tdc.descripcion ''desc_cot'',tdf.descripcion ''desc_fac''	 from  doc_gestion_fa_ref_doc_cc dgf	
	 INNER JOIN ESTADO E ON E.CIA=dgf.CIA AND E.ID_ESTADO=dgf.ID_ESTADO
	 left join tipo_documento tdc on tdc.cia=dgf.cia and tdc.id_tipo_doc=dgf.id_tipo_doc
	 left join tipo_documento tdf on tdf.cia=dgf.cia and tdf.id_tipo_doc=dgf.id_tipo_doc_ref
	where dgf.cia='''+@CIA+'''  AND dgf.sede='''+@sede+''' AND dgf.ID_TIPO_DOC='''+@ID_TIPO_DOC+'''  
	and dgf.SERIE_DOC ='''+@SERIE_DOC+''' AND dgf.NRO_DOC ='''+@NRO_DOC+''' 
	AND dgf.ID_TIPO_DOC_REF='''+@ID_TIPO_DOC_FAC+'''  and dgf.SERIE_DOC_REF ='''+@SERIE_DOC_FAC+''' AND dgf.NRO_DOC_REF ='''+@NRO_DOC_FAC+'''  '	
	-----------------------------------------------------------------------------------------------
	SELECT @sOrderBy	=' order by  dgf.NRO_DOC'	
	---------------------------------------------------------------------------------------------
	SELECT @sExecute = @sSelect +''+ @sOrderBy
 	PRINT @sExecute
	EXEC ('SELECT '+ @sExecute )	 
 	--------------------------------------------------------------------------------------------
END
-----------------------------------------------------------------------------------------------------------------
IF(@INDICADOR='4') BEGIN	--	VALIDAR COTIZACION  GUIA
	SELECT @sSelect='dgf.id_tipo_doc,dgf.serie_doc,dgf.nro_doc,dgf.SERIE_DOC + ''-'' + dgf.nro_doc ''numero-doc'',	
		dgf.id_tipo_doc_ref,dgf.serie_doc_ref,dgf.nro_doc_ref,dgf.SERIE_DOC_ref + ''-'' + dgf.nro_doc_ref ''numero-doc_ref'',
		dgf.id_estado,e.abreviatura ''estado'',e.descripcion ''desc_estado'',fc=CONVERT(VARCHAR(10),dgf.fc,103),
		dgf.uc,tdc.descripcion ''desc_cot'',tdf.descripcion ''desc_guia'' from  doc_gestion_fa_ref_inv_mov dgf	
	 INNER JOIN ESTADO E ON E.CIA=dgf.CIA AND E.ID_ESTADO=dgf.ID_ESTADO
	 left join tipo_documento tdc on tdc.cia=dgf.cia and tdc.id_tipo_doc=dgf.id_tipo_doc
	 left join tipo_documento tdf on tdf.cia=dgf.cia and tdf.id_tipo_doc=dgf.id_tipo_doc_ref
	where dgf.cia='''+@CIA+'''  AND dgf.sede='''+@sede+''' AND dgf.ID_TIPO_DOC='''+@ID_TIPO_DOC+'''  
	and dgf.SERIE_DOC ='''+@SERIE_DOC+''' AND dgf.NRO_DOC ='''+@NRO_DOC+''' 
	AND dgf.ID_TIPO_DOC_REF='''+@ID_TIPO_DOC_GUIA+'''  and dgf.SERIE_DOC_REF ='''+@SERIE_DOC_GUIA+''' AND dgf.NRO_DOC_REF ='''+@NRO_DOC_GUIA+''''	
	SELECT @sOrderBy	=' order by  dgf.NRO_DOC'	
	---------------------------------------------------------------------------------------------
	SELECT @sExecute = @sSelect +''+ @sOrderBy
 	PRINT @sExecute
	EXEC ('SELECT '+ @sExecute )	 
 	--------------------------------------------------------------------------------------------
END
GO
/****** Object:  StoredProcedure [dbo].[SP_ESTACIONES_PUNTO_VENTA_INSERTAR]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*		
SP_HELP PUNTO_VENTA
SELECT * FROM PUNTO_VENTA WHERE  ID_CLIENTE  LIKE '1010'+'%'
SELECT * FROM PUNTO_VENTA WHERE FLAG_ITF='1' 

_ESTACIONES_COTIZACION_INSERTAR '01','01','20','2010','00000696', '01','0001','00002918','SISTEMAS', '','',''
*/
-----------------------------------------------
CREATE	PROC	[dbo].[SP_ESTACIONES_PUNTO_VENTA_INSERTAR]
	@INDICADOR CHAR(1),@CIA CHAR(2),@ID_CLIENTE VARCHAR(20),@ID_PUNTO_VENTA VARCHAR(20),@DESCRIPCION VARCHAR(100),@ID_VENDEDOR varchar(20),
	@ID_ZONA CHAR(3) ,@ID_PAIS VARCHAR(3) ,@ID_DPTO CHAR(2) ,@ID_PROVINCIA CHAR(2),@ID_DISTRITO CHAR(2),@ID_TIPO_VIA CHAR(2),@NOMBRE_VIA VARCHAR(60) ,
	@ID_TIPO_ZONA VARCHAR(20) ,@NOMBRE_ZONA VARCHAR(60) ,@NRO_DIRECCION VARCHAR(10) ,@INTERIOR_DIRECCION VARCHAR(10) ,@REFERENCIA_ZONA VARCHAR(60) ,
	@DIRECCION VARCHAR(300) ,@TELEFONO VARCHAR(30) ,@ID_ESTADO CHAR(2) ,@FLAG_DEFAULT CHAR(1) ,@SE CHAR(2) ,@UC VARCHAR(10),
	@FLAG_ITF CHAR(1) ,	@NRO_EXPEDIENTE VARCHAR(20) ,@FECHA_SOLICITUD DATETIME ,@FECHA_INI_CONSTRUCCION DATETIME ,@FECHA_INI_OPERACION DATETIME ,
	@REPRESENTANTE VARCHAR(100),@SUPERVISOR VARCHAR(100) ,@OBSERVACION VARCHAR(1000),@RESOLUCION_ITF VARCHAR(100) ,@NRO_MANGUERAS INT ,@EMP_INSTALADORAS VARCHAR(100)
AS
	DECLARE @VARMSG VARCHAR(MAX),@COUNT INT
-----------------------------------------------
BEGIN TRANSACTION
	-------------------------------------------
	IF(@INDICADOR='1')BEGIN			
		INSERT	INTO PUNTO_VENTA
		(	
			CIA,ID_CLIENTE,ID_PUNTO_VENTA,DESCRIPCION,ID_VENDEDOR,ID_ZONA,ID_PAIS,ID_DPTO,ID_PROVINCIA,ID_DISTRITO,ID_TIPO_VIA,NOMBRE_VIA,
			ID_TIPO_ZONA,NOMBRE_ZONA,NRO_DIRECCION,INTERIOR_DIRECCION,REFERENCIA_ZONA,DIRECCION,TELEFONO,ID_ESTADO,FLAG_DEFAULT,FLAG_ENVIO,
			SE,FC,UC,FLAG_ITF,NRO_EXPEDIENTE,FECHA_SOLICITUD,FECHA_INI_CONSTRUCCION,FECHA_INI_OPERACION,REPRESENTANTE,SUPERVISOR,OBSERVACION,
			RESOLUCION_ITF,	NRO_MANGUERAS,EMP_INSTALADORAS	
		)
		VALUES		
		(
			@CIA,@ID_CLIENTE,@ID_PUNTO_VENTA,@DESCRIPCION,@ID_VENDEDOR,@ID_ZONA,@ID_PAIS,@ID_DPTO,@ID_PROVINCIA,@ID_DISTRITO,@ID_TIPO_VIA,@NOMBRE_VIA,
			@ID_TIPO_ZONA,@NOMBRE_ZONA,@NRO_DIRECCION,@INTERIOR_DIRECCION,@REFERENCIA_ZONA,@DIRECCION,@TELEFONO,'01',@FLAG_DEFAULT,'1',
			@SE,GETDATE(),@UC,@FLAG_ITF,@NRO_EXPEDIENTE,@FECHA_SOLICITUD,@FECHA_INI_CONSTRUCCION,@FECHA_INI_OPERACION,@REPRESENTANTE,@SUPERVISOR,
			@OBSERVACION,@RESOLUCION_ITF,@NRO_MANGUERAS,@EMP_INSTALADORAS
		)
		-------------------------------------------
		IF @@ERROR <> 0 OR @@ROWCOUNT <> 1	BEGIN
			---------------------------------------
			SET		@varmsg	= 'SE PRODUJO UN ERROR DURANTE EL PROCESO DE GRABACION DE LA DOC_GESTION_FA_REF_DOC_CC. NO SE GRABARON LOS DATOS.'
			GOTO	msgerror
			----------------------------------------
		END 			
	END
COMMIT TRANSACTION
------------------------------------------------
RETURN
MSGERROR:
		ROLLBACK TRANSACTION
		----------------------------------------
		RAISERROR	(@varmsg, 15, 1)	
		RETURN
GO
/****** Object:  StoredProcedure [dbo].[SP_ESTACIONES_PUNTO_VENTA_LISTAR]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
SP_HELP PUNTO_VENTA
SELECT * FROM PUNTO_VENTA

SP_ESTACIONES_PUNTO_VENTA_LISTAR '1','01','',''
SP_ESTACIONES_PUNTO_VENTA_LISTAR '2','01','',''
SP_ESTACIONES_PUNTO_VENTA_LISTAR '3','01','',''
*/
CREATE PROC [dbo].[SP_ESTACIONES_PUNTO_VENTA_LISTAR]
@INDICADOR CHAR(1),@CIA CHAR(2),@ID_ANALITICA VARCHAR(20),@DESCRIPCION CHAR(20)
AS
--------------------------------------------------------------------------------
IF(@INDICADOR='1')BEGIN
	select LTRIM(id_cliente)'id_cliente',id_punto_venta,descripcion,id_vendedor,id_zona,id_pais,
	id_dpto,id_provincia,id_distrito,id_tipo_via,nombre_via,id_tipo_zona,nombre_zona,nro_direccion,
    interior_direccion,referencia_zona,direccion,telefono,id_estado,se,uc,
    CONVERT(VARCHAR(10),fc,103)'fc',flag_itf,nro_expediente,fecha_solicitud,fecha_ini_construccion,fecha_ini_operacion,
    supervisor,observacion,resolucion_itf,nro_mangueras,emp_instaladoras
    FROM PUNTO_VENTA WHERE CIA=@CIA --AND  FC=GETDATE()
     ORDER BY id_cliente
END
--------------------------------------------------------------------------------
IF(@INDICADOR='2')BEGIN
	select LTRIM(id_cliente)'id_cliente',nro_expediente,CONVERT(VARCHAR(10),fecha_ini_construccion,103)'fecha_ini',
	direccion,id_distrito,representante,telefono,supervisor,observacion	
    FROM PUNTO_VENTA WHERE CIA=@CIA AND  FC=GETDATE()
     ORDER BY id_cliente
END
--------------------------------------------------------------------------------
IF(@INDICADOR='3')BEGIN
	select LTRIM(id_cliente)'id_cliente',nro_expediente,CONVERT(VARCHAR(10),fecha_ini_construccion,103)'fecha_ini',
	direccion,id_distrito,representante,telefono,supervisor,observacion	
    FROM PUNTO_VENTA WHERE CIA=@CIA AND  FC=GETDATE() AND (ID_CLIENTE IS NULL) 
     ORDER BY id_cliente
END
--------------------------------------------------------------------------------
GO
/****** Object:  StoredProcedure [dbo].[SP_F_CAMPANIA_ACTUALIZAR]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*

SELECT * FROM F_CAMPANIA

DECLARE @ID_CAMPANIA_OUT VARCHAR(300)
EXEC [SP_F_CAMPANIA_ACTUALIZAR] '2241f79c-43d0-42f4-9ef4-4a94a473fc3f', '01', 2, 'CAMPAÑA DEL MES DE SETIEMBRE', 
'01/09/2010', '30/09/2010','0',2,'0','01','1','02/09/2010','ADMIN', @ID_CAMPANIA_OUT OUTPUT
PRINT @ID_CAMPANIA_OUT


*/
-----------------------------------------------
-----------------------------------------------
create	PROCEDURE	[dbo].[SP_F_CAMPANIA_ACTUALIZAR]
@SESION					VARCHAR(100),
@CIA					CHAR(2), 
@ID_CAMPANIA			INT, 
@DESCRIPCION			VARCHAR(100), 
@FECHA_VIGENCIA_DEL		VARCHAR(25), 
@FECHA_VIGENCIA_AL		VARCHAR(25), 
@FLAG_MONTO				CHAR(1), 
@MINIMO_DIAS_VISITA		INT, 
@FLAG_FRASE_GANADORA	CHAR(1),
@ID_ESTADO				CHAR(2), 
@FLAG_ENVIO				CHAR(1),
@FM						VARCHAR(25), 
@UM						VARCHAR(10),
@ID_CAMPANIA_OUT		VARCHAR(300)OUTPUT
AS
-----------------------------------------------
DECLARE	@FECHA_INI		DATETIME
DECLARE	@FECHA_FIN		DATETIME
DECLARE	@FECHA_FM		DATETIME
DECLARE	@COUNT			INT
-----------------------------------------------
IF((SELECT ISDATE(@FECHA_VIGENCIA_DEL)) = 1) BEGIN SET @FECHA_INI = CONVERT(DATETIME,@FECHA_VIGENCIA_DEL) END ELSE BEGIN SET @FECHA_INI  = NULL END
IF((SELECT ISDATE(@FECHA_VIGENCIA_AL)) = 1) BEGIN SET @FECHA_FIN = CONVERT(DATETIME,@FECHA_VIGENCIA_AL) END ELSE BEGIN SET @FECHA_FIN = NULL END
-----------------------------------------------
/*		INSERTAMOS LOS DATOS EN LA TABLA	*/
BEGIN TRANSACTION
	-------------------------------------------
	UPDATE	F_CAMPANIA
	SET		DESCRIPCION			= @DESCRIPCION, 
			FECHA_VIGENCIA_DEL	= @FECHA_INI, 
			FECHA_VIGENCIA_AL	= @FECHA_FIN, 
			FLAG_MONTO			= @FLAG_MONTO,			
			MINIMO_DIAS_VISITA	= @MINIMO_DIAS_VISITA, 
			FLAG_FRASE_GANADORA	= @FLAG_FRASE_GANADORA, 
			ID_ESTADO			= @ID_ESTADO, 
			FLAG_ENVIO			= @FLAG_ENVIO, 
			FM					= GETDATE(), 
			UM					= @UM
	WHERE	CIA					= @CIA 
	AND		ID_CAMPANIA			= @ID_CAMPANIA 
	-------------------------------------------
	IF @@ERROR <> 0 OR @@ROWCOUNT <> 1
	BEGIN
		---------------------------------------
		SET		@ID_CAMPANIA_OUT	= 'SE PRODUJO UN ERROR DURANTE EL PROCESO DE ACTUALIZAR LA CAMPAÑA. NO SE ACTUALIZARON LOS DATOS.'
		GOTO	MSGERROR
		----------------------------------------
	END 
	ELSE
	BEGIN
		----------------------------------------
		SET	@ID_CAMPANIA_OUT				= 'DATOS ACTUALIZADOS.'
		SET	@ID_CAMPANIA_OUT	= @ID_CAMPANIA
		----------------------------------------
	END
	--------------------------------------------
		/*	INSERTAR LAS POLITICAS	*/
	IF(@FLAG_FRASE_GANADORA = 0)
	BEGIN
		----------------------------------------
		DELETE	FROM F_CAMPANIA_POLITICA_PUNTO
		WHERE	CIA			= @CIA
		AND		ID_CAMPANIA	= @ID_CAMPANIA
		----------------------------------------
		SET	@COUNT =	(
						SELECT ISNULL((	SELECT	COUNT(*)
										FROM	F_CAMPANIA_POLITICA_TEMP
										WHERE	SESION	= @SESION
										AND		CIA		= @CIA
										AND		MODO	= 0),0)
						)
		----------------------------------------
		INSERT INTO  F_CAMPANIA_POLITICA_PUNTO
		(
			CIA, ID_CAMPANIA, ITEM, SEDE, ID_CATEGORIA, ID_CLIENTE, ID_ARTICULO, FLAG_L, FLAG_K, FLAG_M, FLAG_J, FLAG_V, 
			FLAG_S, FLAG_D, FECHA_DEL, FECHA_AL, HORA_DEL, HORA_AL, CANTIDAD, ID_ESTADO, FLAG_ENVIO, LOTE_ENVIO, SE, FE, 
			UE, FC, UC, FM, UM, FA, UA, AA
		)
		SELECT	CIA, ID_CAMPANIA, ITEM, SEDE, ID_CATEGORIA, ID_CLIENTE, ID_ARTICULO, FLAG_L, FLAG_K, FLAG_M, FLAG_J, FLAG_V, 
				FLAG_S, FLAG_D, FECHA_DEL, FECHA_AL, HORA_DEL, HORA_AL, CONVERT(FLOAT,CANTIDAD), ID_ESTADO, FLAG_ENVIO, LOTE_ENVIO, SE, FE, 
				UE, FC, UC, FM, UM, FA, UA, AA
		FROM	F_CAMPANIA_POLITICA_TEMP
		WHERE	SESION	= @SESION
		AND		CIA		= @CIA
		AND		MODO	= 0
		----------------------------------------
		IF @@ERROR <> 0 OR @@ROWCOUNT < @COUNT
		BEGIN
			---------------------------------------
			SET		@ID_CAMPANIA_OUT	= 'SE PRODUJO UN ERROR DURANTE EL PROCESO DE ACTUALIZACION DE LA CAMPAÑA. NO SE GRABARON LOS DATOS.'
			GOTO	MSGERROR
			----------------------------------------
		END 
		----------------------------------------
	END
	ELSE
	BEGIN
		----------------------------------------
		DELETE	FROM F_CAMPANIA_POLITICA_FRASE
		WHERE	CIA			= @CIA
		AND		ID_CAMPANIA	= @ID_CAMPANIA
		----------------------------------------
		SET	@COUNT =	(
						SELECT ISNULL((	SELECT	COUNT(*)
										FROM	F_CAMPANIA_POLITICA_TEMP
										WHERE	SESION	= @SESION
										AND		CIA		= @CIA
										AND		MODO	= 1),0)
						)
		----------------------------------------
		INSERT INTO  F_CAMPANIA_POLITICA_FRASE
		(
			CIA, ID_CAMPANIA, ITEM, SEDE, ID_CATEGORIA, ID_CLIENTE, ID_ARTICULO, FLAG_L, FLAG_K, FLAG_M, FLAG_J, FLAG_V, 
			FLAG_S, FLAG_D, FECHA_DEL, FECHA_AL, HORA_DEL, HORA_AL, LETRAS, ID_ESTADO, FLAG_ENVIO, LOTE_ENVIO, SE, FE, 
			UE, FC, UC, FM, UM, FA, UA, AA
		)
		SELECT	CIA, ID_CAMPANIA, ITEM, SEDE, ID_CATEGORIA, ID_CLIENTE, ID_ARTICULO, FLAG_L, FLAG_K, FLAG_M, FLAG_J, FLAG_V, 
				FLAG_S, FLAG_D, FECHA_DEL, FECHA_AL, HORA_DEL, HORA_AL, CANTIDAD, ID_ESTADO, FLAG_ENVIO, LOTE_ENVIO, SE, FE, 
				UE, FC, UC, FM, UM, FA, UA, AA
		FROM	F_CAMPANIA_POLITICA_TEMP
		WHERE	SESION	= @SESION
		AND		CIA		= @CIA
		AND		MODO	= 1
		----------------------------------------
		IF @@ERROR <> 0 OR @@ROWCOUNT < @COUNT
		BEGIN
			------------------------------------
			SET		@ID_CAMPANIA_OUT	= 'SE PRODUJO UN ERROR DURANTE EL PROCESO DE ACTUALIZACION DE LA CAMPAÑA. NO SE GRABARON LOS DATOS.'
			GOTO	MSGERROR
			------------------------------------
		END 
		----------------------------------------
	END
	--------------------------------------------
	DELETE	FROM F_CAMPANIA_PREMIO
	WHERE	CIA			= @CIA
	AND		ID_CAMPANIA	= @ID_CAMPANIA
	--------------------------------------------
	SET	@COUNT =(
					SELECT ISNULL((	
						SELECT	COUNT(*)
						FROM	F_CAMPANIA_PREMIO_TEMP
						WHERE	SESION	= @SESION
						AND		CIA		= @CIA),0)
				)
	--------------------------------------------
	INSERT INTO	F_CAMPANIA_PREMIO
	(
		CIA, ID_CAMPANIA, ITEM, ID_ARTICULO, CANTIDAD, TOTAL_PUNTOS, FRASE_GANADORA, ID_ESTADO, FLAG_ENVIO, LOTE_ENVIO, 
		SE, FE, UE, FC, UC, FM, UM, FA, UA, AA
	)
	SELECT	CIA, ID_CAMPANIA, ITEM, ID_ARTICULO, CANTIDAD, TOTAL_PUNTOS, FRASE_GANADORA, ID_ESTADO, FLAG_ENVIO, LOTE_ENVIO, 
			SE, FE, UE, FC, UC, FM, UM, FA, UA, AA
	FROM	F_CAMPANIA_PREMIO_TEMP
	WHERE	SESION	= @SESION
	AND		CIA		= @CIA
	--------------------------------------------
	IF @@ERROR <> 0 OR @@ROWCOUNT < @COUNT
	BEGIN
		---------------------------------------
		SET		@ID_CAMPANIA_OUT	= 'SE PRODUJO UN ERROR DURANTE EL PROCESO DE ACTUALIZACION DE LA CAMPAÑA. NO SE GRABARON LOS DATOS.'
		GOTO	MSGERROR
		----------------------------------------
	END
	--------------------------------------------
COMMIT TRANSACTION
------------------------------------------------
RETURN
MSGERROR:
		ROLLBACK TRANSACTION
		----------------------------------------
		RAISERROR	(@ID_CAMPANIA_OUT, 15, 1)
		SET			@ID_CAMPANIA_OUT = ''
		RETURN
GO
/****** Object:  StoredProcedure [dbo].[SP_F_CAMPANIA_BORRAR_TEMPORALES]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*



*/
---------------------------------------------------
---------------------------------------------------
create	PROCEDURE	[dbo].[SP_F_CAMPANIA_BORRAR_TEMPORALES]
@SESION		VARCHAR(100),
@CIA		CHAR(2)
AS
---------------------------------------------------
---------------------------------------------------
DELETE	FROM	F_CAMPANIA_POLITICA_TEMP
WHERE	SESION	= @SESION
AND		CIA		= @CIA

DELETE	FROM	F_CAMPANIA_PREMIO_TEMP
WHERE	SESION	= @SESION
AND		CIA		= @CIA
GO
/****** Object:  StoredProcedure [dbo].[SP_F_CAMPANIA_ELIMINAR]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*

SELECT * FROM F_CAMPANIA

*/
-----------------------------------------------
-----------------------------------------------
create	PROCEDURE	[dbo].[SP_F_CAMPANIA_ELIMINAR]
@CIA			CHAR(2), 
@ID_CAMPANIA	INT,
@ID_ESTADO		CHAR(2),
@FLAG_ENVIO		CHAR(1),
@FA				VARCHAR(25),
@UA				VARCHAR(10),
@AA				VARCHAR(60)
AS
-----------------------------------------------
DECLARE @VARMSG			VARCHAR(MAX)
DECLARE	@FECHA_FA		DATETIME
-----------------------------------------------
SET	@FECHA_FA = CONVERT(DATETIME,LEFT(@FA,10))
-----------------------------------------------
/*		INSERTAMOS LOS DATOS EN LA TABLA	*/
BEGIN TRANSACTION
	-------------------------------------------
	UPDATE	F_CAMPANIA
	SET		ID_ESTADO	= @ID_ESTADO,
			FLAG_ENVIO	= @FLAG_ENVIO,
			FA			= @FECHA_FA,
			UA			= @UA,
			AA			= @AA
	WHERE	CIA			= @CIA 
	AND		ID_CAMPANIA	= @ID_CAMPANIA 
	-------------------------------------------
	IF @@ERROR <> 0 OR @@ROWCOUNT <> 1
	BEGIN
		---------------------------------------
		SET		@VARMSG	= 'SE PRODUJO UN ERROR DURANTE EL PROCESO DE ELIMINACION DE LA CAMPAÑA. NO SE ELIMINO EL REGISTRO.'
		GOTO	MSGERROR
		----------------------------------------
	END 
	ELSE
	BEGIN
		----------------------------------------
		SET	@VARMSG	= 'REGISTRO ELIMINADO.'
		----------------------------------------
	END
	--------------------------------------------
	UPDATE	F_CAMPANIA_POLITICA_PUNTO
	SET		ID_ESTADO	= @ID_ESTADO,
			FLAG_ENVIO	= @FLAG_ENVIO,
			FA			= @FECHA_FA,
			UA			= @UA,
			AA			= @AA
	WHERE	CIA			= @CIA
	AND		ID_CAMPANIA	= @ID_CAMPANIA
	--------------------------------------------
	UPDATE	F_CAMPANIA_POLITICA_FRASE
	SET		ID_ESTADO	= @ID_ESTADO,
			FLAG_ENVIO	= @FLAG_ENVIO,
			FA			= @FECHA_FA,
			UA			= @UA,
			AA			= @AA
	WHERE	CIA			= @CIA
	AND		ID_CAMPANIA	= @ID_CAMPANIA
	--------------------------------------------
	UPDATE	F_CAMPANIA_PREMIO
	SET		ID_ESTADO	= @ID_ESTADO,
			FLAG_ENVIO	= @FLAG_ENVIO,
			FA			= @FECHA_FA,
			UA			= @UA,
			AA			= @AA		
	WHERE	CIA			= @CIA
	AND		ID_CAMPANIA	= @ID_CAMPANIA
	--------------------------------------------
COMMIT TRANSACTION
------------------------------------------------
RETURN
MSGERROR:
		ROLLBACK TRANSACTION
		----------------------------------------
		RAISERROR	(@VARMSG, 15, 1)
		RETURN
GO
/****** Object:  StoredProcedure [dbo].[SP_F_CAMPANIA_INSERTAR]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*

SELECT * FROM F_CAMPANIA

SELECT * FROM ACCESO

Date = {01/12/2010 12:00:00 a.m.}

EXEC [SP_F_CAMPANIA_INSERTAR] '01', 0, 'DSFDSFDSFDSFD', '01/07/2010 12:00:00 a.m.', '01/08/2010 12:00:00 a.m.','1',2,'1','01','1','ADMIN',''

*/
-----------------------------------------------
-----------------------------------------------
create	PROCEDURE	[dbo].[SP_F_CAMPANIA_INSERTAR]
@SESION					VARCHAR(100),
@CIA					CHAR(2), 
@ID_CAMPANIA			INT, 
@DESCRIPCION			VARCHAR(100), 
@FECHA_VIGENCIA_DEL		VARCHAR(25), 
@FECHA_VIGENCIA_AL		VARCHAR(25), 
@FLAG_MONTO				CHAR(1), 
@MINIMO_DIAS_VISITA		INT, 
@FLAG_FRASE_GANADORA	CHAR(1),
@ID_ESTADO				CHAR(2), 
@FLAG_ENVIO				CHAR(1),  
@UC						VARCHAR(10), 
@ID_CAMPANIA_OUT		VARCHAR(MAX)OUTPUT
AS
-----------------------------------------------
DECLARE @VARMSG			VARCHAR(MAX)
DECLARE	@FECHA_INI		DATETIME
DECLARE	@FECHA_FIN		DATETIME
DECLARE	@COUNT			INT
-----------------------------------------------
IF((SELECT ISDATE(@FECHA_VIGENCIA_DEL)) = 1) BEGIN SET @FECHA_INI = CONVERT(DATETIME,@FECHA_VIGENCIA_DEL) END ELSE BEGIN SET @FECHA_INI  = NULL END
IF((SELECT ISDATE(@FECHA_VIGENCIA_AL)) = 1) BEGIN SET @FECHA_FIN = CONVERT(DATETIME,@FECHA_VIGENCIA_AL) END ELSE BEGIN SET @FECHA_FIN = NULL END
-----------------------------------------------
/*		INSERTAMOS LOS DATOS EN LA TABLA	*/
BEGIN TRANSACTION
	-------------------------------------------
	SET	@ID_CAMPANIA =	(
							SELECT ISNULL((	SELECT	max(id_campania)
											FROM	F_CAMPANIA
											WHERE	1 = 1
											AND		cia = @CIA),0)
						)
	-------------------------------------------
	IF	(@ID_CAMPANIA = 0)
	BEGIN
		---------------------------------------
		SET	@ID_CAMPANIA = 1
		---------------------------------------
	END
	ELSE
	BEGIN
		---------------------------------------
		SET	@ID_CAMPANIA = @ID_CAMPANIA + 1
		---------------------------------------
	END
	-------------------------------------------
	INSERT	INTO F_CAMPANIA
	(
		CIA, ID_CAMPANIA, DESCRIPCION, FECHA_VIGENCIA_DEL, FECHA_VIGENCIA_AL, FLAG_MONTO, MINIMO_DIAS_VISITA, 
		FLAG_FRASE_GANADORA, ID_ESTADO, FLAG_ENVIO, FC, UC
	)
	VALUES
	(
		@CIA, @ID_CAMPANIA, @DESCRIPCION, @FECHA_INI, @FECHA_FIN, @FLAG_MONTO, @MINIMO_DIAS_VISITA, 
		@FLAG_FRASE_GANADORA, @ID_ESTADO, @FLAG_ENVIO, GETDATE(), @UC
	)
	-------------------------------------------
	IF @@ERROR <> 0 OR @@ROWCOUNT <> 1
	BEGIN
		---------------------------------------
		SET		@VARMSG	= 'SE PRODUJO UN ERROR DURANTE EL PROCESO DE GRABACION DE LA CAMPAÑA. NO SE GRABARON LOS DATOS.'
		GOTO	MSGERROR
		----------------------------------------
	END 
	ELSE
	BEGIN
		----------------------------------------
		SET	@VARMSG				= 'DATOS GRABADOS.'
		SET	@ID_CAMPANIA_OUT	= @ID_CAMPANIA
		----------------------------------------
	END
	--------------------------------------------
	/*	INSERTAR LAS POLITICAS	*/
	IF(@FLAG_FRASE_GANADORA = 0)
	BEGIN
		----------------------------------------
		SET	@COUNT =	(
						SELECT ISNULL((	SELECT	COUNT(*)
										FROM	F_CAMPANIA_POLITICA_TEMP
										WHERE	SESION	= @SESION
										AND		CIA		= @CIA
										AND		MODO	= 0),0)
						)
		----------------------------------------
		INSERT INTO  F_CAMPANIA_POLITICA_PUNTO
		(
			CIA, ID_CAMPANIA, ITEM, SEDE, ID_CATEGORIA, ID_CLIENTE, ID_ARTICULO, FLAG_L, FLAG_K, FLAG_M, FLAG_J, FLAG_V, 
			FLAG_S, FLAG_D, FECHA_DEL, FECHA_AL, HORA_DEL, HORA_AL, CANTIDAD, ID_ESTADO, FLAG_ENVIO, LOTE_ENVIO, SE, FE, 
			UE, FC, UC, FM, UM, FA, UA, AA
		)
		SELECT	CIA, @ID_CAMPANIA, ITEM, SEDE, ID_CATEGORIA, ID_CLIENTE, ID_ARTICULO, FLAG_L, FLAG_K, FLAG_M, FLAG_J, FLAG_V, 
				FLAG_S, FLAG_D, FECHA_DEL, FECHA_AL, HORA_DEL, HORA_AL, CONVERT(FLOAT,CANTIDAD), ID_ESTADO, FLAG_ENVIO, LOTE_ENVIO, SE, FE, 
				UE, FC, UC, FM, UM, FA, UA, AA
		FROM	F_CAMPANIA_POLITICA_TEMP
		WHERE	SESION	= @SESION
		AND		CIA		= @CIA
		AND		MODO	= 0
		----------------------------------------
		IF @@ERROR <> 0 OR @@ROWCOUNT < @COUNT
		BEGIN
			---------------------------------------
			SET		@VARMSG	= 'SE PRODUJO UN ERROR DURANTE EL PROCESO DE GRABACION DE LA CAMPAÑA. NO SE GRABARON LOS DATOS.'
			GOTO	MSGERROR
			----------------------------------------
		END 
		----------------------------------------
	END
	ELSE
	BEGIN
		----------------------------------------
		SET	@COUNT =	(
						SELECT ISNULL((	SELECT	COUNT(*)
										FROM	F_CAMPANIA_POLITICA_TEMP
										WHERE	SESION	= @SESION
										AND		CIA		= @CIA
										AND		MODO	= 1),0)
						)
		----------------------------------------
		INSERT INTO  F_CAMPANIA_POLITICA_FRASE
		(
			CIA, ID_CAMPANIA, ITEM, SEDE, ID_CATEGORIA, ID_CLIENTE, ID_ARTICULO, FLAG_L, FLAG_K, FLAG_M, FLAG_J, FLAG_V, 
			FLAG_S, FLAG_D, FECHA_DEL, FECHA_AL, HORA_DEL, HORA_AL, LETRAS, ID_ESTADO, FLAG_ENVIO, LOTE_ENVIO, SE, FE, 
			UE, FC, UC, FM, UM, FA, UA, AA
		)
		SELECT	CIA, @ID_CAMPANIA, ITEM, SEDE, ID_CATEGORIA, ID_CLIENTE, ID_ARTICULO, FLAG_L, FLAG_K, FLAG_M, FLAG_J, FLAG_V, 
				FLAG_S, FLAG_D, FECHA_DEL, FECHA_AL, HORA_DEL, HORA_AL, CANTIDAD, ID_ESTADO, FLAG_ENVIO, LOTE_ENVIO, SE, FE, 
				UE, FC, UC, FM, UM, FA, UA, AA
		FROM	F_CAMPANIA_POLITICA_TEMP
		WHERE	SESION	= @SESION
		AND		CIA		= @CIA
		AND		MODO	= 1
		----------------------------------------
		IF @@ERROR <> 0 OR @@ROWCOUNT < @COUNT
		BEGIN
			---------------------------------------
			SET		@VARMSG	= 'SE PRODUJO UN ERROR DURANTE EL PROCESO DE GRABACION DE LA CAMPAÑA. NO SE GRABARON LOS DATOS.'
			GOTO	MSGERROR
			----------------------------------------
		END 
		----------------------------------------
	END
	--------------------------------------------
	SET	@COUNT =(
					SELECT ISNULL((	
						SELECT	COUNT(*)
						FROM	F_CAMPANIA_PREMIO_TEMP
						WHERE	SESION	= @SESION
						AND		CIA		= @CIA),0)
				)
	--------------------------------------------
	INSERT INTO	F_CAMPANIA_PREMIO
	(
		CIA, ID_CAMPANIA, ITEM, ID_ARTICULO, CANTIDAD, TOTAL_PUNTOS, FRASE_GANADORA, ID_ESTADO, FLAG_ENVIO, LOTE_ENVIO, 
		SE, FE, UE, FC, UC, FM, UM, FA, UA, AA
	)
	SELECT	CIA, @ID_CAMPANIA, ITEM, ID_ARTICULO, CANTIDAD, TOTAL_PUNTOS, FRASE_GANADORA, ID_ESTADO, FLAG_ENVIO, LOTE_ENVIO, 
			SE, FE, UE, FC, UC, FM, UM, FA, UA, AA
	FROM	F_CAMPANIA_PREMIO_TEMP
	WHERE	SESION	= @SESION
	AND		CIA		= @CIA
	--------------------------------------------
	IF @@ERROR <> 0 OR @@ROWCOUNT < @COUNT
	BEGIN
		---------------------------------------
		SET		@VARMSG	= 'SE PRODUJO UN ERROR DURANTE EL PROCESO DE GRABACION DE LA CAMPAÑA. NO SE GRABARON LOS DATOS.'
		GOTO	MSGERROR
		----------------------------------------
	END
	--------------------------------------------
COMMIT TRANSACTION
------------------------------------------------
RETURN
MSGERROR:
		ROLLBACK TRANSACTION
		----------------------------------------
		RAISERROR	(@VARMSG, 15, 1)
		SET			@ID_CAMPANIA_OUT = ''
		RETURN
GO
/****** Object:  StoredProcedure [dbo].[SP_F_CAMPANIA_POLITICA_BUSCAR_ARTICULO]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*

SELECT * FROM ARTICULO

DECLARE	@DESCRIPCION VARCHAR(MAX)
EXEC	SP_F_CAMPANIA_POLITICA_BUSCAR_ARTICULO '01', 'PROLUB0000000007', @DESCRIPCION OUTPUT
PRINT @DESCRIPCION

*/
--------------------------------------
--------------------------------------
create	PROCEDURE	[dbo].[SP_F_CAMPANIA_POLITICA_BUSCAR_ARTICULO]
@CIA			CHAR(2),
@ID_ARTICULO	VARCHAR(MAX),
@DESCRIPCION	VARCHAR(MAX) OUTPUT
AS
--------------------------------------
--------------------------------------
SET	@DESCRIPCION	=	(
							SELECT ISNULL ((SELECT	DESCRIPCION FROM ARTICULO
							WHERE	CIA				= @CIA
							AND		ID_ARTICULO		= @ID_ARTICULO),'')
						)
GO
/****** Object:  StoredProcedure [dbo].[SP_F_CAMPANIA_POLITICA_BUSCAR_CATEGORIA]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*

SELECT * FROM CATEGORIA_ANALITICA

DECLARE	@DESCRIPCION VARCHAR(MAX)
EXEC	SP_F_CAMPANIA_POLITICA_BUSCAR_CATEGORIA '01', '02', @DESCRIPCION OUTPUT
PRINT @DESCRIPCION

*/
--------------------------------------
--------------------------------------
create	PROCEDURE	[dbo].[SP_F_CAMPANIA_POLITICA_BUSCAR_CATEGORIA]
@CIA			CHAR(2),
@ID_CATEGORIA	CHAR(2),
@DESCRIPCION	VARCHAR(MAX) OUTPUT
AS
--------------------------------------
--------------------------------------
SET	@DESCRIPCION	=	(
							SELECT ISNULL ((SELECT	DESCRIPCION FROM CATEGORIA_ANALITICA
							WHERE	CIA				= @CIA
							AND		ID_CATEGORIA	= @ID_CATEGORIA),'')
						)
GO
/****** Object:  StoredProcedure [dbo].[SP_F_CAMPANIA_POLITICA_BUSCAR_CLIENTE]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*

SELECT * FROM ANALITICA

DECLARE	@DESCRIPCION VARCHAR(MAX)
EXEC	SP_F_CAMPANIA_POLITICA_BUSCAR_CLIENTE '01', '10036816690', @DESCRIPCION OUTPUT
PRINT @DESCRIPCION

*/
--------------------------------------
--------------------------------------
create	PROCEDURE	[dbo].[SP_F_CAMPANIA_POLITICA_BUSCAR_CLIENTE]
@CIA			CHAR(2),
@ID_CLIENTE		VARCHAR(MAX),
@DESCRIPCION	VARCHAR(MAX) OUTPUT
AS
--------------------------------------
--------------------------------------
SET	@DESCRIPCION	=	(
							SELECT ISNULL ((SELECT	DESCRIPCION FROM ANALITICA
							WHERE	CIA				= @CIA
							AND		ID_ANALITICA	= @ID_CLIENTE),'')
						)
GO
/****** Object:  StoredProcedure [dbo].[SP_F_CAMPANIA_POLITICA_BUSCAR_SEDE]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*

SELECT * FROM SEDE

DECLARE	@DESCRIPCION VARCHAR(MAX)
EXEC	SP_F_CAMPANIA_POLITICA_BUSCAR_SEDE '01', '02', @DESCRIPCION OUTPUT
PRINT @DESCRIPCION

*/
--------------------------------------
--------------------------------------
create	PROCEDURE	[dbo].[SP_F_CAMPANIA_POLITICA_BUSCAR_SEDE]
@CIA			CHAR(2),
@SEDE			CHAR(2),
@DESCRIPCION	VARCHAR(MAX) OUTPUT
AS
--------------------------------------
--------------------------------------
SET	@DESCRIPCION	=	(
							SELECT ISNULL ((SELECT	DESCRIPCION FROM SEDE
							WHERE	CIA		= @CIA
							AND		SEDE	= @SEDE),'')
						)
GO
/****** Object:  StoredProcedure [dbo].[SP_F_CAMPANIA_POLITICA_TEMP_ACTUALIZAR]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*

EXEC [SP_F_CAMPANIA_POLITICA_TEMP_ACTUALIZAR] 'ADMIN','01',1,3,'02','01','10046307581','PROLUB0000000001','0','0','1','0','0','0','0',
											  '2010-05-05',NULL,NULL,NULL,'8','01','1','2010-07-05 00:00:00','ADMIN','0'

*/
---------------------------------------------------
---------------------------------------------------
create PROCEDURE [dbo].[SP_F_CAMPANIA_POLITICA_TEMP_ACTUALIZAR]
@SESION		VARCHAR(50),
@CIA			CHAR(2),
@ID_CAMPANIA	INT,
@ITEM			INT,
@SEDE			CHAR(2),
@ID_CATEGORIA	CHAR(2),
@ID_CLIENTE		VARCHAR(20),
@ID_ARTICULO	VARCHAR(20),
@FLAG_L			CHAR(1),
@FLAG_K			CHAR(1),
@FLAG_M			CHAR(1),
@FLAG_J			CHAR(1),
@FLAG_V			CHAR(1),
@FLAG_S			CHAR(1),
@FLAG_D			CHAR(1),
@FECHA_DEL		VARCHAR(25),
@FECHA_AL		VARCHAR(25),
@HORA_DEL		VARCHAR(25),
@HORA_AL		VARCHAR(25),
@CANTIDAD		VARCHAR(100),
@ID_ESTADO		CHAR(2),
@FLAG_ENVIO		CHAR(1),
@FM				VARCHAR(25),
@UM				VARCHAR(10),
@MODO			CHAR(1)
AS

--SET DATEFORMAT YMD
---------------------------------------------------
DECLARE	@FECHA_INI		DATETIME
DECLARE	@FECHA_FIN		DATETIME
DECLARE	@HORA_INI		DATETIME
DECLARE	@HORA_FIN		DATETIME
DECLARE	@FECHA_M		DATETIME
---------------------------------------------------
IF((SELECT ISDATE(@FECHA_DEL)) = 1) BEGIN SET @FECHA_INI = CONVERT(DATETIME,@FECHA_DEL) END ELSE BEGIN SET @FECHA_INI  = NULL END
IF((SELECT ISDATE(@FECHA_AL)) = 1) BEGIN SET @FECHA_FIN = CONVERT(DATETIME,@FECHA_AL) END ELSE BEGIN SET @FECHA_FIN = NULL END
IF((SELECT ISDATE(@HORA_DEL)) = 1) BEGIN SET @HORA_INI = CONVERT(DATETIME,@HORA_DEL) END ELSE BEGIN SET @HORA_INI = NULL END
IF((SELECT ISDATE(@HORA_AL)) = 1) BEGIN SET @HORA_FIN = CONVERT(DATETIME,@HORA_AL) END ELSE BEGIN SET @HORA_FIN = NULL END
IF((SELECT ISDATE(@FM)) = 1) BEGIN SET @FECHA_M = CONVERT(DATETIME,@FM) END ELSE BEGIN SET @FM = NULL END
SET @FECHA_M = CONVERT(DATETIME,@FM)
---------------------------------------------------
IF(@SEDE = '') BEGIN SET @SEDE = NULL END
IF(@ID_CATEGORIA = '') BEGIN SET @ID_CATEGORIA = NULL END
IF(@ID_CLIENTE='') BEGIN SET @ID_CLIENTE = NULL END
IF(@ID_ARTICULO='') BEGIN SET @ID_ARTICULO = NULL END
---------------------------------------------------
SET NOCOUNT ON

UPDATE	[F_CAMPANIA_POLITICA_TEMP]
SET		[SEDE]			= @SEDE, 
		[ID_CATEGORIA]	= @ID_CATEGORIA, 
		[ID_CLIENTE]	= @ID_CLIENTE, 
		[ID_ARTICULO]	= @ID_ARTICULO, 
		[FLAG_L]		= @FLAG_L, 
		[FLAG_K]		= @FLAG_K, 
		[FLAG_M]		= @FLAG_M, 
		[FLAG_J]		= @FLAG_J,
		[FLAG_V]		= @FLAG_V, 
		[FLAG_S]		= @FLAG_S, 
		[FLAG_D]		= @FLAG_D, 
		[FECHA_DEL]		= @FECHA_INI, 
		[FECHA_AL]		= @FECHA_FIN, 
		[HORA_DEL]		= @HORA_INI, 
		[HORA_AL]		= @HORA_FIN, 
		[CANTIDAD]		= @CANTIDAD, 
		[ID_ESTADO]		= @ID_ESTADO, 
		[FLAG_ENVIO]	= @FLAG_ENVIO, 
		[FM]			= @FECHA_M, 
		[UM]			= @UM, 
		[MODO]			= @MODO
WHERE	[SESION]		= @SESION 
AND		[CIA]			= @CIA
AND		[ID_CAMPANIA]	= CASE WHEN LEN(@ID_CAMPANIA) > 0 THEN @ID_CAMPANIA ELSE '' END
AND		[ITEM]			= @ITEM
GO
/****** Object:  StoredProcedure [dbo].[SP_F_CAMPANIA_POLITICA_TEMP_ELIMINAR]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*



*/
---------------------------------------------------
---------------------------------------------------
create PROCEDURE [dbo].[SP_F_CAMPANIA_POLITICA_TEMP_ELIMINAR]
@SESION		VARCHAR(50),
@CIA			CHAR(2),
@ID_CAMPANIA	INT,
@ITEM			INT,
@ID_ESTADO		CHAR(2),
@FLAG_ENVIO		CHAR(1),
@FA				VARCHAR(25),
@UA				VARCHAR(10),
@AA				VARCHAR(60),
@MODO			CHAR(1)
AS
---------------------------------------------------
DECLARE	@FECHA_FA	DATETIME
-----------------------------------------------
SET	@FECHA_FA = CONVERT(DATETIME,LEFT(@FA,10))
---------------------------------------------------
SET NOCOUNT ON
UPDATE	[F_CAMPANIA_POLITICA_TEMP]
SET		[ID_ESTADO]	= @ID_ESTADO, 
		[FLAG_ENVIO]= @FLAG_ENVIO, 
		[FA]		= @FECHA_FA, 
		[UA]		= @UA, 
		[AA]		= @AA,
		[MODO]		= @MODO
WHERE	[SESION]	= @SESION
AND		[CIA]		= @CIA
AND		[ID_CAMPANIA]= CASE WHEN LEN(@ID_CAMPANIA) > 0 THEN @ID_CAMPANIA ELSE '' END
AND		[ITEM]		= @ITEM
GO
/****** Object:  StoredProcedure [dbo].[SP_F_CAMPANIA_POLITICA_TEMP_INSERT]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*

DELETE FROM [F_CAMPANIA_POLITICA_TEMP]

EXEC	[SP_F_CAMPANIA_POLITICA_TEMP_INSERT] 'fdsfsfsdsfdsfdsfdsfdsfdsf','01','',0,'01','','','','0','1','0','1','0','1','0','01/08/2010','31/08/2010','08:00','20:00',
											 '1', '01', '1', 'admin', '0'
SELECT * FROM [F_CAMPANIA_POLITICA_TEMP]
*/
---------------------------------------------------
---------------------------------------------------
create PROCEDURE [dbo].[SP_F_CAMPANIA_POLITICA_TEMP_INSERT]
@SESION			VARCHAR(100),
@CIA			CHAR(2),
@ID_CAMPANIA	INT,
@ITEM			INT,
@SEDE			CHAR(2),
@ID_CATEGORIA	CHAR(2),
@ID_CLIENTE		VARCHAR(20),
@ID_ARTICULO	VARCHAR(20),
@FLAG_L			CHAR(1),
@FLAG_K			CHAR(1),
@FLAG_M			CHAR(1),
@FLAG_J			CHAR(1),
@FLAG_V			CHAR(1),
@FLAG_S			CHAR(1),
@FLAG_D			CHAR(1),
@FECHA_DEL		VARCHAR(25),
@FECHA_AL		VARCHAR(25),
@HORA_DEL		VARCHAR(25),
@HORA_AL		VARCHAR(25),
@CANTIDAD		VARCHAR(100),
@ID_ESTADO		CHAR(2),
@FLAG_ENVIO		CHAR(1),
@UC				VARCHAR(10),
@MODO			CHAR(1)
AS
--SET DATEFORMAT YMD
---------------------------------------------------
---------------------------------------------------
DECLARE	@FECHA_INI		DATETIME
DECLARE	@FECHA_FIN		DATETIME
DECLARE	@HORA_INI		DATETIME
DECLARE	@HORA_FIN		DATETIME
---------------------------------------------------
IF((SELECT ISDATE(@FECHA_DEL)) = 1) BEGIN SET @FECHA_INI = CONVERT(DATETIME,@FECHA_DEL) END ELSE BEGIN SET @FECHA_INI  = NULL END
IF((SELECT ISDATE(@FECHA_AL)) = 1) BEGIN SET @FECHA_FIN = CONVERT(DATETIME,@FECHA_AL) END ELSE BEGIN SET @FECHA_FIN = NULL END
IF((SELECT ISDATE(@HORA_DEL)) = 1) BEGIN SET @HORA_INI = CONVERT(DATETIME,@HORA_DEL) END ELSE BEGIN SET @HORA_INI = NULL END
IF((SELECT ISDATE(@HORA_AL)) = 1) BEGIN SET @HORA_FIN = CONVERT(DATETIME,@HORA_AL) END ELSE BEGIN SET @HORA_FIN = NULL END
---------------------------------------------------
IF(@SEDE = '') BEGIN SET @SEDE = NULL END
IF(@ID_CATEGORIA = '') BEGIN SET @ID_CATEGORIA = NULL END
IF(@ID_CLIENTE='') BEGIN SET @ID_CLIENTE = NULL END
IF(@ID_ARTICULO='') BEGIN SET @ID_ARTICULO = NULL END
---------------------------------------------------
SET NOCOUNT ON

SET	@ITEM	=	(
					SELECT ISNULL((SELECT	MAX(ITEM) FROM F_CAMPANIA_POLITICA_TEMP
					WHERE	SESION	= @SESION
					AND		MODO	= @MODO),0)
				)
---------------------------------------------------
IF(@ITEM = 0)
BEGIN
	SET	@ITEM = 1
END
ELSE
BEGIN
	SET @ITEM = @ITEM + 1
END
---------------------------------------------------
INSERT INTO [F_CAMPANIA_POLITICA_TEMP]
(
	[SESION], [CIA], [ID_CAMPANIA], [ITEM], [SEDE], [ID_CATEGORIA], [ID_CLIENTE], [ID_ARTICULO], [FLAG_L], [FLAG_K], [FLAG_M], [FLAG_J],
	[FLAG_V], [FLAG_S], [FLAG_D], [FECHA_DEL], [FECHA_AL], [HORA_DEL], [HORA_AL], [CANTIDAD], [ID_ESTADO], [FLAG_ENVIO], [FC], [UC], [MODO]
)
VALUES
(
	@SESION, @CIA, @ID_CAMPANIA, @ITEM, @SEDE, @ID_CATEGORIA, @ID_CLIENTE, @ID_ARTICULO, @FLAG_L, @FLAG_K, @FLAG_M, @FLAG_J,
	@FLAG_V, @FLAG_S, @FLAG_D, @FECHA_INI, @FECHA_FIN, @HORA_INI, @HORA_FIN, @CANTIDAD, @ID_ESTADO, @FLAG_ENVIO, GETDATE(), @UC, @MODO
)
GO
/****** Object:  StoredProcedure [dbo].[SP_F_CAMPANIA_POLITICA_TEMP_TRAER_POLITICA]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*



*/
---------------------------------------------------
---------------------------------------------------
create	PROCEDURE	[dbo].[SP_F_CAMPANIA_POLITICA_TEMP_TRAER_POLITICA]
@SESION			VARCHAR(50),
@CIA			CHAR(2),
@ID_CAMPANIA	INT,
@ITEM			INT
AS
---------------------------------------------------
---------------------------------------------------
SELECT	POL.ITEM, 
		POL.SEDE AS 'ID_SEDE', 
		SEDE.DESCRIPCION AS 'SEDE', 
		POL.ID_CATEGORIA AS 'ID_CATEGORIA', 
		CAT.DESCRIPCION AS 'CATEGORIA', 
		POL.ID_CLIENTE AS 'ID_CLIENTE', 
		CLI.DESCRIPCION AS 'CLIENTE', 
		POL.ID_ARTICULO AS 'ID_ARTICULO', 
		ART.DESCRIPCION AS 'ARTICULO', 
		POL.ID_ESTADO AS 'ESTADO', 
		CONVERT(VARCHAR(10),POL.FECHA_DEL,103) AS 'FECHA_DEL', 
		CONVERT(VARCHAR(10),POL.FECHA_AL,103) AS 'FECHA_AL', 
		LEFT(CONVERT(VARCHAR(10),POL.HORA_DEL,108),5) AS 'HORA_DEL', 
		LEFT(CONVERT(VARCHAR(10),POL.HORA_AL,108),5) AS 'HORA_AL', 
		POL.CANTIDAD AS 'CANTIDAD', 
		POL.FLAG_L AS 'FLAG_L', 
		POL.FLAG_K AS 'FLAG_K', 
		POL.FLAG_M AS 'FLAG_M', 
		POL.FLAG_J AS 'FLAG_J', 
		POL.FLAG_V AS 'FLAG_V', 
		POL.FLAG_S AS 'FLAG_S', 
		POL.FLAG_D AS 'FLAG_D'
FROM	F_CAMPANIA_POLITICA_TEMP AS POL 
LEFT JOIN ANALITICA AS CLI ON CLI.CIA = POL.CIA AND CLI.ID_ANALITICA = POL.ID_CLIENTE 
LEFT JOIN ARTICULO AS ART ON ART.CIA = POL.CIA AND ART.ID_ARTICULO = POL.ID_ARTICULO 
LEFT JOIN CATEGORIA_ANALITICA AS CAT ON CAT.ID_CATEGORIA = POL.ID_CATEGORIA AND CAT.CIA  = POL.CIA
LEFT JOIN SEDE ON SEDE.CIA = POL.CIA AND SEDE.SEDE = POL.SEDE
WHERE	POL.SESION		= @SESION 
AND		POL.CIA			= @CIA 
AND		POL.ID_CAMPANIA = CASE WHEN LEN(@ID_CAMPANIA) > 0 THEN @ID_CAMPANIA ELSE '' END
AND		POL.ITEM		= @ITEM
GO
/****** Object:  StoredProcedure [dbo].[SP_F_CAMPANIA_POLITICA_TEMP_TRAER_TODOS]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*

EXEC	[SP_F_CAMPANIA_POLITICA_TEMP_TRAER_TODOS] 'ADMIN','01',0

SELECT * FROM F_CAMPANIA_POLITICA_TEMP

*/
---------------------------------------------------
---------------------------------------------------
create	PROCEDURE	[dbo].[SP_F_CAMPANIA_POLITICA_TEMP_TRAER_TODOS]
@SESION			VARCHAR(50),
@CIA			CHAR(2),
@ID_CAMPANIA	INT
AS
---------------------------------------------------
---------------------------------------------------
SELECT	POL.ITEM, SEDE.DESCRIPCION AS 'SEDE', CAT.DESCRIPCION AS 'CATEGORIA', CLI.DESCRIPCION AS 'CLIENTE', ART.DESCRIPCION AS 'ARTICULO', EST.ABREVIATURA AS 'ESTADO'
		--POL.FLAG_L AS 'LUN.', POL.FLAG_K AS 'MAR.', POL.FLAG_M AS 'MIE.', POL.FLAG_J AS 'JUE.', POL.FLAG_V AS 'VIE.', POL.FLAG_S AS 'SAB.', 
		--POL.FLAG_D AS 'DOM.', CONVERT(VARCHAR(10), POL.FECHA_DEL, 103) AS 'F.INI', CONVERT(VARCHAR(10), POL.FECHA_AL, 103) AS 'F.FIN', 
		--CONVERT(VARCHAR(10), POL.HORA_DEL, 108) AS 'H.INI', CONVERT(VARCHAR(10), POL.HORA_AL, 108) AS 'H.FIN', POL.CANTIDAD AS 'MODO', 
FROM	F_CAMPANIA_POLITICA_TEMP AS POL 
LEFT JOIN SEDE ON POL.CIA = SEDE.CIA AND POL.SEDE = SEDE.SEDE 
LEFT JOIN CATEGORIA_ANALITICA AS CAT ON POL.CIA = CAT.CIA AND POL.ID_CATEGORIA = CAT.ID_CATEGORIA 
LEFT JOIN ANALITICA AS CLI ON POL.CIA = CLI.CIA AND POL.ID_CLIENTE = CLI.ID_ANALITICA 
LEFT JOIN ARTICULO AS ART ON POL.CIA = ART.CIA AND POL.ID_ARTICULO = ART.ID_ARTICULO 
INNER JOIN ESTADO AS EST ON POL.CIA = EST.CIA AND POL.ID_ESTADO = EST.ID_ESTADO
WHERE	POL.SESION		= @SESION 
AND		POL.CIA			= @CIA 
AND		POL.ID_CAMPANIA = CASE WHEN LEN(@ID_CAMPANIA) > 0 THEN @ID_CAMPANIA ELSE '' END
AND		POL.ID_ESTADO	= '01'
GO
/****** Object:  StoredProcedure [dbo].[SP_F_CAMPANIA_POLITICAS]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*

SELECT * FROM F_CAMPANIA
SELECT * FROM F_CAMPANIA_POLITICA_PUNTO
SELECT * FROM F_CAMPANIA_POLITICA_FRASE

*/
---------------------------------------------------
---------------------------------------------------
create	PROCEDURE	[dbo].[SP_F_CAMPANIA_POLITICAS]
@CIA			CHAR(2),
@ID_CAMPANIA	INT
AS
---------------------------------------------------
DECLARE @MODO	CHAR(1)
---------------------------------------------------
SET	@MODO = (SELECT FLAG_FRASE_GANADORA FROM F_CAMPANIA WHERE CIA = @CIA AND ID_CAMPANIA = @ID_CAMPANIA)
---------------------------------------------------
IF(@MODO = '0')
BEGIN
	-----------------------------------------------
	SELECT	FCP.ITEM, SEDE.DESCRIPCION AS 'SEDE', CAT.DESCRIPCION AS 'CATEGORIA', CLI.DESCRIPCION AS 'CLIENTE', ART.DESCRIPCION AS 'ARTICULO', EST.ABREVIATURA AS 'ESTADO'
	FROM	F_CAMPANIA_POLITICA_PUNTO AS FCP 
	LEFT JOIN SEDE ON FCP.CIA = SEDE.CIA AND FCP.SEDE = SEDE.SEDE 
	LEFT JOIN CATEGORIA_ANALITICA AS CAT ON FCP.CIA = CAT.CIA AND FCP.ID_CATEGORIA = CAT.ID_CATEGORIA 
	LEFT JOIN ANALITICA AS CLI ON FCP.CIA = CLI.CIA AND FCP.ID_CLIENTE = CLI.ID_ANALITICA 
	LEFT JOIN ARTICULO AS ART ON FCP.CIA = ART.CIA AND FCP.ID_ARTICULO = ART.ID_ARTICULO 
	INNER JOIN ESTADO AS EST ON FCP.CIA = EST.CIA AND FCP.ID_ESTADO = EST.ID_ESTADO
	WHERE	FCP.CIA			= @CIA
	AND		FCP.ID_CAMPANIA	= @ID_CAMPANIA
	-----------------------------------------------
END
ELSE
BEGIN
	-----------------------------------------------
	SELECT	FCF.ITEM, SEDE.DESCRIPCION AS 'SEDE', CAT.DESCRIPCION AS 'CATEGORIA', CLI.DESCRIPCION AS 'CLIENTE', ART.DESCRIPCION AS 'ARTICULO', EST.ABREVIATURA AS 'ESTADO'
	FROM	F_CAMPANIA_POLITICA_FRASE AS FCF 
	LEFT JOIN SEDE ON FCF.CIA = SEDE.CIA AND FCF.SEDE = SEDE.SEDE 
	LEFT JOIN CATEGORIA_ANALITICA AS CAT ON FCF.CIA = CAT.CIA AND FCF.ID_CATEGORIA = CAT.ID_CATEGORIA 
	LEFT JOIN ANALITICA AS CLI ON FCF.CIA = CLI.CIA AND FCF.ID_CLIENTE = CLI.ID_ANALITICA 
	LEFT JOIN ARTICULO AS ART ON FCF.CIA = ART.CIA AND FCF.ID_ARTICULO = ART.ID_ARTICULO 
	INNER JOIN ESTADO AS EST ON FCF.CIA = EST.CIA AND FCF.ID_ESTADO = EST.ID_ESTADO
	WHERE	FCF.CIA			= @CIA
	AND		FCF.ID_CAMPANIA	= @ID_CAMPANIA
	-----------------------------------------------
END
GO
/****** Object:  StoredProcedure [dbo].[SP_F_CAMPANIA_PREMIO_TEMP_ACTUALIZAR]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*



*/
-------------------------------------------------------
-------------------------------------------------------
create	PROCEDURE	[dbo].[SP_F_CAMPANIA_PREMIO_TEMP_ACTUALIZAR]
@SESION			VARCHAR(50),
@CIA			CHAR(2),
@ID_CAMPANIA	INT,
@ITEM			INT,
@ID_ARTICULO	VARCHAR(20),
@CANTIDAD		DECIMAL(13,2),
@TOTAL_PUNTOS	DECIMAL(13,2),
@FRASE_GANADORA	VARCHAR(100),
@ID_ESTADO		CHAR(2),
@FLAG_ENVIO		CHAR(1),
@FM				VARCHAR(25),
@UM				VARCHAR(10)
AS
-------------------------------------------------------
DECLARE	@FECHA_M	DATETIME
-------------------------------------------------------
SET	@FECHA_M	= CONVERT(DATETIME,LEFT(@FM,10))
-------------------------------------------------------
SET NOCOUNT ON

UPDATE	F_CAMPANIA_PREMIO_TEMP
SET		[ID_ARTICULO]	= @ID_ARTICULO, 
		[CANTIDAD]		= @CANTIDAD,
		[TOTAL_PUNTOS]	= @TOTAL_PUNTOS,
		[FRASE_GANADORA]= @FRASE_GANADORA,
		[ID_ESTADO]		= @ID_ESTADO, 
		[FLAG_ENVIO]	= @FLAG_ENVIO, 
		[FM]			= @FECHA_M, 
		[UM]			= @UM
WHERE	[SESION]		= @SESION 
AND		[CIA]			= @CIA
AND		[ID_CAMPANIA]	= CASE WHEN LEN(@ID_CAMPANIA) > 0 THEN @ID_CAMPANIA ELSE '' END
AND		[ITEM]			= @ITEM
GO
/****** Object:  StoredProcedure [dbo].[SP_F_CAMPANIA_PREMIO_TEMP_ELIMINAR]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*



*/
-------------------------------------------------------
-------------------------------------------------------
create	PROCEDURE	[dbo].[SP_F_CAMPANIA_PREMIO_TEMP_ELIMINAR]
@SESION			VARCHAR(50),
@CIA			CHAR(2),
@ID_CAMPANIA	INT,
@ITEM			INT,
@ID_ESTADO		CHAR(2),
@FLAG_ENVIO		CHAR(1),
@FA				VARCHAR(25),
@UA				VARCHAR(10),
@AA				VARCHAR(60)
AS
-------------------------------------------------------
-------------------------------------------------------
DECLARE	@FECHA_FA	DATETIME
-----------------------------------------------
SET	@FECHA_FA = CONVERT(DATETIME,LEFT(@FA,10))
---------------------------------------------------
SET NOCOUNT ON
UPDATE	F_CAMPANIA_PREMIO_TEMP
SET		[ID_ESTADO]	= @ID_ESTADO, 
		[FLAG_ENVIO]= @FLAG_ENVIO, 
		[FA]		= @FECHA_FA, 
		[UA]		= @UA, 
		[AA]		= @AA
WHERE	[SESION]	= @SESION
AND		[CIA]		= @CIA
AND		[ID_CAMPANIA]= CASE WHEN LEN(@ID_CAMPANIA) > 0 THEN @ID_CAMPANIA ELSE '' END
AND		[ITEM]		= @ITEM
GO
/****** Object:  StoredProcedure [dbo].[SP_F_CAMPANIA_PREMIO_TEMP_INSERT]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*



*/
-------------------------------------------------------
-------------------------------------------------------
create	PROCEDURE	[dbo].[SP_F_CAMPANIA_PREMIO_TEMP_INSERT]
@SESION			VARCHAR(100),
@CIA			CHAR(2),
@ID_CAMPANIA	INT,
@ITEM			INT,
@ID_ARTICULO	VARCHAR(20),
@CANTIDAD		DECIMAL(13,2),
@TOTAL_PUNTOS	DECIMAL(13,2),
@FRASE_GANADORA	VARCHAR(100),
@ID_ESTADO		CHAR(2),
@FLAG_ENVIO		CHAR(1),
@UC				VARCHAR(10)
AS
-------------------------------------------------------
-------------------------------------------------------
SET	@ITEM	=	(
					SELECT ISNULL((SELECT	MAX(ITEM) FROM F_CAMPANIA_PREMIO_TEMP
					WHERE	SESION	= @SESION),0)
				)
---------------------------------------------------
IF(@ITEM = 0)
BEGIN
	SET	@ITEM = 1
END
ELSE
BEGIN
	SET @ITEM = @ITEM + 1
END
---------------------------------------------------
INSERT INTO F_CAMPANIA_PREMIO_TEMP
(
	[SESION], [CIA], [ID_CAMPANIA], [ITEM], [ID_ARTICULO], [CANTIDAD], [TOTAL_PUNTOS], [FRASE_GANADORA], [ID_ESTADO], [FLAG_ENVIO], [FC], [UC]
)
VALUES
(
	@SESION, @CIA, @ID_CAMPANIA, @ITEM, @ID_ARTICULO, @CANTIDAD, @TOTAL_PUNTOS, @FRASE_GANADORA, @ID_ESTADO, @FLAG_ENVIO, GETDATE(), @UC
)
GO
/****** Object:  StoredProcedure [dbo].[SP_F_CAMPANIA_PREMIO_TEMP_TRAER_PREMIO]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*



*/
---------------------------------------------------
---------------------------------------------------
create	PROCEDURE	[dbo].[SP_F_CAMPANIA_PREMIO_TEMP_TRAER_PREMIO]
@SESION			VARCHAR(50),
@CIA			CHAR(2),
@ID_CAMPANIA	INT,
@ITEM			INT
AS
---------------------------------------------------
---------------------------------------------------
SELECT	PRE.ITEM,  
		PRE.ID_ARTICULO AS 'ID_ARTICULO', 
		ART.DESCRIPCION AS 'ARTICULO', 
		PRE.ID_ESTADO AS 'ESTADO', 
		CONVERT(INT,PRE.CANTIDAD) AS 'CANTIDAD',
		PRE.TOTAL_PUNTOS AS 'TOTAL PUNTOS',
		PRE.FRASE_GANADORA AS 'FRASE GANADORA'
FROM	F_CAMPANIA_PREMIO_TEMP AS PRE
INNER JOIN ARTICULO AS ART ON ART.CIA = PRE.CIA AND ART.ID_ARTICULO = PRE.ID_ARTICULO 
WHERE	PRE.SESION		= @SESION 
AND		PRE.CIA			= @CIA 
AND		PRE.ID_CAMPANIA = CASE WHEN LEN(@ID_CAMPANIA) > 0 THEN @ID_CAMPANIA ELSE '' END
AND		PRE.ITEM		= @ITEM
GO
/****** Object:  StoredProcedure [dbo].[SP_F_CAMPANIA_PREMIO_TEMP_TRAER_TODOS]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*

select * from CATEGORIA_ANALITICA

*/
---------------------------------------------------
---------------------------------------------------
create	PROCEDURE	[dbo].[SP_F_CAMPANIA_PREMIO_TEMP_TRAER_TODOS]
@SESION			VARCHAR(50),
@CIA			CHAR(2),
@ID_CAMPANIA	INT
AS
---------------------------------------------------
---------------------------------------------------
SELECT	PRE.ITEM,
		ART.DESCRIPCION AS 'ARTICULO',
		PRE.CANTIDAD AS 'CANTIDAD',
		PRE.TOTAL_PUNTOS AS 'PUNTOS',
		PRE.FRASE_GANADORA AS 'FRASE',
		EST.ABREVIATURA AS 'ESTADO'
FROM	F_CAMPANIA_PREMIO_TEMP AS PRE 
INNER JOIN ARTICULO AS ART ON ART.CIA = PRE.CIA AND ART.ID_ARTICULO = PRE.ID_ARTICULO
INNER JOIN ESTADO AS EST ON PRE.CIA = EST.CIA AND PRE.ID_ESTADO = EST.ID_ESTADO
WHERE	PRE.SESION		= @SESION 
AND		PRE.CIA			= @CIA 
AND		PRE.ID_CAMPANIA = CASE WHEN LEN(@ID_CAMPANIA) > 0 THEN @ID_CAMPANIA ELSE '' END
AND		PRE.ID_ESTADO	= '01'
GO
/****** Object:  StoredProcedure [dbo].[SP_F_CAMPANIA_PREMIOS]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*

select * from CATEGORIA_ANALITICA

*/
---------------------------------------------------
---------------------------------------------------
create	PROCEDURE	[dbo].[SP_F_CAMPANIA_PREMIOS]
@CIA			CHAR(2),
@ID_CAMPANIA	INT
AS
---------------------------------------------------
---------------------------------------------------
SELECT	PRE.ITEM,
		ART.DESCRIPCION AS 'ARTICULO',
		PRE.CANTIDAD AS 'CANTIDAD',
		PRE.TOTAL_PUNTOS AS 'PUNTOS',
		PRE.FRASE_GANADORA AS 'FRASE',
		EST.ABREVIATURA AS 'ESTADO'
FROM	F_CAMPANIA_PREMIO AS PRE 
INNER JOIN ARTICULO AS ART ON ART.CIA = PRE.CIA AND ART.ID_ARTICULO = PRE.ID_ARTICULO
INNER JOIN ESTADO AS EST ON PRE.CIA = EST.CIA AND PRE.ID_ESTADO = EST.ID_ESTADO
WHERE	PRE.CIA			= @CIA 
AND		PRE.ID_CAMPANIA = CASE WHEN LEN(@ID_CAMPANIA) > 0 THEN @ID_CAMPANIA ELSE '' END
GO
/****** Object:  StoredProcedure [dbo].[SP_F_CAMPANIA_TRAER_CAMPANIA]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*

SELECT * FROM F_CAMPANIA_POLITICA_FRASE
*/
-----------------------------------------------
-----------------------------------------------
create	PROCEDURE	[dbo].[SP_F_CAMPANIA_TRAER_CAMPANIA]
@SESION			VARCHAR(50),
@CIA			CHAR(2),
@ID_CAMPANIA	INT
AS
-----------------------------------------------
DECLARE	@MODO CHAR(1)
-----------------------------------------------
SELECT	CIA, 
		ID_CAMPANIA, 
		DESCRIPCION, 
		CONVERT(VARCHAR(10),FECHA_VIGENCIA_DEL,103), 
		CONVERT(VARCHAR(10),FECHA_VIGENCIA_AL,103), 
		FLAG_MONTO, 
		MINIMO_DIAS_VISITA, 
		FLAG_FRASE_GANADORA, 
		ID_ESTADO, 
        FLAG_ENVIO, 
        LOTE_ENVIO, 
        SE, 
        CONVERT(VARCHAR(10),FE,103), 
        UE, 
        CONVERT(VARCHAR(10),FC,103),
        UC, 
        CONVERT(VARCHAR(10),FM,103), 
        UM, 
        CONVERT(VARCHAR(10),FA,103), 
        UA, 
        AA
FROM	F_CAMPANIA
WHERE	CIA			= @CIA
AND		ID_CAMPANIA	= @ID_CAMPANIA
--------------------------------------------------
DELETE	FROM F_CAMPANIA_POLITICA_TEMP
WHERE	SESION = @SESION
--------------------------------------------------
DELETE	FROM F_CAMPANIA_PREMIO_TEMP
WHERE	SESION = @SESION
--------------------------------------------------

SET	@MODO = (
				SELECT FLAG_FRASE_GANADORA FROM F_CAMPANIA WHERE CIA = @CIA AND ID_CAMPANIA = @ID_CAMPANIA
			)
--------------------------------------------------
IF (@MODO = '0')
BEGIN
	INSERT INTO  F_CAMPANIA_POLITICA_TEMP
	(
		SESION, CIA, ID_CAMPANIA, ITEM, SEDE, ID_CATEGORIA, ID_CLIENTE, ID_ARTICULO, FLAG_L, FLAG_K, FLAG_M, FLAG_J, FLAG_V, 
		FLAG_S, FLAG_D, FECHA_DEL, FECHA_AL, HORA_DEL, HORA_AL, CANTIDAD, ID_ESTADO, FLAG_ENVIO, LOTE_ENVIO, SE, FE, 
		UE, FC, UC, FM, UM, FA, UA, AA, MODO
	)
	SELECT	@SESION, CIA, ID_CAMPANIA, ITEM, SEDE, ID_CATEGORIA, ID_CLIENTE, ID_ARTICULO, FLAG_L, FLAG_K, FLAG_M, FLAG_J, FLAG_V, 
			FLAG_S, FLAG_D, FECHA_DEL, FECHA_AL, HORA_DEL, HORA_AL, CANTIDAD, ID_ESTADO, FLAG_ENVIO, LOTE_ENVIO, SE, FE, 
			UE, FC, UC, FM, UM, FA, UA, AA, @MODO
	FROM	F_CAMPANIA_POLITICA_PUNTO
	WHERE	CIA		= @CIA
	AND		ID_CAMPANIA	= @ID_CAMPANIA
END
ELSE
BEGIN
	INSERT INTO  F_CAMPANIA_POLITICA_TEMP
	(
		SESION, CIA, ID_CAMPANIA, ITEM, SEDE, ID_CATEGORIA, ID_CLIENTE, ID_ARTICULO, FLAG_L, FLAG_K, FLAG_M, FLAG_J, FLAG_V, 
		FLAG_S, FLAG_D, FECHA_DEL, FECHA_AL, HORA_DEL, HORA_AL, CANTIDAD, ID_ESTADO, FLAG_ENVIO, LOTE_ENVIO, SE, FE, 
		UE, FC, UC, FM, UM, FA, UA, AA, MODO
	)
	SELECT	@SESION, CIA, ID_CAMPANIA, ITEM, SEDE, ID_CATEGORIA, ID_CLIENTE, ID_ARTICULO, FLAG_L, FLAG_K, FLAG_M, FLAG_J, FLAG_V, 
			FLAG_S, FLAG_D, FECHA_DEL, FECHA_AL, HORA_DEL, HORA_AL, LETRAS, ID_ESTADO, FLAG_ENVIO, LOTE_ENVIO, SE, FE, 
			UE, FC, UC, FM, UM, FA, UA, AA, @MODO
	FROM	F_CAMPANIA_POLITICA_FRASE
	WHERE	CIA		= @CIA
	AND		ID_CAMPANIA	= @ID_CAMPANIA
END
--------------------------------------------------
INSERT INTO F_CAMPANIA_PREMIO_TEMP
(
	SESION, CIA, ID_CAMPANIA, ITEM, ID_ARTICULO, CANTIDAD, TOTAL_PUNTOS, FRASE_GANADORA, ID_ESTADO, FLAG_ENVIO, LOTE_ENVIO, 
	SE, FE, UE, FC, UC, FM, UM, FA, UA, AA
)
SELECT	@SESION, CIA, ID_CAMPANIA, ITEM, ID_ARTICULO, CANTIDAD, TOTAL_PUNTOS, FRASE_GANADORA, ID_ESTADO, FLAG_ENVIO, LOTE_ENVIO, 
		SE, FE, UE, FC, UC, FM, UM, FA, UA, AA
FROM	F_CAMPANIA_PREMIO
WHERE	CIA			= @CIA
AND		ID_CAMPANIA	= @ID_CAMPANIA
GO
/****** Object:  StoredProcedure [dbo].[SP_F_CAMPANIA_TRAER_TODOS]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
SELECT * FROM F_CAMPANIA

EXEC	[SP_F_CAMPANIA_TRAER_TODOS] '01', '', '', '%'

*/
-----------------------------------------------
-----------------------------------------------
create	PROCEDURE	[dbo].[SP_F_CAMPANIA_TRAER_TODOS]
@CIA			CHAR(2),
@ID_CAMPANIA	VARCHAR(MAX),
@DESCRIPCION	VARCHAR(100),
@ID_ESTADO		VARCHAR(2)	
AS
-----------------------------------------------
-----------------------------------------------
SELECT	FC.ID_CAMPANIA AS 'ID_CAMPANIA', FC.DESCRIPCION AS 'DESCRIPCION', CONVERT(VARCHAR(10),FC.FECHA_VIGENCIA_DEL,103) AS 'FECHA_INI', 
		CONVERT(VARCHAR(10),FC.FECHA_VIGENCIA_AL,103) AS 'FECHA_FIN', 
		CASE FC.FLAG_MONTO
			WHEN 1 THEN 'DINERO'
			ELSE 'CONSUMO'
		END AS 'TIPO',
		CASE FC.FLAG_FRASE_GANADORA
			WHEN 1 THEN 'FRASE'
			ELSE 'PUNTOS'
		END AS 'MODO',
		FC.MINIMO_DIAS_VISITA AS 'NRO_VISITA', UPPER(ES.ABREVIATURA) AS 'ESTADO'
FROM	F_CAMPANIA AS FC INNER JOIN
        ESTADO AS ES ON FC.CIA = ES.CIA 
        AND FC.ID_ESTADO = ES.ID_ESTADO
WHERE	FC.CIA	= @CIA
AND		FC.ID_CAMPANIA	LIKE '%' +	CASE @ID_CAMPANIA
										WHEN '' THEN '%'
										ELSE @ID_CAMPANIA
									END + '%'
AND		FC.DESCRIPCION	LIKE '%' +	CASE @DESCRIPCION
										WHEN '' THEN '%'
										ELSE @DESCRIPCION
									END + '%'
AND		ES.ID_ESTADO	LIKE '%' + @ID_ESTADO + '%'
GO
/****** Object:  StoredProcedure [dbo].[sp_F_Kardex]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*---------------------Kardex----------------------------*/

CREATE PROCEDURE [dbo].[sp_F_Kardex]
@cia char(2),@sede char(2),@fec1 datetime,@fec2 datetime,@codcli varchar(20)
as
------------------------------------------
DECLARE @FECHA1 VARCHAR(8)
DECLARE @FECHA2 VARCHAR(8)
------------------------------------------
SET @FECHA1 = CONVERT(VARCHAR(8),@fec1,112)
SET @FECHA2 = CONVERT(VARCHAR(8),@fec2,112)
------------------------------------------
SELECT co.descripcion 'Cia',an.id_analitica 'cliente',an.descripcion 'descripcion',convert(varchar(10),im.fc,103) 'fecha', 
convert(varchar(10),im.fc,108)'hora',im.serie_doc+'-'+im.nro_doc 'documento',ar.descripcion 'articulo',imd.sede 'sede'
FROM analitica an
INNER JOIN INVENTARIO_MOV im
ON im.id_analitica=an.id_analitica and im.cia=an.cia
INNER JOIN INVENTARIO_MOV_DET imd
ON imd.nro_doc=im.nro_doc and im.cia=an.cia
INNER JOIN articulo ar
ON ar.id_articulo=imd.id_articulo and ar.cia=imd.cia
INNER JOIN compania co ON co.cia=an.cia
WHERE (imd.cia=@cia) and (imd.sede like @sede) and (an.id_analitica=@codcli) and (convert(varchar(10),im.fc,112) BETWEEN @FECHA1 and @FECHA2)


--sp_F_Kardex '01','01','23/08/2010','24/08/2010','10046514241'





/*
insert into F_CLIENTE_CAMPANIA (cia,id_cliente,id_campania,puntos_acumulados,id_estado,flag_envio,fc,uc)
select c.cia,c.id_cliente,'1',sum(v.puntos_fideliza),'01','1',getdate(),'ADMIN' from F_CLIENTE_TARJETA c
INNER JOIN e_venta v ON v.nro_tarjeta_fideliza=c.nro_tarjeta and v.cia=c.cia
group by c.cia,c.id_cliente
*/


--update e_venta set nro_tarjeta_fideliza='001' where cia='01' and sede='01' and id_venta<20

--update e_venta set  puntos_fideliza=cantidad where nro_tarjeta_fideliza='002'
GO
/****** Object:  StoredProcedure [dbo].[sp_F_puntos_acumulados]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE [dbo].[sp_F_puntos_acumulados]
@cia CHAR(2),@filtro varchar(500)
as
EXEC('
SELECT co.descripcion ''Cia'',ct.nro_tarjeta ''Tarjeta'',cc.id_cliente ''IdCliente'',a.descripcion ''Cliente'',cc.puntos_acumulados ''Puntos'',c.descripcion ''Capania''
FROM F_CLIENTE_CAMPANIA cc
INNER JOIN analitica a ON a.id_analitica=cc.id_cliente and a.cia=cc.cia
INNER JOIN F_CAMPANIA c ON c.id_campania=cc.id_campania and c.cia=cc.cia
INNER JOIN F_CLIENTE_TARJETA ct ON ct.id_cliente=cc.id_cliente and ct.cia=cc.cia
INNER JOIN compania co ON co.cia=cc.cia
WHERE (a.cia='''+@cia+''') '+@filtro+'
')
GO
/****** Object:  StoredProcedure [dbo].[sp_F_seguimineto_puntos]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*--------------------Seguimiento de Puntos---------------------------*/

CREATE PROCEDURE [dbo].[sp_F_seguimineto_puntos]
@cia char(2),@filtro varchar(500)
AS
EXEC('
SELECT co.descripcion ''Cia'',ct.nro_tarjeta ''Tarjeta'',an.descripcion ''Cliente'',ar.descripcion ''Producto'',convert(varchar(10),v.fc,103) ''Fecha'',
convert(varchar(10),v.fc,108) ''Hora'',v.puntos_fideliza ''Puntos'',v.letra_fideliza ''Letra''
FROM F_CLIENTE_TARJETA ct
INNER JOIN analitica an ON an.id_analitica=ct.id_cliente and an.cia=ct.cia
INNER JOIN e_venta v ON v.nro_tarjeta_fideliza=ct.nro_tarjeta and v.cia=ct.cia
INNER JOIN articulo ar ON ar.id_articulo=v.id_articulo and ar.cia=v.cia
INNER JOIN compania co ON co.cia=ct.cia
WHERE (ct.id_estado=''01'') and (ct.cia='''+@cia+''') '+@filtro+'
')

--sp_F_seguimineto_puntos '01',''
--sp_F_seguimineto_puntos '01','and ct.nro_tarjeta=0001'
GO
/****** Object:  StoredProcedure [dbo].[SP_GENERAR_CLIV_CRONO]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*------------GENERAR CORRELATIVO DE CLIENTE_VEHICULO Y CRONOGRAMA OPERARIO-----------------*/
--SP_N_CORRELATIVO_CLIV_CRONO 2,'01','10005056298','AGUKIKI','ADMIN'
--SP_N_CORRELATIVO_CLIV_CRONO 2,'01','','',''

create PROCEDURE [dbo].[SP_GENERAR_CLIV_CRONO]
@INDICADOR INT,@CIA CHAR(2),@ID_CLIENTE VARCHAR(20),@PLACA VARCHAR(20),@UC VARCHAR(20)
AS
IF @INDICADOR=1
BEGIN
DECLARE @NRO_DOC VARCHAR(20)
SET @NRO_DOC=(SELECT ISNULL((SELECT RIGHT('0000000'+CAST(RIGHT(MAX(NRO_DOC),8)+1 AS VARCHAR),8) FROM CLIENTE_VEHICULO),'00000001'))
---------------------------------------------------------------
INSERT INTO CLIENTE_VEHICULO (CIA,ID_TIPO_DOC,NRO_DOC,ID_CLIENTE,PLACA,ID_ESTADO,FLAG_ENVIO,FC,UC,FECHA,ID_CLIENTE_SERVICIO) 
VALUES (@CIA,'27',@NRO_DOC,@ID_CLIENTE,@PLACA,'01','1',GETDATE(),@UC,CONVERT(VARCHAR(10),GETDATE(),103),@ID_CLIENTE)
---------------------------------------------------------------
SELECT NRO_DOC FROM CLIENTE_VEHICULO WHERE NRO_DOC=@NRO_DOC
---------------------------------------------------------------
END
ELSE IF @INDICADOR=2
BEGIN
SELECT ISNULL((SELECT RIGHT('0000000'+CAST(RIGHT(MAX(NRO_DOC),8)+1 AS VARCHAR),8) FROM CRONOGRAMA_OPER WHERE CIA=@CIA),'00000001')
END
GO
/****** Object:  StoredProcedure [dbo].[SP_INSERTAR_DATOS_E_DISPLAY]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*

SELECT * FROM E_DISPLAY

SELECT * FROM E_MANGUERA WHERE ID_MANGUERA IN ('01','02','03','04','09','10','13','14')

SELECT * FROM ARTICULO WHERE ID_ARTICULO IN ('PROCOM0000000001','PROCOM0000000003')


EXEC	SP_INSERTAR_DATOS_E_DISPLAY '01', 'ABAJO', 20, 'ASD-156'
EXEC	SP_INSERTAR_DATOS_E_DISPLAY '01', 'ESPERANDO', 30, 'FDG-174'
EXEC	SP_INSERTAR_DATOS_E_DISPLAY '01', 'CLIENTE', 40, 'BVN-987'
EXEC	SP_INSERTAR_DATOS_E_DISPLAY '01', 'DESPACHANDO', 50, 'SDR-255'
EXEC	SP_INSERTAR_DATOS_E_DISPLAY '01', 'FINALIZANDO', 60, 'QWE-874'
EXEC	SP_INSERTAR_DATOS_E_DISPLAY '01', 'PAUSA', 0, ''
EXEC	SP_INSERTAR_DATOS_E_DISPLAY '01', 'AUTORIZANDO', 80, 'POI-870'
EXEC	SP_INSERTAR_DATOS_E_DISPLAY '01', 'ERROR', 0 ,''

*/
----------------------------------------------------
----------------------------------------------------
create	PROCEDURE [dbo].[SP_INSERTAR_DATOS_E_DISPLAY]
@ID_MANGUERA	CHAR(2),
@ESTADO			VARCHAR(20),
@CANTIDAD		FLOAT,
@PLACA			VARCHAR(10)
AS
----------------------------------------------------
----------------------------------------------------
UPDATE	E_DISPLAY
SET		ESTADO		= @ESTADO,
		CANTIDAD	= @CANTIDAD, 
		PLACA		= @PLACA, 
		TOTAL		= PRECIO * @CANTIDAD
WHERE	CIA			= '01'
AND		SEDE		= '02'
AND		ID_MANGUERA	= @ID_MANGUERA
GO
/****** Object:  StoredProcedure [dbo].[SP_INVENTARIO_DET_TEMP]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*

SELECT * FROM INVENTARIO_DET_TEMP

DELETE	FROM INVENTARIO_DET_TEMP

SELECT * FROM EXISTENCIA_ALMACEN

DECLARE	@MENSAJE_ERROR VARCHAR(300)
EXEC	[SP_INVENTARIO_DET_TEMP] '2', '90f87281-f7f3-4a2d-b2ab-872710a76c4d', '01', '02', 2, 1, 'PMATAR0000000003', '10011862573', 20, @MENSAJE_ERROR
PRINT	@MENSAJE_ERROR

*/
----------------------------------------------
----------------------------------------------
create	PROCEDURE [dbo].[SP_INVENTARIO_DET_TEMP]
@INDICADOR		CHAR(1),
@SESION			VARCHAR(100),
@CIA			CHAR(2),
@SEDE			CHAR(2),
@ITEM			INT,
@ID_CAMPANIA	INT,
@ID_ARTICULO	VARCHAR(20),
@ID_CLIENTE		VARCHAR(20),
@CANTIDAD		FLOAT,
@MENSAJE_ERROR	VARCHAR(300)OUTPUT
AS
----------------------------------------------
DECLARE @COUNT				INT
DECLARE	@TOTAL_PUNTOS		DECIMAL(13,2)
DECLARE	@PUNTOS_CANJE		DECIMAL(13,2)
DECLARE @TIPO_CAMPANIA		CHAR(1)
DECLARE	@STOCK				DECIMAL(13,2)
DECLARE	@PUNTOS_ACUMULADOS	DECIMAL(13,2)
----------------------------------------------
SET	@PUNTOS_ACUMULADOS = (SELECT ISNULL((SELECT SUM(P_USADO) FROM INVENTARIO_DET_TEMP WHERE SESION = @SESION AND CIA = @CIA AND SEDE = @SEDE AND ID_CAMPANIA = @ID_CAMPANIA),0))
SET	@STOCK = (SELECT CANT_DISPONIBLE FROM EXISTENCIA_ALMACEN WHERE CIA = @CIA AND SEDE = @SEDE AND ID_ALMACEN = 'ES' AND ID_ARTICULO = @ID_ARTICULO AND ID_ESTADO = '01')
SET @TIPO_CAMPANIA = (SELECT FLAG_FRASE_GANADORA FROM F_CAMPANIA WHERE CIA = @CIA AND ID_CAMPANIA = @ID_CAMPANIA AND ID_ESTADO = '01')
IF(@TIPO_CAMPANIA = '0')
BEGIN
	------------------------------------------
	SET	@TOTAL_PUNTOS = (SELECT PUNTOS_ACUMULADOS FROM F_CLIENTE_CAMPANIA WHERE CIA = @CIA AND ID_CLIENTE = @ID_CLIENTE AND ID_CAMPANIA = @ID_CAMPANIA AND ID_ESTADO = '01')
	SET @PUNTOS_CANJE = (SELECT TOTAL_PUNTOS FROM F_CAMPANIA_PREMIO WHERE CIA = @CIA AND ID_CAMPANIA = @ID_CAMPANIA AND ID_ARTICULO = @ID_ARTICULO AND ID_ESTADO = '01')
	------------------------------------------
END
ELSE
BEGIN
	------------------------------------------
	SET	@TOTAL_PUNTOS = 0
	SET @PUNTOS_CANJE = 0
	------------------------------------------
END
----------------------------------------------
----------------------------------------------
IF (@INDICADOR = '1')
BEGIN
	------------------------------------------
	SET @ITEM = ( SELECT ISNULL ((SELECT max(ITEM) FROM INVENTARIO_DET_TEMP WHERE SESION = @SESION),0) )
	IF(@ITEM > 0) BEGIN SET @ITEM = @ITEM + 1 END ELSE BEGIN SET @ITEM = 1 END
	----------------------------------------------
	SET @COUNT = ( SELECT ISNULL ((	SELECT	COUNT(*) 
									FROM	INVENTARIO_DET_TEMP 
									WHERE	SESION		= @SESION 
	
									AND		ID_ARTICULO = @ID_ARTICULO 
									AND		ID_CAMPANIA	= @ID_CAMPANIA
									AND		SEDE		= @SEDE),0))
	IF(@TIPO_CAMPANIA = 0)
	BEGIN
		----------------------------------------------
		IF((@PUNTOS_CANJE * 1) <= (@TOTAL_PUNTOS - @PUNTOS_ACUMULADOS))
		BEGIN
			----------------------------------------------
			--IF(@COUNT = 0)/*	INSERTAMOS LOS DATOS	*/
			--BEGIN
				INSERT INTO INVENTARIO_DET_TEMP	
				(
					SESION, CIA, SEDE, ITEM, ID_CAMPANIA, ID_ARTICULO, CANTIDAD, P_USADO
				)
				VALUES
				(
					@SESION, @CIA, @SEDE, @ITEM, @ID_CAMPANIA, @ID_ARTICULO, 1, @PUNTOS_CANJE
				)
			--END
			------------------------------------------
			SET	@MENSAJE_ERROR = ''
			------------------------------------------
		END
		ELSE
		BEGIN
			------------------------------------------
			SET	@MENSAJE_ERROR = 'No tiene puntos suficientes.'
			------------------------------------------
		END
		----------------------------------------------
	END
	ELSE
	BEGIN
		----------------------------------------------
		--IF(@COUNT = 0)/*	INSERTAMOS LOS DATOS	*/
		--BEGIN
			INSERT INTO INVENTARIO_DET_TEMP	
			(
				SESION, CIA, SEDE, ITEM, ID_CAMPANIA, ID_ARTICULO, CANTIDAD, P_USADO
			)
			VALUES
			(
				@SESION, @CIA, @SEDE, @ITEM, @ID_CAMPANIA, @ID_ARTICULO, 1, 0
			)
			------------------------------------------
			SET	@MENSAJE_ERROR = ''
			------------------------------------------
		--END
		----------------------------------------------
	END
	----------------------------------------------
END
----------------------------------------------
IF (@INDICADOR = '2')
BEGIN
	-------------------------------------------
	IF(@TIPO_CAMPANIA = 0)
	BEGIN
		---------------------------------------
		IF(@CANTIDAD <= @STOCK)
		BEGIN
			-----------------------------------
			IF((@PUNTOS_CANJE * @CANTIDAD) <= (@TOTAL_PUNTOS - @PUNTOS_ACUMULADOS))
			BEGIN
				-------------------------------
				UPDATE	INVENTARIO_DET_TEMP
				SET		CANTIDAD			= @CANTIDAD,
						P_USADO				= (@PUNTOS_CANJE * @CANTIDAD)
				WHERE	SESION				= @SESION
				AND		CIA					= @CIA 
				AND		SEDE				= @SEDE
				AND		ITEM				= @ITEM
				AND     ID_ARTICULO			= @ID_ARTICULO
				------------------------------------------
				SET	@MENSAJE_ERROR = ''
				------------------------------------------
			END
			ELSE
			BEGIN
				-------------------------------
				SET	@MENSAJE_ERROR = 'No tiene puntos suficientes.'
				-------------------------------
			END
			-----------------------------------
		END
		ELSE
		BEGIN
			-----------------------------------
			SET	@MENSAJE_ERROR = 'No hay Stock suficientes.'
			-----------------------------------
		END
		---------------------------------------
	END
	ELSE
	BEGIN
		---------------------------------------
		IF(@CANTIDAD <= @STOCK)
		BEGIN
			-----------------------------------
			UPDATE	INVENTARIO_DET_TEMP
			SET		CANTIDAD			= @CANTIDAD		
			WHERE	SESION				= @SESION
			AND		CIA					= @CIA 
			AND		SEDE				= @SEDE
			AND		ITEM				= @ITEM
			AND     ID_ARTICULO			= @ID_ARTICULO
			------------------------------------------
			SET	@MENSAJE_ERROR = ''
			------------------------------------------
		END
		ELSE
		BEGIN
			-----------------------------------
			SET	@MENSAJE_ERROR = 'No hay Stock suficientes.'
			-----------------------------------
		END
		---------------------------------------
	END
	-------------------------------------------
END
IF (@INDICADOR = '3')
BEGIN
	------------------------------------------
	DELETE	FROM INVENTARIO_DET_TEMP
	WHERE	SESION		= @SESION
	AND		CIA			= @CIA
	AND		SEDE		= @SEDE
	AND		ITEM		= @ITEM
	AND		ID_ARTICULO	= @ID_ARTICULO
	------------------------------------------
END
IF (@INDICADOR = '4')
BEGIN
	------------------------------------------
	DELETE	FROM INVENTARIO_DET_TEMP
	WHERE	SESION		= @SESION
	AND		CIA			= @CIA
	------------------------------------------
END
GO
/****** Object:  StoredProcedure [dbo].[SP_INVENTARIO_MOV_ELIMINAR_ENTREGA_PREMIO]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*

EXEC [SP_INVENTARIO_MOV_ELIMINAR_ENTREGA_PREMIO] '01', '02', 'NE', '0001', '00000007', '10011862573', 'ADMIN', 'WEBCANJE', 'ES'

*/
-------------------------------------------
-------------------------------------------
create	PROCEDURE	[dbo].[SP_INVENTARIO_MOV_ELIMINAR_ENTREGA_PREMIO]
@CIA				CHAR(2),
@SEDE				CHAR(2),
@ID_TIPO_DOC		CHAR(2),
@SERIE_DOC			CHAR(4),
@NRO_DOC			VARCHAR(20),
@ID_CLIENTE			VARCHAR(20),
@USUARIO			VARCHAR(10),
@AA					VARCHAR(60),
@ID_ALMACEN			CHAR(2)
AS
-------------------------------------------
DECLARE @VARMSG		VARCHAR(300)
DECLARE	@COUNT		INT
DECLARE @IDCAMPANIA	INT
DECLARE @IDARTICULO VARCHAR(20)
DECLARE @PUNTOS		INT
DECLARE	@CANTIDAD	FLOAT
DECLARE @TOTAL_DEV	FLOAT
-------------------------------------------
SET	@PUNTOS = 0
-------------------------------------------
BEGIN TRANSACTION
-------------------------------------------
UPDATE	INVENTARIO_MOV
SET		ID_ESTADO	= '12',
		FLAG_ENVIO	= '1',
		FA			= GETDATE(),
		UA			= @USUARIO,
		AA			= @AA
WHERE	CIA			= @CIA
AND		SEDE		= @SEDE
AND		ID_TIPO_DOC	= @ID_TIPO_DOC
AND		SERIE_DOC	= @SERIE_DOC
AND		NRO_DOC		= @NRO_DOC
-------------------------------------------
IF @@ERROR <> 0 OR @@ROWCOUNT <> 1
BEGIN
	---------------------------------------
	SET		@VARMSG	= 'SE PRODUJO UN ERROR DURANTE EL PROCESO DE ELIMINACION DEL INVENTARIO MOV. NO SE ELIMINO EL REGISTRO.'
	GOTO	MSGERROR
	----------------------------------------
END
--------------------------------------------
SET	@COUNT =(
				SELECT ISNULL((	
					SELECT	COUNT(*)
					FROM	INVENTARIO_MOV_DET
					WHERE	CIA			= @CIA
					AND		SEDE		= @SEDE
					AND		ID_TIPO_DOC	= @ID_TIPO_DOC
					AND		SERIE_DOC	= @SERIE_DOC
					AND		NRO_DOC		= @NRO_DOC
					),0)
			)
--------------------------------------------
UPDATE	INVENTARIO_MOV_DET
SET		ID_ESTADO	= '12',
		FLAG_ENVIO	= '1',
		FA			= GETDATE(),
		UA			= @USUARIO,
		AA			= @AA
WHERE	CIA			= @CIA
AND		SEDE		= @SEDE
AND		ID_TIPO_DOC	= @ID_TIPO_DOC
AND		SERIE_DOC	= @SERIE_DOC
AND		NRO_DOC		= @NRO_DOC
IF @@ERROR <> 0 OR @@ROWCOUNT < @COUNT
BEGIN
	---------------------------------------
	SET		@VARMSG	= 'SE PRODUJO UN ERROR DURANTE EL PROCESO DE ELIMINACION DEL INVENTARIO MOV DET. NO SE GRABARON LOS DATOS.'
	GOTO	MSGERROR
	----------------------------------------
END
--------------------------------------------
/*	ACTUALIZACION DE STOCK	*/
UPDATE	EX_S
SET		EX_S.CANT_DISPONIBLE = (EX_S.CANT_DISPONIBLE + IMD.CANTIDAD)
FROM	EXISTENCIA_SEDE EX_S 
INNER JOIN INVENTARIO_MOV_DET IMD ON EX_S.CIA = IMD.CIA AND EX_S.SEDE = IMD.SEDE AND EX_S.ID_ARTICULO = IMD.ID_ARTICULO
WHERE	EX_S.CIA		= @CIA
AND		EX_S.SEDE		= @SEDE
AND		IMD.ID_TIPO_DOC= @ID_TIPO_DOC
AND		IMD.SERIE_DOC	= @SERIE_DOC
AND		IMD.NRO_DOC	= @NRO_DOC

UPDATE	EX_A
SET		EX_A.CANT_DISPONIBLE = (EX_A.CANT_DISPONIBLE + IMD.CANTIDAD)
FROM	EXISTENCIA_ALMACEN EX_A 
INNER JOIN INVENTARIO_MOV_DET IMD ON EX_A.CIA = IMD.CIA AND EX_A.SEDE = IMD.SEDE AND EX_A.ID_ARTICULO = IMD.ID_ARTICULO
WHERE	EX_A.CIA		= @CIA
AND		EX_A.SEDE		= @SEDE
AND		EX_A.ID_ALMACEN	= @ID_ALMACEN
AND		IMD.ID_TIPO_DOC	= @ID_TIPO_DOC
AND		IMD.SERIE_DOC	= @SERIE_DOC
AND		IMD.NRO_DOC		= @NRO_DOC
--------------------------------------------
/*	DEVOLUCION DE PUNTOS	*/
UPDATE	FCC
SET		FCC.PUNTOS_ACUMULADOS = (FCC.PUNTOS_ACUMULADOS + (IMD.CANTIDAD * FCP.TOTAL_PUNTOS))
FROM	F_CLIENTE_CAMPANIA FCC
INNER JOIN INVENTARIO_MOV_DET IMD ON FCC.CIA = IMD.CIA AND FCC.ID_CAMPANIA = IMD.ID_CAMPANIA
INNER JOIN F_CAMPANIA_PREMIO AS FCP ON IMD.CIA = FCP.CIA AND IMD.ID_ARTICULO = FCP.ID_ARTICULO AND IMD.ID_CAMPANIA = FCP.ID_CAMPANIA 
INNER JOIN F_CAMPANIA AS FC ON FCP.CIA = FC.CIA AND FCP.ID_CAMPANIA = FC.ID_CAMPANIA
WHERE	FC.FLAG_FRASE_GANADORA	= '0'
AND		IMD.CIA			= @CIA
AND		IMD.SEDE		= @SEDE
AND		IMD.ID_TIPO_DOC	= @ID_TIPO_DOC
AND		IMD.SERIE_DOC	= @SERIE_DOC
AND		IMD.NRO_DOC		= @NRO_DOC
--------------------------------------------
--DECLARE CURSOR_PUNTOS CURSOR FOR
--	SELECT	INVENTARIO_MOV_DET.ID_CAMPANIA,
--			INVENTARIO_MOV_DET.ID_ARTICULO
--	FROM	INVENTARIO_MOV_DET 
--	INNER JOIN F_CAMPANIA ON INVENTARIO_MOV_DET.CIA = F_CAMPANIA.CIA AND INVENTARIO_MOV_DET.ID_CAMPANIA = F_CAMPANIA.ID_CAMPANIA
--	WHERE	F_CAMPANIA.FLAG_FRASE_GANADORA	= '0'
--	AND		INVENTARIO_MOV_DET.CIA			= @CIA
--	AND		INVENTARIO_MOV_DET.SEDE			= @SEDE
--	AND		INVENTARIO_MOV_DET.ID_TIPO_DOC	= @ID_TIPO_DOC
--	AND		INVENTARIO_MOV_DET.SERIE_DOC	= @SERIE_DOC
--	AND		INVENTARIO_MOV_DET.NRO_DOC		= @NRO_DOC
--OPEN CURSOR_PUNTOS
--FETCH NEXT FROM CURSOR_PUNTOS
--INTO @IDCAMPANIA, @IDARTICULO
--WHILE @@FETCH_STATUS = 0
--BEGIN
--	----------------------------------------
--	SET	@PUNTOS		= (	SELECT ISNULL((SELECT TOTAL_PUNTOS FROM F_CAMPANIA_PREMIO WHERE CIA = @CIA AND ID_CAMPANIA = @IDCAMPANIA AND ID_ARTICULO = @IDARTICULO),0))
--	SET	@CANTIDAD	= (	SELECT ISNULL((SELECT CANTIDAD FROM INVENTARIO_MOV_DET WHERE CIA = @CIA AND INVENTARIO_MOV_DET.SEDE = @SEDE AND ID_CAMPANIA = @IDCAMPANIA AND ID_ARTICULO = @IDARTICULO AND	INVENTARIO_MOV_DET.ID_TIPO_DOC	= @ID_TIPO_DOC AND INVENTARIO_MOV_DET.SERIE_DOC	= @SERIE_DOC AND INVENTARIO_MOV_DET.NRO_DOC = @NRO_DOC),0))
--	SET @TOTAL_DEV  = @PUNTOS * @CANTIDAD
--	/*  TABLA DE PUNTOS ACUMULADOS  */
--	UPDATE	F_CLIENTE_CAMPANIA
--	SET		PUNTOS_ACUMULADOS = PUNTOS_ACUMULADOS + @TOTAL_DEV
--	WHERE	CIA			= @CIA
--	AND		ID_CLIENTE	= @ID_CLIENTE
--	AND		ID_CAMPANIA = @IDCAMPANIA
--	----------------------------------------
--	FETCH NEXT FROM CURSOR_PUNTOS 
--	INTO @IDCAMPANIA, @IDARTICULO
--	----------------------------------------
--END
--CLOSE CURSOR_PUNTOS
--DEALLOCATE CURSOR_PUNTOS
--------------------------------------------
COMMIT TRANSACTION
--------------------------------------------
RETURN
MSGERROR:
		ROLLBACK TRANSACTION
		------------------------------------
		RAISERROR	(@VARMSG, 15, 1)
		RETURN
GO
/****** Object:  StoredProcedure [dbo].[SP_INVENTARIO_MOV_INSERTAR_ENTREGA_PREMIO]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*

EXEC [SP_INVENTARIO_MOV_INSERTAR_ENTREGA_PREMIO] '5f5e0e62-5dd7-4ae6-b2b4-2d99a11a31db', '01', '02', 'NE', '0001', '', 'EE', '01', '10046307581',
													'0', 'ADMIN'

SELECT * FROM F_CLIENTE_CAMPANIA

SELECT * FROM INVENTARIO_DET_TEMP

*/
-------------------------------------------
-------------------------------------------
create	PROCEDURE	[dbo].[SP_INVENTARIO_MOV_INSERTAR_ENTREGA_PREMIO]
@SESION				VARCHAR(100),
@CIA				CHAR(2),
@SEDE				CHAR(2),
@ID_TIPO_DOC		CHAR(2),
@SERIE_DOC			CHAR(4),
@NRO_DOC			VARCHAR(20),
@ID_MOTIVO_ALMACEN	CHAR(2),
@ID_ALMACEN			CHAR(2),
@ID_ANALITICA		VARCHAR(20),
@FLAG_INGRESO		CHAR(1), -- 0 = SI ES SALIDA, 1 = SI ES ENTRADA
@USUARIO			VARCHAR(10)
AS
-------------------------------------------
DECLARE @VARMSG		VARCHAR(300)
DECLARE	@COUNT		INT
-------------------------------------------
/*	OBTENEMOS EL CORRELATIVO DEL DOCUMENTO	*/
SET	@NRO_DOC	=	(	SELECT	ISNULL((SELECT	(REPLICATE('0',(8 - LEN(CORRELATIVO + 1))) + CONVERT(VARCHAR(8),(CORRELATIVO + 1)))
						FROM	TIPO_DOCUMENTO_SERIE
						WHERE	CIA			= @CIA
						AND		ID_TIPO_DOC	= @ID_TIPO_DOC
						AND		SERIE		= @SERIE_DOC
						AND		ID_ESTADO	= '01'),'00000001')
					)
-------------------------------------------
BEGIN TRANSACTION
	-------------------------------------------
	INSERT	INTO INVENTARIO_MOV
	(
		CIA, SEDE, ID_TIPO_DOC, SERIE_DOC, NRO_DOC, ID_MOTIVO_ALMACEN, FECHA, ID_MONEDA, ID_ALMACEN, ID_ANALITICA, FLAG_INGRESO, ID_MODULO, 
		ANIO, MES, ID_ESTADO, FLAG_ENVIO, SE, FE, UE, FC, UC, TIPO_CAMBIO
	)
	VALUES
	(
		@CIA, @SEDE, @ID_TIPO_DOC, @SERIE_DOC, @NRO_DOC, @ID_MOTIVO_ALMACEN, GETDATE(), '01', @ID_ALMACEN, @ID_ANALITICA, @FLAG_INGRESO, 'FI',
		YEAR(GETDATE()), MONTH(GETDATE()), '11', '1', @SEDE, GETDATE(), @USUARIO, GETDATE(), @USUARIO, '1'
	)
	IF @@ERROR <> 0 OR @@ROWCOUNT <> 1
	BEGIN
		---------------------------------------
		SET		@VARMSG	= 'SE PRODUJO UN ERROR DURANTE EL PROCESO DE GRABACION DE LA NOTA SALIDA. NO SE GRABARON LOS DATOS.'
		GOTO	MSGERROR
		----------------------------------------
	END
	--------------------------------------------
	SET	@COUNT =(
					SELECT ISNULL((	
						SELECT	COUNT(*)
						FROM	INVENTARIO_DET_TEMP
						WHERE	SESION	= @SESION
						AND		CIA		= @CIA
						),0)
				)
	--------------------------------------------
	INSERT INTO INVENTARIO_MOV_DET
	(
		CIA, SEDE, ID_TIPO_DOC, SERIE_DOC, NRO_DOC, ITEM, ITEM_DIGITADO, ID_ARTICULO, CANTIDAD, CANTIDAD_USADA, ID_ESTADO, FLAG_ENVIO,
		SE, FE, UE, FC, UC, ID_CAMPANIA
	)
	SELECT	CIA, SEDE, @ID_TIPO_DOC, @SERIE_DOC, @NRO_DOC, ITEM, ITEM, ID_ARTICULO, CANTIDAD, 0, '11', '1', 
			SEDE, GETDATE(), @USUARIO, GETDATE(), @USUARIO, ID_CAMPANIA
	FROM	INVENTARIO_DET_TEMP
	WHERE	SESION = @SESION
	AND		CIA		= @CIA
	-------------------------------------------
	IF @@ERROR <> 0 OR @@ROWCOUNT < @COUNT
	BEGIN
		---------------------------------------
		SET		@VARMSG	= 'SE PRODUJO UN ERROR DURANTE EL PROCESO DE GRABACION DEL INVENTARIO MOV DET. NO SE GRABARON LOS DATOS.'
		GOTO	MSGERROR
		----------------------------------------
	END
	--------------------------------------------
	/*	ACTUALIZAMOS EL STOCK	*/
	UPDATE	EX_S
	SET		EX_S.CANT_DISPONIBLE = (EX_S.CANT_DISPONIBLE - IDT.CANTIDAD)
	FROM	EXISTENCIA_SEDE EX_S 
	INNER JOIN INVENTARIO_DET_TEMP IDT ON EX_S.CIA	= IDT.CIA AND EX_S.SEDE = IDT.SEDE AND EX_S.ID_ARTICULO = IDT.ID_ARTICULO
	WHERE	EX_S.CIA	= @CIA
	AND		EX_S.SEDE	= @SEDE
	AND		IDT.SESION	= @SESION
	
	UPDATE	EX_A
	SET		EX_A.CANT_DISPONIBLE = (EX_A.CANT_DISPONIBLE - IDT.CANTIDAD)
	FROM	EXISTENCIA_ALMACEN EX_A 
	INNER JOIN INVENTARIO_DET_TEMP IDT ON EX_A.CIA	= IDT.CIA AND EX_A.SEDE = IDT.SEDE AND EX_A.ID_ARTICULO = IDT.ID_ARTICULO
	WHERE	EX_A.CIA		= @CIA
	AND		EX_A.SEDE		= @SEDE
	AND		EX_A.ID_ALMACEN	= @ID_ALMACEN
	AND		IDT.SESION		= @SESION
	
	UPDATE	TIPO_DOCUMENTO_SERIE
	SET		CORRELATIVO = CONVERT(INT,@NRO_DOC)
	WHERE	CIA			= @CIA
	AND		ID_TIPO_DOC	= @ID_TIPO_DOC
	AND		SERIE		= @SERIE_DOC
	--------------------------------------------
	/*	DESCONTAR PUNTOS AL CLIENTE	*/
	UPDATE	FCC
	SET		FCC.PUNTOS_ACUMULADOS = (FCC.PUNTOS_ACUMULADOS - IDT.P_USADO)
	FROM	F_CLIENTE_CAMPANIA FCC
	INNER JOIN INVENTARIO_DET_TEMP IDT ON FCC.CIA = IDT.CIA AND FCC.ID_CAMPANIA = IDT.ID_CAMPANIA
	INNER JOIN F_CAMPANIA FC ON IDT.CIA = FC.CIA AND IDT.ID_CAMPANIA = FC.ID_CAMPANIA
	WHERE	FCC.CIA					= @CIA
	AND		IDT.SESION				= @SESION
	AND		FC.FLAG_FRASE_GANADORA	= '0'
	--------------------------------------------
	DELETE	FROM INVENTARIO_DET_TEMP
	WHERE	SESION	= @SESION
	AND		CIA		= @CIA
--------------------------------------------
COMMIT TRANSACTION
--------------------------------------------
RETURN
MSGERROR:
		ROLLBACK TRANSACTION
		------------------------------------
		RAISERROR	(@VARMSG, 15, 1)
		RETURN
GO
/****** Object:  StoredProcedure [dbo].[SP_INVENTARIO_MOV_TRAER_DETALLE]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*

SELECT * FROM INVENTARIO_MOV_DET

*/
-------------------------------------------------
-------------------------------------------------
create	PROCEDURE [dbo].[SP_INVENTARIO_MOV_TRAER_DETALLE]
@CIA			CHAR(2),
@SEDE			CHAR(2),
@ID_TIPO_DOC	CHAR(2),
@SERIE_DOC		CHAR(4),
@NRO_DOC		VARCHAR(10)
AS
-------------------------------------------------
-------------------------------------------------
SELECT	IMD.ITEM, ART.ID_ARTICULO, ART.NRO_PARTE, ART.DESCRIPCION, IMD.CANTIDAD, IMD.STOCK AS 'P_USADO', IMD.ID_CAMPANIA
FROM	INVENTARIO_MOV_DET AS IMD 
INNER JOIN ARTICULO AS ART ON IMD.CIA = ART.CIA AND IMD.CIA = ART.CIA AND IMD.ID_ARTICULO = ART.ID_ARTICULO
WHERE	IMD.CIA			= @CIA
AND		IMD.SEDE		= @SEDE
AND		IMD.ID_TIPO_DOC	= @ID_TIPO_DOC
AND		IMD.SERIE_DOC	= @SERIE_DOC
AND		IMD.NRO_DOC		= @NRO_DOC
GO
/****** Object:  StoredProcedure [dbo].[SP_INVENTARIO_MOV_TRAER_NOTA]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*

SELECT * FROM INVENTARIO_MOV

*/
---------------------------------------------
---------------------------------------------
create	PROCEDURE	[dbo].[SP_INVENTARIO_MOV_TRAER_NOTA]
@CIA			CHAR(2),
@SEDE			CHAR(2),
@ID_TIPO_DOC	CHAR(2),
@SERIE_DOC		CHAR(4),
@NRO_DOC		VARCHAR(10)
AS
---------------------------------------------
---------------------------------------------
SELECT	CIA, SEDE, ID_TIPO_DOC, SERIE_DOC, NRO_DOC, ID_MOTIVO_ALMACEN, CONVERT(VARCHAR(10),FECHA,103) AS 'FECHA', ID_ALMACEN, ID_ANALITICA, ID_ESTADO
FROM	INVENTARIO_MOV
WHERE	CIA			= @CIA
AND		SEDE		= @SEDE
AND		ID_TIPO_DOC	= @ID_TIPO_DOC
AND		SERIE_DOC	= @SERIE_DOC
AND		NRO_DOC		= @NRO_DOC
GO
/****** Object:  StoredProcedure [dbo].[SP_INVENTARIO_MOV_TRAER_TODOS]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*

EXEC [SP_INVENTARIO_MOV_TRAER_TODOS] '01', '02', '', '', '', '%', '2010-08-22', '2010-08-26'

SELECT * FROM INVENTARIO_MOV

*/
------------------------------------------
------------------------------------------
create	PROCEDURE	[dbo].[SP_INVENTARIO_MOV_TRAER_TODOS]
@CIA			CHAR(2),
@SEDE			CHAR(2),
@NRO_DOC		VARCHAR(20),
@SERIE_DOC		VARCHAR(2),
@DESCRIP_CLI	VARCHAR(50),
@FECHA1			VARCHAR(12),
@FECHA2			VARCHAR(12),
@ID_ESTADO		VARCHAR(2)
AS
--------------------------------------
DECLARE @FECHA_1 DATETIME
DECLARE @FECHA_2 DATETIME
--------------------------------------
SET	@FECHA_1 = CONVERT(DATETIME,@FECHA1)
SET	@FECHA_2 = CONVERT(DATETIME,@FECHA2)
--------------------------------------
SELECT	TIPO_DOCUMENTO.ID_TIPO_DOC, INVENTARIO_MOV.SERIE_DOC, INVENTARIO_MOV.NRO_DOC, INVENTARIO_MOV.SERIE_DOC + '-' + INVENTARIO_MOV.NRO_DOC AS 'NUMERO-DOC', TIPO_DOCUMENTO.DESCRIPCION AS 'TIPO-DOC',
		SEDE.DESCRIPCION AS 'SEDE', ANALITICA.DESCRIPCION AS 'CLIENTE', ESTADO.ABREVIATURA AS 'ESTADO'
FROM	INVENTARIO_MOV 
INNER JOIN SEDE ON INVENTARIO_MOV.CIA = SEDE.CIA AND INVENTARIO_MOV.CIA = SEDE.CIA AND INVENTARIO_MOV.CIA = SEDE.CIA AND INVENTARIO_MOV.SEDE = SEDE.SEDE AND INVENTARIO_MOV.SEDE = SEDE.SEDE 
INNER JOIN TIPO_DOCUMENTO ON INVENTARIO_MOV.CIA = TIPO_DOCUMENTO.CIA AND INVENTARIO_MOV.CIA = TIPO_DOCUMENTO.CIA AND INVENTARIO_MOV.CIA = TIPO_DOCUMENTO.CIA AND INVENTARIO_MOV.CIA = TIPO_DOCUMENTO.CIA AND INVENTARIO_MOV.ID_TIPO_DOC = TIPO_DOCUMENTO.ID_TIPO_DOC AND INVENTARIO_MOV.ID_TIPO_DOC = TIPO_DOCUMENTO.ID_TIPO_DOC 
INNER JOIN ANALITICA ON INVENTARIO_MOV.CIA = ANALITICA.CIA AND INVENTARIO_MOV.CIA = ANALITICA.CIA AND INVENTARIO_MOV.CIA = ANALITICA.CIA AND INVENTARIO_MOV.CIA = ANALITICA.CIA AND INVENTARIO_MOV.ID_ANALITICA = ANALITICA.ID_ANALITICA AND INVENTARIO_MOV.ID_ANALITICA = ANALITICA.ID_ANALITICA
INNER JOIN ESTADO ON INVENTARIO_MOV.CIA = ESTADO.CIA AND INVENTARIO_MOV.ID_ESTADO = ESTADO.ID_ESTADO
WHERE	INVENTARIO_MOV.ID_TIPO_DOC	= 'NE'
AND		INVENTARIO_MOV.CIA			= @CIA
AND		SEDE.SEDE					= @SEDE
AND		INVENTARIO_MOV.NRO_DOC		LIKE  CASE WHEN LEN(@NRO_DOC)> 0 THEN '%' + @NRO_DOC + '%' ELSE '%' END
AND		INVENTARIO_MOV.SERIE_DOC	LIKE  CASE WHEN LEN(@SERIE_DOC) > 0 THEN '%' + @SERIE_DOC + '%' ELSE '%' END
AND		ANALITICA.DESCRIPCION		LIKE  CASE WHEN LEN(@DESCRIP_CLI) > 0 THEN '%' + @DESCRIP_CLI + '%' ELSE '%' END
AND		INVENTARIO_MOV.ID_ESTADO	LIKE  '%' + @ID_ESTADO + '%'
AND		CONVERT(VARCHAR(8),INVENTARIO_MOV.FECHA,112) >= CONVERT(VARCHAR(8),@FECHA_1,112)
AND		CONVERT(VARCHAR(8),INVENTARIO_MOV.FECHA,112) <= CONVERT(VARCHAR(8),@FECHA_2,112)
GO
/****** Object:  StoredProcedure [dbo].[SP_Lista_E_VENTA_DOCUMENTO]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[SP_Lista_E_VENTA_DOCUMENTO] 
as
SELECT Edv.Cia, 
		Edv.Sede,
		Edv.Id_Venta,
		Edv.Id_Tipo_Doc,
		Edv.Serie_Doc,
		Edv.Nro_Doc,
		Edv.Ruc, 
		Edv.ID_Cliente,
		UE,
		FechaCreacion=convert(varchar(30),FC,103)	
FROM E_VENTA_DOCUMENTO Edv
GO
/****** Object:  StoredProcedure [dbo].[SP_LISTAR_ACCESO]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
select flag_web,* from netdat.dbo.acceso where flag_web='1'
select * from acceso where id_acceso LIKE ('86%') AND ID_ESTADO ='01'
select * from acceso where id_acceso LIKE ('8920%') AND ID_ESTADO ='01'
select * from acceso where id_acceso LIKE ('8930%') AND ID_ESTADO ='01'

SP_LISTAR_ACCESO '86','',''
*/
CREATE PROC [dbo].[SP_LISTAR_ACCESO]
@id_acceso VARCHAR(30),@descripcion varchar(50),@nombre_exe VARCHAR(30)
AS
----------------------------------------------------------------------------------
DECLARE @sSelect varchar(MAX),@sFiltroID VARCHAR(MAX),@sFiltroDescripcion varchar(MAX),
	@sOrderBy varchar(MAX),@sGroupBy varchar(MAX),@sExecute varchar(MAX)
SELECT @sSelect='',@sFiltroID='',@sFiltroDescripcion='',@sOrderBy='',@sGroupBy='',@sExecute=''
-------------------------------------------------------------------------
	SELECT @sSelect='
	id_acceso,descripcion,descripcion_corta,nombre_exe,id_acceso_superior,
	orden,id_estado,uc,fc=convert(varchar(30),fc,103),flag_web
	 from acceso a 
	 WHERE	id_estado=''01'' and id_acceso like '''+@id_acceso+''' +''%'' '
	SELECT @sExecute = @sSelect 
 	PRINT @sExecute
	EXEC ('SELECT '+ @sExecute )
GO
/****** Object:  StoredProcedure [dbo].[SP_LISTAR_ALMACEN]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
sp_help almacen
[SP_LISTAR_ALMACEN] '1','01','01','ES',''
[SP_LISTAR_ALMACEN] '2','01','01','ES',''
select * from almacen WHERE cia='01' AND sede='01' AND ID_ALMACEN='es'
*/
CREATE PROCEDURE [dbo].[SP_LISTAR_ALMACEN]
@INDICADOR CHAR(1),@CIA  CHAR(2),@sede  CHAR(2),@ID_ALMACEN	CHAR(2),@DESCRIPCION VARCHAR(2)
AS
-----------------------------------------------------------------------------------------------------------------------
DECLARE @sOrderBy varchar(MAX), @sGroupBy varchar(MAX), @sExecute varchar(MAX),@sSelect varchar(MAX),
	@sFiltroAlmacen varchar(MAX),@sFiltroDescripcion varchar(MAX),@sFiltroEstado varchar(MAX)
SELECT @sSelect='',  @sFiltroAlmacen='', @sFiltroDescripcion ='', @sFiltroEstado ='',@sOrderBy='',@sGroupBy='',@sExecute=''
-----------------------------------------------------------------------------------------------------------------
IF(@INDICADOR='1')
BEGIN
	SELECT @sSelect= ' a.id_almacen, UPPER(a.descripcion) ''descripcion'',a.direccion	FROM almacen a	
			WHERE a.CIA='''+@CIA+''' and 	a.sede='''+@sede+''' 	'
	--------------------------------------------------------------------------------------------
	IF  LEN(ISNULL(@ID_ALMACEN,''))>0 AND  @ID_ALMACEN<>'%' 
			BEGIN    SELECT @sFiltroAlmacen	=' and a.id_almacen in('''+@ID_ALMACEN+''')' 	 END
	ELSE	BEGIN    SELECT @sFiltroAlmacen	=''	END
		--------------------------------------------------------------------------------------------
	IF  LEN(ISNULL(@DESCRIPCION,''))>0 
			BEGIN    SELECT @sFiltroDescripcion	=' and a.descripcion like '''+@DESCRIPCION+''' +''%'' ' END
	ELSE	BEGIN    SELECT @sFiltroDescripcion	=''	END
	SELECT @sOrderBy	=' order by  a.id_almacen'
	---------------------------------------------------------------------------------------------
	SELECT @sExecute = @sSelect +''+  @sFiltroAlmacen+''+ @sFiltroDescripcion +''+ @sOrderBy
 	PRINT @sExecute
	EXEC ('SELECT '+ @sExecute )	 
END
-----------------------------------------------------------------------------------------------------------------
IF(@INDICADOR='2')
BEGIN
	SELECT @sSelect= ' a.id_almacen, UPPER(a.descripcion) ''descripcion''	FROM almacen a	
		WHERE a.CIA='''+@CIA+''' and 	a.sede='''+@sede+''' 	'
	--------------------------------------------------------------------------------------------
	IF  LEN(ISNULL(@ID_ALMACEN,''))>0 AND  @ID_ALMACEN<>'%' 
			BEGIN    SELECT @sFiltroAlmacen	=' and a.id_almacen in('''+@ID_ALMACEN+''')' 	 END
	ELSE	BEGIN    SELECT @sFiltroAlmacen	=''	END
		--------------------------------------------------------------------------------------------
	IF  LEN(ISNULL(@DESCRIPCION,''))>0 
			BEGIN    SELECT @sFiltroDescripcion	=' and a.descripcion like '''+@DESCRIPCION+''' +''%'' ' END
	ELSE	BEGIN    SELECT @sFiltroDescripcion	=''	END
	SELECT @sOrderBy	=' order by  a.id_almacen'
	---------------------------------------------------------------------------------------------
	SELECT @sExecute = @sSelect +''+  @sFiltroAlmacen+''+ @sFiltroDescripcion +''+ @sOrderBy
 	PRINT @sExecute
	EXEC ('SELECT '+ @sExecute ) 
END
GO
/****** Object:  StoredProcedure [dbo].[SP_LISTAR_ANALITICA]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
SP_LISTAR_ANALITICA '1','01','01','',''
SP_LISTAR_ANALITICA '2','01','01','',''
SP_LISTAR_ANALITICA '2','01','03','',''
SP_LISTAR_ANALITICA '3','01','01','',''
SP_LISTAR_ANALITICA '3','01','08','',''
SP_HELP ANALITICA_TIPO
SELECT * FROM ESTADO
SELECT DISTINCT(ID_CLIENTE) FROM CLIENTE_VEHICULO
SELECT * FROM analitica			WHERE ID_ANALITICA='42476689'
SELECT * FROM analitica_TIPO WHERE ID_TIPO_ANALITICA='02'
SELECT * FROM TIPO_ANALITICA  WHERE ID_TIPO_ANALITICA in('02')
SELECT * FROM TIPO_ANALITICA  WHERE ID_TIPO_ANALITICA='02'

select * from usuario
*/
CREATE	PROC	[dbo].[SP_LISTAR_ANALITICA]
@INDICADOR CHAR(1),@CIA CHAR(2),@ID_TIPO_ANALITICA	CHAR(2),@ID_ANALITICA VARCHAR(20),@descripcion VARCHAR(100)
AS
-----------------------------------------------------------------------------------------------------------------------
DECLARE @FECHA1 VARCHAR(8),@FECHA2 VARCHAR(8), @sSelect varchar(MAX),@sFiltroID varchar(MAX), @sFiltroCliente varchar(MAX),
@sFiltroTipoPersona varchar(MAX),@sFiltroPais varchar(MAX),@sFiltroDep varchar(MAX), @sFiltroProv varchar(MAX),
@sFiltroDist varchar(MAX),@sOrderBy varchar(MAX), @sGroupBy varchar(MAX), @sExecute varchar(MAX),@sNotFiltroID varchar(MAX), @sGroup varchar(MAX)
----------------------------------------------------------------------------------------------------------------------
SELECT @sSelect='', @sFiltroID='', @sFiltroCliente='', @sFiltroTipoPersona='',@sFiltroPais='',@sFiltroDep='',@sFiltroProv='',@sFiltroDist='',@sOrderBy='',@sGroupBy='',@sExecute='', @sNotFiltroID='',@sGroup=''
-----------------------------------------------------------------------------------------------------------------
IF(@INDICADOR='1')		/*	CLIENTE VEHICULO	*/
BEGIN
	SELECT @sSelect='
	A.id_analitica ,ltrim(A.descripcion) ''descripcion'',
	case flag_tipo_persona	when ''0'' then ''JURIDICA'' else ''NATURAL''	end as	''tipo_persona''	,
	p.id_pais ''idpais'',p.descripcion as ''despais'',u.id_dpto ''iddpto'',u.des_dpto ''desdpto'',
	u.id_provincia ''idprov'',u.des_provincia ''desprov'',u.id_distrito ''iddis'',u.des_distrito ''desdis'',a.direccion,A.telefono ''telefono'',
	case AT.FLAG_CON_CONTRATO	when ''0'' then ''NO CONTRATADO'' else ''CONTRATADO''	end as ''contrato'',at.flag_con_contrato ''flag_con_contrato''
	from	analitica A
	INNER JOIN ESTADO E ON E.CIA=A.CIA AND E.ID_ESTADO=A.ID_ESTADO
	INNER JOIN ANALITICA_TIPO AT ON at.cia=a.cia AND at.id_analitica=a.id_analitica 
	INNER JOIN TIPO_ANALITICA TA ON ta.cia=at.cia AND ta.id_tipo_analitica=at.id_tipo_analitica
	INNER JOIN CLIENTE_VEHICULO CV ON CV.CIA=A.CIA AND CV.ID_CLIENTE=A.ID_ANALITICA
	INNER JOIN PAIS P ON p.cia=a.cia and p.id_pais=a.id_pais
	INNER JOIN UBICACION U on u.cia=a.cia and u.id_pais=a.id_pais and u.id_dpto=a.id_dpto 
			and u.id_provincia=a.id_provincia and u.id_distrito=a.id_distrito
	WHERE	A.CIA= '''+@CIA+'''	AND A.ID_ESTADO=''01'' AND TA.ID_TIPO_ANALITICA='''+@ID_TIPO_ANALITICA+''''
	select @sGroupBy=' group by
	A.id_analitica ,A.descripcion ,flag_tipo_persona,p.id_pais ,p.descripcion  ,u.id_dpto ,u.des_dpto ,
	u.id_provincia ,u.des_provincia ,u.id_distrito ,u.des_distrito ,a.direccion,A.telefono , at.flag_con_contrato,at.flag_con_contrato	'
	------------------------------------------------------------------------------------------------------------------
	IF  LEN(ISNULL(@ID_ANALITICA,''))>0	BEGIN   SELECT @sFiltroID   =' and a.id_analitica = '''+@ID_ANALITICA+'''  '	 END
	ELSE								BEGIN   SELECT @sFiltroID	=''	END
	--------------------------------------------------------------------------------------------
	IF  LEN(ISNULL(@descripcion,''))>0 	BEGIN   SELECT @sFiltroCliente	=' and a.descripcion like ''%''+'''+@descripcion+''' +''%'' '	 END
	ELSE								BEGIN   SELECT @sFiltroCliente	=''	END	
	--------------------------------------------------------------------------------------------
	SELECT @sOrderBy	=' order by  a.descripcion'
	---------------------------------------------------------------------------------------------
	 SELECT @sExecute = @sSelect +''+ @sFiltroID +''+ @sFiltroCliente+''+  @sGroupBy +''+@sOrderBy
 	PRINT @sExecute
	 EXEC ('SELECT '+ @sExecute )	 
 	--------------------------------------------------------------------------------------------
END
IF(@INDICADOR='2')
BEGIN
	SELECT @sSelect='
	A.id_analitica ,ltrim(A.descripcion) ''descripcion'',
	case flag_tipo_persona	when ''0'' then ''JURIDICA'' else ''NATURAL''	end as	''tipo_persona''	,
	p.id_pais ''idpais'',p.descripcion as ''despais'',u.id_dpto ''iddpto'',u.des_dpto ''desdpto'',
	u.id_provincia ''idprov'',u.des_provincia ''desprov'',u.id_distrito ''iddis'',u.des_distrito ''desdis'',a.direccion,A.telefono ''telefono''
	from	analitica A
	INNER JOIN ESTADO E ON E.CIA=A.CIA AND E.ID_ESTADO=A.ID_ESTADO
	INNER JOIN ANALITICA_TIPO AT ON at.cia=a.cia AND at.id_analitica=a.id_analitica 
	INNER JOIN TIPO_ANALITICA TA ON ta.cia=at.cia AND ta.id_tipo_analitica=at.id_tipo_analitica	
	LEFT JOIN PAIS P ON p.cia=a.cia and p.id_pais=a.id_pais
	LEFT JOIN UBICACION U on u.cia=a.cia and u.id_pais=a.id_pais and u.id_dpto=a.id_dpto 
			and u.id_provincia=a.id_provincia and u.id_distrito=a.id_distrito
	WHERE	A.CIA= '''+@CIA+'''	AND A.ID_ESTADO=''01'' AND TA.ID_TIPO_ANALITICA='''+@ID_TIPO_ANALITICA+''''
	------------------------------------------------------------------------------------------------------------------
	IF  LEN(ISNULL(@ID_ANALITICA,''))>0	BEGIN    SELECT @sFiltroID	=' and a.id_analitica='''+@ID_ANALITICA+''''	 END
	ELSE								BEGIN    SELECT @sFiltroID	=''	END
	--------------------------------------------------------------------------------------------
	IF  LEN(ISNULL(@descripcion,''))>0 BEGIN   SELECT @sFiltroCliente=' and a.descripcion='''+@descripcion+''''	 END
	ELSE							   BEGIN   SELECT @sFiltroCliente	='' 	END	
	--------------------------------------------------------------------------------------------
	SELECT @sOrderBy	=' order by  a.descripcion'
	---------------------------------------------------------------------------------------------
	SELECT @sExecute = @sSelect +''+ @sFiltroID +''+ @sFiltroCliente+''+  @sOrderBy
 	PRINT @sExecute
	EXEC ('SELECT '+ @sExecute )	 
 	--------------------------------------------------------------------------------------------
END
---------------------------------------------------------------------------------------------------------------
IF(@INDICADOR='3')
BEGIN
	SELECT @sSelect='	A.id_analitica ,LTRIM(A.descripcion) ''descripcion''	from	analitica A
	INNER JOIN ESTADO E ON E.CIA=A.CIA AND E.ID_ESTADO=A.ID_ESTADO
	INNER JOIN ANALITICA_TIPO AT ON at.cia=a.cia AND at.id_analitica=a.id_analitica 
	INNER JOIN TIPO_ANALITICA TA ON ta.cia=at.cia AND ta.id_tipo_analitica=at.id_tipo_analitica	
	LEFT JOIN PAIS P ON p.cia=a.cia and p.id_pais=a.id_pais
	LEFT JOIN UBICACION U on u.cia=a.cia and u.id_pais=a.id_pais and u.id_dpto=a.id_dpto 
			and u.id_provincia=a.id_provincia and u.id_distrito=a.id_distrito
	WHERE	A.CIA= '''+@CIA+'''	AND A.ID_ESTADO=''01'' AND TA.ID_TIPO_ANALITICA='''+@ID_TIPO_ANALITICA+''''
	------------------------------------------------------------------------------------------------------------------
	IF  LEN(ISNULL(@ID_ANALITICA,''))>0  AND  @ID_ANALITICA<>'%' 
			BEGIN    SELECT @sFiltroID	=' and a.id_analitica='''+@ID_ANALITICA+''''	 END
	ELSE	BEGIN    SELECT @sFiltroID	=''	END
	--------------------------------------------------------------------------------------------
	SELECT @sOrderBy	=' order by  a.descripcion'
	---------------------------------------------------------------------------------------------
	SELECT @sExecute = @sSelect +''+ @sFiltroID +''+  @sOrderBy
 	PRINT @sExecute
	EXEC ('SELECT '+ @sExecute )	 
 	--------------------------------------------------------------------------------------------
END
IF(@INDICADOR='4')	/*		CLIENTE VEHICULO */
BEGIN
	SELECT @sSelect='	A.id_analitica ,LTRIM(A.descripcion) ''descripcion''	from	analitica A
	INNER JOIN ANALITICA_TIPO AT ON at.cia=a.cia AND at.id_analitica=a.id_analitica 
	INNER JOIN TIPO_ANALITICA TA ON ta.cia=at.cia AND ta.id_tipo_analitica=at.id_tipo_analitica	
	INNER JOIN CLIENTE_VEHICULO CV ON CV.CIA=A.CIA AND CV.ID_CLIENTE=A.ID_ANALITICA
	WHERE	A.CIA= '''+@CIA+'''	AND A.ID_ESTADO=''01'' AND TA.ID_TIPO_ANALITICA='''+@ID_TIPO_ANALITICA+''''
	------------------------------------------------------------------------------------------------------------------
	IF  LEN(ISNULL(@ID_ANALITICA,''))>0  AND  @ID_ANALITICA<>'%' 
			BEGIN    SELECT @sFiltroID	=' and a.id_analitica='''+@ID_ANALITICA+''''	 END
	ELSE	BEGIN    SELECT @sFiltroID	=''	END
	--------------------------------------------------------------------------------------------
	SELECT @sGroup		='GROUP BY A.id_analitica ,A.descripcion '
	SELECT @sOrderBy	=' order by  a.descripcion'
	---------------------------------------------------------------------------------------------
	SELECT @sExecute = @sSelect +''+ @sFiltroID +''+  @sGroup +''+  @sOrderBy
 	PRINT @sExecute
	EXEC ('SELECT '+ @sExecute )	 
 	--------------------------------------------------------------------------------------------
END
---------------------------------------------------------------------------------------------------------------
GO
/****** Object:  StoredProcedure [dbo].[SP_LISTAR_ANALITICA_CONTACTO]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
[SP_LISTAR_ANALITICA_CONTACTO] '01','20100111838','',''
SP_HELP analitica_contacto
SELECT * FROM ESTADO
SELECT * FROM analitica			WHERE ID_TIPO_ANALITICA='02'
SELECT * FROM analitica_TIPO WHERE ID_TIPO_ANALITICA='02'
SELECT * FROM prueba.dbo.TIPO_ANALITICA  WHERE ID_TIPO_ANALITICA='02'
SELECT * FROM netdat.dbo.analitica_contacto
SP_LISTAR_ANALITICA_CONTACTO '01','10000000052','20',''


*/
---------------------------------------------------
CREATE	PROC	[dbo].[SP_LISTAR_ANALITICA_CONTACTO]
@CIA				CHAR(2),
@id_analitica		varchar(20),
@item				CHAR(2),
@CONTACTO			varchar(100)
AS
-------------------------------------------------------------------------------
DECLARE @sExecute varchar(max),@sSelect varchar(max),@sId_anali varchar(max),@sItem varchar(max),@sContacto varchar(max),@sOrderby varchar(max)
-------------------------------------------------------------------------------
SELECT @sExecute='',@sSelect='',@sId_anali='',@sItem='',@sContacto='',@sOrderby=''
-------------------------------------------------------------------------------
SELECT @sSelect='
ac.id_analitica,ac.item,ac.contacto,ac.cargo,AC.telefono
from	analitica_contacto AC
INNER JOIN ESTADO E ON E.CIA=AC.CIA AND E.ID_ESTADO=AC.ID_ESTADO
INNER JOIN ANALITICA A ON a.cia=aC.cia AND a.id_analitica=aC.id_analitica 
INNER JOIN ANALITICA_TIPO AT ON at.cia=a.cia AND at.id_analitica=a.id_analitica 
INNER JOIN TIPO_ANALITICA TA ON ta.cia=at.cia AND ta.id_tipo_analitica=at.id_tipo_analitica
WHERE	AC.CIA= '''+@CIA+'''	AND A.ID_ESTADO=''01'''
------------------------------------------------------------------------------------------------------------------
	IF  LEN(@id_analitica)>0 begin SELECT @sId_anali='AND ac.id_analitica='''+@id_analitica+'''' END
	ELSE BEGIN SELECT @sId_anali='' END
------------------------------------------------------------------------------------------------------------------
	IF  LEN(@item)>0 begin SELECT @sItem='AND ac.item='''+@item+'''' END
	ELSE BEGIN SELECT @sItem='' END
------------------------------------------------------------------------------------------------------------------
	IF  LEN(@CONTACTO)>0 begin SELECT @sContacto='AND ac.contacto='''+@CONTACTO+'''' END
	ELSE BEGIN SELECT @sContacto='' END
------------------------------------------------------------------------------------------------------------------
SELECT @sOrderby='order by aC.item'
------------------------------------------------------------------------------------------------------------------
SELECT @sExecute = @sSelect +' '+ @sId_anali +' '+ @sItem+' '+@sContacto+' '+@sOrderby
-------------------------------------------------------------------------------
EXEC ('SELECT '+ @sExecute )
GO
/****** Object:  StoredProcedure [dbo].[SP_LISTAR_ANALITICA_E]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
SP_LISTAR_ANALITICA_E '01','08'
*/

CREATE PROCEDURE [dbo].[SP_LISTAR_ANALITICA_E]
@CIA CHAR(2),
@TIPO CHAR(1)
AS
-------------------------------------------------------------------------------
DECLARE @sExecute varchar(max),@sSelect varchar(max),@sCondicion varchar(max),@sTipo varchar(max),@sGroup varchar(max),@sOrder varchar(max)
-------------------------------------------------------------------------------
SELECT @sExecute='',@sSelect='',@sCondicion='',@sTipo='',@sGroup='',@sOrder=''
-------------------------------------------------------------------------------
SELECT @sSelect='
A.ID_ANALITICA,ltrim(A.DESCRIPCION) ''DESCRIPCION'' FROM ANALITICA A
INNER JOIN ESTADO E ON E.CIA=A.CIA AND E.ID_ESTADO=A.ID_ESTADO
INNER JOIN ANALITICA_TIPO AT ON at.cia=a.cia AND at.id_analitica=a.id_analitica 
INNER JOIN TIPO_ANALITICA TA ON ta.cia=at.cia AND ta.id_tipo_analitica=at.id_tipo_analitica
INNER JOIN CLIENTE_VEHICULO CV ON CV.CIA=A.CIA AND CV.ID_CLIENTE=A.ID_ANALITICA'
-------------------------------------------------------------------------------
SELECT @sCondicion = 'WHERE A.CIA='''+@CIA+''' AND A.ID_ESTADO=''01'''
-------------------------------------------------------------------------------
IF LEN(@TIPO)>0 BEGIN SELECT @sTipo = 'AND AT.FLAG_CON_CONTRATO='''+@TIPO+'''' END
ELSE BEGIN SELECT @sTipo = '' END
-------------------------------------------------------------------------------
SELECT @sGroup = 'GROUP BY A.ID_ANALITICA,A.DESCRIPCION,AT.FLAG_CON_CONTRATO'
-------------------------------------------------------------------------------
SELECT @sOrder = 'ORDER BY A.DESCRIPCION'
-------------------------------------------------------------------------------
SELECT @sExecute = @sSelect +' '+ @sCondicion +' '+ @sTipo+' '+@sGroup+' '+@sOrder
-------------------------------------------------------------------------------
EXEC ('SELECT '+ @sExecute )
GO
/****** Object:  StoredProcedure [dbo].[SP_LISTAR_ARTICULO]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
SP_HELP articulo
select * from INVENTARIO_MOV
select nro_parte,* from articulo order by nro_parte
SELECT * FROM dbo.EXISTENCIA_ALMACEN
SELECT * FROM dbo.EXISTENCIA_SEDE
select cantidad,* from INVENTARIO_MOV_Det where id_articulo like 'PRO---0000000098' +'%'

SP_LISTAR_articulo '01','PROCOM0',''
[SP_LISTAR_ARTICULO] '01','',''
*/
---------------------------------------------------
CREATE PROCEDURE [dbo].[SP_LISTAR_ARTICULO] 
@cia				char(2),
@id_articulo		varchar(100),
@nombre				varchar(100)
AS
--------------------------------------------------------------------------
DECLARE @sSelect varchar(MAX),@sFiltroArticulo varchar(MAX), @sFiltroDesc varchar(MAX)
DECLARE @sOrderBy varchar(MAX),@sGroupBy varchar(MAX),@sExecute varchar(MAX)
-----------------------------------------------------------------------------------------------------
SELECT @sSelect='', @sFiltroArticulo='',@sFiltroDesc='',@sOrderBy='',@sGroupBy='',@sExecute=''
-------------------------------------------------------------------------------------------------------
SELECT @sSelect='
		 a.id_articulo as ''id_articulo'',nro_parte,
		upper(a.descripcion) as ''descripcion'',
		um.abreviatura as ''unidad_medida'' ,
		count(cantidad)as ''cantidad'',
		upper(ma.descripcion)as ''marca''	
		FROM articulo as a 
		LEFT JOIN estado e ON e.cia=a.cia and e.id_estado=a.id_estado 
		LEFT JOIN unidad_medida um on um.cia=a.cia and um.id_unidad=a.id_unidad
		left join inventario_mov_det imd on imd.cia=a.cia and imd.id_articulo =a.id_articulo
		left join marca_articulo  ma on ma.cia=a.cia and ma.id_marca=a.id_marca
		WHERE a.cia='''+@cia+'''   AND a.id_estado=''01''	'
	
	----------------------------------------------------------------------------------------------
	IF  LEN(ISNULL(@id_articulo,''))>0 
	begin
	   SELECT @sFiltroArticulo		=' and a.id_articulo= '''+@id_articulo+''''
	 END
	ELSE
	BEGIN       
		SELECT @sFiltroArticulo	=''
	END
	--------------------------------------------------------------------------------------------
	IF  LEN(ISNULL(@nombre,''))>0 
	begin
	   SELECT @sFiltroDesc		=' and A.descripcion='''+@nombre+''''
	 END
	ELSE
	BEGIN       
		SELECT @sFiltroDesc	=''
	END
	--------------------------------------------------------------------------------------------
	SELECT @sGroupBy	=	' group by a.id_articulo,nro_parte,a.descripcion,um.abreviatura,ma.descripcion'  
	SELECT @sOrderBy	=	' order by a.descripcion'
	---------------------------------------------------------------------------------------------
	 SELECT @sExecute = @sSelect +''+ @sFiltroArticulo +''+ @sFiltroDesc +''+   @sGroupBy+''+  @sOrderBy
 	PRINT @sExecute
	 EXEC ('SELECT '+ @sExecute )	 
 	--------------------------------------------------------------------------------------------
GO
/****** Object:  StoredProcedure [dbo].[SP_LISTAR_ARTICULO_NRO_PARTE]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
sp_help ARTICULO_NRO_PARTE
[SP_LISTAR_COMBO_UNIDAD_MEDIDA] '01'
select * from ARTICULO_NRO_PARTE ORDER BY NRO_PARTE
SP_LISTAR_ARTICULO_NRO_PARTE '1','01','',''
*/
CREATE PROC [dbo].[SP_LISTAR_ARTICULO_NRO_PARTE]
@INDICADOR	CHAR(1),@CIA  CHAR(2),@ID_ARTICULO  VARCHAR(20),@NRO_PARTE  VARCHAR(60)
AS
-------------------------------------------------------------------------------
DECLARE @sExecute varchar(max),@sSelect varchar(max),@sFiltroIdArticulo varchar(max),
	@sFiltroNroParte varchar(max),@sGroupby varchar(max),@sOrderby varchar(max)
SELECT @sExecute='',  @sSelect='', @sFiltroIdArticulo='',@sFiltroNroParte='',@sOrderBy='',@sGroupBy=''

-------------------------------------------------------------------------------

IF(@INDICADOR='1')
BEGIN
	SELECT @sSelect='
	anp.id_articulo, UPPER(anp.nro_parte) as ''nro_parte'',anp.item
	FROM articulo_nro_parte	AS anp
	LEFT JOIN estado e ON e.cia=anp.cia and e.id_estado=anp.id_estado 
	where anp.CIA='''+@CIA+'''	AND ANP.ID_ESTADO=''01''	'	 
	--------------------------------------------------------------------------------------------------------
	IF  LEN(ISNULL(@id_articulo,''))>0 
			BEGIN    SELECT @sFiltroIdArticulo	=' and anp.id_articulo like ''%''+'''+@id_articulo+''' +''%'' ' END
	ELSE	BEGIN   SELECT @sFiltroIdArticulo	=''		END
	--------------------------------------------------------------------------------------------------------
	IF  LEN(ISNULL(@nro_parte ,''))>0 
			BEGIN    SELECT @sFiltroNroParte	=' and anp.nro_parte like ''%''+'''+@nro_parte+''' +''%'' ' END
	ELSE	BEGIN   SELECT @sFiltroNroParte	=''		END
	--------------------------------------------------------------------------------------------
	SELECT @sOrderby='ORDER BY anp.id_articulo'
	-------------------------------------------------------------------------------
	SELECT @sExecute = @sSelect +' '+ @sFiltroIdArticulo +' '+ @sFiltroNroParte +' '+@sOrderby
	-------------------------------------------------------------------------------
	--PRINT @sExecute
	EXEC ('SELECT '+ @sExecute )

END
-----------------------------------------------------------------------
IF(@INDICADOR='2')
BEGIN
	SELECT @sSelect='
	anp.id_articulo, UPPER(anp.nro_parte) as ''nro_parte''	FROM articulo_nro_parte	AS anp
	LEFT JOIN estado e ON e.cia=anp.cia and e.id_estado=anp.id_estado 
	where anp.CIA='''+@CIA+'''	AND ANP.ID_ESTADO=''01''	'
	--------------------------------------------------------------------------------------------
	SELECT @sOrderby='ORDER BY anp.id_articulo'
	-------------------------------------------------------------------------------
	SELECT @sExecute = @sSelect +' '+ @sFiltroIdArticulo +' '+ @sOrderby
	-------------------------------------------------------------------------------
	--PRINT @sExecute
	EXEC ('SELECT '+ @sExecute )	 
END
GO
/****** Object:  StoredProcedure [dbo].[SP_LISTAR_ARTICULO_TEMP]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
SP_HELP ARTICULO_TEMP
select *FROM ARTICULO_TEMP
delete from ARTICULO_TEMP
GO
SP_LISTAR_ARTICULO_TEMP '52801bf1-ab07-4ca2-8e1d-47a6030d5124','01','01',''
UPDATE ARTICULO_TEMP SET id_estado='02' WHERE sesion ='52801bf1-ab07-4ca2-8e1d-47a6030d5124' AND cia='01' AND sede='01' AND item='2'
*/
CREATE  PROC [dbo].[SP_LISTAR_ARTICULO_TEMP]
@SESION				VARCHAR(max),
@cia				char(2),
@SEDE				CHAR(2),
@id_articulo		varchar(20)
AS
-------------------------------------------------------------------------------
DECLARE @sExecute varchar(max),@sSelect varchar(max),@sCondicion varchar(max),@sGroupby varchar(max),@sOrderby varchar(max)
-------------------------------------------------------------------------------
SELECT @sSelect='at.item,AT.id_articulo as ''id_articulo'',at.nro_parte,at.descripcion,unidad, cantidad,marca
 FROM ARTICULO_TEMP AT
inner join articulo a on a.cia= AT.cia and a.id_articulo=AT.id_articulo	
inner JOIN unidad_medida um on um.cia=a.cia and um.id_unidad=a.id_unidad		
WHERE  AT.CIA='''+@cia+''' AND AT.SEDE='''+@SEDE+''' AND SESION='''+@SESION+''' and at.id_estado=''01'' '
-------------------------------------------------------------------------------
IF LEN(@id_articulo)>0 BEGIN SELECT @sCondicion=' and at.id_articulo='''+@id_articulo+'''' END ELSE BEGIN SELECT @sCondicion='' END
-------------------------------------------------------------------------------
SELECT @sOrderby='ORDER BY at.item'
-------------------------------------------------------------------------------
SELECT @sExecute = @sSelect +' '+ @sCondicion +' '+@sOrderby
-------------------------------------------------------------------------------
--PRINT @sExecute
EXEC ('SELECT '+ @sExecute )
GO
/****** Object:  StoredProcedure [dbo].[SP_LISTAR_ARTICULOS_PROV]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_LISTAR_ARTICULOS_PROV]
@CIA CHAR(2)
AS
SELECT 
ROW_NUMBER() OVER(ORDER BY AR.DESCRIPCION) as 'RANK',
AR.ID_ARTICULO,UPPER(AR.DESCRIPCION) 'DESCRIPCION',AR.NRO_PARTE,AR.ID_MARCA,AR.ID_ESTADO,
PROV.ID_ANALITICA 'ID_PROV',PROV.DESCRIPCION 'DES_PROV',PROV.DIRECCION 'DIREC_PROV' FROM ARTICULO AR    
INNER JOIN	INVENTARIO_MOV_DET AS NI_D ON AR.CIA = NI_D.CIA AND AR.ID_ARTICULO = NI_D.ID_ARTICULO
INNER JOIN	INVENTARIO_MOV AS NI ON NI.CIA = NI_D.CIA AND NI.SEDE = NI_D.SEDE AND NI.ID_TIPO_DOC = NI_D.ID_TIPO_DOC AND 
			NI.SERIE_DOC = NI_D.SERIE_DOC AND NI.NRO_DOC = NI_D.NRO_DOC	
INNER JOIN	ANALITICA PROV ON NI.CIA = PROV.CIA AND NI.ID_ANALITICA=PROV.ID_ANALITICA 
INNER JOIN	ANALITICA_TIPO AS PROV_T ON PROV.CIA = PROV_T.CIA AND PROV.ID_ANALITICA = PROV_T.ID_ANALITICA
WHERE	AR.CIA=@CIA AND NI.ID_TIPO_DOC='31' AND PROV_T.ID_TIPO_ANALITICA='02' AND PROV.ID_ANALITICA!='20519069262'
GROUP BY PROV.ID_ANALITICA,PROV.DESCRIPCION,PROV.DIRECCION,AR.ID_ARTICULO,AR.DESCRIPCION,AR.NRO_PARTE,AR.ID_MARCA,AR.ID_ESTADO	
ORDER BY AR.DESCRIPCION

/*

SP_LISTAR_ARTICULOS_PROV '01'

SELECT COUNT(PROV.ID_ANALITICA),PROV.ID_ANALITICA 'ID_PROV',PROV.DESCRIPCION 'DES_PROV' FROM ARTICULO AR    
INNER JOIN	INVENTARIO_MOV_DET AS NI_D ON AR.CIA = NI_D.CIA AND AR.ID_ARTICULO = NI_D.ID_ARTICULO
INNER JOIN	INVENTARIO_MOV AS NI ON NI.CIA = NI_D.CIA AND NI.SEDE = NI_D.SEDE AND NI.ID_TIPO_DOC = NI_D.ID_TIPO_DOC AND 
			NI.SERIE_DOC = NI_D.SERIE_DOC AND NI.NRO_DOC = NI_D.NRO_DOC	
INNER JOIN	ANALITICA PROV ON NI.CIA = PROV.CIA AND NI.ID_ANALITICA=PROV.ID_ANALITICA 
INNER JOIN	ANALITICA_TIPO AS PROV_T ON PROV.CIA = PROV_T.CIA AND PROV.ID_ANALITICA = PROV_T.ID_ANALITICA
--WHERE	AR.CIA='01' AND NI.ID_TIPO_DOC='31' AND PROV_T.ID_TIPO_ANALITICA='02' AND PROV.ID_ANALITICA!='20519069262'
GROUP BY PROV.ID_ANALITICA,PROV.DESCRIPCION	


SELECT * FROM ANALITICA PROV
INNER JOIN	ANALITICA_TIPO AS PROV_T ON PROV.CIA = PROV_T.CIA AND PROV.ID_ANALITICA = PROV_T.ID_ANALITICA
WHERE PROV_T.ID_TIPO_ANALITICA='02'




*/




/*

select * from ANALITICA_TIPO

SELECT * FROM TIPO_ANALITICA

select * from ARTICULO

select * from INVENTARIO_MOV_DET



*/
GO
/****** Object:  StoredProcedure [dbo].[SP_LISTAR_BD]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
select * from usuario
select * from USUARIO_ACCESO
select * from master..sysdatabases 

*/


create Proc [dbo].[SP_LISTAR_BD]
AS
SELECT	[dbid], UPPER(name) AS Name
FROM	master..sysdatabases 
WHERE	status	!=65544	
--AND		sid		!=	0x01  
order by	name
GO
/****** Object:  StoredProcedure [dbo].[SP_LISTAR_CAJA_BANCO]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
SP_HELP caja_banco
select * from netdat.dbo.caja_banco  where CIA='01' AND id_caja_banco like 'bov' +'%'
SP_LISTAR_CAJA_BANCO '01','bov',''
*/
CREATE PROC [dbo].[SP_LISTAR_CAJA_BANCO]
@cia CHAR(2),@id_caja_banco	VARCHAR(5),@descripcion VARCHAR(60)
AS
--------------------------------------
SELECT cb.id_caja_banco,UPPER(cb.descripcion)'descripcion' FROM caja_banco cb
 INNER JOIN ESTADO E ON E.CIA=cb.CIA AND E.ID_ESTADO=cb.ID_ESTADO
 where cb.id_estado='01'  AND cb.CIA=@CIA
 and   cb.id_caja_banco LIKE  '%' + CASE WHEN LEN(@id_caja_banco) > 0 THEN '%' + @id_caja_banco + '%' ELSE '%' END
 and   cb.descripcion LIKE  '%' + CASE WHEN LEN(@descripcion) > 0 THEN '%' + @descripcion + '%' ELSE '%' END
ORDER BY id_caja_banco
GO
/****** Object:  StoredProcedure [dbo].[SP_LISTAR_CAMPANIA]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*

SP_LISTAR_CAMPANIA '01'

*/


CREATE procedure [dbo].[SP_LISTAR_CAMPANIA]
@cia char(2)
as
select convert(varchar,id_campania) 'codigo',descripcion from F_CAMPANIA
WHERE cia=@cia AND id_estado='01'
GO
/****** Object:  StoredProcedure [dbo].[SP_LISTAR_CLASIFICACION1]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
sp_help CLASIFICACION1
[SP_LISTAR_CLASIFICACION1] '1','01',''
[SP_LISTAR_CLASIFICACION1] '1','01','001'
[SP_LISTAR_CLASIFICACION1] '2','01',''
select * from CLASIFICACION1
*/
CREATE PROCEDURE [dbo].[SP_LISTAR_CLASIFICACION1]
@INDICADOR CHAR(1),@CIA  CHAR(2),@ID_CLASIFICA1  CHAR(3)
AS
-----------------------------------------------------------------------------------------------------------------------
DECLARE @sOrderBy varchar(MAX), @sGroupBy varchar(MAX), @sExecute varchar(MAX),@sSelect varchar(MAX)
DECLARE @sFiltroIdArticulo varchar(MAX),@sFiltroIdclasifica1 varchar(MAX),@sFiltroIdclasifica2 varchar(MAX)
DECLARE @sFiltroEstado varchar(MAX),@sFiltroFecha varchar(MAX)
SELECT @sSelect='',  @sFiltroIdArticulo='', @sFiltroIdclasifica1 ='', @sFiltroIdclasifica2 ='',	@sFiltroEstado ='',
	@sFiltroFecha ='',@sOrderBy='',@sGroupBy='',@sExecute=''
-----------------------------------------------------------------------------------------------------------------
IF(@INDICADOR='1')
BEGIN
	SELECT @sSelect= ' c.id_clasifica1, UPPER(c.descripcion) as ''descripcion'',c.abreviatura		FROM clasificacion1	AS c
		LEFT JOIN estado e ON e.cia=c.cia and e.id_estado=c.id_estado 		WHERE c.CIA='''+@CIA+''' 		'
	--------------------------------------------------------------------------------------------
	IF  LEN(ISNULL(@ID_CLASIFICA1,''))>0 AND  @ID_CLASIFICA1<>'%' 
			BEGIN    SELECT @sFiltroIdclasifica1	=' and c.id_clasifica1 in('''+@ID_CLASIFICA1+''')' 	 END
	ELSE	BEGIN    SELECT @sFiltroIdclasifica1	=''	END
	SELECT @sOrderBy	=' order by  c.id_clasifica1'
	---------------------------------------------------------------------------------------------
	SELECT @sExecute = @sSelect +''+  @sFiltroIdclasifica1 +''+ @sOrderBy
 	PRINT @sExecute
	EXEC ('SELECT '+ @sExecute )	 
END
-----------------------------------------------------------------------------------------------------------------
IF(@INDICADOR='2')
BEGIN
	SELECT @sSelect= ' c.id_clasifica1, UPPER(c.descripcion) as ''descripcion''		FROM clasificacion1	AS c
		LEFT JOIN estado e ON e.cia=c.cia and e.id_estado=c.id_estado 		WHERE c.CIA='''+@CIA+''' 		'
	--------------------------------------------------------------------------------------------
	IF  LEN(ISNULL(@ID_CLASIFICA1,''))>0 AND  @ID_CLASIFICA1<>'%' 
			BEGIN    SELECT @sFiltroIdclasifica1	=' and c.id_clasifica1 in('''+@ID_CLASIFICA1+''')' 	 END
	ELSE	BEGIN    SELECT @sFiltroIdclasifica1	=''	END
	SELECT @sOrderBy	=' order by  c.id_clasifica1'
	---------------------------------------------------------------------------------------------
	SELECT @sExecute = @sSelect +''+  @sFiltroIdclasifica1 +''+ @sOrderBy
 	PRINT @sExecute
	EXEC ('SELECT '+ @sExecute )	 
END
GO
/****** Object:  StoredProcedure [dbo].[SP_LISTAR_CLASIFICACION2]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
[SP_LISTAR_COMBO_CLASIFICACION1] '01'
GO
[SP_LISTAR_CLASIFICACION2] '1','01','001',''
[SP_LISTAR_CLASIFICACION2] '2','01','001',''
select * from CLASIFICACION1
select * from CLASIFICACION2
sp_help CLASIFICACION2

*/
CREATE PROCEDURE [dbo].[SP_LISTAR_CLASIFICACION2]
@INDICADOR CHAR(1),@CIA  CHAR(2),@ID_CLASIFICA1  CHAR(3),@ID_CLASIFICA2  CHAR(3)
AS
-----------------------------------------------------------------------------------------------------------------------
DECLARE @sOrderBy varchar(MAX), @sGroupBy varchar(MAX), @sExecute varchar(MAX),@sSelect varchar(MAX)
DECLARE @sFiltroIdArticulo varchar(MAX),@sFiltroIdclasifica1 varchar(MAX),@sFiltroIdclasifica2 varchar(MAX)
DECLARE @sFiltroEstado varchar(MAX),@sFiltroFecha varchar(MAX)
SELECT @sSelect='',  @sFiltroIdArticulo='', @sFiltroIdclasifica1 ='', @sFiltroIdclasifica2 ='',	@sFiltroEstado ='',
	@sFiltroFecha ='',@sOrderBy='',@sGroupBy='',@sExecute=''
-----------------------------------------------------------------------------------------------------------------
IF(@INDICADOR='1')
BEGIN
	SELECT @sSelect= '
		c.id_clasifica1,c.id_clasifica2, UPPER(c.descripcion) as ''descripcion'',c.abreviatura
		FROM clasificacion2	AS c
		LEFT JOIN estado e ON e.cia=c.cia and e.id_estado=c.id_estado 	
		--left join clasificacion2 cc on cc.cia=c.cia and cc.id_estado=e.id_estado and cc.id_clasifica2=c.id_clasifica2
			WHERE c.CIA='''+@CIA+''' 		'	
	--------------------------------------------------------------------------------------------
	IF  LEN(ISNULL(@ID_CLASIFICA1,''))>0 AND  @ID_CLASIFICA1<>'%' 
			BEGIN    SELECT @sFiltroIdclasifica1	=' and c.id_clasifica1 in('''+@ID_CLASIFICA1+''')' 	 END
	ELSE	BEGIN    SELECT @sFiltroIdclasifica1	=''	END
	---------------------------------------------------------------------
	SELECT @sOrderBy	=' order by  c.id_clasifica1'
	---------------------------------------------------------------------------------------------
	SELECT @sExecute = @sSelect +''+  @sFiltroIdclasifica1 +''+ @sOrderBy
 	PRINT @sExecute
	EXEC ('SELECT '+ @sExecute )	 
END
-----------------------------------------------------------------------------------------------------------------
IF(@INDICADOR='2')
BEGIN
	SELECT @sSelect= ' c.id_clasifica2, UPPER(c.descripcion) as ''descripcion''		FROM clasificacion2	AS c
		LEFT JOIN estado e ON e.cia=c.cia and e.id_estado=c.id_estado 	
		--left join clasificacion2 cc on cc.cia=c.cia and cc.id_estado=e.id_estado and cc.id_clasifica2=c.id_clasifica2
			WHERE c.CIA='''+@CIA+''' 		'	
	--------------------------------------------------------------------------------------------
	IF  LEN(ISNULL(@ID_CLASIFICA1,''))>0 AND  @ID_CLASIFICA1<>'%' 
			BEGIN    SELECT @sFiltroIdclasifica1	=' and c.id_clasifica1 in('''+@ID_CLASIFICA1+''')' 	 END
	ELSE	BEGIN    SELECT @sFiltroIdclasifica1	=''	END
	---------------------------------------------------------------------
	SELECT @sOrderBy	=' order by  c.id_clasifica2'
	---------------------------------------------------------------------------------------------
	SELECT @sExecute = @sSelect +''+  @sFiltroIdclasifica1 +''+ @sOrderBy
 	PRINT @sExecute
	EXEC ('SELECT '+ @sExecute )	 
END
GO
/****** Object:  StoredProcedure [dbo].[SP_LISTAR_CLIENTE]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE [dbo].[SP_LISTAR_CLIENTE]
@CIA char(2),
@CODIGO VARCHAR(20),
@DESCRIPCION VARCHAR(30)
as
SELECT a.id_analitica 'codigo',a.descripcion 'descripcion',a.telefono 'telefono',a.direccion 'direccion',u.id_distrito 'iddistrito',
u.des_distrito 'desdistrito' from analitica a
INNER JOIN ANALITICA_TIPO at ON at.cia=a.cia and at.id_analitica=a.id_analitica
INNER JOIN TIPO_ANALITICA tp ON tp.cia=at.cia and tp.id_tipo_analitica=at.id_tipo_analitica
INNER JOIN UBICACION u ON u.cia=a.cia and u.id_pais=a.id_pais and u.id_dpto=a.id_dpto and u.id_provincia=a.id_provincia and u.id_distrito=a.id_distrito
WHERE a.cia=@CIA and tp.id_tipo_analitica='01' and (a.id_analitica like @CODIGO+'%') and (a.descripcion like @DESCRIPCION+'%')
GO
/****** Object:  StoredProcedure [dbo].[SP_LISTAR_CLIENTE_VEHICULO]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
select * from CLIENTE_VEHICULO 
SELECT * from  ESTADO
SP_LISTAR_CLIENTE_VEHICULO '1','01','','',''
*/
CREATE	PROC	[dbo].[SP_LISTAR_CLIENTE_VEHICULO]
@INDICADOR CHAR(1),@CIA	 CHAR(2),@NRO_DOC VARCHAR(20), @ID_CLIENTE VARCHAR(100), @PLACA VARCHAR(100)
AS
-----------------------------------------------------------------------------------------------------------------------
DECLARE @sSelect varchar(MAX),@sFiltroNro_doc varchar(MAX),@sFiltroClienteID varchar(MAX),
	@sOrderBy varchar(MAX),@sGroupBy varchar(MAX),@sExecute varchar(MAX)
----------------------------------------------------------------------------------------------------------------------
SELECT @sSelect='', @sFiltroNro_doc='',  @sFiltroClienteID='',@sOrderBy='',@sGroupBy='',@sExecute=''
-----------------------------------------------------------------------------------------------------------------
IF(@INDICADOR='1')
BEGIN
	SELECT @sSelect='
    upper(placa) ''placa'',''FAE'' as ''tipo_fae'', nro_doc, id_cliente,
	clase, marca, modelo, anio_vehiculo, color, nro_serie, nro_motor, nro_ejes, 
    nro_puertas, combustible, nro_ruedas, fecha=convert(varchar(10),fecha,103), 
    observacion,CASE WHEN LEN(observacion) >= 0 OR observacion=NULL  THEN ''-'' ELSE observacion END ''observacion''    
	FROM         CLIENTE_VEHICULO cv
	INNER JOIN ESTADO E ON E.CIA=cv.CIA AND E.ID_ESTADO=cv.ID_ESTADO
	WHERE	cv.CIA= '''+@CIA+''' '
	SELECT @sGroupBy=' ' 
 -----------------------------------------------------------------------------------------------
	IF  LEN(ISNULL(@nro_doc,''))>0 
			BEGIN  SELECT @sFiltroNro_doc =' and CV.nro_doc  in('''+@nro_doc+''')'	 END
	ELSE	BEGIN  SELECT @sFiltroNro_doc =''	END
 -------------------------------------------------------------------------------------------
	IF  LEN(ISNULL(@ID_CLIENTE,''))>0 
			BEGIN SELECT @sFiltroClienteID	=' and CV.id_cliente like '''+@ID_CLIENTE+''' +''%'' ' END
	ELSE	BEGIN SELECT @sFiltroClienteID	=''	END
	--------------------------------------------------------------------------------------------	
	SELECT @sOrderBy	=' ORDER BY CV.NRO_DOC'
	---------------------------------------------------------------------------------------------
	 SELECT @sExecute = @sSelect+''+@sFiltroNro_doc+''+@sFiltroClienteID+''+@sGroupBy+''+@sOrderBy
 	PRINT @sExecute
	EXEC ('SELECT '+ @sExecute )	 
 	--------------------------------------------------------------------------------------------
END
GO
/****** Object:  StoredProcedure [dbo].[SP_LISTAR_COMBO_ALMACEN_X_SEDE]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*

EXEC [SP_LISTAR_COMBO_ALMACEN_X_SEDE] '01', '01', 'ADMIN'

*/
-----------------------------------
-----------------------------------
create	PROCEDURE	[dbo].[SP_LISTAR_COMBO_ALMACEN_X_SEDE]
@CIA		CHAR(2),
@SEDE		CHAR(2),
@ID_USUARIO	VARCHAR(10)
AS
-----------------------------------
-----------------------------------
SELECT	USUARIO_ALMACEN.ID_ALMACEN, UPPER(ALMACEN.DESCRIPCION) AS 'DESCRIPCION'
FROM	USUARIO_ALMACEN 
INNER JOIN ALMACEN ON USUARIO_ALMACEN.CIA = ALMACEN.CIA AND USUARIO_ALMACEN.SEDE = ALMACEN.SEDE AND USUARIO_ALMACEN.ID_ALMACEN = ALMACEN.ID_ALMACEN
WHERE	USUARIO_ALMACEN.CIA			= @CIA 
AND		USUARIO_ALMACEN.SEDE		= @SEDE 
AND		USUARIO_ALMACEN.ID_USUARIO	= @ID_USUARIO 
AND		USUARIO_ALMACEN.ID_ESTADO	= '01'
ORDER	BY 'DESCRIPCION'
GO
/****** Object:  StoredProcedure [dbo].[SP_LISTAR_COMBO_CAJA_BANCO_X_USUARIO]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*

EXEC SP_LISTAR_COMBO_CAJA_BANCO_X_USUARIO '01', 'ADMIN', '01'

*/
-------------------------------------------
-------------------------------------------
create	PROCEDURE	[dbo].[SP_LISTAR_COMBO_CAJA_BANCO_X_USUARIO]
@CIA		CHAR(2),
@ID_USUARIO	VARCHAR(10),
@ID_MONEDA	CHAR(2)
AS
-------------------------------------------
-------------------------------------------

SELECT	UCB.ID_CAJA_BANCO, UPPER(CB.DESCRIPCION) AS 'DESCRIPCION'
FROM	USUARIO_CAJA_BCO AS UCB 
INNER JOIN CAJA_BANCO AS CB ON UCB.CIA = CB.CIA AND UCB.ID_CAJA_BANCO = CB.ID_CAJA_BANCO
WHERE	UCB.CIA			= @CIA
AND		UCB.ID_USUARIO	= @ID_USUARIO
AND		UCB.ID_ESTADO	= '01' 
AND		CB.ID_MONEDA	= @ID_MONEDA
ORDER	BY 'DESCRIPCION'
GO
/****** Object:  StoredProcedure [dbo].[SP_LISTAR_COMBO_CAJA_MARKET]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*

EXEC SP_LISTAR_COMBO_CAJA_MARKET '01'

*/
---------------------------------------------
---------------------------------------------
create	PROCEDURE [dbo].[SP_LISTAR_COMBO_CAJA_MARKET]
@CIA CHAR(2)
AS
---------------------------------------------
---------------------------------------------
SELECT	ID_SURTIDOR, DESCRIPCION 
FROM	E_SURTIDOR
WHERE	CIA	= @CIA 
AND		ID_SURTIDOR LIKE 'M%'
GO
/****** Object:  StoredProcedure [dbo].[SP_LISTAR_COMBO_CAMPAÑA]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*

exec	SP_LISTAR_COMBO_CAMPAÑA '01'

*/
--------------------------------------------------
--------------------------------------------------
create	PROCEDURE	[dbo].[SP_LISTAR_COMBO_CAMPAÑA]
@CIA	char(2)
AS
--------------------------------------------------
--------------------------------------------------
SELECT	CONVERT(VARCHAR(10),id_campania) AS 'id_campania', descripcion 
FROM	F_CAMPANIA
WHERE	cia			= @CIA
AND		id_estado	= '01'
GO
/****** Object:  StoredProcedure [dbo].[SP_LISTAR_COMBO_CATEGORIA_ANALITICA]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*

SELECT * FROM ANALITICA

SELECT * FROM CATEGORIA_ANALITICA

EXEC	SP_LISTAR_COMBO_TIPO_ZONA '01'

*/
-------------------------------------------------
-------------------------------------------------
create	PROCEDURE	[dbo].[SP_LISTAR_COMBO_CATEGORIA_ANALITICA]
@CIA	char(2)
AS
-------------------------------------------------
-------------------------------------------------
SELECT	id_categoria,
		descripcion
FROM	categoria_analitica
WHERE	cia	= @CIA
AND		ID_ESTADO = '01'
ORDER	BY descripcion
GO
/****** Object:  StoredProcedure [dbo].[SP_LISTAR_COMBO_GRUPO]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*

SP_LISTAR_COMBO_GRUPO '01'

*/


CREATE PROCEDURE [dbo].[SP_LISTAR_COMBO_GRUPO]
@CIA CHAR(2)
AS
SELECT ID_GRUPO,DESCRIPCION FROM GRUPO WHERE CIA=@CIA
GO
/****** Object:  StoredProcedure [dbo].[SP_LISTAR_COMBO_LISTA_PRECIO]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*

EXEC SP_LISTAR_COMBO_LISTA_PRECIO '01', '01'

*/
-------------------------------------------
-------------------------------------------
create	PROCEDURE	[dbo].[SP_LISTAR_COMBO_LISTA_PRECIO]
@CIA		CHAR(2),
@ID_MONEDA	CHAR(2)
AS
-------------------------------------------
-------------------------------------------
SELECT	ID_LISTA_PRECIO, UPPER(DESCRIPCION) AS 'DESCRIPCION'
FROM	LISTA_PRECIO
WHERE	CIA			= @CIA
AND		ID_MONEDA	= @ID_MONEDA
AND		ID_ESTADO	= '01'
ORDER	BY 'DESCRIPCION'
GO
/****** Object:  StoredProcedure [dbo].[SP_LISTAR_COMBO_ORDEN_PEDIDO]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*

SP_LISTAR_COMBO_ORDEN_PEDIDO '01','01','21','2010','00000044'

*/


CREATE PROCEDURE [dbo].[SP_LISTAR_COMBO_ORDEN_PEDIDO]
@CIA CHAR(2),
@SEDE CHAR(2),
@ID_TIPO_DOC CHAR(4),
@SERIE_DOC CHAR(4),
@NRO_DOC VARCHAR(8)
AS
SELECT DGFD.NRO_DOC,tp.abreviatura+' '+dgf.serie_doc+'-'+dgf.nro_doc
FROM dbo.DOC_GESTION_FA_DETALLE DGFD
INNER JOIN dbo.DOC_GESTION_FA DGF ON DGFD.CIA = DGF.CIA AND DGFD.SEDE = DGF.SEDE AND DGFD.ID_TIPO_DOC = DGF.ID_TIPO_DOC 
AND DGFD.SERIE_DOC = DGF.SERIE_DOC AND DGFD.NRO_DOC = DGF.NRO_DOC
INNER JOIN tipo_documento tp ON TP.CIA=DGF.CIA AND TP.ID_TIPO_DOC=DGF.ID_TIPO_DOC
WHERE DGFD.CIA=@CIA AND DGFD.SEDE=@SEDE AND DGFD.SERIE_DOC=@SERIE_DOC AND DGFD.NRO_DOC=@NRO_DOC AND DGFD.ID_TIPO_DOC=@ID_TIPO_DOC
--AND (CONVERT(VARCHAR(10),DGF.FECHA_VENCIMIENTO,112))>CONVERT(VARCHAR(10),GETDATE(),112)
GROUP BY DGFD.NRO_DOC,dgf.id_tipo_doc,dgf.nro_doc,tp.abreviatura,dgf.serie_doc
ORDER BY DGFD.NRO_DOC
GO
/****** Object:  StoredProcedure [dbo].[SP_LISTAR_COMBO_TIPO_DOCUMENTO_X_USUARIO]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*

EXEC SP_LISTAR_COMBO_TIPO_DOCUMENTO_X_USUARIO '01', 'ADMIN'

*/
---------------------------------------
---------------------------------------
create	PROCEDURE	[dbo].[SP_LISTAR_COMBO_TIPO_DOCUMENTO_X_USUARIO]
@CIA		CHAR(2),
@ID_USUARIO	VARCHAR(10)
AS
---------------------------------------
---------------------------------------
SELECT	UTD.ID_TIPO_DOC, UPPER(TD.DESCRIPCION) AS 'DESCRIPCION'
FROM	USUARIO_TIPO_DOCUMENTO AS UTD 
INNER JOIN TIPO_DOCUMENTO AS TD ON UTD.CIA = TD.CIA AND UTD.ID_TIPO_DOC = TD.ID_TIPO_DOC
WHERE	UTD.CIA			= @CIA 
AND		UTD.ID_USUARIO	= @ID_USUARIO 
AND		UTD.ID_ESTADO	= '01'
ORDER	BY 'DESCRIPCION'
GO
/****** Object:  StoredProcedure [dbo].[SP_LISTAR_COMBO_TIPO_DOCUMENTOS_ID]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*

SELECT * FROM TIPO_DOCUMENTO_ID

EXEC	SP_LISTA_DOCUMENTOS_ID '01'

*/
-------------------------------------------------
-------------------------------------------------
create	PROCEDURE	[dbo].[SP_LISTAR_COMBO_TIPO_DOCUMENTOS_ID]
@CIA	char(2)
AS
-------------------------------------------------
-------------------------------------------------
SELECT	id_tipo_doc_id,
		descripcion
FROM	tipo_documento_id
WHERE	cia	= @CIA
AND		ID_ESTADO = '01'
ORDER	BY descripcion
GO
/****** Object:  StoredProcedure [dbo].[SP_LISTAR_COMBO_TIPO_VIA]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*

SELECT * FROM TIPO_VIA

EXEC	SP_LISTA_DOCUMENTOS_ID '01'

*/
-------------------------------------------------
-------------------------------------------------
create	PROCEDURE	[dbo].[SP_LISTAR_COMBO_TIPO_VIA]
@CIA	char(2)
AS
-------------------------------------------------
-------------------------------------------------
SELECT	id_tipo_via,
		descripcion
FROM	tipo_via
WHERE	cia	= @CIA
AND		ID_ESTADO = '01'
ORDER	BY descripcion
GO
/****** Object:  StoredProcedure [dbo].[SP_LISTAR_COMBO_TIPO_ZONA]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*

SELECT * FROM TIPO_ZONA

EXEC	SP_LISTAR_COMBO_TIPO_ZONA '01'

*/
-------------------------------------------------
-------------------------------------------------
create	PROCEDURE	[dbo].[SP_LISTAR_COMBO_TIPO_ZONA]
@CIA	char(2)
AS
-------------------------------------------------
-------------------------------------------------
SELECT	id_tipo_zona,
		descripcion
FROM	tipo_zona
WHERE	cia	= @CIA
AND		ID_ESTADO = '01'
ORDER	BY descripcion
GO
/****** Object:  StoredProcedure [dbo].[SP_LISTAR_COMOBO_OP]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE [dbo].[SP_LISTAR_COMOBO_OP]
@CIA CHAR(2)
AS
SELECT ID_TIPO_DOC,DESCRIPCION FROM TIPO_DOCUMENTO
WHERE CIA=@CIA AND (ID_TIPO_DOC='21' OR ID_TIPO_DOC='26')
GO
/****** Object:  StoredProcedure [dbo].[SP_LISTAR_COMPANIA]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
SELECT ID_ESTADO,* FROM COMPANIA
[SP_LISTAR_COMPANIA] 'rcidat'
[SP_LISTAR_COMPANIA] '[SELECCIONE]'
*/
CREATE Proc [dbo].[SP_LISTAR_COMPANIA]
@NAMEBD  VARCHAR(30)
AS
------------------------------------------
------------------------------------------

EXEC('
		SELECT	CIA, DESCRIPCION
		FROM	' + @NAMEBD + '.DBO.COMPANIA where id_estado=''01''  order by DESCRIPCION DESC
		IF @@ERROR <> 0	BEGIN
			SELECT	CIA, DESCRIPCION	FROM	DBO.COMPANIA	
			order by DESCRIPCION
		END	'
	)
GO
/****** Object:  StoredProcedure [dbo].[SP_LISTAR_CRONOGRAMA]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
sp_help ocurrencia
SELECT * from NETDAT.dbo.MOTIVO_SERVICIO
SELECT * from  ESTADO
SP_ORDEN_SERVTECNICO_CRONOGRAMA '01','01','86','0001','',''
SP_ORDEN_SERVTECNICO_CRONOGRAMA '01','01','86','0001','00000001',''
SP_ORDEN_SERVTECNICO_CRONOGRAMA '01','01','86','0001','','42953327'

SP_LISTAR_CRONOGRAMA '01','01','86','0000','',''
SP_LISTAR_CRONOGRAMA '01','01','86','0000','','42953327'

select * from dbo.CRONOGRAMA_OPER where cia='01'  and sede='01' and id_tipo_doc ='86' and serie_doc='0001' and nro_doc='00000001'

*/
CREATE	PROC [dbo].[SP_LISTAR_CRONOGRAMA]
@CIA	 CHAR(2),		@SEDE  CHAR(2),	
@ID_TIPO_DOC	CHAR(2),@SERIE_DOC CHAR(4), @NRO_DOC VARCHAR(20), @id_tecnico VARCHAR(100)
AS
-----------------------------------------------------------------------------------------------------------------------
DECLARE @FECHA1 VARCHAR(8),@FECHA2 VARCHAR(8)
DECLARE @sSelect varchar(MAX),	@sInner varchar(MAX),	@sFiltroTecID varchar(MAX), @sFiltroNro_doc varchar(MAX)
DECLARE @sOrderBy varchar(MAX),			@sGroupBy varchar(MAX),		 @sExecute varchar(MAX)
----------------------------------------------------------------------------------------------------------------------
SELECT @sSelect='', @sInner='',  @sFiltroTecID='', @sFiltroNro_doc='',@sOrderBy='',@sGroupBy='',@sExecute=''
-----------------------------------------------------------------------------------------------------------------
SELECT @sSelect='
	co.nro_doc,co.nro_doc	FROM CRONOGRAMA_OPER co
	INNER JOIN ANALITICA A ON A.CIA=co.CIA AND A.ID_ANALITICA=co.id_tecnico
	WHERE co.CIA='''+@CIA+''' AND co.SEDE='''+@SEDE+''' AND co.id_tipo_doc='''+@id_tipo_doc+''' AND co.serie_doc='''+@serie_doc+'''
	AND co.ID_ESTADO=''11'' and co.flag_st=''0''	'
SELECT @sGroupBy=' GROUP by	co.nro_doc,co.nro_doc' 	
	------------------------------------------------------------------------------------------------------------------
	IF  LEN(ISNULL(@nro_doc,''))>0 
			BEGIN    SELECT @sFiltroNro_doc		=' and co.nro_doc  in('''+@nro_doc+''')'	 END
	ELSE	BEGIN    SELECT @sFiltroNro_doc	='' eND
	------------------------------------------------------------------------------------------------------------------
	IF  LEN(ISNULL(@id_tecnico,''))>0 
			BEGIN 	 SELECT @sFiltroTecID	=' and co.id_tecnico  in('''+@id_tecnico+''')' 	 END
	ELSE	BEGIN    SELECT @sFiltroTecID	=''		END
	--------------------------------------------------------------------------------------------	
	SELECT @sOrderBy	=' ORDER BY co.nro_doc'
	---------------------------------------------------------------------------------------------
	SELECT @sExecute = @sSelect  +''+   @sFiltroNro_doc  +''+ @sFiltroTecID+''+ @sGroupBy +''+@sOrderBy
 	PRINT @sExecute
	EXEC ('SELECT '+ @sExecute )	 
 	--------------------------------------------------------------------------------------------
GO
/****** Object:  StoredProcedure [dbo].[SP_LISTAR_E_CARA]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
SP_LISTAR_E_CARA '1','01','','',''
SP_LISTAR_E_CARA '2','01','','',''

SELECT * FROM dbo.E_ISLA

sp_help estado

*/
CREATE PROCEDURE [dbo].[SP_LISTAR_E_CARA]
@indicador CHAR(1),@cia CHAR(2),@id_cara char(2),@descripcion VARCHAR(30),@id_estado CHAR(2)
AS
--------------------------------------------------------------------------------------------------------------
DECLARE @sSelect varchar(MAX),@sFiltroID varchar(MAX),@sFiltroDescripcion varchar(MAX),@sFiltroEstado varchar(MAX),
	@sOrderBy varchar(MAX),@sGroupBy varchar(MAX),@sExecute varchar(MAX)
SELECT @sSelect='',@sFiltroID='',@sFiltroDescripcion='',@sFiltroEstado='',@sOrderBy='',@sGroupBy='',@sExecute=''
---------------------------------------------------------------------------------------------------------------
IF(@INDICADOR='1')
BEGIN
	SELECT @sSelect='
		 ec.id_cara, UPPER(ec.descripcion) ''descripcion'',e.abreviatura ''estado''	FROM e_cara	AS ec
		LEFT JOIN estado e ON e.cia=ec.cia and e.id_estado=ec.id_estado 
		WHERE ec.CIA='''+@CIA+'''	'
		--------------------------------------------------------------------------------------------------------
		IF  LEN(ISNULL(@id_cara,''))>0 
				BEGIN SELECT @sFiltroID =' and U.id_cara  in('''+@id_cara+''')'	 END
		ELSE	BEGIN SELECT @sFiltroID=''	END
		--------------------------------------------------------------------------------------------------------
		IF  LEN(ISNULL(@descripcion,''))>0 
				BEGIN SELECT @sFiltroDescripcion =' and ec.descripcion  like '''+@descripcion+''' +''%'' ' END	 
		ELSE	BEGIN SELECT @sFiltroDescripcion=''	END
		--------------------------------------------------------------------------------------------------------
		IF  LEN(ISNULL(@id_estado,''))>0 AND  @id_estado<>'%' 
				BEGIN SELECT @sFiltroEstado =' and ec.id_estado in('''+@id_estado+''')' 	 END
		ELSE	BEGIN SELECT @sFiltroEstado=''	END
		--------------------------------------------------------------------------------------------------------
		SELECT @sOrderBy	=' order by ec.id_cara'
		SELECT @sExecute = @sSelect  +''+@sFiltroID+''+ @sFiltroDescripcion +''+@sFiltroEstado+''+@sOrderBy
 		PRINT @sExecute
		EXEC ('SELECT '+ @sExecute )	
END
---------------------------------------------------------------------------------------------------------------
IF(@INDICADOR='2')
BEGIN
	SELECT @sSelect='
		 ec.id_cara, UPPER(ec.descripcion) ''descripcion''	FROM e_cara	AS ec
		LEFT JOIN estado e ON e.cia=ec.cia and e.id_estado=ec.id_estado 
		WHERE ec.CIA='''+@CIA+'''	'
		--------------------------------------------------------------------------------------------------------
		IF  LEN(ISNULL(@id_cara,''))>0 
				BEGIN SELECT @sFiltroID =' and U.id_cara  in('''+@id_cara+''')'	 END
		ELSE	BEGIN SELECT @sFiltroID=''	END
		--------------------------------------------------------------------------------------------------------
		IF  LEN(ISNULL(@descripcion,''))>0 
				BEGIN SELECT @sFiltroDescripcion =' and ec.descripcion  like '''+@descripcion+''' +''%'' ' END	 
		ELSE	BEGIN SELECT @sFiltroDescripcion=''	END
		--------------------------------------------------------------------------------------------------------
		SELECT @sOrderBy	=' order by ec.id_cara'
		SELECT @sExecute = @sSelect  +''+@sFiltroID+''+ @sFiltroDescripcion +''+@sOrderBy
 		PRINT @sExecute
		EXEC ('SELECT '+ @sExecute )	
END
---------------------------------------------------------------------------------------------------------------
GO
/****** Object:  StoredProcedure [dbo].[SP_LISTAR_E_IMPRESORA]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
SP_LISTAR_E_IMPRESORA '1','01','02','','',''
SP_LISTAR_E_IMPRESORA '2','01','02','','',''

SELECT * FROM dbo.E_IMPRESORA
SELECT * FROM dbo.E_MANGUERA

sp_help estado

*/
CREATE PROCEDURE [dbo].[SP_LISTAR_E_IMPRESORA]
@indicador CHAR(1),@cia CHAR(2),@sede CHAR(2),@id_impresora char(2),@descripcion VARCHAR(30),@id_estado CHAR(2)
AS
--------------------------------------------------------------------------------------------------------------
DECLARE @sSelect varchar(MAX),@sFiltroID varchar(MAX),@sFiltroDescripcion varchar(MAX),@sFiltroEstado varchar(MAX),
	@sOrderBy varchar(MAX),@sGroupBy varchar(MAX),@sExecute varchar(MAX)
SELECT @sSelect='',@sFiltroID='',@sFiltroDescripcion='',@sFiltroEstado='',@sOrderBy='',@sGroupBy='',@sExecute=''
---------------------------------------------------------------------------------------------------------------
IF(@INDICADOR='1')
BEGIN
	SELECT @sSelect='
		 ei.id_impresora, UPPER(ei.descripcion) ''descripcion'',
		 UPPER(ei.serie_equipo) as ''serie_equipo'' , UPPER(ei.autorizacion) as ''autorizacion'' , 
		UPPER(td.descripcion) as ''id_tipo_doc'' ,ei.nro_doc_del, ei.nro_doc_al   , ei.serie_doc    , ei.correlativo,
		 e.abreviatura ''estado''	FROM  e_impresora AS ei
		LEFT JOIN estado e ON e.cia=ei.cia and e.id_estado=ei.id_estado 
		LEFT JOIN tipo_documento td ON td.cia=ei.cia and td.id_tipo_doc=ei.id_tipo_doc 
		WHERE ei.CIA='''+@CIA+'''	and ei.sede='''+@sede+''''
		--------------------------------------------------------------------------------------------------------
		IF  LEN(ISNULL(@id_impresora,''))>0 
				BEGIN SELECT @sFiltroID =' and  ei.id_impresora  in('''+@id_impresora+''')'	 END
		ELSE	BEGIN SELECT @sFiltroID=''	END
		--------------------------------------------------------------------------------------------------------
		IF  LEN(ISNULL(@descripcion,''))>0 
				BEGIN SELECT @sFiltroDescripcion =' and ei.descripcion  like '''+@descripcion+''' +''%'' ' END	 
		ELSE	BEGIN SELECT @sFiltroDescripcion=''	END
		--------------------------------------------------------------------------------------------------------
		IF  LEN(ISNULL(@id_estado,''))>0 AND  @id_estado<>'%' 
				BEGIN SELECT @sFiltroEstado =' and ec.id_estado in('''+@id_estado+''')' 	 END
		ELSE	BEGIN SELECT @sFiltroEstado=''	END
		--------------------------------------------------------------------------------------------------------
		SELECT @sOrderBy	=' order by  ei.id_impresora'
		SELECT @sExecute = @sSelect  +''+@sFiltroID+''+ @sFiltroDescripcion +''+@sFiltroEstado+''+@sOrderBy
 		PRINT @sExecute
		EXEC ('SELECT '+ @sExecute )	
END
---------------------------------------------------------------------------------------------------------------
IF(@INDICADOR='2')
BEGIN
	SELECT @sSelect='
		 ei.id_impresora, UPPER(ei.descripcion) ''descripcion''	FROM  e_impresora AS ei
		LEFT JOIN estado e ON e.cia=ei.cia and e.id_estado=ei.id_estado 	
		WHERE ei.CIA='''+@CIA+'''	and ei.sede='''+@sede+''''
		--------------------------------------------------------------------------------------------------------
		IF  LEN(ISNULL(@id_impresora,''))>0 
				BEGIN SELECT @sFiltroID =' and  ei.id_impresora  in('''+@id_impresora+''')'	 END
		ELSE	BEGIN SELECT @sFiltroID=''	END
		--------------------------------------------------------------------------------------------------------
		IF  LEN(ISNULL(@descripcion,''))>0 
				BEGIN SELECT @sFiltroDescripcion =' and ei.descripcion  like '''+@descripcion+''' +''%'' ' END	 
		ELSE	BEGIN SELECT @sFiltroDescripcion=''	END
		--------------------------------------------------------------------------------------------------------
		SELECT @sOrderBy	=' order by  ei.id_impresora'
		SELECT @sExecute = @sSelect  +''+@sFiltroID+''+ @sFiltroDescripcion +''+@sOrderBy
 		PRINT @sExecute
		EXEC ('SELECT '+ @sExecute )	
END
---------------------------------------------------------------------------------------------------------------
GO
/****** Object:  StoredProcedure [dbo].[SP_LISTAR_E_ISLA]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
SP_LISTAR_E_ISLA '1','01','','',''
SP_LISTAR_E_ISLA '2','01','','',''

SELECT * FROM dbo.E_ISLA

sp_help estado
*/
CREATE PROCEDURE [dbo].[SP_LISTAR_E_ISLA]
@indicador CHAR(1),@cia CHAR(2),@id_isla char(2),@descripcion VARCHAR(30),@id_estado CHAR(2)
AS
--------------------------------------------------------------------------------------------------------------
DECLARE @sSelect varchar(MAX),@sFiltroID varchar(MAX),@sFiltroDescripcion varchar(MAX),@sFiltroEstado varchar(MAX),
	@sOrderBy varchar(MAX),@sGroupBy varchar(MAX),@sExecute varchar(MAX)
SELECT @sSelect='',@sFiltroID='',@sFiltroDescripcion='',@sFiltroEstado='',@sOrderBy='',@sGroupBy='',@sExecute=''
---------------------------------------------------------------------------------------------------------------
IF(@INDICADOR='1')
BEGIN
	SELECT @sSelect='
		 ei.id_isla, UPPER(ei.descripcion) ''descripcion'',e.abreviatura ''estado''	FROM e_isla	AS ei
		LEFT JOIN estado e ON e.cia=ei.cia and e.id_estado=ei.id_estado 
		WHERE ei.CIA='''+@CIA+'''	'
		--------------------------------------------------------------------------------------------------------
		IF  LEN(ISNULL(@id_isla,''))>0 
				BEGIN SELECT @sFiltroID =' and ei.id_isla  in('''+@id_isla+''')'	 END
		ELSE	BEGIN SELECT @sFiltroID=''	END
		--------------------------------------------------------------------------------------------------------
		IF  LEN(ISNULL(@descripcion,''))>0 
				BEGIN SELECT @sFiltroDescripcion =' and ei.descripcion  like '''+@descripcion+''' +''%'' ' END	 
		ELSE	BEGIN SELECT @sFiltroDescripcion=''	END
		--------------------------------------------------------------------------------------------------------
		IF  LEN(ISNULL(@id_estado,''))>0 AND  @id_estado<>'%' 
				BEGIN SELECT @sFiltroEstado =' and ei.id_estado in('''+@id_estado+''')' 	 END
		ELSE	BEGIN SELECT @sFiltroEstado=''	END
		--------------------------------------------------------------------------------------------------------
		SELECT @sOrderBy	=' order by  ei.id_isla'
		SELECT @sExecute = @sSelect  +''+@sFiltroID+''+ @sFiltroDescripcion +''+@sFiltroEstado+''+@sOrderBy
 		PRINT @sExecute
		EXEC ('SELECT '+ @sExecute )	
END
---------------------------------------------------------------------------------------------------------------
IF(@INDICADOR='2')
BEGIN
	SELECT @sSelect='
		 ei.id_isla, UPPER(ei.descripcion) ''descripcion'',e.abreviatura ''estado''	FROM e_isla	AS ei
		LEFT JOIN estado e ON e.cia=ei.cia and e.id_estado=ei.id_estado 
		WHERE ei.CIA='''+@CIA+'''	'
		--------------------------------------------------------------------------------------------------------
		IF  LEN(ISNULL(@id_isla,''))>0 
				BEGIN SELECT @sFiltroID =' and ei.id_isla  in('''+@id_isla+''')'	 END
		ELSE	BEGIN SELECT @sFiltroID=''	END
		--------------------------------------------------------------------------------------------------------
		IF  LEN(ISNULL(@descripcion,''))>0 
				BEGIN SELECT @sFiltroDescripcion =' and ei.descripcion  like '''+@descripcion+''' +''%'' ' END	 
		ELSE	BEGIN SELECT @sFiltroDescripcion=''	END
		--------------------------------------------------------------------------------------------------------
		SELECT @sOrderBy	=' order by ei.id_isla'
		SELECT @sExecute = @sSelect  +''+@sFiltroID+''+ @sFiltroDescripcion +''+@sOrderBy
 		PRINT @sExecute
		EXEC ('SELECT '+ @sExecute )	
END
---------------------------------------------------------------------------------------------------------------
GO
/****** Object:  StoredProcedure [dbo].[SP_LISTAR_E_MANGUERA]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
SP_LISTAR_E_MANGUERA '1','01','02','','',''
SP_LISTAR_E_MANGUERA '2','01','02','','',''

SELECT * FROM dbo.e_MANGUERA
sp_help e_MANGUERA
sp_help estado

*/
CREATE PROCEDURE [dbo].[SP_LISTAR_E_MANGUERA]
@indicador CHAR(1),@cia CHAR(2),@sede char(2),@id_manguera char(2),@descripcion VARCHAR(30),@id_estado CHAR(2)
AS
--------------------------------------------------------------------------------------------------------------
DECLARE @sSelect varchar(MAX),@sFiltroID varchar(MAX),@sFiltroDescripcion varchar(MAX),@sFiltroEstado varchar(MAX),
	@sOrderBy varchar(MAX),@sGroupBy varchar(MAX),@sExecute varchar(MAX)
SELECT @sSelect='',@sFiltroID='',@sFiltroDescripcion='',@sFiltroEstado='',@sOrderBy='',@sGroupBy='',@sExecute=''
---------------------------------------------------------------------------------------------------------------
IF(@INDICADOR='1')
BEGIN
	SELECT @sSelect='
		em.id_manguera, UPPER(em.descripcion) ''descripcion'',
		ei.id_isla , UPPER(ei.descripcion)  ''isla'',
		es.id_surtidor ,UPPER(es.descripcion)  ''surtidor'' , 
		ec.id_cara ,  UPPER(ec.descripcion)  ''cara'', 
		ep.id_impresora , UPPER(ep.descripcion)  ''impresora'',
		a.id_articulo ,UPPER(a.descripcion) as ''articulo'', 
		em.id_estado,(e.abreviatura) as ''estado'',(e.descripcion) as ''descripcion_estado''	FROM  e_manguera	as em 
		LEFT JOIN estado		e ON e.cia=em.cia and e.id_estado=em.id_estado 
		LEFT JOIN e_isla		ei on ei.cia=em.cia and ei.id_isla=em.id_isla
		LEFT JOIN e_surtidor	es on es.cia=em.cia and  es.id_surtidor=em.id_surtidor
		LEFT JOIN e_cara		ec on ec.cia=em.cia and  ec.id_cara=em.id_Cara
		LEFT JOIN e_impresora	ep on ep.cia=em.cia and  ep.sede=em.sede and ep.id_impresora = em.id_impresora
		left join articulo		a on a.cia=em.cia and a.id_articulo=em.id_articulo
		WHERE em.CIA='''+@CIA+''' and	em.sede='''+@sede+''''
		--------------------------------------------------------------------------------------------------------
		IF  LEN(ISNULL(@id_manguera,''))>0 
				BEGIN SELECT @sFiltroID =' and  em.id_manguera  in('''+@id_manguera+''')'	 END
		ELSE	BEGIN SELECT @sFiltroID=''	END
		--------------------------------------------------------------------------------------------------------
		IF  LEN(ISNULL(@descripcion,''))>0 
				BEGIN SELECT @sFiltroDescripcion =' and em.descripcion  like '''+@descripcion+''' +''%'' ' END	 
		ELSE	BEGIN SELECT @sFiltroDescripcion=''	END
		--------------------------------------------------------------------------------------------------------
		IF  LEN(ISNULL(@id_estado,''))>0 AND  @id_estado<>'%' 
				BEGIN SELECT @sFiltroEstado =' and em.id_estado in('''+@id_estado+''')' 	 END
		ELSE	BEGIN SELECT @sFiltroEstado=''	END
		--------------------------------------------------------------------------------------------------------
		SELECT @sOrderBy	=' order by  em.id_manguera'
		SELECT @sExecute = @sSelect  +''+@sFiltroID+''+ @sFiltroDescripcion +''+@sFiltroEstado+''+@sOrderBy
 		PRINT @sExecute
		EXEC ('SELECT '+ @sExecute )	
END
---------------------------------------------------------------------------------------------------------------
IF(@INDICADOR='2')
BEGIN
	SELECT @sSelect='
		em.id_manguera, UPPER(em.descripcion) ''descripcion'' FROM  e_manguera	as em 
		LEFT JOIN estado		e ON e.cia=em.cia and e.id_estado=em.id_estado 		
		WHERE em.CIA='''+@CIA+''' and	em.sede='''+@sede+''''
		--------------------------------------------------------------------------------------------------------
		IF  LEN(ISNULL(@id_manguera,''))>0 
				BEGIN SELECT @sFiltroID =' and  em.id_manguera  in('''+@id_manguera+''')'	 END
		ELSE	BEGIN SELECT @sFiltroID=''	END
		--------------------------------------------------------------------------------------------------------
		IF  LEN(ISNULL(@descripcion,''))>0 
				BEGIN SELECT @sFiltroDescripcion =' and em.descripcion  like '''+@descripcion+''' +''%'' ' END	 
		ELSE	BEGIN SELECT @sFiltroDescripcion=''	END
		--------------------------------------------------------------------------------------------------------
		SELECT @sOrderBy	=' order by em.id_manguera'
		SELECT @sExecute = @sSelect  +''+@sFiltroID+''+ @sFiltroDescripcion +''+@sOrderBy
 		PRINT @sExecute
		EXEC ('SELECT '+ @sExecute )	
END
---------------------------------------------------------------------------------------------------------------
GO
/****** Object:  StoredProcedure [dbo].[SP_LISTAR_E_SURTIDOR]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
SP_LISTAR_E_SURTIDOR '1','01','','',''
SP_LISTAR_E_SURTIDOR '2','01','','',''
SELECT * FROM dbo.E_SURTIDOR
sp_help estado
*/
CREATE PROCEDURE [dbo].[SP_LISTAR_E_SURTIDOR]
@indicador CHAR(1),@cia CHAR(2),@id_surtidor char(2),@descripcion VARCHAR(30),@id_estado CHAR(2)
AS
--------------------------------------------------------------------------------------------------------------
DECLARE @sSelect varchar(MAX),@sFiltroID varchar(MAX),@sFiltroDescripcion varchar(MAX),@sFiltroEstado varchar(MAX),
	@sOrderBy varchar(MAX),@sGroupBy varchar(MAX),@sExecute varchar(MAX)
SELECT @sSelect='',@sFiltroID='',@sFiltroDescripcion='',@sFiltroEstado='',@sOrderBy='',@sGroupBy='',@sExecute=''
---------------------------------------------------------------------------------------------------------------
IF(@INDICADOR='1')
BEGIN
	SELECT @sSelect='
		 es.id_surtidor, UPPER(es.descripcion) ''descripcion'',e.abreviatura ''estado''	FROM e_surtidor	AS es
		LEFT JOIN estado e ON e.cia=es.cia and e.id_estado=es.id_estado 
		WHERE es.CIA='''+@CIA+'''	'
		--------------------------------------------------------------------------------------------------------
		IF  LEN(ISNULL(@id_surtidor,''))>0 
				BEGIN SELECT @sFiltroID =' and es.id_surtidor  in('''+@id_surtidor+''')'	 END
		ELSE	BEGIN SELECT @sFiltroID=''	END
		--------------------------------------------------------------------------------------------------------
		IF  LEN(ISNULL(@descripcion,''))>0 
				BEGIN SELECT @sFiltroDescripcion =' and es.descripcion  like '''+@descripcion+''' +''%'' ' END	 
		ELSE	BEGIN SELECT @sFiltroDescripcion=''	END
		--------------------------------------------------------------------------------------------------------
		IF  LEN(ISNULL(@id_estado,''))>0 AND  @id_estado<>'%' 
				BEGIN SELECT @sFiltroEstado =' and es.id_estado in('''+@id_estado+''')' 	 END
		ELSE	BEGIN SELECT @sFiltroEstado=''	END
		--------------------------------------------------------------------------------------------------------
		SELECT @sOrderBy	=' order by es.id_surtidor'
		SELECT @sExecute = @sSelect  +''+@sFiltroID+''+ @sFiltroDescripcion +''+@sFiltroEstado+''+@sOrderBy
 		PRINT @sExecute
		EXEC ('SELECT '+ @sExecute )	
END
---------------------------------------------------------------------------------------------------------------
IF(@INDICADOR='2')
BEGIN
	SELECT @sSelect='
		es.id_surtidor, UPPER(es.descripcion) ''descripcion''	FROM e_surtidor	AS es
		LEFT JOIN estado e ON e.cia=es.cia and e.id_estado=es.id_estado 
		WHERE es.CIA='''+@CIA+'''	'
		--------------------------------------------------------------------------------------------------------
		IF  LEN(ISNULL(@id_surtidor,''))>0 
				BEGIN SELECT @sFiltroID =' and es.id_surtidor  in('''+@id_surtidor+''')'	 END
		ELSE	BEGIN SELECT @sFiltroID=''	END
		--------------------------------------------------------------------------------------------------------
		IF  LEN(ISNULL(@descripcion,''))>0 
				BEGIN SELECT @sFiltroDescripcion =' and es.descripcion  like '''+@descripcion+''' +''%'' ' END	 
		ELSE	BEGIN SELECT @sFiltroDescripcion=''	END
		--------------------------------------------------------------------------------------------------------
		SELECT @sOrderBy	=' order by es.id_surtidor'
		SELECT @sExecute = @sSelect  +''+@sFiltroID+''+ @sFiltroDescripcion +''+@sOrderBy
 		PRINT @sExecute
		EXEC ('SELECT '+ @sExecute )	
END
---------------------------------------------------------------------------------------------------------------
GO
/****** Object:  StoredProcedure [dbo].[SP_Listar_Especialidad]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[SP_Listar_Especialidad]
as
select idesp,nomesp from especialidad
GO
/****** Object:  StoredProcedure [dbo].[SP_LISTAR_ESTADO_DOCUMENTO]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*

SP_LISTAR_ESTADO_DOCUMENTO '01'

*/
--------------------------------------
--------------------------------------
CREATE	PROCEDURE	[dbo].[SP_LISTAR_ESTADO_DOCUMENTO]
@CIA	CHAR(2)
AS
--------------------------------------
--------------------------------------
SELECT	ID_ESTADO, UPPER(DESCRIPCION) AS 'DESCRIPCION' 
FROM	ESTADO 
WHERE	CIA				= @CIA
AND		FLAG_DOCUMENTO	= 1 
ORDER	BY 'DESCRIPCION'
GO
/****** Object:  StoredProcedure [dbo].[SP_LISTAR_ESTADOS]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
SELECT * FROM ESTADO
[SP_LISTAR_ESTADOS] '01'
*/
create	PROCEDURE [dbo].[SP_LISTAR_ESTADOS]
@CIA CHAR(2)
AS
---------------------------------
SELECT id_estado as 'id_estado', 
descripcion as 'descripcion'
FROM estado
WHERE cia=@CIA 
AND	flag_general='1'
GO
/****** Object:  StoredProcedure [dbo].[SP_LISTAR_MARCA_ARTICULO]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
[SP_LISTAR_MARCA_ARTICULO] '1','01','','',''
[SP_LISTAR_MARCA_ARTICULO] '2','01','','',''
select * from marca_articulo
*/
CREATE PROCEDURE [dbo].[SP_LISTAR_MARCA_ARTICULO]
@INDICADOR	CHAR(1),@CIA  CHAR(2),@CODIGO CHAR(3),@DESCRIPCION  VARCHAR(60),@ID_ESTADO CHAR(2)
as
------------------------------------------------------------------------------------------------
DECLARE @sExecute varchar(max),@sSelect varchar(max),@sFiltroID varchar(max),
	@sFiltroDescripcion varchar(max),@sFiltroEstado varchar(max),@sGroupby varchar(max),@sOrderby varchar(max)
SELECT @sExecute='',  @sSelect='', @sFiltroID='',@sFiltroDescripcion='',@sOrderBy='',@sGroupBy=''
-----------------------------------------------------------------------------------------------
IF(@INDICADOR='1')
BEGIN
	SELECT @sSelect='ma.id_marca, UPPER(ma.descripcion) ''descripcion'',
	ma.id_estado,e.descripcion ''desc_estado'',e.abreviatura 	FROM marca_articulo	 ma
	LEFT JOIN estado e ON e.cia=ma.cia and e.id_estado=ma.id_estado 
	where ma.CIA='''+@CIA+'''	'	 
	--------------------------------------------------------------------------------------------------------
	IF  LEN(ISNULL(@CODIGO,''))>0 AND  @CODIGO<>'%' 
			BEGIN    SELECT @sFiltroID	=' and ma.id_marca like ''%''+'''+@CODIGO+''' +''%'' ' END
	ELSE	BEGIN   SELECT @sFiltroID	=''		END
	--------------------------------------------------------------------------------------------------------
	IF  LEN(ISNULL(@DESCRIPCION ,''))>0 
			BEGIN    SELECT @sFiltroDescripcion	=' and ma.descripcion like ''%''+'''+@DESCRIPCION+''' +''%'' ' END
	ELSE	BEGIN   SELECT @sFiltroDescripcion	=''		END
	--------------------------------------------------------------------------------------------------------
		IF  LEN(ISNULL(@id_estado,''))>0 AND  @id_estado<>'%' 
				BEGIN SELECT @sFiltroEstado =' and um.id_estado in('''+@id_estado+''')' 	 END
		ELSE	BEGIN SELECT @sFiltroEstado=''	END
	--------------------------------------------------------------------------------------------------------
	SELECT @sOrderby='ORDER BY  ma.id_marca'
	-------------------------------------------------------------------------------
	SELECT @sExecute = @sSelect +' '+ @sFiltroID +' '+ @sFiltroDescripcion +' '+@sFiltroEstado+' '+@sOrderby
	-------------------------------------------------------------------------------
	PRINT @sExecute
	EXEC ('SELECT '+ @sExecute )

END
-----------------------------------------------------------------------
IF(@INDICADOR='2')
BEGIN
	SELECT @sSelect='ma.id_marca, UPPER(ma.descripcion) ''descripcion'' FROM marca_articulo	 ma
	LEFT JOIN estado e ON e.cia=ma.cia and e.id_estado=ma.id_estado 
	where ma.CIA='''+@CIA+'''	'	 
	--------------------------------------------------------------------------------------------------------
	IF  LEN(ISNULL(@CODIGO,''))>0 AND  @CODIGO<>'%' 
			BEGIN    SELECT @sFiltroID	=' and ma.id_marca like ''%''+'''+@CODIGO+''' +''%'' ' END
	ELSE	BEGIN   SELECT @sFiltroID	=''		END
	--------------------------------------------------------------------------------------------------------
	IF  LEN(ISNULL(@DESCRIPCION ,''))>0 
			BEGIN    SELECT @sFiltroDescripcion	=' and ma.descripcion like ''%''+'''+@DESCRIPCION+''' +''%'' ' END
	ELSE	BEGIN   SELECT @sFiltroDescripcion	=''		END
	--------------------------------------------------------------------------------------------------------
	SELECT @sOrderby='ORDER BY  ma.id_marca'
	-------------------------------------------------------------------------------
	SELECT @sExecute = @sSelect +' '+ @sFiltroID +' '+ @sFiltroDescripcion +' '+@sOrderby
	-------------------------------------------------------------------------------
	PRINT @sExecute
	EXEC ('SELECT '+ @sExecute )
END
GO
/****** Object:  StoredProcedure [dbo].[SP_LISTAR_MENU_TITULO]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
select * from acceso where flag_web='1'
GO
*/
CREATE PROC [dbo].[SP_LISTAR_MENU_TITULO]
AS
SELECT	A.ID_ACCESO, A.DESCRIPCION,
		UPPER(A.DESCRIPCION_CORTA) AS DESCRIPCION_CORTA
FROM	ACCESO AS A
WHERE FLAG_WEB='1'	
and id_acceso=0
--	update  acceso set FLAG_WEB='1' WHERE  id_acceso=0
GO
/****** Object:  StoredProcedure [dbo].[SP_LISTAR_MENUS]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SP_LISTAR_MENUS]
AS
SELECT	A.ID_ACCESO, 
		A.DESCRIPCION_CORTA, 
		A.NOMBRE_EXE,	A.ID_ACCESO_SUPERIOR,
		A.ORDEN,a.FLAG_CONTROL
FROM Acceso AS A
WHERE	ID_ACCESO	<	100
AND	    ID_ACCESO	>	1
AND		FLAG_WEB = '1'
ORDER BY	ORDEN
/*
UPDATE ACCESO SET FLAG_WEB = '1' WHERE	ID_ACCESO	<	100 AND	    ID_ACCESO	>	1 AND		FLAG_WEB = '1'
*/
GO
/****** Object:  StoredProcedure [dbo].[SP_LISTAR_MENUS_HIJOS]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
select * from acceso  WHERE flag_ocultar_acceso='1'

SP_LISTAR_MENUS
[SP_LISTAR_MENUS_HIJOS] '1','8920'
[SP_LISTAR_MENUS_HIJOS] '0','8920'
[SP_LISTAR_MENUS_HIJOS] '1','8910'
select * from usuario
select * from acceso where id_acceso LIKE ('8920%') AND ID_ESTADO ='01'
update acceso set flag_ocultar_acceso='1' where id_acceso  in ('892010','892020','892030')
update acceso set flag_ocultar_acceso='0' where id_acceso NOT  in ('892040')
update acceso set FLAG_CONTROL='1' where id_acceso  in ('891010')
EXEC	SP_VALIDARLOGIN 'ADMIN', '123'
*/
CREATE PROC [dbo].[SP_LISTAR_MENUS_HIJOS]
@FLAG_ACESSO	CHAR(1),@ID_ACCESO		INT	
AS
-----------------------------------------------------------------------------------------------------------------------
DECLARE @sSelect varchar(MAX),@sFiltroID_ACCESO varchar(MAX), @sFiltroFLAG_ACESSO varchar(MAX)
DECLARE @sOrderBy varchar(MAX), @sGroupBy varchar(MAX), @sExecute varchar(MAX)
----------------------------------------------------------------------------------------------------------------------
SELECT @sSelect='', @sFiltroID_ACCESO='', @sFiltroFLAG_ACESSO='', @sOrderBy='',@sGroupBy='',@sExecute=''
-----------------------------------------------------------------------------------------------------------------
IF(@FLAG_ACESSO='1')
BEGIN	
	select A.ID_ACCESO,	A.DESCRIPCION_CORTA, 
		A.NOMBRE_EXE,	A.ID_ACCESO_SUPERIOR,
		A.FLAG_WEB,		a.FLAG_OCULTAR_ACCESO,A.FLAG_ACCESO_DIRECTO,A.FLAG_CONTROL
		FROM	ACCESO AS A	
		WHERE	ID_ACCESO			 >	 LEN(@ID_ACCESO) 
		AND		ID_ACCESO_SUPERIOR	 =	 @ID_ACCESO	
		AND		A.ID_ESTADO			 =		'01'
	 ORDER BY ORDEN
END
-----------------------------------------------------------
IF(@FLAG_ACESSO='0')
BEGIN
		select A.ID_ACCESO,	A.DESCRIPCION_CORTA, 
		A.NOMBRE_EXE,	A.ID_ACCESO_SUPERIOR,
		A.FLAG_WEB,		a.FLAG_OCULTAR_ACCESO,A.FLAG_ACCESO_DIRECTO,A.FLAG_CONTROL
		FROM	ACCESO AS A	
		WHERE	ID_ACCESO			 >	 LEN(@ID_ACCESO) 
		AND		ID_ACCESO_SUPERIOR	 =	 @ID_ACCESO
		AND		FLAG_OCULTAR_ACCESO	 =	@FLAG_ACESSO	
		AND		A.ID_ESTADO			 =		'01'
		 ORDER BY ORDEN
END
-----------------------------------------------------------
GO
/****** Object:  StoredProcedure [dbo].[SP_LISTAR_MONEDA]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
sp_help INVENTARIO_MOV
SELECT * FROM INVENTARIO_MOV
SELECT * FROM TIPO_DOCUMENTO
SELECT * FROM moneda
SP_LISTAR_MONEDA '1','01','',''
SP_LISTAR_MONEDA '2','01','02',''
*/

---------------------------------------------------------------
CREATE PROC [dbo].[SP_LISTAR_MONEDA]
@INDICADOR CHAR(1),@cia CHAR(2),@id_moneda CHAR(2),@descripcion VARCHAR(100)
AS
---------------------------------------------------------------------------------
DECLARE @sSelect varchar(MAX),@sFiltroID VARCHAR(MAX),@sFiltroDescripcion varchar(MAX),
	@sOrderBy varchar(MAX),@sGroupBy varchar(MAX),@sExecute varchar(MAX)
SELECT @sSelect='',@sFiltroID='',@sFiltroDescripcion='',@sOrderBy='',@sGroupBy='',@sExecute=''
-------------------------------------------------------------------------
IF(@INDICADOR='1')
BEGIN
	SELECT @sSelect='
	m.id_moneda, m.descripcion  ''descripcion'',m.abreviatura,m.id_estado,    
	e.descripcion ''estado'' FROM moneda	m
	LEFT JOIN estado e ON e.cia=m.cia and e.id_estado=m.id_estado 
	WHERE m.CIA='''+@CIA+'''	ORDER BY   m.id_moneda		'
	SELECT @sExecute = @sSelect 
 	PRINT @sExecute
	EXEC ('SELECT '+ @sExecute )
END
-------------------------------------------------------------------------
IF(@INDICADOR='2')
BEGIN
	SELECT @sSelect='
	m.id_moneda, m.descripcion  ''descripcion'' FROM moneda	AS m
	LEFT JOIN estado e ON e.cia=m.cia and e.id_estado=m.id_estado 
	WHERE m.CIA='''+@CIA+'''		'	
	-------------------------------------------------------------------------------
	IF  LEN(ISNULL(@id_moneda,''))>0 
			BEGIN 	   SELECT @sFiltroID =' and m.id_moneda  in('''+@id_moneda+''')'	 END
	ELSE	BEGIN       SELECT @sFiltroID=''	END
	-------------------------------------------------------------------------------
	IF  LEN(ISNULL(@descripcion,''))>0 
			BEGIN 	   SELECT @sFiltroDescripcion =' and m.descripcion like '''+@descripcion+''' +''%'' ' END	 
	ELSE	BEGIN       SELECT @sFiltroDescripcion=''	END
	-------------------------------------------------------------------------
	SELECT @sOrderBy='ORDER BY   m.id_moneda	'
	-------------------------------------------------------------------------
	SELECT @sExecute = @sSelect+''+  @sFiltroID +''+ @sFiltroDescripcion+''+ @sOrderBy
 	PRINT @sExecute
	EXEC ('SELECT '+ @sExecute )	
END
-------------------------------------------------------------------------
GO
/****** Object:  StoredProcedure [dbo].[SP_LISTAR_MONTAJE]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*

SELECT * FROM doc_gestion_fa

SELECT * FROM ANALITICA_CONTACTO

SELECT * FROM PUNTO_VENTA
20345774042
select * from condicion_pago
27/12/2010
*/

-- SP_LISTAR_MONTAJE 1,'01','01','','','','27/12/2008','27/12/2010'

CREATE PROCEDURE [dbo].[SP_LISTAR_MONTAJE]
@INDICADOR INT,@CIA CHAR(2),@SEDE CHAR(2),@SERIE_COT VARCHAR(4),@NRO_COT VARCHAR(20),@ESTACION VARCHAR(20),@INICIO DATETIME,@FIN DATETIME
AS
-------------------------------------------------------------------------------
DECLARE @FEC1 varchar(8),@FEC2 varchar(8),@sExecute varchar(max),@sSelect varchar(max),
		@sEstacion varchar(max),@sSerie varchar(max),@sNro varchar(max)	,@sGroupby varchar(max)	,@sHaving varchar(max)
-------------------------------------------------------------------------------
SET @FEC1=CONVERT(VARCHAR(8),@INICIO,112)
SET @FEC2=CONVERT(VARCHAR(8),@FIN,112)
--------------------------
SELECT @sExecute='',@sSelect='',@sEstacion='',@sSerie='',@sNro='',@sGroupby='',@sHaving=''
-------------------------------------------------------------------------------
IF @INDICADOR=1 
BEGIN
-------------------------------------------------------------------------------
SELECT @sSelect='
DGF.NRO_DOC ''ID'',DGF.ID_TIPO_DOC,DGF.SERIE_DOC,DGF.NRO_DOC,A.DESCRIPCION,DGF.REFERENCIA,AC.CONTACTO,
		CONVERT(VARCHAR(10),DGF.FECHA_DOCUMENTO,103) ''FECHA'',CP.DESCRIPCION ''TPAGO'',DGF.TOTAL_FINAL
FROM DOC_GESTION_FA DGF
INNER JOIN ANALITICA A ON A.CIA=DGF.CIA AND A.ID_ANALITICA=DGF.ID_CLIENTE
INNER JOIN ANALITICA_CONTACTO AC ON AC.CIA=DGF.CIA AND AC.ID_ANALITICA=DGF.ID_CLIENTE AND AC.ITEM=DGF.ID_CONTACTO
INNER JOIN CONDICION_PAGO CP ON CP.CIA=DGF.CIA AND CP.ID_CONDICION_PAGO=DGF.ID_CONDICION_PAGO
WHERE DGF.CIA='''+@CIA+''' AND DGF.SEDE='''+@SEDE+''' AND CONVERT(VARCHAR(8),DGF.FECHA_DOCUMENTO,112) BETWEEN '''+@FEC1+''' AND '''+@FEC2+'''
AND DGF.ID_ESTADO=''03'' AND DGF.ID_TIPO_DOC=''20'''
--------------------------
IF LEN(@ESTACION)>0 BEGIN SELECT @sEstacion=' AND DGF.ID_CLIENTE='''+@ESTACION+'''' END ELSE BEGIN SELECT @sEstacion='' END
SELECT @sExecute = @sSelect +' '+ @sEstacion +' '+ @sGroupby
EXEC ('SELECT '+ @sExecute )
-------------------------------------------------------------------------------	
END
-------------------------------------------------------------------------------
IF @INDICADOR=2
BEGIN
-------------------------------------------------------------------------------
SELECT @sSelect='
		DCC.ID_TIPO_DOC ''TFAC'',DCC.SERIE_DOC ''SFAC'',DCC.NRO_DOC ''NFAC'',DGFR.SERIE_DOC ''SCOT'',DGFR.NRO_DOC ''NCOT'',DCC.ID_CLIENTE,A.DESCRIPCION,
CONVERT(VARCHAR(10),DCC.FECHA_DOCUMENTO,103) ''FECHA'',CP.DESCRIPCION ''TPAGO'',DCC.TOTAL_FINAL
FROM DOCUMENTO_CC DCC 
INNER JOIN ANALITICA A ON A.CIA=DCC.CIA AND A.ID_ANALITICA=DCC.ID_CLIENTE
INNER JOIN CONDICION_PAGO CP ON CP.CIA=DCC.CIA AND CP.ID_CONDICION_PAGO=DCC.ID_CONDICION_PAGO
----------------------------------------------
INNER JOIN DOC_GESTION_FA_REF_DOC_CC DGFR ON  DCC.CIA=DGFR.CIA AND DCC.SEDE=DGFR.SEDE AND DCC.ID_TIPO_DOC=DGFR.ID_TIPO_DOC_REF 
AND DCC.SERIE_DOC=DGFR.SERIE_DOC_REF AND DCC.NRO_DOC=DGFR.NRO_DOC_REF
--------------------------------------------------------------------------------------------------------------------------
WHERE DCC.CIA='''+@CIA+''' AND DCC.SEDE='''+@SEDE+''' AND CONVERT(VARCHAR(8),DCC.FECHA_DOCUMENTO,112) >= '''+@FEC1+'''
AND DCC.ID_TIPO_DOC=''01'' AND DCC.ID_ESTADO=''13'''
--------------------------
IF LEN(@ESTACION)>0 BEGIN SELECT @sEstacion=' AND DCC.ID_CLIENTE='''+@ESTACION+'''' END ELSE BEGIN SELECT @sEstacion='' END
IF LEN(@SERIE_COT)>0 BEGIN SELECT @sSerie=' AND DCCG.SERIE_DOC_REF='''+@SERIE_COT+'''' END ELSE BEGIN SELECT @sSerie='' END
IF LEN(@NRO_COT)>0 BEGIN SELECT @sNro=' AND DCCG.NRO_DOC_REF='''+@NRO_COT+'''' END ELSE BEGIN SELECT @sNro='' END
SELECT @sGroupby=' GROUP BY DCC.ID_TIPO_DOC,DCC.SERIE_DOC,DCC.NRO_DOC,DCC.ID_CLIENTE,A.DESCRIPCION,
					CONVERT(VARCHAR(10),DCC.FECHA_DOCUMENTO,103),CP.DESCRIPCION,DCC.TOTAL_FINAL,DGFR.SERIE_DOC,DGFR.NRO_DOC'
SELECT @sExecute = @sSelect +' '+ @sEstacion +' '+@sSerie+' '+@sNro+' '+@sGroupby
EXEC ('SELECT '+ @sExecute )
-------------------------------------------------------------------------------	
END
-------------------------------------------------------------------------------
IF @INDICADOR=3
BEGIN
-------------------------------------------------------------------------------
SELECT @sSelect='
		DCC.NRO_DOC ''ID'',DCC.ID_TIPO_DOC,DCC.SERIE_DOC,DCC.NRO_DOC,A.DESCRIPCION,
		CONVERT(VARCHAR(10),DCC.FECHA_DOCUMENTO,103) ''FECHA'',CP.DESCRIPCION ''TPAGO'',DCC.TOTAL_FINAL
FROM DOCUMENTO_CC DCC
INNER JOIN ANALITICA A ON A.CIA=DCC.CIA AND A.ID_ANALITICA=DCC.ID_CLIENTE
INNER JOIN CONDICION_PAGO CP ON CP.CIA=DCC.CIA AND CP.ID_CONDICION_PAGO=DCC.ID_CONDICION_PAGO
----------------------------------------------
LEFT JOIN DOCUMENTO_CC_DETALLE DCCD ON DCC.CIA=DCCD.CIA AND DCC.SEDE=DCCD.SEDE AND 
DCC.ID_TIPO_DOC=DCCD.ID_TIPO_DOC AND DCC.SERIE_DOC=DCCD.SERIE_DOC AND DCC.NRO_DOC=DCCD.NRO_DOC
--------------------------------------------------------------------------------------------------------------------------
LEFT JOIN DOCUMENTO_CC_GESTION DCCG ON DCCD.CIA=DCCG.CIA AND DCCD.SEDE=DCCG.SEDE AND 
DCCD.ID_TIPO_DOC=DCCG.ID_TIPO_DOC AND DCCD.SERIE_DOC=DCCG.SERIE_DOC AND DCCD.NRO_DOC=DCCG.NRO_DOC AND DCCD.ITEM=DCCG.ITEM
--------------------------------------------------------------------------------------------------------------------------
WHERE DCC.CIA='''+@CIA+''' AND DCC.SEDE='''+@SEDE+''' AND DCC.ID_ESTADO=''13''
			AND CONVERT(VARCHAR(8),DCC.FECHA_DOCUMENTO,112)>='''+@FEC1+''' AND DCC.ID_TIPO_DOC=''01'''
--------------------------
IF LEN(@ESTACION)>0 BEGIN SELECT @sEstacion=' AND DCC.ID_CLIENTE='''+@ESTACION+'''' END ELSE BEGIN SELECT @sEstacion='' END
SELECT @sGroupby=' GROUP BY DCC.ID_TIPO_DOC,DCC.SERIE_DOC,DCC.NRO_DOC,A.DESCRIPCION,
					CONVERT(VARCHAR(10),DCC.FECHA_DOCUMENTO,103),CP.DESCRIPCION,DCC.TOTAL_FINAL'
SELECT @sExecute = @sSelect +' '+ @sEstacion +' '+@sGroupby
EXEC ('SELECT '+ @sExecute )
-------------------------------------------------------------------------------	
END
GO
/****** Object:  StoredProcedure [dbo].[SP_LISTAR_MOTIVO_ALMACEN]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
sp_help CLASIFICACION1
[SP_LISTAR_MOTIVO_ALMACEN] '1','01','ei',''
select * from motivo_almacen
*/
CREATE PROCEDURE [dbo].[SP_LISTAR_MOTIVO_ALMACEN]
@INDICADOR CHAR(1),@CIA  CHAR(2),@ID_MOTIVO_ALMACEN	CHAR(2),@DESCRIPCION VARCHAR(2)
AS
-----------------------------------------------------------------------------------------------------------------------
DECLARE @sOrderBy varchar(MAX), @sGroupBy varchar(MAX), @sExecute varchar(MAX),@sSelect varchar(MAX),
	@sFiltroAlmacen varchar(MAX),@sFiltroDescripcion varchar(MAX),@sFiltroEstado varchar(MAX)
SELECT @sSelect='',  @sFiltroAlmacen='', @sFiltroDescripcion ='', @sFiltroEstado ='',@sOrderBy='',@sGroupBy='',@sExecute=''
-----------------------------------------------------------------------------------------------------------------
IF(@INDICADOR='1')
BEGIN
	SELECT @sSelect= ' ma.id_motivo_almacen, UPPER(ma.descripcion) ''descripcion''	FROM motivo_almacen	ma
		--LEFT JOIN estado e ON e.cia=c.cia and e.id_estado=c.id_estado 	
			WHERE ma.CIA='''+@CIA+''' 		'
	--------------------------------------------------------------------------------------------
	IF  LEN(ISNULL(@ID_MOTIVO_ALMACEN,''))>0 AND  @ID_MOTIVO_ALMACEN<>'%' 
			BEGIN    SELECT @sFiltroAlmacen	=' and ma.id_motivo_almacen in('''+@ID_MOTIVO_ALMACEN+''')' 	 END
	ELSE	BEGIN    SELECT @sFiltroAlmacen	=''	END
	SELECT @sOrderBy	=' order by  ma.id_motivo_almacen'
	---------------------------------------------------------------------------------------------
	SELECT @sExecute = @sSelect +''+  @sFiltroAlmacen +''+ @sOrderBy
 	PRINT @sExecute
	EXEC ('SELECT '+ @sExecute )	 
END
-----------------------------------------------------------------------------------------------------------------
IF(@INDICADOR='2')
BEGIN
	SELECT @sSelect= ' ma.id_motivo_almacen, UPPER(ma.descripcion) ''descripcion''	FROM motivo_almacen	 ma
		--LEFT JOIN estado e ON e.cia=c.cia and e.id_estado=c.id_estado 	
			WHERE ma.CIA='''+@CIA+''' 		'
	--------------------------------------------------------------------------------------------
	IF  LEN(ISNULL(@ID_MOTIVO_ALMACEN,''))>0 AND  @ID_MOTIVO_ALMACEN<>'%' 
			BEGIN    SELECT @sFiltroAlmacen	=' and ma.id_motivo_almacen in('''+@ID_MOTIVO_ALMACEN+''')' 	 END
	ELSE	BEGIN    SELECT @sFiltroAlmacen	=''	END
	SELECT @sOrderBy	=' order by  ma.id_motivo_almacen'
	---------------------------------------------------------------------------------------------
	SELECT @sExecute = @sSelect +''+  @sFiltroAlmacen +''+ @sOrderBy
 	PRINT @sExecute
	EXEC ('SELECT '+ @sExecute )	 
END
GO
/****** Object:  StoredProcedure [dbo].[SP_LISTAR_MOTIVO_OCURRENCIA]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
sp_help ocurrencia
SELECT * from NETDAT.dbo.MOTIVO_SERVICIO
SELECT * from  ESTADO
SP_LISTAR_MOTIVO_OCURRENCIA '1','01','',''
SP_LISTAR_MOTIVO_OCURRENCIA '2','01','',''
select * from ocurrencia where cia='01' and sede='01'
select * from MOTIVO_OCURRENCIA where cia='01' and sede='01'
SELECT * FROM TIPO_DOCUMENTo where CIA= '01' AND ID_TIPO_DOC IN('21','26') 
SELECT * FROM TIPO_DOCUMENTO_SERIE where CIA= '01' AND ID_TIPO_DOC IN('21','26') 

*/
CREATE	PROC	[dbo].[SP_LISTAR_MOTIVO_OCURRENCIA]
@indicador CHAR(1),@cia	CHAR(2),@id_motivo_ocurrencia	CHAR(2),@descripcion VARCHAR(20)
AS
DECLARE @FECHA1 VARCHAR(8),@FECHA2 VARCHAR(8),@sSelect varchar(MAX),@sFiltro_IdMotivo varchar(MAX),@sFiltro_Estado varchar(MAX),
	@sOrderBy varchar(MAX), @sGroupBy varchar(MAX), @sExecute varchar(MAX)
------------------------------------------------------------------------------------------------------------------------
SELECT @sSelect='', @sFiltro_IdMotivo='', @sFiltro_Estado='',@sFiltro_Estado='',@sOrderBy='',@sGroupBy='',@sExecute=''
--------------------------------------------------------------------------------------------------------	
IF(@INDICADOR='1')
BEGIN
	SELECT @sSelect='
		mo.id_motivo_ocurrencia ,mo.descripcion,
		CASE WHEN LEN(MO.id_tipo_doc) = 0  THEN ''-'' ELSE MO.id_tipo_doc end ''tipo_documento_generar'',
		CASE WHEN LEN(TD.descripcion) = 0  THEN ''-'' ELSE TD.descripcion end ''descripcion_td''--,tds.serie	
		from motivo_ocurrencia mo
		left JOIN TIPO_DOCUMENTO TD ON TD.CIA=MO.CIA  AND TD.ID_TIPO_DOC=MO.ID_TIPO_DOC
		WHERE	mo.CIA='''+@CIA+'''	AND mo.ID_ESTADO=''01''	'
		--------------------------------------------------------------------------------------------
		IF  LEN(ISNULL(@id_motivo_ocurrencia,''))>0  AND @id_motivo_ocurrencia<>'%'
				BEGIN  SELECT @sFiltro_IdMotivo=' and mo.id_motivo_ocurrencia in('''+@id_motivo_ocurrencia+''') 'END
		ELSE	BEGIN  SELECT @sFiltro_IdMotivo	=''	END	
		--------------------------------------------------------------------------------------------
		SELECT @sGroupBy	='	'  
		SELECT @sOrderBy	=' ORDER BY mo.id_motivo_ocurrencia'		
		SELECT @sExecute = @sSelect  +''+ @sFiltro_IdMotivo +''+ @sFiltro_Estado+''+ @sGroupBy+''+ @sOrderBy
		PRINT @sExecute
		EXEC ('SELECT '+ @sExecute )	
END
--------------------------------------------------------------------------------------------------------	
IF(@INDICADOR='2')
BEGIN
	SELECT @sSelect= 'mo.id_motivo_ocurrencia ,mo.descripcion	from motivo_ocurrencia mo
		left JOIN TIPO_DOCUMENTO TD ON TD.CIA=MO.CIA  AND TD.ID_TIPO_DOC=MO.ID_TIPO_DOC
		WHERE	mo.CIA='''+@CIA+'''	AND mo.ID_ESTADO=''01''	'
		--------------------------------------------------------------------------------------------
		IF  LEN(ISNULL(@id_motivo_ocurrencia,''))>0  AND @id_motivo_ocurrencia<>'%'
				BEGIN  SELECT @sFiltro_IdMotivo=' and mo.id_motivo_ocurrencia in('''+@id_motivo_ocurrencia+''') 'END
		ELSE	BEGIN  SELECT @sFiltro_IdMotivo	=''	END	
		--------------------------------------------------------------------------------------------
		SELECT @sOrderBy	=' order by  c.id_clasifica2'
		--------------------------------------------------------------------------------------------
		SELECT @sGroupBy	='	'  
		SELECT @sOrderBy	=' ORDER BY mo.id_motivo_ocurrencia'		
		SELECT @sExecute = @sSelect  +''+ @sFiltro_IdMotivo +''+ @sFiltro_Estado+''+ @sGroupBy+''+ @sOrderBy
		PRINT @sExecute
		EXEC ('SELECT '+ @sExecute )		 
END
--------------------------------------------------------------------------------------------------------
GO
/****** Object:  StoredProcedure [dbo].[SP_LISTAR_MOTIVO_SERVICIO]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
SELECT * from dbo.MOTIVO_SERVICIO
SELECT * from  ESTADO
SP_LISTAR_MOTIVO_SERVICIO '01','',''
*/
CREATE	PROC	[dbo].[SP_LISTAR_MOTIVO_SERVICIO]
@CIA				CHAR(2),@id_motivo_servicio	CHAR(2),@DESCRIPCION	varchar(100)
AS
-------------------------------------------------------------------------------
DECLARE @sExecute varchar(max),@sSelect varchar(max),@sId_motivo varchar(max),@sDescrip varchar(max),@sOrderby varchar(max)
-------------------------------------------------------------------------------
SELECT @sExecute='',@sSelect='',@sId_motivo='',@sDescrip='',@sOrderby=''
-------------------------------------------------------------------------------
SELECT @sSelect='
	id_motivo_servicio,MS.descripcion	FROM MOTIVO_SERVICIO MS
	INNER JOIN ESTADO E ON E.CIA=MS.CIA AND E.ID_ESTADO=MS.ID_ESTADO
	WHERE	MS.CIA= '''+@CIA+'''	AND MS.ID_ESTADO=''01'''
------------------------------------------------------------------------------------------------------------------
	IF  LEN(@id_motivo_servicio)>0 
		begin SELECT @sId_motivo='AND MS.id_motivo_servicio='''+@id_motivo_servicio+'''' END
	ELSE BEGIN SELECT @sId_motivo='' END
------------------------------------------------------------------------------------------------------------------
	IF  LEN(@DESCRIPCION)>0 
		begin SELECT @sDescrip='AND MS.descripcion='''+@DESCRIPCION+'''' END
	ELSE BEGIN SELECT @sDescrip='' END
	------------------------------------------------------------------------------------------------------------------	
	SELECT	@sOrderby='order by MS.ID_MOTIVO_SERVICIO'
	------------------------------------------------------------------------------------------------------------------
	SELECT @sExecute = @sSelect +' '+ @sId_motivo +' '+ @sDescrip+' '+@sOrderby
	-------------------------------------------------------------------------------
	EXEC ('SELECT '+ @sExecute )
GO
/****** Object:  StoredProcedure [dbo].[SP_LISTAR_OCURRENCIA]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
sp_help ocurrencia
SELECT * from dbo.MOTIVO_SERVICIO
select * from cliente_vehiculo
SELECT * FROM dbo.MOTIVO_OCURRENCIA WHERE CIA='01' AND 
select * from ocurrencia
SELECT * from  ESTADO
SELECT * from  tipo_documento
select * from ocurrencia
go
SP_LISTAR_OCURRENCIA '01','01','','','','','','','%'		,'%'
SP_LISTAR_OCURRENCIA '01','01','292','','','','','',''
SP_LISTAR_OCURRENCIA '01','01','','lla','','','','',''
SP_LISTAR_OCURRENCIA '01','01','','   ','','31178811','','',''
SP_LISTAR_OCURRENCIA '01','01','','   ','','a','','',''
SP_LISTAR_OCURRENCIA  '01','01','','','','','','12/10/2010','%'
SP_LISTAR_OCURRENCIA '01','02','','%','','','01/01/2011','05/01/2011','%'
*/
CREATE	PROC	[dbo].[SP_LISTAR_OCURRENCIA]
@CIA	 CHAR(2),		@SEDE  CHAR(2),		 @id_ocurrencia	VARCHAR(100),			@motivo	char(2),
@cliente VARCHAR(100), @nombre VARCHAR(100), @FEC1	 datetime,	@FEC2 datetime,  @id_estado	VARCHAR(100)--,@tipo_doc varchar(100)
AS
-----------------------------------------------------------------------------------------------------------------------
DECLARE @FECHA1 VARCHAR(8),@FECHA2 VARCHAR(8), @sSelect varchar(MAX),@sFiltroID varchar(MAX),@sFiltroMotivo varchar(MAX),
 @sFiltroCliente varchar(MAX), @sFiltroNombre varchar(MAX),@sFiltroFecha varchar(MAX), @sFiltroEstado varchar(MAX),
 @sFiltroTipoDoc VARCHAR(max), @sOrderBy varchar(MAX), @sGroupBy varchar(MAX), @sExecute varchar(MAX)
----------------------------------------------------------------------------------------------------------------------
SET @FECHA1 = CONVERT(VARCHAR(8),@fec1,112)
SET @FECHA2 = CONVERT(VARCHAR(8),@fec2,112)
SELECT @sSelect='',  @sFiltroID='', @sFiltroMotivo='', @sFiltroCliente='',@sFiltroNombre ='', @sFiltroFecha ='',@sFiltroEstado ='',@sFiltroTipoDoc ='',@sOrderBy='',@sGroupBy='',@sExecute=''
-----------------------------------------------------------------------------------------------------------------
SELECT @sSelect='
	id_ocurrencia ,o.id_tipo_doc,tdp.abreviatura ''tipo_doc_oc'',cv.placa,o.nro_doc ''nro_doc_placa'',
	fecha_hora=CONVERT(VARCHAR(10),o.fecha,103) +space(2)+convert(char(5),o.fecha, 114) ,
	o.id_motivo_ocurrencia,	m.descripcion AS ''motivo'',o.ID_ANALITICA AS ''cliente'',A.DESCRIPCION ''nombre'',o.observacion,
	o.UC ''operador'',o.id_tipo_doc_op,o.serie_doc_op,o.nro_doc_op,	e.abreviatura ''estado'',o.id_estado ''id_estado'',
	fecha=CONVERT(VARCHAR(10),o.fecha,103),hora=convert(char(5),o.fecha, 114),
	CASE WHEN LEN(tdo.descripcion) > 0 THEN tdo.descripcion  ELSE ''/-'' END ''descripcion_td'',	
	CASE WHEN LEN(m.id_tipo_doc) > 0 THEN ''SI''  ELSE ''NO'' END ''pedido'',
	o.id_tecnico_1,o.id_tecnico_2,o.id_tecnico_3,o.id_tecnico_4,
	AT1.DESCRIPCION ''nombre_tecnico_1'',AT2.DESCRIPCION ''nombre_tecnico_2'',AT3.DESCRIPCION ''nombre_tecnico_3'',AT4.DESCRIPCION ''nombre_tecnico_4''
			FROM ocurrencia O	
	INNER JOIN ESTADO E ON E.CIA=o.CIA AND E.ID_ESTADO=o.ID_ESTADO
	INNER JOIN MOTIVO_OCURRENCIA M ON M.CIA=O.CIA AND M.ID_MOTIVO_OCURRENCIA=O.ID_MOTIVO_OCURRENCIA
	INNER JOIN ANALITICA A ON A.CIA=O.CIA AND A.ID_ANALITICA=O.ID_ANALITICA
	left JOIN ANALITICA AT1 ON AT1.CIA=O.CIA AND AT1.ID_ANALITICA=O.id_tecnico_1
	left JOIN ANALITICA AT2 ON AT2.CIA=O.CIA AND AT2.ID_ANALITICA=O.id_tecnico_2
	left JOIN ANALITICA AT3 ON AT3.CIA=O.CIA AND AT3.ID_ANALITICA=O.id_tecnico_3
	left JOIN ANALITICA AT4 ON AT4.CIA=O.CIA AND AT4.ID_ANALITICA=O.id_tecnico_4
	left JOIN cliente_vehiculo CV ON CV.CIA=O.CIA AND  CV.ID_TIPO_DOC=O.ID_TIPO_DOC AND CV.NRO_DOC=O.NRO_DOC
	left join tipo_documento tdo on tdo.cia=O.cia and tdo.id_tipo_doc=O.id_tipo_doc_op
	left join tipo_documento tdp on tdp.cia=CV.cia and tdp.id_tipo_doc=CV.id_tipo_doc		
	WHERE O.CIA='''+@CIA+''' AND O.SEDE='''+@SEDE+''' AND M.ID_ESTADO=''01'''
	------------------------------------------------------------------------------------------------------------------
	IF  LEN(ISNULL(@id_ocurrencia,''))>0 
			BEGIN    SELECT @sFiltroID	=' and o.id_ocurrencia  in('+@id_ocurrencia+')' 	 END
	ELSE	BEGIN   SELECT @sFiltroID	=''		END
	--------------------------------------------------------------------------------------------
	IF  LEN(ISNULL(@motivo,''))>0 AND @motivo<>'%' 
			BEGIN    SELECT @sFiltroMotivo	=' and o.id_motivo_ocurrencia in('+@motivo+')' 	 END
	ELSE	BEGIN    SELECT @sFiltroMotivo	=''
	END
	--------------------------------------------------------------------------------------------
	IF  LEN(ISNULL(@cliente,''))>0 
			BEGIN    SELECT @sFiltroCliente	=' and o.ID_ANALITICA like '''+@cliente+''' +''%'' ' END
	ELSE	BEGIN    SELECT @sFiltroCliente	=''	END
	--------------------------------------------------------------------------------------------
	IF  LEN(ISNULL(@nombre,''))>0 
			BEGIN   SELECT @sFiltroNombre	=' and A.DESCRIPCION like ''%''+'''+@nombre+''' +''%'' ' END
	ELSE	BEGIN   SELECT @sFiltroNombre	=''
	END
	--------------------------------------------------------------------------------------------	
	IF  ISNULL(@FECHA1,'19000101') <> '19000101'  AND  ISNULL(@FECHA2,'19000101') <> '19000101'
			BEGIN 	SELECT @sFiltroFecha=' and convert(varchar(8),O.fecha,112) between  '''+@FECHA1+'''  and  '''+@FECHA2+''''	END
	ELSE	BEGIN  	SELECT @sFiltroFecha	=''		END	
	--------------------------------------------------------------------------------------------
	IF  LEN(ISNULL(@id_estado,''))>0 AND @id_estado<>'%' 
			BEGIN   SELECT @sFiltroEstado	=' and o.ID_ESTADO  in('''+@id_estado+''') ' END
	ELSE	BEGIN	SELECT @sFiltroEstado	=''	END
		--------------------------------------------------------------------------------------------
	--IF  LEN(ISNULL(@tipo_doc,''))>0 AND @tipo_doc<>'%' 
	--		BEGIN   SELECT @sFiltroTipoDoc	=' and o.id_tipo_doc_op  in('''+@tipo_doc+''') ' END
	--ELSE	BEGIN	SELECT @sFiltroTipoDoc	=''	END
	--------------------------------------------------------------------------------------------
	SELECT @sOrderBy	=' order by id_ocurrencia'
	---------------------------------------------------------------------------------------------
	SELECT @sExecute = @sSelect +''+ @sFiltroID +''+ @sFiltroMotivo +''+ @sFiltroCliente +''+ @sFiltroNombre  +''+ @sFiltroFecha +''+ @sFiltroEstado+''+ @sFiltroTipoDoc+''+ @sOrderBy
 	PRINT @sExecute
	EXEC ('SELECT '+ @sExecute )	 
 	--------------------------------------------------------------------------------------------
GO
/****** Object:  StoredProcedure [dbo].[SP_LISTAR_ORDEN_PEDIDO]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*          -- 

SP_LISTAR_ORDEN_PEDIDO '01','01','','','',''

SP_LISTAR_ORDEN_PEDIDO_DET '01','01','21','2010','00000230',''

*/

CREATE PROCEDURE [dbo].[SP_LISTAR_ORDEN_PEDIDO]
@CIA CHAR(2),@SEDE CHAR(2),@TIPO_DOC VARCHAR(2),@SERIE_DOC VARCHAR(4),@NRO_DOC VARCHAR(20),@CLIENTE VARCHAR(20)
AS
-------------------------------------------------------------------------------
DECLARE @sExecute varchar(max),@sSelect varchar(max),@sTipo varchar(max),@sSerie varchar(max),
			@sNro varchar(max),@sCli varchar(max),@sOrder varchar(max),@sGroup varchar(max)
-------------------------------------------------------------------------------
SELECT @sExecute='',@sSelect='',@sTipo='',@sSerie='',@sNro='',@sCli='',@sOrder='',@sGroup=''
-------------------------------------------------------------------------------
SELECT @sSelect='
dgf.serie_doc,dgf.id_tipo_doc,dgf.nro_doc,tp.abreviatura+'' ''+dgf.serie_doc+''-''+dgf.nro_doc ''doc'',convert(varchar(10),dgf.fecha_vencimiento,103) ''fecha'',a.descripcion,
case when len(a.telefono) >= 0 or a.telefono=null  then ''-'' else a.telefono end ''telefono'',
case when len(a.telefono2) >= 0 or a.telefono2=null  then ''-'' else a.telefono2 end ''telefono2'',
case when len(a.e_mail ) >= 0 or a.e_mail =null  then ''-'' else a.e_mail end ''e_mail'',
ac.contacto,case when len(ac.telefono) >= 0 or ac.telefono=null  then ''-'' else ac.telefono end ''telefcontacto'',dgf.id_ocurrencia,
ocu.id_tecnico_1 ''tecnico'',dgfd.cantidad-sum(cod.cantidad) ''cant''
FROM dbo.doc_gestion_fa dgf
INNER JOIN ocurrencia ocu ON ocu.cia=dgf.cia and ocu.sede=dgf.sede and ocu.id_ocurrencia=dgf.id_ocurrencia 
INNER JOIN dbo.analitica a ON DGF.CIA = A.CIA AND DGF.ID_CLIENTE = A.ID_ANALITICA
INNER JOIN dbo.analitica_contacto AC ON DGF.CIA = AC.CIA AND DGF.ID_CONTACTO = AC.ITEM AND DGF.ID_CLIENTE=AC.ID_ANALITICA
INNER JOIN tipo_documento tp ON TP.CIA=DGF.CIA AND TP.ID_TIPO_DOC=DGF.ID_TIPO_DOC
LEFT JOIN dbo.DOC_GESTION_FA_DETALLE DGFD ON DGFD.CIA = DGF.CIA AND DGFD.SEDE = DGF.SEDE AND DGFD.ID_TIPO_DOC = DGF.ID_TIPO_DOC 
AND DGFD.SERIE_DOC = DGF.SERIE_DOC AND DGFD.NRO_DOC = DGF.NRO_DOC
LEFT JOIN CRONOGRAMA_OPER_PEDIDO cop ON cop.cia=DGFD.cia and cop.sede=DGFD.sede and cop.id_tipo_doc_ref=DGFD.id_tipo_doc 
															and cop.serie_doc_ref=DGFD.serie_doc and cop.nro_doc_ref=DGFD.nro_doc
LEFT JOIN 	CRONOGRAMA_OPER_DETALLE	COD ON COD.cia=COP.cia and COD.sede=COP.sede and COD.id_tipo_doc=COP.id_tipo_doc 
															and COD.serie_doc=COP.serie_doc and COD.nro_doc=COP.nro_doc	
WHERE DGF.CIA='''+@CIA+''' AND DGF.SEDE='''+@SEDE+''' 
AND ((((DGFD.CANTIDAD-COD.CANTIDAD)>0) AND COD.ID_ESTADO=''01'') or (((DGFD.CANTIDAD-COD.CANTIDAD)<=0) AND COD.ID_ESTADO=''02'') or ((DGFD.CANTIDAD-COD.CANTIDAD)is null))
AND (CONVERT(VARCHAR(8),DGF.FECHA_VENCIMIENTO,112))>CONVERT(VARCHAR(8),GETDATE(),112) 
and (ocu.id_estado=''03'') '
--AND dgf.ID_ESTADO=''03'' and (ocu.id_estado=''12'') AND (COD.id_estado!=01) 
------------------------------------------------------------------------------------------------------------------
	IF  LEN(@TIPO_DOC)>0 begin SELECT @sTipo='AND DGF.ID_TIPO_DOC='''+@TIPO_DOC+'''' END
	ELSE BEGIN SELECT @sTipo='' END
------------------------------------------------------------------------------------------------------------------
	IF  LEN(@SERIE_DOC)>0 begin SELECT @sSerie='AND DGF.SERIE_DOC='''+@SERIE_DOC+'''' END
	ELSE BEGIN SELECT @sSerie='' END
------------------------------------------------------------------------------------------------------------------
	IF  LEN(@NRO_DOC)>0 begin SELECT @sNro='AND DGF.NRO_DOC='''+@NRO_DOC+'''' END
	ELSE BEGIN SELECT @sNro='' END
------------------------------------------------------------------------------------------------------------------
	IF  LEN(@CLIENTE)>0 begin SELECT @sCli='AND a.id_analitica='''+@CLIENTE+''' AND dgf.id_cliente='''+@CLIENTE+'''' END
	ELSE BEGIN SELECT @sCli='' END
------------------------------------------------------------------------------------------------------------------
SELECT	@sOrder='ORDER BY DGF.SERIE_DOC,DGF.ID_TIPO_DOC,DGF.NRO_DOC'
------------------------------------------------------------------------------------------------------------------
SELECT	@sGroup='GROUP BY dgf.serie_doc,dgf.id_tipo_doc,dgf.nro_doc,tp.abreviatura,convert(varchar(10),dgf.fecha_vencimiento,103),a.descripcion,
							a.telefono,a.telefono2,a.e_mail,ac.contacto,ac.telefono,dgf.id_ocurrencia,dgfd.cantidad,cod.cantidad,ocu.id_tecnico_1'
------------------------------------------------------------------------------------------------------------------
SELECT @sExecute = @sSelect +' '+ @sTipo +' '+ @sSerie+' '+ @sNro+' '+ @sCli+' '+@sGroup+' '+@sOrder
-------------------------------------------------------------------------------
--print @sExecute
EXEC ('SELECT '+ @sExecute )
GO
/****** Object:  StoredProcedure [dbo].[SP_LISTAR_ORDEN_PEDIDO_DET]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_LISTAR_ORDEN_PEDIDO_DET]
@CIA CHAR(2),
@SEDE CHAR(2),
@TIPO_DOC VARCHAR(2),
@SERIE_DOC CHAR(8),
@NRO_DOC VARCHAR(8),
@DES_ARTICULO VARCHAR(100)
AS
SELECT DGFD.SERIE_DOC,DGFD.ID_TIPO_DOC,DGFD.NRO_DOC,DGFD.ID_ARTICULO,DGFD.NRO_PARTE,DGFD.DES_ARTICULO,DGFD.ITEM,DGFD.CANTIDAD,
--(DGFD.CANTIDAD)-SUM((COD.CANTIDAD)) 'CANTIDAD2',
case when len(COD.CANTIDAD) <= 0 then DGFD.CANTIDAD else (DGFD.CANTIDAD)-SUM((COD.CANTIDAD)) end 'CANTIDAD2',
DGF.ID_CLIENTE,DGF.ID_CONTACTO,DGF.ID_PUNTO_VENTA,DGF.ID_OCURRENCIA,ocu.id_tecnico_1 'tecnico'
FROM dbo.DOC_GESTION_FA_DETALLE DGFD
LEFT JOIN dbo.DOC_GESTION_FA DGF ON DGFD.CIA = DGF.CIA AND DGFD.SEDE = DGF.SEDE AND DGFD.ID_TIPO_DOC = DGF.ID_TIPO_DOC 
AND DGFD.SERIE_DOC = DGF.SERIE_DOC AND DGFD.NRO_DOC = DGF.NRO_DOC
INNER JOIN ocurrencia ocu ON ocu.cia=dgf.cia and ocu.sede=dgf.sede and ocu.id_ocurrencia=dgf.id_ocurrencia
LEFT JOIN CRONOGRAMA_OPER_PEDIDO cop ON cop.cia=DGFD.cia and cop.sede=DGFD.sede and cop.id_tipo_doc_ref=DGFD.id_tipo_doc 
															and cop.serie_doc_ref=DGFD.serie_doc and cop.nro_doc_ref=DGFD.nro_doc
LEFT JOIN 	CRONOGRAMA_OPER_DETALLE	COD ON COD.cia=COP.cia and COD.sede=COP.sede and COD.id_tipo_doc=COP.id_tipo_doc 
															and COD.serie_doc=COP.serie_doc and COD.nro_doc=COP.nro_doc													
WHERE DGFD.CIA=@CIA AND DGFD.SEDE=@SEDE 
AND DGFD.ID_TIPO_DOC =@TIPO_DOC 
AND DGFD.SERIE_DOC=@SERIE_DOC
AND (CONVERT(VARCHAR(10),DGF.FECHA_VENCIMIENTO,112))>CONVERT(VARCHAR(10),GETDATE(),112)
AND DGFD.NRO_DOC=@NRO_DOC AND DGFD.DES_ARTICULO LIKE @DES_ARTICULO+'%'
GROUP BY DGFD.SERIE_DOC,DGFD.ID_TIPO_DOC,DGFD.NRO_DOC,DGFD.ID_ARTICULO,DGFD.NRO_PARTE,DGFD.DES_ARTICULO,DGFD.ITEM,DGFD.CANTIDAD,
DGFD.CANTIDAD,COD.CANTIDAD,DGF.ID_CLIENTE,DGF.ID_CONTACTO,DGF.ID_PUNTO_VENTA,DGF.ID_OCURRENCIA,ocu.id_tecnico_1
ORDER BY DGFD.SERIE_DOC,DGFD.NRO_DOC,DGFD.ITEM
GO
/****** Object:  StoredProcedure [dbo].[SP_LISTAR_PREMIOS_CAMPANIA]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*

SELECT * FROM F_CAMPANIA_PREMIO

EXEC SP_LISTAR_PREMIOS_CAMPANIA '01', '02', '%', ''

*/
----------------------------------------------
----------------------------------------------
create	PROCEDURE	[dbo].[SP_LISTAR_PREMIOS_CAMPANIA]
@CIA			CHAR(2),
@SEDE			CHAR(2),
@ID_CAMPANIA	VARCHAR(10),
@BUSCAR			VARCHAR(100)
AS
----------------------------------------------
----------------------------------------------
SELECT	FCP.ID_CAMPANIA, EXA.ID_ARTICULO, ART.DESCRIPCION, EXA.CANT_DISPONIBLE AS 'STOCK', CASE FC.FLAG_FRASE_GANADORA 
																					WHEN '0' THEN CONVERT(VARCHAR(10), CONVERT(INT, FCP.TOTAL_PUNTOS)) 
																					ELSE FCP.FRASE_GANADORA 
																				END AS 'DATO'
FROM	F_CAMPANIA_PREMIO AS FCP 
INNER JOIN	F_CAMPANIA AS FC ON FCP.CIA = FC.CIA AND FCP.ID_CAMPANIA = FC.ID_CAMPANIA 
INNER JOIN	EXISTENCIA_ALMACEN AS EXA ON FCP.CIA = EXA.CIA AND FCP.ID_ARTICULO = EXA.ID_ARTICULO 
INNER JOIN	ARTICULO AS ART ON EXA.CIA = ART.CIA AND EXA.ID_ARTICULO = ART.ID_ARTICULO
WHERE	FCP.CIA			= @CIA
AND		EXA.SEDE		= @SEDE
AND		EXA.ID_ALMACEN	= 'ES'
AND		FCP.ID_CAMPANIA	LIKE '%' + @ID_CAMPANIA + '%'
AND		FCP.ID_ESTADO	= '01'
AND		ART.DESCRIPCION LIKE CASE WHEN LEN(@BUSCAR) > 0 THEN '%' + @BUSCAR + '%' ELSE '%' END
ORDER	BY ART.DESCRIPCION
GO
/****** Object:  StoredProcedure [dbo].[SP_LISTAR_PRODUCTOS_PDV]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*

SELECT * FROM LISTA_PRECIO

*/
------------------------------------------------
------------------------------------------------
create	PROCEDURE [dbo].[SP_LISTAR_PRODUCTOS_PDV]
@CIA				CHAR(2),
@SEDE				CHAR(2),
@ID_ALMACEN			CHAR(2),
@ID_LISTA_PRECIO	CHAR(3),
@DES_PROD			VARCHAR(100)
AS
------------------------------------------------
------------------------------------------------
SELECT	EA.ID_ARTICULO, ART.NRO_PARTE AS 'NRO-PARTE', ART.DESCRIPCION, UND.ABREVIATURA AS 'UND', 
		EA.CANT_DISPONIBLE AS 'STOCK', LPD.PRECIO_VENTA AS 'PRECIO'
FROM	EXISTENCIA_ALMACEN AS EA 
INNER JOIN ARTICULO AS ART ON EA.CIA = ART.CIA AND EA.ID_ARTICULO = ART.ID_ARTICULO 
INNER JOIN UNIDAD_MEDIDA AS UND ON ART.CIA = UND.CIA AND ART.ID_UNIDAD = UND.ID_UNIDAD 
INNER JOIN LISTA_PRECIO_DET AS LPD ON ART.CIA = LPD.CIA AND ART.ID_ARTICULO = LPD.ID_ARTICULO
WHERE	EA.CIA				= @CIA 
AND		EA.SEDE				= @SEDE 
AND		EA.ID_ALMACEN		= @ID_ALMACEN 
AND		LPD.ID_LISTA_PRECIO = @ID_LISTA_PRECIO
AND		ART.DESCRIPCION		LIKE '%' + CASE @DES_PROD WHEN '' THEN '%' ELSE @DES_PROD END + '%'
GO
/****** Object:  StoredProcedure [dbo].[SP_LISTAR_PUNTOI]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
SP_LISTAR_ANALITICA '01','01','',''
SP_HELP punto_venta
SELECT * FROM punto_venta where CIA='01' AND id_cliente LIKE '0001%' 
	AND ID_PUNTO_VENTA LIKE '%' AND DESCRIPCION LIKE '%'
select * from analitica where descripcion like '%'+'espino' +'%'
[SP_LISTAR_PUNTOI] '01','20100111838',''
SP_LISTAR_ANALITICA_CONTACTO '01','20100111838','',''
*/
create PROCEDURE [dbo].[SP_LISTAR_PUNTOI]
@CIA CHAR(2),
@ID_CLIENTE VARCHAR(100),
@ID_PUNTO VARCHAR (20)

AS
SELECT id_punto_venta,
CASE WHEN LEN(descripcion) = 0  THEN '-' ELSE descripcion END 'descripcion',
direccion FROM punto_venta
WHERE CIA=@CIA AND ID_ESTADO='01' AND ID_CLIENTE=@ID_CLIENTE AND 
ID_PUNTO_VENTA LIKE  '%' + CASE WHEN LEN(@ID_PUNTO) > 0 THEN '%' + @ID_PUNTO + '%' ELSE '%' END
GO
/****** Object:  StoredProcedure [dbo].[SP_LISTAR_SEDE]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
SELECT * FROM SEDE

[SP_LISTAR_SEDE] '01','sistemas'

*/
-----------------------------------------------
-----------------------------------------------
CREATE  PROC  [dbo].[SP_LISTAR_SEDE]
@CIA		 CHAR(2),
@ID_USUARIO  VARCHAR(10)
AS
-----------------------------------------------
-----------------------------------------------
SELECT	S.sede, S.descripcion
FROM	usuario AS U INNER JOIN 
	    Sede S ON U.cia = S.cia
WHERE	S.id_estado		= 01 
AND     S.cia			= @CIA 
AND	    U.id_usuario	= @ID_USUARIO
AND		s.ID_ESTADO	='01'

ORDER BY S.descripcion  
-----------------------------------------------
-----------------------------------------------
GO
/****** Object:  StoredProcedure [dbo].[SP_LISTAR_SERIE_DOCUMENTO]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*

select * from TIPO_DOCUMENTO_SERIE where id_tipo_doc='26'
select * from TIPO_DOCUMENTO where descripcion like 'o%'order by descripcion
[SP_LISTAR_SERIE_DOCUMENTO] '1','01','21'
[SP_LISTAR_SERIE_DOCUMENTO] '2','01','20'
*/
--------------------------------------------------
--------------------------------------------------
CREATE	PROCEDURE	[dbo].[SP_LISTAR_SERIE_DOCUMENTO]
@INDICADOR CHAR(1),@CIA CHAR(2),@ID_TIPO_DOC CHAR(2)
AS
--------------------------------------------------
IF (@INDICADOR = 1)	BEGIN	
	SELECT	SERIE FROM	TIPO_DOCUMENTO_SERIE WHERE	CIA			= @CIA
	AND		ID_TIPO_DOC	= @ID_TIPO_DOC	AND		ID_ESTADO	= '01'
	AND FECHA_VENCE=(SELECT MAX(FECHA_VENCE)FROM TIPO_DOCUMENTO_SERIE WHERE CIA=@CIA AND ID_TIPO_DOC=@ID_TIPO_DOC )
END
IF (@INDICADOR = 2)	BEGIN	
	SELECT	SERIE,SERIE FROM	TIPO_DOCUMENTO_SERIE WHERE	CIA			= @CIA
	AND		ID_TIPO_DOC	= @ID_TIPO_DOC	AND		ID_ESTADO	= '01'
--	AND FECHA_VENCE=(SELECT MAX(FECHA_VENCE)FROM TIPO_DOCUMENTO_SERIE WHERE CIA=@CIA AND ID_TIPO_DOC=@ID_TIPO_DOC )
END
GO
/****** Object:  StoredProcedure [dbo].[SP_LISTAR_TIPO_CAMBIO]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
sp_help INVENTARIO_MOV
SELECT * FROM INVENTARIO_MOV
SELECT * FROM TIPO_CAMBIO	WHERE CIA='01' AND ID_MONEDA='02' AND YEAR(FECHA) ='2010' AND MONTH(FECHA)='11'
SELECT * FROM TIPO_CAMBIO	WHERE CIA='01' AND ID_MONEDA='02' AND YEAR(FECHA) ='2011' AND MONTH(FECHA)='01'
SELECT * FROM moneda
SP_LISTAR_TIPO_CAMBIO '1','01','','','','2011',''
SP_LISTAR_TIPO_CAMBIO '1','01','02','','','2010','11'

*/

---------------------------------------------------------------
CREATE PROC [dbo].[SP_LISTAR_TIPO_CAMBIO]
@INDICADOR CHAR(1),@cia CHAR(2),@id_moneda CHAR(2), @FEC1 datetime,@FEC2 datetime,@ANIO CHAR(4),@MES CHAR(2)
AS
------------------------------------------------------------------------------------------------------------------------
DECLARE @FECHA1 VARCHAR(8),@FECHA2 VARCHAR(8), @sSelect varchar(MAX),@sFiltroID VARCHAR(MAX),@sFiltroFecha varchar(MAX),
	@sFiltroAnio varchar(MAX),@sFiltroMes varchar(MAX),@sOrderBy varchar(MAX),@sGroupBy varchar(MAX),@sExecute varchar(MAX)
SELECT @sSelect='',@sFiltroID='',@sFiltroAnio='',@sFiltroMes='',@sOrderBy='',@sGroupBy='',@sExecute=''
------------------------------------------------------------------------------------------------------------------------
IF(@INDICADOR='1')
BEGIN
	SELECT @sSelect='RANK() Over (ORDER BY fecha) ''Correlativo'',
	fecha=CONVERT(VARCHAR(10),tc.fecha,103) +space(2)+convert(char(5),tc.FC, 114),tc.id_moneda,
	convert(varchar(100), convert(decimal(15,3),tc.compra)) +space(2)+ m.abreviatura ''compra'',
	convert(varchar(100), convert(decimal(15,3),tc.venta)) +space(2)+ m.abreviatura ''venta'',tc.anio,tc.mes,
	m.descripcion ''desc_moneda'',m.abreviatura	FROM tipo_cambio	tc	
	LEFT JOIN MONEDa m on m.cia=tc.cia and m.id_moneda =tc.id_moneda 
	WHERE tc.CIA='''+@CIA+'''	'
	-------------------------------------------------------------------------------
	IF  LEN(ISNULL(@id_moneda,''))>0 
			BEGIN 	   SELECT @sFiltroID =' and tc.id_moneda  in('''+@id_moneda+''')'	 END
	ELSE	BEGIN       SELECT @sFiltroID=''	END
	-------------------------------------------------------------------------------	
	IF  ISNULL(@FECHA1,'19000101') <> '19000101'  AND  ISNULL(@FECHA2,'19000101') <> '19000101'
			BEGIN 	SELECT @sFiltroFecha=' and convert(varchar(8),O.fecha,112) between  '''+@FECHA1+'''  and  '''+@FECHA2+''''	END
	ELSE	BEGIN  	SELECT @sFiltroFecha	=''		END	
	-------------------------------------------------------------------------------
	IF  LEN(ISNULL(@ANIO,''))>0 
			BEGIN 	   SELECT @sFiltroAnio =' and TC.anio  in('''+@ANIO+''')'	 END
	ELSE	BEGIN       SELECT @sFiltroAnio=''	END
	-------------------------------------------------------------------------------
	IF  LEN(ISNULL(@MES,''))>0 
			BEGIN 	   SELECT @sFiltroMes =' and TC.mes in('''+@MES+''')'	 END
	ELSE	BEGIN       SELECT @sFiltroMes=''	END
	-------------------------------------------------------------------------------	
	SELECT @sOrderBy=' ORDER BY   tc.fecha	'
	-------------------------------------------------------------------------
	SELECT @sExecute = @sSelect+''+ @sFiltroID +''+ @sFiltroFecha+''+@sFiltroAnio +''+ @sFiltroMes +''+ @sOrderBy
 	PRINT @sExecute
	EXEC ('SELECT '+ @sExecute )
END
-------------------------------------------------------------------------
IF(@INDICADOR='2')
BEGIN
	SELECT @sSelect='	'
	EXEC ('SELECT '+ @sExecute )	
END
-------------------------------------------------------------------------
GO
/****** Object:  StoredProcedure [dbo].[SP_LISTAR_TIPO_DIAGNOSTICO_SOLUCION]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
delete from tipo_diagnostico where cia='01' and id_tipo_diagnostico in('44')
delete from tipo_solucion where cia='01' and id_tipo_solucion in('35')
select * from tipo_diagnostico				
select * from tipo_solucion	
SP_LISTAR_TIPO_DIAGNOSTICO_SOLUCION 1,'01','99','PPP','',''
SP_LISTAR_TIPO_DIAGNOSTICO_SOLUCION 2,'01','','','04',''
SP_LISTAR_TIPO_DIAGNOSTICO_SOLUCION 1,'01','01','','',''
SP_LISTAR_TIPO_DIAGNOSTICO_SOLUCION 1,'01','','NO LEEN CHIPS','',''
SP_LISTAR_TIPO_DIAGNOSTICO_SOLUCION 2,'01','','','01',''
SP_LISTAR_TIPO_DIAGNOSTICO_SOLUCION 2,'01','','','','SE CAMBIO JACK TOOLS'
*/
-----------------------------------------------
-----------------------------------------------
CREATE proc [dbo].[SP_LISTAR_TIPO_DIAGNOSTICO_SOLUCION]
	@INDICADOR int,@CIA CHAR(2),@ID_TIPO_DIAGNOSTICO CHAR(2),@DESCRIPCION_TD VARCHAR(max),@ID_TIPO_SOLUCION CHAR(2),@DESCRIPCION_TS VARCHAR(max)
AS
DECLARE @sSelect varchar(MAX),@sFiltroID_TD varchar(MAX),@sFiltroID_TS varchar(MAX), 
	@sFiltroDescTD varchar(MAX),@sFiltroDescTS varchar(MAX), @sOrderBy varchar(MAX),
	@sGroupBy varchar(MAX), @sExecute varchar(MAX)
SELECT @sSelect='',  @sFiltroID_TD='', @sFiltroID_TS='', @sFiltroDescTD='',@sFiltroDescTS ='',@sOrderBy='',@sGroupBy='',@sExecute=''
----------------------------------------------
IF (@INDICADOR = 1)	BEGIN		
	---------------------------------------------------------------------------------------------
	SELECT @sSelect=' TD.id_tipo_diagnostico,td.descripcion,td.id_estado FROM tipo_diagnostico TD
					 where TD.ID_ESTADO = ''01'' AND TD.CIA	= '''+@CIA+'''	'
	---------------------------------------------------------------------------------------------
	IF  LEN(ISNULL(@ID_TIPO_DIAGNOSTICO,''))>0 AND @ID_TIPO_DIAGNOSTICO<>'99'  	BEGIN
				  SELECT @sFiltroID_TD  =' and TD.ID_TIPO_DIAGNOSTICO  ='''+@ID_TIPO_DIAGNOSTICO+''' '	END
	ELSE	BEGIN SELECT @sFiltroID_TD	=''										END
	---------------------------------------------------------------------------------------------
	IF  LEN(ISNULL(@DESCRIPCION_TD,''))>0										BEGIN
				  SELECT @sFiltroDescTD	=' and TD.DESCRIPCION  ='''+@DESCRIPCION_TD+''' '	 END
	ELSE	BEGIN SELECT @sFiltroDescTD	= '' 									END		
	---------------------------------------------------------------------------------------------
	SELECT @sExecute = @sSelect +''+ @sFiltroID_TD +''+ @sFiltroDescTD 
 	PRINT @sExecute
	EXEC ('SELECT '+ @sExecute ) 
	------------------------------------------------------------------------------------
end
------------------------------------------------------------------------------------
IF (@INDICADOR = 2)	BEGIN	
	------------------------------------------------------------------------------------
	SELECT @sSelect=' ts.id_tipo_solucion,ts.descripcion,ts.id_estado FROM tipo_solucion TS 
					 where   Ts.ID_ESTADO =	''01'' 	AND		TS.CIA	=	'''+@CIA+'''	'
	------------------------------------------------------------------------------------
	IF  LEN(ISNULL(@ID_TIPO_SOLUCION,''))>0 AND @ID_TIPO_SOLUCION<>'99'			BEGIN		
				  SELECT @sFiltroID_TS	=' and TS.ID_TIPO_SOLUCION	='''+@ID_TIPO_SOLUCION+''' '	 END
	ELSE	BEGIN SELECT @sFiltroID_TS	=''										END
	------------------------------------------------------------------------------------
	IF  LEN(ISNULL(@DESCRIPCION_TS,''))>0										BEGIN
				  SELECT @sFiltroDescTS	=' and TS.DESCRIPCION  ='''+@DESCRIPCION_TS+''''	 END
	ELSE	BEGIN SELECT @sFiltroDescTS	=''										END	
	------------------------------------------------------------------------------------
	SELECT @sExecute = @sSelect +''+ @sFiltroID_TS +''+ @sFiltroDescTS 
 	PRINT @sExecute
	EXEC ('SELECT '+ @sExecute ) 
	------------------------------------------------------------------------------------
END
GO
/****** Object:  StoredProcedure [dbo].[SP_LISTAR_TIPO_DOCUMENTO]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
SELECT * FROM V_TIPO_DOCUMENTO
sp_help TIPO_DOCUMENTO
SELECT * FROM TIPO_DOCUMENTO where cia='01' and id_tipo_doc in('01','20','21','23','25','30','31','34')
SP_LISTAR_TIPO_DOCUMENTO '1','01','',''
SP_LISTAR_TIPO_DOCUMENTO '2','01','ni',''
select * from tipo_documento order by  descripcion
*/
---------------------------------------------------------------
CREATE PROC [dbo].[SP_LISTAR_TIPO_DOCUMENTO]
@INDICADOR CHAR(1),@cia CHAR(2),@ID_TIPO_DOC  CHAR(2),@DESCRIPCION  VARCHAR(20)
AS
-----------------------------------------------------------------------------------------------------------------------
DECLARE @sOrderBy varchar(MAX), @sGroupBy varchar(MAX), @sExecute varchar(MAX),@sSelect varchar(MAX)
DECLARE @sFiltro_IdTipoDoc varchar(MAX),@sFiltroDescripcion varchar(MAX)
SELECT @sSelect='', @sFiltro_IdTipoDoc ='', @sFiltroDescripcion ='',@sOrderBy='',@sGroupBy='',@sExecute=''
--------------------------------------------------------------------------------------------
IF(@INDICADOR='1')
BEGIN
	SELECT @sSelect= '
		TD.id_tipo_doc, TD.descripcion ''descripcion'',td.abreviatura,id_estado,fc=convert(varchar(10),fc,103)
		FROM tipo_documento	AS TD
		WHERE TD.cia='''+@CIA+''' 		'
	--------------------------------------------------------------------------------------------
	IF  LEN(ISNULL(@ID_TIPO_DOC,''))>0 AND  @ID_TIPO_DOC<>'%' 
			BEGIN    SELECT @sFiltro_IdTipoDoc	=' and td.ID_TIPO_DOC in('''+@ID_TIPO_DOC+''')' 	 END
	ELSE	BEGIN    SELECT @sFiltro_IdTipoDoc	=''	END
	SELECT @sOrderBy	=' order by  TD.id_tipo_doc'
	---------------------------------------------------------------------------------------------
	SELECT @sExecute = @sSelect +''+  @sFiltro_IdTipoDoc +''+ @sFiltroDescripcion+''+ @sGroupBy+''+ @sOrderBy
 	PRINT @sExecute
	EXEC ('SELECT '+ @sExecute )	
END
--------------------------------------------------------------------------------------------
IF(@INDICADOR='2')
BEGIN
	SELECT @sSelect= '
		TD.id_tipo_doc, TD.descripcion ''descripcion''	FROM tipo_documento	AS TD
		WHERE TD.cia='''+@CIA+''' 		'
	--------------------------------------------------------------------------------------------
	IF  LEN(ISNULL(@ID_TIPO_DOC,''))>0 AND  @ID_TIPO_DOC<>'%' 
			BEGIN    SELECT @sFiltro_IdTipoDoc	=' and td.ID_TIPO_DOC in('''+@ID_TIPO_DOC+''')' 	 END
	ELSE	BEGIN    SELECT @sFiltro_IdTipoDoc	=''	END
	SELECT @sOrderBy	=' order by  TD.id_tipo_doc'
	---------------------------------------------------------------------------------------------
	SELECT @sExecute = @sSelect +''+  @sFiltro_IdTipoDoc +''+ @sFiltroDescripcion+''+ @sGroupBy+''+ @sOrderBy
 	PRINT @sExecute
	EXEC ('SELECT '+ @sExecute )	
END
GO
/****** Object:  StoredProcedure [dbo].[SP_LISTAR_TIPO_PERSONA]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[SP_LISTAR_TIPO_PERSONA]
AS
 select flag_tipo_persona,
case flag_tipo_persona	when '0' then 'Juridica' else 'Natural'	end as 'tipo_persona'	
from	analitica 
GROUP BY flag_tipo_persona
GO
/****** Object:  StoredProcedure [dbo].[SP_LISTAR_TURNO]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
SP_HELP E_TURNO
SELECT * FROM E_TURNO
SELECT * FROM USUARIO
SELECT * FROM COMPANIA
SP_LISTAR_TURNO '01','',''
*/
CREATE PROC [dbo].[SP_LISTAR_TURNO]
@cia CHAR(2),@id_turno	CHAR(2),@descripcion VARCHAR(60)
AS
--------------------------------------
SELECT id_turno,et.descripcion FROM e_turno et
 INNER JOIN ESTADO E ON E.CIA=ET.CIA AND E.ID_ESTADO=ET.ID_ESTADO
--INNER JOIN COMPANIA C ON C.CIA=ET.CIA
 where et.id_estado='01'  AND et.CIA=@CIA
 and   et.id_turno LIKE  '%' + CASE WHEN LEN(@id_turno) > 0 THEN '%' + @id_turno + '%' ELSE '%' END
 and   et.descripcion LIKE  '%' + CASE WHEN LEN(@descripcion) > 0 THEN '%' + @descripcion + '%' ELSE '%' END
ORDER BY id_turno
GO
/****** Object:  StoredProcedure [dbo].[sp_listar_Ulti_V]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*----------------------Ultimas Ventas---------------------*/

--sp_listar_Ulti_V 1,'01','02',600,''

CREATE PROCEDURE [dbo].[sp_listar_Ulti_V]
@tipo INT,@cia CHAR(2),@sede CHAR(2),@dhora INT,@filtro VARCHAR(500)
AS
-------------------------------------------------------------------------------
DECLARE @sExecute varchar(max),@sSelect varchar(max),@sCondicion varchar(max),@sGroupby varchar(max),@sOrderby varchar(max)
-------------------------------------------------------------------------------
DECLARE @desde VARCHAR(8)
DECLARE @hasta VARCHAR(8)
------------------------------------------
SET @hasta = (DATEPART(hour, getdate())*60)+(DATEPART(minute, getdate()))
SET @desde = (DATEPART(hour, getdate())*60)+(DATEPART(minute, getdate()))-@dhora
-------------------------------------------------------------------------------
SELECT @sExecute='',@sSelect='',@sCondicion='',@sGroupby='',@sOrderby=''
-------------------------------------------------------------------------------

SELECT @sSelect='c.descripcion ''Cia'',s.descripcion ''Sede'',v.placa ''PLACA'',v.id_manguera ''MANGUERA'',
convert(varchar(10), v.fc,103) ''FECHA'',convert(varchar(8), v.fc,108) ''HORA'',
v.cantidad ''CANTIDAD'',v.precio ''VALOR'',v.subtotal ''RECAUDO'',vd.id_venta ''RECIBO'',vd.serie_doc+''-''+vd.nro_doc ''DOCUMENTO'' 
FROM e_venta v
INNER JOIN e_venta_documento vd ON vd.id_venta=v.id_venta and vd.cia=v.cia and vd.sede=v.sede
inner join compania c on c.cia=v.cia
inner join sede s on s.cia=v.cia and s.sede=v.sede'
-------------------------------------------------------------------------------
IF @tipo=0 
BEGIN
SELECT @sCondicion='WHERE (v.cia='''+@cia+''') and (v.sede='''+@sede+''') 
and ((convert(varchar(10), v.fc,112))=(convert(varchar(10), getdate(),112)))
and (((DATEPART(hour, getdate())*60)+(DATEPART(minute, getdate()))) between '''+@desde+''' and '''+@hasta+''')
'+@filtro+''
END
ELSE IF @tipo=1 
BEGIN
SELECT @sCondicion='WHERE (v.cia='''+@cia+''') and (v.sede='''+@sede+''') 
and ((convert(varchar(10), v.fc,112))=(convert(varchar(10), getdate(),112)))
and (((DATEPART(hour, getdate())*60)+(DATEPART(minute, getdate()))) between '''+@desde+''' and '''+@hasta+''') 
--and ((DATEPART(hour, v.fc)*60)+DATEPART(minute, v.fc) between  ''720'' and ''1440'')
'+@filtro+''
END
-------------------------------------------------------------------------------
SELECT @sGroupby=''
-------------------------------------------------------------------------------
SELECT @sOrderby=''
------------------------------------------------------------------------------------------------------------------
SELECT @sExecute = @sSelect +' '+ @sCondicion +' '+@filtro+' '+ @sGroupby+' '+@sOrderby
-------------------------------------------------------------------------------
--PRINT @sExecute
EXEC ('SELECT '+ @sExecute )
GO
/****** Object:  StoredProcedure [dbo].[SP_LISTAR_UNIDAD_MEDIDA]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
SP_HELP unidad_medida
[SP_LISTAR_UNIDAD_MEDIDA]  '1','01','','',''
[SP_LISTAR_UNIDAD_MEDIDA]  '2','01','','',''
SELECT * FROM unidad_medida
*/
create PROCEDURE [dbo].[SP_LISTAR_UNIDAD_MEDIDA]
@INDICADOR	CHAR(1),@CIA  CHAR(2),@ID_UNIDAD CHAR(2),@DESCRIPCION  VARCHAR(60),@ID_ESTADO CHAR(2)
as
------------------------------------------------------------------------------------------------
DECLARE @sExecute varchar(max),@sSelect varchar(max),@sFiltroID varchar(max),
	@sFiltroDescripcion varchar(max),@sFiltroEstado varchar(max),@sGroupby varchar(max),@sOrderby varchar(max)
SELECT @sExecute='',  @sSelect='', @sFiltroID='',@sFiltroDescripcion='',@sOrderBy='',@sGroupBy=''
-----------------------------------------------------------------------------------------------
IF(@INDICADOR='1')
BEGIN
	SELECT @sSelect='um.id_unidad, UPPER(um.descripcion) ''descripcion'',um.abreviatura,
	um.id_estado,e.descripcion ''desc_estado'',e.abreviatura 	FROM unidad_medida	 um
	LEFT JOIN estado e ON e.cia=um.cia and e.id_estado=um.id_estado 
	where um.CIA='''+@CIA+'''	'	 
	--------------------------------------------------------------------------------------------------------
	IF  LEN(ISNULL(@ID_UNIDAD,''))>0 AND  @ID_UNIDAD<>'%' 
			BEGIN    SELECT @sFiltroID	=' and um.id_unidad like ''%''+'''+@ID_UNIDAD+''' +''%'' ' END
	ELSE	BEGIN   SELECT @sFiltroID	=''		END
	--------------------------------------------------------------------------------------------------------
	IF  LEN(ISNULL(@DESCRIPCION ,''))>0 
			BEGIN    SELECT @sFiltroDescripcion	=' and um.descripcion like ''%''+'''+@DESCRIPCION+''' +''%'' ' END
	ELSE	BEGIN   SELECT @sFiltroDescripcion	=''		END
	--------------------------------------------------------------------------------------------------------
		IF  LEN(ISNULL(@id_estado,''))>0 AND  @id_estado<>'%' 
				BEGIN SELECT @sFiltroEstado =' and um.id_estado in('''+@id_estado+''')' 	 END
		ELSE	BEGIN SELECT @sFiltroEstado=''	END
	--------------------------------------------------------------------------------------------------------
	SELECT @sOrderby='ORDER BY  um.id_unidad'
	-------------------------------------------------------------------------------
	SELECT @sExecute = @sSelect +' '+ @sFiltroID +' '+ @sFiltroDescripcion +' '+@sFiltroEstado+' '+@sOrderby
	-------------------------------------------------------------------------------
	PRINT @sExecute
	EXEC ('SELECT '+ @sExecute )

END
-----------------------------------------------------------------------
IF(@INDICADOR='2')
BEGIN
	SELECT @sSelect='um.id_unidad, UPPER(um.descripcion) ''descripcion'' FROM unidad_medida	 um
	LEFT JOIN estado e ON e.cia=um.cia and e.id_estado=um.id_estado 
	where um.CIA='''+@CIA+'''	'	 
	--------------------------------------------------------------------------------------------------------
	IF  LEN(ISNULL(@ID_UNIDAD,''))>0 AND  @ID_UNIDAD<>'%' 
			BEGIN    SELECT @sFiltroID	=' and um.id_unidad like ''%''+'''+@ID_UNIDAD+''' +''%'' ' END
	ELSE	BEGIN   SELECT @sFiltroID	=''		END
	--------------------------------------------------------------------------------------------------------
	IF  LEN(ISNULL(@DESCRIPCION ,''))>0 
			BEGIN    SELECT @sFiltroDescripcion	=' and um.descripcion like ''%''+'''+@DESCRIPCION+''' +''%'' ' END
	ELSE	BEGIN   SELECT @sFiltroDescripcion	=''		END
	--------------------------------------------------------------------------------------------------------
	SELECT @sOrderby='ORDER BY  um.id_unidad'
	-------------------------------------------------------------------------------
	SELECT @sExecute = @sSelect +' '+ @sFiltroID +' '+ @sFiltroDescripcion +' '+@sOrderby
	-------------------------------------------------------------------------------
	PRINT @sExecute
	EXEC ('SELECT '+ @sExecute )
END
GO
/****** Object:  StoredProcedure [dbo].[SP_LISTAR_URL_MENUS_HIJOS]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE [dbo].[SP_LISTAR_URL_MENUS_HIJOS]
@ID_ACCESO		INT
AS
-----------------------------------------------
SELECT	A.ID_ACCESO,A.DESCRIPCION_CORTA, A.NOMBRE_EXE,A.ID_ACCESO_SUPERIOR,A.FLAG_WEB
FROM	ACCESO AS A
INNER JOIN ESTADO E ON E.ID_ESTADO=A.ID_ESTADO
WHERE	A.ID_ACCESO=@ID_ACCESO AND A.ID_ESTADO='01'	
ORDER BY ORDEN
GO
/****** Object:  StoredProcedure [dbo].[SP_LISTAR_USUARIO]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
SP_LISTAR_USUARIO '2','01','','',''
SP_LISTAR_USUARIO '3','01','','',''
SP_LISTAR_USUARIO '1','01','FAINT','1234',''
				
SP_LISTAR_USUARIO '3','01','FAINT','',''

*/
CREATE PROC [dbo].[SP_LISTAR_USUARIO]
@indicador CHAR(1),@CIA	CHAR(2),
@id_usuario		VARCHAR(30),@clave	varchar(max),@descripcion VARCHAR(30)
AS
----------------------------------------------------------------------------------
DECLARE @sSelect varchar(MAX),@sFiltroSede varchar(MAX),@sFiltroID VARCHAR(MAX),
	@sFiltroClave varchar(MAX),@sFiltroDescripcion varchar(MAX),
	@sOrderBy varchar(MAX),@sGroupBy varchar(MAX),@sExecute varchar(MAX)
SELECT @sSelect='',@sFiltroSede='',@sFiltroID='',@sFiltroClave='',
		@sFiltroDescripcion='',@sOrderBy='',@sGroupBy='',@sExecute=''
-------------------------------------------------------------------------
IF(@INDICADOR='1') /*	VALIDAR USUARIO (LOGIN)	*/
BEGIN
	SELECT @sSelect='
	U.cia, U.id_Usuario, U.Clave,u.id_estado,u.flag_administrador,
	u.flag_sede_default,u.sede_default,u.flag_trabajador
	FROM	Usuario U 
	--left join sede s on s.cia=u.cia		
	WHERE	u.CIA='''+@CIA+''' and U.id_Usuario='''+@id_usuario+'''
	and U.Clave='''+@clave+'''	and u.id_estado	=	''01''	'	
	SELECT @sExecute = @sSelect 
 	PRINT @sExecute
	EXEC ('SELECT '+ @sExecute )		
END
-------------------------------------------------------------------------
IF(@INDICADOR='2')/*	LISTAR USUARIO */
BEGIN
	SELECT @sSelect='
	 u.id_usuario,u.descripcion,U.Clave,u.id_estado,u.flag_administrador,
	u.flag_sede_default,u.sede_default,u.flag_trabajador,u.id_grupo,gp.descripcion ''desgrupo'' FROM	Usuario U 	
	left join estado e on e.cia=u.cia AND E.id_estado=U.id_estado	
	left join compania c on c.cia=u.cia
	inner join grupo gp on gp.cia=u.cia and gp.id_grupo=u.id_grupo	
	WHERE	u.CIA='''+@CIA+''' 	and u.id_estado	=	''01''	'
	-------------------------------------------------------------------------------
	IF  LEN(ISNULL(@id_usuario,''))>0 
			BEGIN 	   SELECT @sFiltroID =' and U.id_Usuario  in('''+@id_usuario+''')'	 END
	ELSE	BEGIN       SELECT @sFiltroID=''	END
	-------------------------------------------------------------------------------
	IF  LEN(ISNULL(@descripcion,''))>0 
			BEGIN 	   SELECT @sFiltroDescripcion =' and U.descripcion like '''+@descripcion+''' +''%'' ' END	 
	ELSE	BEGIN       SELECT @sFiltroDescripcion=''	END
	-------------------------------------------------------------------------
	SELECT @sExecute = @sSelect +''+@sFiltroID+''+ @sFiltroDescripcion
 	PRINT @sExecute
	EXEC ('SELECT '+ @sExecute )		
END
-------------------------------------------------------------------------
IF(@INDICADOR='3')
BEGIN
	SELECT @sSelect='
	 u.id_usuario,u.descripcion,U.Clave,u.id_estado,e.descripcion ''desestado'',u.flag_cajero,u.flag_administrador,
	u.flag_sede_default,u.sede_default,u.flag_trabajador,u.id_grupo,gp.descripcion ''desgrupo'' 
	FROM	Usuario U 	
	left join estado e on e.cia=u.cia AND E.id_estado=U.id_estado	
	left join compania c on c.cia=u.cia
	inner join grupo gp on gp.cia=u.cia and gp.id_grupo=u.id_grupo	
	WHERE	u.CIA='''+@CIA+''' '
	-------------------------------------------------------------------------------
	IF  LEN(ISNULL(@id_usuario,''))>0 
			BEGIN 	   SELECT @sFiltroID =' and U.id_Usuario  in('''+@id_usuario+''')'	 END
	ELSE	BEGIN       SELECT @sFiltroID=''	END
	-------------------------------------------------------------------------------
	IF  LEN(ISNULL(@descripcion,''))>0 
			BEGIN 	   SELECT @sFiltroDescripcion =' and U.descripcion like '''+@descripcion+''' +''%'' ' END	 
	ELSE	BEGIN       SELECT @sFiltroDescripcion=''	END
	-------------------------------------------------------------------------
	SELECT @sExecute = @sSelect +''+@sFiltroID+''+ @sFiltroDescripcion
 	PRINT @sExecute
	EXEC ('SELECT '+ @sExecute )		
END
GO
/****** Object:  StoredProcedure [dbo].[sp_listar_Ve_x_Dia]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*--------------Ventas Diarias-----------------------*/

--sp_listar_Ve_x_Dia 0,'01','02','10/08/2010','13/08/2010',''

CREATE PROCEDURE [dbo].[sp_listar_Ve_x_Dia]
@tipo int,@cia char(2),@sede char(2), @fec1 datetime, @fec2 datetime,@filtro varchar(500)
AS
-------------------------------------------------------------------------------
DECLARE @sExecute varchar(max),@sSelect varchar(max),@sCondicion varchar(max),@sGroupby varchar(max),@sOrderby varchar(max)
-------------------------------------------------------------------------------
DECLARE @FECHA1 VARCHAR(8),@FECHA2 VARCHAR(8)
-------------------------------------------------------------------------------
SET @FECHA1 = CONVERT(VARCHAR(8),@fec1,112)
SET @FECHA2 = CONVERT(VARCHAR(8),@fec2,112)
-------------------------------------------------------------------------------
SELECT @sExecute='',@sSelect='',@sCondicion='',@sGroupby='',@sOrderby=''
-------------------------------------------------------------------------------

SELECT @sSelect='c.descripcion ''Cia'',s.descripcion ''Sede'',a.nro_parte ''Producto'',convert(varchar(10), v.fecha,103) ''Fecha'',count(v.id_venta) ''Numero de Vehiculos'',
sum(v.cantidad) ''Cantidad M3'',sum(v.subtotal) ''Valor'' 
FROM e_venta v
INNER JOIN articulo a ON a.id_articulo=v.id_articulo and a.cia=v.cia
INNER JOIN compania c ON c.cia=v.cia
INNER JOIN sede s ON s.cia=v.cia and s.sede=v.sede'
-------------------------------------------------------------------------------
IF @tipo=0 
BEGIN
SELECT @sCondicion='WHERE v.cia=''' + @cia + '''  and v.sede='''+@sede+''' and (convert(varchar(8),v.fecha,112) between ''' + @FECHA1 + '''
 and ''' + @FECHA2 + ''') '+@filtro+''
END
ELSE IF @tipo=1 
BEGIN
SELECT @sCondicion='WHERE v.cia=''' + @cia + '''  and v.sede='''+@sede+''' and 
(convert(int,(DATEPART(hour, v.fc)*60)+DATEPART(minute, v.fc)) between  720 and 1440) 
and (convert(varchar(8),v.fecha,112) between ''' + @FECHA1 + '''
 and ''' + @FECHA2 + ''') '+@filtro+''
END
-------------------------------------------------------------------------------
SELECT @sGroupby='GROUP BY c.descripcion,s.descripcion,a.nro_parte,convert(varchar(10), v.fecha,103)'
-------------------------------------------------------------------------------
SELECT @sOrderby=''
------------------------------------------------------------------------------------------------------------------
SELECT @sExecute = @sSelect +' '+ @sCondicion +' '+ @filtro+' '+ @sGroupby+' '+@sOrderby
-------------------------------------------------------------------------------
--PRINT @sExecute
EXEC ('SELECT '+ @sExecute )
GO
/****** Object:  StoredProcedure [dbo].[sp_listar_Ve_x_M]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*----------------Ventas diarias por Manguera---------------------------*/

--sp_listar_Ve_x_M 1,'01','02','10/08/2010','13/08/2010',''

CREATE PROCEDURE [dbo].[sp_listar_Ve_x_M]
@tipo int,@cia char(2),@sede char(2), @fec1 datetime, @fec2 datetime,@filtro varchar(500)
AS
-------------------------------------------------------------------------------
DECLARE @sExecute varchar(max),@sSelect varchar(max),@sCondicion varchar(max),@sGroupby varchar(max),@sOrderby varchar(max)
-------------------------------------------------------------------------------
DECLARE @FECHA1 VARCHAR(8),@FECHA2 VARCHAR(8)
-------------------------------------------------------------------------------
SET @FECHA1 = CONVERT(VARCHAR(8),@fec1,112)
SET @FECHA2 = CONVERT(VARCHAR(8),@fec2,112)
-------------------------------------------------------------------------------
SELECT @sExecute='',@sSelect='',@sCondicion='',@sGroupby='',@sOrderby=''
-------------------------------------------------------------------------------

SELECT @sSelect='c.descripcion ''Cia'',s.descripcion ''Sede'',v.id_manguera ''Manguera'',min(v.contometro_inicial) ''Lectura Inicial'',max(v.contometro_final) ''Lectura Final'',
max(v.contometro_final)-min(v.contometro_inicial) as ''Diferencia'',convert(numeric(15,2), avg(v.precio)) ''Precio'',
sum(v.cantidad) ''Valor'',sum(v.subtotal) ''Recaudo''
FROM e_venta v
inner join compania c on c.cia=v.cia
inner join sede s on s.cia=v.cia and s.sede=v.sede'
-------------------------------------------------------------------------------
IF @tipo=0 
BEGIN
SELECT @sCondicion='WHERE v.cia=''' + @cia + '''  and v.sede='''+@sede+''' and (convert(varchar(8),v.fecha,112) between ''' + @FECHA1 + '''
 and ''' + @FECHA2 + ''') '+@filtro+''
END
ELSE IF @tipo=1 
BEGIN
SELECT @sCondicion='WHERE v.cia=''' + @cia + '''  and v.sede='''+@sede+''' and 
(convert(int,(DATEPART(hour, v.fc)*60)+DATEPART(minute, v.fc)) between  720 and 1440) 
 and (convert(varchar(8),v.fecha,112) between ''' + @FECHA1 + '''
 and ''' + @FECHA2 + ''') '+@filtro+''
END
-------------------------------------------------------------------------------
SELECT @sGroupby='GROUP BY c.descripcion,s.descripcion,v.id_manguera'
-------------------------------------------------------------------------------
SELECT @sOrderby=''
------------------------------------------------------------------------------------------------------------------
SELECT @sExecute = @sSelect +' '+ @sCondicion +' '+@filtro+' '+ @sGroupby+' '+@sOrderby
-------------------------------------------------------------------------------
--PRINT @sExecute
EXEC ('SELECT '+ @sExecute )
GO
/****** Object:  StoredProcedure [dbo].[sp_listar_Ve_x_Ma_y_Tu]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*---------Reporte de ventas diarias por manguera y turno---------------*/

--sp_listar_Ve_x_Ma_y_Tu 1,'01','02','08/08/2010','28/08/2010',''


CREATE PROCEDURE [dbo].[sp_listar_Ve_x_Ma_y_Tu]
@tipo int,@cia char(2),@sede char(2), @fec1 datetime, @fec2 datetime, @filtro varchar(500)
AS
-------------------------------------------------------------------------------
DECLARE @sExecute varchar(max),@sSelect varchar(max),@sCondicion varchar(max),@sGroupby varchar(max),@sOrderby varchar(max)
-------------------------------------------------------------------------------
DECLARE @FECHA1 VARCHAR(8),@FECHA2 VARCHAR(8)
-------------------------------------------------------------------------------
SET @FECHA1 = CONVERT(VARCHAR(8),@fec1,112)
SET @FECHA2 = CONVERT(VARCHAR(8),@fec2,112)
-------------------------------------------------------------------------------
SELECT @sExecute='',@sSelect='',@sCondicion='',@sGroupby='',@sOrderby=''
-------------------------------------------------------------------------------
SELECT @sSelect='co.descripcion ''Cia'',se.descripcion ''Sede'',convert(varchar(10), v.fecha,103) ''Fecha'', v.id_turno ''Turno'', v.id_manguera ''Manguera'',
v.id_turno_control ''IdTurno'',case when c.cierre is null then ''Abierto'' else ''Cerrado'' end ''Estado'',
min(v.contometro_inicial) as ''Lectura Inicial'', max(v.contometro_final) as ''Lectura Final'',
max(v.contometro_final)-min(v.contometro_inicial) as ''Diferencia'',
convert(numeric(15,2),avg(v.precio)) ''Precio'', sum(v.cantidad) as ''Cantidad'',
sum(v.subtotal) as ''SubTotal'', sum(v.subtotal) as ''Otros'', sum(v.subtotal) as ''Total Final''
FROM e_venta as v
INNER JOIN e_venta_documento d ON d.cia=v.cia and d.sede=v.sede and d.id_venta=v.id_venta and d.id_estado=''01''
INNER JOIN e_turno_control c ON c.cia=v.cia and c.sede=v.sede and c.id_turno_control=v.id_turno_control
INNER JOIN estado e ON e.cia=v.cia and e.id_estado=v.id_estado
INNER JOIN compania co ON co.cia=v.cia
INNER JOIN sede se ON se.cia=v.cia and se.sede=v.sede'
-------------------------------------------------------------------------------
IF @tipo=0 
BEGIN
SELECT @sCondicion='WHERE v.cia=''' + @cia + '''  and v.sede='''+@sede+''' and (convert(varchar(8),v.fecha,112) between ''' + @FECHA1 + '''
 and ''' + @FECHA2 + ''') '+@filtro+''
END
ELSE IF @tipo=1 
BEGIN
SELECT @sCondicion='WHERE v.cia=''' + @cia + '''  and v.sede='''+@sede+''' and 
(convert(int,(DATEPART(hour, v.fc)*60)+DATEPART(minute, v.fc)) between  720 and 1440) 
 and (convert(varchar(8),v.fecha,112) between ''' + @FECHA1 + '''
 and ''' + @FECHA2 + ''') '+@filtro+''
END
-------------------------------------------------------------------------------
SELECT @sGroupby='GROUP BY co.descripcion,se.descripcion,v.fecha, v.id_turno, v.id_manguera, v.id_turno_control, c.cierre'
-------------------------------------------------------------------------------
SELECT @sOrderby='ORDER BY fecha, turno,manguera'
------------------------------------------------------------------------------------------------------------------
SELECT @sExecute = @sSelect +' '+ @sCondicion +' '+ @filtro+' '+ @sGroupby+' '+@sOrderby
-------------------------------------------------------------------------------
--PRINT @sExecute
EXEC ('SELECT '+ @sExecute )
GO
/****** Object:  StoredProcedure [dbo].[sp_listar_Ve_x_Ma_y_Tu_det]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------Ventas Diarias detalladas---------------------*/

--sp_listar_Ve_x_Ma_y_Tu_det 0,'01','02','10/08/2010','13/08/2010',' and v.id_surtidor=02'

CREATE PROCEDURE [dbo].[sp_listar_Ve_x_Ma_y_Tu_det]
@tipo int,@cia char(2),@sede char(2), @fec1 datetime, @fec2 datetime, @filtro varchar(500)
AS
-------------------------------------------------------------------------------
DECLARE @sExecute varchar(max),@sSelect varchar(max),@sCondicion varchar(max),@sGroupby varchar(max),@sOrderby varchar(max)
-------------------------------------------------------------------------------
DECLARE @FECHA1 VARCHAR(8),@FECHA2 VARCHAR(8)
-------------------------------------------------------------------------------
SET @FECHA1 = CONVERT(VARCHAR(8),@fec1,112)
SET @FECHA2 = CONVERT(VARCHAR(8),@fec2,112)
-------------------------------------------------------------------------------
SELECT @sExecute='',@sSelect='',@sCondicion='',@sGroupby='',@sOrderby=''
-------------------------------------------------------------------------------
SELECT @sSelect='co.descripcion ''Cia'',se.descripcion ''Sede'',convert(varchar(10), v.fecha,103) ''Fecha'',convert(varchar(10), v.fc,108) ''Hora'',vd.ruc ''Ruc'',td.descripcion ''Tipo de Documento'',
vd.nro_doc ''# Documento'',v.placa ''Placa'',s.descripcion ''Surtidor'',c.descripcion ''Cara'',min(v.contometro_inicial) as ''Lectura Inicial'',
max(v.contometro_final) as ''Lectura Final'',avg(v.precio) ''Precio M3'', sum(v.cantidad) ''Cant M3'', sum(v.subtotal) ''Recaudo'', sum(v.subtotal) ''Valor''
FROM e_venta_documento vd
INNER JOIN e_venta v ON v.id_venta=vd.id_venta and v.cia=vd.cia and v.sede=vd.sede 
INNER JOIN tipo_documento td ON td.id_tipo_doc=vd.id_tipo_doc and td.cia=vd.cia
INNER JOIN e_surtidor s ON s.id_surtidor=v.id_surtidor and s.cia=v.cia 
INNER JOIN e_cara c ON c.id_cara=v.id_cara  and c.cia=v.cia
INNER JOIN compania co ON co.cia=v.cia
INNER JOIN sede se ON se.cia=v.cia and se.sede=v.sede'
-------------------------------------------------------------------------------
IF @tipo=0 
BEGIN
SELECT @sCondicion='WHERE v.cia=''' + @cia + '''  and v.sede='''+@sede+''' and (convert(varchar(8),v.fecha,112) between ''' + @FECHA1 + '''
 and ''' + @FECHA2 + ''') '+@filtro+''
END
ELSE IF @tipo=1 
BEGIN
SELECT @sCondicion='WHERE v.cia=''' + @cia + '''  and v.sede='''+@sede+'''  and 
(convert(int,(DATEPART(hour, v.fc)*60)+DATEPART(minute, v.fc)) between  720 and 1440) 
and (convert(varchar(8),v.fecha,112) between ''' + @FECHA1 + '''
 and ''' + @FECHA2 + ''') '+@filtro+''
END
-------------------------------------------------------------------------------
SELECT @sGroupby='GROUP BY co.descripcion,se.descripcion,v.fecha,v.fc,vd.ruc,td.descripcion,vd.nro_doc,v.placa,s.descripcion,c.descripcion'
-------------------------------------------------------------------------------
SELECT @sOrderby='ORDER BY fecha,hora'
------------------------------------------------------------------------------------------------------------------
SELECT @sExecute = @sSelect +' '+ @sCondicion+' '+ @filtro+' '+ @sGroupby+' '+@sOrderby
-------------------------------------------------------------------------------
--PRINT @sExecute
EXEC ('SELECT '+ @sExecute )
GO
/****** Object:  StoredProcedure [dbo].[sp_listar_Ve_x_Mes]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*----------------Ventas mensuales----------------------*/

--sp_listar_Ve_x_Mes 0,'01','02','10/08/2010','13/08/2010',''

CREATE PROCEDURE [dbo].[sp_listar_Ve_x_Mes]
@tipo int,@cia char(2),@sede char(2), @fec1 datetime, @fec2 datetime,@filtro varchar(500)
AS
-------------------------------------------------------------------------------
DECLARE @sExecute varchar(max),@sSelect varchar(max),@sCondicion varchar(max),@sGroupby varchar(max),@sOrderby varchar(max)
-------------------------------------------------------------------------------
DECLARE @FECHA1 VARCHAR(8),@FECHA2 VARCHAR(8)
-------------------------------------------------------------------------------
SET @FECHA1 = CONVERT(VARCHAR(8),@fec1,112)
SET @FECHA2 = CONVERT(VARCHAR(8),@fec2,112)
-------------------------------------------------------------------------------
SELECT @sExecute='',@sSelect='',@sCondicion='',@sGroupby='',@sOrderby=''
-------------------------------------------------------------------------------
SELECT @sSelect='c.descripcion ''Cia'',s.descripcion ''Sede'',Year(v.fecha) ''Ano'',datename(m,v.fecha) ''Mes'',a.nro_parte ''Producto'',v.id_turno_control ''Turno'',
sum(v.cantidad) ''Cantidad M3'',sum(v.precio) ''Valor'',sum(v.descuento) ''Descuento'',sum(v.subtotal) ''Abono''
FROM e_venta v
INNER JOIN articulo a ON a.id_articulo=v.id_articulo and a.cia=v.cia
INNER JOIN compania c ON c.cia=v.cia
INNER JOIN sede s ON s.cia=v.cia and s.sede=v.sede'
-------------------------------------------------------------------------------
IF @tipo=0 
BEGIN
SELECT @sCondicion='WHERE v.cia=''' + @cia + '''  and v.sede='''+@sede+''' and (convert(varchar(8),v.fecha,112) between ''' + @FECHA1 + '''
 and ''' + @FECHA2 + ''') '+@filtro+''
END
ELSE IF @tipo=1 
BEGIN
SELECT @sCondicion='WHERE v.cia=''' + @cia + '''  and v.sede='''+@sede+''' and 
(convert(int,(DATEPART(hour, v.fc)*60)+DATEPART(minute, v.fc)) between  720 and 1440) 
 and (convert(varchar(8),v.fecha,112) between ''' + @FECHA1 + '''
 and ''' + @FECHA2 + ''') '+@filtro+''
END
-------------------------------------------------------------------------------
SELECT @sGroupby='GROUP BY c.descripcion,s.descripcion,month(v.fecha),Year(v.fecha),datename(m,fecha),a.nro_parte,v.id_turno_control'
-------------------------------------------------------------------------------
SELECT @sOrderby=''
------------------------------------------------------------------------------------------------------------------
SELECT @sExecute = @sSelect +' '+ @sCondicion+' '+ @filtro +' '+ @sGroupby+' '+@sOrderby
-------------------------------------------------------------------------------
--PRINT @sExecute
EXEC ('SELECT '+ @sExecute )
GO
/****** Object:  StoredProcedure [dbo].[sp_listar_VxT]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------TURNOS----------------------*/

--sp_listar_VxT 0,'01','02','10/08/2010','13/08/2010'

CREATE PROCEDURE [dbo].[sp_listar_VxT]
@tipo int,@cia char(2),@sede char(2), @fec1 datetime, @fec2 datetime
AS
-------------------------------------------------------------------------------
DECLARE @sExecute varchar(max),@sSelect varchar(max),@sCondicion varchar(max),@sGroupby varchar(max),@sOrderby varchar(max)
-------------------------------------------------------------------------------
DECLARE @FECHA1 VARCHAR(8),@FECHA2 VARCHAR(8)
-------------------------------------------------------------------------------
SET @FECHA1 = CONVERT(VARCHAR(8),@fec1,112)
SET @FECHA2 = CONVERT(VARCHAR(8),@fec2,112)
-------------------------------------------------------------------------------
SELECT @sExecute='',@sSelect='',@sCondicion='',@sGroupby='',@sOrderby=''
-------------------------------------------------------------------------------

SELECT @sSelect='c.descripcion ''Cia'',s.descripcion ''Sede'',convert(varchar(10),tc.apertura,103) ''Fecha'',tcd.id_manguera ''MANGUERA'',
tc.id_turno ''IDTURNO'',case when tc.cierre is null then ''Abierto'' else ''Cerrado'' end ''Estado'',
tc.id_usuario ''DESPACHADOR'',tc.apertura ''APERTURA'',tc.cierre ''CIERRE'',
min(tcd.contometro_inicial) ''LECTURA INCIAL'',max(tcd.contometro_final) ''LECTURA FINAL'' 
FROM e_turno_control tc
INNER JOIN e_turno_control_det tcd ON tcd.id_turno_control=tc.id_turno_control and tcd.cia=tc.cia and tcd.sede=tc.sede
INNER JOIN e_venta v ON v.id_turno_control=tc.id_turno_control and v.cia=tc.cia and v.sede=tc.sede
inner join compania c on c.cia=v.cia
inner join sede s on s.cia=v.cia and s.sede=v.sede'
-------------------------------------------------------------------------------
IF @tipo=0 
BEGIN
SELECT @sCondicion='WHERE tc.cia='''+@cia+'''   and tc.sede='''+@sede+''' and (convert(varchar(8),v.fecha,112) between '''+@FECHA1+''' and '''+@FECHA2+''' )'
END
ELSE IF @tipo=1 
BEGIN
SELECT @sCondicion='WHERE tc.cia='''+@cia+'''   and tc.sede='''+@sede+''' and (convert(varchar(8),v.fecha,112) between '''+@FECHA1+''' and '''+@FECHA2+''' )
and ((DATEPART(hour, v.fc)*60)+(DATEPART(minute, v.fc)) between  720 and 1440)'
END
-------------------------------------------------------------------------------
SELECT @sGroupby='GROUP BY c.descripcion,s.descripcion,tcd.id_manguera,tc.id_turno,tc.id_usuario,tc.apertura,tc.cierre'
-------------------------------------------------------------------------------
SELECT @sOrderby=''
------------------------------------------------------------------------------------------------------------------
SELECT @sExecute = @sSelect +' '+ @sCondicion +' '+ @sGroupby+' '+@sOrderby
-------------------------------------------------------------------------------
--PRINT @sExecute
EXEC ('SELECT '+ @sExecute )
GO
/****** Object:  StoredProcedure [dbo].[SP_MANTE_CRONOGRAMA]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*

SP_MANTE_CRONOGRAMA 2,'a34a29b2-d6b6-4ba8-9a8b-82450cf0492a','01','01','0000','00000017','12',
					'25-10-2010','27-10-2010','2','10000000003','1','1','42476689','fdthhtrhn',
					'admin','00000093','kuikui','','',''
					
SP_MANTE_CRONOGRAMA 3,'','01','01','0000','00000032','12',
					'25-10-2010','27-10-2010','2','10000000003','1','1','42476689','fdthhtrhn',
					'admin','00000093','kuikui','','',''

*/

------------------------------------------------------------------------------------------------------


CREATE PROCEDURE [dbo].[SP_MANTE_CRONOGRAMA]
@INDICADOR INT,@SESION VARCHAR(500),@CIA CHAR(2),@SEDE CHAR(2),@SERIE_DOC CHAR(4),@NRO_DOC VARCHAR(20),@ID_MOTIVO_SERVICIO CHAR(2),@FECHA_INICIO DATETIME,@FECHA_FIN DATETIME,
@TIEMPO_DURACION INT,@ID_CLIENTE VARCHAR(20),@ID_PUNTO_VENTA VARCHAR(20),@ID_CONTACTO VARCHAR(20),@ID_TECNICO VARCHAR(20),@OBSERVACION TEXT,
@USUARIO VARCHAR(20),@NRO_FAE VARCHAR(20),@PLACA VARCHAR(200),@T1 VARCHAR(20),@T2 VARCHAR(20),@T3 VARCHAR(20)
AS
-------------------------------------------------------------------------
DECLARE @FECHA1 DATETIME,@FECHA2 DATETIME, @TEC1 VARCHAR(20),@TEC2 VARCHAR(20),@TEC3 VARCHAR(20)
-------------------------------------------------------------------------
SET @FECHA1=@FECHA_INICIO
--SET @FECHA2=@FECHA_FIN
SET @TEC1=@T1
SET @TEC2=@T2
SET @TEC3=@T3
-------------------------------------------------------------------------
IF datepart(hh,@FECHA_INICIO) > datepart(hh,@FECHA_FIN) BEGIN SET @FECHA2=(@FECHA_FIN)+1 END ELSE BEGIN SET @FECHA2=@FECHA_FIN END 
-------------------------------------------------------------------------
IF LEN(@TEC1)>0 BEGIN SET @T1=@T1 END ELSE BEGIN SET @T1=NULL END 
IF LEN(@TEC2)>0 BEGIN SET @T2=@T2 END ELSE BEGIN SET @T2=NULL END 
IF LEN(@TEC3)>0 BEGIN SET @T3=@T3 END ELSE BEGIN SET @T3=NULL END 
-------------------------------------------------------------------------
IF @INDICADOR=1
BEGIN

INSERT INTO CRONOGRAMA_OPER (CIA,SEDE,ID_TIPO_DOC,SERIE_DOC,NRO_DOC,ID_MOTIVO_SERVICIO,FECHA,FECHA_INICIO,FECHA_FIN,TIEMPO_DURACION,
ID_CLIENTE,ID_PUNTO_VENTA,ID_CONTACTO,ID_TECNICO,OBSERVACION,ID_ESTADO,FLAG_ENVIO,FC,UC,UE,ID_TECNICO_2,ID_TECNICO_3,ID_TECNICO_4,FECHA_EJECUTA) 
VALUES (@CIA,@SEDE,'86',@SERIE_DOC,@NRO_DOC,@ID_MOTIVO_SERVICIO,GETDATE(),@FECHA1,@FECHA2,@TIEMPO_DURACION,
@ID_CLIENTE,@ID_PUNTO_VENTA,@ID_CONTACTO,@ID_TECNICO,@OBSERVACION,'11','1',GETDATE(),@USUARIO,@USUARIO,@T1,@T2,@T3,@FECHA_INICIO)
-------------------------------------------------------------------------
INSERT INTO CRONOGRAMA_OPER_DETALLE (CIA,SEDE,ID_TIPO_DOC,SERIE_DOC,NRO_DOC,ITEM,ID_ARTICULO,CANTIDAD,
DES_ARTICULO,ID_TIPO_FAE,NRO_FAE,PLACA,ID_ESTADO,FLAG_ENVIO,FC,UC,UE) 

SELECT CIA,SEDE,'86',@SERIE_DOC,@NRO_DOC,ITEM,ID_ARTICULO,CANTIDAD,
DESCRIPCION,'27',@NRO_FAE,@PLACA,'01','1',GETDATE(),@USUARIO,@USUARIO FROM ARTICULO_TEMP
WHERE CIA=@CIA AND SEDE=@SEDE AND SESION=@SESION AND ID_ESTADO='01'

UPDATE TIPO_DOCUMENTO_SERIE SET CORRELATIVO=CORRELATIVO+1 WHERE CIA=@CIA AND ID_TIPO_DOC='86' AND SERIE=@SERIE_DOC AND ID_ESTADO='01' 

END
------------------------------------------
ELSE IF @INDICADOR=2
BEGIN 

UPDATE CRONOGRAMA_OPER SET SEDE=@SEDE,ID_MOTIVO_SERVICIO=@ID_MOTIVO_SERVICIO,FECHA_INICIO=@FECHA1,FECHA_FIN=@FECHA2,FECHA_EJECUTA=@FECHA_INICIO,
TIEMPO_DURACION=@TIEMPO_DURACION,ID_CLIENTE=@ID_CLIENTE,ID_PUNTO_VENTA=@ID_PUNTO_VENTA,ID_CONTACTO=@ID_CONTACTO,ID_TECNICO=@ID_TECNICO,
OBSERVACION=@OBSERVACION,ID_TECNICO_2=@T1,ID_TECNICO_3=@T2,ID_TECNICO_4=@T3
WHERE CIA=@CIA AND SEDE=@SEDE AND ID_TIPO_DOC='86' AND SERIE_DOC=@SERIE_DOC AND NRO_DOC=@NRO_DOC
-------------------------------------------------------------------------
DELETE CRONOGRAMA_OPER_PEDIDO WHERE CIA=@CIA AND SERIE_DOC=@SERIE_DOC AND NRO_DOC=@NRO_DOC 
DELETE CRONOGRAMA_OPER_DETALLE WHERE CIA=@CIA AND SEDE=SEDE AND SERIE_DOC=@SERIE_DOC AND NRO_DOC=@NRO_DOC
-------------------------------------------------------------------------
INSERT INTO CRONOGRAMA_OPER_DETALLE (CIA,SEDE,ID_TIPO_DOC,SERIE_DOC,NRO_DOC,ITEM,ID_ARTICULO,CANTIDAD,
DES_ARTICULO,ID_TIPO_FAE,NRO_FAE,PLACA,ID_ESTADO,FLAG_ENVIO,FM,UM) 
SELECT CIA,SEDE,'86',@SERIE_DOC,@NRO_DOC,ITEM,ID_ARTICULO,CANTIDAD,
DESCRIPCION,'27',@NRO_FAE,@PLACA,'01','1',GETDATE(),@USUARIO FROM ARTICULO_TEMP
WHERE CIA=@CIA AND SEDE=@SEDE AND SESION=@SESION AND ID_ESTADO='01'

END
-----------------------------------
ELSE
BEGIN 
UPDATE CRONOGRAMA_OPER SET ID_ESTADO='12' WHERE CIA=@CIA AND SEDE=@SEDE AND ID_TIPO_DOC='86' AND SERIE_DOC=@SERIE_DOC AND NRO_DOC=@NRO_DOC
UPDATE CRONOGRAMA_OPER_DETALLE SET ID_ESTADO='02'  WHERE CIA=@CIA AND SEDE=@SEDE AND ID_TIPO_DOC='86' AND SERIE_DOC=@SERIE_DOC AND NRO_DOC=@NRO_DOC
UPDATE CRONOGRAMA_OPER_PEDIDO SET ID_ESTADO='02'  WHERE CIA=@CIA AND SEDE=@SEDE AND ID_TIPO_DOC='86' AND SERIE_DOC=@SERIE_DOC AND NRO_DOC=@NRO_DOC
END

------------------------------------------------------------------------------------------------------

/*

SP_MANTE_CRONOGRAMA '03','','01','01','00000009','','','','','','','','','','','','','','','',''


SELECT * FROM ARTICULO_TEMP 

UPDATE CRONOGRAMA_OPER SET ID_ESTADO='11' WHERE CIA='01' AND SEDE='01' AND SERIE_DOC='0001' AND NRO_DOC='00000009'
UPDATE CRONOGRAMA_OPER_DETALLE SET ID_ESTADO='01'  WHERE CIA='01' AND SEDE='01' AND SERIE_DOC='0001' AND NRO_DOC='00000009'

SELECT * FROM dbo.CRONOGRAMA_OPER

SELECT * FROM dbo.CRONOGRAMA_OPER_DETALLE

SP_MANTE_CRONOGRAMA
2,'5715619d-5a25-454b-965f-fb7eceff87e8','01','01','00000003','01','01/01/1900','01/01/1900',
'5','20124653780','1','1','44725392','jojo prueba',
'admin','1','MANSER0000000002','2','jujuj','00000040','20124653780'



INSERT INTO CRONOGRAMA_OPER_DETALLE (CIA,SEDE,ID_TIPO_DOC,SERIE_DOC,NRO_DOC,ITEM,ID_ARTICULO,CANTIDAD,
DES_ARTICULO,ID_TIPO_FAE,NRO_FAE,PLACA,ID_ESTADO,FLAG_ENVIO,FM,UM) 
SELECT CIA,SEDE,'86','0001','00000001',ITEM,ID_ARTICULO,CANTIDAD,
DESCRIPCION,'27','00000040',20124653780,'01','1',GETDATE(),'admin' FROM ARTICULO_TEMP
WHERE CIA='01' AND SEDE='01' AND SESION='5715619d-5a25-454b-965f-fb7eceff87e8'



@INDICADOR INT,@SESION VARCHAR(500),@CIA CHAR(2),@SEDE CHAR(2),@NRO_DOC VARCHAR(20),@ID_MOTIVO_SERVICIO CHAR(2),@FECHA_INICIO DATETIME,@FECHA_FIN DATETIME,
@TIEMPO_DURACION INT,@ID_CLIENTE VARCHAR(20),@ID_PUNTO_VENTA VARCHAR(20),@ID_CONTACTO VARCHAR(20),@ID_TECNICO VARCHAR(20),@OBSERVACION TEXT,
@USUARIO VARCHAR(20),@ITEM INT,@ID_ARTICULO VARCHAR(20),@CANTIDAD FLOAT,@DES_ARTICULO VARCHAR(100),@NRO_FAE VARCHAR(20),@PLACA VARCHAR(60)

*/
GO
/****** Object:  StoredProcedure [dbo].[SP_MANTE_CRONOGRAMA_OP]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*

DELETE CRONOGRAMA_OPER_PEDIDO

sp_help CRONOGRAMA_OPER_PEDIDO

select * from estado order by id_estado

SELECT * FROM dbo.CRONOGRAMA_OPER_DETALLE

SELECT * FROM dbo.CRONOGRAMA_OPER_PEDIDO

SELECT * FROM dbo.DOC_GESTION_FA_DETALLE

SP_MANTE_CRONOGRAMA_OP 1,'01','01','0000','00000007','21','2010','00000137',1,'admin'

*/


CREATE PROCEDURE [dbo].[SP_MANTE_CRONOGRAMA_OP]
@INDICADOR INT,@CIA CHAR(2),@SEDE CHAR(2),@SERIE_DOC CHAR(4),@NRO_DOC  VARCHAR(8),@TIPO_DOC_REF  VARCHAR(2),@SERIE_DOC_REF  VARCHAR(4),
@NRO_DOC_REF  VARCHAR(20),@ITEM_REF INT,@UC	 VARCHAR(100)
AS
IF @INDICADOR=1
BEGIN
INSERT INTO CRONOGRAMA_OPER_PEDIDO 
		(CIA,SEDE,ID_TIPO_DOC,SERIE_DOC,NRO_DOC,ITEM,ID_TIPO_DOC_REF,SERIE_DOC_REF,NRO_DOC_REF,ITEM_REF,ID_ESTADO,FLAG_ENVIO,FC,UC) 
      VALUES
       (@CIA,@SEDE,'86',@SERIE_DOC,@NRO_DOC,'1',@TIPO_DOC_REF,@SERIE_DOC_REF,@NRO_DOC_REF,@ITEM_REF,'01',1,GETDATE(),@UC)
END
------------------------------------------
ELSE IF @INDICADOR=2
BEGIN 

UPDATE CRONOGRAMA_OPER_PEDIDO  SET FM=GETDATE(),UM=@UC,ID_ESTADO='02'
	WHERE CIA=@CIA AND SEDE=@SEDE AND NRO_DOC=@NRO_DOC AND NRO_DOC_REF=@NRO_DOC_REF
	
INSERT INTO CRONOGRAMA_OPER_PEDIDO 
	(CIA,SEDE,ID_TIPO_DOC,SERIE_DOC,NRO_DOC,ITEM,ID_TIPO_DOC_REF,SERIE_DOC_REF,NRO_DOC_REF,ITEM_REF,ID_ESTADO,FLAG_ENVIO,FC,UC) 
VALUES
   (@CIA,@SEDE,'86',@SERIE_DOC,@NRO_DOC,'1',@TIPO_DOC_REF,@SERIE_DOC_REF,@NRO_DOC_REF,@ITEM_REF,'01',1,GETDATE(),@UC)
END
-----------------------------------
ELSE
BEGIN 
--UPDATE CRONOGRAMA_OPER_PEDIDO  SET ID_ESTADO='02' WHERE CIA=@CIA AND SEDE=@SEDE AND NRO_DOC=@NRO_DOC
UPDATE CRONOGRAMA_OPER_PEDIDO SET ID_ESTADO='02'  WHERE CIA=@CIA AND SEDE=@SEDE AND ID_TIPO_DOC='86' AND SERIE_DOC=@SERIE_DOC AND NRO_DOC=@NRO_DOC
													AND ITEM='1' AND ID_TIPO_DOC_REF='86' AND SERIE_DOC_REF=@SERIE_DOC AND NRO_DOC_REF=@NRO_DOC 
													AND ITEM_REF='1'
END

------------------------------------------------------------------------------------------------------
GO
/****** Object:  StoredProcedure [dbo].[SP_MANTE_MONTAJE]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*

01-21
sp_help 'DOC_GESTION_FA_REF_DOC_CC'
select * from DOCUMENTO_CC_GESTION

delete DOCUMENTO_CC_GESTION where cia='01' and sede='01' and ID_TIPO_DOC='42' and serie_doc='0000' and nro_doc='00003629'
and ID_TIPO_DOC_ref='20' and serie_doc_ref='2010' and nro_doc_ref='00000687'

SP_MANTE_MONTAJE '2','01','01','42','0000','00003629','20','2010','00000687','01','SISTEMAS'

*/



CREATE PROCEDURE [dbo].[SP_MANTE_MONTAJE]
@INDICADOR INT,@CIA CHAR(2),@SEDE CHAR(2),@ID_TIPO_DOC CHAR(2),@SERIE_DOC CHAR(4),@NRO_DOC VARCHAR(20),
@ID_TIPO_DOC_REF CHAR(2),@SERIE_DOC_REF CHAR(4),@NRO_DOC_REF VARCHAR(20),@SE CHAR(2),@UC VARCHAR(10)
AS
IF @INDICADOR=1 
BEGIN 		
INSERT	INTO DOC_GESTION_FA_REF_DOC_CC
		(	CIA,SEDE,ID_TIPO_DOC,SERIE_DOC,NRO_DOC,ID_TIPO_DOC_REF,SERIE_DOC_REF,NRO_DOC_REF,ID_ESTADO,FLAG_ENVIO,LOTE_ENVIO,FC,UC	)
	VALUES		
	(	@CIA,@SEDE,@ID_TIPO_DOC,@SERIE_DOC,@NRO_DOC,@ID_TIPO_DOC_REF,@SERIE_DOC_REF,@NRO_DOC_REF,'01','1','1',GETDATE(),@UC			)
	
END
--------------------------------------------------------------
ELSE IF @INDICADOR=2 
BEGIN 
/*
UPDATE DOCUMENTO_CC_GESTION SET ID_ESTADO='02',FM=GETDATE(),UM=@UC
					WHERE CIA=@CIA AND SEDE=@SEDE AND ID_TIPO_DOC=@ID_TIPO_DOC AND SERIE_DOC=@SERIE_DOC
					AND NRO_DOC=@NRO_DOC AND ID_TIPO_DOC_REF=@ID_TIPO_DOC_REF AND SERIE_DOC_REF=@SERIE_DOC_REF AND NRO_DOC_REF=@NRO_DOC_REF
*/
DELETE DOC_GESTION_FA_REF_DOC_CC WHERE CIA=@CIA AND SEDE=@SEDE AND ID_TIPO_DOC=@ID_TIPO_DOC AND SERIE_DOC=@SERIE_DOC
					AND NRO_DOC=@NRO_DOC AND ID_TIPO_DOC_REF=@ID_TIPO_DOC_REF AND SERIE_DOC_REF=@SERIE_DOC_REF AND NRO_DOC_REF=@NRO_DOC_REF

END
GO
/****** Object:  StoredProcedure [dbo].[SP_MANTENIMIENTO_ANALITICA_TEMP]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*

SP_LISTAR_ANALITICA '01','08','',''



[SP_MANTENIMIENTO_ANALITICA_TEMP] '1','f6802722-e8b0-435f-b2ff-7459eb08d70c','01','01','','42953327','RIVERA CARHUAYAL, JHERSON MILCIADES'
[SP_MANTENIMIENTO_ANALITICA_TEMP] '3','81fd6a7d-91cf-47ff-ada2-330734990d42','01','02','2','',''
GO
[SP_MANTENIMIENTO_ANALITICA_TEMP] '4','81fd6a7d-91cf-47ff-ada2-330734990d42','01','02','2','',''
GO
SP_LISTAR_ANALITICA_TEMP '81fd6a7d-91cf-47ff-ada2-330734990d42','01','02'

SELECT * FROM ANALITICA_TEMP
DELETE FROM ANALITICA_TEMP
SP_HELP ANALITICA_TEMP
*/
----------------------------------------------
----------------------------------------------
create	PROCEDURE [dbo].[SP_MANTENIMIENTO_ANALITICA_TEMP]
@INDICADOR		CHAR(1),
@SESION			VARCHAR(MAX),
@CIA			CHAR(2),
@SEDE			CHAR(2),
@COD			INT,
@ID_ANALITICA	VARCHAR(20),
@DESCRIPCION	VARCHAR(100)
AS
----------------------------------------------
DECLARE @ITEM INT,@COUNT INT,@VARMSG VARCHAR(MAX)
----------------------------------------------
BEGIN TRANSACTION
	-------------------------------------------------------------------------------------
	IF (@INDICADOR = '1')		/*	INSERTAMOS LOS DATOS	*/
	BEGIN
		SET @ITEM =		( SELECT ISNULL ((SELECT max(ITEM) FROM ANALITICA_TEMP WHERE SESION = @SESION),0) )
		IF(@ITEM > 0) BEGIN SET @ITEM = @ITEM + 1 END ELSE BEGIN SET @ITEM = 1 END
		--print @ITEM
			SET @COUNT = ( SELECT ISNULL ((	SELECT	COUNT(*) FROM	ANALITICA_TEMP 	WHERE	SESION = @SESION 
													AND		CIA = @CIA 	AND	SEDE = @SEDE),0) )
		------------------------------------------------------
		IF(@COUNT < 3)			
				----------------------------------------------			
				INSERT INTO ANALITICA_TEMP	
				(		
					SESION,CIA,SEDE,ITEM,ID_ANALITICA,DESCRIPCION,ID_ESTADO,FC
				)
				VALUES
				(
					@SESION,@CIA,@SEDE,@ITEM,@ID_ANALITICA,@DESCRIPCION,'01',GETDATE()
				)
				-------------------------------------------
				IF @@ERROR <> 0 OR @@ROWCOUNT <> 1
				BEGIN
					---------------------------------------
					SET		@VARMSG	= 'SE PRODUJO UN ERROR DURANTE EL PROCESO DE GRABACION DEL ANALITICA_TEMP. NO SE GRABARON LOS DATOS.'
					GOTO	MSGERROR
					----------------------------------------
				END 
				ELSE
				BEGIN
					----------------------------------------
					SET	@VARMSG					= 'DATOS GRABADOS.'	
					----------------------------------------
				END			
					--DELETE	FROM ANALITICA_TEMP 	WHERE	SESION = @SESION
	END
---------------------------------------------------------------------------------------------------------------
		-------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------
	IF (@INDICADOR = '3')			/*	ELIMINAR LOS DATOS	*/
	BEGIN
		DELETE	FROM ANALITICA_TEMP	WHERE	SESION = @SESION AND CIA=@CIA AND SEDE=@SEDE AND ITEM=@COD	
		-------------------------------------------
		IF @@ERROR <> 0 OR @@ROWCOUNT <> 1
		BEGIN
			---------------------------------------
			SET		@VARMSG	= 'SE PRODUJO UN ERROR DURANTE EL PROCESO DE ELIMINACION DE LA ANALITICA_TEMP. NO SE ELIMINO EL REGISTRO.'
			GOTO	MSGERROR
			----------------------------------------
		END 
		ELSE
		BEGIN
			----------------------------------------
			SET	@VARMSG	= 'REGISTRO ELIMINADO.'
			----------------------------------------
		END	
	END
---------------------------------------------------------------------------------------------------------------
		-------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------
	IF (@INDICADOR = '4')		/*	LIMPIAR LOS DATOS	*/
	BEGIN
		DELETE	FROM ANALITICA_TEMP	WHERE	CIA=@CIA AND SEDE=@SEDE and SESION=@SESION	
	END
----------------------------------------------------------------------------------------------


COMMIT TRANSACTION
------------------------------------------------
RETURN
MSGERROR:
		ROLLBACK TRANSACTION
		----------------------------------------
		RAISERROR	(@VARMSG, 15, 1)
		RETURN
GO
/****** Object:  StoredProcedure [dbo].[SP_MANTENIMIENTO_PUNTO_VENTA_TEMP]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*

DELETE FROM PUNTO_VENTA_TEMP

PROCOM0000000002
PROCOM0000000005
PROLUB0000000001
SELECT * FROM ARTICULO WHERE ID_ARTICULO = 'PROCOM0000000002'
SELECT * FROM EXISTENCIA_SEDE WHERE ID_ARTICULO = 'PROCOM0000000002' AND SEDE = '01'
SELECT * FROM EXISTENCIA_ALMACEN WHERE ID_ARTICULO = 'PROCOM0000000002' AND  SEDE = '01' AND ID_ALMACEN = '01'
SELECT * FROM LISTA_PRECIO 
SELECT * FROM LISTA_PRECIO_DET WHERE ID_ARTICULO = 'PROCOM0000000002'

DECLARE @TOTALES VARCHAR(300)
EXEC SP_MANTENIMIENTO_PUNTO_VENTA_TEMP '4', '92ab2485-6d9f-484e-80d9-4cccf8e33314', '01', '01', '01', 'EDS', 0, 'PROCOM0000000002', 1, @TOTALES OUTPUT
PRINT @TOTALES


SELECT * FROM PUNTO_VENTA_TEMP


*/
------------------------------------------------
------------------------------------------------
create	PROCEDURE	[dbo].[SP_MANTENIMIENTO_PUNTO_VENTA_TEMP]
@INDICADOR			CHAR(1),
@SESION				VARCHAR(100),
@CIA				CHAR(2),
@SEDE				CHAR(2),
@ID_ALMACEN			CHAR(2),
@ID_LISTA_PRECIO	CHAR(3),
@ITEM				INT,
@ID_ARTICULO		VARCHAR(20),
@CANTIDAD			FLOAT,
@TOTALES			VARCHAR(300)OUTPUT
AS
------------------------------------------------
/* VARIABLES PARA VALIDAR */
DECLARE	@COUNT		INT
DECLARE	@STOCK		FLOAT
DECLARE	@UNIDAD		VARCHAR(10)
DECLARE	@PRECIO		FLOAT
DECLARE	@COUNT_PRO	INT
------------------------------------------------
/* VARIABLES PARA TOTALES*/
DECLARE	@SUBTOTAL	FLOAT
DECLARE	@IMPUESTOS	FLOAT
DECLARE	@TOTAL		FLOAT
------------------------------------------------
SET	@TOTALES = ''
------------------------------------------------
SET	@COUNT_PRO	=	(	SELECT	ISNULL((SELECT COUNT(*)
						FROM	PUNTO_VENTA_TEMP
						WHERE	SESION		= @SESION
						AND		CIA			= @CIA
						AND		ID_ARTICULO	= @ID_ARTICULO),0)
					)
					
SET	@COUNT	=	(	SELECT	ISNULL((SELECT COUNT(*)
					FROM	EXISTENCIA_ALMACEN
					WHERE	CIA			= @CIA
					AND		SEDE		= @SEDE
					AND		ID_ALMACEN	= @ID_ALMACEN
					AND		ID_ARTICULO	= @ID_ARTICULO
					AND		ID_ESTADO	= '01'),0)
				)
				
SET	@STOCK	=	(	SELECT	ISNULL((SELECT CANT_DISPONIBLE
					FROM	EXISTENCIA_ALMACEN
					WHERE	CIA			= @CIA
					AND		SEDE		= @SEDE
					AND		ID_ALMACEN	= @ID_ALMACEN
					AND		ID_ARTICULO	= @ID_ARTICULO
					AND		ID_ESTADO	= '01'
					),0)
				)
				
SET	@UNIDAD	=	(	SELECT	ISNULL((SELECT	UNIDAD_MEDIDA.ABREVIATURA
					FROM    UNIDAD_MEDIDA 
					INNER JOIN ARTICULO ON UNIDAD_MEDIDA.CIA = ARTICULO.CIA AND UNIDAD_MEDIDA.ID_UNIDAD = ARTICULO.ID_UNIDAD
					WHERE	ARTICULO.CIA		= @CIA 
					AND		ARTICULO.ID_ARTICULO= @ID_ARTICULO 
					AND		ARTICULO.ID_ESTADO	= '01'),'')
				)
				
SET	@PRECIO	=	(	SELECT	ISNULL((SELECT PRECIO_VENTA
					FROM	LISTA_PRECIO_DET
					WHERE	CIA				= @CIA
					AND		ID_LISTA_PRECIO	= @ID_LISTA_PRECIO
					AND		ID_ARTICULO		= @ID_ARTICULO
					AND		ID_ESTADO		= '01'),0)
				)
------------------------------------------------
--IF(@INDICADOR = '1' OR @INDICADOR = '2')
--BEGIN
--	--------------------------------------------
--	IF(@COUNT_PRO > 0)
--	BEGIN 
--		SET @INDICADOR	= '2'
--		SET	@ITEM		=	( SELECT ITEM FROM	PUNTO_VENTA_TEMP WHERE SESION = @SESION AND CIA = @CIA AND ID_ARTICULO = @ID_ARTICULO)
--		SET @CANTIDAD	= 1
--	END
--	ELSE BEGIN SET @INDICADOR = '1' END
--	--------------------------------------------
--END
------------------------------------------------
IF(@INDICADOR = '1') -- INSERTAMOS
BEGIN
	--------------------------------------------
	--IF(@COUNT = 0) BEGIN SET @TOTALES = 'Producto no existe' END
	--ELSE
	--BEGIN 
		----------------------------------------
		IF(@STOCK = 0) BEGIN SET @TOTALES = 'Producto sin stock' END
		ELSE
		BEGIN
			------------------------------------
			IF(@PRECIO = 0) BEGIN SET @TOTALES = 'Producto no tiene Precio de Venta' END
			ELSE
			BEGIN
				------------------------------------
				SET @ITEM =	( SELECT ISNULL ((SELECT max(ITEM) FROM PUNTO_VENTA_TEMP WHERE SESION = @SESION AND CIA = @CIA),0) )
				IF(@ITEM > 0) BEGIN SET @ITEM = @ITEM + 1 END ELSE BEGIN SET @ITEM = 1 END
				------------------------------------
				INSERT	INTO PUNTO_VENTA_TEMP
				(
					SESION, CIA, SEDE, ITEM, ID_ARTICULO, UNIDAD, STOCK, CANTIDAD, PRECIO, TOTAL
				)
				VALUES
				(
					@SESION, @CIA, @SEDE, @ITEM, @ID_ARTICULO, @UNIDAD, @STOCK, 1, @PRECIO, (@PRECIO * 1)
				)
				------------------------------------
			END
		END
		----------------------------------------
	--END
END
ELSE
BEGIN
	--------------------------------------------
	IF(@INDICADOR = '2')--ACTUALIZAR
	BEGIN
		----------------------------------------
		IF(@STOCK < @CANTIDAD)
		BEGIN	
			------------------------------------
			SET @TOTALES = 'Stock insuficiente'
			------------------------------------
		END
		ELSE
			BEGIN
			------------------------------------
			UPDATE	PUNTO_VENTA_TEMP
			SET		CANTIDAD	= @CANTIDAD,--CANTIDAD + @CANTIDAD,
					TOTAL		= @CANTIDAD * PRECIO--(CANTIDAD + @CANTIDAD) * PRECIO
			WHERE	SESION		= @SESION
			AND		CIA			= @CIA
			AND		SEDE		= @SEDE
			AND		ITEM		= @ITEM
			AND		ID_ARTICULO	= @ID_ARTICULO
			------------------------------------
		END
		----------------------------------------
	END
	ELSE --ELIMINA
	BEGIN
		----------------------------------------
		IF(@INDICADOR = '3')
		BEGIN
			------------------------------------
			DELETE	FROM PUNTO_VENTA_TEMP
			WHERE	SESION		= @SESION
			AND		CIA			= @CIA
			AND		SEDE		= @SEDE
			AND		ITEM		= @ITEM
			AND		ID_ARTICULO	= @ID_ARTICULO
			------------------------------------
		END
		ELSE
		BEGIN
			------------------------------------
			DELETE	FROM PUNTO_VENTA_TEMP
			WHERE	SESION		= @SESION
			AND		CIA			= @CIA
			------------------------------------
		END
		----------------------------------------
	END
	--------------------------------------------
END
------------------------------------------------
/*	CALCULO DE TOTALES	*/
IF(LEN(@TOTALES) = 0)
BEGIN
	--------------------------------------------
	SET	@TOTAL		= (SELECT ISNULL((SELECT SUM(TOTAL) FROM PUNTO_VENTA_TEMP WHERE SESION = @SESION AND CIA = @CIA AND SEDE = @SEDE),0))
	SET	@IMPUESTOS	= (@TOTAL * 0.19)
	SET	@SUBTOTAL	= (@TOTAL - @IMPUESTOS)
	SET	@TOTALES	= CONVERT(VARCHAR(30),CONVERT(NUMERIC(15,2),@SUBTOTAL)) + ',' + CONVERT(VARCHAR(30),CONVERT(NUMERIC(15,2),@IMPUESTOS)) + ',' + CONVERT(VARCHAR(30),CONVERT(NUMERIC(15,2),@TOTAL))
	--------------------------------------------
END
GO
/****** Object:  StoredProcedure [dbo].[SP_MIGRACION]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*

SELECT * FROM E_MANGUERA

SELECT * FROM E_VENTA
SELECT * FROM E_VENTA_DOCUMENTO ORDER BY SERIE_DOC, NRO_DOC

DELETE FROM E_VENTA
DELETE FROM E_VENTA_DOCUMENTO

---- TURNO DE LA MAÑANA

EXEC SP_MIGRACION '09/08/2010','09/08/2010 08:01:00', '09/08/2010 08:03:00', '01', '01','01','43766685','ADMIN', '0001', '10', 'DER-457'

EXEC SP_MIGRACION '09/08/2010','09/08/2010 08:07:00', '09/08/2010 08:10:00', '01', '01','01','10036011748','ADMIN', '0001', '10', 'DYU-477'

SELECT * FROM E_TURNO_CONTROL
*/
---------------------------------------------------
---------------------------------------------------
create PROCEDURE [dbo].[SP_MIGRACION]
@FECHA		DATETIME,
@HORA_INI	DATETIME,
@HORA_FIN	DATETIME,
@IMPRESORA	CHAR(2),
@MANGUERA	CHAR(2),
@ID_TURNO	CHAR(2),
@RUC		VARCHAR(20),
@USUARIO	VARCHAR(10),
@SERIE		CHAR(4),
@CANTIDAD	DECIMAL,
@PLACA		VARCHAR(7)
AS
---------------------------------------------------
DECLARE @NUM INT
DECLARE @NRO VARCHAR(20)
DECLARE @COUNT VARCHAR(8)
---------------------------------------------------
INSERT INTO e_venta 
(
[CIA],[SEDE],[ID_VENTA],[ID_TURNO_CONTROL],[ID_TURNO],[ID_MANGUERA],[ID_ISLA],[ID_SURTIDOR],[ID_CARA],[ID_IMPRESORA],[ID_ARTICULO],[FECHA],
[HORA_INICIO],[HORA_FIN],[CONTOMETRO_INICIAL],[CONTOMETRO_FINAL],[CANTIDAD],[PRECIO],[SUBTOTAL],[DESCUENTO],[SUBTOTAL_CON_DSCTO],[IMPUESTO],
[TOTAL],[ID_CONDICION_PAGO],[RUC],[ID_CLIENTE],[NOMBRE_CLIENTE],[PLACA],[ID_VEHICULO],[ID_ESTADO],[FLAG_ENVIO],[LOTE_ENVIO],[SE],[FE],[UE],[FC],
[UC],[FM],[UM],[FA],[UA],[AA],[NRO_TARJETA_FIDELIZA],[PUNTOS_FIDELIZA],[LETRA_FIDELIZA],[FLAG_FIDELIZA]
)
SELECT	CIA, SEDE, (SELECT ISNULL((SELECT MAX(ID_VENTA) FROM E_VENTA WHERE CIA = '01' AND SEDE = '02'),0)) + 1,
		(SELECT ID_TURNO_CONTROL FROM E_TURNO_CONTROL WHERE CIA = '01' AND SEDE = '02' AND CONVERT(VARCHAR(8),APERTURA,112) = CONVERT(VARCHAR(8),@FECHA,112) AND LEFT(CONVERT(VARCHAR(8),APERTURA,108),2) = '20' AND ID_USUARIO = @USUARIO),
		@ID_TURNO, ID_MANGUERA, ID_ISLA, ID_SURTIDOR, ID_CARA, ID_IMPRESORA, ID_ARTICULO, @FECHA, @HORA_INI, @HORA_FIN, 
		(SELECT ISNULL((SELECT	TOP 1 CONTOMETRO_FINAL FROM	E_VENTA WHERE	CIA = '01' AND SEDE = '02' AND ID_IMPRESORA = @IMPRESORA AND CONVERT(VARCHAR(8),FECHA,112) = CONVERT(VARCHAR(8),@FECHA,112)ORDER BY HORA_FIN DESC),0))+ 1,
		(SELECT ISNULL((SELECT TOP 1 CONTOMETRO_FINAL FROM E_VENTA WHERE CIA = '01' AND SEDE = '02' AND ID_IMPRESORA = @IMPRESORA AND CONVERT(VARCHAR(8),FECHA,112) = CONVERT(VARCHAR(8),@FECHA,112)ORDER BY HORA_FIN DESC),0))+ @CANTIDAD, 
		@CANTIDAD, 8.90, ((@CANTIDAD * 8.90)- ((@CANTIDAD * 8.90) * 0.19)),0,((@CANTIDAD * 8.90)- ((@CANTIDAD * 8.90) * 0.19)), ((@CANTIDAD * 8.90) * 0.19), (@CANTIDAD * 8.90),
		'01', @RUC, @RUC, NULL,@PLACA,NULL,'01','1', NULL, NULL,NULL, NULL, @FECHA,
		@USUARIO, NULL,NULL,NULL,NULL,NULL,NULL, CONVERT(INT,(@CANTIDAD * 1)),NULL,NULL
FROM	E_MANGUERA
WHERE	CIA = '01' AND SEDE = '02' AND ID_MANGUERA = @MANGUERA
---------------------------------------------------
SET @NUM = (SELECT MAX(ID_VENTA) FROM E_VENTA WHERE CIA = '01' AND SEDE = '02')
SET @COUNT = (SELECT ISNULL((SELECT MAX(NRO_DOC) FROM E_VENTA_DOCUMENTO WHERE CIA = '01' AND SEDE = '02' AND SERIE_DOC = @SERIE),'0'))
SET	@NRO = (REPLICATE('0',(8 - LEN(CONVERT(INT,@COUNT) + 1))) + CONVERT(VARCHAR(8),CONVERT(INT,@COUNT + 1)))
---------------------------------------------------
INSERT INTO e_venta_documento
(
[CIA],[SEDE],[ID_VENTA],[ID_TIPO_DOC],[SERIE_DOC],[NRO_DOC],[RUC],[ID_CLIENTE],[FLAG_ANULA],[ID_ESTADO],[FLAG_ENVIO],[LOTE_ENVIO],
[SE],[FE],[UE],[FC],[UC]
)
VALUES
(
	'01', '02', @NUM, '07', @SERIE, @NRO, @RUC, @RUC, null,'01', '1', null,
	null, NULL, null, @HORA_INI, @USUARIO
)
GO
/****** Object:  StoredProcedure [dbo].[sp_modificar_tarjeta_cliente]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE [dbo].[sp_modificar_tarjeta_cliente]
@cia char(2),@idcli varchar(20),@id_articulo varchar(30),@item int,@nro_tarjeta varchar(20)
AS
UPDATE F_CLIENTE_TARJETA SET id_estado='02'
WHERE (cia=@cia) and (id_cliente=@idcli)

UPDATE F_CLIENTE_TARJETA SET nro_tarjeta=@nro_tarjeta,id_estado='01'
WHERE (cia=@cia) and (id_cliente=@idcli) and (item=@item) and (id_articulo=@id_articulo)
GO
/****** Object:  StoredProcedure [dbo].[SP_N_CORRELATIVO_CLI_V]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE [dbo].[SP_N_CORRELATIVO_CLI_V]
@CIA CHAR(2),
@ID_CLIENTE VARCHAR(20),
@PLACA VARCHAR(20),
@UC VARCHAR(20)
AS

DECLARE @NRO_DOC VARCHAR(20)
SET @NRO_DOC=(SELECT RIGHT('0000000'+CAST(RIGHT(MAX(NRO_DOC),8)+1 AS VARCHAR),8) FROM CLIENTE_VEHICULO)

INSERT INTO CLIENTE_VEHICULO (CIA,ID_TIPO_DOC,NRO_DOC,ID_CLIENTE,PLACA,ID_ESTADO,FLAG_ENVIO,FC,UC,FECHA,ID_CLIENTE_SERVICIO) 
VALUES (@CIA,'27',@NRO_DOC,@ID_CLIENTE,@PLACA,'01','1',GETDATE(),@UC,CONVERT(VARCHAR(10),GETDATE(),103),@ID_CLIENTE)

SELECT * FROM CLIENTE_VEHICULO WHERE NRO_DOC=@NRO_DOC
GO
/****** Object:  StoredProcedure [dbo].[SP_OCURRENCIA_MANTENIMIENTO]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
sp_help DOC_GESTION_FA

SP_LISTAR_MOTIVO_OCURRENCIA '01',''
	SELECT * FROM OCURRENCIA			select * from estado
	sp_help OCURRENCIA	
SP_OCURRENCIA_MANTENIMIENTO
'2','01','01',2,'FAE','00000010','01','20100111838','DDDDD','03','ADMIN','42476689','42953327','',''

SP_OCURRENCIA_MANTENIMIENTO	'3','01','01','1','','','','','','','','','','','',''
SP_OCURRENCIA_MANTENIMIENTO '4','01','01','','','','','','','','','','','','',''

SP_OCURRENCIA_MANTENIMIENTO
	'1','01','01','','FAE','00000010','01','20100111838','dddd','11','admin','42476689','44725392','','','26','0001'
SP_OCURRENCIA_MANTENIMIENTO
	'1','01','02','','FAE','00000009','02','20517103633','OCHO','11','admin','40870717','44725392','','','',''
*/
-----------------------------------------------
-----------------------------------------------
CREATE	PROC	[dbo].[SP_OCURRENCIA_MANTENIMIENTO]
@INDICADOR		CHAR(1),	@CIA		CHAR(2),	 @SEDE	CHAR(2),
@ID_OCURRENCIA	INT,		@ID_TIPO_DOC CHAR(2),	 @NRO_DOC	VARCHAR(20),
@ID_MOTIVO_OCURRENCIA	CHAR(2), 
@ID_ANALITICA	VARCHAR(20),@OBSERVACION	 VARCHAR(max),@ID_ESTADO	CHAR(2),	@UC	VARCHAR(25),
@ID_TECNICO_1 VARCHAR(20),@ID_TECNICO_2	VARCHAR(20),@ID_TECNICO_3 VARCHAR(20),@ID_TECNICO_4	VARCHAR(20),
@ID_TIPO_DOC_MO			CHAR(2),@SERIE_DOC				CHAR(4)
AS
------------------------------------------------------------------------------------------------------------------
DECLARE @VARMSG	VARCHAR(MAX),@COUNT	INT, @CODIGO INT,@NRO_DOC_MO varchar(20),@NRO_DOC_OC varchar(20),@ID_ESTADO_TDS	CHAR(2),
	@fechamax datetime ,@anio CHAR(4),@mes CHAR(2), @ID_ARTICULO VARCHAR(100), @ID_UNIDAD CHAR(2),@NRO_PARTE VARCHAR(100),
	@DESCRIPCION_ART VARCHAR(100), @TECNICO_2 VARCHAR(20), @TECNICO_3 VARCHAR(20), @TECNICO_4 VARCHAR(20),	@diames VARCHAR(6)
set @anio=year(getdate()) 
set @mes=month(getdate())
SET @diames='31-12-'
--SET @fechamax=  '31-12-'+@anio--'31-12-2010'
SET @fechamax =  @DIAMES+@anio
--PRINT  @fechamax
-----------------------------------------------------------------------------------------------------------------
	IF  LEN(@ID_TECNICO_2)>0 BEGIN 	SET  @TECNICO_2	=	@ID_TECNICO_2	END	ELSE	BEGIN   SET @TECNICO_2	=	NULL			END
	-----------------------------------------------------
	IF  LEN(@ID_TECNICO_3)>0 BEGIN 	SET  @TECNICO_3	=	@ID_TECNICO_3	END	ELSE	BEGIN   SET @TECNICO_3	=	NULL			END
	-----------------------------------------------------
	IF  LEN(@ID_TECNICO_4)>0 BEGIN	SET  @TECNICO_4	=	@ID_TECNICO_4	END	ELSE	BEGIN   SET @TECNICO_4	=	NULL			END	
	----------------------------------------------------------------------------------------------------------
	IF  LEN(@ID_TIPO_DOC_MO)>0 
			BEGIN	SET	@NRO_DOC_MO	=(SELECT ISNULL((SELECT	(REPLICATE('0',(8 - LEN(CORRELATIVO + 1))) + CONVERT(VARCHAR(8),(CORRELATIVO + 1)))
					FROM TIPO_DOCUMENTO_SERIE WHERE CIA=@CIA AND ID_TIPO_DOC=@ID_TIPO_DOC_MO AND SERIE=@SERIE_DOC AND ID_ESTADO='01'),'00000001'))	END	
	ELSE	BEGIN   SET @NRO_DOC_MO	=	''				END	
	-------------------------------------------------------
	--IF  LEN(@SERIE_DOC)>0 
	--		BEGIN	SET  @SERIE_DOC	=	@SERIE_DOC	END
	--ELSE	BEGIN   SET @SERIE_DOC	=	NULL			END	
	-----------------------------------------------------
	SET @ID_ARTICULO=(SELECT ID_ARTICULO FROM MOTIVO_OCURRENCIA WHERE CIA=@CIA AND ID_MOTIVO_OCURRENCIA=@ID_MOTIVO_OCURRENCIA )
	SET @DESCRIPCION_ART=(SELECT DESCRIPCION FROM ARTICULO WHERE CIA=@CIA AND ID_ARTICULO=@ID_ARTICULO )	
	SET @NRO_PARTE=(SELECT NRO_PARTE FROM ARTICULO WHERE CIA=@CIA AND ID_ARTICULO=@ID_ARTICULO )	
	SET @ID_UNIDAD=(SELECT ID_UNIDAD FROM ARTICULO WHERE CIA=@CIA AND ID_ARTICULO=@ID_ARTICULO )
	SET	@ID_ESTADO_TDS=(SELECT ISNULL((SELECT ID_ESTADO FROM TIPO_DOCUMENTO_SERIE WHERE ID_TIPO_DOC=@ID_TIPO_DOC ),0))
	-------------------------------------------------------------------------------------------------------------------------------------
	SET	@NRO_DOC_OC	=(SELECT NRO_DOC FROM DOC_GESTION_FA WHERE CIA=@CIA AND SEDE=@SEDE	AND ID_TIPO_DOC=@ID_TIPO_DOC_MO
						AND SERIE_doc=@SERIE_DOC	AND ID_OCURRENCIA	=@ID_OCURRENCIA	 )	
	-------------------------------------------------------------------------------------------------------------------------------------
	SET @CODIGO =( SELECT ISNULL ((SELECT max(ID_OCURRENCIA) FROM OCURRENCIA WHERE CIA=@CIA	 AND SEDE = @sede),0) )
					IF(@CODIGO > 0) BEGIN SET @CODIGO = @CODIGO + 1 END ELSE BEGIN SET @CODIGO = 1 END	
	-------------------------------------------------------------------------------------------------------------------
BEGIN TRANSACTION		
	-------------------------------------------------------------------------------------------------------------------------------------
IF (@INDICADOR = '1')
BEGIN	
	----------------------------------------------------------------------------------------------------------------------------	
	--PRINT  @ID_ARTICULO +'-'+@ID_TIPO_DOC_MO +'-'+@SERIE_DOC+'-'+ @NRO_DOC_MO+'-'+  @NRO_DOC_OC+'-'+@NRO_PARTE	+'-'+	@ID_UNIDAD 
	IF  LEN(ISNULL(@ID_ARTICULO,''))>0 
	BEGIN		
			INSERT	INTO DOC_GESTION_FA		/*		SELECT *  FROM dOC_GESTION_FA		*/
			(
			   CIA, SEDE,ID_TIPO_DOC,SERIE_DOC,NRO_DOC,ID_CLIENTE,ID_PUNTO_VENTA,ID_CONTACTO,ID_SALUDO,ID_DESPEDIDA,FECHA_DOCUMENTO,FECHA_VENCIMIENTO, 
			   SUBTOTAL,PORC_DSCTO,DESCUENTO,SUBTOTAL_CON_DSCTO,IMPUESTO,TOTAL,TOTAL_FINAL,OBSERVACION,REFERENCIA,   
			   ANIO,MES,ID_ESTADO,FLAG_ENVIO,SE,FC,UC,DES_SALUDO,DES_DESPEDIDA,ID_OCURRENCIA 
			)
			VALUES						/*	SP_HELP DOC_GESTION_FA		*/
			(
				@CIA,@SEDE,@ID_TIPO_DOC_MO,@SERIE_DOC,@NRO_DOC_MO,@ID_ANALITICA,'1',1,'100','200',GETDATE(),@fechamax,'','','','','','','','','',
				YEAR(GETDATE()), MONTH(GETDATE()),'11','1',@SEDE,GETDATE(),@UC,'','',@CODIGO
			)		
			--------------------------------------------------------------------------------------------------------------			
			INSERT	INTO DOC_GESTION_FA_DETALLE		/*		SELECT *  FROM DOC_GESTION_FA_DETALLE		*/
			(
				CIA,SEDE,ID_TIPO_DOC,SERIE_DOC,NRO_DOC,ITEM,ITEM_DIGITADO,ID_ARTICULO,CANTIDAD,
				--PRECIO,SUB_TOTAL,PORC_DSCTO,DESCUENTO,SUBTOTAL_CON_DSCTO,IMPUESTO,TOTAL,OTROS,TOTAL_FINAL,
				DES_ARTICULO,DES_LARGA_ARTICULO, ID_ESTADO,FLAG_ENVIO,SE,FC,UC,FORMA_ENTREGA,NRO_PARTE,MARCA,FECHA_ENTREGA,id_unidad  
			)
			VALUES						/*	SP_HELP DOC_GESTION_FA_DETALLE		*/
			(
				@CIA,@SEDE,@ID_TIPO_DOC_MO,@SERIE_DOC,@NRO_DOC_MO,1,1,@ID_ARTICULO,1,--	,,,,,,,,,
				@DESCRIPCION_ART,'','01','1',@SEDE,GETDATE(),@UC,'',@NRO_PARTE,'',@fechamax,@ID_UNIDAD		
			)								
			------------------------------------------------------------------------------------------------
			UPDATE	TIPO_DOCUMENTO_SERIE			/*		select * from TIPO_DOCUMENTO_SERIE */
				SET		CORRELATIVO			= CONVERT(INT, @NRO_DOC_MO)		
				WHERE	CIA					= @CIA 	
				AND		ID_TIPO_DOC			= @ID_TIPO_DOC_MO
				AND		SERIE				= @SERIE_DOC	
	END	
	-------------------------------------------------------------------------------------------------
	IF  LEN(ISNULL(@ID_TIPO_DOC_MO,''))>0 
	BEGIN	
		INSERT	INTO OCURRENCIA			/*	SELECT * FROM OCURRENCIA	*/
		(
			CIA,SEDE,ID_OCURRENCIA,ID_TIPO_DOC,NRO_DOC,ID_MOTIVO_OCURRENCIA,ID_ANALITICA,FECHA,OBSERVACION,USUARIO_RESPONSABLE,
			ID_TIPO_DOC_OP,SERIE_DOC_OP,NRO_DOC_OP,
			ID_ESTADO,FLAG_ENVIO, SE,FC,UC,ID_TECNICO_1,ID_TECNICO_2,ID_TECNICO_3,ID_TECNICO_4
		)
		VALUES			
		(
			@CIA,@SEDE,@CODIGO,'27',@NRO_DOC,@ID_MOTIVO_OCURRENCIA,@ID_ANALITICA,GETDATE(),@OBSERVACION,@UC,
			@ID_TIPO_DOC_MO,@SERIE_DOC,@NRO_DOC_MO,
			'11','1',@SEDE,GETDATE(),@UC,@ID_TECNICO_1,@TECNICO_2,@TECNICO_3,@TECNICO_4
		)
		------------------------------------------------------------------------------------------------
		IF  LEN(@NRO_DOC_MO)>0 
		BEGIN
			UPDATE	TIPO_DOCUMENTO_SERIE			/*		select * from TIPO_DOCUMENTO_SERIE */
				SET		CORRELATIVO			= CONVERT(INT, @NRO_DOC_MO)		
				WHERE	CIA					= @CIA 	
				AND		ID_TIPO_DOC			= @ID_TIPO_DOC_MO
				AND		SERIE				= @SERIE_DOC		
		END	
	END
	------------------------------------------------------------------------------------------------
	ELSE
	BEGIN
		INSERT	INTO OCURRENCIA			/*	SELECT * FROM OCURRENCIA	*/
		(
			CIA,SEDE,ID_OCURRENCIA,ID_TIPO_DOC,NRO_DOC,ID_MOTIVO_OCURRENCIA,ID_ANALITICA,FECHA,OBSERVACION,USUARIO_RESPONSABLE,
			
			ID_ESTADO,FLAG_ENVIO, SE,FC,UC,ID_TECNICO_1,ID_TECNICO_2,ID_TECNICO_3,ID_TECNICO_4
		)
		VALUES			
		(
			@CIA,@SEDE,@CODIGO,'27',@NRO_DOC,@ID_MOTIVO_OCURRENCIA,@ID_ANALITICA,GETDATE(),@OBSERVACION,@UC,			
			'11','1',@SEDE,GETDATE(),@UC,@ID_TECNICO_1,@TECNICO_2,@TECNICO_3,@TECNICO_4
		)
	END
----------------------------------------------------------------------------------------	
END
-----------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------


IF (@INDICADOR = '2')
BEGIN	
	UPDATE	OCURRENCIA			
		SET		ID_MOTIVO_OCURRENCIA	= @ID_MOTIVO_OCURRENCIA,
				ID_ANALITICA			= @ID_ANALITICA,
				OBSERVACION				= @OBSERVACION,
				ID_ESTADO				= @ID_ESTADO, 				
				FM						= getdate(), 
				UM						= @Uc,						
				ID_TECNICO_1			= @ID_TECNICO_1,
				ID_TECNICO_2			= @TECNICO_2,
				ID_TECNICO_3			= @TECNICO_3,
				ID_TECNICO_4			= @TECNICO_4
		WHERE	CIA						= @CIA 	
		AND		SEDE					= @SEDE
		AND		ID_OCURRENCIA			= @ID_OCURRENCIA	
		---------------------------------------------------------
		UPDATE	DOC_GESTION_FA			
		SET		ID_ESTADO			= @ID_ESTADO, 				
				FM					= getdate(), 
				UM					= @Uc				
		WHERE	CIA					= @CIA 	
		AND		SEDE				= @SEDE
		AND		ID_TIPO_DOC			= @ID_TIPO_DOC_MO
		AND		SERIE_DOC			= @SERIE_DOC		
		AND		NRO_DOC				= @NRO_DOC_OC	
		---------------------------------------------------------
		UPDATE	DOC_GESTION_FA_DETALLE			
		SET		ID_ESTADO			= @ID_ESTADO, 				
				FM					= getdate(), 
				UM					= @Uc				
		WHERE	CIA					= @CIA 	
		AND		SEDE				= @SEDE
		AND		ID_TIPO_DOC			= @ID_TIPO_DOC_MO
		AND		SERIE_DOC			= @SERIE_DOC		
		AND		NRO_DOC				= @NRO_DOC_OC	
END
-----------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------

IF (@INDICADOR = '3')
BEGIN
		UPDATE	OCURRENCIA			
		SET		ID_ESTADO			= '12', 				
				FE					= getdate(), 
				UE					= @Uc				
		WHERE	CIA					= @CIA 	
		AND		SEDE				= @SEDE
		AND		ID_OCURRENCIA		= @ID_OCURRENCIA			
		---------------------------------------------------------
		UPDATE	DOC_GESTION_FA			
		SET		ID_ESTADO			= '12', 				
				FE					= getdate(), 
				UE					= @Uc				
		WHERE	CIA					= @CIA 	
		AND		SEDE				= @SEDE
		AND		ID_TIPO_DOC		= @ID_TIPO_DOC_MO
		AND		SERIE_DOC		= @SERIE_DOC		
		AND		NRO_DOC			= @NRO_DOC_OC	
		---------------------------------------------------------
		UPDATE	DOC_GESTION_FA_DETALLE			
		SET		ID_ESTADO			= '12', 				
				FE					= getdate(), 
				UE					= @Uc				
		WHERE	CIA					= @CIA 	
		AND		SEDE				= @SEDE
		AND		ID_TIPO_DOC		= @ID_TIPO_DOC_MO
		AND		SERIE_DOC		= @SERIE_DOC		
		AND		NRO_DOC			= @NRO_DOC_OC	
END
-------------------------------------------------------------------------------------------
IF (@INDICADOR = '4')
BEGIN
	SET @CODIGO =( SELECT ISNULL ((SELECT max(ID_OCURRENCIA) FROM OCURRENCIA WHERE CIA=@CIA	 AND SEDE = @sede ),0) )
	IF(@CODIGO > 0) BEGIN SET @CODIGO = @CODIGO  END
	 ELSE BEGIN SET @CODIGO = 1 END
	SELECT @CODIGO
	--	SP_OCURRENCIA_MANTENIMIENTO '4','01','01','','','','','','','','','','','','',''
	--	SELECT  id_ocurrencia FROM OCURRENCIA	WHERE CIA=@CIA AND SEDE=@SEDE ORDER BY id_ocurrencia desc
END
-----------------------------------------------------------------------------------------------------
COMMIT TRANSACTION
------------------------------------------------
RETURN
MSGERROR:
		ROLLBACK TRANSACTION
		----------------------------------------
		RAISERROR	(@VARMSG, 15, 1)
		RETURN
GO
/****** Object:  StoredProcedure [dbo].[SP_OPER_V_ESTADO_CRONO]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE [dbo].[SP_OPER_V_ESTADO_CRONO]
@CIA CHAR(2),
@SEDE CHAR(2),
@CODIGO CHAR(8)
AS
SELECT id_estado FROM dbo.CRONOGRAMA_OPER
WHERE cia=@CIA AND sede=@SEDE AND  NRO_DOC=@CODIGO
GO
/****** Object:  StoredProcedure [dbo].[SP_OPERACIONES_HORARIO_HT]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--set nocount on



-- SP_OPERACIONES_HORARIO_HT '01','01','15-11-2010','30-11-2010','',''

CREATE PROCEDURE [dbo].[SP_OPERACIONES_HORARIO_HT]
@CIA CHAR(2),@SEDE CHAR(2),@DESDE DATETIME,@HASTA DATETIME,@TECNICO VARCHAR(20),@HORA int
AS
------------------------------------------------------------------------
DECLARE @FECHAI DATETIME,@FECHAF DATETIME
SET @FECHAI=CONVERT(VARCHAR(10),@DESDE,103)
SET @FECHAF=CONVERT(VARCHAR(10),@HASTA,103)
------------------------------------------------------------------------
--// definimos variables y estructuras
declare @in_row   int,@in_allrow int,@in_hra1  int,@in_hra24 int,@ch_tecnico char(8),@ch_tecnico_des varchar(200),
		@ch_nro_doc char(500),@dt_fecha DATETIME,@dt_fecha2 DATETIME,
		@in_rowt   int,@in_allrowt int,@in_hra1t  int,@in_hra3t int,@ch_tecnicot char(8),@ch_tecnico_dest varchar(200),
		@ch_nro_doct char(500),@dt_fechat DATETIME,@dt_fecha2t DATETIME

declare @TT_TECNICO table (secc int identity, id_tecnico char(8),des_tec VARCHAR(200))

declare @TT_TA table (secc int identity, id_tecnico char(8),des_tec VARCHAR(200),  nro_doc char(500),  fecha datetime,  fecha2 DATETIME,
						tec1 varchar(20),tec2 varchar(20),tec3 varchar(20))

declare @TT_TAREAS table (secc int identity, id_tecnico char(8),des_tec VARCHAR(200),  nro_doc char(500),  fecha datetime,  fecha2 DATETIME)

declare @TT_DATOS table (hora_n int, hora char(14), id_tecnico char(8),des_tec VARCHAR(200),
			lun varchar(500), mar varchar(500), 
			mie varchar(500), jue varchar(500), 
			vie varchar(500), sab varchar(500), 
			dom varchar(500))

---------------------------------------------------------------------------------------------------------------------------	
--// Cargamos estructura de tareas
insert @TT_TAREAS (id_tecnico,des_tec, nro_doc, fecha, fecha2)
select CO.id_tecnico,A2.DESCRIPCION, CO.nro_doc+' - '+A.DESCRIPCION, CO.fecha_inicio, CO.fecha_fin from CRONOGRAMA_OPER CO
		INNER JOIN dbo.ANALITICA A ON CO.CIA = A.CIA AND CO.ID_CLIENTE = A.ID_ANALITICA 
		LEFT JOIN ANALITICA A2 ON CO.CIA = A2.CIA AND CO.ID_TECNICO = A2.ID_ANALITICA
		INNER JOIN ANALITICA_TIPO AT ON at.cia=A2.cia AND at.id_analitica=A2.id_analitica 
		INNER JOIN TIPO_ANALITICA TA ON ta.cia=at.cia AND ta.id_tipo_analitica=at.id_tipo_analitica
		WHERE (CO.CIA=@CIA) AND (CO.SEDE=@SEDE) AND 
		(TA.ID_TIPO_ANALITICA='08') AND (CO.ID_ESTADO!='12') AND 
		(
		(CONVERT(VARCHAR(8),CO.FECHA_INICIO,112) BETWEEN 
		CONVERT(VARCHAR(10),(DATEADD(wk, DATEDIFF(wk,0,@FECHAI), 0)),112) AND
		CONVERT(VARCHAR(10),(DATEADD(wk, DATEDIFF(wk,5,@FECHAF), 5)+1),112)) OR 
		(CONVERT(VARCHAR(8),CO.FECHA_FIN,112) BETWEEN 
		CONVERT(VARCHAR(10),(DATEADD(wk, DATEDIFF(wk,0,@FECHAI), 0)),112) AND
		CONVERT(VARCHAR(10),(DATEADD(wk, DATEDIFF(wk,5,@FECHAF), 5)+1),112))
		)
		GROUP BY CO.id_tecnico,A2.DESCRIPCION, CO.nro_doc,A.DESCRIPCION, CO.fecha_inicio, CO.fecha_fin
		ORDER BY A2.DESCRIPCION


insert @TT_TA (id_tecnico,des_tec, nro_doc, fecha, fecha2,tec1,tec2,tec3)
select CO.id_tecnico,A2.DESCRIPCION, CO.nro_doc+' - '+A.DESCRIPCION, CO.fecha_inicio, CO.fecha_fin, 
		CO.ID_TECNICO_2,CO.ID_TECNICO_3,CO.ID_TECNICO_4
		from CRONOGRAMA_OPER CO
		INNER JOIN dbo.ANALITICA A ON CO.CIA = A.CIA AND CO.ID_CLIENTE = A.ID_ANALITICA 
		LEFT JOIN ANALITICA A2 ON CO.CIA = A2.CIA AND CO.ID_TECNICO = A2.ID_ANALITICA
		INNER JOIN ANALITICA_TIPO AT ON at.cia=A2.cia AND at.id_analitica=A2.id_analitica 
		INNER JOIN TIPO_ANALITICA TA ON ta.cia=at.cia AND ta.id_tipo_analitica=at.id_tipo_analitica
		WHERE (CO.CIA=@CIA) AND (CO.SEDE=@SEDE) AND 
		(TA.ID_TIPO_ANALITICA='08') AND (CO.ID_ESTADO!='12') AND 
		(
		(CONVERT(VARCHAR(8),CO.FECHA_INICIO,112) BETWEEN 
		CONVERT(VARCHAR(10),(DATEADD(wk, DATEDIFF(wk,0,@FECHAI), 0)),112) AND
		CONVERT(VARCHAR(10),(DATEADD(wk, DATEDIFF(wk,5,@FECHAF), 5)+1),112)) OR 
		(CONVERT(VARCHAR(8),CO.FECHA_FIN,112) BETWEEN 
		CONVERT(VARCHAR(10),(DATEADD(wk, DATEDIFF(wk,0,@FECHAI), 0)),112) AND
		CONVERT(VARCHAR(10),(DATEADD(wk, DATEDIFF(wk,5,@FECHAF), 5)+1),112))
		)
		GROUP BY CO.id_tecnico,A2.DESCRIPCION, CO.nro_doc,A.DESCRIPCION, CO.fecha_inicio, CO.fecha_fin, CO.ID_TECNICO_2,CO.ID_TECNICO_3,CO.ID_TECNICO_4
		ORDER BY A2.DESCRIPCION



select @in_rowt = 1, @in_allrowt = @@rowcount
while @in_rowt <= @in_allrowt begin
	select @ch_nro_doct = nro_doc from @TT_TA where secc = @in_rowt
	select @dt_fechat = fecha from @TT_TA where secc = @in_rowt
	select @dt_fecha2t = fecha2 from @TT_TA where secc = @in_rowt
	select @in_hra1t = 1, @in_hra3t = 3 
	------------------------------------------------------------------------------
		select @ch_tecnicot = tec1 from @TT_TA where secc = @in_rowt
			if @ch_tecnicot !='' begin
				select @ch_tecnico_dest = (select descripcion from analitica where id_analitica=@ch_tecnicot and cia=@CIA)
				insert @TT_TAREAS (id_tecnico,des_tec, nro_doc, fecha, fecha2)
					values (@ch_tecnicot,@ch_tecnico_dest,@ch_nro_doct,@dt_fechat,@dt_fecha2t)
			end
	------------------------------------------------------------------------------			
		select @ch_tecnicot = tec2 from @TT_TA where secc = @in_rowt
			if @ch_tecnicot !='' begin
				select @ch_tecnico_dest = (select descripcion from analitica where id_analitica=@ch_tecnicot and cia=@CIA)
				insert @TT_TAREAS (id_tecnico,des_tec, nro_doc, fecha, fecha2)
					values (@ch_tecnicot,@ch_tecnico_dest,@ch_nro_doct,@dt_fechat,@dt_fecha2t)
			end
	------------------------------------------------------------------------------
		select @ch_tecnicot = tec3 from @TT_TA where secc = @in_rowt
			if @ch_tecnicot !='' begin
				select @ch_tecnico_dest = (select descripcion from analitica where id_analitica=@ch_tecnicot and cia=@CIA)
				insert @TT_TAREAS (id_tecnico,des_tec, nro_doc, fecha, fecha2)
					values (@ch_tecnicot,@ch_tecnico_dest,@ch_nro_doct,@dt_fechat,@dt_fecha2t)
			end
	------------------------------------------------------------------------------
	set @in_rowt = @in_rowt + 1
end
---------------------------------------------------------------------------------------------------------------------------	
--// Cargamos estructura del calendario
insert @TT_TECNICO (id_tecnico,des_tec)
--select distinct id_tecnico,des_tec from @TT_TAREAS
select A2.ID_ANALITICA,A2.DESCRIPCION
from ANALITICA A2
LEFT JOIN CRONOGRAMA_OPER CO ON CO.CIA = A2.CIA AND CO.ID_TECNICO = A2.ID_ANALITICA
INNER JOIN ANALITICA_TIPO AT ON at.cia=A2.cia AND at.id_analitica=A2.id_analitica 
INNER JOIN TIPO_ANALITICA TA ON ta.cia=at.cia AND ta.id_tipo_analitica=at.id_tipo_analitica
WHERE A2.CIA=@CIA AND TA.ID_TIPO_ANALITICA='08' AND A2.ID_ESTADO='01' AND (A2.ID_ANALITICA LIKE @TECNICO+'%')
GROUP BY A2.ID_ANALITICA,A2.DESCRIPCION
ORDER BY A2.DESCRIPCION


select @in_hra1 = 1, @in_hra24 = 24 
while @in_hra1 <= @in_hra24 begin
	select @in_row = 1
	select @in_allrow = (SELECT COUNT(A2.ID_ANALITICA) FROM ANALITICA  A2
						INNER JOIN ANALITICA_TIPO AT ON at.cia=A2.cia AND at.id_analitica=A2.id_analitica 
						INNER JOIN TIPO_ANALITICA TA ON ta.cia=at.cia AND ta.id_tipo_analitica=at.id_tipo_analitica
						WHERE TA.ID_TIPO_ANALITICA='08' AND A2.ID_ESTADO='01' AND A2.ID_ANALITICA LIKE @TECNICO+'%')
		while @in_row <= @in_allrow begin
			select @ch_tecnico = id_tecnico from @TT_TECNICO where secc = @in_row
			select @ch_tecnico_des = des_tec from @TT_TECNICO where secc = @in_row
			
			insert @TT_DATOS (id_tecnico,des_tec, hora_n, hora)
			select @ch_tecnico,@ch_tecnico_des, @in_hra1, right('0' + cast((@in_hra1-1) as varchar), 2) + ':00 - '+right('0' + cast((@in_hra1) as varchar), 2) + ':00'
			
			set @in_row = @in_row + 1
		end
		
	set @in_hra1 = @in_hra1 + 1
end

--// 
select @in_row = 1, @in_allrow = count(*) from @TT_TAREAS

while @in_row <= @in_allrow  begin
	select @ch_tecnico = id_tecnico,@ch_tecnico_des=des_tec, @ch_nro_doc = nro_doc, @dt_fecha = fecha, @dt_fecha2 = fecha2
	 from @TT_TAREAS
	 where secc = @in_row
	
	---------------------------------------------------------------------------------------------------------------------------------------	
	if  (CONVERT(VARCHAR(8),(DATEADD(wk, DATEDIFF(wk,0,@DESDE), 0)),112) between CONVERT(VARCHAR(8),@dt_fecha,112) and CONVERT(VARCHAR(8),@dt_fecha2,112))			
		if (datepart(HH, @dt_fecha2)<datepart(HH, @dt_fecha)) begin
			if(datepart(DW, @dt_fecha)='1') begin
			update @TT_DATOS set lun = @ch_nro_doc where (hora_n between datepart(HH, @dt_fecha)+1 AND '24') AND  id_tecnico = @ch_tecnico
			end
			else if (datepart(DW, @dt_fecha2)='1') begin 
				update @TT_DATOS set lun = @ch_nro_doc where (hora_n between '1' and datepart(HH, @dt_fecha2)+1) AND  id_tecnico = @ch_tecnico
			end
			else begin 
				update @TT_DATOS set lun = @ch_nro_doc where (hora_n between datepart(HH, @dt_fecha)+1 AND '24') AND  id_tecnico = @ch_tecnico
				update @TT_DATOS set lun = @ch_nro_doc where (hora_n between '1' and datepart(HH, @dt_fecha2)+1) AND  id_tecnico = @ch_tecnico
			end
		end
		else
		begin
		update @TT_DATOS set lun = @ch_nro_doc where (hora_n between datepart(HH, @dt_fecha)+1 AND datepart(HH, @dt_fecha2)) AND  id_tecnico = @ch_tecnico
		end
		
	---------------------------------------------------------------------------------------------------------------------------------------
	if  (CONVERT(VARCHAR(8),(DATEADD(wk, DATEDIFF(wk,1,@DESDE), 1)),112) between CONVERT(VARCHAR(8),@dt_fecha,112) and CONVERT(VARCHAR(8),@dt_fecha2,112))			
		if (datepart(HH, @dt_fecha2)<datepart(HH, @dt_fecha)) begin
			if(datepart(DW, @dt_fecha)='2') begin
			update @TT_DATOS set mar = @ch_nro_doc where (hora_n between datepart(HH, @dt_fecha)+1 AND '24') AND  id_tecnico = @ch_tecnico
			end
			else if (datepart(DW, @dt_fecha2)='2') begin 
				update @TT_DATOS set mar = @ch_nro_doc where (hora_n between '1' and datepart(HH, @dt_fecha2)+1) AND  id_tecnico = @ch_tecnico
			end
			else begin 
				update @TT_DATOS set mar = @ch_nro_doc where (hora_n between datepart(HH, @dt_fecha)+1 AND '24') AND  id_tecnico = @ch_tecnico
				update @TT_DATOS set mar = @ch_nro_doc where (hora_n between '1' and datepart(HH, @dt_fecha2)+1) AND  id_tecnico = @ch_tecnico
			end
		end
		else
		begin
		update @TT_DATOS set mar = @ch_nro_doc where (hora_n between datepart(HH, @dt_fecha)+1 AND datepart(HH, @dt_fecha2)) AND  id_tecnico = @ch_tecnico
		end
		
	---------------------------------------------------------------------------------------------------------------------------------------
	if  (CONVERT(VARCHAR(8),(DATEADD(wk, DATEDIFF(wk,2,@DESDE), 2)),112) between CONVERT(VARCHAR(8),@dt_fecha,112) and CONVERT(VARCHAR(8),@dt_fecha2,112))			
		if (datepart(HH, @dt_fecha2)<datepart(HH, @dt_fecha)) begin
			if(datepart(DW, @dt_fecha)='3') begin
			update @TT_DATOS set mie = @ch_nro_doc where (hora_n between datepart(HH, @dt_fecha)+1 AND '24') AND  id_tecnico = @ch_tecnico
			end
			else if (datepart(DW, @dt_fecha2)='3') begin 
				update @TT_DATOS set mie = @ch_nro_doc where (hora_n between '1' and datepart(HH, @dt_fecha2)+1) AND  id_tecnico = @ch_tecnico
			end
			else begin 
				update @TT_DATOS set mie = @ch_nro_doc where (hora_n between datepart(HH, @dt_fecha)+1 AND '24') AND  id_tecnico = @ch_tecnico
				update @TT_DATOS set mie = @ch_nro_doc where (hora_n between '1' and datepart(HH, @dt_fecha2)+1) AND  id_tecnico = @ch_tecnico
			end
		end
		else
		begin
		update @TT_DATOS set mie = @ch_nro_doc where (hora_n between datepart(HH, @dt_fecha)+1 AND datepart(HH, @dt_fecha2)) AND  id_tecnico = @ch_tecnico
		end
		
	---------------------------------------------------------------------------------------------------------------------------------------
	if  (CONVERT(VARCHAR(8),(DATEADD(wk, DATEDIFF(wk,3,@DESDE), 3)),112) between CONVERT(VARCHAR(8),@dt_fecha,112) and CONVERT(VARCHAR(8),@dt_fecha2,112))			
		if (datepart(HH, @dt_fecha2)<datepart(HH, @dt_fecha)) begin
			if(datepart(DW, @dt_fecha)='4') begin
			update @TT_DATOS set jue = @ch_nro_doc where (hora_n between datepart(HH, @dt_fecha)+1 AND '24') AND  id_tecnico = @ch_tecnico
			end
			else if (datepart(DW, @dt_fecha2)='4') begin 
				update @TT_DATOS set jue = @ch_nro_doc where (hora_n between '1' and datepart(HH, @dt_fecha2)+1) AND  id_tecnico = @ch_tecnico
			end
			else begin 
				update @TT_DATOS set jue = @ch_nro_doc where (hora_n between datepart(HH, @dt_fecha)+1 AND '24') AND  id_tecnico = @ch_tecnico
				update @TT_DATOS set jue = @ch_nro_doc where (hora_n between '1' and datepart(HH, @dt_fecha2)+1) AND  id_tecnico = @ch_tecnico
			end
		end
		else
		begin
		update @TT_DATOS set jue = @ch_nro_doc where (hora_n between datepart(HH, @dt_fecha)+1 AND datepart(HH, @dt_fecha2)) AND  id_tecnico = @ch_tecnico
		end
		
	---------------------------------------------------------------------------------------------------------------------------------------
	if  (CONVERT(VARCHAR(8),(DATEADD(wk, DATEDIFF(wk,4,@DESDE), 4)),112) between CONVERT(VARCHAR(8),@dt_fecha,112) and CONVERT(VARCHAR(8),@dt_fecha2,112))			
		if (datepart(HH, @dt_fecha2)<datepart(HH, @dt_fecha)) begin
			if(datepart(DW, @dt_fecha)='5') begin
			update @TT_DATOS set vie = @ch_nro_doc where (hora_n between datepart(HH, @dt_fecha)+1 AND '24') AND  id_tecnico = @ch_tecnico
			end
			else if (datepart(DW, @dt_fecha2)='5') begin 
				update @TT_DATOS set vie = @ch_nro_doc where (hora_n between '1' and datepart(HH, @dt_fecha2)+1) AND  id_tecnico = @ch_tecnico
			end
			else begin 
				update @TT_DATOS set vie = @ch_nro_doc where (hora_n between datepart(HH, @dt_fecha)+1 AND '24') AND  id_tecnico = @ch_tecnico
				update @TT_DATOS set vie = @ch_nro_doc where (hora_n between '1' and datepart(HH, @dt_fecha2)+1) AND  id_tecnico = @ch_tecnico
			end
		end
		else
		begin
		update @TT_DATOS set vie = @ch_nro_doc where (hora_n between datepart(HH, @dt_fecha)+1 AND datepart(HH, @dt_fecha2)) AND  id_tecnico = @ch_tecnico
		end
		
	---------------------------------------------------------------------------------------------------------------------------------------
	if  (CONVERT(VARCHAR(8),(DATEADD(wk, DATEDIFF(wk,5,@DESDE), 5)),112) between CONVERT(VARCHAR(8),@dt_fecha,112) and CONVERT(VARCHAR(8),@dt_fecha2,112))			
		if (datepart(HH, @dt_fecha2)<datepart(HH, @dt_fecha)) begin
			if(datepart(DW, @dt_fecha)='6') begin
			update @TT_DATOS set sab = @ch_nro_doc where (hora_n between datepart(HH, @dt_fecha)+1 AND '24') AND  id_tecnico = @ch_tecnico
			end
			else if (datepart(DW, @dt_fecha2)='6') begin 
				update @TT_DATOS set sab = @ch_nro_doc where (hora_n between '1' and datepart(HH, @dt_fecha2)+1) AND  id_tecnico = @ch_tecnico
			end
			else begin 
				update @TT_DATOS set sab = @ch_nro_doc where (hora_n between datepart(HH, @dt_fecha)+1 AND '24') AND  id_tecnico = @ch_tecnico
				update @TT_DATOS set sab = @ch_nro_doc where (hora_n between '1' and datepart(HH, @dt_fecha2)+1) AND  id_tecnico = @ch_tecnico
			end
		end
		else
		begin
		update @TT_DATOS set sab = @ch_nro_doc where (hora_n between datepart(HH, @dt_fecha)+1 AND datepart(HH, @dt_fecha2)) AND  id_tecnico = @ch_tecnico
		end
		
	---------------------------------------------------------------------------------------------------------------------------------------
	if  (CONVERT(VARCHAR(8),(DATEADD(wk, DATEDIFF(wk,5,@DESDE), 5)+1),112) between CONVERT(VARCHAR(8),@dt_fecha,112) and CONVERT(VARCHAR(8),@dt_fecha2,112))			
		if (datepart(HH, @dt_fecha2)<datepart(HH, @dt_fecha)) begin
			if(datepart(DW, @dt_fecha)='7') begin
			update @TT_DATOS set dom = @ch_nro_doc where (hora_n between datepart(HH, @dt_fecha)+1 AND '24') AND  id_tecnico = @ch_tecnico
			end
			else if (datepart(DW, @dt_fecha2)='7') begin 
				update @TT_DATOS set dom = @ch_nro_doc where (hora_n between '1' and datepart(HH, @dt_fecha2)+1) AND  id_tecnico = @ch_tecnico
			end
			else begin 
				update @TT_DATOS set dom = @ch_nro_doc where (hora_n between datepart(HH, @dt_fecha)+1 AND '24') AND  id_tecnico = @ch_tecnico
				update @TT_DATOS set dom = @ch_nro_doc where (hora_n between '1' and datepart(HH, @dt_fecha2)+1) AND  id_tecnico = @ch_tecnico
			end
		end
		else
		begin
		update @TT_DATOS set dom = @ch_nro_doc where (hora_n between datepart(HH, @dt_fecha)+1 AND datepart(HH, @dt_fecha2)) AND  id_tecnico = @ch_tecnico
		end
		
	---------------------------------------------------------------------------------------------------------------------------------------
	set @in_row = @in_row +1
end

--select id_tecnico,des_tec, nro_doc, fecha, fecha2 from @TT_TAREAS 


--// presentamos los datos
IF @HORA>0 
BEGIN 
SELECT hora,id_tecnico, des_tec, lun, mar, mie, jue, vie, sab, dom  from @TT_DATOS WHERE hora_n=@HORA
END 
ELSE 
BEGIN 
SELECT hora,id_tecnico, des_tec, lun, mar, mie, jue, vie, sab, dom  from @TT_DATOS 
END


-- SP_OPERACIONES_HORARIO_HT '01','01','15-11-2010','30-11-2010','',''
GO
/****** Object:  StoredProcedure [dbo].[SP_OPERACIONES_HORARIO_TH]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--set nocount on

--select * from cronograma_oper

--select * from cronograma_oper_detalle

-- SP_OPERACIONES_HORARIO_TH '01','01','15/11/2010','30/11/2010',''

CREATE PROCEDURE [dbo].[SP_OPERACIONES_HORARIO_TH]
@CIA CHAR(2),@SEDE CHAR(2),@DESDE DATETIME,@HASTA DATETIME,@TECNICO VARCHAR(20)
AS
------------------------------------------------------------------------
DECLARE @FECHAI DATETIME,@FECHAF DATETIME
SET @FECHAI=CONVERT(VARCHAR(10),@DESDE,103)
SET @FECHAF=CONVERT(VARCHAR(10),@HASTA,103)
------------------------------------------------------------------------
--// definimos variables y estructuras
declare @in_row   int,@in_allrow int,@in_hra1  int,@in_hra24 int,@ch_tecnico char(8),@ch_tecnico_des varchar(200),
		@ch_nro_doc char(500),@dt_fecha DATETIME,@dt_fecha2 DATETIME,
		@in_rowt   int,@in_allrowt int,@in_hra1t  int,@in_hra3t int,@ch_tecnicot char(8),@ch_tecnico_dest varchar(200),
		@ch_nro_doct char(500),@dt_fechat DATETIME,@dt_fecha2t DATETIME

declare @TT_TECNICO table (secc int identity, id_tecnico char(8),des_tec VARCHAR(200))

declare @TT_TA table (secc int identity, id_tecnico char(8),des_tec VARCHAR(200),  nro_doc char(500),  fecha datetime,  fecha2 DATETIME,
						tec1 varchar(20),tec2 varchar(20),tec3 varchar(20))

declare @TT_TAREAS table (secc int identity, id_tecnico char(8),des_tec VARCHAR(200),  nro_doc char(500),  fecha datetime,  fecha2 DATETIME)

declare @TT_DATOS table (id_tecnico char(8),des_tec VARCHAR(200),
			hora_n int, hora char(14), 
			lun varchar(500), mar varchar(500), 
			mie varchar(500), jue varchar(500), 
			vie varchar(500), sab varchar(500), 
			dom varchar(500))
---------------------------------------------------------------------------------------------------------------------------	
--// Cargamos estructura de tareas
insert @TT_TAREAS (id_tecnico,des_tec, nro_doc, fecha, fecha2)
select CO.id_tecnico,A2.DESCRIPCION, CO.nro_doc+' - '+A.DESCRIPCION, CO.fecha_inicio, CO.fecha_fin from CRONOGRAMA_OPER CO
		INNER JOIN dbo.ANALITICA A ON CO.CIA = A.CIA AND CO.ID_CLIENTE = A.ID_ANALITICA 
		LEFT JOIN ANALITICA A2 ON CO.CIA = A2.CIA AND CO.ID_TECNICO = A2.ID_ANALITICA
		INNER JOIN ANALITICA_TIPO AT ON at.cia=A2.cia AND at.id_analitica=A2.id_analitica 
		INNER JOIN TIPO_ANALITICA TA ON ta.cia=at.cia AND ta.id_tipo_analitica=at.id_tipo_analitica
		WHERE (CO.CIA=@CIA) AND (CO.SEDE=@SEDE) AND 
		(TA.ID_TIPO_ANALITICA='08') AND (CO.ID_ESTADO!='12') AND 
		(
		(CONVERT(VARCHAR(8),CO.FECHA_INICIO,112) BETWEEN 
		CONVERT(VARCHAR(10),(DATEADD(wk, DATEDIFF(wk,0,@FECHAI), 0)),112) AND
		CONVERT(VARCHAR(10),(DATEADD(wk, DATEDIFF(wk,5,@FECHAF), 5)+1),112)) OR 
		(CONVERT(VARCHAR(8),CO.FECHA_FIN,112) BETWEEN 
		CONVERT(VARCHAR(10),(DATEADD(wk, DATEDIFF(wk,0,@FECHAI), 0)),112) AND
		CONVERT(VARCHAR(10),(DATEADD(wk, DATEDIFF(wk,5,@FECHAF), 5)+1),112))
		)
		GROUP BY CO.id_tecnico,A2.DESCRIPCION, CO.nro_doc,A.DESCRIPCION, CO.fecha_inicio, CO.fecha_fin
		ORDER BY A2.DESCRIPCION



insert @TT_TA (id_tecnico,des_tec, nro_doc, fecha, fecha2,tec1,tec2,tec3)
select CO.id_tecnico,A2.DESCRIPCION, CO.nro_doc+' - '+A.DESCRIPCION, CO.fecha_inicio, CO.fecha_fin, 
		CO.ID_TECNICO_2,CO.ID_TECNICO_3,CO.ID_TECNICO_4
		from CRONOGRAMA_OPER CO
		INNER JOIN dbo.ANALITICA A ON CO.CIA = A.CIA AND CO.ID_CLIENTE = A.ID_ANALITICA 
		LEFT JOIN ANALITICA A2 ON CO.CIA = A2.CIA AND CO.ID_TECNICO = A2.ID_ANALITICA
		INNER JOIN ANALITICA_TIPO AT ON at.cia=A2.cia AND at.id_analitica=A2.id_analitica 
		INNER JOIN TIPO_ANALITICA TA ON ta.cia=at.cia AND ta.id_tipo_analitica=at.id_tipo_analitica
		WHERE (CO.CIA=@CIA) AND (CO.SEDE=@SEDE) AND 
		(TA.ID_TIPO_ANALITICA='08') AND (CO.ID_ESTADO!='12') AND 
		(
		(CONVERT(VARCHAR(8),CO.FECHA_INICIO,112) BETWEEN 
		CONVERT(VARCHAR(10),(DATEADD(wk, DATEDIFF(wk,0,@FECHAI), 0)),112) AND
		CONVERT(VARCHAR(10),(DATEADD(wk, DATEDIFF(wk,5,@FECHAF), 5)+1),112)) OR 
		(CONVERT(VARCHAR(8),CO.FECHA_FIN,112) BETWEEN 
		CONVERT(VARCHAR(10),(DATEADD(wk, DATEDIFF(wk,0,@FECHAI), 0)),112) AND
		CONVERT(VARCHAR(10),(DATEADD(wk, DATEDIFF(wk,5,@FECHAF), 5)+1),112))
		)
		GROUP BY CO.id_tecnico,A2.DESCRIPCION, CO.nro_doc,A.DESCRIPCION, CO.fecha_inicio, CO.fecha_fin, CO.ID_TECNICO_2,CO.ID_TECNICO_3,CO.ID_TECNICO_4
		ORDER BY A2.DESCRIPCION



select @in_rowt = 1, @in_allrowt = @@rowcount
while @in_rowt <= @in_allrowt begin
	select @ch_nro_doct = nro_doc from @TT_TA where secc = @in_rowt
	select @dt_fechat = fecha from @TT_TA where secc = @in_rowt
	select @dt_fecha2t = fecha2 from @TT_TA where secc = @in_rowt
	select @in_hra1t = 1, @in_hra3t = 3 
	------------------------------------------------------------------------------
		select @ch_tecnicot = tec1 from @TT_TA where secc = @in_rowt
			if @ch_tecnicot !='' begin
				select @ch_tecnico_dest = (select descripcion from analitica where id_analitica=@ch_tecnicot and cia=@CIA)
				insert @TT_TAREAS (id_tecnico,des_tec, nro_doc, fecha, fecha2)
					values (@ch_tecnicot,@ch_tecnico_dest,@ch_nro_doct,@dt_fechat,@dt_fecha2t)
			end
	------------------------------------------------------------------------------			
		select @ch_tecnicot = tec2 from @TT_TA where secc = @in_rowt
			if @ch_tecnicot !='' begin
				select @ch_tecnico_dest = (select descripcion from analitica where id_analitica=@ch_tecnicot and cia=@CIA)
				insert @TT_TAREAS (id_tecnico,des_tec, nro_doc, fecha, fecha2)
					values (@ch_tecnicot,@ch_tecnico_dest,@ch_nro_doct,@dt_fechat,@dt_fecha2t)
			end
	------------------------------------------------------------------------------
		select @ch_tecnicot = tec3 from @TT_TA where secc = @in_rowt
			if @ch_tecnicot !='' begin
				select @ch_tecnico_dest = (select descripcion from analitica where id_analitica=@ch_tecnicot and cia=@CIA)
				insert @TT_TAREAS (id_tecnico,des_tec, nro_doc, fecha, fecha2)
					values (@ch_tecnicot,@ch_tecnico_dest,@ch_nro_doct,@dt_fechat,@dt_fecha2t)
			end
	------------------------------------------------------------------------------
	set @in_rowt = @in_rowt + 1
end
---------------------------------------------------------------------------------------------------------------------------		
--// Cargamos estructura del calendario
insert @TT_TECNICO (id_tecnico,des_tec)
--select distinct id_tecnico,des_tec from @TT_TAREAS
select A2.ID_ANALITICA,A2.DESCRIPCION
from ANALITICA A2
LEFT JOIN CRONOGRAMA_OPER CO ON CO.CIA = A2.CIA AND CO.ID_TECNICO = A2.ID_ANALITICA
INNER JOIN ANALITICA_TIPO AT ON at.cia=A2.cia AND at.id_analitica=A2.id_analitica 
INNER JOIN TIPO_ANALITICA TA ON ta.cia=at.cia AND ta.id_tipo_analitica=at.id_tipo_analitica
WHERE A2.CIA=@CIA AND TA.ID_TIPO_ANALITICA='08' AND A2.ID_ESTADO='01' AND (A2.ID_ANALITICA LIKE @TECNICO+'%')
GROUP BY A2.ID_ANALITICA,A2.DESCRIPCION

 

select @in_row = 1, @in_allrow = @@rowcount

while @in_row <= @in_allrow begin
	select @ch_tecnico = id_tecnico from @TT_TECNICO where secc = @in_row
	select @ch_tecnico_des = des_tec from @TT_TECNICO where secc = @in_row
	select @in_hra1 = 1, @in_hra24 = 24 
	
	while @in_hra1 <= @in_hra24 begin
		insert @TT_DATOS (id_tecnico,des_tec, hora_n, hora)
		select @ch_tecnico,@ch_tecnico_des, @in_hra1, right('0' + cast((@in_hra1-1) as varchar), 2) + ':00 - '+right('0' + cast((@in_hra1) as varchar), 2) + ':00'
		set @in_hra1 = @in_hra1 + 1
	end
	
	set @in_row = @in_row + 1
end


--// 
select @in_row = 1, @in_allrow = count(*) from @TT_TAREAS

while @in_row <= @in_allrow  begin
	select @ch_tecnico = id_tecnico,@ch_tecnico_des=des_tec, @ch_nro_doc = nro_doc, @dt_fecha = fecha, @dt_fecha2 = fecha2
	 from @TT_TAREAS
	 where secc = @in_row
		
	---------------------------------------------------------------------------------------------------------------------------------------	
	if  (CONVERT(VARCHAR(8),(DATEADD(wk, DATEDIFF(wk,0,@DESDE), 0)),112) between CONVERT(VARCHAR(8),@dt_fecha,112) and CONVERT(VARCHAR(8),@dt_fecha2,112))			
		if (datepart(HH, @dt_fecha2)<datepart(HH, @dt_fecha)) begin
			if(datepart(DW, @dt_fecha)='1') begin
			update @TT_DATOS set lun = @ch_nro_doc where (hora_n between datepart(HH, @dt_fecha)+1 AND '24') AND  id_tecnico = @ch_tecnico
			end
			else if (datepart(DW, @dt_fecha2)='1') begin 
				update @TT_DATOS set lun = @ch_nro_doc where (hora_n between '1' and datepart(HH, @dt_fecha2)+1) AND  id_tecnico = @ch_tecnico
			end
			else begin 
				update @TT_DATOS set lun = @ch_nro_doc where (hora_n between datepart(HH, @dt_fecha)+1 AND '24') AND  id_tecnico = @ch_tecnico
				update @TT_DATOS set lun = @ch_nro_doc where (hora_n between '1' and datepart(HH, @dt_fecha2)+1) AND  id_tecnico = @ch_tecnico
			end
		end
		else
		begin
		update @TT_DATOS set lun = @ch_nro_doc where (hora_n between datepart(HH, @dt_fecha)+1 AND datepart(HH, @dt_fecha2)) AND  id_tecnico = @ch_tecnico
		end
		
	---------------------------------------------------------------------------------------------------------------------------------------
	if  (CONVERT(VARCHAR(8),(DATEADD(wk, DATEDIFF(wk,1,@DESDE), 1)),112) between CONVERT(VARCHAR(8),@dt_fecha,112) and CONVERT(VARCHAR(8),@dt_fecha2,112))			
		if (datepart(HH, @dt_fecha2)<datepart(HH, @dt_fecha)) begin
			if(datepart(DW, @dt_fecha)='2') begin
			update @TT_DATOS set mar = @ch_nro_doc where (hora_n between datepart(HH, @dt_fecha)+1 AND '24') AND  id_tecnico = @ch_tecnico
			end
			else if (datepart(DW, @dt_fecha2)='2') begin 
				update @TT_DATOS set mar = @ch_nro_doc where (hora_n between '1' and datepart(HH, @dt_fecha2)+1) AND  id_tecnico = @ch_tecnico
			end
			else begin 
				update @TT_DATOS set mar = @ch_nro_doc where (hora_n between datepart(HH, @dt_fecha)+1 AND '24') AND  id_tecnico = @ch_tecnico
				update @TT_DATOS set mar = @ch_nro_doc where (hora_n between '1' and datepart(HH, @dt_fecha2)+1) AND  id_tecnico = @ch_tecnico
			end
		end
		else
		begin
		update @TT_DATOS set mar = @ch_nro_doc where (hora_n between datepart(HH, @dt_fecha)+1 AND datepart(HH, @dt_fecha2)) AND  id_tecnico = @ch_tecnico
		end
		
	---------------------------------------------------------------------------------------------------------------------------------------
	if  (CONVERT(VARCHAR(8),(DATEADD(wk, DATEDIFF(wk,2,@DESDE), 2)),112) between CONVERT(VARCHAR(8),@dt_fecha,112) and CONVERT(VARCHAR(8),@dt_fecha2,112))			
		if (datepart(HH, @dt_fecha2)<datepart(HH, @dt_fecha)) begin
			if(datepart(DW, @dt_fecha)='3') begin
			update @TT_DATOS set mie = @ch_nro_doc where (hora_n between datepart(HH, @dt_fecha)+1 AND '24') AND  id_tecnico = @ch_tecnico
			end
			else if (datepart(DW, @dt_fecha2)='3') begin 
				update @TT_DATOS set mie = @ch_nro_doc where (hora_n between '1' and datepart(HH, @dt_fecha2)+1) AND  id_tecnico = @ch_tecnico
			end
			else begin 
				update @TT_DATOS set mie = @ch_nro_doc where (hora_n between datepart(HH, @dt_fecha)+1 AND '24') AND  id_tecnico = @ch_tecnico
				update @TT_DATOS set mie = @ch_nro_doc where (hora_n between '1' and datepart(HH, @dt_fecha2)+1) AND  id_tecnico = @ch_tecnico
			end
		end
		else
		begin
		update @TT_DATOS set mie = @ch_nro_doc where (hora_n between datepart(HH, @dt_fecha)+1 AND datepart(HH, @dt_fecha2)) AND  id_tecnico = @ch_tecnico
		end
		
	---------------------------------------------------------------------------------------------------------------------------------------
	if  (CONVERT(VARCHAR(8),(DATEADD(wk, DATEDIFF(wk,3,@DESDE), 3)),112) between CONVERT(VARCHAR(8),@dt_fecha,112) and CONVERT(VARCHAR(8),@dt_fecha2,112))			
		if (datepart(HH, @dt_fecha2)<datepart(HH, @dt_fecha)) begin
			if(datepart(DW, @dt_fecha)='4') begin
			update @TT_DATOS set jue = @ch_nro_doc where (hora_n between datepart(HH, @dt_fecha)+1 AND '24') AND  id_tecnico = @ch_tecnico
			end
			else if (datepart(DW, @dt_fecha2)='4') begin 
				update @TT_DATOS set jue = @ch_nro_doc where (hora_n between '1' and datepart(HH, @dt_fecha2)+1) AND  id_tecnico = @ch_tecnico
			end
			else begin 
				update @TT_DATOS set jue = @ch_nro_doc where (hora_n between datepart(HH, @dt_fecha)+1 AND '24') AND  id_tecnico = @ch_tecnico
				update @TT_DATOS set jue = @ch_nro_doc where (hora_n between '1' and datepart(HH, @dt_fecha2)+1) AND  id_tecnico = @ch_tecnico
			end
		end
		else
		begin
		update @TT_DATOS set jue = @ch_nro_doc where (hora_n between datepart(HH, @dt_fecha)+1 AND datepart(HH, @dt_fecha2)) AND  id_tecnico = @ch_tecnico
		end
		
	---------------------------------------------------------------------------------------------------------------------------------------
	if  (CONVERT(VARCHAR(8),(DATEADD(wk, DATEDIFF(wk,4,@DESDE), 4)),112) between CONVERT(VARCHAR(8),@dt_fecha,112) and CONVERT(VARCHAR(8),@dt_fecha2,112))			
		if (datepart(HH, @dt_fecha2)<datepart(HH, @dt_fecha)) begin
			if(datepart(DW, @dt_fecha)='5') begin
			update @TT_DATOS set vie = @ch_nro_doc where (hora_n between datepart(HH, @dt_fecha)+1 AND '24') AND  id_tecnico = @ch_tecnico
			end
			else if (datepart(DW, @dt_fecha2)='5') begin 
				update @TT_DATOS set vie = @ch_nro_doc where (hora_n between '1' and datepart(HH, @dt_fecha2)+1) AND  id_tecnico = @ch_tecnico
			end
			else begin 
				update @TT_DATOS set vie = @ch_nro_doc where (hora_n between datepart(HH, @dt_fecha)+1 AND '24') AND  id_tecnico = @ch_tecnico
				update @TT_DATOS set vie = @ch_nro_doc where (hora_n between '1' and datepart(HH, @dt_fecha2)+1) AND  id_tecnico = @ch_tecnico
			end
		end
		else
		begin
		update @TT_DATOS set vie = @ch_nro_doc where (hora_n between datepart(HH, @dt_fecha)+1 AND datepart(HH, @dt_fecha2)) AND  id_tecnico = @ch_tecnico
		end
		
	---------------------------------------------------------------------------------------------------------------------------------------
	if  (CONVERT(VARCHAR(8),(DATEADD(wk, DATEDIFF(wk,5,@DESDE), 5)),112) between CONVERT(VARCHAR(8),@dt_fecha,112) and CONVERT(VARCHAR(8),@dt_fecha2,112))			
		if (datepart(HH, @dt_fecha2)<datepart(HH, @dt_fecha)) begin
			if(datepart(DW, @dt_fecha)='6') begin
			update @TT_DATOS set sab = @ch_nro_doc where (hora_n between datepart(HH, @dt_fecha)+1 AND '24') AND  id_tecnico = @ch_tecnico
			end
			else if (datepart(DW, @dt_fecha2)='6') begin 
				update @TT_DATOS set sab = @ch_nro_doc where (hora_n between '1' and datepart(HH, @dt_fecha2)+1) AND  id_tecnico = @ch_tecnico
			end
			else begin 
				update @TT_DATOS set sab = @ch_nro_doc where (hora_n between datepart(HH, @dt_fecha)+1 AND '24') AND  id_tecnico = @ch_tecnico
				update @TT_DATOS set sab = @ch_nro_doc where (hora_n between '1' and datepart(HH, @dt_fecha2)+1) AND  id_tecnico = @ch_tecnico
			end
		end
		else
		begin
		update @TT_DATOS set sab = @ch_nro_doc where (hora_n between datepart(HH, @dt_fecha)+1 AND datepart(HH, @dt_fecha2)) AND  id_tecnico = @ch_tecnico
		end
		
	---------------------------------------------------------------------------------------------------------------------------------------
	if  (CONVERT(VARCHAR(8),(DATEADD(wk, DATEDIFF(wk,5,@DESDE), 5)+1),112) between CONVERT(VARCHAR(8),@dt_fecha,112) and CONVERT(VARCHAR(8),@dt_fecha2,112))			
		if (datepart(HH, @dt_fecha2)<datepart(HH, @dt_fecha)) begin
			if(datepart(DW, @dt_fecha)='7') begin
			update @TT_DATOS set dom = @ch_nro_doc where (hora_n between datepart(HH, @dt_fecha)+1 AND '24') AND  id_tecnico = @ch_tecnico
			end
			else if (datepart(DW, @dt_fecha2)='7') begin 
				update @TT_DATOS set dom = @ch_nro_doc where (hora_n between '1' and datepart(HH, @dt_fecha2)+1) AND  id_tecnico = @ch_tecnico
			end
			else begin 
				update @TT_DATOS set dom = @ch_nro_doc where (hora_n between datepart(HH, @dt_fecha)+1 AND '24') AND  id_tecnico = @ch_tecnico
				update @TT_DATOS set dom = @ch_nro_doc where (hora_n between '1' and datepart(HH, @dt_fecha2)+1) AND  id_tecnico = @ch_tecnico
			end
		end
		else
		begin
		update @TT_DATOS set dom = @ch_nro_doc where (hora_n between datepart(HH, @dt_fecha)+1 AND datepart(HH, @dt_fecha2)) AND  id_tecnico = @ch_tecnico
		end
		
	---------------------------------------------------------------------------------------------------------------------------------------

	set @in_row = @in_row +1
end


--// presentamos los datos
	select id_tecnico, des_tec, hora, lun, mar, mie, jue, vie, sab, dom  from @TT_DATOS
	--GROUP BY des_tec,id_tecnico, hora, lun, mar, mie, jue, vie, sab, dom

--select id_tecnico,des_tec, nro_doc, fecha, fecha2 from @TT_TAREAS

-- SP_OPERACIONES_HORARIO_TH '01','01','15/11/2010','30/11/2010',''
GO
/****** Object:  StoredProcedure [dbo].[SP_OPERACIONES_HORAS]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*

SP_OPERACIONES_HORAS

*/


CREATE PROCEDURE [dbo].[SP_OPERACIONES_HORAS]
AS
-------------------------------------------------------------
declare @TT_DATOS table (hora_n char(2), hora char(14))
DECLARE @in_hra1  int,@in_hra24 int
-------------------------------------------------------------
select @in_hra1 = 1, @in_hra24 = 24 
while @in_hra1 <= @in_hra24 begin
	
			insert @TT_DATOS (hora_n, hora)
			select @in_hra1, right('0' + cast((@in_hra1-1) as varchar), 2) + ':00 - '+right('0' + cast((@in_hra1) as varchar), 2) + ':00'
	set @in_hra1 = @in_hra1 + 1
end
-------------------------------------------------------------

select * from @TT_DATOS
GO
/****** Object:  StoredProcedure [dbo].[SP_OPERCIONES_GET_DIA]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE [dbo].[SP_OPERCIONES_GET_DIA]
@nom_dia VARCHAR(15),
@dia datetime
AS
IF DATENAME(DW,(DATEADD(wk, DATEDIFF(wk,0,@dia), 0)))=@nom_dia 
	SELECT CONVERT(VARCHAR(10),(DATEADD(wk, DATEDIFF(wk,0,@dia), 0)),103)
IF DATENAME(DW,(DATEADD(wk, DATEDIFF(wk,1,@dia), 1)))=@nom_dia 
	SELECT CONVERT(VARCHAR(10),(DATEADD(wk, DATEDIFF(wk,1,@dia), 1)),103)
IF DATENAME(DW,(DATEADD(wk, DATEDIFF(wk,2,@dia), 2)))=@nom_dia 
	SELECT CONVERT(VARCHAR(10),(DATEADD(wk, DATEDIFF(wk,2,@dia), 2)),103)
IF DATENAME(DW,(DATEADD(wk, DATEDIFF(wk,3,@dia), 3)))=@nom_dia 
	SELECT CONVERT(VARCHAR(10),(DATEADD(wk, DATEDIFF(wk,3,@dia), 3)),103)
IF DATENAME(DW,(DATEADD(wk, DATEDIFF(wk,4,@dia), 4)))=@nom_dia 
	SELECT CONVERT(VARCHAR(10),(DATEADD(wk, DATEDIFF(wk,4,@dia), 4)),103)
IF DATENAME(DW,(DATEADD(wk, DATEDIFF(wk,5,@dia), 5)))=@nom_dia 
	SELECT CONVERT(VARCHAR(10),(DATEADD(wk, DATEDIFF(wk,5,@dia), 5)),103)
IF DATENAME(DW,(DATEADD(wk, DATEDIFF(wk,5,@dia), 5)+1))=@nom_dia 
	SELECT CONVERT(VARCHAR(10),(DATEADD(wk, DATEDIFF(wk,5,@dia), 5)+1),103)
GO
/****** Object:  StoredProcedure [dbo].[SP_ORDEN_SERVTECNICO_CRONOGRAMA]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
sp_help ocurrencia
SELECT * from dbo.MOTIVO_SERVICIO
SELECT * from  ESTADO
SP_ORDEN_SERVTECNICO_CRONOGRAMA '1','01','01','86','0000','00000014',''
SP_ORDEN_SERVTECNICO_CRONOGRAMA '2','01','01','86','0000','00000014',''

SP_ORDEN_SERVTECNICO_CRONOGRAMA '1','01','01','86','0000','00000014','42476689'
SP_ORDEN_SERVTECNICO_CRONOGRAMA '2','01','01','86','0000','00000014','42476689'

SELECT * FROM OCURRENCIA
SELECT * FROM cronograma_oper
select * from articulo_temp
delete from articulo_temp
*/

CREATE	PROC [dbo].[SP_ORDEN_SERVTECNICO_CRONOGRAMA]
@INDICADOR CHAR(1),
@CIA	 CHAR(2),		@SEDE  CHAR(2),	
@ID_TIPO_DOC	CHAR(2),@SERIE_DOC CHAR(4), @NRO_DOC VARCHAR(20),
 @id_tecnico VARCHAR(100)
AS
-----------------------------------------------------------------------------------------------------------------------
DECLARE @FECHA1 VARCHAR(8),@FECHA2 VARCHAR(8)
DECLARE @sSelect varchar(MAX),	@sInner varchar(MAX),	@sFiltroTecID varchar(MAX), @sFiltroNro_doc varchar(MAX)
DECLARE @sOrderBy varchar(MAX),			@sGroupBy varchar(MAX),		 @sExecute varchar(MAX)
----------------------------------------------------------------------------------------------------------------------
SELECT @sSelect='', @sInner='',  @sFiltroTecID='', @sFiltroNro_doc='',@sOrderBy='',@sGroupBy='',@sExecute=''
-----------------------------------------------------------------------------------------------------------------
IF(@INDICADOR='1')
BEGIN
	SELECT @sSelect='
		co.id_tipo_doc ,co.serie_doc,co.nro_doc,co.id_motivo_servicio,fecha=CONVERT(VARCHAR(10),co.fecha,103),
		co.tiempo_duracion,co.id_cliente,co.id_punto_venta,id_contacto,	e.abreviatura ''estado'',co.id_estado ''id_estado'',
		fecha_inicio=CONVERT(VARCHAR(10),co.fecha_inicio,103),fecha_fin=CONVERT(VARCHAR(10),co.fecha_fin,103),
		hora_inicio=convert(char(5),co.fecha_inicio, 114) ,hora_fin=convert(char(5),co.fecha_fin, 114),
		co.id_tecnico,co.id_tecnico_2,co.id_tecnico_3,co.id_tecnico_4
		FROM CRONOGRAMA_OPER co
		INNER JOIN ESTADO E ON E.CIA=co.CIA AND E.ID_ESTADO=co.ID_ESTADO
		INNER JOIN CRONOGRAMA_OPER_DETALLE cod ON cod.CIA=co.CIA AND cod.sede=co.sede AND cod.id_tipo_doc=co.id_tipo_doc AND  cod.serie_doc=co.serie_doc AND  cod.nro_doc=co.nro_doc
		INNER JOIN ANALITICA A ON A.CIA=co.CIA AND A.ID_ANALITICA=co.id_tecnico
		WHERE co.CIA='''+@CIA+''' AND co.SEDE='''+@SEDE+''' AND co.id_tipo_doc='''+@id_tipo_doc+''' AND co.serie_doc='''+@serie_doc+'''	AND co.ID_ESTADO=''11''	
		AND FLAG_ST=''0'' '
	SELECT @sGroupBy= 'GROUP by co.id_tipo_doc ,co.serie_doc,co.nro_doc,co.id_motivo_servicio,CONVERT(VARCHAR(10),co.fecha,103),
		co.tiempo_duracion,co.id_cliente,co.id_punto_venta,id_contacto,	e.abreviatura ,co.id_estado,
		CONVERT(VARCHAR(10),co.fecha_inicio,103),CONVERT(VARCHAR(10),co.fecha_fin,103),convert(char(5),co.fecha_inicio, 114),
		convert(char(5),co.fecha_fin, 114),co.id_tecnico,co.id_tecnico_2,co.id_tecnico_3,co.id_tecnico_4'  
	------------------------------------------------------------------------------------------------------------------
	IF  LEN(ISNULL(@nro_doc,''))>0 
			BEGIN    SELECT @sFiltroNro_doc		=' and co.nro_doc  in('''+@nro_doc+''')'	 END
	ELSE	BEGIN    SELECT @sFiltroNro_doc	=''	END
	------------------------------------------------------------------------------------------------------------------
	IF  LEN(ISNULL(@id_tecnico,''))>0 
			BEGIN    SELECT @sFiltroTecID		=' and co.id_tecnico  in('''+@id_tecnico+''')'	 END
	ELSE	BEGIN    SELECT @sFiltroTecID	=''	END
	--------------------------------------------------------------------------------------------	
	SELECT @sOrderBy	=' ORDER BY co.nro_doc'
	---------------------------------------------------------------------------------------------
	 SELECT @sExecute = @sSelect  +''+   @sFiltroNro_doc  +''+ @sFiltroTecID+''+ @sGroupBy +''+@sOrderBy
 	PRINT @sExecute
	EXEC ('SELECT '+ @sExecute )	
end 
-------------------------------------------------------------------------------------------- 
IF(@INDICADOR='2')
BEGIN
	SELECT @sSelect='	
		COD.item,COD.ID_ARTICULO ''id_articulo'',COD.CANTIDAD ''cantidad'',COD.DES_ARTICULO ''descripcion'',
		um.ABREVIATURA ''unidad'',A.nro_parte,upper(MA.DESCRIPCION) ''marca''
		FROM CRONOGRAMA_OPER CO
		INNER JOIN CRONOGRAMA_OPER_DETALLE COD ON COD.CIA=CO.CIA AND COD.SEDE=CO.SEDE AND 
			COD.ID_TIPO_DOC=CO.ID_TIPO_DOC AND COD.SERIE_DOC=CO.SERIE_DOC AND COD.NRO_DOC=CO.NRO_DOC
		INNER JOIN ARTICULO A ON A.CIA=COD.CIA AND A.ID_ARTICULO=COD.ID_ARTICULO
		INNER JOIN UNIDAD_MEDIDA UM ON UM.CIA=A.CIA AND UM.ID_UNIDAD=A.ID_UNIDAD
		LEFT JOIN MARCA_ARTICULO  MA ON MA.CIA=A.CIA AND MA.ID_MARCA=A.ID_MARCA
		WHERE CO.CIA='''+@CIA+''' AND CO.SEDE='''+@SEDE+'''	AND	CO.ID_TIPO_DOC='''+@ID_TIPO_DOC+'''
		AND	CO.SERIE_DOC='''+@SERIE_DOC+'''	AND	CO.NRO_DOC LIKE '''+@NRO_DOC+'''	'
	-------------------------------------------------------------------------
	SELECT @sGroupBy=''  
	SELECT @sOrderBy	=' ORDER BY COd.item'
	---------------------------------------------------------------------------------------------
	SELECT @sExecute = @sSelect  +''+  @sGroupBy +''+@sOrderBy
 	PRINT @sExecute
	EXEC ('SELECT '+ @sExecute )	 
 END
GO
/****** Object:  StoredProcedure [dbo].[SP_ORDEN_SERVTECNICO_GRABAR_TIPO]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
sp_help SERVICIO_TECNICO
select * from tipo_diagnostico				40
select * from tipo_solucion					32
DELETE	FROM tipo_diagnostico where cia='01' and id_tipo_diagnostico in('41')
DELETE	FROM tipo_solucion where cia='01' and id_tipo_Solucion in('35')
[SP_ORDEN_SERVTECNICO_GRABAR_TIPO] 2,'01','01','','99','','mmmmmmmmmmmmmmmmmm','admin'

*/
-----------------------------------------------
-----------------------------------------------
CREATE	PROC	[dbo].[SP_ORDEN_SERVTECNICO_GRABAR_TIPO]
@INDICADOR				int,
@CIA					CHAR(2), 
@SEDE					CHAR(2),
@ID_TIPO_DIAGNOSTICO	CHAR(2),
@ID_TIPO_SOLUCION		CHAR(2),
@DESCRIPCION_TD			VARCHAR(max),
@DESCRIPCION_TS			VARCHAR(max),
@UC						VARCHAR(25)
AS
-----------------------------------------------
DECLARE @VARMSG			VARCHAR(MAX)
DECLARE	@COUNT			INT
DECLARE @ID_TD			CHAR(2)
DECLARE @ID_TS			CHAR(2)
SET @ID_TD = (SELECT ISNULL ((SELECT max(ID_TIPO_DIAGNOSTICO)+1 FROM  tipo_diagnostico 	WHERE CIA = @CIA ),'01'))			
SET @ID_TS = (SELECT ISNULL ((SELECT max(ID_TIPO_SOLUCION)+1 FROM  tipo_solucion wHERE CIA = @CIA ),'01'))	
-----------------------------------------------
BEGIN TRANSACTION
	-------------------------------------------
IF (@INDICADOR = 1)
BEGIN		
	----------------------------------------------------
		IF(@ID_TIPO_DIAGNOSTICO='99')
		BEGIN	
				-------------------------------------------
				INSERT	INTO tipo_diagnostico			
				(
					CIA, ID_TIPO_DIAGNOSTICO,descripcion,ID_ESTADO,FLAG_ENVIO,SE,FC,UC			
				)
				VALUES			
				(
					@CIA, @ID_TD,@descripcion_td,'01','1',@SEDE,GETDATE(),@UC				
				)		
				-------------------------------------------
				IF @@ERROR <> 0 OR @@ROWCOUNT <> 1
				BEGIN
					---------------------------------------	
					SET		@VARMSG	= 'SE PRODUJO UN ERROR DURANTE EL PROCESO DE GRABACION DEL tipo_diagnostico. NO SE GRABARON LOS DATOS.'					
					GOTO	MSGERROR
					----------------------------------------
				END
		end			
end
------------------------------------------------------------------------------------
IF (@INDICADOR = 2)
BEGIN		
		IF(@ID_TIPO_SOLUCION='99')
			begin			
				-------------------------------------------
				INSERT	INTO tipo_solucion			
				(
					CIA, ID_TIPO_solucion,descripcion,ID_ESTADO,FLAG_ENVIO,SE,FC,UC			
				)
				VALUES			
				(
					@CIA, @ID_TS,@descripcion_ts,'01','1',@SEDE,GETDATE(),@UC				
				)		
				----------------------------------------------
				IF @@ERROR <> 0 OR @@ROWCOUNT <> 1
				BEGIN
					---------------------------------------	
					SET		@VARMSG	= 'SE PRODUJO UN ERROR DURANTE EL PROCESO DE GRABACION DEL tipo_solucion. NO SE GRABARON LOS DATOS.'				
					GOTO	MSGERROR
					---------------------------------------
				END		
				--print @CIA+','+ @ID_TS+','+ @descripcion_ts+','+ '01,1,'+ @SEDE+','+ @UC			
			end
END		
COMMIT TRANSACTION
------------------------------------------------
RETURN
MSGERROR:
		ROLLBACK TRANSACTION
		----------------------------------------
		RAISERROR	(@VARMSG, 15, 1)
		RETURN
GO
/****** Object:  StoredProcedure [dbo].[SP_ORDEN_SERVTECNICO_LISTAR]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
sp_help ocurrencia

SELECT * from  ESTADO



SPHELP 
SP_ORDEN_SERVTECNICO_TRAER '2','01','01','28','0001','' 
GO
SP_ORDEN_SERVTECNICO_LISTAR '01','01','28','0001','','','' ,'','' ,'','' ,'','' ,'' ,'','' ,''
SP_ORDEN_SERVTECNICO_LISTAR '01','01','28','0001','','','01/11/2010','30/11/2010','' ,'','' ,'','' ,'' ,'','' ,''
SP_ORDEN_SERVTECNICO_LISTAR '01','01','28','0001','','','','',  '44725392' ,'','' ,'','' ,'' ,'','' ,''
SP_ORDEN_SERVTECNICO_LISTAR '01','01','28','0001','','','','',  '' ,'','' ,'','' ,'' ,'11','' ,''
select * from dbo.SERVICIO_TECNICO  where cia='01'  and sede='01' and id_tipo_doc='28' 	and serie_doc='0001'  and nro_doc='00000002' 
select * from dbo.SERVICIO_TECNICO_DETALLE
select * from dbo.motivo_servicio
SELECT * FROM articulo_temp

*/

CREATE	PROC [dbo].[SP_ORDEN_SERVTECNICO_LISTAR]
@CIA			CHAR(2), @SEDE      CHAR(2),	 
@ID_TIPO_DOC	CHAR(2), @SERIE_DOC CHAR(4), @NRO_DOC VARCHAR(20),
@ID_MOTIVO_SERVICIO	CHAR(2), @fec_ini datetime, @fec_fin DATETIME,   @id_tecnico VARCHAR(100), @nom_tec VARCHAR(100),       @id_punto_venta CHAR(1),
@id_contacto CHAR(1),    @id_cliente VARCHAR(20),@nom_cli VARCHAR(100), @id_estado VARCHAR(100), @id_tipo_diagnostico CHAR(2),@id_tipo_solucion char(2)
AS
-----------------------------------------------------------------------------------------------------------------------
DECLARE @FECHA1 VARCHAR(8),@FECHA2 VARCHAR(8)
DECLARE @sSelect varchar(MAX),			@sFiltroID varchar(MAX),	@sFiltroMotivo varchar(MAX), @sFiltroTecnico varchar(MAX)
DECLARE @sFiltroTecnicoNombre varchar(MAX),	@sFiltroFecha varchar(MAX), @sFiltroClienteNombre varchar(MAX), @sFiltroEstado varchar(MAX)
DECLARE @sOrderBy varchar(MAX), @sGroupBy varchar(MAX), @sExecute varchar(MAX)
----------------------------------------------------------------------------------------------------------------------
SET @FECHA1 = CONVERT(VARCHAR(8),@fec_ini,112)
SET @FECHA2 = CONVERT(VARCHAR(8),@fec_fin,112)
SELECT @sSelect='', @sFiltroID='', @sFiltroMotivo='',@sFiltroTecnico='',@sFiltroTecnicoNombre='',@sFiltroClienteNombre='',
		@sFiltroFecha='',@sFiltroEstado='',	@sOrderBy ='',	@sGroupBy ='',	@sExecute =''
-----------------------------------------------------------------------------------------------------------------
SELECT @sSelect='
	st.id_tipo_doc ,st.serie_doc,st.nro_doc,st.SERIE_DOC + ''-'' + st.nro_doc ''numero-doc'',st.id_motivo_servicio,ms.descripcion ''motivo'',
	fecha=CONVERT(VARCHAR(10),st.fecha,103),st.id_tecnico,A.DESCRIPCION ''nombre'',	st.id_punto_venta,st.id_contacto,st.id_cliente,
	e.abreviatura ''estado'',st.id_tipo_diagnostico,st.id_tipo_solucion,st.id_tecnico_2,st.id_tecnico_3,st.id_tecnico_4,
	fecha_hora=CONVERT(VARCHAR(10),st.fecha,103) +space(2)+convert(char(5),st.fecha, 114),ac.descripcion ''nombre_cliente'',st.id_estado ''id_estado'',
	st.id_tipo_doc_op,st.serie_doc_op,st.nro_doc_op
	FROM SERVICIO_TECNICO st
	INNER JOIN ESTADO E ON E.CIA=st.CIA AND E.ID_ESTADO=st.ID_ESTADO
	left JOIN SERVICIO_TECNICO_DETALLE std ON std.CIA=st.CIA AND std.sede=st.sede AND std.id_tipo_doc=st.id_tipo_doc
				AND  std.serie_doc=st.serie_doc AND  std.nro_doc=st.nro_doc
	INNER JOIN ANALITICA A ON A.CIA=st.CIA AND A.ID_ANALITICA=st.id_tecnico
	INNER JOIN ANALITICA AC ON AC.CIA=st.CIA AND AC.ID_ANALITICA=st.id_cliente
	inner join motivo_servicio ms on ms.cia=st.cia and ms.id_motivo_servicio=st.id_motivo_servicio
	WHERE st.CIA='''+@CIA+''' AND st.SEDE='''+@SEDE+''' AND st.id_tipo_doc='''+@id_tipo_doc+''' AND st.serie_doc='''+@serie_doc+'''		'
SELECT @sGroupBy=' GROUP BY
	st.id_tipo_doc ,st.serie_doc,st.nro_doc,st.id_motivo_servicio,ms.descripcion,CONVERT(VARCHAR(10),st.fecha,103),
	st.id_tecnico,A.DESCRIPCION,st.id_punto_venta,st.id_contacto,st.id_cliente,e.abreviatura,st.id_tipo_diagnostico,
	st.id_tipo_solucion,st.id_tecnico_2,st.id_tecnico_3,st.id_tecnico_4,CONVERT(VARCHAR(10),st.fecha,103)+space(2)+convert(char(5),st.fecha, 114),
	ac.descripcion,st.id_estado,st.id_tipo_doc_op,st.serie_doc_op,st.nro_doc_op '	
	 ------------------------------------------------------------------------------------------------------------------
	IF  LEN(ISNULL(@nro_doc,''))>0 
			BEGIN    SELECT @sFiltroID	=' and st.nro_doc  in('''+@nro_doc+''')' END
	ELSE	BEGIN    SELECT @sFiltroID	=''	END
	------------------------------------------------------------------------------------------------------------------
	IF  LEN(ISNULL(@ID_MOTIVO_SERVICIO,''))>0 
			BEGIN    SELECT @sFiltroMotivo=' and ms.descripcion like '''+@ID_MOTIVO_SERVICIO+''' +''%'' '	 END
	ELSE	BEGIN    SELECT @sFiltroMotivo=''END
	--------------------------------------------------------------------------------------------	
	IF  ISNULL(@FECHA1,'19000101') <> '19000101'  AND  ISNULL(@FECHA2,'19000101') <> '19000101'
			BEGIN 	SELECT @sFiltroFecha=' and convert(varchar(8),st.fecha,112) between  '''+@FECHA1+'''  and  '''+@FECHA2+''''	END
	ELSE 	BEGIN	SELECT @sFiltroFecha=''	END	
		------------------------------------------------------------------------------------------------------------------
	IF  LEN(ISNULL(@id_tecnico,''))>0 
			BEGIN   SELECT @sFiltroTecnico=' and st.id_tecnico like '''+@id_tecnico+''' +''%'' '	 END
	ELSE	BEGIN   SELECT @sFiltroTecnico	=''	END
	------------------------------------------------------------------------------------------------------------------
	IF  LEN(ISNULL(@nom_tec,''))>0 
			BEGIN   SELECT @sFiltroTecnicoNombre=' and A.DESCRIPCION like  ''%'' +'''+@nom_tec+''' +''%'' '	END
	ELSE	BEGIN   SELECT @sFiltroTecnicoNombre=''	END
	------------------------------------------------------------------------------------------------------------------
	IF  LEN(ISNULL(@nom_cli,''))>0 
			BEGIN  SELECT @sFiltroClienteNombre=' and A.DESCRIPCION like  ''%'' +'''+@nom_cli+''' +''%'' '	END
	ELSE	BEGIN  SELECT @sFiltroClienteNombre	=''	END	
	--------------------------------------------------------------------------------------------
	IF  LEN(ISNULL(@id_estado,''))>0 AND @id_estado<>'%' 
			BEGIN   SELECT @sFiltroEstado=' and st.ID_ESTADO  in('''+@id_estado+''') ' END
	ELSE	BEGIN	SELECT @sFiltroEstado=''	END
	--------------------------------------------------------------------------------------------	
	SELECT @sOrderBy	=' ORDER BY st.nro_doc'
	---------------------------------------------------------------------------------------------
	SELECT @sExecute = @sSelect +''+ @sFiltroID  +''+ @sFiltroMotivo+''+@sFiltroFecha+''+ @sFiltroTecnico +''+
			 @sFiltroTecnicoNombre +''+ @sFiltroClienteNombre +''+  @sFiltroEstado +''+@sGroupBy +''+ @sOrderBy
 	PRINT @sExecute
	EXEC ('SELECT '+ @sExecute )	 
 	--------------------------------------------------------------------------------------------
GO
/****** Object:  StoredProcedure [dbo].[SP_ORDEN_SERVTECNICO_MANTENIMIENTO]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
			
select * from articulo_temp			where sesion='1efd9e14-84ac-4d0c-b684-6f727eedf62d'
select * from TIPO_DOCUMENTO_SERIE where ID_TIPO_DOC='28' AND SERIE='0001' AND ID_ESTADO = '01'
SELECT ID_ESTADO,* FROM SERVICIO_TECNICo
SELECT ID_ESTADO,* FROM CRONOGRAMA_OPER
SELECT  ID_ESTADO,*FROM SERVICIO_TECNICo_detalle
SELECT top 1  ID_ESTADO,* FROM cronograma_oper_detalle

update TIPO_DOCUMENTO_SERIE set correlativo='0' where ID_TIPO_DOC='28' AND SERIE='0001' AND ID_ESTADO = '01'
delete SERVICIO_TECNICo where cia='01' and sede='01' and  id_tipo_doc='28' and serie_doc='0001'
delete SERVICIO_TECNICo_detalle where cia='01' and sede='01' and  id_tipo_doc='28' and serie_doc='0001' 
update  CRONOGRAMA_OPER SET ID_ESTADO='11',flag_st='0' WHERE cia='01' AND sede='01' 
update  cronograma_oper_detalle SET ID_ESTADO='01' WHERE cia='01' AND sede='01' 

SP_ORDEN_SERVTECNICO_MANTENIMIENTO
'2','9cf672be-a6bd-4794-8fe8-9c2a3b402d24','01','01','28','0001','00000001','01','20127765279','1',1,'42476689','PPPPPPPPP',
'19/10/2010 06:39','19/10/2010 07:00','','ADMIN','01','10','11','NO LEEN CHIPS','SE CAMBIO DS-9097','00000034','86','0001','00000001','','',''

SP_ORDEN_SERVTECNICO_MANTENIMIENTO
'4','556bb126-76da-4f2a-96df-67aa2867a895','01','01','28','0001','00000001','','','','','','','','','','admin','','','19','','','','','',''

SP_ORDEN_SERVTECNICO_MANTENIMIENTO
'1','7080c50f-beaf-4aae-b89b-8e107a553397','01','01','28','0001','00000001','12','20100111838','1',1,'42953327','XX','25/10/2010 02:00','27/10/2010 04:00',
'','ADMIN','01','10','11','NO LEEN CHIPS','SE CAMBIO DS-9097','00000010','86','0001','00000001','31178811','',''

SP_ORDEN_SERVTECNICO_MANTENIMIENTO
'6','07752482-6143-4da1-92c4-d2f062db0ffe','01','01','28','0001','00088889','06','20117813143','1',1,'40870717','GG','19/11/2010 10:00','19/11/2010 14:00',
'','SISTEMAS','33','03','11','PROBLEMAS CON EL BOUCHER','SE CAMBIO LA FUENTE','00000016','86','0000','00000009','','',''
*/
-----------------------------------------------
CREATE	PROC	[dbo].[SP_ORDEN_SERVTECNICO_MANTENIMIENTO]
@INDICADOR	CHAR(1),@SESION	VARCHAR(max),@CIA CHAR(2),@SEDE CHAR(2),
@ID_TIPO_DOC CHAR(2),@SERIE_DOC	VARCHAR(4),@NRODOC	varchar(20),	
@ID_MOTIVO_SERVICIO		VARCHAR(2),
@ID_CLIENTE				VARCHAR(20),
@ID_PUNTO_VENTA			VARCHAR(20),
@ID_CONTACTO			int,
@ID_TECNICO_1			VARCHAR(20),
@INFORMACION_TECNICA	VARCHAR(max),
@INICIO_SERVICIO		datetime,
@FIN_SERVICIO			datetime,
@OBSERVACION			VARCHAR(max),
@UC						VARCHAR(25),
@ID_TIPO_DIAGNOSTICO	CHAR(2),@ID_TIPO_SOLUCION		CHAR(2),
@ID_ESTADO				CHAR(2),
@DESCRIPCION_TD		VARCHAR(200),@DESCRIPCION_TS	VARCHAR(200),
@NRO_FAE				VARCHAR(20),
@ID_TIPO_DOC_REF	CHAR(2),@SERIE_DOC_REF	VARCHAR(4),@NRO_DOC_REF	varchar(20),
@ID_TECNICO_2	VARCHAR(20),@ID_TECNICO_3	VARCHAR(20),@ID_TECNICO_4	VARCHAR(20)
AS
-------------------------------------------------------------------------------------------------------------
DECLARE @VARMSG	VARCHAR(MAX),@COUNT	INT,@ID_TIPO_FAE CHAR(2),@NRO_DOC varchar(20), @NRO_DOC_DCD	varchar(20),
	@ID_ESTADO_TDS	CHAR(2),@ID_TD	CHAR(2),@ID_TS	CHAR(2), @NRO_DOC_ING varchar(20),
	@TECNICO_2 VARCHAR(20), @TECNICO_3 VARCHAR(20), @TECNICO_4 VARCHAR(20)
SET		@ID_TIPO_FAE	=  '27'
-----------------------------------------------
BEGIN TRANSACTION
-----------------------------------------
	SET	@NRO_DOC	=	(	SELECT ISNULL((SELECT	(REPLICATE('0',(8 - LEN(CORRELATIVO + 1))) + CONVERT(VARCHAR(8),(CORRELATIVO + 1)))
							FROM	TIPO_DOCUMENTO_SERIE	WHERE	CIA	= @CIA	AND	
							ID_TIPO_DOC	= @ID_TIPO_DOC	AND	SERIE	= @SERIE_DOC	AND	ID_ESTADO	= '01'),'00000001')
						)
	IF(@ID_TIPO_DIAGNOSTICO='99')
			BEGIN	SET @ID_TD = (SELECT ISNULL ((SELECT max(ID_TIPO_DIAGNOSTICO)+1 FROM  tipo_diagnostico 	WHERE CIA = @CIA ),'01'))	END		
	ELSE	BEGIN	SET @ID_TD = @ID_TIPO_DIAGNOSTICO	END
	-----------------------------------------------------------------------------------------		
	IF(@ID_TIPO_SOLUCION='99')
			BEGIN	SET @ID_TS = (SELECT ISNULL ((SELECT max(ID_TIPO_SOLUCION)+1 FROM  tipo_solucion wHERE CIA = @CIA ),'01'))		END		
	ELSE	BEGIN	SET @ID_TS = @ID_TIPO_SOLUCION		END
	-------------------------------------------------------------------------------------------------------
	IF  LEN(@ID_TECNICO_2)>0 
			BEGIN 	SET  @TECNICO_2	=	@ID_TECNICO_2	 END
	ELSE	BEGIN   SET @TECNICO_2	=	NULL			END
	-----------------------------------------------------
	IF  LEN(@ID_TECNICO_3)>0 
			BEGIN 	SET  @TECNICO_3	=	@ID_TECNICO_3	 END
	ELSE	BEGIN   SET @TECNICO_3	=	NULL	END
	-----------------------------------------------------
	IF  LEN(@ID_TECNICO_4)>0 
			BEGIN	SET  @TECNICO_4	=	@ID_TECNICO_4	 END
	ELSE	BEGIN   SET @TECNICO_4	=	NULL	END
	-------------------------------------------
IF (@INDICADOR = '1')
BEGIN	
	-----------------------------------------------------
	INSERT	INTO SERVICIO_TECNICO			/*	sp_help SERVICIO_TECNICO	*/
	(
		CIA, SEDE,ID_TIPO_DOC,SERIE_DOC,NRO_DOC,ID_MOTIVO_SERVICIO,FECHA,ID_CLIENTE,ID_PUNTO_VENTA,ID_CONTACTO,
		ID_TECNICO,INFORMACION_TECNICA,INICIO_SERVICIO,FIN_SERVICIO,OBSERVACION,ID_ESTADO,FLAG_ENVIO,SE,FC,UC,FECHA_INICIO_SERVICIO,
		ID_TIPO_DOC_OP,SERIE_DOC_OP,NRO_DOC_OP,	ID_TIPO_DIAGNOSTICO,ID_TIPO_SOLUCION,ID_TECNICO_2,ID_TECNICO_3,ID_TECNICO_4
	)
	VALUES				/*		SELECT * FROM SERVICIO_TECNICO		*/
	(
		@CIA, @SEDE,@ID_TIPO_DOC,@SERIE_DOC,@NRO_DOC,@ID_MOTIVO_SERVICIO,GETDATE(),@ID_CLIENTE,@ID_PUNTO_VENTA,@ID_CONTACTO,
		@ID_TECNICO_1,@INFORMACION_TECNICA,@INICIO_SERVICIO,@FIN_SERVICIO,@OBSERVACION,'11','1',@SEDE,GETDATE(),@UC,GETDATE(),
		@ID_TIPO_DOC_REF,@SERIE_DOC_REF,@NRO_DOC_REF,@ID_TD,@ID_TS,@TECNICO_2,@TECNICO_3,@TECNICO_4
	)
	-------------------------------------------
	IF @@ERROR <> 0 OR @@ROWCOUNT <> 1
	BEGIN
		---------------------------------------
		SET		@VARMSG	= 'SE PRODUJO UN ERROR DURANTE EL PROCESO DE GRABACION DEL SERVICIO_TECNICO. NO SE GRABARON LOS DATOS.'
		GOTO	MSGERROR
		----------------------------------------
	END			
	---------------------------------------------------------------------------------	
	INSERT	INTO SERVICIO_TECNICO_DETALLE		
	(
		CIA,SEDE,ID_TIPO_DOC,SERIE_DOC,NRO_DOC,ITEM,ID_ARTICULO,CANTIDAD,ID_TIPO_FAE,NRO_FAE,ID_ESTADO,FLAG_ENVIO,SE,FC,UC--,DES_ARTICULO
	)							
	SELECT	@CIA,@SEDE,@ID_TIPO_DOC,@SERIE_DOC,@NRO_DOC,ITEM,ID_ARTICULO,CANTIDAD,@ID_TIPO_FAE,@NRO_FAE,'01','1',@SEDE, GETDATE(), @UC--,@DES_ARTICULO		 
		FROM	ARTICULO_TEMP		WHERE	SESION = @SESION	
	---------------------------------------------------------------------------------------------------------	
	UPDATE	CRONOGRAMA_OPER			/*		select * from CRONOGRAMA_OPER */
		SET		FLAG_ST				= '1'		
		WHERE	CIA					= @CIA 	
		AND		SEDE				= @SEDE
		AND		ID_TIPO_DOC			= @ID_TIPO_DOC_REF	
		AND		SERIE_DOC			= @SERIE_DOC_REF
		AND		NRO_DOC				= @NRO_DOC_REF
	----------------------------------------------------------------------------------------------------------------
	SET	@ID_ESTADO_TDS=(SELECT ISNULL((SELECT ID_ESTADO FROM TIPO_DOCUMENTO_SERIE WHERE ID_TIPO_DOC=@ID_TIPO_DOC ),0))
	------------------------------------------------------------------------------------------------
	UPDATE	TIPO_DOCUMENTO_SERIE			/*		select * from TIPO_DOCUMENTO_SERIE */
		SET		CORRELATIVO			= CONVERT(INT, @NRO_DOC)		
		WHERE	CIA					= @CIA 	
		AND		ID_TIPO_DOC			= @ID_TIPO_DOC
		AND		SERIE				= @SERIE_DOC
		AND     ID_ESTADO			= @ID_ESTADO_TDS
	IF @@ERROR <> 0 OR @@ROWCOUNT <> 1
	BEGIN
		---------------------------------------
		SET		@VARMSG	= 'SE PRODUJO UN ERROR DURANTE EL PROCESO DE ACTUALIZAR DEL TIPO_DOCUMENTO_SERIE. NO SE ACTUALIZARON LOS DATOS.'
		GOTO	MSGERROR
		----------------------------------------
	END	
	----------------------------------------------------------------------------------------	
	DELETE	FROM ARTICULO_TEMP 		WHERE	SESION = @SESION	
	--------------------------------------------------------------------------------------------	
END
-----------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------
IF (@INDICADOR = '2')
BEGIN
		UPDATE	SERVICIO_TECNICO			
		SET		ID_MOTIVO_SERVICIO	= @ID_MOTIVO_SERVICIO,
				ID_CLIENTE			= @ID_CLIENTE,
				ID_PUNTO_VENTA		= @ID_PUNTO_VENTA,
				ID_CONTACTO			= @ID_CONTACTO,
				ID_TECNICO			= @ID_TECNICO_1,
				INFORMACION_TECNICA	= @INFORMACION_TECNICA,
				INICIO_SERVICIO		= @INICIO_SERVICIO,
				FIN_SERVICIO		= @FIN_SERVICIO,
				OBSERVACION			= @OBSERVACION,
				ID_ESTADO			= @ID_ESTADO, 				
				FM					= getdate(), 
				UM					= @Uc,
				ID_TIPO_DIAGNOSTICO	= @ID_TIPO_DIAGNOSTICO,
				ID_TIPO_SOLUCION	= @ID_TIPO_SOLUCION
		WHERE	CIA					= @CIA 	
		AND		SEDE				= @SEDE
		AND		ID_TIPO_DOC			= @ID_TIPO_DOC	
		AND		SERIE_DOC			= @SERIE_DOC
		AND		NRO_DOC				= @NRODOC		
	-------------------------------------------------------------------------------		
	DELETE	FROM SERVICIO_TECNICO_DETALLE 	WHERE	CIA=@CIA AND	SEDE=@SEDE	AND	
		ID_TIPO_DOC	= @ID_TIPO_DOC	AND	SERIE_DOC= @SERIE_DOC AND	NRO_DOC	= @NRODOC
	---------------------------------------------------------------------------------			
	INSERT	INTO SERVICIO_TECNICO_DETALLE			/*	sp_help SERVICIO_TECNICO_DETALLE	*/
	(
		CIA,SEDE,ID_TIPO_DOC,SERIE_DOC,NRO_DOC,ITEM,ID_ARTICULO,CANTIDAD,ID_TIPO_FAE,NRO_FAE,ID_ESTADO,SE,FC,UC
	)					/*		SELECT * FROM SERVICIO_TECNICO_DETALLE		*/			
	SELECT	@CIA,@SEDE,@ID_TIPO_DOC,@SERIE_DOC,@NRODOC,ITEM,ID_ARTICULO,CANTIDAD,@ID_TIPO_FAE,@NRO_FAE,@ID_ESTADO,@SEDE, GETDATE(), @UC	 
		FROM	ARTICULO_TEMP		WHERE	SESION = @SESION 		
end
-----------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------
IF (@INDICADOR = '3')
BEGIN
		UPDATE	SERVICIO_TECNICO			
		SET		ID_ESTADO			= '12', 				
				FE					= getdate(), 
				UE					= @Uc				
		WHERE	CIA					= @CIA 	
		AND		SEDE				= @SEDE
		AND		ID_TIPO_DOC			= @ID_TIPO_DOC	
		AND		SERIE_DOC			= @SERIE_DOC
		AND		NRO_DOC				= @NRODOC	
		IF @@ERROR <> 0 OR @@ROWCOUNT <> 1
		BEGIN
			---------------------------------------
			SET		@VARMSG	= 'SE PRODUJO UN ERROR DURANTE EL PROCESO DE ELIMINAR DEL SERVICIO_TECNICO. NO SE ACTUALIZARON LOS DATOS.'
			GOTO	MSGERROR
			----------------------------------------
		END	
		-------------------------------------------------------------------------------		
		UPDATE	SERVICIO_TECNICO_DETALLE		
		SET		ID_ESTADO			= '02', 				
				FE					= getdate(), 
				UE					= @Uc
		WHERE	CIA					= @CIA 	
		AND		SEDE				= @SEDE
		AND		ID_TIPO_DOC			= @ID_TIPO_DOC	
		AND		SERIE_DOC			= @SERIE_DOC
		AND		NRO_DOC				= @NRODOC	
END
-----------------------------------------------------------------------------------------------------
IF (@INDICADOR = '4')
BEGIN
		UPDATE	SERVICIO_TECNICO			
		SET		ID_ESTADO			= @ID_ESTADO, 				
				FM					= getdate(), 
				UM					= @Uc			
		WHERE	CIA					= @CIA 	
		AND		SEDE				= @SEDE
		AND		ID_TIPO_DOC			= @ID_TIPO_DOC	
		AND		SERIE_DOC			= @SERIE_DOC
		AND		NRO_DOC				= @NRODOC	
		IF @@ERROR <> 0 OR @@ROWCOUNT <> 1
		BEGIN
			---------------------------------------
			SET		@VARMSG	= 'SE PRODUJO UN ERROR DURANTE EL PROCESO DE ACTUALIZAR DEL SERVICIO_TECNICO. NO SE ACTUALIZARON LOS DATOS.'
			GOTO	MSGERROR
			----------------------------------------
		END	
		-----------------------------------------------------------------------------		
		UPDATE	SERVICIO_TECNICO_DETALLE		
		SET		ID_ESTADO			= '02', 				
				FM					= getdate(), 
				UM					= @Uc
		WHERE	CIA					= @CIA 	
		AND		SEDE				= @SEDE
		AND		ID_TIPO_DOC			= @ID_TIPO_DOC	
		AND		SERIE_DOC			= @SERIE_DOC
		AND		NRO_DOC				= @NRODOC		
		-------------------------------------------------------------------------------		@ID_TIPO_DOC_REF,@SERIE_DOC_REF,@NRO_DOC_REF	
		UPDATE	CRONOGRAMA_OPER		
		SET		ID_ESTADO			= @ID_ESTADO, 				
				FM					= getdate(), 
				UM					= @Uc
		WHERE	CIA					= @CIA 	
		AND		SEDE				= @SEDE
		AND		ID_TIPO_DOC			= @ID_TIPO_DOC_REF
		AND		SERIE_DOC			= @SERIE_DOC_REF
		AND		NRO_DOC				= @NRO_DOC_REF
		IF @@ERROR <> 0 OR @@ROWCOUNT <> 1
		BEGIN
			---------------------------------------
			SET		@VARMSG	= 'SE PRODUJO UN ERROR DURANTE EL PROCESO DE ACTUALIZAR DEL CRONOGRAMA_OPER. NO SE ACTUALIZARON LOS DATOS.'
			GOTO	MSGERROR
			----------------------------------------
		END		
		-------------------------------------------------------------------------------			
		UPDATE	CRONOGRAMA_OPER_DETALLE		
		SET		ID_ESTADO			= '02', 				
				FM					= getdate(), 
				UM					= @Uc
		WHERE	CIA					= @CIA 	
		AND		SEDE				= @SEDE
		AND		ID_TIPO_DOC			= @ID_TIPO_DOC_REF
		AND		SERIE_DOC			= @SERIE_DOC_REF
		AND		NRO_DOC				= @NRO_DOC_REF	
end
-----------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------
IF (@INDICADOR = '5')
BEGIN
		SELECT TOP 1 nro_doc FROM SERVICIO_TECNICO	WHERE CIA=@CIA 	AND	SEDE=@SEDE AND 
				ID_TIPO_DOC=@ID_TIPO_DOC AND SERIE_DOC=@SERIE_DOC		
		ORDER BY nro_doc desc	
end		
----------------------------------------------------------------------------------------	


--------------------------------------------------------------------------------------------------------------------------------
IF (@INDICADOR = '6')
BEGIN
	
	-----------------------------------------------------
	INSERT	INTO SERVICIO_TECNICO			/*	sp_help SERVICIO_TECNICO	*/
	(
		CIA, SEDE,ID_TIPO_DOC,SERIE_DOC,NRO_DOC,ID_MOTIVO_SERVICIO,FECHA,ID_CLIENTE,ID_PUNTO_VENTA,ID_CONTACTO,
		ID_TECNICO,INFORMACION_TECNICA,INICIO_SERVICIO,FIN_SERVICIO,OBSERVACION,ID_ESTADO,FLAG_ENVIO,SE,FC,UC,FECHA_INICIO_SERVICIO,
		ID_TIPO_DOC_OP,SERIE_DOC_OP,NRO_DOC_OP,	ID_TIPO_DIAGNOSTICO,ID_TIPO_SOLUCION,ID_TECNICO_2,ID_TECNICO_3,ID_TECNICO_4
	)
	VALUES				/*		SELECT * FROM SERVICIO_TECNICO		*/
	(
		@CIA, @SEDE,@ID_TIPO_DOC,@SERIE_DOC,@NRODOC,@ID_MOTIVO_SERVICIO,GETDATE(),@ID_CLIENTE,@ID_PUNTO_VENTA,@ID_CONTACTO,
		@ID_TECNICO_1,@INFORMACION_TECNICA,@INICIO_SERVICIO,@FIN_SERVICIO,@OBSERVACION,'11','1',@SEDE,GETDATE(),@UC,GETDATE(),
		@ID_TIPO_DOC_REF,@SERIE_DOC_REF,@NRO_DOC_REF,@ID_TD,@ID_TS,@TECNICO_2,@TECNICO_3,@TECNICO_4
	)
	-------------------------------------------
	IF @@ERROR <> 0 OR @@ROWCOUNT <> 1
	BEGIN
		---------------------------------------
		SET		@VARMSG	= 'SE PRODUJO UN ERROR DURANTE EL PROCESO DE GRABACION DEL SERVICIO_TECNICO. NO SE GRABARON LOS DATOS.'
		GOTO	MSGERROR
		----------------------------------------
	END
	---------------------------------------------------------------------------------		
	---------------------------------------------------------------------------------	
	INSERT	INTO SERVICIO_TECNICO_DETALLE		
	(
		CIA,SEDE,ID_TIPO_DOC,SERIE_DOC,NRO_DOC,ITEM,ID_ARTICULO,CANTIDAD,ID_TIPO_FAE,NRO_FAE,ID_ESTADO,FLAG_ENVIO,SE,FC,UC--,DES_ARTICULO
	)							
	SELECT	@CIA,@SEDE,@ID_TIPO_DOC,@SERIE_DOC,@NRODOC,ITEM,ID_ARTICULO,CANTIDAD,@ID_TIPO_FAE,@NRO_FAE,'01','1',@SEDE, GETDATE(), @UC--,@DES_ARTICULO		 
		FROM	ARTICULO_TEMP		WHERE	SESION = @SESION 
	---------------------------------------------------------------------------------------------------------	
		UPDATE	CRONOGRAMA_OPER			/*		select * from CRONOGRAMA_OPER */
		SET		FLAG_ST				= '1'		
		WHERE	CIA					= @CIA 	
		AND		SEDE				= @SEDE
		AND		ID_TIPO_DOC			= @ID_TIPO_DOC_REF	
		AND		SERIE_DOC			= @SERIE_DOC_REF
		AND		NRO_DOC				= @NRO_DOC_REF
	----------------------------------------------------------------------------------------------------------------
	SET	@ID_ESTADO_TDS=(SELECT ISNULL((SELECT ID_ESTADO FROM TIPO_DOCUMENTO_SERIE WHERE ID_TIPO_DOC=@ID_TIPO_DOC ),0))
	SET @NRO_DOC_ING=(SELECT ISNULL ((SELECT count(NRO_DOC) FROM SERVICIO_TECNICO WHERE CIA=@CIA AND SEDE =@SEDE
						AND ID_TIPO_DOC= @ID_TIPO_DOC	AND SERIE_DOC= @SERIE_DOC),0))
	------------------------------------------------------------------------------------------------
	UPDATE	TIPO_DOCUMENTO_SERIE			/*		select * from TIPO_DOCUMENTO_SERIE */
		SET		CORRELATIVO			= CONVERT(INT, @NRO_DOC_ING)		
		WHERE	CIA					= @CIA 	
		AND		ID_TIPO_DOC			= @ID_TIPO_DOC
		AND		SERIE				= @SERIE_DOC
		AND     ID_ESTADO			= @ID_ESTADO_TDS
	IF @@ERROR <> 0 OR @@ROWCOUNT <> 1
	BEGIN
		---------------------------------------
		SET		@VARMSG	= 'SE PRODUJO UN ERROR DURANTE EL PROCESO DE ACTUALIZAR DEL TIPO_DOCUMENTO_SERIE. NO SE ACTUALIZARON LOS DATOS.'
		GOTO	MSGERROR
		----------------------------------------
	END	
	----------------------------------------------------------------------------------------	
	DELETE	FROM ARTICULO_TEMP 		WHERE	SESION = @SESION	
	--------------------------------------------------------------------------------------------	
END
-----------------------------------------------------------------------------------------------------

COMMIT TRANSACTION
------------------------------------------------
RETURN
MSGERROR:
		ROLLBACK TRANSACTION
		----------------------------------------
		RAISERROR	(@VARMSG, 15, 1)
		RETURN
GO
/****** Object:  StoredProcedure [dbo].[SP_ORDEN_SERVTECNICO_TRAER]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
SP_HELP SERVICIO_TECNICO
SP_ORDEN_SERVTECNICO_TRAER '1','01','01','28','0001','' 
SP_ORDEN_SERVTECNICO_TRAER '2','01','01','28','0001','' 
 


go
SP_LISTAR_ARTICULO_TEMP '','01','02'
SELECT ID_MARCA,* FROM ARTICULO
select * from dbo.SERVICIO_TECNICO  where cia='01'  and sede='01' and id_tipo_doc='28' 	and serie_doc='0001'  and nro_doc='00000002' 
select * from dbo.SERVICIO_TECNICO_DETALLE 	where cia='01'  and sede='01' and id_tipo_doc='28' and serie_doc='0001'  and nro_doc='00001008'
*/
CREATE  PROC [dbo].[SP_ORDEN_SERVTECNICO_TRAER]
@INDICADOR		CHAR(1),
@CIA			CHAR(2),
@SEDE			CHAR(2),
@ID_TIPO_DOC	CHAR(2),
@SERIE_DOC		CHAR(4),
@NRO_DOC		VARCHAR(20)
AS
--------------------------------------------------------------------------
DECLARE @sSelect varchar(MAX),@sFiltroID varchar(MAX), @sOrderBy varchar(MAX),@sGroupBy varchar(MAX),@sExecute varchar(MAX)
-----------------------------------------------------------------------------------------------------
SELECT @sSelect='', @sFiltroID='',@sOrderBy='',@sGroupBy='',@sExecute=''
-------------------------------------------------------------------------------------------------------
IF(@INDICADOR='1')
BEGIN
	SELECT @sSelect='
		ST.ID_TIPO_DOC,ST.SERIE_DOC,ST.NRO_DOC,ST.ID_MOTIVO_SERVICIO,
		FECHA=convert(varchar(10),ST.FECHA,103),ST.ID_CLIENTE,ST.ID_PUNTO_VENTA,ST.ID_CONTACTO,ST.ID_TECNICO,ST.INFORMACION_TECNICA,
		INICIO_SERVICIO=convert(varchar(10),ST.INICIO_SERVICIO,103),
		FIN_SERVICIO=convert(varchar(10),ST.FIN_SERVICIO,103),
		ST.ID_ESTADO,ST.ID_TIPO_DIAGNOSTICO,ST.ID_TIPO_SOLUCION,STD.NRO_FAE,
		hora_inicio=convert(char(5),ST.INICIO_SERVICIO, 114) ,hora_fin=convert(char(5),ST.FIN_SERVICIO, 114),
		ST.id_tecnico_2,ST.id_tecnico_3,ST.id_tecnico_4,st.id_tipo_doc_op,st.serie_doc_op,st.nro_doc_op
		FROM SERVICIO_TECNICO ST		
		left JOIN SERVICIO_TECNICO_DETALLE STD ON STD.CIA=ST.CIA AND STD.SEDE=ST.SEDE AND 
		STD.ID_TIPO_DOC=ST.ID_TIPO_DOC AND STD.SERIE_DOC=ST.SERIE_DOC AND STD.NRO_DOC=ST.NRO_DOC		
		WHERE ST.CIA='''+@CIA+''' AND ST.SEDE='''+@SEDE+'''	AND	ST.ID_TIPO_DOC='''+@ID_TIPO_DOC+'''
		AND	ST.SERIE_DOC='''+@SERIE_DOC+'''	  '
	------------------------------------------------------------------------------------------------------------------
	IF  LEN(ISNULL(@nro_doc,''))>0 
			BEGIN 	   SELECT @sFiltroID =' and st.nro_doc  in('''+@nro_doc+''')'		 END
	ELSE	BEGIN       SELECT @sFiltroID=''	END
	-------------------------------------------------------------------------
	SELECT @sGroupBy	='	'  
	SELECT @sOrderBy	=' ORDER BY ST.nro_doc'
	---------------------------------------------------------------------------------------------
	SELECT @sExecute = @sSelect  +''+   @sFiltroID  +''+@sGroupBy +''+@sOrderBy
 	PRINT @sExecute
	EXEC ('SELECT '+ @sExecute )	
END
----------------------------------------------------------------------------------------------------------------
IF(@INDICADOR='2')
BEGIN
	SELECT @sSelect='
		STD.item,STD.id_articulo as ''id_articulo'',A.nro_parte,A.descripcion as ''descripcion'',
		upper(um.abreviatura) as ''unidad'', cantidad,upper(ma.descripcion)as ''marca''	
		FROM SERVICIO_TECNICO ST
		INNER JOIN SERVICIO_TECNICO_DETALLE STD ON STD.CIA=ST.CIA AND STD.SEDE=ST.SEDE AND 
		STD.ID_TIPO_DOC=ST.ID_TIPO_DOC AND STD.SERIE_DOC=ST.SERIE_DOC AND STD.NRO_DOC=ST.NRO_DOC
		INNER JOIN ARTICULO A ON A.CIA=STD.CIA AND A.ID_ARTICULO=STD.ID_ARTICULO
		INNER JOIN UNIDAD_MEDIDA UM ON UM.CIA=A.CIA AND UM.ID_UNIDAD=A.ID_UNIDAD
		LEFT JOIN MARCA_ARTICULO  MA ON MA.CIA=A.CIA AND MA.ID_MARCA=A.ID_MARCA
		WHERE ST.CIA='''+@CIA+''' AND ST.SEDE='''+@SEDE+'''	AND	ST.ID_TIPO_DOC='''+@ID_TIPO_DOC+'''
		AND	ST.SERIE_DOC='''+@SERIE_DOC+'''	AND	ST.NRO_DOC LIKE '''+@NRO_DOC+'''	'
	-------------------------------------------------------------------------
	SELECT @sGroupBy=''  
	SELECT @sOrderBy	=' ORDER BY ST.nro_doc'
	---------------------------------------------------------------------------------------------
	SELECT @sExecute = @sSelect  +''+  @sGroupBy +''+@sOrderBy
 	PRINT @sExecute
	EXEC ('SELECT '+ @sExecute )	 
 END
GO
/****** Object:  StoredProcedure [dbo].[SP_PREMIO_ACTUALIZAR]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
sp_help INVENTARIO_MOV
SELECT * FROM INVENTARIO_MOV where id_tipo_doc='ni' AND NRO_DOC='00000001'
SELECT * FROM INVENTARIO_MOV_Det where id_tipo_doc='ni' AND NRO_DOC='00000001'
[SP_A_PREMIO_ACTUALIZAR_ENTREGA_PREMIO]
'01','02','NI','0001','00000001','aaa','20521849160','ADMIN'
*/
  ----------------------------------------------------------------
  
create	PROC	[dbo].[SP_PREMIO_ACTUALIZAR]
@CIA				CHAR(2),
@SEDE				CHAR(2),
@ID_TIPO_DOC		CHAR(2),
@SERIE_DOC			varchar(4),
@NRO_DOC			VARCHAR(20),
@GLOSA				VARCHAR(MAX),
@ID_ANALITICA		VARCHAR(20),
@UM				 	VARCHAR(25)
AS
-----------------------------------------------
DECLARE @VARMSG			VARCHAR(MAX)
DECLARE	@COUNT			INT
DECLARE	@FECHA_ACTUAL	DATETIME
----------------------------------------------
SET		@FECHA_ACTUAL	=	GETDATE()
-----------------------------------------------
BEGIN TRANSACTION
		-------------------------------------------
	UPDATE	INVENTARIO_MOV
	SET		GLOSA				= @GLOSA,
			ID_ANALITICA		= @ID_ANALITICA, 
			FM					= @FECHA_ACTUAL, 
			UM					= @UM
	WHERE	CIA					= @CIA 
	AND		SEDE				= @SEDE 
	AND		ID_TIPO_DOC			= @ID_TIPO_DOC
	AND	    SERIE_DOC			= @SERIE_DOC
	AND		NRO_DOC				= @NRO_DOC
	-------------------------------------------
	IF @@ERROR <> 0 OR @@ROWCOUNT <> 1
	BEGIN
		---------------------------------------
		SET		@VARMSG	= 'SE PRODUJO UN ERROR DURANTE EL PROCESO DE ACTUALIZACION DEL PREMIO. NO SE GRABARON LOS DATOS.'
		GOTO	MSGERROR
		----------------------------------------
	END 
	ELSE
	BEGIN
		----------------------------------------
		SET	@VARMSG				= 'DATOS ACTUALIZADOS.'		
		----------------------------------------
	END		
	--------------------------------------------
	-------------------------------------------
	--UPDATE	INVENTARIO_MOV_Det
	--SET		
		 
	--		FM					= @FECHA_ACTUAL, 
	--		UM					= @UM
	--WHERE	CIA					= @CIA 
	--AND		SEDE				= @SEDE 
	--AND		ID_TIPO_DOC			= @ID_TIPO_DOC
	--AND	    SERIE_DOC			= @SERIE_DOC
	--AND		NRO_DOC				= @NRO_DOC	
	---------------------------------------------
	--IF @@ERROR <> 0 OR @@ROWCOUNT <> 1
	--BEGIN
	--	---------------------------------------
	--	SET		@VARMSG	= 'SE PRODUJO UN ERROR DURANTE EL PROCESO DE ACTUALIZACION DEL PREMIO DET. NO SE GRABARON LOS DATOS.'
	--	GOTO	MSGERROR
	--		----------------------------------------
	--END 
	--ELSE
	--BEGIN
	--	----------------------------------------
	--	SET	@VARMSG				= 'DATOS ACTUALIZADOS.'		
	--	----------------------------------------
	--END	
	--------------------------------------------
COMMIT TRANSACTION
------------------------------------------------
RETURN
MSGERROR:
		ROLLBACK TRANSACTION
		----------------------------------------
		RAISERROR	(@VARMSG, 15, 1)		
		RETURN
GO
/****** Object:  StoredProcedure [dbo].[SP_PREMIO_ELIMINAR]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*

SELECT ID_ESTADO,* FROM INVENTARIO_MOV where id_tipo_doc ='NI'
SELECT ID_ESTADO,* FROM INVENTARIO_MOV_DET where id_tipo_doc ='NI' 

UPDATE INVENTARIO_MOV SET ID_ESTADO='01'  where id_tipo_doc ='NI'
UPDATE INVENTARIO_MOV_DET SET ID_ESTADO='01'  where id_tipo_doc ='NI'

SELECT * FROM EXISTENCIA_SEDE			SELECT * FROM EXISTENCIA_ALMACEN				
[SP_PREMIO_ELIMINAR] '01','01','NI','0001','00001088','ES','ADMIN'
*/
-----------------------------------------------
-----------------------------------------------
CREATE	PROCEDURE	[dbo].[SP_PREMIO_ELIMINAR]
@CIA				CHAR(2),
@SEDE				CHAR(2),
@ID_TIPO_DOC		char(2),
@SERIE_DOC			varchar(4),
@NRO_DOC			VARCHAR(25),
@ID_ALMACEN			CHAR(2),
@UA					VARCHAR(10)
AS	
-----------------------------------------------
DECLARE @VARMSG			VARCHAR(MAX)
DECLARE	@COUNT		INT
DECLARE	@CANTIDAD	FLOAT
DECLARE @TOTAL_DEV	FLOAT
-----------------------------------------------
BEGIN TRANSACTION
	---------------------------------------------
--PRINT @CIA +'-'+@SEDE+'-'+@ID_TIPO_DOC+'-'+@SERIE_DOC+'-'+@NRO_DOC+'-'+@ID_ALMACEN	
	UPDATE	INVENTARIO_MOV
	SET		ID_ESTADO	= '02',	
			FA			= GETDATE(), 
			UA			= @UA			
	WHERE	CIA			= @CIA 
	AND		SEDE		= @SEDE 
	AND		ID_TIPO_DOC	= @ID_TIPO_DOC
	AND		SERIE_DOC	= @SERIE_DOC
	AND		NRO_DOC		= @NRO_DOC 
--------------------------------------------------------------------------------------------------------------
	UPDATE	INVENTARIO_MOV_DET
	SET		ID_ESTADO	= '02',	
			FA			= GETDATE(), 
			UA			= @UA			
	WHERE	CIA			= @CIA
	AND		SEDE		= @SEDE
	AND		ID_TIPO_DOC	= @ID_TIPO_DOC
	AND		SERIE_DOC	= @SERIE_DOC
	AND		NRO_DOC		= @NRO_DOC	
	--------------------------------------------------------------------------
	UPDATE	EX_S				/*	select *  from EXISTENCIA_SEDE	*/
	SET		EX_S.CANT_DISPONIBLE = (EX_S.CANT_DISPONIBLE - IDT.CANTIDAD)
	FROM	EXISTENCIA_SEDE EX_S 
	INNER JOIN INVENTARIO_MOV_DET IDT ON EX_S.CIA=IDT.CIA AND EX_S.SEDE=IDT.SEDE 
			AND EX_S.ID_ARTICULO=IDT.ID_ARTICULO 
	WHERE	EX_S.CIA=@CIA	 AND	 EX_S.SEDE=@SEDE 	AND 	IDT.NRO_DOC=@NRO_DOC
	------------------------------------------------------------------------------------------------
	UPDATE	EX_A					/*	select *  from EXISTENCIA_ALMACEN	*/
	SET		EX_A.CANT_DISPONIBLE = (EX_A.CANT_DISPONIBLE - IDT.CANTIDAD)
	FROM	EXISTENCIA_ALMACEN EX_A 
	INNER JOIN INVENTARIO_MOV_DET IDT ON EX_A.CIA=IDT.CIA AND EX_A.SEDE=IDT.SEDE
			 AND EX_A.ID_ARTICULO = IDT.ID_ARTICULO 
	WHERE	EX_A.CIA = @CIA
	AND		EX_A.SEDE= @SEDE AND EX_A.ID_ALMACEN=@ID_ALMACEN	AND		IDT.NRO_DOC=@NRO_DOC
	--------------------------------------------	
	COMMIT TRANSACTION
------------------------------------------------
RETURN
MSGERROR:
		ROLLBACK TRANSACTION
		----------------------------------------
		RAISERROR	(@VARMSG, 15, 1)
		RETURN
GO
/****** Object:  StoredProcedure [dbo].[SP_PREMIO_INSERTAR]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
SP_HELP INVENTARIO_MOV		SP_HELP INVENTARIO_MOV_DET
SP_HELP existencia_sede		SP_HELP	TIPO_DOCUMENTO_SERIE

select * from dbo.almacen					where ID_ALMACEN ='ES' 
select * from rcidat.dbo.existencia_almacen where ID_ALMACEN ='ES' 
select * from rcidat.dbo.existencia_sede	
select * from ARTICULO_TEMP	

SELECT * FROM INVENTARIO_MOV where id_tipo_doc ='NI'
SELECT * FROM INVENTARIO_MOV_DET where id_tipo_doc ='NI'
SELECT * FROM TIPO_DOCUMENTO_SERIE where id_tipo_doc ='NI'

delete FROM INVENTARIO_MOV where id_tipo_doc ='NI'
delete FROM INVENTARIO_MOV_DET where id_tipo_doc ='NI'
update TIPO_DOCUMENTO_SERIE set correlativo=0 where id_tipo_doc ='ni' and serie='0001' 
delete FROM aRTICULO_TEMP	

[SP_PREMIO_INSERTAR] 
'ab30ca69-dc29-449e-9101-20aa6d41794c','01','01','NI','0001','00001088','EI','02','ES','20517033830','1','FI','admin','2.802','sssssssssss'
*/
-------------------------------------------
CREATE	PROC	[dbo].[SP_PREMIO_INSERTAR]
@SESION	VARCHAR(max),@CIA CHAR(2),@SEDE CHAR(2),@ID_TIPO_DOC CHAR(2),@SERIE_DOC	VARCHAR(4),@NRODOC	varchar(20),
@ID_MOTIVO_ALMACEN	CHAR(2),@ID_MONEDA CHAR(2),@ID_ALMACEN CHAR(2),@ID_ANALITICA VARCHAR(20),
@FLAG_INGRESO	CHAR(1), -- 0 = SI ES SALIDA, 1 = SI ES ENTRADA
@ID_MODULO CHAR(2),@UC VARCHAR(10),@TIPO_CAMBIO FLOAT ,@OBSERVACION	VARCHAR(MAX)
AS
-------------------------------------------
DECLARE @VARMSG	VARCHAR(MAX),@NRO_DOC varchar(20),@COUNT INT,@CORRELATIVO INT,@COUNT_ES	INT,
		@ID_ESTADO_TDS	CHAR(2),@COUNT_EA INT,@CIA_2 CHAR(2),@SEDE_2 CHAR(2),@ID_ARTICULO VARCHAR(20),@CANTIDAD FLOAT
-----------------------------------------------------------------------------------------------
SET	@NRO_DOC	=	(	SELECT ISNULL((SELECT	(REPLICATE('0',(8 - LEN(CORRELATIVO + 1))) + CONVERT(VARCHAR(8),(CORRELATIVO + 1)))
						FROM	TIPO_DOCUMENTO_SERIE	WHERE	CIA=@CIA AND ID_TIPO_DOC=@ID_TIPO_DOC AND SERIE=@SERIE_DOC
						AND		ID_ESTADO	= '01'),'00000001')
					)
-------------------------------------------
BEGIN TRANSACTION
-------------------------------------------
DECLARE	CURSOR_PROD CURSOR FOR
	SELECT	CIA, SEDE, ID_ARTICULO, CANTIDAD FROM ARTICULO_TEMP	WHERE	SESION	= @SESION AND CIA=@CIA AND	SEDE=@SEDE
OPEN CURSOR_PROD
FETCH NEXT FROM CURSOR_PROD
	INTO @CIA_2, @SEDE_2, @ID_ARTICULO, @CANTIDAD
WHILE @@FETCH_STATUS = 0
BEGIN
	----------------------------------------
	SET @COUNT_ES = (SELECT ISNULL ((SELECT COUNT(*) FROM  EXISTENCIA_SEDE WHERE CIA = @CIA_2 AND SEDE = @SEDE_2 AND ID_ARTICULO = @ID_ARTICULO),0))
	SET	@COUNT_EA = (SELECT ISNULL ((SELECT COUNT(*) FROM  EXISTENCIA_ALMACEN WHERE CIA = @CIA_2 AND SEDE = @SEDE_2 AND ID_ARTICULO = @ID_ARTICULO AND ID_ALMACEN = @ID_ALMACEN),0))
	----------------------------------------
	/*	EXISTENCIA SEDE	*/
	IF(@COUNT_ES = 0)
	BEGIN
		------------------------------------
		INSERT	INTO EXISTENCIA_SEDE
		(	CIA, SEDE, ID_ARTICULO, CANT_DISPONIBLE, ID_ESTADO, FLAG_ENVIO, SE, FC, UC	)
		VALUES
		(	@CIA_2, @SEDE_2, @ID_ARTICULO, @CANTIDAD, '01', '1', @SEDE_2, GETDATE(), @UC	)
		IF @@ERROR <> 0 OR @@ROWCOUNT <> 1
		BEGIN
			--------------------------------
			SET		@VARMSG	= 'ERROR AL INSERTAR DATOS EN EXISTENCIA SEDE. NO SE GRABARON LOS DATOS.'
			GOTO	MSGERROR
			--------------------------------
		END
		------------------------------------
	END
	-----------------------------------------------------------------------------------------------------
	ELSE
	BEGIN
		------------------------------------
		UPDATE	EXISTENCIA_SEDE
		SET		CANT_DISPONIBLE	= CANT_DISPONIBLE + @CANTIDAD,
				FM				= GETDATE(),
				UM				= @UC
		WHERE	CIA				= @CIA_2
		AND		SEDE			= @SEDE_2
		AND		ID_ARTICULO		= @ID_ARTICULO
		IF @@ERROR <> 0 OR @@ROWCOUNT <> 1
		BEGIN
			--------------------------------
			SET		@VARMSG	= 'ERROR AL ACTUALIZAR DATOS EN EXISTENCIA SEDE. NO SE GRABARON LOS DATOS.'
			GOTO	MSGERROR
			--------------------------------
		END
		------------------------------------
	END
	----------------------------------------
	/*	EXISTENCIA ALMACEN	*/
	IF(@COUNT_EA = 0)
	BEGIN
		------------------------------------
		INSERT	INTO EXISTENCIA_ALMACEN
		(	CIA, SEDE, ID_ARTICULO, ID_ALMACEN,CANT_DISPONIBLE, ID_ESTADO, FLAG_ENVIO, SE, FC, UC	)
		VALUES
		(	@CIA_2, @SEDE_2, @ID_ARTICULO, @ID_ALMACEN, @CANTIDAD, '01', '1', @SEDE, GETDATE(), @UC	)
		IF @@ERROR <> 0 OR @@ROWCOUNT <> 1
		BEGIN
			--------------------------------
			SET		@VARMSG	= 'ERROR AL INSERTAR DATOS EN EXISTENCIA ALMACEN. NO SE GRABARON LOS DATOS.'
			GOTO	MSGERROR
			--------------------------------
		END
		------------------------------------
	END
	------------------------------------------------------------------------------------------------------------
	ELSE
	BEGIN
		------------------------------------
		UPDATE	EXISTENCIA_ALMACEN
		SET		CANT_DISPONIBLE	= CANT_DISPONIBLE + @CANTIDAD,
				FM				= GETDATE(),
				UM				= @UC
		WHERE	CIA				= @CIA_2
		AND		SEDE			= @SEDE_2
		AND		ID_ARTICULO		= @ID_ARTICULO
		AND		ID_ALMACEN		= @ID_ALMACEN
		IF @@ERROR <> 0 OR @@ROWCOUNT <> 1
		BEGIN
			--------------------------------
			SET		@VARMSG	= 'ERROR AL ACTUALIZAR DATOS EN EXISTENCIA ALMACEN. NO SE GRABARON LOS DATOS.'
			GOTO	MSGERROR
			--------------------------------
		END
		------------------------------------
	END
	----------------------------------------
	FETCH NEXT FROM CURSOR_PROD 
	INTO @CIA_2, @SEDE_2, @ID_ARTICULO, @CANTIDAD
	----------------------------------------
END
CLOSE CURSOR_PROD
DEALLOCATE CURSOR_PROD
--------------------------------------------
		/*	INVENTARIO MOV	*/
		INSERT	INTO INVENTARIO_MOV
		(	 
			CIA,SEDE,ID_TIPO_DOC,SERIE_DOC,NRO_DOC,ID_MOTIVO_ALMACEN,FECHA,ID_MONEDA,ID_ALMACEN,ID_ANALITICA,
			FLAG_INGRESO,ID_MODULO,ANIO,MES,ID_ESTADO,FLAG_ENVIO,SE,FC,UC,TIPO_CAMBIO,OBSERVACION
		)
		VALUES
		(
			@CIA,@SEDE,@ID_TIPO_DOC,@SERIE_DOC,@NRODOC,@ID_MOTIVO_ALMACEN,GETDATE(),@ID_MONEDA,@ID_ALMACEN,@ID_ANALITICA,
			@FLAG_INGRESO,@ID_MODULO,YEAR(GETDATE()),MONTH(GETDATE()),'11','1',@SEDE,GETDATE(),@UC,@TIPO_CAMBIO,@OBSERVACION
		)
		IF @@ERROR <> 0 OR @@ROWCOUNT <> 1
		BEGIN
			---------------------------------------
			SET		@VARMSG	= 'SE PRODUJO UN ERROR DURANTE EL PROCESO DE GRABACION DE LA NOTA ENTRADA. NO SE GRABARON LOS DATOS.'
			GOTO	MSGERROR
			----------------------------------------
		END
		-----------------------------------------------------------------------------------------------------------------------------------
		SET	@COUNT =(SELECT ISNULL((SELECT COUNT(*)FROM articulo_temp	WHERE SESION = @SESION AND CIA = @CIA AND SEDE = @SEDE),0))
		----------------------------------------------------------------------------------------------------------------------------------
		INSERT INTO INVENTARIO_MOV_DET			--		SELECT * FROM INVENTARIO_DET_MOV_TEMP	
		(
			CIA, SEDE, ID_TIPO_DOC, SERIE_DOC, NRO_DOC, ITEM, ITEM_DIGITADO, ID_ARTICULO, CANTIDAD, CANTIDAD_USADA, ID_ESTADO, FLAG_ENVIO,SE, FC, UC
		)
		SELECT	@CIA, @SEDE, @ID_TIPO_DOC, @SERIE_DOC, @NRODOC, ITEM, ITEM, ID_ARTICULO, CANTIDAD, CANTIDAD, '11', '1', @SEDE, GETDATE(), @UC 
			FROM	ARTICULO_TEMP			WHERE	SESION = @SESION 
		IF @@ERROR <> 0 OR @@ROWCOUNT <> @COUNT
		BEGIN
			---------------------------------------
			SET		@VARMSG	= 'SE PRODUJO UN ERROR DURANTE EL PROCESO DE GRABACION DEL INVENTARIO_MOV_DET. NO SE GRABARON LOS DATOS.'
			GOTO	MSGERROR
			----------------------------------------
		END			
		----------------------------------------------------------------------------------------------------------------
		SET	@ID_ESTADO_TDS=(SELECT ISNULL((SELECT ID_ESTADO FROM TIPO_DOCUMENTO_SERIE WHERE ID_TIPO_DOC=@ID_TIPO_DOC ),0))
		------------------------------------------------------------------------------------------------
		UPDATE	TIPO_DOCUMENTO_SERIE			/*		select * from TIPO_DOCUMENTO_SERIE */
				SET		CORRELATIVO			= CONVERT(INT, @NRO_DOC)		
				WHERE	CIA					= @CIA 	
				AND		ID_TIPO_DOC			= @ID_TIPO_DOC
				AND		SERIE				= @SERIE_DOC
				AND     ID_ESTADO			= @ID_ESTADO_TDS
		IF @@ERROR <> 0 OR @@ROWCOUNT <> 1
		BEGIN
			---------------------------------------
			SET		@VARMSG	= 'SE PRODUJO UN ERROR DURANTE EL PROCESO DE ACTUALIZAR DEL TIPO_DOCUMENTO_SERIE. NO SE ACTUALIZARON LOS DATOS.'
			GOTO	MSGERROR
			----------------------------------------
		END
		--------------------------------------------
			DELETE	FROM articulo_temp WHERE	SESION = @SESION
--------------------------------------------
COMMIT TRANSACTION
--------------------------------------------
RETURN
MSGERROR:
		ROLLBACK TRANSACTION
		------------------------------------
		CLOSE CURSOR_PROD
		DEALLOCATE CURSOR_PROD
		RAISERROR	(@VARMSG, 15, 1)
		RETURN
GO
/****** Object:  StoredProcedure [dbo].[SP_PREMIO_LISTAR]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
sp_help INVENTARIO_MOV
SELECT * FROM analitica
SELECT * FROM motivo_almacen
SELECT * FROM almacen
SELECT * FROM TIPO_DOCUMENTO 
SELECT * FROM INVENTARIO_MOV	where id_tipo_doc='NI'
SELECT * FROM INVENTARIO_MOV_DET	where id_tipo_doc='NI'
SELECT * FROM TOMA_INVENTARIO
[SP_PREMIO_LISTAR] '1','01','01','NI','0001','00001088','','','','','','','','','','','',''
[SP_PREMIO_LISTAR] '2','01','01','NI','0001','00001088','','','','','','','','','','','',''

*/
---------------------------------------------------------------
CREATE  PROC [dbo].[SP_PREMIO_LISTAR]
@INDICADOR CHAR(1),@CIA CHAR(2),@SEDE CHAR(2),@ID_TIPO_DOC CHAR(2),@SERIE_DOC CHAR(4),@NRO_DOC VARCHAR(20),
@id_motivo_almacen	CHAR(2), @fec_ini datetime, @fec_fin DATETIME, @GLOSA VARCHAR(MAX), @id_moneda CHAR(2),@id_almacen CHAR(2),
@id_analitica VARCHAR(20),@analitica_nom VARCHAR(MAX),  @id_modulo char(2), @anio VARCHAR(4), @MES CHAR(2),@id_estado CHAR(2)
AS
-----------------------------------------------------------------------------------------------------------------------
DECLARE @FECHA1 VARCHAR(8),@FECHA2 VARCHAR(8),@sSelect varchar(MAX),
	@sFiltro_IdTipoDoc varchar(MAX),@sFiltro_SerieDoc varchar(MAX),@sFiltro_NroDoc varchar(MAX),@sFiltro_IdMotivoAlmacen varchar(MAX),
	@sFiltro_Fecha varchar(MAX),@sFiltro_Glosa varchar(MAX),@sFiltro_IdMoneda varchar(MAX),@sFiltro_IdAlmacen varchar(MAX),	
	@sFiltro_Analitica varchar(MAX),@sFiltro_IdModulo varchar(MAX),@sFiltro_Anio varchar(MAX),@sFiltro_Mes varchar(MAX),@sFiltro_Estado varchar(MAX),
	@sFiltro_TipoCambio varchar(MAX),@sOrderBy varchar(MAX), @sGroupBy varchar(MAX), @sExecute varchar(MAX)
----------------------------------------------------------------------------------------------------------------------
SET @FECHA1 = CONVERT(VARCHAR(8),@fec_ini,112)
SET @FECHA2 = CONVERT(VARCHAR(8),@fec_fin,112)
SELECT @sSelect='', @sFiltro_IdTipoDoc='', @sFiltro_SerieDoc='', @sFiltro_NroDoc='', @sFiltro_Fecha='',@sFiltro_Glosa ='',
		@sFiltro_IdMoneda ='',@sFiltro_IdAlmacen='',  @sFiltro_Analitica='', @sFiltro_IdModulo='', @sFiltro_Anio='',
		 @sFiltro_Mes='',@sFiltro_Estado ='', @sFiltro_TipoCambio ='',   @sOrderBy='',@sGroupBy='',@sExecute=''
-----------------------------------------------------------------------------------------------------------------
IF(@INDICADOR='1')
BEGIN
	SELECT @sSelect='
		IM.id_tipo_doc,IM.serie_doc,IM.nro_doc,IM.serie_doc + ''-'' + IM.nro_doc ''numero-doc'', 
		IM.id_motivo_almacen,MA.descripcion ''motivo_almacen_descripcion'',fecha_hora=CONVERT(VARCHAR(10),IM.fecha,103) +space(2)+convert(char(5),IM.fecha, 114),	
		IM.observacion,IM.id_moneda,UPPER(m.descripcion) ''descripcion_moneda'',m.abreviatura ''abreviatura_moneda'',
		IM.id_almacen,UPPER(ALM.descripcion) ''descripcion_almacen'',ALM.direccion ''direccion_almacen'',
		IM.id_analitica,UPPER(a.descripcion) ''descripcion_analitica'',a.direccion ''direccion_analitica'',
		IM.id_punto_venta,IM.id_tipo_doc_ref,IM.serie_doc_ref,IM.nro_doc_ref,IM.id_transportista,IM.id_conductor,IM.id_vehiculo,
		IM.id_modulo,IM.anio,IM.mes,DATENAME(MONTH,IM.FECHA) ''nom_mes'',IM.id_estado,e.abreviatura ''estado'',IM.tipo_cambio,
		fecha=CONVERT(VARCHAR(10),IM.fecha,103),hora=convert(char(5),IM.fecha, 114) FROM INVENTARIO_MOV IM
		LEFT JOIN motivo_almacen  MA ON MA.cia=IM.cia and MA.id_motivo_almacen=IM.id_motivo_almacen 
		LEFT JOIN estado e ON e.cia=IM.cia and e.id_estado=IM.id_estado 
		LEFT JOIN moneda M on M.cia=IM.cia and M.id_moneda=IM.id_moneda
		LEFT JOIN almacen ALM on ALM.cia=IM.cia and  ALM.sede=IM.sede and ALM.id_almacen=IM.id_almacen
		INNER JOIN analitica A ON A.cia=IM.cia AND A.id_analitica=IM.id_analitica
		WHERE	IM.CIA='''+@CIA+''' AND  IM.SEDE='''+@SEDE+'''	'
		SELECT @sGroupBy=' '		
		--------------------------------------------------------------------------------------------
		IF  LEN(ISNULL(@id_tipo_doc,''))>0  AND @id_tipo_doc<>'%'
				BEGIN  SELECT @sFiltro_IdTipoDoc=' and IM.id_tipo_doc in('''+@id_tipo_doc+''') 'END
		ELSE	BEGIN  SELECT @sFiltro_IdTipoDoc	=''	END	
		--------------------------------------------------------------------------------------------
		IF  LEN(ISNULL(@serie_doc,''))>0  AND @serie_doc<>'%'
				BEGIN  SELECT @sFiltro_SerieDoc=' and IM.serie_doc in('''+@serie_doc+''') 'END
		ELSE	BEGIN  SELECT @sFiltro_SerieDoc	=''	END
		--------------------------------------------------------------------------------------------
		IF  LEN(ISNULL(@NRO_DOC,''))>0 
				BEGIN  SELECT @sFiltro_NroDoc=' and IM.nro_doc like ''%''+'''+@NRO_DOC +''' +''%'' ' END
		ELSE	BEGIN  SELECT @sFiltro_NroDoc	=''	END
		--------------------------------------------------------------------------------------------
		IF  LEN(ISNULL(@id_motivo_almacen,''))>0  
				BEGIN  SELECT @sFiltro_IdMotivoAlmacen=' and IM.id_motivo_almacen in('''+@id_motivo_almacen+''') 'END
		ELSE	BEGIN  SELECT @sFiltro_IdMotivoAlmacen	=''END
			--------------------------------------------------------------------------------------------	
		IF  ISNULL(@FECHA1,'19000101') <> '19000101'  AND  ISNULL(@FECHA2,'19000101') <> '19000101'
				BEGIN 	SELECT @sFiltro_Fecha=' and convert(varchar(8),IM.fecha,112) between  '''+@FECHA1+'''  and  '''+@FECHA2+''''	END
		ELSE	BEGIN  	SELECT @sFiltro_Fecha	=''		END	
------------------------------------------------------------------------------------------------------------------------------
		IF  LEN(ISNULL(@id_moneda,''))>0  
				BEGIN  SELECT @sFiltro_IdMoneda=' and IM.id_moneda in('''+@id_moneda+''') 'END
		ELSE	BEGIN  SELECT @sFiltro_IdMoneda	=''END
		--------------------------------------------------------------------------------------------
		IF  LEN(ISNULL(@id_almacen,''))>0  
				BEGIN  SELECT @sFiltro_IdAlmacen=' and IM.id_almacen in('''+@id_almacen+''') 'END
		ELSE	BEGIN  SELECT @sFiltro_IdAlmacen	=''END
		--------------------------------------------------------------------------------------------
		IF  LEN(ISNULL(@id_analitica,''))>0  
				BEGIN  SELECT @sFiltro_Analitica=' and IM.id_analitica in('''+@id_analitica+''') 'END
		ELSE	BEGIN  SELECT @sFiltro_Analitica	=''END
------------------------------------------------------------------------------------------------------------------------------------
		IF  LEN(ISNULL(@anio,''))>0  AND @anio<>'%'
				BEGIN  SELECT @sFiltro_Anio=' and IM.ANIO in('''+@anio+''') 'END
		ELSE	BEGIN  SELECT @sFiltro_Anio	=''END
			--------------------------------------------------------------------------------------------
		IF  LEN(ISNULL(@mes,''))>0  AND @mes<>'%'
				BEGIN  SELECT @sFiltro_Mes=' and IM.MES  in('''+@mes+''') 'END
		ELSE	BEGIN  SELECT @sFiltro_Mes	=''END
			--------------------------------------------------------------------------------------------
		IF  LEN(ISNULL(@id_estado,''))>0 AND @id_estado<>'%' 
				BEGIN   SELECT @sFiltro_Estado=' and IM.ID_ESTADO  in('''+@id_estado+''') ' END
		ELSE	BEGIN	SELECT @sFiltro_Estado=''	END
		--------------------------------------------------------------------------------------------
		SELECT @sGroupBy	='	'  
		SELECT @sOrderBy	=' ORDER BY IM.nro_doc'
		---------------------------------------------------------------------------------------------
		SELECT @sExecute = @sSelect  +''+  @sFiltro_IdTipoDoc +''+ @sFiltro_SerieDoc  +''+  @sFiltro_NroDoc   +''+  
			   @sFiltro_IdMotivoAlmacen +''+ @sFiltro_Fecha+''+ @sFiltro_IdMoneda  +''+ @sFiltro_IdAlmacen +''+ 
			   @sFiltro_IdAlmacen +''+  @sFiltro_Analitica +''+ @sFiltro_Anio +''+@sFiltro_Mes+''+@sFiltro_Estado+''+
			   @sGroupBy +''+@sOrderBy
 		PRINT @sExecute
		EXEC ('SELECT '+ @sExecute )	
END
----------------------------------------------------------------------------------------------------
IF(@INDICADOR='2')
BEGIN
		SELECT @sSelect='
		IM.id_tipo_doc,IM.serie_doc,IM.nro_doc,IM.serie_doc + ''-'' + IM.nro_doc ''numero-doc'', 
		IM.item,IM.item_digitado,IM.id_articulo,IM.cantidad,IM.cantidad_usada,IM.cu_01,IM.cu_02,IM.stock,IM.stock_almacen,
		IM.cp_01,IM.cp_02,IM.id_estado,e.abreviatura ''estado'',fecha_hora=CONVERT(VARCHAR(10),IM.fc,103) +space(2)+convert(char(5),IM.fc, 114),	
		fecha=CONVERT(VARCHAR(10),IM.fc,103),hora=convert(char(5),IM.fc, 114),
		A.nro_parte,A.descripcion as ''descripcion'',upper(um.abreviatura) as ''unidad'', cantidad,upper(ma.descripcion)as ''marca''
		 FROM INVENTARIO_MOV_DET IM				
		LEFT JOIN estado e ON e.cia=IM.cia and e.id_estado=IM.id_estado 
		INNER JOIN ARTICULO A ON A.CIA=IM.CIA AND A.ID_ARTICULO=IM.ID_ARTICULO
		INNER JOIN UNIDAD_MEDIDA UM ON UM.CIA=A.CIA AND UM.ID_UNIDAD=A.ID_UNIDAD
		LEFT JOIN MARCA_ARTICULO  MA ON MA.CIA=A.CIA AND MA.ID_MARCA=A.ID_MARCA		
		WHERE	IM.CIA='''+@CIA+''' AND  IM.SEDE='''+@SEDE+'''	'
		SELECT @sGroupBy=' '		
		--------------------------------------------------------------------------------------------
		IF  LEN(ISNULL(@id_tipo_doc,''))>0  AND @id_tipo_doc<>'%'
				BEGIN  SELECT @sFiltro_IdTipoDoc=' and IM.id_tipo_doc in('''+@id_tipo_doc+''') 'END
		ELSE	BEGIN  SELECT @sFiltro_IdTipoDoc	=''	END	
		--------------------------------------------------------------------------------------------
		IF  LEN(ISNULL(@serie_doc,''))>0  AND @serie_doc<>'%'
				BEGIN  SELECT @sFiltro_SerieDoc=' and IM.serie_doc in('''+@serie_doc+''') 'END
		ELSE	BEGIN  SELECT @sFiltro_SerieDoc	=''	END
		--------------------------------------------------------------------------------------------
		IF  LEN(ISNULL(@NRO_DOC,''))>0 
				BEGIN  SELECT @sFiltro_NroDoc=' and IM.nro_doc like ''%''+'''+@NRO_DOC +''' +''%'' ' END
		ELSE	BEGIN  SELECT @sFiltro_NroDoc	=''	END
		--------------------------------------------------------------------------------------------
		SELECT @sExecute = @sSelect  +''+  @sFiltro_IdTipoDoc +''+ @sFiltro_SerieDoc  +''+  @sFiltro_NroDoc   +''+  
			   @sFiltro_Fecha+''+   @sFiltro_Estado+''+	   @sGroupBy +''+@sOrderBy
 		PRINT @sExecute
		EXEC ('SELECT '+ @sExecute )	
	
END	
-------------------------------------------------------------------------------------------
IF (@INDICADOR = '3')
BEGIN
		SELECT TOP 1 nro_doc FROM INVENTARIO_MOV	WHERE CIA=@CIA 	AND	SEDE=@SEDE AND 
				ID_TIPO_DOC=@ID_TIPO_DOC AND SERIE_DOC=@SERIE_DOC		
		ORDER BY nro_doc desc	
end		
----------------------------------------------------------------------------------------
GO
/****** Object:  StoredProcedure [dbo].[sp_pruebilla]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE [dbo].[sp_pruebilla]
AS
DECLARE @HORAS VARCHAR(20)
-------------------------------------------
WHILE 0 < @HORAS
BEGIN
SET @HORAS=(SELECT COUNT(*) FROM dbo.CRONOGRAMA_OPER)
END
-------------------------------------------
SELECT @HORAS
GO
/****** Object:  StoredProcedure [dbo].[SP_PUNTO_DE_VENTA_TRAER_TODOS_TEMP]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*

EXEC SP_PUNTO_DE_VENTA_TRAER_TODOS_TEMP 'SDSFSDFSDF', '01', '01'

*/
----------------------------------------
----------------------------------------
create	PROCEDURE	[dbo].[SP_PUNTO_DE_VENTA_TRAER_TODOS_TEMP]
@SESION		VARCHAR(100),
@CIA		CHAR(2),
@SEDE		CHAR(2)
AS
----------------------------------------
----------------------------------------
SELECT	PUNTO_VENTA_TEMP.ITEM, PUNTO_VENTA_TEMP.ID_ARTICULO, ARTICULO.NRO_PARTE AS 'NRO-PARTE', ARTICULO.DESCRIPCION, PUNTO_VENTA_TEMP.UNIDAD, PUNTO_VENTA_TEMP.STOCK, 
		PUNTO_VENTA_TEMP.CANTIDAD, PUNTO_VENTA_TEMP.PRECIO, PUNTO_VENTA_TEMP.TOTAL
FROM	PUNTO_VENTA_TEMP 
INNER JOIN ARTICULO ON PUNTO_VENTA_TEMP.CIA = ARTICULO.CIA AND PUNTO_VENTA_TEMP.ID_ARTICULO = ARTICULO.ID_ARTICULO
WHERE	PUNTO_VENTA_TEMP.SESION	= @SESION
AND		PUNTO_VENTA_TEMP.CIA	= @CIA
AND		PUNTO_VENTA_TEMP.SEDE	= @SEDE
GO
/****** Object:  StoredProcedure [dbo].[SP_R_COTIZACION]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*


SP_LISTAR_ANALITICA '3','01','01','20513567139',''
SP_ESTACIONES_COTIZACION '1','01','20507909168','2010'
SP_R_COTIZACION '01','01','20','2010','00000408'	--46
SP_R_COTIZACION '01','01','20','2010','00000711'	--1
									   
SELECT * FROM  DOC_GESTION_FA  WHERE CIA='01' AND SEDE='01' AND ID_TIPO_DOC='20' AND SERIE_DOC='2010' and nro_doc='00000696'
SELECT * FROM  DOC_GESTION_FA_DETALLE  WHERE CIA='01' AND SEDE='01' AND ID_TIPO_DOC='20' AND SERIE_DOC='2010' and nro_doc='00000268'
		AND ID_ARTICULO LIKE 'PRO---0000000213' + '%'

*/
CREATE PROC [dbo].[SP_R_COTIZACION]
@CIA  CHAR(2),@sede CHAR(2),@ID_TIPO_DOC CHAR(2),@SERIE_DOC CHAR(4),@NRO_DOC  VARCHAR(20)
AS
DECLARE @doc VARCHAR(20)
SET @doc='No hay Documento'
SELECT 	C.DESCRIPCION 'compania',DGFD.id_tipo_doc,DGFD.serie_doc,DGFD.nro_doc,DGFD.ITEM 'item',DGFD.ID_ARTICULO 'id_articulo',
	upper(art.nro_parte) 'nro_parte',	ART.descripcion 'desc_articulo',upper(ma.descripcion) 'marca',
	um.abreviatura 'und',convert(DECIMAL(15,4),DGFD.precio)'precio',
	convert(DECIMAL(15,2),DGFD.cantidad)'cantidad',DGFD.des_larga_articulo 'detalle',fecha_entrega=CONVERT(VARCHAR(10),DGF.fecha_entrega,103),
	fecha_documento=CONVERT(VARCHAR(10),DGF.fecha_documento,103),fecha_vencimiento=CONVERT(VARCHAR(10),DGF.fecha_vencimiento,103),	
	'proveedor' =	(
						select	top 1 prov.descripcion 'descripcion' 	from    inventario_mov ni 
						INNER JOIN	inventario_mov_det as ni_d on ni.cia = ni_d.cia and ni.sede = ni_d.sede and ni.id_tipo_doc = ni_d.id_tipo_doc and 
									ni.serie_doc = ni_d.serie_doc and ni.nro_doc = ni_d.nro_doc 
						INNER JOIN	analitica prov on ni.cia = prov.cia and ni.id_analitica=prov.id_analitica 
						INNER JOIN	analitica_tipo as prov_t on prov.cia = prov_t.cia and prov.id_analitica = prov_t.id_analitica
						where	ni.cia=gp.cia  and ni.sede=gp.sede and ni.id_tipo_doc='31' and prov_t.id_tipo_analitica='02'
							and	ni_d.id_articulo = art.id_articulo	
							AND ni.id_tipo_doc=guia.id_tipo_doc AND ni.serie_doc=guia.serie_doc  AND ni.nro_doc=guia.nro_doc
							order by 'descripcion' 
						)	,
	'direccion_proveedor' =	(
						select	top 1 prov.direccion 'direecion_proveedor' 	from    inventario_mov as ni 
						inner join	inventario_mov_det as ni_d on ni.cia = ni_d.cia and ni.sede = ni_d.sede and ni.id_tipo_doc = ni_d.id_tipo_doc and 
									ni.serie_doc = ni_d.serie_doc and ni.nro_doc = ni_d.nro_doc 
						inner join	analitica as prov on ni.cia = prov.cia and ni.cia = prov.cia and ni.cia = prov.cia
							 and ni.cia = prov.cia and ni.id_analitica = prov.id_analitica  and ni.id_analitica = prov.id_analitica
						inner join	analitica_tipo as prov_t on prov.cia = prov_t.cia and prov.id_analitica = prov_t.id_analitica
						where	ni.cia=gp.cia  and ni.sede=GP.sede and ni.id_tipo_doc='31' and prov_t.id_tipo_analitica='02'
							and	ni_d.id_articulo=art.id_articulo order by 'descripcion' 							
						)	,pc.ID_TIPO_DOC 'id_tipo_doc_op',pc.SERIE_DOC 'serie_doc_op' ,ISNULL(pc.NRO_DOC,@doc) 'nro_doc_op',
							FP.ID_TIPO_DOC 'id_tipo_doc_fac',FP.SERIE_DOC 'serie_doc_fac' ,ISNULL(FP.NRO_DOC,@doc) 'nro_doc_fac',
							GF.ID_TIPO_DOC 'id_tipo_doc_guia',GF.SERIE_DOC 'serie_doc_guia' ,ISNULL(GF.NRO_DOC,@doc) 'nro_doc_guia'	
	--	COTIZACION					
	from DOC_GESTION_FA DGF 
	--	COTIZACION DETALLE
	INNER JOIN DOC_GESTION_FA_DETALLE DGFD on DGFD.cia=DGF.cia and DGFD.sede=DGF.sede 
		AND DGFD.ID_TIPO_DOC=DGF.ID_TIPO_DOC AND DGFD.SERIE_DOC=DGF.SERIE_DOC  AND DGFD.NRO_DOC = DGF.NRO_DOC 	
	--------------------------------------------------------------------------------------------
	INNER JOIN COMPANIA C ON C.CIA=DGF.CIA			
	INNER JOIN analitica a on a.cia=DGF.cia and a.ID_ANALITICA=DGF.id_cliente 
	INNER JOIN analitica_TIPO AT on AT.cia=a.cia and AT.ID_ANALITICA=A.ID_ANALITICA 
	INNER JOIN ARTICULO ART on ART.cia=DGFD.cia and ART.ID_ARTICULO=DGFD.ID_ARTICULO 
	LEFT JOIN marca_articulo ma on ma.cia=a.cia and ma.id_marca=aRT.id_marca
	LEFT JOIN unidad_medida um on um.cia=aRT.cia and um.id_unidad=aRT.id_unidad
	--------------------------------------------------------------------------------------------
	--	SP_R_COTIZACION '01','01','20','2010','00000712'	--46
	--1	PEDIDO  CON COTIZACION
	LEFT JOIN PEDIDO_COTIZACION pc ON pc.cia=DGFD.cia AND  pc.sede=DGFD.sede AND 
			pc.id_tipo_doc_ref=DGFD.id_tipo_doc AND pc.serie_doc_ref=DGFD.serie_doc  AND pc.nro_doc_ref=DGFD.nro_doc
	--2	GUIA CON PEDIDO
	LEFT JOIN INVENTARIO_MOV_GESTION GP ON GP.cia=pc.cia AND  GP.sede=pc.sede and 
		GP.id_tipo_doc_ref=PC.id_tipo_doc AND GP.serie_doc_ref=PC.serie_doc  AND GP.nro_doc_ref = PC.nro_doc	
	--3	GUIA - GUIA 
	LEFT JOIN INVENTARIO_MOV_DET GUIA ON  GUIA.cia=GP.cia AND  GUIA.sede=GP.sede and 
		GUIA.id_tipo_doc=GP.id_tipo_doc AND GUIA.serie_doc=GP.serie_doc  AND GUIA.nro_doc=GP.nro_doc	
	--------------------------------------------------------------------------------------------
	--	FACTURA CON PEDIDO
	LEFT JOIN DOCUMENTO_CC_GESTION FP ON FP.cia=pc.cia AND  FP.sede=pc.sede and 
			FP.ID_TIPO_DOC_REF=pc.id_tipo_doc AND FP.serie_doc_REF=pc.serie_doc  AND FP.nro_doc_REF = pc.nro_doc
	-- GUIA CON FACTURA
	LEFT JOIN INVENTARIO_MOV_DOC_CC_REF GF ON GF.cia=FP.cia AND  GF.sede=FP.sede and 
			GF.ID_TIPO_DOC_REF=FP.id_tipo_doc AND GF.SERIE_DOC_REF=FP.serie_doc AND GF.NRO_DOC_REF = FP.nro_doc				
	--------------------------------------------------------------------------------------------
	where DGFd.cia=@CIA AND DGFd.sede=@sede AND DGFd.id_tipo_doc=@id_tipo_doc AND DGFd.serie_doc=@serie_doc	AND DGFd.nro_doc=@nro_doc	
	--	AGRUPADOS
	GROUP BY gp.cia,gp.sede,guia.id_tipo_doc,guia.serie_doc,guia.nro_doc,guia.cia,guia.sede,C.DESCRIPCION,DGFD.cia,DGFD.sede,C.DESCRIPCION,
		DGFD.id_tipo_doc,DGFD.serie_doc,DGFD.nro_doc,DGFD.ITEM,DGFD.ID_ARTICULO,art.nro_parte,ART.descripcion,ma.descripcion,
		um.abreviatura,DGFD.precio,DGFD.cantidad,DGFD.des_larga_articulo,DGF.fecha_entrega,DGF.fecha_documento,DGF.fecha_vencimiento,	
	--[proveedor] ,[direecion proveedor],
	pc.ID_TIPO_DOC ,pc.SERIE_DOC ,pc.NRO_DOC ,FP.ID_TIPO_DOC ,FP.SERIE_DOC,FP.NRO_DOC,GF.ID_TIPO_DOC ,GF.SERIE_DOC ,GF.NRO_DOC ,ART.ID_ARTICULO
GO
/****** Object:  StoredProcedure [dbo].[SP_R_ESTADO_ESTACIONES]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
go
SELECT * FROM analitica WHERE DESCRIPCION LIKE '%'+'gnv'+'%'
SELECT * FROM dbo.ANALITICA_TIPO
SELECT * FROM dbo.ANALITICA_CONTACTO WHERE ID_ANALITICA='20516522233'
SELECT * FROM dbo.CLIENTE_VEHICULO
SELECT * FROM dbo.PUNTO_VENTA
SELECT * FROM compania
SP_HELP PUNTO_VENTA
SELECT * FROM PUNTO_VENTA WHERE  ID_CLIENTE  LIKE '1010'+'%'
SELECT * FROM PUNTO_VENTA WHERE FLAG_ITF='1' 
UPDATE  PUNTO_VENTA SET FLAG_ITF='1'  WHERE  ID_CLIENTE  LIKE '1009'+'%'
UPDATE  PUNTO_VENTA SET fecha_solicitud='20100915'  WHERE  ID_CLIENTE  LIKE '1000'+'%'
UPDATE  PUNTO_VENTA SET fecha_ini_construccion='20100915'  WHERE  ID_CLIENTE  LIKE '2010'+'%'
UPDATE  PUNTO_VENTA SET fecha_ini_operacion='20100915'  WHERE  ID_CLIENTE  LIKE '2010'+'%'
--------------------------------------------------------------------------------------------------------------------------------------------
SP_R_ESTADO_ESTACIONES '01'

*/
CREATE PROC [dbo].[SP_R_ESTADO_ESTACIONES]
@CIA CHAR(2)
AS
	SELECT C.DESCRIPCION 'CIA',A.ID_ANALITICA,LTRIM(A.DESCRIPCION) 'ESTACION DE SERVICIO',PV.NRO_EXPEDIENTE,
		CONVERT(VARCHAR(10),PV.FECHA_SOLICITUD,103) 'FECHA SOLICITUD',A.DIRECCION,
	u.id_distrito 'id_distrito',u.des_distrito 'desc_distrito',AC.CONTACTO 'REPRESENTANTE',A.TELEFONO,E.DESCRIPCION,
		PV.SUPERVISOR,PV.OBSERVACION,PV.FLAG_ITF
	FROM analitica A
	INNER JOIN COMPANIA C ON C.CIA=A.CIA
	INNER JOIN ESTADO E ON E.CIA=A.CIA AND E.ID_ESTADO=A.ID_ESTADO
	LEFT JOIN UBICACION U on U.cia=A.cia and u.id_pais=a.id_pais and u.id_dpto=a.id_dpto and u.id_provincia=a.id_provincia and u.id_distrito=a.id_distrito
	INNER JOIN ANALITICA_CONTACTO AC on AC.cia=a.cia and AC.ID_ANALITICA=A.ID_ANALITICA 
	INNER JOIN analitica_TIPO AT on AT.cia=a.cia and AT.ID_ANALITICA=A.ID_ANALITICA 
	INNER JOIN PUNTO_VENTA PV ON 	PV.cia=a.cia and PV.ID_CLIENTE=A.ID_ANALITICA 
	WHERE  A.CIA=@CIA	AND at.ID_TIPO_ANALITICA in('01') AND PV.FLAG_ITF='1'
	GROUP BY  C.DESCRIPCION,A.ID_ANALITICA,A.DESCRIPCION,PV.NRO_EXPEDIENTE,PV.FECHA_SOLICITUD,A.DIRECCION,u.id_distrito,u.des_distrito ,AC.CONTACTO,A.TELEFONO,E.DESCRIPCION,PV.SUPERVISOR,PV.OBSERVACION,PV.FLAG_ITF
	ORDER BY A.DESCRIPCION
GO
/****** Object:  StoredProcedure [dbo].[SP_R_ESTADO_ESTACIONES_02]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
go
SELECT * FROM analitica WHERE DESCRIPCION LIKE '%'+'gnv'+'%'
SELECT * FROM dbo.ANALITICA_TIPO
SELECT * FROM dbo.ANALITICA_CONTACTO WHERE ID_ANALITICA='20516522233'
SELECT * FROM dbo.CLIENTE_VEHICULO
SELECT * FROM dbo.PUNTO_VENTA
SELECT * FROM compania
SP_HELP PUNTO_VENTA
SELECT * FROM PUNTO_VENTA WHERE  ID_CLIENTE  LIKE '1010'+'%'
SELECT * FROM PUNTO_VENTA WHERE FLAG_ITF='1' 
UPDATE  PUNTO_VENTA SET FLAG_ITF='1'  WHERE  ID_CLIENTE  LIKE '1009'+'%'
UPDATE  PUNTO_VENTA SET fecha_solicitud='20100915'  WHERE  ID_CLIENTE  LIKE '1000'+'%'
UPDATE  PUNTO_VENTA SET fecha_ini_construccion='20100915'  WHERE  ID_CLIENTE  LIKE '2010'+'%'
UPDATE  PUNTO_VENTA SET fecha_ini_operacion='20100915'  WHERE  ID_CLIENTE  LIKE '2010'+'%'
UPDATE  PUNTO_VENTA SET NRO_EXPEDIENTE='786226'  WHERE  ID_CLIENTE  LIKE '2010'+'%'


--------------------------------------------------------------------------------------------------------------------------------------------
SP_R_ESTADO_ESTACIONES_02 '01'
GO
SP_R_ESTADO_ESTACIONES '2','01'
SP_R_ESTADO_ESTACIONES '3','01'
SP_R_ESTADO_ESTACIONES '4','01'
--AND convert(varchar(10),a.fc ,112) between  '20100101'  and  '20101231' 
*/

CREATE PROC [dbo].[SP_R_ESTADO_ESTACIONES_02]
@CIA CHAR(2)
AS
	SELECT C.DESCRIPCION 'CIA',A.ID_ANALITICA,LTRIM(A.DESCRIPCION) 'ESTACION DE SERVICIO',PV.NRO_EXPEDIENTE,
		CONVERT(VARCHAR(10),PV.FECHA_SOLICITUD,103) 'FECHA SOLICITUD',A.DIRECCION,
		u.id_distrito 'id_distrito',u.des_distrito 'desc_distrito',AC.CONTACTO 'REPRESENTANTE',A.TELEFONO,E.DESCRIPCION,
		PV.SUPERVISOR,PV.RESOLUCION_ITF,PV.FLAG_ITF
	FROM analitica A
	INNER JOIN COMPANIA C ON C.CIA=A.CIA
	INNER JOIN ESTADO E ON E.CIA=A.CIA AND E.ID_ESTADO=A.ID_ESTADO
	LEFT JOIN UBICACION U on U.cia=A.cia and u.id_pais=a.id_pais and u.id_dpto=a.id_dpto and u.id_provincia=a.id_provincia and u.id_distrito=a.id_distrito
	INNER JOIN ANALITICA_CONTACTO AC on AC.cia=a.cia and AC.ID_ANALITICA=A.ID_ANALITICA 
	INNER JOIN analitica_TIPO AT on AT.cia=a.cia and AT.ID_ANALITICA=A.ID_ANALITICA 
	INNER JOIN PUNTO_VENTA PV ON 	PV.cia=a.cia and PV.ID_CLIENTE=A.ID_ANALITICA 
	WHERE  A.CIA=@CIA	
	AND at.ID_TIPO_ANALITICA in('01') AND PV.FLAG_ITF='0'
	GROUP BY C.DESCRIPCION,A.ID_ANALITICA,A.DESCRIPCION,PV.NRO_EXPEDIENTE,PV.FECHA_SOLICITUD,A.DIRECCION,u.id_distrito,u.des_distrito,
			AC.CONTACTO,A.TELEFONO,E.DESCRIPCION,PV.SUPERVISOR,PV.OBSERVACION,PV.RESOLUCION_ITF,PV.FLAG_ITF
	ORDER BY A.DESCRIPCION

------------------------------------------------------------------------------------------------------------------------------------------------
--IF(@INDICADOR='3')	BEGIN
--	SELECT A.ID_ANALITICA,LTRIM(A.DESCRIPCION) 'ESTACION DE SERVICIO',C.DESCRIPCION 'empresa de sistemas',PV.NRO_EXPEDIENTE,
--		CONVERT(VARCHAR(10),PV.FECHA_INI_CONSTRUCCION,103) 'INICIO CONSTRUCCION',A.DIRECCION,
--		u.id_distrito 'id_distrito',u.des_distrito 'desc_distrito',AC.CONTACTO 'REPRESENTANTE',A.TELEFONO,E.DESCRIPCION,
--		PV.SUPERVISOR,PV.OBSERVACION 'avance de obra',PV.NRO_MANGUERAS,PV.FLAG_ITF		
--	FROM analitica A
--	INNER JOIN ESTADO E ON E.CIA=A.CIA AND E.ID_ESTADO=A.ID_ESTADO
--	LEFT JOIN UBICACION U on U.cia=A.cia and u.id_pais=a.id_pais and u.id_dpto=a.id_dpto and u.id_provincia=a.id_provincia and u.id_distrito=a.id_distrito
--	INNER JOIN ANALITICA_CONTACTO AC on AC.cia=a.cia and AC.ID_ANALITICA=A.ID_ANALITICA 
--	INNER JOIN analitica_TIPO AT on AT.cia=a.cia and AT.ID_ANALITICA=A.ID_ANALITICA 
--	INNER JOIN PUNTO_VENTA PV ON 	PV.cia=a.cia and PV.ID_CLIENTE=A.ID_ANALITICA 
--	INNER JOIN compania C ON C.CIA=A.CIA
--	WHERE  A.CIA=@CIA	AND		at.ID_TIPO_ANALITICA in('01') AND LEN(pV.FECHA_INI_CONSTRUCCION)>0
--	ORDER BY A.DESCRIPCION,A.ID_ANALITICA
--END
------------------------------------------------------------------------------------------------------------------------------------------------
-- IF(@INDICADOR='4')	BEGIN
--	SELECT A.ID_ANALITICA,LTRIM(A.DESCRIPCION) 'ESTACION DE SERVICIO',PV.NRO_EXPEDIENTE,
--		CONVERT(VARCHAR(10),PV.fecha_ini_operacion,103) 'INICIO OPERACION',A.DIRECCION,PV.EMP_INSTALADORAS,
--		u.id_distrito 'id_distrito',u.des_distrito 'desc_distrito',AC.CONTACTO 'REPRESENTANTE',A.TELEFONO,
--		PV.SUPERVISOR,E.DESCRIPCION 'ESTADO',PV.NRO_MANGUERAS,PV.OBSERVACION,PV.FLAG_ITF
--	FROM analitica A
--	INNER JOIN ESTADO E ON E.CIA=A.CIA AND E.ID_ESTADO=A.ID_ESTADO
--	LEFT JOIN UBICACION U on U.cia=A.cia and u.id_pais=a.id_pais and u.id_dpto=a.id_dpto and u.id_provincia=a.id_provincia and u.id_distrito=a.id_distrito
--	INNER JOIN ANALITICA_CONTACTO AC on AC.cia=a.cia and AC.ID_ANALITICA=A.ID_ANALITICA 
--	INNER JOIN analitica_TIPO AT on AT.cia=a.cia and AT.ID_ANALITICA=A.ID_ANALITICA 
--	INNER JOIN PUNTO_VENTA PV ON 	PV.cia=a.cia and PV.ID_CLIENTE=A.ID_ANALITICA 
--	WHERE  A.CIA=@CIA	AND		at.ID_TIPO_ANALITICA in('01') AND LEN(pV.fecha_ini_operacion)>0
--	ORDER BY A.DESCRIPCION,A.ID_ANALITICA
--END
----------------------------------------------------------------------------------------------------------------------------------------------
GO
/****** Object:  StoredProcedure [dbo].[SP_R_ESTADO_ESTACIONES_03]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
go
SELECT * FROM analitica WHERE DESCRIPCION LIKE '%'+'gnv'+'%'
SELECT * FROM dbo.ANALITICA_TIPO
SELECT * FROM dbo.ANALITICA_CONTACTO WHERE ID_ANALITICA='20516522233'
SELECT * FROM dbo.CLIENTE_VEHICULO
SELECT * FROM dbo.PUNTO_VENTA
SELECT * FROM compania
SP_HELP PUNTO_VENTA
SELECT * FROM PUNTO_VENTA WHERE  ID_CLIENTE  LIKE '1010'+'%'
SELECT * FROM PUNTO_VENTA WHERE FLAG_ITF='1' 
UPDATE  PUNTO_VENTA SET FLAG_ITF='1'  WHERE  ID_CLIENTE  LIKE '1009'+'%'
UPDATE  PUNTO_VENTA SET fecha_solicitud='20100915'  WHERE  ID_CLIENTE  LIKE '1000'+'%'
UPDATE  PUNTO_VENTA SET fecha_ini_construccion='20100915'  WHERE  ID_CLIENTE  LIKE '2010'+'%'
UPDATE  PUNTO_VENTA SET fecha_ini_operacion='20100915'  WHERE  ID_CLIENTE  LIKE '2010'+'%'
UPDATE  PUNTO_VENTA SET NRO_EXPEDIENTE='786226'  WHERE  ID_CLIENTE  LIKE '2010'+'%'


--------------------------------------------------------------------------------------------------------------------------------------------
SP_R_ESTADO_ESTACIONES_03 '01'

*/

CREATE PROC [dbo].[SP_R_ESTADO_ESTACIONES_03]
@CIA CHAR(2)
AS
	SELECT C.DESCRIPCION 'CIA',A.ID_ANALITICA,LTRIM(A.DESCRIPCION) 'ESTACION DE SERVICIO',C.DESCRIPCION 'empresa de sistemas',PV.NRO_EXPEDIENTE,
		CONVERT(VARCHAR(10),PV.FECHA_INI_CONSTRUCCION,103) 'INICIO CONSTRUCCION',A.DIRECCION,
		u.id_distrito 'id_distrito',u.des_distrito 'desc_distrito',AC.CONTACTO 'REPRESENTANTE',A.TELEFONO,E.DESCRIPCION,
		PV.SUPERVISOR,PV.OBSERVACION 'avance de obra',PV.NRO_MANGUERAS,PV.FLAG_ITF		
	FROM analitica A
	INNER JOIN COMPANIA C ON C.CIA=A.CIA
	INNER JOIN ESTADO E ON E.CIA=A.CIA AND E.ID_ESTADO=A.ID_ESTADO
	LEFT JOIN UBICACION U on U.cia=A.cia and u.id_pais=a.id_pais and u.id_dpto=a.id_dpto and u.id_provincia=a.id_provincia and u.id_distrito=a.id_distrito
	INNER JOIN ANALITICA_CONTACTO AC on AC.cia=a.cia and AC.ID_ANALITICA=A.ID_ANALITICA 
	INNER JOIN analitica_TIPO AT on AT.cia=a.cia and AT.ID_ANALITICA=A.ID_ANALITICA 
	INNER JOIN PUNTO_VENTA PV ON 	PV.cia=a.cia and PV.ID_CLIENTE=A.ID_ANALITICA 
	WHERE  A.CIA=@CIA	AND		at.ID_TIPO_ANALITICA in('01') AND LEN(pV.FECHA_INI_CONSTRUCCION)>0
	GROUP BY C.DESCRIPCION,A.ID_ANALITICA,A.DESCRIPCION,C.DESCRIPCION,PV.NRO_EXPEDIENTE,PV.FECHA_INI_CONSTRUCCION,A.DIRECCION,
			u.id_distrito,u.des_distrito,AC.CONTACTO,A.TELEFONO,E.DESCRIPCION,PV.SUPERVISOR,PV.OBSERVACION,PV.NRO_MANGUERAS,PV.FLAG_ITF
	ORDER BY A.DESCRIPCION,A.ID_ANALITICA

------------------------------------------------------------------------------------------------------------------------------------------------
-- IF(@INDICADOR='4')	BEGIN
--	SELECT A.ID_ANALITICA,LTRIM(A.DESCRIPCION) 'ESTACION DE SERVICIO',PV.NRO_EXPEDIENTE,
--		CONVERT(VARCHAR(10),PV.fecha_ini_operacion,103) 'INICIO OPERACION',A.DIRECCION,PV.EMP_INSTALADORAS,
--		u.id_distrito 'id_distrito',u.des_distrito 'desc_distrito',AC.CONTACTO 'REPRESENTANTE',A.TELEFONO,
--		PV.SUPERVISOR,E.DESCRIPCION 'ESTADO',PV.NRO_MANGUERAS,PV.OBSERVACION,PV.FLAG_ITF
--	FROM analitica A
--	INNER JOIN ESTADO E ON E.CIA=A.CIA AND E.ID_ESTADO=A.ID_ESTADO
--	LEFT JOIN UBICACION U on U.cia=A.cia and u.id_pais=a.id_pais and u.id_dpto=a.id_dpto and u.id_provincia=a.id_provincia and u.id_distrito=a.id_distrito
--	INNER JOIN ANALITICA_CONTACTO AC on AC.cia=a.cia and AC.ID_ANALITICA=A.ID_ANALITICA 
--	INNER JOIN analitica_TIPO AT on AT.cia=a.cia and AT.ID_ANALITICA=A.ID_ANALITICA 
--	INNER JOIN PUNTO_VENTA PV ON 	PV.cia=a.cia and PV.ID_CLIENTE=A.ID_ANALITICA 
--	WHERE  A.CIA=@CIA	AND		at.ID_TIPO_ANALITICA in('01') AND LEN(pV.fecha_ini_operacion)>0
--	ORDER BY A.DESCRIPCION,A.ID_ANALITICA
--END
----------------------------------------------------------------------------------------------------------------------------------------------
GO
/****** Object:  StoredProcedure [dbo].[SP_R_ESTADO_ESTACIONES_04]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
go
SELECT * FROM analitica WHERE DESCRIPCION LIKE '%'+'gnv'+'%'
SELECT * FROM dbo.ANALITICA_TIPO
SELECT * FROM dbo.ANALITICA_CONTACTO WHERE ID_ANALITICA='20516522233'
SELECT * FROM dbo.CLIENTE_VEHICULO
SELECT * FROM dbo.PUNTO_VENTA
SELECT * FROM compania
SP_HELP PUNTO_VENTA
SELECT * FROM PUNTO_VENTA WHERE  ID_CLIENTE  LIKE '1010'+'%'
SELECT * FROM PUNTO_VENTA WHERE FLAG_ITF='1' 
UPDATE  PUNTO_VENTA SET FLAG_ITF='1'  WHERE  ID_CLIENTE  LIKE '1009'+'%'
UPDATE  PUNTO_VENTA SET fecha_solicitud='20100915'  WHERE  ID_CLIENTE  LIKE '1000'+'%'
UPDATE  PUNTO_VENTA SET fecha_ini_construccion='20100915'  WHERE  ID_CLIENTE  LIKE '2010'+'%'
UPDATE  PUNTO_VENTA SET fecha_ini_operacion='20100915'  WHERE  ID_CLIENTE  LIKE '2010'+'%'
UPDATE  PUNTO_VENTA SET NRO_EXPEDIENTE='786226'  WHERE  ID_CLIENTE  LIKE '2010'+'%'


--------------------------------------------------------------------------------------------------------------------------------------------
SP_R_ESTADO_ESTACIONES_04 '01'

*/

CREATE PROC [dbo].[SP_R_ESTADO_ESTACIONES_04]
@CIA CHAR(2)
AS
	SELECT C.DESCRIPCION 'CIA',A.ID_ANALITICA,LTRIM(A.DESCRIPCION) 'ESTACION DE SERVICIO',PV.NRO_EXPEDIENTE,
		CONVERT(VARCHAR(10),PV.fecha_ini_operacion,103) 'INICIO OPERACION',A.DIRECCION,PV.EMP_INSTALADORAS,
		u.id_distrito 'id_distrito',u.des_distrito 'desc_distrito',AC.CONTACTO 'REPRESENTANTE',A.TELEFONO,
		PV.SUPERVISOR,E.DESCRIPCION 'ESTADO',PV.NRO_MANGUERAS,PV.OBSERVACION,PV.FLAG_ITF
	FROM analitica A
	INNER JOIN COMPANIA C ON C.CIA=A.CIA
	INNER JOIN ESTADO E ON E.CIA=A.CIA AND E.ID_ESTADO=A.ID_ESTADO
	LEFT JOIN UBICACION U on U.cia=A.cia and u.id_pais=a.id_pais and u.id_dpto=a.id_dpto and u.id_provincia=a.id_provincia and u.id_distrito=a.id_distrito
	INNER JOIN ANALITICA_CONTACTO AC on AC.cia=a.cia and AC.ID_ANALITICA=A.ID_ANALITICA 
	INNER JOIN analitica_TIPO AT on AT.cia=a.cia and AT.ID_ANALITICA=A.ID_ANALITICA 
	INNER JOIN PUNTO_VENTA PV ON 	PV.cia=a.cia and PV.ID_CLIENTE=A.ID_ANALITICA 
	WHERE  A.CIA=@CIA	AND		at.ID_TIPO_ANALITICA in('01') AND LEN(pV.fecha_ini_operacion)>0
	GROUP BY C.DESCRIPCION,A.ID_ANALITICA,A.DESCRIPCION,PV.NRO_EXPEDIENTE,PV.fecha_ini_operacion,A.DIRECCION,PV.EMP_INSTALADORAS,
			u.id_distrito,u.des_distrito,AC.CONTACTO,A.TELEFONO,PV.SUPERVISOR,E.DESCRIPCION,PV.NRO_MANGUERAS,PV.OBSERVACION,PV.FLAG_ITF
	ORDER BY A.DESCRIPCION,A.ID_ANALITICA
GO
/****** Object:  StoredProcedure [dbo].[SP_R_MONTAJE]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- SP_R_MONTAJE '01','01','','','06/01/2008','06/01/2011'

CREATE PROCEDURE [dbo].[SP_R_MONTAJE]
@CIA CHAR(2),@SEDE CHAR(2),@TIPO VARCHAR(1),@ESTACION VARCHAR(20),@INICIO DATETIME,@FIN DATETIME
AS
-------------------------------------------------------------------------------
DECLARE @FEC1 varchar(8),@FEC2 varchar(8)
-------------------------------------------------------------------------------
SET @FEC1=CONVERT(VARCHAR(8),@INICIO,112)
SET @FEC2=CONVERT(VARCHAR(8),@FIN,112)
-------------------------------------------------------------------------------
--// definimos variables y estructuras		
declare @in_rowt int,@in_allrowt int,@id_condi char(2),@cod_cliente varchar(20),@serie_doc char(4),@nro_doc VARCHAR(20),
		@monto float,@monto_deuda1 float,@monto_deuda2 float,@monto_deuda3 float,@monto_deuda4 float
		,@in_rowt2 int,@n_contador int,@ind int,@serie_doc_ref_1 char(4),@nro_doc_ref_1 VARCHAR(20),@monto_ref_1 float,
		@serie_doc_ref_2 char(4),@nro_doc_ref_2 VARCHAR(20),@monto_ref_2 float,
		@serie_doc_ref_3 char(4),@nro_doc_ref_3 VARCHAR(20),@monto_ref_3 float,
		@serie_doc_ref_4 char(4),@nro_doc_ref_4 VARCHAR(20),@monto_ref_4 float

declare @TT_FACTURAS table (secc int identity,cod_cliente varchar(20), serie_doc char(4),
						nro_doc VARCHAR(20),monto float,fecha datetime, serie_doc_ref char(4),nro_doc_ref VARCHAR(20))

declare @TT_DATOS table (secc int identity,cia varchar(1000),sede varchar(1000),cod_cliente varchar(20),cliente varchar(1000),fecha datetime,
												serie_doc char(4),nro_doc varchar(20),tipo_cot char(2),monto float,
												serie_doc_pago1 varchar(4),nro_doc_pago1 varchar(20),monto_pago1 float,monto_deuda1 float,
												serie_doc_pago2 varchar(4),nro_doc_pago2 varchar(20),monto_pago2 float,monto_deuda2 float,
												serie_doc_pago3 varchar(4),nro_doc_pago3 varchar(20),monto_pago3 float,monto_deuda3 float,
												serie_doc_pago4 varchar(4),nro_doc_pago4 varchar(20),monto_pago4 float,monto_deuda4 float)
---------------------------------------------------------------------------------------------------------------------------	
--// Cargamos estructura de cotizaciones
				insert @TT_DATOS (cia,sede,cod_cliente,cliente,fecha,serie_doc,nro_doc,tipo_cot,monto,monto_pago1,monto_deuda1,monto_pago2,monto_deuda2
									,monto_pago3,monto_deuda3,monto_pago4,monto_deuda4)
				select CON.DESCRIPCION,SE.DESCRIPCION,DGF.ID_CLIENTE,A.DESCRIPCION,CONVERT(VARCHAR(10),DGF.FECHA_DOCUMENTO,103),
				DGF.SERIE_DOC,DGF.NRO_DOC,DGF.ID_CONDICION_PAGO,DGF.TOTAL_FINAL,'0','0','0','0','0','0','0','0'
				FROM DOC_GESTION_FA DGF
				INNER JOIN COMPANIA CON ON CON.CIA=DGF.CIA
				INNER JOIN SEDE SE ON SE.CIA=DGF.CIA AND SE.SEDE=DGF.SEDE
				INNER JOIN ANALITICA A ON DGF.CIA=A.CIA AND DGF.ID_CLIENTE=A.ID_ANALITICA
				WHERE DGF.CIA=@CIA and DGF.SEDE=@SEDE and (convert(varchar(8),DGF.FECHA_DOCUMENTO,112) between @FEC1 and @FEC2) 
				and DGF.ID_ESTADO ='03' AND DGF.ID_TIPO_DOC='20'
				AND ID_CLIENTE LIKE '%'+@ESTACION
				ORDER BY A.DESCRIPCION
----------------------------------------------

select @in_rowt = 1, @in_allrowt = @@rowcount
while @in_rowt <= @in_allrowt 
begin
			select @id_condi='',@cod_cliente='',@serie_doc='',@nro_doc='',@monto=''
			
			select @id_condi = tipo_cot from @TT_DATOS where secc = @in_rowt
			select @cod_cliente = cod_cliente from @TT_DATOS where secc = @in_rowt
			select @serie_doc = serie_doc from @TT_DATOS where secc = @in_rowt
			select @nro_doc = nro_doc from @TT_DATOS where secc = @in_rowt
			select @monto = monto from @TT_DATOS where secc = @in_rowt
			------------------------------------------------------------------------------
			select @n_contador=0,@ind=0,@serie_doc_ref_1='',@nro_doc_ref_1='',@monto_ref_1=0,@serie_doc_ref_2='',@nro_doc_ref_2='',@monto_ref_2=0,
										@serie_doc_ref_3='',@nro_doc_ref_3='',@monto_ref_3=0,@serie_doc_ref_4='',@nro_doc_ref_4='',@monto_ref_4=0
								
			------------------------------------------------------------------------------
			--// Cargamos estructura de facturas 1
				INSERT @TT_FACTURAS (cod_cliente,serie_doc,nro_doc,monto,serie_doc_ref,nro_doc_ref)
				SELECT DCC.ID_CLIENTE,DCC.SERIE_DOC,DCC.NRO_DOC,DCC.TOTAL_FINAL,DGFR.SERIE_DOC,DGFR.NRO_DOC
				FROM DOCUMENTO_CC DCC
				----------------------------------------------
				INNER JOIN DOC_GESTION_FA_REF_DOC_CC DGFR ON DCC.CIA=DGFR.CIA AND DCC.SEDE=DGFR.SEDE AND 
				DCC.ID_TIPO_DOC=DGFR.ID_TIPO_DOC_REF AND DCC.SERIE_DOC=DGFR.SERIE_DOC_REF AND DCC.NRO_DOC=DGFR.NRO_DOC_REF
				--------------------------------------------------------------------------------------------------------------------------
				WHERE DCC.CIA=@CIA and DCC.SEDE=@SEDE AND CONVERT(VARCHAR(8),DCC.FECHA_DOCUMENTO,112)>=@FEC1 AND DCC.ID_ESTADO='13'
				AND DGFR.SERIE_DOC=@serie_doc AND DGFR.NRO_DOC=@nro_doc AND DCC.ID_TIPO_DOC='01'
				----------------------------------------------
				GROUP BY DGFR.SERIE_DOC,DGFR.NRO_DOC,DCC.SERIE_DOC,DCC.NRO_DOC,DCC.TOTAL_FINAL,DCC.ID_CLIENTE
				ORDER BY DGFR.NRO_DOC
			------------------------------------------------------------------------------
			--// Cargamos estructura de facturas 2
				/*insert @TT_FACTURAS (cod_cliente,serie_doc,nro_doc,monto,serie_doc_ref,nro_doc_ref)
				SELECT DCC.ID_CLIENTE,DCC.SERIE_DOC,DCC.NRO_DOC,DCC.TOTAL_FINAL,DCCG.SERIE_DOC_REF,DCCG.NRO_DOC_REF
				FROM DOCUMENTO_CC DCC
				----------------------------------------------
				INNER JOIN DOCUMENTO_CC_DETALLE DCCD ON DCC.CIA=DCCD.CIA AND DCC.SEDE=DCCD.SEDE AND 
				DCC.ID_TIPO_DOC=DCCD.ID_TIPO_DOC AND DCC.SERIE_DOC=DCCD.SERIE_DOC AND DCC.NRO_DOC=DCCD.NRO_DOC
				--------------------------------------------------------------------------------------------------------------------------
				INNER JOIN DOCUMENTO_CC_GESTION DCCG ON DCCD.CIA=DCCG.CIA AND DCCD.SEDE=DCCG.SEDE AND 
				DCCD.ID_TIPO_DOC=DCCG.ID_TIPO_DOC AND DCCD.SERIE_DOC=DCCG.SERIE_DOC AND DCCD.NRO_DOC=DCCG.NRO_DOC AND DCCD.ITEM=DCCG.ITEM
				--------------------------------------------------------------------------------------------------------------------------
				WHERE DCC.CIA=@CIA and DCC.SEDE=@SEDE AND CONVERT(VARCHAR(8),DCC.FECHA_DOCUMENTO,112)>=@FEC1 AND DCC.ID_ESTADO!='12'
				AND DCCG.SERIE_DOC_REF=@serie_doc AND DCCG.NRO_DOC_REF=@nro_doc
				----------------------------------------------
				GROUP BY DCCG.SERIE_DOC_REF,DCCG.NRO_DOC_REF,DCC.SERIE_DOC,DCC.NRO_DOC,DCC.TOTAL_FINAL,DCC.ID_CLIENTE
				ORDER BY DCCG.NRO_DOC_REF*/
------------------------------------------------------------------------------
			select @ind = min(secc) from @TT_FACTURAS WHERE serie_doc_ref=@serie_doc AND nro_doc_ref=@nro_doc
			select @n_contador = count(secc) from @TT_FACTURAS WHERE serie_doc_ref=@serie_doc AND nro_doc_ref=@nro_doc
			
			if @n_contador >= 1 begin  
				select @serie_doc_ref_1 = serie_doc from @TT_FACTURAS where serie_doc_ref=@serie_doc and nro_doc_ref=@nro_doc and secc=@ind
				select @nro_doc_ref_1 = nro_doc from @TT_FACTURAS where serie_doc_ref=@serie_doc and nro_doc_ref=@nro_doc and secc=@ind
				select @monto_ref_1 = monto from @TT_FACTURAS where serie_doc_ref=@serie_doc and nro_doc_ref=@nro_doc and secc=@ind
			end
			
			if @n_contador >= 2 begin  
				select @serie_doc_ref_2 = serie_doc from @TT_FACTURAS where serie_doc_ref=@serie_doc and nro_doc_ref=@nro_doc and secc=(@ind+1)
				select @nro_doc_ref_2 = nro_doc from @TT_FACTURAS where serie_doc_ref=@serie_doc and nro_doc_ref=@nro_doc and secc=(@ind+1)
				select @monto_ref_2 = monto from @TT_FACTURAS where serie_doc_ref=@serie_doc and nro_doc_ref=@nro_doc and secc=(@ind+1)
			end
			
			if @n_contador >= 3 begin  
				select @serie_doc_ref_3 = serie_doc from @TT_FACTURAS where serie_doc_ref=@serie_doc and nro_doc_ref=@nro_doc and secc=(@ind+2)
				select @nro_doc_ref_3 = nro_doc from @TT_FACTURAS where serie_doc_ref=@serie_doc and nro_doc_ref=@nro_doc and secc=(@ind+2)
				select @monto_ref_3 = monto from @TT_FACTURAS where serie_doc_ref=@serie_doc and nro_doc_ref=@nro_doc and secc=(@ind+2)
			end
			
			if @n_contador >= 4 begin  
				select @serie_doc_ref_4 = serie_doc from @TT_FACTURAS where serie_doc_ref=@serie_doc and nro_doc_ref=@nro_doc and secc=(@ind+3)
				select @nro_doc_ref_4 = nro_doc from @TT_FACTURAS where serie_doc_ref=@serie_doc and nro_doc_ref=@nro_doc and secc=(@ind+3)
				select @monto_ref_4 = monto from @TT_FACTURAS where serie_doc_ref=@serie_doc and nro_doc_ref=@nro_doc and secc=(@ind+3)
			end
			------------------------------------------------------------------------------
			if (@id_condi ='01') or (@id_condi ='03') or (@id_condi ='04') or (@id_condi ='05') or (@id_condi ='11') or (@id_condi ='17')
				 or (@id_condi ='31') or (@id_condi ='32') or (@id_condi ='33') or (@id_condi ='35') or (@id_condi ='36') or (@id_condi ='38')  
			begin 
					if len(@nro_doc_ref_1)>0 begin
					update @TT_DATOS set serie_doc_pago1=@serie_doc_ref_1,nro_doc_pago1=@nro_doc_ref_1,monto_pago1=@monto_ref_1
					where serie_doc=@serie_doc and nro_doc=@nro_doc and cod_cliente=@cod_cliente and secc=@in_rowt
					end
					else 
					begin
						update @TT_DATOS set monto_deuda1=@monto
					where serie_doc=@serie_doc and nro_doc=@nro_doc and cod_cliente=@cod_cliente and secc=@in_rowt
					end
			end
			else if @id_condi ='02'
			begin 
			select @monto_deuda1=@monto*0.7
			select @monto_deuda2=@monto*0.3
					if len(@serie_doc_ref_1)>0 begin
						update @TT_DATOS set serie_doc_pago1=@serie_doc_ref_1,nro_doc_pago1=@nro_doc_ref_1,monto_pago1=@monto_ref_1
						where serie_doc=@serie_doc and nro_doc=@nro_doc and cod_cliente=@cod_cliente and secc=@in_rowt
					end
					else 
					begin 
						update @TT_DATOS set monto_deuda1=@monto_deuda1
						where serie_doc=@serie_doc and nro_doc=@nro_doc and cod_cliente=@cod_cliente and secc=@in_rowt
					end
					if len(@serie_doc_ref_2)>0 begin
						update @TT_DATOS set serie_doc_pago2=@serie_doc_ref_2,nro_doc_pago2=@nro_doc_ref_2,monto_pago2=@monto_ref_2
						where serie_doc=@serie_doc and nro_doc=@nro_doc and cod_cliente=@cod_cliente and secc=@in_rowt
					end
					else 
					begin 
						update @TT_DATOS set monto_deuda2=@monto_deuda2
						where serie_doc=@serie_doc and nro_doc=@nro_doc and cod_cliente=@cod_cliente and secc=@in_rowt
					end	
			end
			else if @id_condi ='06'
			begin 
			select @monto_deuda1=@monto*0.5
			select @monto_deuda2=@monto*0.3
			select @monto_deuda3=@monto*0.2
					if len(@serie_doc_ref_1)>0 begin
						update @TT_DATOS set serie_doc_pago1=@serie_doc_ref_1,nro_doc_pago1=@nro_doc_ref_1,monto_pago1=@monto_ref_1
						where serie_doc=@serie_doc and nro_doc=@nro_doc and cod_cliente=@cod_cliente and secc=@in_rowt
					end
					else 
					begin 
						update @TT_DATOS set monto_deuda1=@monto_deuda1
						where serie_doc=@serie_doc and nro_doc=@nro_doc and cod_cliente=@cod_cliente and secc=@in_rowt
					end
					if len(@serie_doc_ref_2)>0 begin
						update @TT_DATOS set serie_doc_pago2=@serie_doc_ref_2,nro_doc_pago2=@nro_doc_ref_2,monto_pago2=@monto_ref_2
						where serie_doc=@serie_doc and nro_doc=@nro_doc and cod_cliente=@cod_cliente and secc=@in_rowt
					end
					else 
					begin 
						update @TT_DATOS set monto_deuda2=@monto_deuda2
						where serie_doc=@serie_doc and nro_doc=@nro_doc and cod_cliente=@cod_cliente and secc=@in_rowt
					end
					if len(@serie_doc_ref_3)>0 begin
						update @TT_DATOS set serie_doc_pago3=@serie_doc_ref_3,nro_doc_pago3=@nro_doc_ref_3,monto_pago3=@monto_ref_3
						where serie_doc=@serie_doc and nro_doc=@nro_doc and cod_cliente=@cod_cliente and secc=@in_rowt
					end
					else 
					begin 
						update @TT_DATOS set monto_deuda3=@monto_deuda3
						where serie_doc=@serie_doc and nro_doc=@nro_doc and cod_cliente=@cod_cliente and secc=@in_rowt
					end
			end
			else if @id_condi ='07'
			begin 
			select @monto_deuda1=@monto*0.4
			select @monto_deuda2=@monto*0.4
			select @monto_deuda3=@monto*0.2
					if len(@serie_doc_ref_1)>0 begin
						update @TT_DATOS set serie_doc_pago1=@serie_doc_ref_1,nro_doc_pago1=@nro_doc_ref_1,monto_pago1=@monto_ref_1
						where serie_doc=@serie_doc and nro_doc=@nro_doc and cod_cliente=@cod_cliente and secc=@in_rowt
					end
					else 
					begin 
						update @TT_DATOS set monto_deuda1=@monto_deuda1
						where serie_doc=@serie_doc and nro_doc=@nro_doc and cod_cliente=@cod_cliente and secc=@in_rowt
					end
					if len(@serie_doc_ref_2)>0 begin
						update @TT_DATOS set serie_doc_pago2=@serie_doc_ref_2,nro_doc_pago2=@nro_doc_ref_2,monto_pago2=@monto_ref_2
						where serie_doc=@serie_doc and nro_doc=@nro_doc and cod_cliente=@cod_cliente and secc=@in_rowt
					end
					else 
					begin 
						update @TT_DATOS set monto_deuda2=@monto_deuda2
						where serie_doc=@serie_doc and nro_doc=@nro_doc and cod_cliente=@cod_cliente and secc=@in_rowt
					end
					if len(@serie_doc_ref_3)>0 begin
						update @TT_DATOS set serie_doc_pago3=@serie_doc_ref_3,nro_doc_pago3=@nro_doc_ref_3,monto_pago3=@monto_ref_3
						where serie_doc=@serie_doc and nro_doc=@nro_doc and cod_cliente=@cod_cliente and secc=@in_rowt
					end
					else 
					begin 
						update @TT_DATOS set monto_deuda3=@monto_deuda3
						where serie_doc=@serie_doc and nro_doc=@nro_doc and cod_cliente=@cod_cliente and secc=@in_rowt
					end
			end
			else if @id_condi ='08'
			begin 
			select @monto_deuda1=@monto*0.5
			select @monto_deuda2=@monto*0.4
			select @monto_deuda3=@monto*0.1
					if len(@serie_doc_ref_1)>0 begin
						update @TT_DATOS set serie_doc_pago1=@serie_doc_ref_1,nro_doc_pago1=@nro_doc_ref_1,monto_pago1=@monto_ref_1
						where serie_doc=@serie_doc and nro_doc=@nro_doc and cod_cliente=@cod_cliente and secc=@in_rowt
					end
					else 
					begin 
						update @TT_DATOS set monto_deuda1=@monto_deuda1
						where serie_doc=@serie_doc and nro_doc=@nro_doc and cod_cliente=@cod_cliente and secc=@in_rowt
					end
					if len(@serie_doc_ref_2)>0 begin
						update @TT_DATOS set serie_doc_pago2=@serie_doc_ref_2,nro_doc_pago2=@nro_doc_ref_2,monto_pago2=@monto_ref_2
						where serie_doc=@serie_doc and nro_doc=@nro_doc and cod_cliente=@cod_cliente and secc=@in_rowt
					end
					else 
					begin 
						update @TT_DATOS set monto_deuda2=@monto_deuda2
						where serie_doc=@serie_doc and nro_doc=@nro_doc and cod_cliente=@cod_cliente and secc=@in_rowt
					end
					if len(@serie_doc_ref_3)>0 begin
						update @TT_DATOS set serie_doc_pago3=@serie_doc_ref_3,nro_doc_pago3=@nro_doc_ref_3,monto_pago3=@monto_ref_3
						where serie_doc=@serie_doc and nro_doc=@nro_doc and cod_cliente=@cod_cliente and secc=@in_rowt
					end
					else 
					begin 
						update @TT_DATOS set monto_deuda3=@monto_deuda3
						where serie_doc=@serie_doc and nro_doc=@nro_doc and cod_cliente=@cod_cliente and secc=@in_rowt
					end
			end
			else if @id_condi ='09'
			begin 
			select @monto_deuda1=@monto*0.6
			select @monto_deuda2=@monto*0.4
					if len(@serie_doc_ref_1)>0 begin
						update @TT_DATOS set serie_doc_pago1=@serie_doc_ref_1,nro_doc_pago1=@nro_doc_ref_1,monto_pago1=@monto_ref_1
						where serie_doc=@serie_doc and nro_doc=@nro_doc and cod_cliente=@cod_cliente and secc=@in_rowt
					end
					else 
					begin 
						update @TT_DATOS set monto_deuda1=@monto_deuda1
						where serie_doc=@serie_doc and nro_doc=@nro_doc and cod_cliente=@cod_cliente and secc=@in_rowt
					end
					if len(@serie_doc_ref_2)>0 begin
						update @TT_DATOS set serie_doc_pago2=@serie_doc_ref_2,nro_doc_pago2=@nro_doc_ref_2,monto_pago2=@monto_ref_2
						where serie_doc=@serie_doc and nro_doc=@nro_doc and cod_cliente=@cod_cliente and secc=@in_rowt
					end
					else 
					begin 
						update @TT_DATOS set monto_deuda2=@monto_deuda2
						where serie_doc=@serie_doc and nro_doc=@nro_doc and cod_cliente=@cod_cliente and secc=@in_rowt
					end
			end
			else if (@id_condi ='10') or (@id_condi ='14') or (@id_condi ='20')
			begin 
			select @monto_deuda1=@monto*0.5
			select @monto_deuda2=@monto*0.5
					if len(@serie_doc_ref_1)>0 begin
						update @TT_DATOS set serie_doc_pago1=@serie_doc_ref_1,nro_doc_pago1=@nro_doc_ref_1,monto_pago1=@monto_ref_1
						where serie_doc=@serie_doc and nro_doc=@nro_doc and cod_cliente=@cod_cliente and secc=@in_rowt
					end
					else 
					begin 
						update @TT_DATOS set monto_deuda1=@monto_deuda1
						where serie_doc=@serie_doc and nro_doc=@nro_doc and cod_cliente=@cod_cliente and secc=@in_rowt
					end
					if len(@serie_doc_ref_2)>0 begin
						update @TT_DATOS set serie_doc_pago2=@serie_doc_ref_2,nro_doc_pago2=@nro_doc_ref_2,monto_pago2=@monto_ref_2
						where serie_doc=@serie_doc and nro_doc=@nro_doc and cod_cliente=@cod_cliente and secc=@in_rowt
					end
					else 
					begin 
						update @TT_DATOS set monto_deuda2=@monto_deuda2
						where serie_doc=@serie_doc and nro_doc=@nro_doc and cod_cliente=@cod_cliente and secc=@in_rowt
					end
			end
			else if @id_condi ='12'
			begin 
			select @monto_deuda1=@monto*0.5
			select @monto_deuda2=@monto*0.25
			select @monto_deuda3=@monto*0.25
					if len(@serie_doc_ref_1)>0 begin
						update @TT_DATOS set serie_doc_pago1=@serie_doc_ref_1,nro_doc_pago1=@nro_doc_ref_1,monto_pago1=@monto_ref_1
						where serie_doc=@serie_doc and nro_doc=@nro_doc and cod_cliente=@cod_cliente and secc=@in_rowt
					end
					else 
					begin 
						update @TT_DATOS set monto_deuda1=@monto_deuda1
						where serie_doc=@serie_doc and nro_doc=@nro_doc and cod_cliente=@cod_cliente and secc=@in_rowt
					end
					if len(@serie_doc_ref_2)>0 begin
						update @TT_DATOS set serie_doc_pago2=@serie_doc_ref_2,nro_doc_pago2=@nro_doc_ref_2,monto_pago2=@monto_ref_2
						where serie_doc=@serie_doc and nro_doc=@nro_doc and cod_cliente=@cod_cliente and secc=@in_rowt
					end
					else 
					begin 
						update @TT_DATOS set monto_deuda2=@monto_deuda2
						where serie_doc=@serie_doc and nro_doc=@nro_doc and cod_cliente=@cod_cliente and secc=@in_rowt
					end
					if len(@serie_doc_ref_3)>0 begin
						update @TT_DATOS set serie_doc_pago3=@serie_doc_ref_3,nro_doc_pago3=@nro_doc_ref_3,monto_pago3=@monto_ref_3
						where serie_doc=@serie_doc and nro_doc=@nro_doc and cod_cliente=@cod_cliente and secc=@in_rowt
					end
					else 
					begin 
						update @TT_DATOS set monto_deuda3=@monto_deuda3
						where serie_doc=@serie_doc and nro_doc=@nro_doc and cod_cliente=@cod_cliente and secc=@in_rowt
					end
			end
			else if @id_condi ='13'
			begin 
			select @monto_deuda1=@monto*0.6
			select @monto_deuda2=@monto*0.3
			select @monto_deuda3=@monto*0.1
					if len(@serie_doc_ref_1)>0 begin
						update @TT_DATOS set serie_doc_pago1=@serie_doc_ref_1,nro_doc_pago1=@nro_doc_ref_1,monto_pago1=@monto_ref_1
						where serie_doc=@serie_doc and nro_doc=@nro_doc and cod_cliente=@cod_cliente and secc=@in_rowt
					end
					else 
					begin 
						update @TT_DATOS set monto_deuda1=@monto_deuda1
						where serie_doc=@serie_doc and nro_doc=@nro_doc and cod_cliente=@cod_cliente and secc=@in_rowt
					end
					if len(@serie_doc_ref_2)>0 begin
						update @TT_DATOS set serie_doc_pago2=@serie_doc_ref_2,nro_doc_pago2=@nro_doc_ref_2,monto_pago2=@monto_ref_2
						where serie_doc=@serie_doc and nro_doc=@nro_doc and cod_cliente=@cod_cliente and secc=@in_rowt
					end
					else 
					begin 
						update @TT_DATOS set monto_deuda2=@monto_deuda2
						where serie_doc=@serie_doc and nro_doc=@nro_doc and cod_cliente=@cod_cliente and secc=@in_rowt
					end
					if len(@serie_doc_ref_3)>0 begin
						update @TT_DATOS set serie_doc_pago3=@serie_doc_ref_3,nro_doc_pago3=@nro_doc_ref_3,monto_pago3=@monto_ref_3
						where serie_doc=@serie_doc and nro_doc=@nro_doc and cod_cliente=@cod_cliente and secc=@in_rowt
					end
					else 
					begin 
						update @TT_DATOS set monto_deuda3=@monto_deuda3
						where serie_doc=@serie_doc and nro_doc=@nro_doc and cod_cliente=@cod_cliente and secc=@in_rowt
					end
			end
			else if @id_condi ='15'
			begin 
			select @monto_deuda1=@monto*0.55
			select @monto_deuda2=@monto*0.45
					if len(@serie_doc_ref_1)>0 begin
						update @TT_DATOS set serie_doc_pago1=@serie_doc_ref_1,nro_doc_pago1=@nro_doc_ref_1,monto_pago1=@monto_ref_1
						where serie_doc=@serie_doc and nro_doc=@nro_doc and cod_cliente=@cod_cliente and secc=@in_rowt
					end
					else 
					begin 
						update @TT_DATOS set monto_deuda1=@monto_deuda1
						where serie_doc=@serie_doc and nro_doc=@nro_doc and cod_cliente=@cod_cliente and secc=@in_rowt
					end
					if len(@serie_doc_ref_2)>0 begin
						update @TT_DATOS set serie_doc_pago2=@serie_doc_ref_2,nro_doc_pago2=@nro_doc_ref_2,monto_pago2=@monto_ref_2
						where serie_doc=@serie_doc and nro_doc=@nro_doc and cod_cliente=@cod_cliente and secc=@in_rowt
					end
					else 
					begin 
						update @TT_DATOS set monto_deuda2=@monto_deuda2
						where serie_doc=@serie_doc and nro_doc=@nro_doc and cod_cliente=@cod_cliente and secc=@in_rowt
					end
			end
			else if @id_condi ='16'
			begin 
			select @monto_deuda1=@monto*0.3
			select @monto_deuda2=@monto*0.3
			select @monto_deuda3=@monto*0.3
			select @monto_deuda4=@monto*0.1
					if len(@serie_doc_ref_1)>0 begin
						update @TT_DATOS set serie_doc_pago1=@serie_doc_ref_1,nro_doc_pago1=@nro_doc_ref_1,monto_pago1=@monto_ref_1
						where serie_doc=@serie_doc and nro_doc=@nro_doc and cod_cliente=@cod_cliente and secc=@in_rowt
					end
					else 
					begin 
						update @TT_DATOS set monto_deuda1=@monto_deuda1
						where serie_doc=@serie_doc and nro_doc=@nro_doc and cod_cliente=@cod_cliente and secc=@in_rowt
					end
					if len(@serie_doc_ref_2)>0 begin
						update @TT_DATOS set serie_doc_pago2=@serie_doc_ref_2,nro_doc_pago2=@nro_doc_ref_2,monto_pago2=@monto_ref_2
						where serie_doc=@serie_doc and nro_doc=@nro_doc and cod_cliente=@cod_cliente and secc=@in_rowt
					end
					else 
					begin 
						update @TT_DATOS set monto_deuda2=@monto_deuda2
						where serie_doc=@serie_doc and nro_doc=@nro_doc and cod_cliente=@cod_cliente and secc=@in_rowt
					end
					if len(@serie_doc_ref_3)>0 begin
						update @TT_DATOS set serie_doc_pago3=@serie_doc_ref_3,nro_doc_pago3=@nro_doc_ref_3,monto_pago3=@monto_ref_3
						where serie_doc=@serie_doc and nro_doc=@nro_doc and cod_cliente=@cod_cliente and secc=@in_rowt
					end
					else 
					begin 
						update @TT_DATOS set monto_deuda3=@monto_deuda3
						where serie_doc=@serie_doc and nro_doc=@nro_doc and cod_cliente=@cod_cliente and secc=@in_rowt
					end
					if len(@serie_doc_ref_4)>0 begin
						update @TT_DATOS set serie_doc_pago4=@serie_doc_ref_4,nro_doc_pago4=@nro_doc_ref_4,monto_pago4=@monto_ref_4
						where serie_doc=@serie_doc and nro_doc=@nro_doc and cod_cliente=@cod_cliente and secc=@in_rowt
					end
					else 
					begin 
						update @TT_DATOS set monto_deuda4=@monto_deuda4
						where serie_doc=@serie_doc and nro_doc=@nro_doc and cod_cliente=@cod_cliente and secc=@in_rowt
					end
			end
			else if @id_condi ='34'
			begin 
			select @monto_deuda1=@monto*0.6
			select @monto_deuda2=@monto*0.2
			select @monto_deuda3=@monto*0.2
					if len(@serie_doc_ref_1)>0 begin
						update @TT_DATOS set serie_doc_pago1=@serie_doc_ref_1,nro_doc_pago1=@nro_doc_ref_1,monto_pago1=@monto_ref_1
						where serie_doc=@serie_doc and nro_doc=@nro_doc and cod_cliente=@cod_cliente and secc=@in_rowt
					end
					else 
					begin 
						update @TT_DATOS set monto_deuda1=@monto_deuda1
						where serie_doc=@serie_doc and nro_doc=@nro_doc and cod_cliente=@cod_cliente and secc=@in_rowt
					end
					if len(@serie_doc_ref_2)>0 begin
						update @TT_DATOS set serie_doc_pago2=@serie_doc_ref_2,nro_doc_pago2=@nro_doc_ref_2,monto_pago2=@monto_ref_2
						where serie_doc=@serie_doc and nro_doc=@nro_doc and cod_cliente=@cod_cliente and secc=@in_rowt
					end
					else 
					begin 
						update @TT_DATOS set monto_deuda2=@monto_deuda2
						where serie_doc=@serie_doc and nro_doc=@nro_doc and cod_cliente=@cod_cliente and secc=@in_rowt
					end
					if len(@serie_doc_ref_3)>0 begin
						update @TT_DATOS set serie_doc_pago3=@serie_doc_ref_3,nro_doc_pago3=@nro_doc_ref_3,monto_pago3=@monto_ref_3
						where serie_doc=@serie_doc and nro_doc=@nro_doc and cod_cliente=@cod_cliente and secc=@in_rowt
					end
					else 
					begin 
						update @TT_DATOS set monto_deuda3=@monto_deuda3
						where serie_doc=@serie_doc and nro_doc=@nro_doc and cod_cliente=@cod_cliente and secc=@in_rowt
					end
			end
			else if @id_condi ='37'
			begin 
			select @monto_deuda1=@monto*0.25
			select @monto_deuda2=@monto*0.75
					if len(@serie_doc_ref_1)>0 begin
						update @TT_DATOS set serie_doc_pago1=@serie_doc_ref_1,nro_doc_pago1=@nro_doc_ref_1,monto_pago1=@monto_ref_1
						where serie_doc=@serie_doc and nro_doc=@nro_doc and cod_cliente=@cod_cliente and secc=@in_rowt
					end
					else 
					begin 
						update @TT_DATOS set monto_deuda1=@monto_deuda1
						where serie_doc=@serie_doc and nro_doc=@nro_doc and cod_cliente=@cod_cliente and secc=@in_rowt
					end
					if len(@serie_doc_ref_2)>0 begin
						update @TT_DATOS set serie_doc_pago2=@serie_doc_ref_2,nro_doc_pago2=@nro_doc_ref_2,monto_pago2=@monto_ref_2
						where serie_doc=@serie_doc and nro_doc=@nro_doc and cod_cliente=@cod_cliente and secc=@in_rowt
					end
					else 
					begin 
						update @TT_DATOS set monto_deuda2=@monto_deuda2
						where serie_doc=@serie_doc and nro_doc=@nro_doc and cod_cliente=@cod_cliente and secc=@in_rowt
					end
			end
	set @in_rowt = @in_rowt + 1
end

select secc,cia,sede,cliente 'Estacion',convert(varchar(10),fecha,103) 'Fecha',serie_doc+'_'+nro_doc 'Cotizacion',monto 'Monto',
		serie_doc_pago1+'-'+nro_doc_pago1 '# Factura',monto_pago1,monto_deuda1,
		serie_doc_pago2+'-'+nro_doc_pago2 '# Factura',monto_pago2,monto_deuda2,
		serie_doc_pago3+'-'+nro_doc_pago3 '# Factura',monto_pago3,monto_deuda3,
		serie_doc_pago4+'-'+nro_doc_pago4 '# Factura',monto_pago4,monto_deuda4 FROM @TT_DATOS	


--select * from @TT_FACTURAS

-- SP_R_MONTAJE '01','01','','','15/11/2010','28/12/2010'
GO
/****** Object:  StoredProcedure [dbo].[SP_R_SOPORTE_D]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*

SP_R_SOPORTE_D '01','01','42953327','15-10-2010','30-11-2011'

*/

CREATE PROCEDURE [dbo].[SP_R_SOPORTE_D]
@CIA CHAR(2),@SEDE CHAR(2),@TECNICO VARCHAR(20),@INICIO DATETIME,@FIN DATETIME
AS
-------------------------------------------------------------------------------
DECLARE @sExecute varchar(max),@sSelect varchar(max),@sTec varchar(max),@sTipo varchar(max),@sEtacion varchar(max),@sGroup varchar(max)
DECLARE @FEC1 varchar(8),@FEC2 varchar(8)
-------------------------------------------------------------------------------
SET @FEC1=CONVERT(VARCHAR(8),@INICIO,112)
SET @FEC2=CONVERT(VARCHAR(8),@FIN,112)
-------------------------------------------------------------------------------
SELECT @sExecute='',@sSelect='',@sTipo='',@sEtacion='',@sGroup='',@sTec=''
-------------------------------------------------------------------------------
SELECT @sSelect='
CON.DESCRIPCION ''CIA'',SE.DESCRIPCION ''SEDE'',A2.DESCRIPCION ''TECNICO'',ST.SERIE_DOC+''-''+ST.NRO_DOC ''documento'',
A.DESCRIPCION ''cliente'',CONVERT(VARCHAR,MS.DESCRIPCION) ''motivo'',
		CONVERT(varchar(max),ST.INFORMACION_TECNICA) ''solucion'',ST.INICIO_SERVICIO,ST.FIN_SERVICIO,E.DESCRIPCION ''estado'',
		STD.ITEM,AR.DESCRIPCION,STD.CANTIDAD
FROM SERVICIO_TECNICO ST
INNER JOIN COMPANIA CON ON CON.CIA=ST.CIA
INNER JOIN SEDE SE ON SE.CIA=ST.CIA AND SE.SEDE=ST.SEDE
INNER JOIN MOTIVO_SERVICIO MS ON MS.CIA=ST.CIA AND MS.ID_MOTIVO_SERVICIO=ST.ID_MOTIVO_SERVICIO
INNER JOIN ANALITICA A ON A.CIA=ST.CIA AND A.ID_ANALITICA=ST.ID_CLIENTE
INNER JOIN ANALITICA A2 ON A2.CIA=ST.CIA AND A2.ID_ANALITICA=ST.ID_TECNICO
INNER JOIN SERVICIO_TECNICO_DETALLE STD ON STD.CIA=ST.CIA AND STD.SEDE=ST.SEDE AND STD.ID_TIPO_DOC=ST.ID_TIPO_DOC 
												AND STD.SERIE_DOC=ST.SERIE_DOC AND STD.NRO_DOC=ST.NRO_DOC
INNER JOIN ARTICULO AR ON AR.CIA=STD.CIA AND AR.ID_ARTICULO=STD.ID_ARTICULO
INNER JOIN ESTADO E ON E.CIA=ST.CIA AND E.ID_ESTADO=ST.ID_ESTADO
WHERE ST.CIA='''+@CIA+''' AND ST.SEDE='''+@SEDE+''' AND 
CONVERT(VARCHAR(8),ST.FIN_SERVICIO,112) BETWEEN '''+@FEC1+''' AND '''+@FEC2+''''
------------------------------------------------------------------------------------------------------------------
	IF  LEN(@TECNICO)>0 begin SELECT @sTec='AND ST.ID_TECNICO='''+@TECNICO+'''' END
	ELSE BEGIN SELECT @sTec='' END
------------------------------------------------------------------------------------------------------------------	
SELECT	@sGroup='GROUP BY CON.DESCRIPCION,SE.DESCRIPCION,A2.DESCRIPCION,ST.SERIE_DOC,ST.NRO_DOC,A.DESCRIPCION,CONVERT(VARCHAR,MS.DESCRIPCION),
		CONVERT(varchar(max),ST.INFORMACION_TECNICA),ST.INICIO_SERVICIO,ST.FIN_SERVICIO,E.DESCRIPCION,STD.ITEM,AR.DESCRIPCION,STD.CANTIDAD'
------------------------------------------------------------------------------------------------------------------
SELECT @sExecute = @sSelect +' '+ @sTec+' '+@sGroup
-------------------------------------------------------------------------------
--PRINT @sExecute
EXEC ('SELECT '+ @sExecute )
GO
/****** Object:  StoredProcedure [dbo].[SP_R_SOPORTE_E]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*

SP_R_SOPORTE_E '01','01','','','15-10-2008','30-11-2010'

*/

CREATE PROCEDURE [dbo].[SP_R_SOPORTE_E]
@CIA CHAR(2),@SEDE CHAR(2),@TIPO VARCHAR(1),@ESTACION VARCHAR(20),@INICIO DATETIME,@FIN DATETIME
AS
-------------------------------------------------------------------------------
DECLARE @sExecute varchar(max),@sSelect varchar(max),@sTipo varchar(max),@sEtacion varchar(max),@sGroup varchar(max)
DECLARE @FEC1 varchar(8),@FEC2 varchar(8)
-------------------------------------------------------------------------------
SET @FEC1=CONVERT(VARCHAR(8),@INICIO,112)
SET @FEC2=CONVERT(VARCHAR(8),@FIN,112)
-------------------------------------------------------------------------------
SELECT @sExecute='',@sSelect='',@sTipo='',@sEtacion='',@sGroup=''
-------------------------------------------------------------------------------
SELECT @sSelect='
CON.DESCRIPCION ''CIA'',SE.DESCRIPCION ''SEDE'',A.DESCRIPCION ''cliente'',
case AT.FLAG_CON_CONTRATO	when ''0'' then ''NO CONTRATADO'' else ''CONTRATADO'' end as	''tipo_cliente'',ST.SERIE_DOC+''-''+ST.NRO_DOC ''documento'',
CONVERT(VARCHAR(MAX),MS.DESCRIPCION)	''motivo'',CONVERT(VARCHAR(max),ST.INFORMACION_TECNICA) ''solucion'',
		A2.DESCRIPCION ''TECNICO'',ST.INICIO_SERVICIO,ST.FIN_SERVICIO,E.DESCRIPCION ''estado'',
		STD.ITEM,AR.DESCRIPCION,STD.CANTIDAD
FROM SERVICIO_TECNICO ST
INNER JOIN COMPANIA CON ON CON.CIA=ST.CIA
INNER JOIN SEDE SE ON SE.CIA=ST.CIA AND SE.SEDE=ST.SEDE
INNER JOIN MOTIVO_SERVICIO MS ON MS.CIA=ST.CIA AND MS.ID_MOTIVO_SERVICIO=ST.ID_MOTIVO_SERVICIO
INNER JOIN ANALITICA A ON A.CIA=ST.CIA AND A.ID_ANALITICA=ST.ID_CLIENTE
INNER JOIN ANALITICA A2 ON A2.CIA=ST.CIA AND A2.ID_ANALITICA=ST.ID_TECNICO
INNER JOIN SERVICIO_TECNICO_DETALLE STD ON STD.CIA=ST.CIA AND STD.SEDE=ST.SEDE AND STD.ID_TIPO_DOC=ST.ID_TIPO_DOC 
												AND STD.SERIE_DOC=ST.SERIE_DOC AND STD.NRO_DOC=ST.NRO_DOC
INNER JOIN ARTICULO AR ON AR.CIA=STD.CIA AND AR.ID_ARTICULO=STD.ID_ARTICULO
INNER JOIN ESTADO E ON E.CIA=ST.CIA AND E.ID_ESTADO=ST.ID_ESTADO
INNER JOIN ANALITICA_TIPO AT ON at.cia=a.cia AND at.id_analitica=a.id_analitica 
INNER JOIN TIPO_ANALITICA TA ON ta.cia=at.cia AND ta.id_tipo_analitica=at.id_tipo_analitica
WHERE ST.CIA='''+@CIA+''' AND ST.SEDE='''+@SEDE+'''   AND
CONVERT(VARCHAR(8),ST.FIN_SERVICIO,112) BETWEEN '''+@FEC1+''' AND '''+@FEC2+''''
------------------------------------------------------------------------------------------------------------------
	IF  LEN(@TIPO)>0 begin SELECT @sTipo='AND AT.FLAG_CON_CONTRATO='''+@TIPO+'''' END
	ELSE BEGIN SELECT @sTipo='' END
------------------------------------------------------------------------------------------------------------------
	IF  LEN(@ESTACION)>0 begin SELECT @sEtacion='AND A.ID_ANALITICA='''+@ESTACION+'''' END
	ELSE BEGIN SELECT @sEtacion='' END
------------------------------------------------------------------------------------------------------------------
SELECT	@sGroup='GROUP BY CON.DESCRIPCION,SE.DESCRIPCION,A.DESCRIPCION,AT.FLAG_CON_CONTRATO,ST.SERIE_DOC,ST.NRO_DOC ,
A2.DESCRIPCION,ST.INICIO_SERVICIO,ST.FIN_SERVICIO,E.DESCRIPCION,STD.ITEM,AR.DESCRIPCION,STD.CANTIDAD,MS.DESCRIPCION,CONVERT(VARCHAR(max),ST.INFORMACION_TECNICA)'
------------------------------------------------------------------------------------------------------------------
SELECT @sExecute = @sSelect +' '+ @sTipo +' '+ @sEtacion+' '+@sGroup
-------------------------------------------------------------------------------
EXEC ('SELECT '+ @sExecute )
GO
/****** Object:  StoredProcedure [dbo].[SP_R_VISITA_T]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*

SP_R_VISITA_T '01','01','','0','','15-10-2008','30-10-2010'

*/

CREATE PROCEDURE [dbo].[SP_R_VISITA_T]
@CIA CHAR(2),@SEDE CHAR(2),@TECNICO VARCHAR(20),@TIPO VARCHAR(1),@ESTACION VARCHAR(20),@INICIO DATETIME,@FIN DATETIME
AS
-------------------------------------------------------------------------------
DECLARE @sExecute varchar(max),@sSelect varchar(max),@sTec varchar(max),@sTipo varchar(max),@sEtacion varchar(max),@sGroup varchar(max)
DECLARE @FEC1 varchar(8),@FEC2 varchar(8)
-------------------------------------------------------------------------------
SET @FEC1=CONVERT(VARCHAR(8),@INICIO,112)
SET @FEC2=CONVERT(VARCHAR(8),@FIN,112)
-------------------------------------------------------------------------------
SELECT @sExecute='',@sSelect='',@sTipo='',@sEtacion='',@sGroup=''


------------------------------------------------------------------------------------------------------------------
	IF  LEN(@TECNICO)>0 begin SELECT @sTec='AND ST.ID_TECNICO='''+@TECNICO+'''' END
	ELSE BEGIN SELECT @sTec='' END
------------------------------------------------------------------------------------------------------------------
	IF  LEN(@TIPO)>0 begin SELECT @sTipo='AND AT.FLAG_CON_CONTRATO='''+@TIPO+'''' END
	ELSE BEGIN SELECT @sTipo='' END
------------------------------------------------------------------------------------------------------------------
	IF  LEN(@ESTACION)>0 begin SELECT @sEtacion='AND A.ID_ANALITICA='''+@ESTACION+'''' END
	ELSE BEGIN SELECT @sEtacion='' END
	
------------------------------------------------------------------------------------------------------------------
SELECT @sSelect=
'con.descripcion ''cia'',se.descripcion ''sede'',a.descripcion ''cliente'',
case at.flag_con_contrato	when ''0'' then ''no contratado'' else ''contratado'' end as	''tipo_cliente'',st.serie_doc+''-''+st.nro_doc ''documento'',
convert(varchar(max),ms.descripcion)	''motivo'',convert(varchar(max),st.informacion_tecnica) ''solucion'',
		a2.descripcion ''tecnico'',st.inicio_servicio,st.fin_servicio,e.descripcion ''estado'',
		std.item,ar.descripcion,std.cantidad
FROM SERVICIO_TECNICO ST
INNER JOIN COMPANIA CON ON CON.CIA=ST.CIA
INNER JOIN SEDE SE ON SE.CIA=ST.CIA AND SE.SEDE=ST.SEDE
INNER JOIN MOTIVO_SERVICIO MS ON MS.CIA=ST.CIA AND MS.ID_MOTIVO_SERVICIO=ST.ID_MOTIVO_SERVICIO
INNER JOIN ANALITICA A ON A.CIA=ST.CIA AND A.ID_ANALITICA=ST.ID_CLIENTE
INNER JOIN ANALITICA A2 ON A2.CIA=ST.CIA AND A2.ID_ANALITICA=ST.ID_TECNICO
INNER JOIN SERVICIO_TECNICO_DETALLE STD ON STD.CIA=ST.CIA AND STD.SEDE=ST.SEDE AND STD.ID_TIPO_DOC=ST.ID_TIPO_DOC 
												AND STD.SERIE_DOC=ST.SERIE_DOC AND STD.NRO_DOC=ST.NRO_DOC
INNER JOIN ARTICULO AR ON AR.CIA=STD.CIA AND AR.ID_ARTICULO=STD.ID_ARTICULO
INNER JOIN ESTADO E ON E.CIA=ST.CIA AND E.ID_ESTADO=ST.ID_ESTADO
INNER JOIN ANALITICA_TIPO AT ON at.cia=a.cia AND at.id_analitica=a.id_analitica 
INNER JOIN TIPO_ANALITICA TA ON ta.cia=at.cia AND ta.id_tipo_analitica=at.id_tipo_analitica
WHERE ST.CIA='''+@CIA+''' AND ST.SEDE='''+@SEDE+'''  AND ST.ID_MOTIVO_SERVICIO=''38'' AND
CONVERT(VARCHAR(8),ST.FIN_SERVICIO,112) BETWEEN '''+@FEC1+''' AND '''+@FEC2+''' '
-----------------------------------------------------------------------------------------------------------------
SELECT @sGroup='
GROUP BY CON.DESCRIPCION,SE.DESCRIPCION,A.DESCRIPCION,AT.FLAG_CON_CONTRATO,ST.SERIE_DOC,ST.NRO_DOC ,
A2.DESCRIPCION,ST.INICIO_SERVICIO,ST.FIN_SERVICIO,E.DESCRIPCION,STD.ITEM,AR.DESCRIPCION,STD.CANTIDAD,
MS.DESCRIPCION,CONVERT(VARCHAR(max),ST.INFORMACION_TECNICA)'
------------------------------------------------------------------------------------------------------------------
SELECT @sExecute = @sSelect +' '+ @sTec+' '+@sTipo+' '+@sEtacion+' '+@sGroup
-------------------------------------------------------------------------------
--PRINT @sExecute
EXEC ('SELECT '+ @sExecute )
GO
/****** Object:  StoredProcedure [dbo].[SP_SEDE_ACTUALIZAR]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
SELECT * FROM E_ISLA
[SP_E_ISLA_ACTUALIZAR] '01', '01', 'ISLA 0111', '01','01/07/2010 12:00:00 a.m.', '01/08/2010 12:00:00 a.m.','ADMIN'
 

 DELETE E_ISLA WHERE ID_ISLA IN('4')
*/
-----------------------------------------------
-----------------------------------------------
create	PROC	[dbo].[SP_SEDE_ACTUALIZAR]
@CIA						CHAR(2), 
@SEDE						CHAR(2),  
@DESCRIPCION				VARCHAR(100), 
@ID_ESTADO					CHAR(2), 
@SE							CHAR(2), 
@UM						    VARCHAR(25),
@CORRELATIVO_SCTR_PDT		VARCHAR(6),	
@RUTA_PUBLICO				VARCHAR(100),
@RUTA_ARCHIVO_RRHH			VARCHAR(100),
@DIRECCION					VARCHAR(100),
@CODIGO_SUNAT				VARCHAR(4),
@CX_ID_TIPO_ESTABLECIMIENTO	VARCHAR(6),
@TASA_CENTRO_RIESGO			DECIMAL(13, 2),
@FLAG_EMPRESA_DESTACO		CHAR(1),
@HORA_CORTE_EESS			INT,
@INTERFAZ_IP				VARCHAR(20),
@INTERFAZ_PORT				INT,
@INTERFAZ_AUTO				CHAR(1),
@MONTO_MAXIMO_VTA_POS		FLOAT

AS
-----------------------------------------------
DECLARE @VARMSG			VARCHAR(MAX)
DECLARE	@COUNT			INT
--------------------------------------------------
/*		INSERTAMOS LOS DATOS EN LA TABLA	*/
BEGIN TRANSACTION
	-------------------------------------------
	UPDATE	SEDE
	SET		DESCRIPCION			= @DESCRIPCION, 
			ID_ESTADO			= @ID_ESTADO, 						
			FM					= GETDATE(), 
			UM					= @UM
	WHERE	CIA					= @CIA 
	AND		SEDE				= @SEDE 
	-------------------------------------------
	IF @@ERROR <> 0 OR @@ROWCOUNT <> 1
	BEGIN
		---------------------------------------
		SET		@VARMSG	= 'SE PRODUJO UN ERROR DURANTE EL PROCESO DE ACTUALIZAR LA SEDE. NO SE ACTUALIZARON LOS DATOS.'
		GOTO	MSGERROR
		----------------------------------------
	END 
	ELSE
	BEGIN
		----------------------------------------
		SET	@VARMSG				= 'DATOS ACTUALIZADOS.'
		
		----------------------------------------
	END
	--------------------------------------------
	
COMMIT TRANSACTION
------------------------------------------------
RETURN
MSGERROR:
		ROLLBACK TRANSACTION
		----------------------------------------
		RAISERROR	(@VARMSG, 15, 1)		
		RETURN
GO
/****** Object:  StoredProcedure [dbo].[SP_SEDE_ELIMINAR]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*

delete from e_isla where id_isla='a'
sp_help sede
select * from SEDE
*/
-----------------------------------------------
-----------------------------------------------
create	PROC	[dbo].[SP_SEDE_ELIMINAR]
@CIA			CHAR(2), 
@SEDE			CHAR(2),
@UA				VARCHAR(10)--,
--@AA				VARCHAR(60)
AS
-----------------------------------------------
DECLARE @VARMSG			VARCHAR(MAX)
-----------------------------------------------
/*		INSERTAMOS LOS DATOS EN LA TABLA	*/
BEGIN TRANSACTION
	-------------------------------------------
	UPDATE	SEDE
	SET		ID_ESTADO	= '02'	,
			FA			= GETDATE(), 
			UA			= @UA--,
		--	AA			= @AA
	WHERE	CIA			= @CIA 
	AND		SEDE		= @SEDE 
	-------------------------------------------
	IF @@ERROR <> 0 OR @@ROWCOUNT <> 1
	BEGIN
		---------------------------------------
		SET		@VARMSG	= 'SE PRODUJO UN ERROR DURANTE EL PROCESO DE ELIMINACION DE LA SEDE. NO SE ELIMINO EL REGISTRO.'
		GOTO	MSGERROR
		----------------------------------------
	END 
	ELSE
	BEGIN
		----------------------------------------
		SET	@VARMSG	= 'REGISTRO ELIMINADO.'
		----------------------------------------
	END	
COMMIT TRANSACTION
------------------------------------------------
RETURN
MSGERROR:
		ROLLBACK TRANSACTION
		----------------------------------------
		RAISERROR	(@VARMSG, 15, 1)
		RETURN
GO
/****** Object:  StoredProcedure [dbo].[SP_SEDE_INSERTAR]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*		

select * from SEDE WHERE	CIA			= '01' 	AND		SEDE		= '03' 
sp_help sede
select * from tipo_documento_correlativo
select * from empresa_destaco_personal
SP_SEDE_INSERTAR	'01','15','aaaa','01','04','admin','01','','','aaaaaaaaaaaa','0000','00',0,'','0','192.168.1.122',1024,'1',50000
DELETE FROM SEDE WHERE CIA='01' AND SEDE IN('15','56')
*/
       
-----------------------------------------------
create	PROC	[dbo].[SP_SEDE_INSERTAR]
@CIA						CHAR(2), 
@SEDE						CHAR(2),  
@DESCRIPCION				VARCHAR(100), 
@ID_ESTADO					CHAR(2), 
@SE							CHAR(2), 
@UC							VARCHAR(30),
@CORRELATIVO_SCTR_PDT		VARCHAR(6),	
@RUTA_PUBLICO				VARCHAR(100),
@RUTA_ARCHIVO_RRHH			VARCHAR(100),
@DIRECCION					VARCHAR(100),
@CODIGO_SUNAT				VARCHAR(4),
@CX_ID_TIPO_ESTABLECIMIENTO	VARCHAR(6),
@TASA_CENTRO_RIESGO			DECIMAL(13, 2),
@FLAG_EMPRESA_DESTACO		CHAR(1),
@HORA_CORTE_EESS			INT,
@INTERFAZ_IP				VARCHAR(20),
@INTERFAZ_PORT				INT,
@INTERFAZ_AUTO				CHAR(1),
@MONTO_MAXIMO_VTA_POS		FLOAT
AS
-----------------------------------------------
DECLARE @VARMSG			VARCHAR(MAX)		
DECLARE	@COUNT			INT
-----------------------------------------------
BEGIN TRANSACTION
	-------------------------------------------
	INSERT	INTO SEDE
	(
	   CIA, SEDE, DESCRIPCION,   ID_ESTADO, FLAG_ENVIO,  SE,  FC, UC, 
	   CORRELATIVO_SCTR_PDT, RUTA_PUBLICO, RUTA_ARCHIVO_RRHH, DIRECCION,  CODIGO_SUNAT, CX_ID_TIPO_ESTABLECIMIENTO,  TASA_CENTRO_RIESGO,  
       FLAG_EMPRESA_DESTACO, HORA_CORTE_EESS, INTERFAZ_IP, INTERFAZ_PORT, INTERFAZ_AUTO, MONTO_MAXIMO_VTA_POS
	)
	VALUES		(
		
	   @CIA, @SEDE, @DESCRIPCION,   @ID_ESTADO, '1',  @SE,  GETDATE(), @UC, 
	   @CORRELATIVO_SCTR_PDT, @RUTA_PUBLICO, @RUTA_ARCHIVO_RRHH, @DIRECCION,  @CODIGO_SUNAT, @CX_ID_TIPO_ESTABLECIMIENTO,  @TASA_CENTRO_RIESGO,  
       @FLAG_EMPRESA_DESTACO, @HORA_CORTE_EESS, @INTERFAZ_IP, @INTERFAZ_PORT, @INTERFAZ_AUTO, @MONTO_MAXIMO_VTA_POS
	)
	-------------------------------------------
	IF @@ERROR <> 0 OR @@ROWCOUNT <> 1
	BEGIN
		---------------------------------------
		SET		@VARMSG	= 'SE PRODUJO UN ERROR DURANTE EL PROCESO DE GRABACION DE LA SEDE. NO SE GRABARON LOS DATOS.'
		GOTO	MSGERROR
		----------------------------------------
	END 
	ELSE
	BEGIN
		----------------------------------------
		SET	@VARMSG				= 'DATOS GRABADOS.'
		----------------------------------------
	END
	--------------------------------------------
COMMIT TRANSACTION
------------------------------------------------
RETURN
MSGERROR:
		ROLLBACK TRANSACTION
		----------------------------------------
		RAISERROR	(@VARMSG, 15, 1)	
		RETURN
GO
/****** Object:  StoredProcedure [dbo].[SP_SEDE_LISTAR]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
[SP_SEDE_LISTAR] '01','','',''
SELECT * FROM SEDE
sp_help estado

*/
create PROCEDURE [dbo].[SP_SEDE_LISTAR]
@cia CHAR(2),
@CODIGO		VARCHAR(100),
@nombre		VARCHAR(100),
@estado		varchar(100)
AS
SELECT S.sede, UPPER(S.descripcion)as 'descripcion',  
	e.abreviatura	as 'estado'
FROM SEDE	AS S
LEFT JOIN estado e ON e.cia=S.cia and e.id_estado=S.id_estado 
WHERE  S.cia=@cia     
AND		 S.sede			LIKE '%'+  @CODIGO +'%'
AND		S.descripcion	LIKE '%'+  @nombre +'%'
AND		e.id_estado LIKE '%' + @estado + '%'
 ORDER BY S.SEDE
GO
/****** Object:  StoredProcedure [dbo].[SP_SEDE_TRAER]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
SELECT * FROM sede
sp_help sede
[SP_SEDE_TRAER] '01','02'
*/
--------------------------------------------
create PROC [dbo].[SP_SEDE_TRAER]
@cia CHAR(2),@sede char(2)	
AS
-------------------------------------------
SELECT S.sede, UPPER(S.descripcion) as 'descripcion',
  UPPER(S.id_estado) as 'estado', UPPER(S.DIRECCION) as 'direecion',
  correlativo_sctr_pdt,cx_id_tipo_establecimiento, tasa_centro_riesgo
FROM SEDE	as S 
LEFT JOIN estado e      ON e.cia=S.cia and e.id_estado=S.id_estado 
WHERE  S.cia=@cia     --em.sede=@sede 
and S.sede=@sede
GO
/****** Object:  StoredProcedure [dbo].[sp_tanqueos]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*---------------Numero de Tanqueos------------------------*/

--sp_tanqueos 0,'01','02','10/08/2010','13/08/2010'

CREATE PROCEDURE [dbo].[sp_tanqueos]
@tipo int,@cia char(2),@sede char(2),@fec1 datetime,@fec2 datetime
AS
-------------------------------------------------------------------------------
DECLARE @sExecute varchar(max),@sSelect varchar(max),@sCondicion varchar(max),@sGroupby varchar(max),@sOrderby varchar(max)
-------------------------------------------------------------------------------
DECLARE @FECHA1 VARCHAR(8),@FECHA2 VARCHAR(8)
-------------------------------------------------------------------------------
SET @FECHA1 = CONVERT(VARCHAR(8),@fec1,112)
SET @FECHA2 = CONVERT(VARCHAR(8),@fec2,112)
-------------------------------------------------------------------------------
SELECT @sExecute='',@sSelect='',@sCondicion='',@sGroupby='',@sOrderby=''
-------------------------------------------------------------------------------

SELECT @sSelect='c.descripcion ''Cia'',s.descripcion ''Sede'',year(convert(varchar(10),ev.fecha,103)) ''Ano'',datename(m,ev.fecha) ''Mes'',
datename(dw,ev.fecha)+'' ''+convert(varchar(8),day(ev.fecha)) ''Dia'',count(ev.id_articulo) ''Tanqueos'' 
FROM e_venta ev
INNER JOIN compania c ON c.cia=ev.cia
INNER JOIN sede s ON s.cia=ev.cia and s.sede=ev.sede'
-------------------------------------------------------------------------------
IF @tipo=0 
BEGIN
SELECT @sCondicion='WHERE ev.cia='''+@cia+'''  and ev.sede='''+@sede+''' and (convert(varchar(8),ev.fecha,112) between  '''+@FECHA1+''' and  '''+@FECHA2+''')'
END
ELSE IF @tipo=1 
BEGIN
SELECT @sCondicion='WHERE ev.cia='''+@cia+'''  and ev.sede='''+@sede+'''  and 
(convert(int,(DATEPART(hour, ev.fc)*60)+DATEPART(minute, ev.fc)) between  720 and 1440) 
and (convert(varchar(8),ev.fecha,112) between  '''+@FECHA1+''' and  '''+@FECHA2+''')'
END
-------------------------------------------------------------------------------
SELECT @sGroupby='GROUP BY c.descripcion,s.descripcion,convert(varchar(10),ev.fecha,103),datename(m,ev.fecha),datename(dw,ev.fecha)+'' ''+convert(varchar(8),day(ev.fecha))'
-------------------------------------------------------------------------------
SELECT @sOrderby=''
------------------------------------------------------------------------------------------------------------------
SELECT @sExecute = @sSelect +' '+ @sCondicion +' '+ @sGroupby+' '+@sOrderby
-------------------------------------------------------------------------------
--PRINT @sExecute
EXEC ('SELECT '+ @sExecute )
GO
/****** Object:  StoredProcedure [dbo].[SP_TIPOCAMBIO_INSERTAR]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*

[SP_TIPOCAMBIO_LISTAR] '01','','2010',''
select *from tipo_cambio where cia='01' and anio='2010' and mes='09'
select *from MONEDA
--		BOV01	SOLES
--		BOV02	DOLAR
SP_HELP tipo_cambio
SP_TIPOCAMBIO_INSERTAR '01','03/09/2010','02:50:00','02',7.77,5.65,'02','ADMIN'
SP_TIPOCAMBIO_INSERTAR '01','03/09/2010','05:10:18','02',5.65,5.65,'02','admin'

*/
-----------------------------------------------
-----------------------------------------------
create	PROCEDURE	[dbo].[SP_TIPOCAMBIO_INSERTAR]
@CIA					CHAR(2), 
@FECHA					VARCHAR(10),
@HORA					VARCHAR(10),
@ID_MONEDA				CHAR(2), 
@VENTA					FLOAT, 
@COMPRA					FLOAT, 
@SE						CHAR(2),
@UC						VARCHAR(25)
AS
-----------------------------------------------
DECLARE @VARMSG			VARCHAR(MAX)
DECLARE	@COUNT			INT
DECLARE	@ANIO			CHAR(4) 
DECLARE	@MES			CHAR(2) 
DECLARE @FEC			VARCHAR(25)
DECLARE @FECH			DATETIME
--------------------------------------------------
set @ANIO=(year(convert(varchar(10),@FECHA,103)))
set @MES =(SELECT SUBSTRING(CONVERT(VARCHAR(10),@FECHA,103),4,2))
SET @FEC=(@FECHA+' '+@HORA)

--print @MES
-------------------------------------------------------
BEGIN TRANSACTION
	-------------------------------------------
	INSERT	INTO TIPO_CAMBIO
	(
		CIA,FECHA,ID_MONEDA,VENTA,COMPRA,ANIO,MES,FLAG_ENVIO,SE,FC,UC
	)
	VALUES		/*		SELECT * FROM TIPO_CAMBIO		*/
	(
		@CIA,@FEC,@ID_MONEDA,@VENTA,@COMPRA,@ANIO,@MES,'1',@SE,GETDATE(),@UC
	)
	-------------------------------------------
	IF @@ERROR <> 0 OR @@ROWCOUNT <> 1
	BEGIN
		---------------------------------------
		SET		@VARMSG	= 'SE PRODUJO UN ERROR DURANTE EL PROCESO DE GRABACION DEL TIPO_CAMBIO. NO SE GRABARON LOS DATOS.'
		GOTO	MSGERROR
		----------------------------------------
	END 
	ELSE
	BEGIN
		----------------------------------------
		SET	@VARMSG					= 'DATOS GRABADOS.'	
		----------------------------------------
	END
	--print @CIA+' -- '+@FEC+' -- '+@ID_MONEDA+' -- '+@VENTA+' -- '+@COMPRA+' -- '+@ANIO+' -- '+
	--		@MES+' -- '+@SE+' -- '+@UC
	--------------------------------------------
COMMIT TRANSACTION
------------------------------------------------
RETURN
MSGERROR:
		ROLLBACK TRANSACTION
		----------------------------------------
		RAISERROR	(@VARMSG, 15, 1)
		RETURN
GO
/****** Object:  StoredProcedure [dbo].[SP_TIPOCAMBIO_LISTAR]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*

[SP_TIPOCAMBIO_LISTAR] '01','','2010','09'
select *from tipo_cambio where fecha between '01/09/2010' and '03/09/2010'
select *from MONEDA
--		BOV01	SOLES
--		BOV02	DOLAR
select * from caja_banco WHERE CIA='01' AND ID_CAJA_BANCO IN('BOV01','BOV02')
select * from caja_banco WHERE CIA='01' AND id_moneda='02' and id_caja_banco  like 'Bov' + '%'
select * from tipo_cta_bco
select * from banco

*/
---------------------------------------------------
create	PROC	[dbo].[SP_TIPOCAMBIO_LISTAR]
@CIA			CHAR(2),
@ID_MONEDA		varchar(100),
@ANIO		varchar(100),
@MES		varchar(100)
AS
---------------------------------------------------
SELECT  FECHA_HORA=FECHA, FECHA=CONVERT(VARCHAR(10), FECHA,103), M.ABREVIATURA,VENTA,COMPRA,ANIO,MES
from	tipo_cambio TC
INNER JOIN MONEDA M ON M.CIA=TC.CIA and m.id_moneda=tc.id_moneda
WHERE	TC.CIA=@CIA 
AND		TC.ID_MONEDA LIKE '%' + @ID_MONEDA + '%'
AND		ANIO		LIKE '%' + @ANIO + '%'
AND		MES			LIKE '%' + @MES + '%'
ORDER BY FECHA
GO
/****** Object:  StoredProcedure [dbo].[SP_TIPOCAMBIO_VALIDAR]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
sp_help moneda
select * from moneda
SELECT * FROM TIPO_CAMBIO  WHERE     (ANIO = '2010') AND (MES = '09')
select * from TIPO_CAMBIO where fecha=(select CONVERT(VARCHAR(10),max(fecha),103) from TIPO_CAMBIO )

 SELECT TOP 1 *  FROM TIPO_CAMBIO ORDER BY FECHA DESC
SP_TIPOCAMBIO_VALIDAR '01','02'
*/
create PROC [dbo].[SP_TIPOCAMBIO_VALIDAR]
@CIA CHAR(2),
@ID_MONEDA CHAR(2)
AS
-------------------------------------------------------------
--DECLARE @FECHA VARCHAR(30)
--SET @FECHA=(SELECT CONVERT(VARCHAR(10),fecha,103) FROM TIPO_CAMBIO)
-------------------------------------------------------------
SELECT m.ID_MONEDA,DESCRIPCION=UPPER(m.DESCRIPCION),
TC.VENTA,FECHA=CONVERT(VARCHAR(10),max(fecha),103)
from moneda m
left join estado e on e.cia=m.cia and E.id_estado=m.id_estado
left join TIPO_CAMBIO tc on tc.cia=m.cia and tc.ID_MONEDA =m.ID_MONEDA
where m.cia=@CIA
AND M.ID_MONEDA = @ID_MONEDA
--AND fecha=(select CONVERT(VARCHAR(10),max(fecha),103) from TIPO_CAMBIO )
AND FECHA=( select TOP 1 FECHA FROM TIPO_CAMBIO ORDER BY FECHA DESC )
--AND m.id_estado='01'
GROUP BY m.ID_MONEDA,m.DESCRIPCION,TC.VENTA,fecha
order by fecha desc

--select convert(varchar(10),getdate(),103)
GO
/****** Object:  StoredProcedure [dbo].[SP_TRAER_DATOS_DEL_USUARIO]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*

EXEC SP_TRAER_DATOS_DEL_USUARIO '01', 'ADMIN'

*/
-----------------------------------------------
-----------------------------------------------
create	PROCEDURE	[dbo].[SP_TRAER_DATOS_DEL_USUARIO]
@CIA		CHAR(2),
@ID_USUARIO	VARCHAR(10)
AS
-----------------------------------------------
-----------------------------------------------
SELECT	ANALITICA.DESCRIPCION
FROM	USUARIO_ANALITICA INNER JOIN
		ANALITICA ON USUARIO_ANALITICA.CIA = ANALITICA.CIA AND USUARIO_ANALITICA.ID_ANALITICA = ANALITICA.ID_ANALITICA
WHERE	USUARIO_ANALITICA.CIA			= @CIA 
AND		USUARIO_ANALITICA.ID_USUARIO	= @ID_USUARIO
GO
/****** Object:  StoredProcedure [dbo].[SP_TRAER_SERIE_DOCUMENTO]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*

select * from TIPO_DOCUMENTO_SERIE where id_tipo_doc='26'
select * from TIPO_DOCUMENTO where descripcion like 'o%'order by descripcion
[SP_TRAER_SERIE_DOCUMENTO] '01','21'
*/
--------------------------------------------------
--------------------------------------------------
CREATE	PROCEDURE	[dbo].[SP_TRAER_SERIE_DOCUMENTO]
@CIA			CHAR(2),
@ID_TIPO_DOC	CHAR(2)
AS
--------------------------------------------------
--------------------------------------------------
SELECT	SERIE
FROM	TIPO_DOCUMENTO_SERIE
WHERE	CIA			= @CIA
AND		ID_TIPO_DOC	= @ID_TIPO_DOC
AND		ID_ESTADO	= '01'
AND FECHA_VENCE=(SELECT MAX(FECHA_VENCE)
FROM TIPO_DOCUMENTO_SERIE WHERE CIA=@CIA AND ID_TIPO_DOC=@ID_TIPO_DOC )
GO
/****** Object:  StoredProcedure [dbo].[SP_TRAER_SERIE_NRO_DOC]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*

EXEC [SP_TRAER_SERIE_NRO_DOC] '01','86','0000'

*/
----------------------------------------------
----------------------------------------------
CREATE	PROCEDURE	[dbo].[SP_TRAER_SERIE_NRO_DOC]
@CIA			CHAR(2),
@ID_TIPO_DOC	CHAR(2),
@SERIE_DOC		CHAR(4)	
AS
--------------------------------------------------

SELECT ISNULL((SELECT RIGHT('0000000'+CAST(RIGHT(MAX(CORRELATIVO),8)+1 AS VARCHAR),8) 
				FROM TIPO_DOCUMENTO_SERIE WHERE CIA=@CIA AND ID_TIPO_DOC=@ID_TIPO_DOC AND SERIE=@SERIE_DOC AND ID_ESTADO='01'),'00000001')
/*				
--------------------------------------------------
SELECT	(REPLICATE('0',(8 - LEN(CORRELATIVO))) + CONVERT(VARCHAR(8),(CORRELATIVO + 1))) AS 'CORRELATIVO'
FROM	TIPO_DOCUMENTO_SERIE
WHERE	CIA			= @CIA
AND		ID_TIPO_DOC	= @ID_TIPO_DOC
AND		SERIE		= @SERIE_DOC
AND		ID_ESTADO	= '01'
*/
GO
/****** Object:  StoredProcedure [dbo].[SP_TRAER_TIPO_CAMPANIA]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*

DECLARE @MENSAJE		CHAR(1)
EXEC	SP_TRAER_TIPO_CAMPANIA '01', 1, @MENSAJE OUTPUT
PRINT @MENSAJE

*/
--------------------------------------------------
--------------------------------------------------
create	PROCEDURE	[dbo].[SP_TRAER_TIPO_CAMPANIA]
@CIA			char(2),
@ID_CAMPANIA	INT,
@MENSAJE		CHAR(1)OUTPUT
AS
--------------------------------------------------
--------------------------------------------------
SET @MENSAJE = (SELECT Flag_Frase_Ganadora FROM F_CAMPANIA WHERE cia = @CIA AND Id_Campania = @ID_CAMPANIA)
GO
/****** Object:  StoredProcedure [dbo].[SP_TRAER_TIPO_DE_CAMBIO]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
SELECT * FROM MONEDA
SELECT * FROM TIPO_CAMBIO

DECLARE @VALOR VARCHAR(30)
EXEC SP_TRAER_TIPO_DE_CAMBIO '01', '02', @VALOR OUTPUT
PRINT @VALOR

*/
---------------------------------------------
---------------------------------------------
CREATE	PROCEDURE	[dbo].[SP_TRAER_TIPO_DE_CAMBIO]
@CIA		CHAR(2),
@ID_MONEDA	CHAR(2),
@VALOR		VARCHAR(30) OUTPUT
AS
---------------------------------------------
DECLARE @ABR	VARCHAR(5)
---------------------------------------------
SET	@VALOR	=	(	SELECT ISNULL((SELECT	TOP 1 CONVERT(VARCHAR(30),CONVERT(DECIMAL(18,3),VENTA))
					FROM	TIPO_CAMBIO
					WHERE	CIA			= @CIA
					AND		ID_MONEDA	= @ID_MONEDA
					AND		CONVERT(VARCHAR(8),FECHA,112) = CONVERT(VARCHAR(8),GETDATE(),112)
					ORDER	BY FECHA DESC
					),'No hay Tipo de Cambio')
				)
SET @ABR	=	(	SELECT ISNULL ((SELECT	ABREVIATURA
					FROM	MONEDA
					WHERE	CIA			= @CIA
					AND		ID_MONEDA	= @ID_MONEDA
					AND		ID_ESTADO	= '01'),' ')
				)
SET @VALOR	=	@VALOR + ',' + @ABR
GO
/****** Object:  StoredProcedure [dbo].[SP_TRAER_TODOS_INVENTARIO_DET_TEMP]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*



*/
--------------------------------------------
--------------------------------------------
create	PROCEDURE	[dbo].[SP_TRAER_TODOS_INVENTARIO_DET_TEMP]
@SESION		VARCHAR(100),
@CIA		CHAR(2),
@SEDE		CHAR(2)
AS
--------------------------------------------
--------------------------------------------
SELECT	IDT.ITEM, ART.ID_ARTICULO, ART.NRO_PARTE, ART.DESCRIPCION, IDT.CANTIDAD, IDT.P_USADO, IDT.ID_CAMPANIA
FROM	INVENTARIO_DET_TEMP IDT
INNER JOIN ARTICULO ART ON IDT.CIA = ART.CIA AND IDT.ID_ARTICULO = ART.ID_ARTICULO
WHERE	IDT.SESION	= @SESION 
AND		IDT.CIA		= @CIA 
AND		IDT.SEDE	= @SEDE
GO
/****** Object:  StoredProcedure [dbo].[sp_V_AbonoxV]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*----------------Abonos por Vehiculo----------------------*/

--sp_V_AbonoxV 0,'01','02','10/08/2008','13/08/2010','JKL-577'

CREATE PROCEDURE [dbo].[sp_V_AbonoxV]
@tipo int,@cia char(2),@sede char(2),@fec1 datetime,@fec2 datetime,@placa varchar(10)
AS
-------------------------------------------------------------------------------
DECLARE @sExecute varchar(max),@sSelect varchar(max),@sCondicion varchar(max),@sGroupby varchar(max),@sOrderby varchar(max)
-------------------------------------------------------------------------------
DECLARE @FECHA1 VARCHAR(8),@FECHA2 VARCHAR(8)
-------------------------------------------------------------------------------
SET @FECHA1 = CONVERT(VARCHAR(8),@fec1,112)
SET @FECHA2 = CONVERT(VARCHAR(8),@fec2,112)
-------------------------------------------------------------------------------
SELECT @sExecute='',@sSelect='',@sCondicion='',@sGroupby='',@sOrderby=''
-------------------------------------------------------------------------------

SELECT @sSelect='c.descripcion ''Cia'',s.descripcion ''Sede'',convert(varchar(8),v.fecha,103) ''Fecha'',vd.serie_doc+'' ''+vd.nro_doc ''N° Docuemento'', 
vd.id_venta ''N° Recibo'',v.subtotal''Valor Abono'' 
FROM e_venta v
inner join e_venta_documento vd on vd.id_venta=v.id_venta and vd.cia=v.cia and vd.sede=v.sede
inner join compania c on c.cia=v.cia
inner join sede s on s.cia=v.cia and s.sede=v.sede'
-------------------------------------------------------------------------------
IF @tipo=0 
BEGIN
SELECT @sCondicion='WHERE v.cia='''+@cia+''' and v.sede='''+@sede+''' and convert(varchar(8),v.fecha,112) between '''+@FECHA1+''' and '''+@FECHA2+''' and 
v.placa='''+@placa+''''
END
ELSE IF @tipo=1 
BEGIN
SELECT @sCondicion='WHERE v.cia='''+@cia+''' and v.sede='''+@sede+''' and 
(convert(int,(DATEPART(hour, v.fc)*60)+DATEPART(minute, v.fc)) between  720 and 1440)
 and convert(varchar(8),v.fecha,112) between '''+@FECHA1+''' and '''+@FECHA2+''' and 
v.placa='''+@placa+''''
END
-------------------------------------------------------------------------------
SELECT @sGroupby=''
-------------------------------------------------------------------------------
SELECT @sOrderby=''
------------------------------------------------------------------------------------------------------------------
SELECT @sExecute = @sSelect +' '+ @sCondicion +' '+ @sGroupby+' '+@sOrderby
-------------------------------------------------------------------------------
--PRINT @sExecute
EXEC ('SELECT '+ @sExecute )
GO
/****** Object:  StoredProcedure [dbo].[sp_V_pmv]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*---------------Promedio de Ventas--------------------------*/

--sp_V_pmv 0,'01','02','10/08/2010','13/08/2010',''

CREATE PROCEDURE [dbo].[sp_V_pmv]
@tipo int,@cia char(2),@sede char(2),@fec1 datetime,@fec2 datetime,@filtro varchar(500)
AS
-------------------------------------------------------------------------------
DECLARE @sExecute varchar(max),@sSelect varchar(max),@sCondicion varchar(max),@sGroupby varchar(max),@sOrderby varchar(max)
-------------------------------------------------------------------------------
DECLARE @FECHA1 VARCHAR(8),@FECHA2 VARCHAR(8)
-------------------------------------------------------------------------------
SET @FECHA1 = CONVERT(VARCHAR(8),@fec1,112)
SET @FECHA2 = CONVERT(VARCHAR(8),@fec2,112)
-------------------------------------------------------------------------------
SELECT @sExecute='',@sSelect='',@sCondicion='',@sGroupby='',@sOrderby=''
-------------------------------------------------------------------------------

SELECT @sSelect='c.descripcion ''Cia'',s.descripcion ''Sede'',datename(dw,v.fecha) ''Dia'',count(v.id_venta) ''Numero de Vehiculos'',
sum(v.cantidad) ''Cantidad M3'',sum(v.subtotal) ''Valor'',
CASE datename(dw,v.fecha)
WHEN ''Lunes'' THEN ''1''
WHEN ''Martes'' THEN ''2''
WHEN ''Miércoles'' THEN ''3''
WHEN ''Miercoles'' THEN ''3''
WHEN ''Jueves'' THEN ''4''
WHEN ''Viernes'' THEN ''5''
WHEN ''Sabado'' THEN ''6''
WHEN ''Sábado'' THEN ''6''
WHEN ''Domingo'' THEN ''7''
END  
as ''Numero''
FROM e_venta v
inner join compania c on c.cia=v.cia
inner join sede s on s.cia=v.cia and s.sede=v.sede'
-------------------------------------------------------------------------------
IF @tipo=0 
BEGIN
SELECT @sCondicion='WHERE v.cia=''' + @cia + '''  and v.sede='''+@sede+''' and (convert(varchar(8),v.fecha,112) between ''' + @FECHA1 + '''
 and ''' + @FECHA2 + ''') '+@filtro+''
END
ELSE IF @tipo=1 
BEGIN
SELECT @sCondicion='WHERE v.cia=''' + @cia + '''  and v.sede='''+@sede+''' and 
(convert(int,(DATEPART(hour, v.fc)*60)+DATEPART(minute, v.fc)) between  720 and 1440)
 and (convert(varchar(8),v.fecha,112) between ''' + @FECHA1 + '''
 and ''' + @FECHA2 + ''') '+@filtro+''
END
-------------------------------------------------------------------------------
SELECT @sGroupby='GROUP BY c.descripcion,s.descripcion,datename(dw,v.fecha)'
-------------------------------------------------------------------------------
SELECT @sOrderby=''
------------------------------------------------------------------------------------------------------------------
SELECT @sExecute = @sSelect +' '+ @sCondicion +' '+ @filtro+' '+ @sGroupby+' '+@sOrderby
-------------------------------------------------------------------------------
--PRINT @sExecute
EXEC ('SELECT '+ @sExecute )
GO
/****** Object:  StoredProcedure [dbo].[sp_V_recaudacion]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-----------------Recaudacion Diaria------------------------*/

--sp_V_recaudacion 1,'01','02','13/08/2010','18/08/2010',''

CREATE PROCEDURE [dbo].[sp_V_recaudacion]
@tipo int,@cia char(2),@sede char(2),@fec1 datetime,@fec2 datetime,@filtro varchar(500)
AS
-------------------------------------------------------------------------------
DECLARE @sExecute varchar(max),@sSelect varchar(max),@sCondicion varchar(max),@sGroupby varchar(max),@sOrderby varchar(max)
-------------------------------------------------------------------------------
DECLARE @FECHA1 VARCHAR(8),@FECHA2 VARCHAR(8)
-------------------------------------------------------------------------------
SET @FECHA1 = CONVERT(VARCHAR(8),@fec1,112)
SET @FECHA2 = CONVERT(VARCHAR(8),@fec2,112)
-------------------------------------------------------------------------------
SELECT @sExecute='',@sSelect='',@sCondicion='',@sGroupby='',@sOrderby=''
-------------------------------------------------------------------------------

SELECT @sSelect='c.descripcion ''Cia'',s.descripcion ''Sede'',convert(varchar(10),v.fecha,103) ''Fecha'',sum(v.cantidad) ''Cantidad M3'',convert(numeric(15,2),Sum(v.precio)) ''Valor'',
convert(numeric(15,2),Sum(v.subtotal)) ''Recaudo'' 
FROM e_venta v
inner join compania c on c.cia=v.cia
inner join sede s on s.cia=v.cia and s.sede=v.sede'
-------------------------------------------------------------------------------
IF @tipo=0 
BEGIN
SELECT @sCondicion='WHERE v.cia='''+@cia+'''  and v.sede='''+@sede+''' 
and (convert(varchar(8),v.fecha,112) between '''+@FECHA1+''' and '''+@FECHA2+''')  '+@filtro+''
END
ELSE IF @tipo=1 
BEGIN
SELECT @sCondicion='WHERE v.cia='''+@cia+'''  and v.sede='''+@sede+''' 
and ((DATEPART(hour, v.fc)*60)+(DATEPART(minute, v.fc)) between  720 and 1440)
and (convert(varchar(8),v.fecha,112) between '''+@FECHA1+''' and '''+@FECHA2+''')  '+@filtro+''
END
-------------------------------------------------------------------------------
SELECT @sGroupby='GROUP BY c.descripcion,s.descripcion,convert(varchar(10),v.fecha,103)'
-------------------------------------------------------------------------------
SELECT @sOrderby=''
------------------------------------------------------------------------------------------------------------------
SELECT @sExecute = @sSelect +' '+ @sCondicion +' '+ @filtro+' '+ @sGroupby+' '+@sOrderby
-------------------------------------------------------------------------------
--PRINT @sExecute
EXEC ('SELECT '+ @sExecute )
GO
/****** Object:  StoredProcedure [dbo].[sp_V_Sunat]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*------------Ventas sunat------------*/

--sp_V_Sunat 0,'01','02','10/08/2010','13/08/2010',''

CREATE PROCEDURE [dbo].[sp_V_Sunat]
@tipo int,@cia char(2),@sede char(2),@fec1 datetime,@fec2 datetime,@filtro varchar(500)
AS
-------------------------------------------------------------------------------
DECLARE @sExecute varchar(max),@sSelect varchar(max),@sCondicion varchar(max),@sGroupby varchar(max),@sOrderby varchar(max)
-------------------------------------------------------------------------------
DECLARE @FECHA1 VARCHAR(8),@FECHA2 VARCHAR(8)
-------------------------------------------------------------------------------
SET @FECHA1 = CONVERT(VARCHAR(8),@fec1,112)
SET @FECHA2 = CONVERT(VARCHAR(8),@fec2,112)
-------------------------------------------------------------------------------
SELECT @sExecute='',@sSelect='',@sCondicion='',@sGroupby='',@sOrderby=''
-------------------------------------------------------------------------------

SELECT @sSelect='co.descripcion ''Cia'',se.descripcion ''Sede'',convert(varchar(10),v.fecha,103) ''fecha de emision'',vd.id_tipo_doc ''tipo comprobante'',vd.serie_doc ''serie'',a.descripcion ''producto'',
vd.nro_doc ''comprobante inicial'',vd.nro_doc ''comprobante final'',v.ruc ''ruc'',
case when v.id_cliente is null then ''xxxxxx'' end ''razon social'',v.subtotal ''base imponible'',v.impuesto ''igv 19%'',v.total ''total venta''
FROM e_venta v
INNER JOIN e_venta_documento vd ON vd.id_venta=v.id_venta and vd.cia=v.cia and vd.sede=v.sede
INNER JOIN articulo a ON a.id_articulo=v.id_articulo and a.cia=v.cia
INNER JOIN compania co ON co.cia=v.cia
INNER JOIN sede se ON se.cia=v.cia and se.sede=v.sede'
-------------------------------------------------------------------------------
IF @tipo=0 
BEGIN
SELECT @sCondicion='WHERE v.cia=''' + @cia + '''  and v.sede='''+@sede+''' and (convert(varchar(8),v.fecha,112) between ''' + @FECHA1 + '''
 and ''' + @FECHA2 + ''') '+@filtro+''
END
ELSE IF @tipo=1 
BEGIN
SELECT @sCondicion='WHERE v.cia=''' + @cia + '''  and v.sede='''+@sede+''' and 
(convert(int,(DATEPART(hour, v.fc)*60)+DATEPART(minute, v.fc)) between  720 and 1440) 
 and (convert(varchar(8),v.fecha,112) between ''' + @FECHA1 + '''
 and ''' + @FECHA2 + ''') '+@filtro+''
END
-------------------------------------------------------------------------------
SELECT @sGroupby=''
-------------------------------------------------------------------------------
SELECT @sOrderby=''
------------------------------------------------------------------------------------------------------------------
SELECT @sExecute = @sSelect +' '+ @sCondicion+' '+ @filtro+' '+ @sGroupby+' '+@sOrderby
-------------------------------------------------------------------------------
--PRINT @sExecute
EXEC ('SELECT '+ @sExecute )
GO
/****** Object:  StoredProcedure [dbo].[SP_VALIDAR_CRONOGRAMA]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*

SELECT * FROM CRONOGRAMA_OPER WHERE ID_TECNICO='42476689'

SP_VALIDAR_CRONOGRAMA '01','01','42476689','19-11-2010 00:00:00','19-11-2010 01:00:00','0000','00000030'

*/

CREATE PROCEDURE [dbo].[SP_VALIDAR_CRONOGRAMA]
@CIA CHAR(2),@SEDE CHAR(2),@ID_TECNICO VARCHAR(8),@FECHA_INICIO DATETIME,@FECHA_FIN DATETIME,@SERIE_DOC CHAR(4),@NRO_DOC VARCHAR(20)
AS
-------------------------------------------------
DECLARE @fINICIO VARCHAR(8)
DECLARE @fFIN VARCHAR(8)
DECLARE @hINICIO VARCHAR(8)
DECLARE @hFIN VARCHAR(8)
-------------------------------------------------
SET @fINICIO=CONVERT(VARCHAR(8),@FECHA_INICIO,112)
SET @fFIN=CONVERT(VARCHAR(8),@FECHA_FIN,112)
SET @hINICIO=CONVERT(VARCHAR(8),@FECHA_INICIO,108)
SET @hFIN=CONVERT(VARCHAR(8),@FECHA_FIN,108)
-------------------------------------------------
SELECT * FROM dbo.CRONOGRAMA_OPER
WHERE CIA=@CIA AND SEDE=@SEDE AND (ID_TECNICO=@ID_TECNICO OR ID_TECNICO_2=@ID_TECNICO OR ID_TECNICO_3=@ID_TECNICO OR ID_TECNICO_4=@ID_TECNICO)
 AND ID_ESTADO !='12' AND
((@fINICIO BETWEEN CONVERT(VARCHAR(8),FECHA_INICIO,112) AND CONVERT(VARCHAR(8),FECHA_FIN,112)) OR 
(@fFIN BETWEEN CONVERT(VARCHAR(8),FECHA_INICIO,112) AND CONVERT(VARCHAR(8),FECHA_FIN,112)))
 AND 
((@hINICIO BETWEEN CONVERT(VARCHAR(8),FECHA_INICIO,108) AND CONVERT(VARCHAR(8),FECHA_FIN,108)) OR 
(@hFIN BETWEEN CONVERT(VARCHAR(8),FECHA_INICIO,108) AND CONVERT(VARCHAR(8),FECHA_FIN,108)))

AND SERIE_DOC=@SERIE_DOC AND NRO_DOC != @NRO_DOC
GO
/****** Object:  StoredProcedure [dbo].[SP_VALIDAR_SESSION]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
select * FROM SESION
DELETE	FROM SESION
SELECT * FROM USUARIO 

[SP_VALIDAR_SESSION] '1','81fd6a7d-91cf-47ff-ada2-330734990d48','ADMIN'		
[SP_VALIDAR_SESSION] '2','',''
[SP_VALIDAR_SESSION] '3','05c35669-6ed1-4e71-adc1-c4f3b3fbf2df','SISTEMAS'
[SP_VALIDAR_SESSION] '4','','ADMIN'
*/
-----------------------------------------------
-----------------------------------------------
CREATE	PROCEDURE	[dbo].[SP_VALIDAR_SESSION]
@INDICADOR	 CHAR(1),@SESION	  VARCHAR(MAX),@UC varchar(20)
AS
----------------------------------------------------------------------------------------------
DECLARE @VARMSG	VARCHAR(MAX),@COUNT	INT,@SESIONVAL VARCHAR(MAX)
----------------------------------------------------------------------------------------------
BEGIN TRANSACTION
----------------------------------------------------------------------------------------------
	IF  LEN(@SESION)>0 
			BEGIN 	SET  @SESIONVAL	=	(SELECT SESION FROM SESION WHERE SESION=@SESION)	 END
	ELSE	BEGIN   SET @SESIONVAL	=	NULL			END
	-----------------------------------------------------
		IF(@INDICADOR='1')	BEGIN		/*				INSERTAR			*/		
		----------------------------------------------			
			INSERT INTO SESION	(	SESION,FC,UC			)
			VALUES				(	@SESION,GETDATE(),@UC	)
		-------------------------------------------
		IF @@ERROR <> 0 OR @@ROWCOUNT <> 1	BEGIN		
			---------------------------------------
			SET		@VARMSG	= 'SE PRODUJO UN ERROR DURANTE EL PROCESO DE GRABACION DEL SESION. NO SE GRABARON LOS DATOS.'
			GOTO	MSGERROR
			----------------------------------------
		END 				
	END
	----------------------------------------------------------------------------------------------
	IF(@INDICADOR='2')	BEGIN	/*		ELIMINAR SESSION		*/
		 DELETE	FROM SESION	WHERE	SESION=@SESION AND UC=@UC
	END
	----------------------------------------------------------------------------------------------
	IF(@INDICADOR='3')BEGIN		/*		TRAER SESSION		*/
		IF  LEN(@SESIONVAL)>0 
				BEGIN SELECT ISNULL(@SESIONVAL,null) 'SESION' FROM SESION WHERE	SESION=@SESION AND UC=@UC	 END
		ELSE	BEGIN SELECT	NULL 'SESION' END 
	END		
		----------------------------------------------------------------------------------------------
	IF(@INDICADOR='4')BEGIN		/*		TRAER USUARIO		*/
		IF  LEN(@SESIONVAL)>0  AND  LEN(@UC)>0 
				BEGIN SELECT  ISNULL(@UC,null)	'UC' FROM SESION WHERE	UC=@UC	 END
		ELSE	BEGIN SELECT	NULL 'UC' END 
	END		
	----------------------------------------------------------------------------------------------	
COMMIT TRANSACTION
------------------------------------------------
RETURN
MSGERROR:
		ROLLBACK TRANSACTION
		----------------------------------------
		RAISERROR	(@VARMSG, 15, 1)
		RETURN
GO
/****** Object:  StoredProcedure [dbo].[sp_VxVehiculo]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*----------------------Ventas por Vehiculo---------------------*/

--sp_VxVehiculo 0,'01','02','10/08/2010','10/08/2010','JKL-577'

CREATE PROCEDURE [dbo].[sp_VxVehiculo]
@tipo int,@cia char(2),@sede char(2),@fec1 datetime,@fec2 datetime,@placa varchar(50)
AS
-------------------------------------------------------------------------------
DECLARE @sExecute varchar(max),@sSelect varchar(max),@sCondicion varchar(max),@sGroupby varchar(max),@sOrderby varchar(max)
-------------------------------------------------------------------------------
DECLARE @FECHA1 VARCHAR(8),@FECHA2 VARCHAR(8)
-------------------------------------------------------------------------------
SET @FECHA1 = CONVERT(VARCHAR(8),@fec1,112)
SET @FECHA2 = CONVERT(VARCHAR(8),@fec2,112)
-------------------------------------------------------------------------------
SELECT @sExecute='',@sSelect='',@sCondicion='',@sGroupby='',@sOrderby=''
-------------------------------------------------------------------------------

SELECT @sSelect='co.descripcion ''Cia'',se.descripcion ''Sede'',v.placa ''Placa'',CONVERT(VARCHAR(10),v.fecha,103) ''Fecha'',c.descripcion ''Cara'',
vd.nro_doc ''N° Documento'',v.id_venta ''N° Recibo interno'',v.cantidad ''Cantidad M3'',v.subtotal ''Valor''
FROM e_venta v
INNER JOIN e_cara c ON c.id_cara=v.id_cara AND c.cia=v.cia
INNER JOIN e_venta_documento vd ON vd.id_venta=v.id_venta AND vd.cia=v.cia AND vd.sede=v.sede
INNER JOIN compania co ON co.cia=v.cia
INNER JOIN sede se ON se.cia=v.cia and se.sede=v.sede'
-------------------------------------------------------------------------------
IF @tipo=0 
BEGIN
SELECT @sCondicion='WHERE (v.placa='''+@placa+''') AND v.cia='''+@cia+'''  AND v.sede='''+@sede+''' 
AND (CONVERT(VARCHAR(8),v.fecha,112) BETWEEN  '''+@FECHA1+'''  and  '''+@FECHA2+''')'
END
ELSE IF @tipo=1 
BEGIN
SELECT @sCondicion='WHERE (v.placa='''+@placa+''') AND v.cia='''+@cia+'''  AND v.sede='''+@sede+''' and 
(convert(int,(DATEPART(hour, v.fc)*60)+DATEPART(minute, v.fc)) between  720 and 1440)
 AND (CONVERT(VARCHAR(8),v.fecha,112) BETWEEN  '''+@FECHA1+'''  and  '''+@FECHA2+''')'
END
-------------------------------------------------------------------------------
SELECT @sGroupby=''
-------------------------------------------------------------------------------
SELECT @sOrderby=''
------------------------------------------------------------------------------------------------------------------
SELECT @sExecute = @sSelect +' '+ @sCondicion +' '+ @sGroupby+' '+@sOrderby
-------------------------------------------------------------------------------
--PRINT @sExecute
EXEC ('SELECT '+ @sExecute )
GO
/****** Object:  StoredProcedure [dbo].[usp_ActualizarDatos]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[usp_ActualizarDatos]
@ALU_COD CHAR(5),@ALU_DIR VARCHAR(100),@ALU_NOM VARCHAR(100),@ALU_EDAD INT,
@COD_PAIS INT, @COD_CIUDAD INT
AS 
UPDATE ALUMNOS_2 SET 
ALU_DIR=@ALU_DIR, ALU_NOM=@ALU_NOM, ALU_EDAD=@ALU_EDAD,COD_PAIS=@COD_PAIS,
COD_CIUDAD=@COD_CIUDAD
WHERE ALU_COD=@ALU_COD
GO
/****** Object:  StoredProcedure [dbo].[usp_Articulos]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE proc [dbo].[usp_Articulos]
As
Select * from Articulos

GO
/****** Object:  StoredProcedure [dbo].[Usp_BuscarDocente]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[Usp_BuscarDocente] 
@codigo char(6)
as
select * from docentes where codigo=@codigo
GO
/****** Object:  StoredProcedure [dbo].[usp_BusquedaArticulos]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE proc [dbo].[usp_BusquedaArticulos]
@articulo varchar(200)
As
 Select art_cod,art_nom,art_pre,art_stk from articulos 
         Where art_nom Like @articulo+'%'

GO
/****** Object:  StoredProcedure [dbo].[usp_CiudadesporPais]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
select * from ciudades
[usp_CiudadesporPais] '1'
Alumnos_2
*/
CREATE proc [dbo].[usp_CiudadesporPais] 
@cod_pais varchar(100)
as
select cod_ciudad,nom_ciudad from ciudades 
where cod_pais=@cod_pais
GO
/****** Object:  StoredProcedure [dbo].[Usp_CustomersBusqueda]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  PROC [dbo].[Usp_CustomersBusqueda]
@Customers VARCHAR(30)
as
SELECT c.CustomerID, c.companyName ,count(o.orderid)AS Nro_Ordenes,
[Tipo_Cliente]=(CASE WHEN count(o.orderid)>10 THEN 'Cliente_Vip'
 ELSE 'Normal' End) FROM Customers c ,Orders o
WHERE c.CustomerID=o.CustomerID AND 
c.CompanyName  LIKE @Customers+'%'  --'['+@Letras+']%' 
GROUP BY c.CustomerID,c.CompanyName 
GO
/****** Object:  StoredProcedure [dbo].[Usp_CustomersEncontrados]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[Usp_CustomersEncontrados]
@CustomerId VARCHAR(5)
AS
SELECT  o.OrderID,convert(VARCHAR(10),o.OrderDate,101),o.Freight 
FROM Orders o, [Order Details] od
WHERE o.OrderID=od.OrderID AND o.CustomerID=@CustomerId
GROUP BY o.OrderID,o.OrderDate,o.Freight 
GO
/****** Object:  StoredProcedure [dbo].[Usp_DetallePedido]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[Usp_DetallePedido]
@ProductID char(5)
as
select ProductName,od.Quantity,
total=sum(od.UnitPrice*Quantity)
from products p ,[order details] od,orders o
where o.orderId=od.orderId and od.ProductID=p.ProductID  
and p.ProductID =@ProductID
group by  p.ProductID,ProductName,od.Quantity
order by total
GO
/****** Object:  StoredProcedure [dbo].[USP_DetalleVenta]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[USP_DetalleVenta]
@Orderid int
as
select p.productid,p.productname,p.unitprice,od.Quantity,
total=p.unitprice*od.Quantity
from Products as p,[Order Details] as od 
where od.ProductID=p.ProductID and od.OrderID=@Orderid
GO
/****** Object:  StoredProcedure [dbo].[usp_EliDocente]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[usp_EliDocente] 
@codigo CHAR(6)
AS
delete FROM docentes WHERE codigo=@codigo
GO
/****** Object:  StoredProcedure [dbo].[usp_EliEmpleado]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
----------------------------------------------------------------
CREATE PROC [dbo].[usp_EliEmpleado]
@Emp_cod CHAR(5)
AS
SELECT * FROM Empleados WHERE Emp_cod=@Emp_cod
GO
/****** Object:  StoredProcedure [dbo].[usp_EliminarAlumno]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[usp_EliminarAlumno]
@alu_cod char(5)
as
delete from Alumnos_2 where alu_cod=@alu_cod
GO
/****** Object:  StoredProcedure [dbo].[usp_EmpleadosporAñodeVenta]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[usp_EmpleadosporAñodeVenta]
@Año int
As
Select E.EmployeeID,LastName+space(2)+FirstName as Empleado,Title,
Convert(varchar(10),HireDate,103) as HireDate,Venta=Sum(UnitPrice*Quantity) From 
Employees E,Orders O,[Order Details] d Where E.EmployeeID=O.EmployeeID and
O.OrderID=d.OrderID and year(OrderDate)=@Año Group by E.EmployeeID,LastName,
FirstName,Title,HireDate Order by E.EmployeeID asc
GO
/****** Object:  StoredProcedure [dbo].[Usp_EmpleadosPorOrdenes]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[Usp_EmpleadosPorOrdenes] 
@employeID int
as
select top 5 o.orderId, customerId, o.EmployeeID , 
		orderdate=convert(varchar(30),o.orderdate,103)
from orders o , employees e 
where e.EmployeeID=o.EmployeeID
and e.EmployeeID=@employeID
GO
/****** Object:  StoredProcedure [dbo].[Usp_EmpleadosPorOrdenS9]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create Proc [dbo].[Usp_EmpleadosPorOrdenS9]
@OrderID int
as
Select E.EmployeeID,Empleado=LastName+space(2)+FirstName,
Photo from Employees E, Orders O  Where E.EmployeeID=o.EmployeeID
and OrderID=@OrderID
GO
/****** Object:  StoredProcedure [dbo].[Usp_EmployeesOrdenes]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[Usp_EmployeesOrdenes]
@OrderID int
AS
SELECT p.ProductID,p.ProductName,od.UnitPrice ,od.Quantity ,
Total=od.UnitPrice*od.Quantity
 FROM Orders o,Products p,[Order Details] od
WHERE o.OrderID=od.OrderID AND od.ProductID=p.ProductID AND 
o.OrderID =@OrderID
GROUP BY p.ProductID,p.ProductName,od.UnitPrice ,od.Quantity
GO
/****** Object:  StoredProcedure [dbo].[USP_F_CAMPANIA_POLITICA_TEMP_TRAER_POLITICA]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*



*/
----------------------------------------------------------
----------------------------------------------------------
create	PROCEDURE	[dbo].[USP_F_CAMPANIA_POLITICA_TEMP_TRAER_POLITICA]
@SESION			VARCHAR(10),
@CIA			CHAR(2),
@ID_CAMPANIA	INT,
@ITEM			INT
AS
----------------------------------------------------------
----------------------------------------------------------
SELECT	POL.ITEM, POL.SEDE AS 'ID_SEDE', SEDE.DESCRIPCION AS 'SEDE', POL.ID_CATEGORIA AS 'ID_CATEGORIA', CAT.DESCRIPCION AS 'CATEGORIA', 
		POL.ID_CLIENTE AS 'ID_CLIENTE', CLI.DESCRIPCION AS 'CLIENTE', POL.ID_ARTICULO AS 'ID_ARTICULO', ART.DESCRIPCION AS 'ARTICULO', POL.ID_ESTADO AS 'ESTADO', 
		POL.FECHA_DEL AS 'FECHA_DEL', POL.FECHA_AL AS 'FECHA_AL', POL.HORA_DEL AS 'HORA_DEL', POL.HORA_AL AS 'HORA_AL', POL.CANTIDAD AS 'CANTIDAD', 
		POL.FLAG_L AS 'FLAG_L', POL.FLAG_K AS 'FLAG_K', POL.FLAG_M AS 'FLAG_M', POL.FLAG_J AS 'FLAG_J', POL.FLAG_V AS 'FLAG_V', POL.FLAG_S AS 'FLAG_S', POL.FLAG_D AS 'FLAG_D'
FROM	F_CAMPANIA_POLITICA_TEMP AS POL INNER JOIN
		ANALITICA AS CLI ON POL.CIA = CLI.CIA AND POL.ID_CLIENTE = CLI.ID_ANALITICA INNER JOIN
		ARTICULO AS ART ON POL.CIA = ART.CIA AND POL.ID_ARTICULO = ART.ID_ARTICULO INNER JOIN
		CATEGORIA_ANALITICA AS CAT ON POL.ID_CATEGORIA = CAT.ID_CATEGORIA AND POL.CIA = CAT.CIA INNER JOIN
		SEDE ON POL.CIA = SEDE.CIA AND POL.SEDE = SEDE.SEDE
WHERE	POL.SESION		= @SESION 
AND		POL.CIA			= @CIA 
AND		POL.ID_CAMPANIA = @ID_CAMPANIA
AND		POL.ITEM		= @ITEM
GO
/****** Object:  StoredProcedure [dbo].[USP_fecha]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[USP_fecha]
@nombre varchar(30),@fecha1 varchar(10),@fecha2 varchar(10)
as
select o.orderid,o.ShippedDate,Total_Venta=sum(od.UnitPrice*od.Quantity),
Dias_Envio=datediff(d,o.orderdate,o.ShippedDate),
Estado_Envio=case when(datediff(d,o.orderdate,o.ShippedDate)>=10)then 'Fuera_De_Fecha' 
else 'Entrega_Inmediata'end	
from orders as o,[order details] as od ,Customers as c
where o.OrderID = od.OrderID and c.CompanyName=@nombre 
and orderdate between @fecha1 and @fecha2 and c.CustomerID=o.CustomerID
group by o.orderid,o.ShippedDate,datediff("d",o.orderdate,o.ShippedDate) 
GO
/****** Object:  StoredProcedure [dbo].[usp_gabrarCabecera]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create proc [dbo].[usp_gabrarCabecera]
@fac_num varchar(5),@fac_fec smalldatetime,@cli_cod varchar(5),@fac_igv char(1),
@Total float
As
Insert Into fac_cabe values(@fac_num,@fac_fec,@cli_cod,@fac_igv,@Total)
GO
/****** Object:  StoredProcedure [dbo].[usp_grabarDetalle]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create proc [dbo].[usp_grabarDetalle]
@fac_num varchar(5),@art_cod char(5),@art_pre numeric(10,2),@art_cant int
As
Insert Into fac_deta values(@fac_num,@art_cod,@art_pre,@art_cant)
GO
/****** Object:  StoredProcedure [dbo].[Usp_Ins_Produco]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-----------------------------------------------------------------
Create Procedure [dbo].[Usp_Ins_Produco]
@nombre varchar(70),
@Precio money,
@Stock int
as
Insert Into Products(ProductName,UnitPrice,UnitsInStock)
		Values(@nombre,@precio,@stock)
GO
/****** Object:  StoredProcedure [dbo].[usp_InsAlumno]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create proc [dbo].[usp_InsAlumno]
@alu_cod char(5),@alu_dir varchar(100),@alu_nom varchar(100),
@alu_edad int, @cod_pais int, @cod_ciudad int
as
Insert Into Alumnos values(@alu_cod,@alu_dir,@alu_nom,@alu_edad,
@cod_pais,@cod_ciudad)
GO
/****** Object:  StoredProcedure [dbo].[Usp_InserDocente]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[Usp_InserDocente] 
@codigo CHAR(6),@nombres VARCHAR(100),@especialidad VARCHAR (100)
AS
INSERT INTO docentes VALUES(@codigo,@nombres,@especialidad)
GO
/****** Object:  StoredProcedure [dbo].[Usp_InserEmpleado]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[Usp_InserEmpleado]
@Emp_cod CHAR(6),@Emp_nom VARCHAR(50),@Emp_pais VARCHAR (50),
@Emp_fecha_nac CHAR(12),@Emp_sexo CHAR(20)
AS
INSERT INTO Empleados VALUES(@Emp_cod,@Emp_nom,@Emp_pais,@Emp_fecha_nac,@Emp_sexo)
GO
/****** Object:  StoredProcedure [dbo].[Usp_InserProductos]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[Usp_InserProductos]
@ProductID INT,@ProductName VARCHAR (100),@UnitPrice FLOAT,@UnitsInStock INT
AS
INSERT INTO ProductosVendidosExamen 
VALUES(@ProductID,@ProductName,@UnitPrice,@UnitsInStock)
GO
/****** Object:  StoredProcedure [dbo].[Usp_LetraCustomers]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[Usp_LetraCustomers]
@letras char (5)
AS
SELECT CompanyName FROM Customers WHERE CompanyName 
LIKE '['+@letras+']%'--'b%'
GO
/****** Object:  StoredProcedure [dbo].[usp_ListadoAlumnos]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[usp_ListadoAlumnos]
as
select alu_cod,alu_dir,alu_nom,alu_edad,p.cod_pais,nom_pais,
nom_ciudad from Alumnos_2 a, paises p, ciudades c
where p.cod_pais=a.cod_pais and a.cod_ciudad=c.cod_ciudad order by
alu_cod asc
GO
/****** Object:  StoredProcedure [dbo].[Usp_ListaPaises]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[Usp_ListaPaises]
as 
select cod_pais,nom_pais from paises
GO
/****** Object:  StoredProcedure [dbo].[usp_ListarClientes]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create proc [dbo].[usp_ListarClientes]
As
Select cli_cod,cli_nom from clientes
GO
/****** Object:  StoredProcedure [dbo].[Usp_ListarDocentes]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[Usp_ListarDocentes]
AS
SELECT * FROM docentes
GO
/****** Object:  StoredProcedure [dbo].[Usp_MesesAñoDeVentas]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[Usp_MesesAñoDeVentas]
@año int
AS
SELECT DISTINCT  Mes=datename (mm,orderdate)  FROM Orders
WHERE year(orderdate)=@año
GO
/****** Object:  StoredProcedure [dbo].[usp_MesesdeVenta]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[usp_MesesdeVenta]  
@anio int
As
Select Distinct datename(Month,OrderDate) as Mes,
NumMes=Month(orderdate) From Orders
Where year(OrderDate)=@anio
GO
/****** Object:  StoredProcedure [dbo].[usp_NBusDocentes]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Busqueda de Docentes---
Create proc [dbo].[usp_NBusDocentes]
@codigo char(6)
As
Select * from Docentes Where codigo=@codigo
GO
/****** Object:  StoredProcedure [dbo].[usp_NEliDocente]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create proc [dbo].[usp_NEliDocente]
@codigo char(6)
As
Delete from Docentes Where codigo=@codigo
GO
/****** Object:  StoredProcedure [dbo].[usp_NInserDocente]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create proc [dbo].[usp_NInserDocente]
@codigo char(6),@nombres varchar(100),@fecha smalldatetime,
@especialidad varchar(100),@foto image
As
Insert Into Docentes values(@codigo,@nombres,@fecha,
				@especialidad,@foto)
GO
/****** Object:  StoredProcedure [dbo].[usp_NListadoDocentes]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create proc [dbo].[usp_NListadoDocentes]
As
Select * From Docentes
GO
/****** Object:  StoredProcedure [dbo].[usp_NUpdateDocente]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create proc [dbo].[usp_NUpdateDocente]
@codigo char(6),@nombres varchar(100),@fecha smalldatetime,
@especialidad varchar(100),@foto image
As
Update Docentes Set nombres=@nombres,fecha=@fecha,
	especialidad=@especialidad,foto=@foto Where
  codigo=@codigo
GO
/****** Object:  StoredProcedure [dbo].[Usp_OrdenesEmitidasPorPais]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROC [dbo].[Usp_OrdenesEmitidasPorPais]
@ShipCountry VARCHAR(15)
as 
SELECT orderId,OrderDate,ShippedDate ,Freight  FROM Orders  
WHERE  ShipCountry=@ShipCountry 
GO
/****** Object:  StoredProcedure [dbo].[usp_OrdenesporClientesporMesyAño]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[usp_OrdenesporClientesporMesyAño]
@anio int,@Mes Varchar(30)
As
Select C.CustomerID,CompanyName,Count(OrderID) As Cantidad from Orders O,
Customers C Where O.CustomerID=c.CustomerID and 
Datename(Month,OrderDate)=@Mes and year(OrderDate)=@anio
Group by C.CustomerID,CompanyName Order by Cantidad Desc
GO
/****** Object:  StoredProcedure [dbo].[usp_OrdenesVendidasporEmpleados]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create proc [dbo].[usp_OrdenesVendidasporEmpleados]
@codigos varchar(100)
As
Exec('Select O.OrderID,EmployeeID,OrderDate=convert(varchar(30),OrderDate,103),
Freight,Total=Sum(UnitPrice*Quantity) From 
Orders O,[Order Details] d Where O.OrderID=d.OrderID and EmployeeID in('+@codigos+') 
Group by O.OrderID,EmployeeID,OrderDate,Freight')
GO
/****** Object:  StoredProcedure [dbo].[usp_OrdenesVendidasporEmpleados2]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE proc [dbo].[usp_OrdenesVendidasporEmpleados2] 
@codigos int
As
Select O.OrderID,EmployeeID,OrderDate=convert(varchar(30),OrderDate,103),
Freight,Total=Sum(UnitPrice*Quantity) From 
Orders O,[Order Details] d Where O.OrderID=d.OrderID and EmployeeID =@codigos
Group by O.OrderID,EmployeeID,OrderDate,Freight
GO
/****** Object:  StoredProcedure [dbo].[USp_PaisesPorOrdenes]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  PROC [dbo].[USp_PaisesPorOrdenes]
as
--SELECT distinct ShipCountry FROM Orders --WHERE ShipCountry=@ShipCountry 
select distinct country,CustomerID from customers
GO
/****** Object:  StoredProcedure [dbo].[USp_Producto_Categories]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*

DECLARE @MENSAJE VARCHAR(MAX)
EXEC [USP_PRODUCTO_CATEGORIES] '2', @MENSAJE OUTPUT
PRINT @MENSAJE

*/
-------------------------------------------
-------------------------------------------
CREATE PROC [dbo].[USp_Producto_Categories]
@CATEGORYID VARCHAR(5),
@MENSAJE	VARCHAR(MAX)OUTPUT
AS
-------------------------------------------
-------------------------------------------
SELECT	PRODUCTID AS 'ID PRODUCTO', 
		PRODUCTNAME AS 'DESCRIPCION',
		SUPPLIERID AS 'ID SUPPLIER',
		C.CATEGORYID AS 'ID CATEGORIA'
FROM	DBO.PRODUCTS P, DBO.CATEGORIES C
WHERE	C.CATEGORYID	= P.CATEGORYID 
AND		C.CATEGORYID	LIKE '%' + @CATEGORYID + '%'
-------------------------------------------
IF(@CATEGORYID = '')
BEGIN
	---------------------------------------
	 SET @MENSAJE	= 'NO HA INGRESADO NINGUN CARACTER.'
	---------------------------------------
END
ELSE
BEGIN
	---------------------------------------
	SET	@MENSAJE	= 'USTED INGRESO: ' + CONVERT(VARCHAR(5),@CATEGORYID)
	---------------------------------------
END
GO
/****** Object:  StoredProcedure [dbo].[usp_ProductosVendidosporOrden]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
---------------------------------------------------------------------------------------
Create proc [dbo].[usp_ProductosVendidosporOrden]
@Orden int
As
Select P.ProductID,ProductName,P.UnitPrice,Quantity,P.UnitPrice*Quantity as Total From 
Products P,[Order Details] d Where P.ProductID=d.ProductID and OrderID=@Orden
GO
/****** Object:  StoredProcedure [dbo].[usp_Reporte1]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create procedure [dbo].[usp_Reporte1]
As
Select C.CustomerID,CompanyName,Count(OrderID) as Cantidad,Year(OrderDate) as Año
From Customers C,Orders O Where C.CustomerID=O.CustomerID 
Group by C.CustomerID,CompanyName,Year(OrderDate) Order by Cantidad desc
GO
/****** Object:  StoredProcedure [dbo].[usp_Reporte2]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create procedure [dbo].[usp_Reporte2]
As
Select C.CustomerID,CompanyName,Count(OrderID) as Cantidad,Year(OrderDate) as Año,
Datename(Month,OrderDate) as Mes
From Customers C,Orders O Where C.CustomerID=O.CustomerID 
Group by C.CustomerID,CompanyName,Year(OrderDate),Datename(Month,OrderDate)
Order by Cantidad desc
GO
/****** Object:  StoredProcedure [dbo].[Usp_ReporteDeVenta]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[Usp_ReporteDeVenta]
@fac_num VARCHAR(6)
AS
	 SELECT fc.fac_num, 
		    Fecha=CONVERT(VARCHAR(30),fac_fec,103),
			c.cli_nom, fac_igv,	art_cod, art_pre,
			art_can=sum(art_can), total
	FROM fac_cabe fc, fac_deta fd, clientes c
	WHERE fc.fac_num=fd.fac_num 
	AND c.cli_cod = fc.cli_cod
	group BY fc.fac_num, fac_fec, c.cli_nom, 
			fac_igv,art_cod, art_pre, total
	ORDER BY fc.fac_num
GO
/****** Object:  StoredProcedure [dbo].[usp_ServiceProductosVendidos]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE procedure [dbo].[usp_ServiceProductosVendidos]
@OrderID varchar(100)
As
Exec("Select P.ProductID,ProductName,P.UnitPrice,Quantity,
	(P.Unitprice * Quantity) as Total,OrderID From [Order Details] Od,Products P
 Where Od.ProductID=P.ProductID  and OrderID in("+@OrderID+")
	Order by OrderID asc")

GO
/****** Object:  StoredProcedure [dbo].[Usp_UpdateDocentes]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[Usp_UpdateDocentes]
@codigo char(6),@nombres varchar(100),
@especialidad varchar(100)
as
update docentes set nombres=@nombres,
especialidad=@especialidad where codigo=@codigo
GO
/****** Object:  StoredProcedure [dbo].[WEB_LISTAR_CLIENTES_POR_FACTURAS_V]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[WEB_LISTAR_CLIENTES_POR_FACTURAS_V]
@FAC_NUM CHAR(5)
AS
SELECT VA.art_cod,VA.art_nom,VFD.art_can,VFD.art_pre,SUM(vfd.art_can*vfd.art_pre)'total' 
FROM VENTAS_Fac_cabe vf 
INNER JOIN VENTAS_Fac_deta VFD ON vfd.fac_num=vf.fac_num
INNER JOIN VENTAS_Articulos VA ON VA.art_cod=VFD.art_cod
WHERE vf.fac_num=@FAC_NUM 
GROUP BY  VA.art_cod,VA.art_nom,VFD.art_can,VFD.art_pre
 ORDER BY  VA.art_cod
GO
/****** Object:  StoredProcedure [dbo].[WEB_LISTAR_CLIENTES_V]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[WEB_LISTAR_CLIENTES_V]
@CLI_nom varchar(max)
AS
SELECT vc.cli_cod,vc.cli_nom--,vf.fac_num
FROM VENTAS_Clientes vc 
left JOIN VENTAS_Fac_cabe vf ON vf.cli_cod=vc.cli_cod
WHERE vc.CLI_nom LIKE  @CLI_nom + '%'
GROUP BY vc.cli_cod,vc.cli_nom--,vf.fac_num
ORDER BY  vc.cli_cod
GO
/****** Object:  StoredProcedure [dbo].[WEB_LISTAR_FACTURAS_V]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[WEB_LISTAR_FACTURAS_V]
@CLI_COD CHAR(5)
AS
SELECT vf.fac_num FROM VENTAS_Clientes vc 
INNER JOIN VENTAS_Fac_cabe vf ON vf.cli_cod=vc.cli_cod
WHERE vc.cli_cod=@CLI_COD GROUP BY vc.cli_cod,vc.cli_nom,vf.fac_num ORDER BY  vf.fac_num
GO
/****** Object:  StoredProcedure [dbo].[XSP_REPORTE_ESTADO_FRAGMENTACIoN_TABLAS]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--	COMO CREAR UN REPORTE DEL ESTADO DE FRAGMENTACIÓN DE LAS TABLAS 
/*
Es muy importante que a menudo revisemos el estado de fragmentación de nuestras tablas,
 ya que estas pueden afectar el performance de nuestro manejador.
Una de las tareas de un administrador de bases de datos es llevar un control de cuando
 es necesario eliminar la fragmentación de ciertas tablas. Esto puede ser una actividad 
 muy sencilla para bases de datos pequeñas pues es un mantenimiento que nos puede llevar 
 solo unos cuantos minutos, pero que pasa con las bases de datos de varios gigas. 
 Es una tarea bastante pesada tan solo para revisar el estado de fragmentación de nuestras tablas.
A continuación muestro una forma de generar un reporte de la fragmentación de nuestra base de datos 
que podría ser automatizada facilmente con la ayuda de un job y ejecutarla los fines de semana.
 Así el lunes podemos revisar la información y planear el reindex de alguna de las tablas.
Antes que nada debemos de crear una tabla en donde vamos a guardar la información.
*/


/*
CREATE TABLE TBL_SHOWCONTIG (
ObjectName CHAR (255),
ObjectId INT,
IndexName CHAR (255),
IndexId INT,Lvl INT,
CountPages INT,
CountRows INT,
MinRecSize INT,
MaxRecSize INT,
AvgRecSize INT,
ForRecCount INT,
Extents INT,
ExtentSwitches INT,
AvgFreeBytes INT,
AvgPageDensity INT,
ScanDensity DECIMAL,
BestCount INT,
ActualCount INT,
LogicalFrag DECIMAL,
ExtentFrag DECIMAL
)
*/

/*
 Después ejecutamos el comando que va a alimentar esta tabla, el cuál podría ser 
 programado dentro de algún job, donde el primero paso sería eliminar los registros
  existente para posteriormente poder alimentar la tabla.
  */
  
  /*
INSERT tbl_ShowContig EXEC ('DBCC SHOWCONTIG WITH ALL_INDEXES, TABLERESULTS')
go
*/


--	Ahora ya estamos listos para revisar la fragmentación de nuestras tablas
/*
SELECT ObjectName, IndexName,IndexID,CountRows,ScanDensity 
FROM tbl_ShowContig WHERE ObjectName NOT LIKE 'dt%' AND ObjectName
 NOT LIKE 'sys%'ORDER BY ScanDensity DESC
 go
 */
 --		drop table TBL_SHOWCONTIG
 
-------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------

 /*
 Si la columna indexid es igual a 0, significa que la tabla no contiene un índice clustered si es 1,
 siginfica que ese es un índice clustered y los que son mayores a 1 son índices nonclustered
La columna que nos importa para ver que tan fragmentada se encuentra nuestra tabla es ScanDensity ,
cuando todo esta completamente desfragmentado el valor es 100, si es menor a 100 significa que existe 
fragmentación en la tabla.
Desde mi punto de vista personal, considero que una tabla necesita ser desfragmentada cuando el valor 
en ScanDensity es menor a 75. Para hacer esto puede borrar el índice y volverlo o utilizar el comando
 DBCC DBREINDEX o DBCC INDEXDEFRAG.
La diferencia entre los dos, es que el INDEXDEFRAG es una operación que se puede hacer en linea,
 mientras se tienen usuarios haciendo uso de la tabla, pues no genera bloqueos que duren mucho tiempo. 
 Una desventaja de este metodo es que puede llevarse mucho más tiempo que un DBREINDEX cuando los
  índices estan demasiado fragmentados. El DBREINDEX si genera bloqueos muy largos mientras esta
   regenerando los índices.
Recuerda desfragmentar tus tablas, he presenciado casos en donde la fragmentación de una tabla cambia
 el plan de ejecución de un query haciendo que tarde hasta 20 minutos en correr y al eliminar la 
 fragmentación reducir su tiempo a 6 segundos con el nuevo plan de ejecución generado por SQL Server.
Si quisieramos crear algun job que haga esto diariamente y guardar estadísticas delcomportamiento de 
la fragmentación de nuestras tablas podemos crear una tabla con un constraint de esta manera.
 */
 
 /*
 CREATE TABLE [dbo].[TBL_SHOWCONTIG] (
  [ObjectName] [char] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
  [ObjectId] [int] NULL ,
  [IndexName] [char] (255)	    COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
  [IndexId] [int] NULL ,		[Lvl] [int] NULL ,			 [CountPages] [int] NULL , 
  [CountRows] [int] NULL ,		[MinRecSize] [int] NULL ,	  [MaxRecSize] [int] NULL , 
  [AvgRecSize] [int] NULL ,		[ForRecCount] [int] NULL ,    [Extents] [int] NULL , 
  [ExtentSwitches] [int] NULL , [AvgFreeBytes] [int] NULL ,   [AvgPageDensity] [int] NULL ,
  [ScanDensity] [decimal](18, 0) NULL ,[BestCount] [int] NULL ,  [ActualCount] [int] NULL ,
  [LogicalFrag] [decimal](18, 0) NULL , [ExtentFrag] [decimal](18, 0) NULL ,
  [FracDate] [datetime] NOT NULL ) ON [PRIMARY]
  GO
ALTER TABLE [dbo].[TBL_SHOWCONTIG] ADD  CONSTRAINT [todaydate] DEFAULT (getdate())
 FOR [FracDate]
GO
*/

--Y un job que ejecute diario esto:
/*
INSERT into tbl_ShowContig (ObjectName,ObjectId,IndexName,IndexId,Lvl,CountPages,
CountRows,MinRecSize,MaxRecSize,AvgRecSize,ForRecCount,Extents,ExtentSwitches,
AvgFreeBytes,AvgPageDensity,ScanDensity,BestCount,ActualCount,LogicalFrag,ExtentFrag)
EXEC ('DBCC SHOWCONTIG WITH ALL_INDEXES, TABLERESULTS')
*/
CREATE proc [dbo].[XSP_REPORTE_ESTADO_FRAGMENTACIoN_TABLAS]
as
select * from customers
GO
/****** Object:  StoredProcedure [dbo].[Z_reptq1]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Z_reptq1] AS
select 
	case when grouping(pub_id) = 1 then 'ALL' else pub_id end as pub_id, 
	avg(price) as avg_price
from titles
where price is NOT NULL
group by pub_id with rollup
order by pub_id
GO
/****** Object:  StoredProcedure [dbo].[Z_Reptq2]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Z_Reptq2] AS
select 
	case when grouping(type) = 1 then 'ALL' else type end as type, 
	case when grouping(pub_id) = 1 then 'ALL' else pub_id end as pub_id, 
	avg(ytd_sales) as avg_ytd_sales
from titles
where pub_id is NOT NULL
group by pub_id, type with rollup
GO
/****** Object:  StoredProcedure [dbo].[Z_reptq3]    Script Date: 15/11/2018 17:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Z_reptq3] @lolimit money, @hilimit money,
@type char(12)
AS
select 
	case when grouping(pub_id) = 1 then 'ALL' else pub_id end as pub_id, 
	case when grouping(type) = 1 then 'ALL' else type end as type, 
	count(title_id) as cnt
from titles
where price >@lolimit AND price <@hilimit AND type = @type OR type LIKE '%cook%'
group by pub_id, type with rollup
GO
