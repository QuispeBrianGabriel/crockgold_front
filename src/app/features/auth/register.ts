import { Component, inject, signal } from '@angular/core';
import {
  AbstractControl,
  NonNullableFormBuilder,
  ReactiveFormsModule,
  ValidationErrors,
  Validators,
} from '@angular/forms';
import { RouterLink } from '@angular/router';
import { Auth, authErrorMessage } from '../../core/auth';

const MIN_PASSWORD = 8;

function passwordsMatch(group: AbstractControl): ValidationErrors | null {
  return group.get('password')?.value === group.get('confirm')?.value ? null : { mismatch: true };
}

@Component({
  imports: [ReactiveFormsModule, RouterLink],
  selector: 'app-register',
  styleUrl: './auth-form.scss',
  templateUrl: './register.html',
})
export class Register {
  private readonly auth = inject(Auth);

  protected readonly minPassword = MIN_PASSWORD;
  protected readonly form = inject(NonNullableFormBuilder).group(
    {
      email: ['', [Validators.required, Validators.email]],
      password: ['', [Validators.required, Validators.minLength(MIN_PASSWORD)]],
      confirm: ['', Validators.required],
    },
    { validators: passwordsMatch },
  );
  protected readonly showPassword = signal(false);
  protected readonly showConfirm = signal(false);
  protected readonly sending = signal(false);
  protected readonly error = signal('');
  protected readonly done = signal(false);

  protected bad(name: 'email' | 'password' | 'confirm'): boolean {
    const control = this.form.controls[name];
    const mismatch = name === 'confirm' && this.form.hasError('mismatch');
    return (control.invalid || mismatch) && control.touched;
  }

  protected submit(): void {
    if (this.sending()) return;
    if (this.form.invalid) {
      this.form.markAllAsTouched();
      return;
    }

    const { email, password } = this.form.getRawValue();
    this.sending.set(true);
    this.error.set('');
    this.auth.register({ email, password }).subscribe({
      next: () => this.done.set(true),
      error: (err: unknown) => {
        this.sending.set(false);
        this.error.set(authErrorMessage(err, { 409: 'Ya existe una cuenta con ese correo.' }));
      },
    });
  }
}
