# AutoBranding Generator

Aplicación para generar brandings automáticos para múltiples clientes con configuraciones personalizadas (logos, colores, etc.). Esta herramienta facilita la creación de configuraciones específicas para cada cliente, como su logo, paleta de colores y más, sin necesidad de hacerlo manualmente.

## Configuración:

### 1. Crear una carpeta para la nueva app

En el directorio raíz donde se generará el nuevo branding, crea una carpeta con el nombre de la nueva aplicación. Por ejemplo:
`/root/Prueba`

### 2. Configurar el archivo `$appName.xcconfig`

Debes proporcionar un archivo `$appName.xcconfig` que contenga los parámetros de configuración específicos del cliente, como colores, logos, nombres de app, etc. Este archivo será usado para personalizar la app según las preferencias del cliente.

### 3. Crear el archivo `$appName.yml`

El archivo `$appName.yml` debe contener el workflow de Bitrise para la integración continua. No hay que añadir los steps, ya que estos se añadirán automáticamente.

## Uso

Una vez tengamos la configuración terminada, podemos proceder a lanzar el generador de branding de las siguientes formas:

### Opción 1: Ejecutar desde el repositorio

Para ejecutar el generador de branding directamente desde el repositorio, utiliza el siguiente comando:

```bash
swift run BrandingCreator create $appName
```

Este comando generará el branding de la app para el cliente. Asegúrate de tener el archivo de configuración adecuado (xcconfig y bitrise.yml) en el directorio correspondiente antes de ejecutar el comando.

### Opción 2: Instalar mediante Mint

También puedes instalar la herramienta usando Mint, un gestor de dependencias para herramientas de línea de comandos en Swift. Para instalar la herramienta con Mint, ejecuta el siguiente comando:

```bash
mint install Odilo-Namek/OdiloRebrand
```

Una vez instalada la herramienta, puedes usar este comando para generar el branding de tu aplicación:

```bash
BrandingCreator create $appName
```

### Autenticación en Firebase

Al ejecutar el comando, se abrirá un navegador para que inicies sesión en tu cuenta de Firebase. Esto es necesario para vincular la aplicación con Crashlytics. Asegúrate de completar el proceso de autenticación para permitir la integración con los servicios de Firebase y Crashlytics.

Una vez que hayas iniciado sesión correctamente, la app se conectará automáticamente a Crashlytics, lo que te permitirá realizar un seguimiento de los errores y otros problemas en la aplicación.

## Pasos manuales:

Una vez que la configuración esté completa y la app esté generada, recuerda realizar las siguientes acciones manuales:

- **Añadir manualmente el `appItunesID`** una vez que la ficha esté creada en el AppStoreConnect.
- **Añadir manualmente el archivo P8** una vez que haya terminado el proceso tenemos que annadir el archivo P8 para las notificaciones en Firebase.
- **Subir las imágenes** a la tienda manualmente.
- **Provocar el crash** para que se conecte con Crashlytics.
- **Añadir el deeplinking** al repositorio de Orion.
