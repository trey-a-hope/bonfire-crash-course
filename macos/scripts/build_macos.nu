#!/usr/bin/env nu

# Build the macOS release app
def main [] {
    print "Building macOS release..."
    flutter build macos --release
    print "Done: build/macos/Build/Products/Release/"
}