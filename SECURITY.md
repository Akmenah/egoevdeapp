# Security Policy

## Supported Versions

Currently supported versions of EgoEvde:

| Version | Supported          |
| ------- | ------------------ |
| 1.0.x   | :white_check_mark: |

## Reporting a Vulnerability

If you discover a security vulnerability in EgoEvde, please follow these steps:

1. **Do Not** create a public GitHub issue for security vulnerabilities
2. Email the details to [your-email@example.com] with the subject "Security Vulnerability in EgoEvde"
3. Include:
   - Description of the vulnerability
   - Steps to reproduce
   - Potential impact
   - Suggested fix (if available)

We will respond within 48 hours and work with you to understand and resolve the issue.

## Security Considerations

### Data Privacy
- This app does not collect, store, or transmit any personal user data
- All bus stop data is fetched from public EGO API endpoints
- Saved routes are stored only on the local device using SharedPreferences

### Network Security
- All API calls are made over HTTPS when possible
- No authentication credentials are required or stored
- Network requests timeout after a reasonable period

### Local Storage
- Route data is stored in plain text in SharedPreferences
- No sensitive information is stored locally

## Best Practices for Contributors

- Never commit API keys, passwords, or secrets to the repository
- Use environment variables for any configuration that may contain sensitive data
- Review dependencies regularly for known vulnerabilities
- Follow secure coding practices as outlined in the CONTRIBUTING.md

## Third-Party Dependencies

We regularly monitor our dependencies for security vulnerabilities. Run `flutter pub outdated` to check for updates.

## Disclosure Policy

When we receive a security vulnerability report, we will:
1. Confirm the problem and determine affected versions
2. Audit code to find similar problems
3. Prepare fixes for all supported versions
4. Release patches as soon as possible

Thank you for helping keep EgoEvde secure!
