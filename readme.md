# FitnessFreaks

![App Banner](https://github.com/yourusername/FitnessFreaks/raw/main/Images/app_banner.png)

A modern iOS fitness tracking app with elegant UI design, built entirely with SwiftUI. FitnessFreaks provides a comprehensive dashboard to monitor your fitness metrics, workout intensity, sleep patterns, and recovery status.

## Features

- **Beautiful Glass-Morphic UI Design**: Modern interface with frosted glass effects and dynamic animations
- **Workout Activity Tracking**: View and track your daily workout activities
- **Intensity Monitoring**: Visualize workout intensity across the week or month
- **Health Metrics**: Monitor heart rate, sleep, recovery, and stress levels
- **Activity Charts**: Interactive graphs showing your fitness progress
- **Dark Mode Optimized**: Designed for optimal viewing in dark mode

## Screenshots

![App Screenshots](https://github.com/yourusername/FitnessFreaks/raw/main/Images/app_screenshots.png)

## Requirements

- iOS 16.0+
- Xcode 15.0+
- Swift 5.9+

## Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/FitnessFreaks.git
   ```

2. Open the project in Xcode:
   ```bash
   cd FitnessFreaks
   open FitnessFreaks.xcodeproj
   ```

3. Build and run the project on your simulator or physical device.

## Project Structure

```
FitnessFreaks/
├── Views/
│   ├── ContentView.swift             # Main container view
│   ├── Components/
│   │   ├── WorkoutProgressCard.swift # Daily workout activity card
│   │   ├── WorkoutIntensityGraph.swift # Workout intensity visualization
│   │   ├── QuickInsightsView.swift   # Health metrics insights cards
│   │   ├── GraphMetricsView.swift    # Detailed metrics graphs
│   │   └── BackgroundGradient.swift  # Styled app background
├── Extensions/
│   ├── ColorExtension.swift          # Custom color definitions
│   └── ViewExtension.swift           # View modifier extensions
├── Styles/
│   └── GlassCardStyle.swift          # Glass-morphic card styling
└── Resources/
    └── Assets.xcassets               # App resources
```

## Key Components

### ContentView
The main container view that organizes all components with a custom tab bar, animated header, and scrolling content.

### WorkoutProgressCard
Displays the current day's workout activity status with calendar integration.

### WorkoutIntensityGraph
A beautifully animated line graph showing workout intensity over time with interactive data points.

### QuickInsightsView
Card-based display of health metrics including heart rate, sleep, recovery, and stress levels.

### GraphMetricsView
Detailed bar graphs for various health metrics that can be scrolled horizontally.

### GlassCardStyle
A custom ViewModifier that implements the frosted glass card style used throughout the app.

## UI Design

FitnessFreaks features a modern dark-themed UI with a "glass-morphic" design language:

- **Background**: Gradient blend of vibrant mint/teal colors
- **Cards**: Frosted glass effect with subtle transparency and highlights
- **Typography**: Clean, legible text with carefully chosen font sizes and weights
- **Animations**: Smooth spring animations for interactive elements
- **Color Palette**: Dark background with vibrant accent colors for different metrics

## Custom UI Elements

- **Glass Cards**: Translucent cards with subtle highlights and shadows
- **Interactive Graphs**: Touch-responsive data visualization
- **Custom Tab Bar**: Glass-effect tab bar with animated selection indicators
- **Adaptive Header**: Header that transforms as you scroll
- **Dynamic Animations**: Spring animations on user interaction

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the project
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgements

- [SwiftUI](https://developer.apple.com/xcode/swiftui/)
- [SF Symbols](https://developer.apple.com/sf-symbols/) for iconography