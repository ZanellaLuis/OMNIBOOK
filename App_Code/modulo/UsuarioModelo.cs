﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

/// <summary>
/// Summary description for UsuarioModelo
/// </summary>
public class UsuarioModelo
{
        public long Id_Usuario { get; set; }
        public string Nombre { get; set; }
        public string Nick { get; set; }
        public string Correo { get; set; }
        public string Contrasenia { get; set; }
        public string Fecha_Nacimiento { get; set; }
        public bool Estatus { get; set; }
    //
    // TODO: Add constructor logic here
    //
    public UsuarioModelo() {
    }
}