# Homebrew Formula Checksum Updater

## update-checksums.sh

Automatically updates SHA256 checksums in the rgrc.rb Homebrew formula.

### Usage

#### 1. Auto-detect version from formula file

```bash
./update-checksums.sh
```

The script reads the version from `Formula/rgrc.rb` and downloads the corresponding release artifacts to calculate SHA256 checksums.

#### 2. Specify version explicitly

```bash
./update-checksums.sh 0.5.1
```

### How It Works

1. Extracts version number from Formula file or command line argument
2. Downloads ARM64 (aarch64-apple-darwin) and Intel (x86_64-apple-darwin) release tarballs
3. Calculates SHA256 checksums for both architectures
4. Updates the `sha256` values in the Formula file
5. Displays changes for review via git diff

### Prerequisites

- macOS or Linux system
- `curl` installed
- `shasum` (macOS) or `sha256sum` (Linux)
- `ruby` (usually pre-installed)
- Network access to GitHub

### Example Output

```
[INFO] Using version from formula file: 0.5.1
[INFO] Calculating checksums for version 0.5.1...

[INFO] Processing ARM64 (Apple Silicon)...
[INFO] Downloading: https://github.com/lazywalker/rgrc/releases/download/v0.5.1/rgrc-aarch64-apple-darwin.tar.gz
[INFO] ARM64 SHA256: 78e390d0c3b9ac640070459878dd887dc7d8d46df2a6a2cee65734cdac424173

[INFO] Processing x86_64 (Intel)...
[INFO] Downloading: https://github.com/lazywalker/rgrc/releases/download/v0.5.1/rgrc-x86_64-apple-darwin.tar.gz
[INFO] Intel SHA256: 9874ad9698cee642e4dfa531d1674156248c74d9bb6b0efe7f65a131a7bc431d

[INFO] Updating formula file...
[INFO] Formula file updated successfully!

[INFO] Changes made:
  ARM64:  78e390d0c3b9ac640070459878dd887dc7d8d46df2a6a2cee65734cdac424173
  Intel:  9874ad9698cee642e4dfa531d1674156248c74d9bb6b0efe7f65a131a7bc431d

[INFO] You can review the changes with: git diff Formula/rgrc.rb
```

### Troubleshooting

#### Download Failures

If downloads fail, verify:
- Version number is correct
- Release exists on GitHub
- Network connectivity to GitHub

#### Permission Denied

Ensure the script is executable:
```bash
chmod +x update-checksums.sh
```

### Integration with Release Workflow

Recommended workflow after publishing a new release:

```bash
# 1. Tag and push new version in rgrc repository
cd /path/to/rgrc
git tag v0.5.2
git push --tags

# 2. Wait for GitHub Actions to build and publish releases

# 3. Update Homebrew formula checksums
cd /path/to/homebrew-rgrc
./update-checksums.sh 0.5.2

# 4. Review and commit changes
git diff Formula/rgrc.rb
git add Formula/rgrc.rb
git commit -m "chore: update to v0.5.2"
git push
```

### Notes

- The script modifies `Formula/rgrc.rb` directly
- Use `git diff` to review changes before committing
- Use `git restore Formula/rgrc.rb` to revert if needed
- Since the project is git-managed, no backup files are created
