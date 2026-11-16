#!/usr/bin/env bash
# -----------------------------------------------------------------------------
# Arranca `ng serve` mostrando solo lo importante: las URLs y los errores.
# Oculta el aviso de seguridad del host, la tabla de tamaños y las notas.
#
# `script` da a ng serve un terminal propio, así conserva colores y atajos
# (r, o, q…) aunque su salida pase por el filtro de awk. `-W interactive`
# evita que mawk acumule la salida en bloques (sin él no se ve nada hasta salir).
#
# Uso: scripts/serve.sh [args de ng serve…]
# -----------------------------------------------------------------------------
cmd="npx ng serve"
for arg in "$@"; do cmd+=" $(printf '%q' "$arg")"; done

script -qefc "$cmd" /dev/null | awk -W interactive '
{ line = $0; gsub(/\r|\033\[[?0-9;]*[A-Za-z]/, "", line) }

# Aviso de seguridad: termina en "websocket connection issues."
line ~ /^Warning: This is a simple server/ { skip_warning = 1 }
skip_warning { if (line ~ /websocket connection issues\./) { skip_warning = 0; skip_blank = 1 } next }

# Tabla de tamaños: termina en la fila "Initial total"
line ~ /^Initial chunk files/ { skip_table = 1 }
skip_table { if (line ~ /Initial total/) { skip_table = 0; skip_blank = 1 } next }

line ~ /^Watch mode enabled/        { next }
line ~ /^NOTE: Raw file sizes/      { next }
line ~ /press h \+ enter/           { next }

# Líneas en blanco o con solo espacios que dejan lo ocultado
line ~ /^[ \t]*$/ { if (skip_blank) next }
{ skip_blank = 0; print; fflush() }
'
