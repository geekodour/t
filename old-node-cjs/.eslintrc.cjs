/* eslint-env node */
module.exports = {
  env: { node: true },
  extends: [
    'eslint:recommended',
    'plugin:@typescript-eslint/recommended',
    'plugin:@typescript-eslint/recommended-requiring-type-checking',
    'plugin:security/recommended',
    // see https://typescript-eslint.io/linting/troubleshooting/formatting
    // adding prettier here doesn't add prettier but exclusively turns off all
    // formatting rules by eslint
    'prettier',
  ],
  parser: '@typescript-eslint/parser',
  parserOptions: {
    project: true,
    tsconfigRootDir: __dirname,
  },
  plugins: ['@typescript-eslint'],
  root: true,
};
