# Crockgold Front

Frontend en Angular 22 de [crockgold_core](https://github.com/QuispeBrianGabriel/crockgold_core). Se trabaja dentro del Dev Container.

## Primeros pasos

1. En el host, preparar el repo (crea `docker/.env` desde `docker/.env.example`):

   ```bash
   make setup
   ```

2. Abrir la carpeta en VS Code y elegir **Reopen in Container**. Al crearse, el contenedor ejecuta `npm ci`.

3. Dentro del contenedor, `make help` lista todas las tareas. Las principales:

   | Tarea                   | Qué hace                                         |
   | ----------------------- | ------------------------------------------------ |
   | `make run`              | Servidor de desarrollo en http://localhost:4200  |
   | `make check`            | Lo mismo que el pipeline: formato, build y tests |
   | `make test`             | Tests unitarios con Vitest                       |
   | `make component NAME=…` | Crea un componente                               |
   | `make release V=X.Y.Z`  | Publica una versión                              |

## URL de la API

El front llama a `auth/login` y `auth/register` del core. Cómo llega a él depende del ambiente:

- **Desarrollo**: el navegador llama directo al core en `API_URL`, que se define en `docker/.env` y `make run` recoge. Tras cambiarla hay que recrear el contenedor. El core debe permitir el origen del front con su `FRONT_URL`.
- **Producción**: el navegador llama a `/api` en el mismo dominio del front y nginx lo reenvía al core por la red privada. La dirección se da al arrancar el contenedor en `API_PRIVATE_URL` (en Railway, `http://${{Core.RAILWAY_PRIVATE_DOMAIN}}:8080`). Sin ella nginx no arranca.

## CI/CD

- **Pipeline** (`.github/workflows/pipeline.yml`): en cada push ejecuta `npm run check`.
- **Release** (`.github/workflows/release.yml`): al subir un tag `v*` (con `make release`) espera al pipeline, publica la imagen `docker/Dockerfile.prod` en GHCR y crea el GitHub Release.

La imagen de producción sirve la app con nginx (sin root) en el puerto 8080.
