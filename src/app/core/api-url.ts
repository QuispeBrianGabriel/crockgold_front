/**
 * URL base de la API, sin barra final.
 *
 * `API_URL` no es una variable real: el build la sustituye por un texto fijo
 * (`define` en angular.json). Su valor sale de la variable de entorno API_URL
 * (ver scripts/serve.sh y docker/Dockerfile.prod). Vacía = mismo origen que el front.
 */
declare const API_URL: string;

export const apiUrl = API_URL.replace(/\/+$/, '');
