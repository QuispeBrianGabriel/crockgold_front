import { HttpClient, HttpErrorResponse } from '@angular/common/http';
import { Injectable, inject } from '@angular/core';
import { Observable } from 'rxjs';
import { apiUrl } from './api-url';

export interface Credentials {
  email: string;
  password: string;
}

@Injectable({ providedIn: 'root' })
export class Auth {
  private readonly http = inject(HttpClient);

  login(credentials: Credentials): Observable<unknown> {
    return this.http.post(`${apiUrl}/auth/login`, credentials);
  }

  register(credentials: Credentials): Observable<unknown> {
    return this.http.post(`${apiUrl}/auth/register`, credentials);
  }
}

/** Traduce un fallo HTTP a un mensaje para el usuario. */
export function authErrorMessage(err: unknown, byStatus: Record<number, string> = {}): string {
  if (!(err instanceof HttpErrorResponse)) return 'Algo salió mal. Inténtalo de nuevo.';
  if (err.status === 0) return 'No se pudo conectar con el servidor.';
  return byStatus[err.status] ?? 'Algo salió mal. Inténtalo de nuevo.';
}
