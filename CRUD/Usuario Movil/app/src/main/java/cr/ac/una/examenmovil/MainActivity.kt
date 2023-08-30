package cr.ac.una.examenmovil

import android.content.Intent
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.view.View

class MainActivity : AppCompatActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)
    }

    fun listarUsuariosView(view: View?) {
        val intent = Intent(view?.context, ListarUsuariosActivity::class.java)
        view?.context?.startActivity(intent)
    }

    fun agregarUsuariosView(view: View?) {
        val intent = Intent(view?.context, AgregarUsuarioActivity::class.java)
        view?.context?.startActivity(intent)
    }
}