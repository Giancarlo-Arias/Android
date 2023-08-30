package cr.ac.una.examenmovil.Data

class UsuarioData {

    var insertarURL: String = "http://192.168.136.56:3000/insertarUsuario?"
    var eliminar: String = "http://192.168.136.56:3000/eliminarUsuario?"
    var actualizar: String = "http://192.168.136.56:3000/modificarUsuario?"
    var obtener: String = "http://192.168.136.56:3000/listarUsuarios"

    fun getInsertarURLValue(): String {
        return insertarURL
    }

    fun setInsertarURLValue(insertarURL: String) {
        this.insertarURL = insertarURL
    }

    fun getEliminarValue(): String {
        return eliminar
    }

    fun setEliminarValue(eliminar: String) {
        this.eliminar = eliminar
    }

    fun getActualizarValue(): String {
        return actualizar
    }

    fun setActualizarValue(actualizar: String) {
        this.actualizar = actualizar
    }

    fun getObtenerValue(): String {
        return obtener
    }

    fun setObtenerValue(obtener: String) {
        this.obtener = obtener
    }
}