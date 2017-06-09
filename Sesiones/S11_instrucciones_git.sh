################################################
## Configuración global al inicio             ##
################################################
git config --global user.name "Carlos Vergara-Hernández" # Nombre de usuario
git config --global user.email carlos.vergara@uv.es # Correo electrónico del usuario
git config --global core.editor atom # emacs atom notepad ...
git config --list # Consultar las opciones de configurción

################################################
## Primeros pasos                             ##
################################################
mkdir curso
cd curso
git init # Inicia un repositorio git en el directorio donde se esté
git status # Así se puede ver qué está pasando en el repositorio: archivos sin seguimiento, los que estaban en un commit previo y han sido modificados... cualquier cosa.
echo 'Esto es un ejemplo de git' >> README.md
git status
git add . # Añade todos los archivos del directorio (y subdirectorios) a la zona de commit.
# 'git commit': Se abre el editor para escribir el mensaje de commit y ejecutarlo sobre los archivos que están en este momento en la zona de commit.
git commit -m 'Primer commit: con la opción -m se puede escribir el mensaje junto al comando, sin necesidad de abrir un editor.'
git log # Muestra información sobre el historial del repositorio.
git rm --cached README.md # Elimina los archivos de la zona de commit.
git status # README.md aparece sin seguimiento, gracias a 'git rm --cached' que hicimos antes.
git log # Pero no ha eliminado el commit: el resto de archivos se conservan, en este caso únicamente este documento.
mkdir dir1 && cp README.md dir1/README.md # Comando BASH para crear un nuevo directorio y copiar el archivo dentro de él.
git add '*.md' # Añade todos los archivos que coincidan con el patrón '.md' a la zona de commit.
git commit -m 'Segundo commit: añado copia de documento en dir1.'
git status
echo 'Una nueva línea en _el archivo_' >> README.md
git status
git diff # ¿Qué cambios ha habido en los archivos que estaban en el último commit?
git commit -a -m 'Tercer commit: con la instrucción "-a -m" se puede añadir el archivo al siguiente commit y hacerlo inmediatamente después, especificando un mensaje (como este).' # No obstante, el archivo debe estar en seguimiento por git, es decir, en algún momento previo debió hacerse un 'git add archivo' o 'git add .' existiendo este archivo. Implicaciones: si el archivo es nuevo, hay que trabajar de la forma habitual 'git add . && git commit -m "commit que incorpora el nuevo archivo"'.
git status
echo 'Creo un nuevo archivo cuyo nombre será---> "nuevo_doc.txt"' >> nuevo_doc.txt
git status
git add . && git commit -m 'Cuarto commit: se incorpora nuevo_doc.txt'
git status
git tag "v0.0.1" # en cualquier momento podemos asociar una etiqueta con un commit. Esto es muy útil en el desarrollo de proyectos de software, como pueden ser paquetes de R, de forma que tenemos un control claro de la versión del mismo.
git tag # Así podemos ver el historial de etiquetas (versiones, según el uso que aquí le hemos dado).

################################################
## Deshaciendo cosas                          ##
################################################

git status && git log # Vemos el historial de commit: hasta ahora, cuatro commits.
git reset HEAD~1 # Volvemos un commit atrás!!!! Usar con precaución...
git log # Vemos que se ha borrado el último commit!!!
git add . && git commit -m 'Cuarto commit: se incorpora nuevo_doc.txt' # Añadimos de nuevo el documento...
git status
echo 'Modifo este archivo añadiendo una nueva línea...' >> nuevo_doc.txt
git status # Aparece un archivo para añadir...
git checkout -- nuevo_doc.txt # Este comando hace que el archivo vuelva a la versión que está almacenada en el último commit, es decir, se perderá el texto que acabamos de añadir y, por lo tanto, al ver el estado de git comprobaremos que no hay nada añadido!!!! Nuevamente, usar con precaución...
git status # El archivo ha desparecido:

################################################
## Mover o renombrar archivos con git         ##
################################################
ls -a
git mv nuevo_doc.txt nuevo_doc_renombrado.txt  # Así se renombra el archivo
ls -a && git status # Comprobamos el resultado...
git mv nuevo_doc_renombrado.txt dir1/nuevo_doc_renombrado.txt  # Así se mueve el archivo a dir1
ls -a && git status # Comprobamos el resultado...
git commit -m 'Quinto commit: cambio de nombre de archivo'

################################################
## Trabajo con ramas                          ##
################################################

git branch # Este comando nos muestra las ramas que existen e indica con un asterisco en cuál estamos. En este caso, estamos en 'master', la rama principal que se crea por defecto y vemos que no hay ninguna rama más.
git branch nueva_rama # Al indicarle texto tras el comando 'git branch', crea una nueva rama con ese nombre.
git branch # Ahora hay dos ramas: 'master', la principal y en la que estamos, y 'nueva_rama', que ahora mismo es una copia idéntica a 'master'.
git branch -v # Como curiosidad, podemos indicar con '-v' que nos muestre el último commit de cada rama, aunque en este caso nos muestra el mismo commit para ambas ramas: tiene sentido, pues en realidad acabamos de crear la nueva rama y ahora mismo no es más que una copia de 'master'.
git checkout nueva_rama # Con 'git checkout NOMBRE_DE_RAMA' cambiamos a una rama distinta.
git branch # Comprobamos que, efectivamente, hemos cambiado de rama.
echo 'Creamos un archivo en la nueva rama' >> nuevo_doc_en_nueva_rama.txt
git add . && git commit -m 'Primer commit en nueva rama: se incorpora nuevo_doc_en_nueva_rama.txt' # Añadimos el documento...
git status
git checkout master # Se vuelve a la rama 'master'.
echo 'Creamos un archivo en la rama master' >> archivo_tras_crear_otra_rama.txt
git add . && git commit -m 'Sexto commit: se incorpora archivo_tras_crear_otra_rama.txt' # Añadimos el documento...
git status
git log --oneline --decorate --graph --all # Con esta instrucción le pedimos a git que nos muestre, de forma resumida y añadiendo un gráfico, los commits efectuados en todas las ramas. En el resultado devuelto, cada asterisco a la izquierda representa un commit y va asociado con un mensaje. Si nos fijamos en el quinto commit, vemos que ocurre una escisión, se crea la nueva rama y se realiza el primer commit en ella. También podemos ver cómo del quinto commit la rama máster se dirige al sexto commit, el cual refleja el trabajo que se realizó al cambiar de rama nuevamente.
git merge nueva_rama -m "Uno dos ramas" # Estando en la rama 'master', podemos añadir el trabajo que se realizó en la nueva_rama con esta instrucción. En primer lugar, el comando busca posibles conflictos, aunque dado que la rama master solo se diferencia de nueva_rama en que carece del archivo nuevo_doc_en_nueva_rama.txt, en este caso no hay conflicto alguno, de modo el archivo faltante se incorpora, sin más.
git log --oneline --decorate --graph --all # Ahora podemos ver cómo se unen las ramas gráficamente, así como el mensaje de unión (merge).
git checkout nueva_rama # Vamos a generar una situación asociada a un conflicto. Para ello, vamos a la nueva rama y modificamos el archivo que antes incorporamos.
echo 'Añadimos una segunda línea en el archivo de la nueva rama desde ella' >> nuevo_doc_en_nueva_rama.txt
git add . && git commit -m 'Segundo commit en nueva rama: se incorpora una línea en el archivo nuevo_doc_en_nueva_rama.txt para generar un conflicto con la rama "master".'
git checkout master # Se vuelve a la rama 'master'.
echo 'Añadimos una tercera línea en el archivo de la nueva rama desde la rama "master"' >> nuevo_doc_en_nueva_rama.txt # Hay que tener en cuenta que el nombre del archivo no ha sufrido modificación alguna...
git add . && git commit -m 'Septimo commit: se incorpora una linea nuevo_doc_en_nueva_rama.txt desde la rama "master"'
git log --oneline --decorate --graph --all # Vemos que el gráfico ha variado, reflejando la nueva actividad. Si ahora intentamos unir ambas ramas...
git merge nueva_rama # CONFLICTO!!!! git ya no puede incorporar el contenido de forma automática en la rama 'master', ya que se ha editado el contenido del mismo documento desde ambas ramas... ¿con qué habría de quedarse: la línea incorporada desde nueva_rama, la que se añadió desde master, o con ambas? Para solucionar la papeleta, veamos qué nos sugiere 'git status'...
git status # Nos dice que para continuar con la unión de ambas ramas, primero hay que solucionar el conflicto y, después, lanzar 'git commit -a -m "mensaje..."', de modo que vamos a hacerlo así. Para ello abrimos el archivo conflictivo desde la rama master, y veremos que ahora incorpora algunas cosas interesantes.
atom nuevo_doc_en_nueva_rama.txt # SORPRESA!!! El documento guarda las líneas que se introdujeron en ambas ramas: lo que procede de la rama 'master' viene precedido por "<<<<<<< HEAD", después hay una separación marcada por una línea con el contenido "=======", tras lo que aparece el contenido de nueva_rama y, para acabar, se indica que, efectivamente, esa es su procedencia (">>>>>>> nueva_rama"). En este caso, nos interesa quedarnos con las dos líneas y que, además, estén en orden, así que borramos las señalizaciones que introdujo git y colocamos la línea que reza "Añadimos una segunda línea en el archivo de la nueva rama desde ella" como segunda línea, seguida por la línea que dice 'Añadimos una tercera línea en el archivo de la nueva rama desde la rama "master"'. Ahora realizamos esta operación a mano, es decir, modificamos el archivo copiando y pegando lo que nos interesa de una u otra rama, aunque hay aplicaciones específicas para solucionar estos conflictos de una forma más dinámica (por ejemplo, desde atom, con el plugin mergeconflicts, se puede clickar sobre las líneas que se quieren conservar o borrar...). Tras esta edición, guardamos el documento y hacemos, o bien 'git add nuevo_doc_en_nueva_rama.txt && git commit -m "mensaje"', o directamente 'git commit -a -m "mensaje"' (en mi caso haré esto último por comodidad).
git commit -a -m 'Octavo commit: uno ambas ramas resolviendo un conflicto!!' # Es el octavo commit porque, como recordarás, estamos en la rama 'master'.
git status # Todo parece en orden.
git log --oneline --decorate --graph --all # En el gráfico vemos que todo ha salido bien: somos los mejores!!!
git branch -v # Vemos la información de los últimos commits.
git checkout -b desarrollo # Empleando este comando ('git checkout -b NOMBRE_DE_NUEVA_RAMA'), git crea una nueva rama y, seguidamente, se mueve hacia ella.
git branch # Vemos que, efectivamente, todo ha salido según lo esperado.
git checkout master && git branch -d desarrollo # Como no vamos a utilizar esta rama, cambiamos a la rama 'master' y borramos la rama 'desarrollo' con la opción '-d'.

################################################
## Previo al trabajo con GitHub o un servidor ##
################################################

# A estas alturas ya debes tenr una cuenta en GitHub, el cual actúa como un servidor remoto donde almacenar tu repositorio.
# Para poder trabajar con un servidor, en primer lugar tenemos que pensar un momento en cómo se conectará nuestra máquina local con él. Hay dos opciones: o bien mediante http-https, de forma que cada vez que tratemos de comunicarnos con el servidor se nos pedirá un nombre de usuario y una contraseña; o bien mediante SSH con claves pública-privada, de forma que, añadiendo nuestra clave pública en el servidor, las máquinas se comunicarán sin problema y sin tener que identificarse a cada paso.
# Ambas opciones son válidas, aunque en mi caso, como soy muy vago, prefiero usar la conexión con SSH. Para ello, en primer lugar ejecuto un comando en la terminal y me aseguro de que el ordenador desde el que trabajo tiene instalado todo lo necesario:
ls ~/.ssh # Si aparece 'id_rsa  id_rsa.pub' todo funciona bien: tenemos una clave pública (id_rsa.pub) que añadir a GitHub. Si no aparece nada o el directorio ni siquiera existe, puede ser porque o bien no tenemos instalado un cliente o agente ssh (algo raro), o todavía no hemos generado un par de claves (pública-privada). Vamos a comprobar esto último, ya que es lo más probable (si hubiera que instalar el cliente-agente ssh, habría que buscar el programa apropiado para nuestro sistema operativo, aunque es algo bastante raro pues al instalar git este otro software suele instalarse como dependencia.
ssh-keygen -C 'carlos.vergara@uv.es' # Agiliza las cosas si ahora introducimos el correo electrónico con el que tenemos vinculada nuestra cuenta de GitHub, aunque no es imprescindible y podría lanzarse sencillamente 'ssh-keygen'. Si nos aparece un error, tendremos que instalarnos el software apropiado y repetir esta operación. Como parte de la generación de las claves ssh, se nos pedirá que elijamos un directorio donde almacenarlas: como el que nos propone no es algo descabellado (directorio oculto en HOME cuyo nombre es .ssh), apretamos intro. Después se nos indica que introduzcamos una contraseña paa las claves o que apretemos intro si queremos dejarla en blanco: nos decantamos por esta opción, así que apretamos intro dos veces. Tras esto, solo queda comunicar al agente ssh dónde tenemos nuestra clave pública.
ssh-add ~/.ssh/id_rsa
# Ahora copiamos el contenido del archivo ~/.ssh/id_rsa.pub, vamos a nuestra cuenta en GitHub, y en la configuración (Settings) de la cuenta veremos un apartado que indica 'SSH and GPG keys', vamos y hacemos click en 'New SSH key'. Le damos un nombre (por ejemplo, si trabajamos desde el ordenador portátil: 'mi_portatil'), y pegamos el contenido que habíamos copiado hace un momento. Ahora ya podemos comunicarnos con nuestra cuenta de GitHub siempre que queramos!!!

################################################
## Trabajo en complicidad con GitHub          ##
################################################

# Lo primero que vamos a hacer es crear un nuevo repositorio en GitHub con EXACTAMENTE el mismo nombre que nuestro repositorio actual (en esta guía, 'curso_fisabio').
git remote add origin git@github.com:carlosvergara/curso_fisabio.git # Con con el comando 'git remote add' le estamos indicando a nuestro repositorio local que puede comunicarse con el servidor, al cual le llamaremos 'origin' (podemos llamarlo como queramos), estando alojado en ese URL (IMPORTANTE: recuerda sustituir 'carlosvergara' por tu nombre de usuario en GitHub).
git remote -v # Con este comando comprobamos que, efectivamente, hemos añadido el servidor de forma correcta.
git push -u origin master # Este comando es muy importante: 'git push' le dice a git que suba TODO el contenido almacenado en el repositorio dentro de la rama 'master', al servidor 'origin', que en este caso está en GitHub.
git push -u origin nueva_rama # También subimos el contenido de nueva_rama. De forma que ahora disponemos de un respaldo completo de nuestro repositorio en GitHub.
echo 'Hacemos modificaciones de forma local en nuestro directorio...' >> README.md
git add . && git commit -m 'Noveno commit: modificaciones para probar el trabajo con GitHub'
git log
git fetch origin master # Este comando también es muy importante: 'git fetch' le dice a git que se descargue TODO el contenido almacenado en el repositorio del servidor (origin) dentro de la rama 'master'. De este modo, actualizamos nuestro repositorio local por si alguien hubiera actualizado el repositorio del servidor (este no es el caso, pues acabamos de crearlo... pero es una buena dinámica de trabajo, así que la incorporamos a nuestra rutina!).
git status # OJO AL MENSAJE: nos dice que nuestra rama ('master') local está a un commit de distancia de la rama 'master' en el servidor (en 'origin'), así que usaremos 'git push' para ponerlo todo al día.
git push -u origin master
git status # Ahora sí que sí: nuestro repositorio local está exactamente igual que el del servidor.

# Pero... ¿qué ocurriría si nuestro servidor tuviera nueva actividad que no estuviera reflejada en nuestro repositorio local? Pues en este caso tendríamos que descargarnos el nuevo material (fetch) y unirlo a nuestra rama (merge), aunque hay un atajo que será el que usaremos por defecto casi siempre y que, en la mayoría de los casos, sustituirá a la dinámica fetch-merge: git pull
git pull origin master # Este comando también es muy importante: 'git pull' le dice a git que se descargue TODO el contenido almacenado en el repositorio del servidor (origin) dentro de la rama 'master' (como hacía 'git fetch'), y trate de unirlo a nuestra rama local 'master' (como haría 'git merge'). # En este caso, nos dice que todo está actualizado.

################################################
## Descargar repos existentes de GitHub       ##
################################################

# Hasta ahora hemos estado trabajando en local durante un buen rato y, llegado el momento, hemos subido nuestros avances al servidor. Otra forma de trabajar, sobre todo cuando se trabaja en proyectos colaborativos o cuando se trabaja desde varios ordenadores (personal, trabajo, casa...), consiste en descargarse una copia de un repositorio de GitHub, o en el argot de git, clonar un repositorio.
cd ~/ # Nos movemos a nuestro directorio HOME.
git clone https://github.com/fisabio/fisabior # Este comando clona todo el contenido del repositorio 'fisabior', del usuario 'fisabio' (una organización, en este caso) dentro del directorio '~/fisabior'.
cd ~/fisabior
# Ahora podemos trabajar de forma local con nuestra copia del repositorio y, llegado el momento, proponer al dueño del repositorio que incorpore nuestras modificaciones. En lenguaje de git-GitHub, esto se conoce como un 'Pull Request', y es la forma más habitual de trabajar en equipo y manejar código.

################################################
## Próximos pasos                             ##
################################################

# Antes de trabajar con un proyecto, vamos a ver algunos ejemplos reales en GitHub para mostrar el auténtico potencial de esta herramienta.
