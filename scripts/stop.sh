#!/usr/bin/env bash
# -----------------------------------------------------------------------------
# Detiene el servidor lanzado con `make run` (ng serve) y libera el 4200.
# Si no había ninguno corriendo, lo avisa sin fallar.
# -----------------------------------------------------------------------------
source "$(dirname "$0")/_common.sh"

# pkill busca por la línea de comandos completa del proceso de Node.
if pkill -f "ng serve"; then
	ok "Servidor detenido"
else
	printf '%sNo había ningún servidor corriendo%s\n' "$DIM" "$RESET"
fi
