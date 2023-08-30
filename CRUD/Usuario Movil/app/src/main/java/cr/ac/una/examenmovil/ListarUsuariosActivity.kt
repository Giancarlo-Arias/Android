package cr.ac.una.examenmovil

import android.content.Intent
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.view.View
import android.widget.Toast
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.android.volley.Request
import com.android.volley.RequestQueue
import com.android.volley.Response
import com.android.volley.VolleyError
import com.android.volley.toolbox.JsonObjectRequest
import com.android.volley.toolbox.Volley
import cr.ac.una.examenmovil.Data.UsuarioData
import cr.ac.una.examenmovil.Domain.AdapterRecyclerUsuarios
import cr.ac.una.examenmovil.Domain.Usuario
import org.json.JSONException
import org.json.JSONObject
import java.text.SimpleDateFormat
import java.util.Locale

class ListarUsuariosActivity : AppCompatActivity() , Response.Listener<JSONObject>, Response.ErrorListener{
    private var ID_USUARIO: Int = 0
    val usuarioDB = UsuarioData()
    private lateinit var requestQueue: RequestQueue
    private lateinit var recycler: RecyclerView
    private lateinit var usuarios: ArrayList<Usuario>
    private lateinit var jsonRequest: JsonObjectRequest

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_listar_usuarios)
        requestQueue = Volley.newRequestQueue(this)

        val intent = intent
        ID_USUARIO = intent.getIntExtra("id_usuario", 0)
        jsonRequest = JsonObjectRequest(Request.Method.GET, usuarioDB.getObtenerValue(), null, this, this)
        requestQueue.add(jsonRequest)
        Toast.makeText(this, "Enviando solicitud...", Toast.LENGTH_SHORT).show()

        recycler = findViewById(R.id.recyclerUsuarios)
        recycler.layoutManager = LinearLayoutManager(this, LinearLayoutManager.VERTICAL,false)
        usuarios = ArrayList()
    }

    override fun onResponse(response: JSONObject) {
        try {
            val jsonArray = response.getJSONArray("usuarios")
            val usuarios = ArrayList<Usuario>()
            for (i in 0 until jsonArray.length()) {
                val jsonObject = jsonArray.getJSONObject(i)
                val idUsuario = jsonObject.getInt("id")
                val nombre = jsonObject.getString("nombre")
                val edad = jsonObject.getInt("edad")
                val fecha = jsonObject.getString("fecha")
                val activo = jsonObject.getInt("activo")
                val correo = jsonObject.getString("correo")
                val formatoFecha = SimpleDateFormat("yyyy-MM-dd", Locale.getDefault())
                val fechas = formatoFecha.parse(fecha)
                val usuario = Usuario(idUsuario, nombre,fechas, edad, correo, activo)
                usuarios.add(usuario)
            }
            if (usuarios.isEmpty()) {
                Toast.makeText(this, "No hay usuarios.", Toast.LENGTH_SHORT).show()
            } else {
                val adapter = AdapterRecyclerUsuarios(this, usuarios)
                recycler.adapter = adapter
            }
        } catch (e: JSONException) {
            e.printStackTrace()
        }
    }

    override fun onErrorResponse(error: VolleyError) {
        Toast.makeText(this, "Error al obtener los usuarios.", Toast.LENGTH_SHORT).show()
    }
    fun volverInicio(view: View?) {
        val intent = Intent(view?.context, MainActivity::class.java)
        view?.context?.startActivity(intent)
    }

    fun AgregarUsuario(view: View?) {
        val intent = Intent(view?.context, AgregarUsuarioActivity::class.java)
        view?.context?.startActivity(intent)
    }
}