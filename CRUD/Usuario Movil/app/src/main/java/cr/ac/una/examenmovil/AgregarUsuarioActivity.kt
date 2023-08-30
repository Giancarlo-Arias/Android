package cr.ac.una.examenmovil

import android.app.DatePickerDialog
import android.content.Intent
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.util.Log
import android.view.View
import android.widget.Button
import android.widget.EditText
import android.widget.Toast
import com.android.volley.RequestQueue
import com.android.volley.Response
import com.android.volley.VolleyError
import com.android.volley.toolbox.StringRequest
import com.android.volley.toolbox.Volley
import cr.ac.una.examenmovil.Data.UsuarioData
import org.json.JSONException
import org.json.JSONObject
import java.text.SimpleDateFormat
import java.util.Calendar
import java.util.Date
import java.util.HashMap
import java.util.Locale

class AgregarUsuarioActivity : AppCompatActivity(), Response.Listener<String>, Response.ErrorListener {
    val usuarioDB = UsuarioData()
    private lateinit var requestQueue: RequestQueue
    private lateinit var descripcionEditText: EditText
    private lateinit var fechaButton: Button
    private lateinit var edadEditText: EditText
    private lateinit var correoEditText: EditText
    private var selectedDate: Date? = null


    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_agregar_usuario)
        requestQueue = Volley.newRequestQueue(this)
        descripcionEditText = findViewById(R.id.descripcionEditText)
        fechaButton = findViewById(R.id.fechaButton)
        edadEditText = findViewById(R.id.edadEditText)
        correoEditText = findViewById(R.id.correoEditText)

        fechaButton.setOnClickListener { showDatePickerDialog() }
    }

    private fun showDatePickerDialog() {
        val calendar = Calendar.getInstance()
        val datePickerDialog = DatePickerDialog(
            this,
            { _, year, month, dayOfMonth ->
                val selectedCalendar = Calendar.getInstance()
                selectedCalendar.set(year, month, dayOfMonth)
                selectedDate = selectedCalendar.time
                val formattedDate = SimpleDateFormat("yyyy-MM-dd", Locale.getDefault()).format(selectedDate!!)
                fechaButton.text = formattedDate
            },
            calendar.get(Calendar.YEAR),
            calendar.get(Calendar.MONTH),
            calendar.get(Calendar.DAY_OF_MONTH)
        )
        datePickerDialog.show()
    }

    fun agregarUsuario(view: View) {
        val descripcion = descripcionEditText.text.toString()
        val fecha = selectedDate?.let { SimpleDateFormat("yyyy-MM-dd", Locale.getDefault()).format(it) } ?: ""
        val edad = edadEditText.text.toString().toInt()
        val correo = correoEditText.text.toString()
        val activo = 1
        var isFieldsValid = true

        if (descripcion.isEmpty()) {
            isFieldsValid = false
            Toast.makeText(this, "Falta nombre", Toast.LENGTH_SHORT).show()
        }

        if (fecha.isEmpty()) {
            isFieldsValid = false
            Toast.makeText(this, "Seleccione una fecha", Toast.LENGTH_SHORT).show()

        }

        if (edadEditText.text.isEmpty()) {
            isFieldsValid = false
            Toast.makeText(this, "Falta edad", Toast.LENGTH_SHORT).show()
        }

        if (correo.isEmpty()) {
            isFieldsValid = false
            Toast.makeText(this, "Falta correo", Toast.LENGTH_SHORT).show()
        }



        if (isFieldsValid) {
            val request = object : StringRequest(
                Method.GET,
                usuarioDB.getInsertarURLValue() + "nombre=$descripcion&fecha=$fecha&edad=$edad&correo=$correo&activo=$activo",
                Response.Listener<String> { response ->
                    Toast.makeText(this, "La inserción se realizó con éxito", Toast.LENGTH_SHORT).show()
                    descripcionEditText.setText("")
                    fechaButton.text = ""
                    edadEditText.setText("")
                    correoEditText.setText("")
                },
                Response.ErrorListener { error ->
                    Toast.makeText(this, "Error al insertar los datos", Toast.LENGTH_SHORT).show()
                }
            ) {
                override fun getHeaders(): MutableMap<String, String> {
                    val headers = HashMap<String, String>()
                    headers["Content-Type"] = "application/json"
                    return headers
                }
            }
            requestQueue.add(request)
        } else {
            Toast.makeText(this, "Por favor, complete todos los campos", Toast.LENGTH_SHORT).show()
        }
    }

    override fun onResponse(response: String?) {
        try {
            val jsonObject = JSONObject(response)
            val statusArray = jsonObject.getJSONArray("status")
            val status = statusArray.getJSONObject(0).getString("status")
            val message = statusArray.getJSONObject(0).getString("message")
            if (status == "success") {
                Toast.makeText(this, message, Toast.LENGTH_SHORT).show()
                // Restablecer los campos de entrada
                descripcionEditText.setText("")
                fechaButton.text = ""
                edadEditText.setText("")
                correoEditText.setText("")
                val intent = Intent(this, MainActivity::class.java)
                startActivity(intent)
            } else {
                Toast.makeText(this, message, Toast.LENGTH_SHORT).show()
            }
        } catch (e: JSONException) {
            e.printStackTrace()
        }
    }

    override fun onErrorResponse(error: VolleyError) {
        Toast.makeText(this, "Error al agregar usuario", Toast.LENGTH_SHORT).show()
        Log.e("AgregarUsuario", "Error: " + error.message)
    }

    fun volverInicio(view: View?) {
        val intent = Intent(view?.context, MainActivity::class.java)
        view?.context?.startActivity(intent)
    }
}