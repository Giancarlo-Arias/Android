using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Text.RegularExpressions;

using Xamarin.Forms;
using Xamarin.Forms.Xaml;

namespace XamarinCrud
{
    [XamlCompilation(XamlCompilationOptions.Compile)]
    public partial class ViewPageInsertar : ContentPage
    {
        public ViewPageInsertar()
        {
            InitializeComponent();
        }

        private async void MostrarMensajeInsertar(object sender, EventArgs e)
        {
            string nombre = NombreEntry.Text;
            string correo = CorreoEntry.Text;

            if (string.IsNullOrEmpty(nombre) || string.IsNullOrEmpty(correo))
            {
                await DisplayAlert("Error", "Por favor, complete todos los campos.", "Aceptar");
                return;
            }

            // Validar que el campo de nombre solo contenga letras y espacios
            if (!Regex.IsMatch(nombre, "^[a-zA-Z ]+$"))
            {
                await DisplayAlert("Error", "El campo de nombre solo puede contener letras y espacios.", "Aceptar");
                return;
            }

            await DisplayAlert("Alerta", "Registrado correctamente", "OK");
            await Navigation.PushAsync(new MainPage());
        }
    }
}
