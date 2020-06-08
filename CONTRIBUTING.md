We encourage you to contribute to Frontman if they have ideas for improvements to the project. 
Your help is essential to keeping Frontman fast and easy to use.

## Opening an issue

When you open an issue, please provide as many details as possible to replicate the issue.
It would be even better to have a link to a (forked) repository so that we can see the behavior right away.

## Security issues

If you find a security issue in Frontman, please open an issue an add the `Security` label.

## Submitting a pull request

Keep your changes as focused as possible. If there are multiple changes you'd like to make, consider submitting them as separate pull requests unless they are related to each other.

Here are a few tips to increase the likelihood of us merging your pull request:

- [ ] Write tests.
- [ ] Write [good commit messages](http://tbaggery.com/2008/04/19/a-note-about-git-commit-messages.html).
- [ ] Allow [edits from maintainers](https://blog.github.com/2016-09-07-improving-collaboration-with-forks/).

## Code style
All Ruby code must follow the [Ruby community style guide](https://rubystyle.guide/). The `bundle exec rubocop` command runs [Rubocop](https://docs.rubocop.org/en/stable/) to ensure the code follows these conventions.

## Tests
If you create a PR that fixes a bug, we expect you to create a test demonstrating the buggy behavior. The test should pass after your PR. 

For any code you introduce, you must add tests that confirm that the **public API** of your code works as expected.

## Breaking changes
Ideally, Frontman should remain backward compatible so that updating Frontman is easy for everyone.
However, we're ready to break backward compatibility if needed.

If you want to make a change that breaks backward compatibility, please describe them in your pull request and explain why you had to make these changes.

## Resources

- [Code of conduct](.github/CODE_OF_CONDUCT.md)
- [Contributing to Open Source on GitHub](https://guides.github.com/activities/contributing-to-open-source/)
- [Using Pull Requests](https://help.github.com/articles/using-pull-requests/)
- [GitHub Help](https://help.github.com)
