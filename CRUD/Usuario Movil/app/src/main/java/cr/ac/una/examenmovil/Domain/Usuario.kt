package cr.ac.una.examenmovil.Domain

import java.io.Serializable
import java.util.Date

class Usuario: Serializable {

    private var id: Int = 0
    private var descripcion: String = ""
    private var fecha: Date = Date()
    private var edad: Int = 0
    private var correo: String = ""
    private var activo: Int = 0

    constructor()

    constructor(
        id: Int,
        descripcion: String,
        fecha: Date,
        edad: Int,
        correo: String,
        activo: Int
    ) {
        this.id = id
        this.descripcion = descripcion
        this.fecha = fecha
        this.edad = edad
        this.correo = correo
        this.activo = activo
    }

    fun getId(): Int {
        return id
    }

    fun setId(id: Int) {
        this.id = id
    }

    fun getDescripcion(): String {
        return descripcion
    }

    fun setDescripcion(descripcion: String) {
        this.descripcion = descripcion
    }

    fun getFecha(): Date {
        return fecha
    }

    fun setFecha(fecha: Date) {
        this.fecha = fecha
    }

    fun getEdad(): Int {
        return edad
    }

    fun setEdad(edad: Int) {
        this.edad = edad
    }

    fun getCorreo(): String {
        return correo
    }

    fun setCorreo(correo: String) {
        this.correo = correo
    }

    fun getActivo(): Int {
        return activo
    }

    fun setActivo(Activo: Int) {
        this.activo = activo
    }
}