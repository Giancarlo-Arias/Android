using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Xamarin.Forms;

namespace XamarinCrud
{
    public partial class MainPage : ContentPage
    {
        public MainPage()
        {
            InitializeComponent();
        }

        async void irRegistrar(object senter, EventArgs e)
        {
            await Navigation.PushAsync(new ViewPageInsertar());
        }

        void Editar(object senter, EventArgs e)
        {
            ListUsuarios.IsVisible = false;
            MiStackLayout.IsVisible = true;
            btnRegistrar.IsVisible = false;
            btnConsulUsuario.IsVisible = false;
            btnEliminar.IsVisible = false;
            btnEditar.IsVisible = false;
        }

        void AtrasEditar(object senter, EventArgs e)
        {
            ListUsuarios.IsVisible = true;
            MiStackLayout.IsVisible = false;
            btnRegistrar.IsVisible = true;
            btnConsulUsuario.IsVisible = true;
            btnEliminar.IsVisible = true;
            btnEditar.IsVisible = true;
        }

        void consultar(object senter, EventArgs e)
        {
            ListUsuarios.IsVisible = true;
        }

        private async void MostrarMensajeEditar(object sender, EventArgs e)
        {
            await DisplayAlert("Alert", "Editado Correctamente", "OK");
            await Navigation.PushAsync(new MainPage());
        }
    }
}
