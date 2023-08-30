package cr.ac.una.examenmovil

import android.app.DatePickerDialog
import android.content.Intent
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.view.View
import android.widget.Button
import android.widget.EditText
import android.widget.Toast
import com.android.volley.RequestQueue
import com.android.volley.Response
import com.android.volley.toolbox.StringRequest
import com.android.volley.toolbox.Volley
import cr.ac.una.examenmovil.Data.UsuarioData
import cr.ac.una.examenmovil.Domain.Usuario
import java.text.SimpleDateFormat
import java.util.Calendar
import java.util.Locale

class ActualizarUsuarioActivity : AppCompatActivity() {

    private val usuarioDb = UsuarioData()
    private lateinit var requestQueue: RequestQueue
    private lateinit var editDescripcion: EditText
    private lateinit var editFecha: EditText
    private lateinit var editEdad: EditText
    private lateinit var editCorreo: EditText
    private lateinit var editActivo: EditText
    private lateinit var btnGuardar: Button

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_actualizar_usuario)
        requestQueue = Volley.newRequestQueue(this)
        editDescripcion = findViewById(R.id.edit_descripcion)
        editFecha = findViewById(R.id.edit_fecha)
        editEdad = findViewById(R.id.edit_edad)
        editCorreo = findViewById(R.id.edit_correo)
        editActivo = findViewById(R.id.edit_activo)
        btnGuardar = findViewById(R.id.btn_guardar)

        val usuario = intent.getSerializableExtra("usuario") as? Usuario
        if (usuario != null) {
            // Mostrar la información del objeto en los inputs
            editDescripcion.setText(usuario.getDescripcion())
            editFecha.setText(usuario.getFecha().toString())
            editEdad.setText(usuario.getEdad().toString())
            editCorreo.setText((usuario.getCorreo()))
            editActivo.setText(usuario.getActivo().toString())
        }
        editFecha.setOnClickListener {
            mostrarDatePickerDialog()
        }
        btnGuardar.setOnClickListener {
            // Obtener los valores de los inputs
            val descripcion = editDescripcion.text.toString()
            val fecha = editFecha.text.toString()
            val edad = editEdad.text.toString().toInt()
            val correo = editCorreo.text.toString()
            val activo = editActivo.text.toString().toInt()


            // Validar campos vacíos
            if (descripcion.isBlank() || correo.isBlank() || editEdad.text.toString().isBlank() || editActivo.text.toString().isBlank() ) {
                Toast.makeText(this, "Todos los campos deben estar llenos", Toast.LENGTH_SHORT).show()
            } else {// Actualizar los datos en el backend usando Volley o Retrofit
                val request = object : StringRequest(
                    Method.GET,
                    usuarioDb.getActualizarValue() + "id=${usuario?.getId()}&nombre=$descripcion&fecha=$fecha&edad=$edad&correo=$correo&activo=$activo",
                    Response.Listener<String> { response ->
                        Toast.makeText(this, "La actualización se realizó con éxito", Toast.LENGTH_SHORT).show()
                        val intent = Intent(this, ListarUsuariosActivity::class.java)
                        startActivity(intent)
                    },
                    Response.ErrorListener { error ->
                        // Manejar el error de la solicitud
                        Toast.makeText(this, "Error al actualizar los datos", Toast.LENGTH_SHORT).show()
                    }
                ) {
                    override fun getHeaders(): MutableMap<String, String> {
                        val headers = HashMap<String, String>()
                        headers["Content-Type"] = "application/json"
                        return headers
                    }
                }
                requestQueue.add(request)
            }
        }
    }

    private fun mostrarDatePickerDialog() {
        // Obtener la fecha actual
        val calendario = Calendar.getInstance()
        val anio = calendario.get(Calendar.YEAR)
        val mes = calendario.get(Calendar.MONTH)
        val dia = calendario.get(Calendar.DAY_OF_MONTH)

        // Crear y mostrar el DatePickerDialog
        val datePickerDialog = DatePickerDialog(this, { view, year, month, dayOfMonth ->
            // Obtener la fecha seleccionada en el DatePickerDialog
            val fechaSeleccionada = Calendar.getInstance()
            fechaSeleccionada.set(year, month, dayOfMonth)

            // Formatear la fecha seleccionada como texto
            val formatoFecha = SimpleDateFormat("yyyy/MM/dd", Locale.getDefault())
            val fechaTexto = formatoFecha.format(fechaSeleccionada.time)

            // Establecer el texto de la fecha seleccionada en el EditText
            editFecha.setText(fechaTexto)
        }, anio, mes, dia)
        datePickerDialog.show()
    }

    fun volverInicio(view: View?) {
        val intent = Intent(view?.context, MainActivity::class.java)
        view?.context?.startActivity(intent)
    }
}