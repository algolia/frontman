 # Frontman release process
 
 ## Setup
 
 > You only have to do this setup once.
 
 * Make sure you have an account on [RubyGems][rubygems].
 * Run the `gem signin` command from your CLI, and log in with your RubyGems credentials.
 * Make sure that you're an administrator on the Frontman gem. You can ask an existing administrator for access if you're in a position to do releases for Frontman.
 
 ## Release 
 * First, make sure all the tests on `master` are green.
 * Switch to the `master` branch: `git checkout master`.
 * Make sure you branch is up-to-date: `git fetch && git pull`.
 * Make sure your repository is clean: `git reset --hard`.
 * Check the changes the new version introduces by visiting https://github.com/algolia/frontman/compare/{latest_version}...master , where you have to replace `{latest version}` with the latest tag. You can use `git tag --list` to check for the latest release.
 * Determine the new version number that you should release, and make sure there are no breaking changes.
 * Bump the version in `lib/frontman/version.rb`.
 * Update the [`CHANGELOG.md`][changelog] file with the changes that this new version introduces.
 * Commit your changes: `git commit -a -m "chore: bumps version to vX.X.X"`.
 * Create a tag for the new version: `git tag X.X.X`.
 * Push your changes and the new tag: `git push && git push --tags`.
 * Build the Frontman gem: `gem build frontman-ssg.gemspec`.
 * Push the newly built gem to [RubyGems][rubygems]: `gem push frontman-ssg-X.X.X.gem`.
 * Delete the locally built gem: `rm frontman-ssg-X.X.X.gem`.
 
 
 [changelog]: ../CHANGELOG.md
 [rubygems]: https://www.rubygems.org/
