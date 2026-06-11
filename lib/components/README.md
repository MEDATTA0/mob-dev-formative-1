# components/

Reusable UI widgets shared across screens.

| File | Widget | Description |
|------|--------|-------------|
| `custom_button.dart` | `CustomButton` | Animated elevated button with press-scale effect, loading state, and optional icon. |
| `custom_text_field.dart` | `CustomTextField` | Animated text field with focus shadow, password toggle, and form validation support. |
| `custom_dropdown_field.dart` | `CustomDropdownField<T>` | Themed dropdown form field with a prefix icon, matching the app's input style. |
| `login_form.dart` | `LoginForm` | Email/password form that authenticates against `userStore` and sets `AuthSession`. |
| `signup_form.dart` | `SignupForm` | Registration form that validates inputs, generates a campus ID, and persists a new `User` via `userStore`. |
