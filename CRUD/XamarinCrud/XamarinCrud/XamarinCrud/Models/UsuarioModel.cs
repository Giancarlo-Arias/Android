using System;
using System.Collections.Generic;
using System.Text;

namespace XamarinCrud.Models
{
    public class UsuarioModel
    {
        public int id { get; set; }
        public string nombre { get; set; }
        public int edad { get; set; }
        public string fecha { get; set; }
        public int activo { get; set; }
        public string correo { get; set; }
    }
}
