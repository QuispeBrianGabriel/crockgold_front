import { Component, inject, signal } from '@angular/core';
import { NonNullableFormBuilder, ReactiveFormsModule, Validators } from '@angular/forms';
import { RouterLink } from '@angular/router';
import { Auth, authErrorMessage } from '../../core/auth';

@Component({
  imports: [ReactiveFormsModule, RouterLink],
  selector: 'app-login',
  styleUrl: './auth-form.scss',
  templateUrl: './login.html',
})
export class Login {
  private readonly auth = inject(Auth);

  protected readonly form = inject(NonNullableFormBuilder).group({
    email: ['', [Validators.required, Validators.email]],
    password: ['', Validators.required],
  });
  protected readonly showPassword = signal(false);
  protected readonly sending = signal(false);
  protected readonly error = signal('');
  protected readonly done = signal(false);

  protected bad(name: 'email' | 'password'): boolean {
    const control = this.form.controls[name];
    return control.invalid && control.touched;
  }

  protected submit(): void {
    if (this.sending()) return;
    if (this.form.invalid) {
      this.form.markAllAsTouched();
      return;
    }

    this.sending.set(true);
    this.error.set('');
    this.auth.login(this.form.getRawValue()).subscribe({
      // Pendiente del contrato de la API: guardar la sesión y redirigir.
      next: () => this.done.set(true),
      error: (err: unknown) => {
        this.sending.set(false);
        this.error.set(authErrorMessage(err, { 401: 'Correo o contraseña incorrectos.' }));
      },
    });
  }
}
