package cr.ac.una.examenmovil.Domain

import android.content.Context
import android.content.Intent
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.Button
import android.widget.TextView
import android.widget.Toast
import androidx.recyclerview.widget.RecyclerView
import com.android.volley.RequestQueue
import com.android.volley.Response
import com.android.volley.toolbox.StringRequest
import com.android.volley.toolbox.Volley
import cr.ac.una.examenmovil.ActualizarUsuarioActivity
import cr.ac.una.examenmovil.Data.UsuarioData
import cr.ac.una.examenmovil.R
import java.util.HashMap

class AdapterRecyclerUsuarios(
    private val context: Context,
    private var lista: List<Usuario>
) : RecyclerView.Adapter<AdapterRecyclerUsuarios.ViewHolderDatos>(){
    private val requestQueue: RequestQueue = Volley.newRequestQueue(context)

    override fun onCreateViewHolder(parent: ViewGroup,viewType: Int): AdapterRecyclerUsuarios.ViewHolderDatos {
        val view = LayoutInflater.from(parent.context)
            .inflate(R.layout.list_card_usuario,parent,false)
        return ViewHolderDatos(view)
    }

    override fun onBindViewHolder(holder: AdapterRecyclerUsuarios.ViewHolderDatos, position: Int) {
        holder.asignarDatos(lista[position])
    }

    override fun getItemCount(): Int {
        return lista.size
    }

    private fun eliminarUsuario(usuario: Usuario) {
        val usuarioDB = UsuarioData()
        val url = "${usuarioDB.getEliminarValue()}id=${usuario.getId()}"

        val request = object : StringRequest(
            Method.GET, url,
            Response.Listener { response ->
                Toast.makeText(
                    context,
                    "Usuario eliminado exitosamente",
                    Toast.LENGTH_SHORT
                ).show()

                // Lógica para eliminar el usuario de la lista
                lista = lista.filter { it.getId() != usuario.getId() }
                notifyDataSetChanged()
            },
            Response.ErrorListener { error ->
                Toast.makeText(
                    context,
                    "Error al eliminar el usuario",
                    Toast.LENGTH_SHORT
                ).show()
            }) {

            override fun getHeaders(): MutableMap<String, String> {
                val headers = HashMap<String, String>()
                headers["Content-Type"] = "application/json"
                return headers
            }
        }

        requestQueue.add(request)
    }
    inner class ViewHolderDatos(itemView: View) : RecyclerView.ViewHolder(itemView) {

        private val nombreUsuario: TextView = itemView.findViewById(R.id.card_descripcion)
        private val fechausuario: TextView = itemView.findViewById(R.id.card_fecha)
        private val edadUsuario: TextView = itemView.findViewById(R.id.card_edad)
        private val correoUsuario: TextView = itemView.findViewById(R.id.card_correo)
        private val activoUsuario: TextView = itemView.findViewById(R.id.card_activo)
        private val buttonEliminar: Button = itemView.findViewById(R.id.card_button_eliminar)
        private val buttonEditar: Button = itemView.findViewById(R.id.card_editar)

        init {
            buttonEliminar.setOnClickListener {
                val posicion = adapterPosition
                if (posicion != RecyclerView.NO_POSITION) {
                    val usuario = lista[posicion]
                    eliminarUsuario(usuario)
                }
            }

            buttonEditar.setOnClickListener {
                val posicion = adapterPosition
                if (posicion != RecyclerView.NO_POSITION) {
                    val usuario = lista[posicion]
                    abrirActualizaUsuarioActivity(usuario)
                }
            }
        }

        fun asignarDatos(usuario: Usuario) {
            nombreUsuario.text = usuario.getDescripcion()
            fechausuario.text = "Fecha: " + usuario.getFecha().toString()
            edadUsuario.text = "Edad: " + usuario.getEdad().toString()
            correoUsuario.text = "Estado: " + usuario.getCorreo()
            activoUsuario.text = "Activo: " + usuario.getActivo().toString()
        }

        private fun abrirActualizaUsuarioActivity(usuario: Usuario) {
            val intent = Intent(context, ActualizarUsuarioActivity::class.java)
            intent.putExtra("usuario", usuario)
            context.startActivity(intent)
        }
    }

}