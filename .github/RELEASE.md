 # Frontman release process
 
 ## Setup
 
 > You only have to do this once.
 
 * Make sure you have an account on [RubyGems][rubygems].
 * Run the `gem signin` command from your CLI and log in with your RubyGems credentials.
 * Make sure you're an administrator on the [Frontman][frontman] gem. You can ask an existing administrator for access if you're in a position to release Frontman.
 
 ## Release 
 * First, make sure all the tests on `master` are green.
 * Switch to the `master` branch: `git checkout master`.
 * Make sure you branch is up-to-date: `git fetch && git pull`.
 * Make sure your repository is clean: `git reset --hard && git clean -dfx`.
 * Check the changes the new version introduces by visiting `github.com/algolia/frontman/compare/{latest_version}...master`, replacing `{latest version}` with the latest tag. You can run `git tag --list` to check for the latest release.
 * Determine the [new version number][semver] that you should release, and make sure there are no breaking changes.
 * Bump the version in `lib/frontman/version.rb`.
 * Update the [`CHANGELOG.md`][changelog] file with the changes that this new version introduces.
 * Commit your changes: `git commit -a -m "chore: bumps version to vX.Y.Z"`.
 * Create a tag for the new version: `git tag X.Y.Z`.
 * Push your changes and the new tag: `git push && git push --tags`.
 * Build the Frontman gem: `gem build frontman-ssg.gemspec`.
 * Push the newly built gem to [RubyGems][rubygems]: `gem push frontman-ssg-X.Y.Z.gem`.
 * Delete the locally built gem: `rm frontman-ssg-X.Y.Z.gem`.
 
[changelog]: ../CHANGELOG.md
[frontman]: https://rubygems.org/gems/frontman-ssg
[rubygems]: https://www.rubygems.org/
[semver]: https://semver.org/
