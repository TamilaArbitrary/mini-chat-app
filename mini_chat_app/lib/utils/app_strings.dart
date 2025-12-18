abstract class AppStrings { 
  static const String appTitle = 'CHATTRIX';
  static const String tagline = 'Connect. Chat. Enjoy';   

  static const String fieldNameHint = 'Full Name';
  static const String fieldEmailHint = 'Email Address';
  static const String fieldPasswordHint = 'Password';

  static const String buttonSignUp = 'Sign Up';
  static const String buttonSignIn = 'Sign In';
  static const String buttonSignInGoogle = 'Sign in with Google';
  static const String linkNewUser = 'New user? Sign Up here';
  static const String linkExistingUser = 'Already have an account? Sign In here';
  
  static const String errorRequired = ' is required.';
  
  static const String errorNameRequired = 'Name is required.'; 
  static const String errorNameLength = 'Name must be at least 3 characters long.';
    
  static const String errorEmailRequired = 'Email is required.';
  static const String errorEmailTooShort = 'Email is too short.';
  static const String errorEmailTooLong = 'Email is too long.';
  static const String errorEmailInvalidFormat = 'Invalid email address format.';
    
  static const String errorPasswordRequired = 'Password is required.'; 
  static const String errorPasswordLength = 'Password must be at least 8 characters.';
  static const String errorPasswordUppercase = 'Must contain an uppercase letter.';
  static const String errorPasswordLowercase = 'Must contain a lowercase letter.';
  static const String errorPasswordDigit = 'Must contain a number.';    
  static const String errorAuthFailed = 'Authentication failed. Please try again.';
  static const String errorAuthInvalidCredentials = 'Invalid email or password. Please check your credentials.';
  static const String errorAuthTooManyRequests = 'Too many failed attempts. Try again later.';
  static const String errorAuthEmailInUse = 'This email is already registered. Please sign in instead.';
  static const String errorAuthWeakPassword = 'The password is too weak. Ensure it meets complexity requirements.';
  static const String errorAuthInvalidEmail = 'The email address format is invalid.';
  static const String errorSignInFailedUnknown = 'Sign in failed. Unknown error.';
  static const String errorSignUpFailedUnknown = 'Sign up failed. Unknown error.';
  static const String errorGoogleSignInFailed = 'Google Sign In failed.';
  static const String errorGoogleSignInCancelled = 'Google Sign In cancelled or failed.';
}