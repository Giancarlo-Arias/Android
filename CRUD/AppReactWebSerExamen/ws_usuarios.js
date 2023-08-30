const express = require('express');
const app = express();
const mysql = require('mysql');
const bodyParser = require('body-parser');

const connection = mysql.createConnection({
  host: 'localhost',
  database: 'dbexamenmoviles',
  user: 'root',
  password: '',
});

connection.connect((err) => {
  if (err) throw err;
  console.log('Connected to the database');
});

app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());

app.use((req, res, next) => {
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE, OPTIONS');
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With');
  next();
});

app.options('*', (req, res) => {
  res.setHeader('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE, OPTIONS');
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With');
  res.sendStatus(200);
});

app.get('/listarUsuarios', (req, res) => {
  const query = 'SELECT * FROM tb_usuario';
  connection.query(query, (err, results) => {
    if (err) throw err;
    res.json({ usuarios: results });
  });
});
//http://192.168.100.251:3000/listarUsuarios
app.get('/eliminarUsuario', (req, res) => {
  const id = req.query.id;
  const query = `DELETE FROM tb_usuario WHERE id = ${id}`;
  connection.query(query, (err, results) => {
    if (err) throw err;
    res.send('Usuario eliminado');
  });
});

/*app.get('/insertarUsuario', (req, res) => {
  const { nombre, edad, fecha, activo, correo } = req.query;
  const query = `INSERT INTO tb_usuario (nombre, edad, fecha, activo, correo) VALUES ('${nombre}', '${edad}', '${fecha}', '${activo}', '${correo}')`;
  connection.query(query, (err, results) => {
    if (err) throw err;
    res.send('Usuario insertado');
  });
});*/
app.get('/insertarUsuario', (req, res) => {
  const { nombre, edad, fecha, activo, correo } = req.query;
  const query = 'INSERT INTO tb_usuario (nombre, edad, fecha, activo, correo) VALUES (?, ?, ?, ?, ?)';
  connection.query(query, [nombre, edad, fecha, activo, correo], (err, results) => {
    if (err) throw err;
    res.send('Usuario insertado');
  });
});

app.get('/modificarUsuario', (req, res) => {
  const { id, nombre, edad, fecha, activo, correo } = req.query;
  const query = `UPDATE tb_usuario SET nombre = '${nombre}', edad = '${edad}', fecha = '${fecha}', activo = '${activo}', correo = '${correo}' WHERE id = '${id}'`;
  connection.query(query, (err, results) => {
    if (err) throw err;
    res.send('Usuario modificado');
  });
});


//metodos xamarin

// Obtener todos los usuarios
app.get('/listUsuarios', (req, res) => {
  const sql = 'SELECT * FROM tb_usuario';
  connection.query(sql, (err, result) => {
    if (err) {
      throw err;
    }
    res.json(result);
  });
});
// Obtener un usuario por su ID
app.get('/usuarios/:id', (req, res) => {
  const id = req.params.id;
  const sql = `SELECT * FROM tb_usuario WHERE id = ${id}`;
  connection.query(sql, (err, result) => {
    if (err) {
      throw err;
    }
    res.json(result[0]);
  });
});

  // Agregar un nuevo usuario
  app.post('/add-usuario', (req, res) => {
    const { nombre, edad, fecha, activo, correo } = req.body;
    
    const sql = `INSERT INTO tb_usuario (nombre, edad, fecha, activo, correo) VALUES ('${nombre}', '${edad}', '${fecha}', '${activo}', '${correo}')`;
    connection.query(sql, (err, result) => {
      if (err) {
        throw err;
      }
      res.json({ message: 'Usuario agregado correctamente' });
    });
  });
  
  // Actualizar un usuario
  app.put('/usuarios/:id', (req, res) => {
    const id = req.params.id;
    const { nombre, edad, fecha, activo, correo } = req.body;
    const sql = `UPDATE tb_usuario SET nombre=?, edad=?, fecha=?, activo=?, correo=? WHERE id=?`;
    const values = [nombre, edad, fecha, activo, correo, id];
  
    connection.query(sql, values, (err, result) => {
      if (err) {
        console.error(err);
        res.status(500).json({ message: 'Error al actualizar el usuario' });
      } else {
        res.json({ message: 'Usuario actualizado correctamente' });
      }
    });
  });
  
  
  // Eliminar un usuario
  app.delete('/usuarios/:id', (req, res) => {
    const id = req.params.id;
    const sql = `DELETE FROM tb_usuario WHERE id = ${id}`;
    connection.query(sql, (err, result) => {
      if (err) {
        throw err;
      }
      res.json({ message: 'Usuario eliminado correctamente' });
    });
  });




app.listen(3000, () => {
  console.log('Server running on port 3000');
});
