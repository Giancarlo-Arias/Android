using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Input;
using Xamarin.Forms;
using XamarinCrud.Models;
using XamarinCrud.Service;

namespace XamarinCrud.ViewModels
{
    public class ViewModelInsertar : ViewModelBase
    {
        Api webApi = new Api();

        private ObservableCollection<UsuarioModel> listaUsuarios;
        public ObservableCollection<UsuarioModel> ListaUsuarios
        {
            get { return listaUsuarios; }
            set { listaUsuarios = value; RaisePropertyChanged(); }
        }

        public ICommand InsertarUsuarioCommand { get; set; }

        public ViewModelInsertar()
        {
            InsertarUsuarioCommand = new Command(async () => await InsertarUsuario());
        }

        private int Id;
        private string Nombre;
        private int Edad;
        private int Activo;
        private string Fecha;
        private string Correo;

        public int id
        {
            get { return Id; }
            set { Id = value; RaisePropertyChanged(); }
        }

        public string nombre
        {
            get { return Nombre; }
            set { Nombre = value; RaisePropertyChanged(); }
        }

        public int edad
        {
            get { return Edad; }
            set { Edad = value; RaisePropertyChanged(); }
        }

        public int activo
        {
            get { return Activo; }
            set { Activo = value; RaisePropertyChanged(); }
        }

        public string fecha
        {
            get { return Fecha; }
            set { Fecha = value; RaisePropertyChanged(); }
        }

        public string correo
        {
            get { return Correo; }
            set { Correo = value; RaisePropertyChanged(); }
        }

        public async Task InsertarUsuario()
        {
            if (string.IsNullOrEmpty(nombre) || string.IsNullOrEmpty(correo))
            {
                await App.Current.MainPage.DisplayAlert("Error", "Por favor, complete todos los campos.", "Aceptar");
                return;
            }

            // Validar que el campo de nombre solo contenga letras y espacios
            if (!System.Text.RegularExpressions.Regex.IsMatch(nombre, "^[a-zA-Z ]+$"))
            {
                await App.Current.MainPage.DisplayAlert("Error", "El campo de nombre solo puede contener letras y espacios.", "Aceptar");
                return;
            }

            UsuarioModel usuario = new UsuarioModel()
            {
                nombre = nombre,
                edad = edad,
                activo = activo,
                fecha = fecha,
                correo = correo
            };

            bool isInsertSuccessful = await webApi.insertarPost(usuario);

            if (isInsertSuccessful)
            {
                // La inserción se realizó correctamente
                await App.Current.MainPage.DisplayAlert("Éxito", "Usuario insertado correctamente.", "Aceptar");
                Console.WriteLine("Usuario insertado correctamente.");
            }
            else
            {
                // La inserción falló
                await App.Current.MainPage.DisplayAlert("Error", "Error al insertar el usuario.", "Aceptar");
                Console.WriteLine("Error al insertar el usuario.");
            }
        }
    }
}
