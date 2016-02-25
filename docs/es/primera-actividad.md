
#Creando nuestra primera actividad

¿Cómo crear nuestra propia actividad de evaluación en cuatro pasos?

##PASO 1
Creamos un fichero vacío con permisos de ejecución. Incluimos una referencia
a nuestra herramienta (`lib/tool.rb`).
```
    require_relative '../../lib/tool'
```

Este fichero puede llamarse, por ejemplo, `./check/demos/my_demo.rb`.

##PASO 2
Segundo, escribimos los test usando las palabras del DSL: `desc`, `goto` y `expect`.
Veamos un ejemplo:

```
check :existe_userio_david do

	desc "Existe el usuario <david>"
	goto :host1, :execute => "id david |wc -l"
	expect result.equal?(1)

end
```

El ejemplo anterior comproueba que exista el usuario *david* en la máquina *host1*.

Veamos lo que significan estas palabras del DSL:
* `desc "Existe el usuario <david>"`, Define un texto que describe el objetivo
que vamos a comprobar con nuestras propias palabras. De esta forma cuando
leamos el informe nos será más sencillo de interpretar los resultados.
* `goto :host1, :execute => "id david|wc -l"`: Ejecuta el comando especificado
dentro de la máquina *host1*. La conexión con la máquina remota se hace usando 
SSH. 
* `expect result.equal?(1)`: Después de ejecutar el comando necesitamos
comprobar si el resultado obtenido coincide con el valor esperado.

##PASO 3
Al final del script escribimos las siguientes líneas:
```
start do
  show
  export
end
```
Estas instrucciones sirven para lo siguiente:
* `start`: Es la orden para iniciar el proceso de evaluación de cada caso.
* `show`: Indica que se muestre en pantalla mensajes con indicación de las acciones
que se van realizando.
* `export`: Indica que debemos crear informes con los resultados de los test.
Estos informes se crearán con los valores por defecto (Por defecto el formato 
de salida es txt).

##PASO 4
Como paso final, necesitamos un fichero de configuración (En formato YAML).
Este fichero define los parámetros y configuraciones de los hosts usados
por nuestro script. Veamos:

```
---
:global:
  :host1_username: root
:cases:
- :tt_members: Estudiante1
  :tt_emails: estudiante1@correo.es
  :host1_ip: 1.1.1.1
  :host1_password: clave-root-para-estudiante1
- :tt_members: Estudiante2
  :tt_emails: estudiante2@correo.es
  :host1_ip: 2.2.2.2
  :host1_password: clave-root-para-estudiante2
```
El fichero de configuración anterior configura 2 casos con sus propios parámetros.
El script usa esta información cuando ejecuta cada caso.