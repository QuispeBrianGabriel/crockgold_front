#!/usr/bin/env bash
# -----------------------------------------------------------------------------
# Prepara un repositorio recién clonado para abrirlo en el Dev Container.
#
# ⚠ Es el ÚNICO script que se ejecuta en el HOST, fuera del Dev Container,
#   porque deja lista la configuración que el contenedor necesita para arrancar.
#
# Pasos:
#   1. Comprueba que estás en el host y que Docker responde.
#   2. Crea docker/.env a partir de docker/.env.example (si no existe).
#
# Se puede repetir sin riesgo: no pisa un docker/.env ya configurado.
#
# Requiere en el host: bash, make y Docker.
# -----------------------------------------------------------------------------
source "$(dirname "$0")/_common.sh"

ENV_FILE=docker/.env
EXAMPLE=docker/.env.example

# --- 1. Host y Docker --------------------------------------------------------
# /.dockerenv solo existe dentro de un contenedor.
if [[ -f /.dockerenv ]]; then
	fail "make setup se ejecuta en el HOST, no dentro del Dev Container"
fi
command -v docker >/dev/null || fail "No se encuentra el comando docker"
docker info >/dev/null 2>&1 || fail "Docker no responde: arráncalo y repite"
ok "Docker disponible"

# --- 2. docker/.env ----------------------------------------------------------
if [[ -f "$ENV_FILE" ]]; then
	info "$ENV_FILE ya existe: se conserva"
else
	cp "$EXAMPLE" "$ENV_FILE"
	ok "Creado $ENV_FILE desde la plantilla"
fi

# --- Siguiente paso ----------------------------------------------------------
echo
ok "Todo listo. Ahora:"
echo "   1. Abre esta carpeta en VS Code"
echo "   2. Elige «Reopen in Container»"
echo "   3. Dentro, ejecuta: make help"
