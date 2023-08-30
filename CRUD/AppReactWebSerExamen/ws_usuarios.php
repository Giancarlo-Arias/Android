<?php
header("Access-Control-Allow-Origin: *"); // No es recomendable dar acceso a todas las rutas (*), lo correcto es especificar las rutas permitidas

$host = "localhost";
$data_base = "dbexamenmoviles";
$user = "root";
$pass = "";

$json = array();

if (isset($_GET['listar']) && $_GET['listar'] == 'listarUsuarios') {
    $conexion = mysqli_connect($host, $user, $pass, $data_base);
    $query = "SELECT * FROM tb_usuario";
    $result = mysqli_query($conexion, $query);

    while ($row = mysqli_fetch_assoc($result)) {
        $json["usuarios"][] = $row;
    }

    mysqli_close($conexion);
    echo json_encode($json);
    // Ejemplo de URL para listar usuarios: http://192.168.100.251/AppReactWebSerExamen/ws_usuarios.php?listar=listarUsuarios
}

// Eliminar usuario
if (isset($_GET['eliminar']) && $_GET['eliminar'] == 'eliminarUsuario') {
    $id = $_GET['id'];
    $conexion = mysqli_connect($host, $user, $pass, $data_base);
    $query = "DELETE FROM tb_usuario WHERE id = $id";
    $result = mysqli_query($conexion, $query);
    mysqli_close($conexion);
    // Ejemplo de URL para eliminar usuario: http://192.168.100.251/AppReactWebSer/ws_usuarios.php?eliminar=eliminarUsuario&id=1
}

// Insertar usuario
if (isset($_GET['insertar']) && $_GET['insertar'] == 'insertarUsuario') {
    if (isset($_GET["nombre"]) && isset($_GET["edad"]) && isset($_GET["fecha"]) && isset($_GET["activo"]) && isset($_GET["correo"])) {
        $nombre = $_GET["nombre"];
        $edad = $_GET["edad"];
        $fecha = $_GET["fecha"];
        $activo = $_GET["activo"];
        $correo = $_GET["correo"];

        $conexion = mysqli_connect($host, $user, $pass, $data_base);
        $insert = "INSERT INTO tb_usuario (nombre, edad, fecha, activo, correo) VALUES ('$nombre', '$edad', '$fecha', '$activo', '$correo')";
        $result = mysqli_query($conexion, $insert);

        mysqli_close($conexion);
        // Ejemplo de URL para insertar usuario: http://192.168.100.251/AppReactWebSerExamen/ws_usuarios.php?insertar=insertarUsuario&nombre=John&edad=25&fecha=2023-06-01&activo=1&correo=john@example.com
    }
}

// Modificar usuario
if (isset($_GET['modificar']) && $_GET['modificar'] == 'modificarUsuario') {
    if (isset($_GET["id"]) && isset($_GET["nombre"]) && isset($_GET["edad"]) && isset($_GET["fecha"]) && isset($_GET["activo"]) && isset($_GET["correo"])) {
        $id = $_GET["id"];
        $nombre = $_GET["nombre"];
        $edad = $_GET["edad"];
        $fecha = $_GET["fecha"];
        $activo = $_GET["activo"];
        $correo = $_GET["correo"];

        $conexion = mysqli_connect($host, $user, $pass, $data_base);
        $queryUpdate = "UPDATE tb_usuario SET nombre = '$nombre', edad = '$edad', fecha = '$fecha', activo = '$activo', correo = '$correo' WHERE id = '$id'";
        $result = mysqli_query($conexion, $queryUpdate);

        mysqli_close($conexion);                 //http://192.168.100.251/AppReactWebSerExamen/ws_usuarios.php?listar=listarUsuarios
        // Ejemplo de URL para modificar usuario: http://192.168.100.251/AppReactWebSerExamen/ws_usuarios.php?modificar=modificarUsuario&id=1&nombre=John1&edad=30&fecha=2023-06-10&activo=1&correo=john@example.com
    }
}
