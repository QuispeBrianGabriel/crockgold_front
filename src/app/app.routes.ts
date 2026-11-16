import { Routes } from '@angular/router';
import { AuthLayout } from './features/auth/auth-layout';
import { Login } from './features/auth/login';
import { Register } from './features/auth/register';

export const routes: Routes = [
  {
    path: '',
    component: AuthLayout,
    children: [
      { path: 'login', component: Login, title: 'Entrar · Crockgold' },
      { path: 'register', component: Register, title: 'Crear cuenta · Crockgold' },
      { path: '', pathMatch: 'full', redirectTo: 'login' },
    ],
  },
  { path: '**', redirectTo: 'login' },
];
