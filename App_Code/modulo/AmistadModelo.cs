﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

/// <summary>
/// Summary description for AmistadModelo
/// </summary>
public class AmistadModelo
{
    public int Id_Amistad { set; get; }
    public UsuarioModelo Usuario { set; get; }
    public UsuarioModelo Usuario2 { set; get; }
    public AmistadModelo()
    {
        //
        // TODO: Add constructor logic here
        //
    }
}