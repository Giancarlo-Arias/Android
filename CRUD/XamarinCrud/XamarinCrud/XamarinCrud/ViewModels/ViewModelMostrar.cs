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
    public class ViewModelMostrar : ViewModelBase
    {
        Api webApi = new Api();

        //inicio consulta
        private ObservableCollection<UsuarioModel> listaUsuarios;
        public ObservableCollection<UsuarioModel> ListaUsuarios
        {
            get { return listaUsuarios; }
            set { listaUsuarios = value; RaisePropertyChanged(); }
        }

        public ICommand ConsultaListaUsuariosCommand { get; set; }

        public ICommand EliminarUsuarioGetCommand { get; set; }

        public ICommand EditarUsuarioGetCommand { get; set; }

        public ICommand EditarUsuarioCommand { get; set; }

        public ViewModelMostrar()
        {
            //consultar
            ConsultaListaUsuariosCommand = new Command(async () => await ConsultaListaUsuarios());
            //Eliminar
            EliminarUsuarioGetCommand = new Command(async () => await EliminarUsuarioGet());
            //Consultareditar
            EditarUsuarioGetCommand = new Command(async () => await EditarUsuarioGet());
            //Editar
            EditarUsuarioCommand = new Command(async () => await EditarUsuario());
        }


        private UsuarioModel usuarioSeleccionado;
        public UsuarioModel UsuarioSeleccionado
        {
            get { return usuarioSeleccionado; }
            set { usuarioSeleccionado = value; RaisePropertyChanged(); }
        }

        public ObservableCollection<UsuarioModel> listaEditar;
        public ObservableCollection<UsuarioModel> ListaEditar
        {
            get { return listaEditar; }
            set { listaEditar = value; RaisePropertyChanged(); }
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

        public async Task EliminarUsuarioGet()
        {
            if (UsuarioSeleccionado != null)
            {
                bool confirm = await App.Current.MainPage.DisplayAlert("Confirmar", "¿Estás seguro de que quieres eliminar este usuario?", "Sí", "No");

                if (confirm)
                {
                    int id = UsuarioSeleccionado.id;
                    string stParamsDelete = $"{id}";
                    bool success = await webApi.ExecuteRequestDelete(stParamsDelete);

                    if (success)
                    {
                        await App.Current.MainPage.DisplayAlert("Éxito", "Usuario eliminado correctamente.", "Aceptar");
                        ListaUsuarios = await webApi.consultarUsuarios<ObservableCollection<UsuarioModel>>();
                    }
                    else
                    {
                        await App.Current.MainPage.DisplayAlert("Error", "Error al eliminar el usuario.", "Aceptar");
                    }
                }
            }
        }




        public async Task ConsultaListaUsuarios()
        {
            ListaUsuarios = await webApi.consultarUsuarios<ObservableCollection<UsuarioModel>>();//consulta
        }


        public async Task EditarUsuarioGet()
        {
            if (UsuarioSeleccionado != null)
            {
                
                    int id = UsuarioSeleccionado.id;
                    string stParamsUpdate = $"{id}";
                    ListaEditar = await webApi.ConsultRequestUpdate<ObservableCollection<UsuarioModel>>(stParamsUpdate);

                    foreach (var item in ListaEditar)
                    {
                        id = item.id;
                        nombre = item.nombre;
                        edad = item.edad;
                        fecha = item.fecha;
                        activo = item.activo;
                        correo = item.correo;
                    }
                
                

            }
            
        }

        public async Task EditarUsuario()
        {
            bool confirm = await App.Current.MainPage.DisplayAlert("Confirmar", "¿Estás seguro de que quieres guardar los cambios?", "Sí", "No");

            if (confirm)
            {
                UsuarioModel usuario = new UsuarioModel()
                {
                    nombre = nombre,
                    edad = edad,
                    fecha = fecha,
                    activo = activo,
                    correo = correo
                };

                bool isInsertSuccessful = await webApi.executeRequestPut(usuario, usuarioSeleccionado.id);

                if (isInsertSuccessful)
                {
                    await App.Current.MainPage.DisplayAlert("Éxito", "Usuario actualizado correctamente.", "Aceptar");
                }
                else
                {
                    await App.Current.MainPage.DisplayAlert("Error", "Error al actualizar el usuario.", "Aceptar");
                }
            }
        }


    }
}
