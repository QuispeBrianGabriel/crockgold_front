# =============================================================================
#  Crockgold Front — interfaz del desarrollador
#
#  Ejecuta `make` o `make help` para ver todas las tareas.
#  La lógica vive en scripts/: aquí solo se llaman comandos.
#
#  Todas las tareas se ejecutan dentro del Dev Container, salvo `setup`,
#  que se ejecuta en el host antes de abrirlo por primera vez.
#
#  Al añadir una tarea, añade también su línea en `help`.
# =============================================================================

# bash y no sh (dash): con un solo comando, bash se reemplaza por él. dash se
# queda en medio y, tras un Ctrl+C, se mata con SIGINT aunque el comando haya
# terminado bien, y make imprime "*** Interrupt" (ver scripts/graceful.sh).
SHELL         := bash
.DEFAULT_GOAL := help
MAKEFLAGS     += --no-print-directory

# Envoltorio de cierre ordenado con Ctrl+C (ver scripts/graceful.sh)
GRACEFUL := scripts/graceful.sh
NG       := $(GRACEFUL) "🛑 Tarea de Angular interrumpida" npx ng
NPM      := $(GRACEFUL) "🛑 Tarea de npm interrumpida" npm

# Parámetros opcionales (se pasan como `make tarea VAR=valor`)
T    ?=
NAME ?=
V    ?=

.PHONY: setup help tree \
        install run stop \
        check test format format-check \
        build clean \
        component service \
        version release

# =============================================================================
#  📚 Ayuda
# =============================================================================

# Formatos de printf usados por `help`:
#   TITLE → título de grupo
#   ITEM  → tarea + descripción
#   ARGS  → tarea + descripción + parámetros (atenuados)
TITLE := \n\033[1;33m%s\033[0m\n
ITEM  := "  \033[1;36m%-15s\033[0m %s\n"
ARGS  := "  \033[1;36m%-15s\033[0m %s \033[2m%s\033[0m\n"

help:
	@printf "\n\033[1;35m  🪙  Crockgold Front\033[0m \033[2m— make <tarea> [VAR=valor]\033[0m\n"

	@printf "$(TITLE)" "🖥️  Host — se ejecuta FUERA del Dev Container"
	@printf $(ITEM) "setup"         "🧰 Prepara el repo recién clonado (una sola vez)"

	@printf "$(TITLE)" "📚 General"
	@printf $(ITEM) "help"          "📖 Muestra esta ayuda"
	@printf $(ITEM) "tree"          "🌳 Árbol del código del proyecto"

	@printf "$(TITLE)" "🚀 Aplicación"
	@printf $(ITEM) "install"       "📥 Instala las dependencias (npm ci)"
	@printf $(ITEM) "run"           "▶️  Arranca la app en :4200"
	@printf $(ITEM) "stop"          "⏹️  Detiene la app y libera el 4200"

	@printf "$(TITLE)" "🧪 Calidad"
	@printf $(ITEM) "check"         "✅ Lo mismo que el pipeline"
	@printf $(ARGS) "test"          "🧪 Ejecuta los tests" "[T='**/auth/**']"
	@printf $(ITEM) "format"        "🎨 Corrige el formato"
	@printf $(ITEM) "format-check"  "🔍 Verifica el formato sin tocar nada"

	@printf "$(TITLE)" "🏗️  Build"
	@printf $(ITEM) "build"         "📦 Genera la app en dist/"
	@printf $(ITEM) "clean"         "🧹 Borra dist/ y la caché de Angular"

	@printf "$(TITLE)" "🧩 Generadores"
	@printf $(ARGS) "component"     "🧱 Crea un componente" "NAME=features/login"
	@printf $(ARGS) "service"       "🔌 Crea un servicio" "NAME=core/auth"

	@printf "$(TITLE)" "🏷️  Release"
	@printf $(ITEM) "version"       "🔖 Última versión publicada"
	@printf $(ARGS) "release"       "🚢 Publica la imagen (pide confirmar)" "V=0.1.0"

	@printf "\n\033[2m  Docs: README.md\033[0m\n\n"

.DEFAULT:
	@printf "\033[1;31m✘\033[0m La tarea '%s' no existe. Usa \033[1;36mmake help\033[0m para ver todas.\n" "$@"

# Único comando que se ejecuta en el host
setup:
	@scripts/setup.sh

tree:
	@$(GRACEFUL) "🛑 Cancelado" tree -a --dirsfirst -I '.git|node_modules|dist|.angular|coverage|scripts|docker|.devcontainer|.github'

# =============================================================================
#  🚀 Aplicación
# =============================================================================

install:
	@$(NPM) ci --no-audit --no-fund

run:
	@$(GRACEFUL) "⏹️  App detenida correctamente" npx ng serve

stop:
	@scripts/stop.sh

# =============================================================================
#  🧪 Calidad
# =============================================================================

check:
	@$(NPM) run check

# Con T se filtran los specs por ruta: make test T='**/auth/**'
test:
	@$(NG) test --watch=false $(if $(T),--include '$(T)')

format:
	@$(NPM) run format

format-check:
	@$(NPM) run format:check

# =============================================================================
#  🏗️ Build
# =============================================================================

build:
	@$(NG) build

clean:
	@$(GRACEFUL) "🛑 Cancelado" rm -rf dist .angular

# =============================================================================
#  🧩 Generadores
# =============================================================================

component:
	@$(if $(NAME),$(NG) generate component '$(NAME)',printf "\033[1;31m✘\033[0m Falta el nombre. Ej: make component NAME=features/login\n")

service:
	@$(if $(NAME),$(NG) generate service '$(NAME)',printf "\033[1;31m✘\033[0m Falta el nombre. Ej: make service NAME=core/auth\n")

# =============================================================================
#  🏷️ Release
# =============================================================================

version:
	@git describe --tags --abbrev=0 2>/dev/null || printf "\033[2mAún no hay ninguna versión publicada\033[0m\n"

release:
	@scripts/release.sh "$(V)"
