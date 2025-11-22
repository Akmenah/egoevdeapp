# Contributing to EgoEvde

Thank you for considering contributing to EgoEvde! We welcome contributions from the community.

## How to Contribute

### Reporting Bugs

If you find a bug, please create an issue on GitHub with:
- A clear, descriptive title
- Steps to reproduce the issue
- Expected behavior
- Actual behavior
- Screenshots (if applicable)
- Device and OS information

### Suggesting Enhancements

We welcome suggestions for new features. Please create an issue with:
- A clear description of the enhancement
- Use cases and benefits
- Possible implementation approach (optional)

### Pull Requests

1. Fork the repository
2. Create a new branch from `main` for your feature (`git checkout -b feature/your-feature-name`)
3. Make your changes following the code style guidelines below
4. Test your changes thoroughly
5. Commit your changes with clear, descriptive messages
6. Push to your fork and submit a pull request

### Code Style Guidelines

- Follow the [Dart Style Guide](https://dart.dev/guides/language/effective-dart/style)
- Use `flutter format` to format your code before committing
- Write meaningful variable and function names
- Add comments for complex logic
- Keep functions small and focused on a single responsibility
- Add documentation comments for public APIs

### Localization

When adding new strings:
1. Add the string to both `lib/l10n/app_en.arb` and `lib/l10n/app_tr.arb`
2. Include a description in the ARB file
3. Run `flutter gen-l10n` to regenerate localization files
4. Use `AppLocalizations.of(context)!.stringKey` in your code

### Testing

- Test your changes on both Android and iOS (if possible)
- Test in both portrait and landscape orientations
- Test with different screen sizes
- Verify that existing features still work correctly

### Commit Messages

- Use clear and meaningful commit messages
- Start with a verb in present tense (e.g., "Add feature", "Fix bug", "Update documentation")
- Reference issue numbers when applicable (e.g., "Fix #123: Error handling in network calls")

## Code of Conduct

- Be respectful and inclusive
- Welcome newcomers and help them learn
- Focus on constructive feedback
- Accept criticism gracefully

## Questions?

If you have questions about contributing, feel free to create an issue labeled "question".

Thank you for contributing to EgoEvde! 🚌
