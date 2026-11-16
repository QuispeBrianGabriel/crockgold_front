import { HttpErrorResponse, provideHttpClient } from '@angular/common/http';
import { HttpTestingController, provideHttpClientTesting } from '@angular/common/http/testing';
import { TestBed } from '@angular/core/testing';
import { Auth, authErrorMessage } from './auth';

describe('Auth', () => {
  let auth: Auth;
  let http: HttpTestingController;
  const credentials = { email: 'a@b.co', password: 'secreto123' };

  beforeEach(() => {
    TestBed.configureTestingModule({
      providers: [provideHttpClient(), provideHttpClientTesting()],
    });
    auth = TestBed.inject(Auth);
    http = TestBed.inject(HttpTestingController);
  });

  afterEach(() => http.verify());

  it('envía las credenciales a auth/login', () => {
    auth.login(credentials).subscribe();
    const req = http.expectOne((r) => r.url.endsWith('/auth/login'));
    expect(req.request.method).toBe('POST');
    expect(req.request.body).toEqual(credentials);
    req.flush({});
  });

  it('envía las credenciales a auth/register', () => {
    auth.register(credentials).subscribe();
    const req = http.expectOne((r) => r.url.endsWith('/auth/register'));
    expect(req.request.method).toBe('POST');
    expect(req.request.body).toEqual(credentials);
    req.flush({});
  });
});

describe('authErrorMessage', () => {
  it('usa el mensaje propio del código de estado', () => {
    const err = new HttpErrorResponse({ status: 401 });
    expect(authErrorMessage(err, { 401: 'Credenciales incorrectas' })).toBe(
      'Credenciales incorrectas',
    );
  });

  it('avisa cuando no hay conexión', () => {
    expect(authErrorMessage(new HttpErrorResponse({ status: 0 }))).toContain('conectar');
  });
});
