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

## CI/CD

- **Pipeline** (`.github/workflows/pipeline.yml`): en cada push ejecuta `npm run check`.
- **Release** (`.github/workflows/release.yml`): al subir un tag `v*` (con `make release`) espera al pipeline, publica la imagen `docker/Dockerfile.prod` en GHCR y crea el GitHub Release.

La imagen de producción sirve la app con nginx (sin root) en el puerto 8080.
