# FitnessFreaks (iOS)

A SwiftUI fitness dashboard exploring a glass-morphic design language: frosted cards, animated charts, and a custom tab bar.

> **Status: UI prototype.** This is the interface layer only. Charts render from sample data, and there is no HealthKit integration or persistence yet.

## What's here

- **Workout progress card** with calendar integration
- **Intensity graph** — animated line chart with interactive data points
- **Quick insights** — heart rate, sleep, recovery, and stress cards
- **Metrics graphs** — horizontally scrolling bar charts
- **Adaptive header** that transforms on scroll
- **Custom glass tab bar** with animated selection

Everything is built with SwiftUI primitives. No charting library, no third-party dependencies.

## Design notes

The glass effect is a reusable `ViewModifier` in `Styles/GlassCardStyle.swift` rather than a per-view treatment, so every card picks up the same translucency, highlight, and shadow. Colour definitions live in `Extensions/ColorExtension.swift` and view helpers in `Extensions/ViewExtension.swift`.

The palette is dark-first: a mint and teal gradient background with per-metric accent colours, so each health card is identifiable at a glance.

## Structure

```
FitnessFreaks/
  FitnessFreaksApp.swift        App entry point
  ContentView.swift             Root container, tab bar, scroll header
  Components/
    WorkoutProgressCard.swift
    WorkoutIntensityGraph.swift
    QuickInsightsView.swift
    GraphMetricsView.swift
    BackgroundGradient.swift
  Styles/
    GlassCardStyle.swift        Shared frosted-glass modifier
  Extensions/
    ColorExtension.swift
    ViewExtension.swift
```

## Requirements

- iOS 16.0+
- Xcode 15.0+
- Swift 5.9+

## Running

```bash
git clone https://github.com/nikhilsharma81181/FitnessFreaks.git
cd FitnessFreaks
open FitnessFreaks.xcodeproj
```

Build and run on a simulator or device.

## Related

- [fitness_freaks](https://github.com/nikhilsharma81181/fitness_freaks) — the Flutter version, further along
- [fitness_freaks_ai](https://github.com/nikhilsharma81181/fitness_freaks_ai) — the LLM coaching backend

## License

MIT.
