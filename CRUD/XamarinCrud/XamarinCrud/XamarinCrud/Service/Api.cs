using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Net.Http.Headers;
using System.Net.Http;
using System.Text;
using System.Threading.Tasks;
using Newtonsoft.Json;

namespace XamarinCrud.Service
{
    public class Api
    {
        Uri urlBase = new Uri("http://192.168.100.72:3000");

        //consulta
        public async Task<T> consultarUsuarios<T>()
        {
            string requestUri = "/listUsuarios";
            var client = new HttpClient();
            client.BaseAddress = urlBase;

            HttpResponseMessage response = await client.GetAsync($"{requestUri}");

            if (response.IsSuccessStatusCode)
            {
                var json = await response.Content.ReadAsStringAsync();

                return JsonConvert.DeserializeObject<T>(json);
            }
            else
            {
                return default(T);
            }
        }

        public async Task<bool> insertarPost<T>(T data)
        {
            string requestUri = "/add-usuario";
            var usuario = new HttpClient();
            usuario.BaseAddress = urlBase;
            usuario.DefaultRequestHeaders.Accept.Clear();
            usuario.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));

            var json = JsonConvert.SerializeObject(data);
            var content = new StringContent(json, Encoding.UTF8, "application/json");

            HttpResponseMessage response = await usuario.PostAsync(requestUri, content);
            return response.IsSuccessStatusCode;
        }

        //Eliminar
        public async Task<bool> ExecuteRequestDelete(string stParams)
        {
            string requestUri = $"/usuarios/{stParams}";
            var client = new HttpClient();
            client.BaseAddress = urlBase;

            HttpResponseMessage response = await client.DeleteAsync(requestUri);
            return response.IsSuccessStatusCode;
        }


        //consulta
        public async Task<T> ConsultRequestUpdate<T>(string stParams)
        {
            string requestUri = $"/usuarios/{stParams}";
            var client = new HttpClient();
            client.BaseAddress = urlBase;

            HttpResponseMessage response = await client.GetAsync($"{requestUri}");
            if (response.IsSuccessStatusCode)
            {
                var json = await response.Content.ReadAsStringAsync();

                if (typeof(T).IsGenericType && typeof(T).GetGenericTypeDefinition() == typeof(ObservableCollection<>))
                {
                    // Si el tipo es una colección, envuelve el objeto JSON en un arreglo
                    json = $"[{json}]";
                }

                return JsonConvert.DeserializeObject<T>(json);
            }
            else
            {
                return default(T);
            }
        }

        public async Task<bool> executeRequestPut<T>(T data, int stParams)
        {
            string requestUri = $"/usuarios/{stParams}";
            var usuario = new HttpClient();
            usuario.BaseAddress = urlBase;
            usuario.DefaultRequestHeaders.Accept.Clear();
            usuario.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));

            var json = JsonConvert.SerializeObject(data);
            var content = new StringContent(json, Encoding.UTF8, "application/json");

            HttpResponseMessage response = await usuario.PutAsync(requestUri, content);
            return response.IsSuccessStatusCode;
        }

    }
}
