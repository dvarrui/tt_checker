
[Ejemplo anterior](./example-02.md) | [Listado de Ejemplos](./ejemplos.md) | Ejemplo siguiente

##example-03

```
    En este ejemplo, vamos necesitar varias másquinas: la del profesore y varias de estudiantes.
    Las másquinas de los estudiantes tienen el contenido que va a ser evaluado.
    La máquinas del profesor tiene el script que evalua el grado de cumplimiento de los objetivos de las diferetnes máquinas de los estudiantes.
    Usaremos el fichero de configuración para definir las diferentes máquinas remotas.
    Usaremos SSH como vía de comunicación entre las máquinas.
```

* Script: [example-03.rb](../examples/example-03.rb) 
* Fichero de configuración: [example-03.yaml](../examples/example-03.yaml)
* Descripción: Evalua varios casos entrando en *máquinas remotas*.
* Requisitos: En este ejemplo se ejecutan comandos de GNU/Linux en las *máquinas remotas*.
*localhost* puede ser cualquier otro sistema operativo.

##Script

En este ejemplo, debemos fijarnos que las instrucciones `goto` no se ejecuta en localhost,
porque se ha especificado `goto :host1, ...`. De modo, que se ejecutarán dentro
la máquina `host1` (Ya veremos quien es).

Supondremos que en nuestro ejemplo cada alumno/grupo tendrá una máquina que llamaremos
por ejemplo `host1`. Podemos usar el nombre que queramos para nombrar las máquinas.

Para podernos conectar con las máquinas remotas, éstas deben tener instalado el servicio SSH.
Además la máquina donde ejecutamos el script debe tener instalado el cliente SSH.

##Fichero de configuración

En este ejemplo, el fichero de configuración contiene una variable global
`:host1_username` con el valor `root`. Esto quiere decir que en todos los casos
cuando se establezca la conexión SSH desde el equipo del profesor al `host1` del alumno,
se usará como usuario de la conexión el valor `root` en todos los casos. Esto no siempre
tiene que ser así, pero ahora en nuestro ejemplo nos vale.

Además el fichero de configuración tiene definidos más parámetros en cada caso.
Estos son:
* `host1_ip`: define la IP de host1 par ese caso. Lógicamente cada máquina de cada caso
deberá tener una iP diferente para poder conectarnos correctamente
* `host1_password`: cada caso tiene definida una clave deferente en cada máquina para
el usuario que usaremos en la conexión SSH (En nuetro caso dijimos que sería `root`).
Todos las máquinas podrían tener la misma clave para el usuario `root` pero... no.
Eso no está bien.
* `host1_hostname`: Es el FQDN del equipo host1 en cada caso. Cada caso tendrá
una personalización de la máquina `host1` diferente.
* `username`: Será el nombre de un usuario que cada alumno/grupo debe tener
creado dentro de su `host1`.

Notice that host1 it is diferent machine depending every case. So we can define
diferents machines for every student. But in our activity script,we call it with the
same name (host1).



En el ejemplo anterior (`example-01`) vimos que tenía el objetivo de
comprobar la existencia de un usuario concreto. Si queremos comprobar 
un nombre de usuario diferente, tendríamos que modificar el script de 
evaluación... Pero ¿y si sacamos los parámetros que pueden cambiar 
de la prueba, a un fichero de configuración externo? ¿Mejor? ¿verdad?

En este ejemplo vamos a poner los nombres de usuarios a comprobar (objetivos)
en el fichero de configuración, y para leer dichos valores desde el script usaremos
la instrucción *get* del DSL (Consultar [example-02.rb](../examples/example-02.rb)).

##Fichero de configuración

Vemos que en el script hay una nueva intrucción:
* **get**: Lee el valor del parámetro indicado, del contenido del fichero 
de configuración. Para cada caso podrá ser diferente. Las acciones de 
comprobación toman el valor configurado para cada caso del fichero 
de configuración, y de esta forma cada caso se evalúa con diferentes valores.
* *get* intenta primero leer el valor solicitado en la configuración del caso,
y si no lo encuentra lo intenta leer de la configuración global. De esta forma
podemos tenemos parámetros específicos para cada caso, o comunes para todos
ellos.

En este ejemplo no tenemos definidas variables globales de configuración.
Para cada caso se definen los parámetros siguientes: `tt_members`, `tt_emails` 
y `username`.
* **username**: Este parámetro tiene diferente valor para cada caso, de modo
que cuando se ejecuta la accción de comprobación, ésta será diferente en cada
caso.
* Consulta el fichero de configuración de este ejemplo.

##Ejecución del script
Ejecutamos el script con `./docs/examples/example-03.rb` y vemos la siguiente salida por pantalla:

```
=============================================
Executing [sysadmin-game] tests (version 0.5)
[INFO] Running in parallel (2016-02-21 12:14:14 +0000)
...!????.?
[INFO] Duration = 5.380654018 (2016-02-21 12:14:19 +0000)


=============================================
INITIAL CONFIGURATIONS
  tt_title: Executing [sysadmin-game] tests (version 0.5)
  tt_scriptname: ./docs/examples/example-03.rb
  tt_configfile: ./docs/examples/example-03.yaml
  host1_username: root
  host1_password: profesor
  tt_testname: example-03
  tt_sequence: false
TARGETS HISTORY
  -  Case_01 =>   0 ? darth-maul
  -  Case_02 =>  33 ? r2d2
  -  Case_03 => 100   obiwan kenobi
FINAL VALUES
  start_time: 2016-02-21 12:14:14 +0000
  finish_time: 2016-02-21 12:14:19 +0000
  duration: 5.380654018
```

Aquí lo más importante es ver en TARGETS HISTORY el resumen de todos los casos analizados
con su evaluación final. En este ejemplo, tenemos los siguientes 3 casos con distinta
puntuación final.

##Informes de salida

Para tener más información sobre cada caso, y averiguar lo que ha pasado
con cada uno para obtener las puntuaciones finales, debemos consultar 
los informes. Los informes se graban en `var/example-03/out`.

```
var/example-03/out/
├── case-01.txt
├── case-02.txt
├── case-03.txt
└── resume.txt
```

###Informe de salida para `case-01`

Veamos el informe del caso 01, consultando el fichero `var/example-03/out/case-01.txt`.

```
INITIAL CONFIGURATIONS
+----------------+----------------------+
| tt_members     | darth-maul           |
| tt_emails      | darth-maul@email.com |
| tt_skip        | false                |
| host1_ip       | 192.168.1.108        |
| host1_hostname | sith.starwars        |
| username       | dmaul                |
+----------------+----------------------+
TARGETS HISTORY
  - INFO: Begin host_configuration
  - ERROR: Host 192.168.1.108 unreachable!
  01 (0.0/1.0)
  		Description : Hostname is <sith.starwars>
  		Command     : hostname -f
  		Expected    : sith.starwars
  		Result      : 
  02 (0.0/1.0)
  		Description : DNS Server OK
  		Command     : host www.google.es| grep 'has address'| wc -l
  		Expected    : 1
  		Result      : 
  - INFO: End host_configuration
  - INFO: Begin user_configuration
  03 (0.0/1.0)
  		Description : Exist user <dmaul>
  		Command     : id dmaul |wc -l
  		Expected    : 1
  		Result      : 
  - INFO: End user_configuration
FINAL VALUES
+--------------+---------------------------+
| case_id      | 1                         |
| start_time_  | 2016-02-21 12:14:14 +0000 |
| finish_time  | 2016-02-21 12:14:17 +0000 |
| duration     | 3.010793217               |
| unique_fault | 0                         |
| max_weight   | 3.0                       |
| good_weight  | 0.0                       |
| fail_weight  | 3.0                       |
| fail_counter | 3                         |
| grade        | 0.0                       |
+--------------+---------------------------+
```

Se ha intentado evaluar los objetivos, y todos sin éxito, puesto que el valor
esperado no coincide con el valor obtenido.

Si nos fijamos veremos en la sección *TARGETS HISTORY* una línea de ERROR.
Esta línea con el mensaje nos dice que no ha sido posible establecer 
una conexión SSH con dicha IP. En nuestro ejemplo, la máquina estaba apagada.

Cuando no hay conexión, no se puede consultar el estado de los objetivos 
y por tanto la nota final será 0%.

Algunos de los motivos por los que puede no funcionar la conexión SSH a las máquinas remotas:
* La máquina remota está apagada.
* La máquina remota tiene mal configurada la red.
* La máquina remota no tiene instalado el servicio SSH.
* La máquina remota no tiene configurado el acceso SSH para nuestro usuario.
* El cortafuegos de la máquina remota y/o la máquina del profesor cortan las comunicaciones SSH.

###Informe de salida para `case-02`

Veamos el informe del caso 02, consultando el fichero `var/example-03/out/case-02.txt`.

```
INITIAL CONFIGURATIONS
+----------------+-----------------+
| tt_members     | r2d2            |
| tt_emails      | rd2d2@email.com |
| tt_skip        | false           |
| host1_ip       | 192.168.1.109   |
| host1_hostname | robot.starwars  |
| username       | r2d2            |
+----------------+-----------------+
TARGETS HISTORY
  - INFO: Begin host_configuration
  01 (0.0/1.0)
  		Description : Hostname is <robot.starwars>
  		Command     : hostname -f
  		Expected    : robot.starwars
  		Result      : curso1516.ies
  02 (1.0/1.0)
  		Description : DNS Server OK
  		Command     : host www.google.es| grep 'has address'| wc -l
  		Expected    : 1
  		Result      : 1
  - INFO: End host_configuration
  - INFO: Begin user_configuration
  03 (0.0/1.0)
  		Description : Exist user <r2d2>
  		Command     : id r2d2 |wc -l
  		Expected    : 1
  		Result      : id: r2d2: No existe ese usuario
  - INFO: End user_configuration
FINAL VALUES
+--------------+---------------------------+
| case_id      | 2                         |
| start_time_  | 2016-02-21 12:14:14 +0000 |
| finish_time  | 2016-02-21 12:14:19 +0000 |
| duration     | 5.365698817               |
| unique_fault | 0                         |
| max_weight   | 3.0                       |
| good_weight  | 1.0                       |
| fail_weight  | 2.0                       |
| fail_counter | 2                         |
| grade        | 33.33333333333333         |
+--------------+---------------------------+
```

En este caso, si hemos establecido una conexión SSH correcta con la máquina,
pero sólo se ha cumplido satisfactoriamente 1 de los 3 objetivos previstos.

###Informe de salida para `case-03`

Veamos el informe del caso 03, consultando el fichero `var/example-03/out/case-03.txt`.

```
INITIAL CONFIGURATIONS
+----------------+------------------+
| tt_members     | obiwan kenobi    |
| tt_emails      | obiwan@email.com |
| tt_skip        | false            |
| host1_ip       | 192.168.1.113    |
| host1_hostname | jedi.starwars    |
| username       | obiwan           |
+----------------+------------------+
TARGETS HISTORY
  - INFO: Begin host_configuration
  01 (1.0/1.0)
  		Description : Hostname is <jedi.starwars>
  		Command     : hostname -f
  		Expected    : jedi.starwars
  		Result      : jedi.starwars
  02 (1.0/1.0)
  		Description : DNS Server OK
  		Command     : host www.google.es| grep 'has address'| wc -l
  		Expected    : 1
  		Result      : 1
  - INFO: End host_configuration
  - INFO: Begin user_configuration
  03 (1.0/1.0)
  		Description : Exist user <obiwan>
  		Command     : id obiwan |wc -l
  		Expected    : 1
  		Result      : 1
  - INFO: End user_configuration
FINAL VALUES
+--------------+---------------------------+
| case_id      | 3                         |
| start_time_  | 2016-02-21 12:14:14 +0000 |
| finish_time  | 2016-02-21 12:14:15 +0000 |
| duration     | 1.177294342               |
| unique_fault | 0                         |
| max_weight   | 3.0                       |
| good_weight  | 3.0                       |
| fail_weight  | 0.0                       |
| fail_counter | 0                         |
| grade        | 100.0                     |
+--------------+---------------------------+
```

Comprobamos que todos los objetivos se han cumplido correctamente.


##Recordatorio

Si tenemos bien configurada la conexión SSH desde el profesor a las máquinas clientes la 
evaluación podrá realizarse adecuadamente.

Podemos tener tantos casos como queramos. El hecho de tener más alumnos/grupos que evaluar
no aumenta el tiempo de evaluación puesto que las evaluaciones de todos los casos se hacen
en paralelo usando técnicas de programación multihilo.

Como la evaluación termina al evaluar todos lo casos, lo que si puede pasar es que el proceso
se demore más de la cuenta al tener que esperar las másquinas rápidas por alguna que
sea más lenta.

En nuestro ejemplo cada alumno/grupo hacía uso de una máquina para realizar su trabajo.
Pero podemos realizar actividades más complejas donde cada alumno/grupo tiene una o varias
máquinas diferentes. Lo único a tener en cuenta es que hay que darles nombres y especificar
su configutración de IP, usuario, y clave en el fichero de configuración.