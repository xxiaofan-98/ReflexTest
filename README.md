# ReflexTest

A minimal, dark-themed iOS app that tests your reaction speed through a color-change tap game.

## How It Works

1. Tap to start a round
2. Wait through the countdown (3, 2, 1)
3. Screen turns **red** — wait for it...
4. Screen turns **green** — tap as fast as you can!
5. Repeat for 5 rounds, then view your stats

Tap during red = too early, retry that round. Random delay before green: 1.5–5.0 seconds.

## Features

- **5-round sessions** with per-round reaction timing
- **Results screen** with average, best, worst, median, and round breakdown
- **Leaderboard** sorted by average or best, with swipe-to-delete
- **Share results** as formatted text
- **Haptic feedback** on key interactions
- **Local storage** via UserDefaults (up to 100 records)

## Tech Stack

- SwiftUI, iOS 16+
- MVVM architecture
- No dependencies, no account system

## Building

Open `ReflexTest/ReflexTest.xcodeproj` in Xcode 15+ and run on a simulator or device.
