#!/usr/bin/env bash
# -----------------------------------------------------------------------------
# Ejecuta un comando del Makefile con salida ordenada (ver _common.sh):
#   - Ctrl+C          → muestra el mensaje indicado.
#   - El comando falla → explica qué falló y con qué código.
#   - No existe        → sugiere reconstruir el Dev Container.
# Nunca termina con un error de make.
#
# Uso: scripts/graceful.sh "<mensaje al pulsar Ctrl+C>" <comando> [args…]
#   Ej:  scripts/graceful.sh "⏹️  Servidor detenido" npx ng serve
# -----------------------------------------------------------------------------
source "$(dirname "$0")/_common.sh"

INTERRUPT_MSG="$1"
shift

# Nombre legible del programa para los mensajes: se saltan `env`, `npx` y las
# asignaciones VAR=valor (así se muestra `ng` y no `npx`).
program=""
for arg in "$@"; do
	if [[ "$arg" != env && "$arg" != npx && "$arg" != *=* ]]; then
		program=$(basename "$arg")
		break
	fi
done

status=0
"$@" || status=$?

case $status in
0) ;;
127) fail "No se encuentra el comando '$program': haz Rebuild Container para instalarlo" ;;
*) fail "$program terminó con errores (código $status): revisa la salida de arriba" ;;
esac
