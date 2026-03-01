import SwiftUI

struct CountUpText: View {
    let targetValue: Int
    let suffix: String
    let font: Font
    let color: Color

    @State private var displayValue: Int = 0
    @State private var animationTimer: Timer?

    init(targetValue: Int, suffix: String = " ms", font: Font = .system(size: 48, weight: .bold, design: .monospaced), color: Color = .theme.textPrimary) {
        self.targetValue = targetValue
        self.suffix = suffix
        self.font = font
        self.color = color
    }

    var body: some View {
        Text("\(displayValue)\(suffix)")
            .font(font)
            .foregroundColor(color)
            .monospacedDigit()
            .onAppear {
                startAnimation()
            }
            .onDisappear {
                animationTimer?.invalidate()
            }
            .onChange(of: targetValue) { _ in
                startAnimation()
            }
    }

    private func startAnimation() {
        animationTimer?.invalidate()
        displayValue = 0

        let steps = 20
        let interval = 0.4 / Double(steps)
        let increment = max(targetValue / steps, 1)
        var currentStep = 0

        animationTimer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { timer in
            currentStep += 1
            if currentStep >= steps {
                displayValue = targetValue
                timer.invalidate()
            } else {
                displayValue = min(increment * currentStep, targetValue)
            }
        }
    }
}
