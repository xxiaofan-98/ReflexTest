import SwiftUI

struct GameView: View {
    @StateObject private var viewModel = GameViewModel()
    let onComplete: (ResultData) -> Void
    let onBack: () -> Void

    @State private var countdownScale: CGFloat = 1.5
    @State private var countdownOpacity: Double = 0
    @State private var tapTextScale: CGFloat = 0.5
    @State private var showResult = false

    var body: some View {
        ZStack {
            backgroundColor
                .ignoresSafeArea()

            VStack {
                header
                Spacer()
                centerContent
                Spacer()
                bottomHint
            }
            .padding(.top, 16)
            .padding(.bottom, 32)
        }
        .contentShape(Rectangle())
        .onTapGesture {
            handleTap()
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)) { _ in
            viewModel.pauseGame()
        }
        .statusBarHidden(true)
    }

    // MARK: - Header

    private var header: some View {
        HStack {
            Button {
                viewModel.reset()
                onBack()
            } label: {
                Image(systemName: "xmark")
                    .font(.title3.weight(.semibold))
                    .foregroundColor(headerTextColor)
                    .frame(width: 44, height: 44)
            }

            Spacer()

            ProgressDots(
                totalRounds: 5,
                currentRound: viewModel.currentRound,
                completedRounds: viewModel.roundTimes.count
            )

            Spacer()

            Color.clear
                .frame(width: 44, height: 44)
        }
        .padding(.horizontal, 16)
    }

    // MARK: - Center Content

    @ViewBuilder
    private var centerContent: some View {
        switch viewModel.gameState {
        case .idle:
            idleContent

        case .countdown(let count):
            countdownContent(count)

        case .waiting:
            waitingContent

        case .ready:
            readyContent

        case .tapped(let ms):
            tappedContent(ms)

        case .tooEarly:
            tooEarlyContent
        }
    }

    private var idleContent: some View {
        VStack(spacing: 12) {
            Image(systemName: "hand.tap.fill")
                .font(.system(size: 48))
                .foregroundColor(Color.theme.textSecondary)

            Text("Tap anywhere to begin")
                .font(.title3)
                .fontWeight(.medium)
                .foregroundColor(Color.theme.textSecondary)
        }
    }

    private func countdownContent(_ count: Int) -> some View {
        Text("\(count)")
            .font(.system(size: 120, weight: .bold, design: .rounded))
            .foregroundColor(Color.theme.textPrimary)
            .scaleEffect(countdownScale)
            .opacity(countdownOpacity)
            .onChange(of: count) { _ in
                animateCountdown()
            }
            .onAppear {
                animateCountdown()
            }
    }

    private var waitingContent: some View {
        VStack(spacing: 12) {
            Text("Wait for green...")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.white)
        }
    }

    private var readyContent: some View {
        Text("TAP!")
            .font(.system(size: 72, weight: .black, design: .rounded))
            .foregroundColor(.black)
            .scaleEffect(tapTextScale)
            .onAppear {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.5, blendDuration: 0)) {
                    tapTextScale = 1.0
                }
            }
            .onDisappear {
                tapTextScale = 0.5
            }
    }

    private func tappedContent(_ ms: Int) -> some View {
        VStack(spacing: 16) {
            CountUpText(
                targetValue: ms,
                font: .system(size: 64, weight: .bold, design: .monospaced)
            )

            Text(ReactionRecord.ratingFor(ms: ms))
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundColor(Color.theme.textSecondary)

            if viewModel.isSessionComplete {
                Text("Session complete!")
                    .font(.headline)
                    .foregroundColor(Color.theme.accentGreen)
                    .padding(.top, 8)

                PrimaryButton(title: "View Results") {
                    onComplete(viewModel.resultData)
                }
                .padding(.horizontal, 48)
                .padding(.top, 8)
            } else {
                Text("Tap to continue")
                    .font(.subheadline)
                    .foregroundColor(Color.theme.textSecondary)
                    .padding(.top, 8)
            }
        }
    }

    private var tooEarlyContent: some View {
        VStack(spacing: 12) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 48))
                .foregroundColor(.black)

            Text("Too early!")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.black)

            Text("Wait for the green screen")
                .font(.body)
                .foregroundColor(.black.opacity(0.7))

            Text("Tap to retry")
                .font(.subheadline)
                .foregroundColor(.black.opacity(0.5))
                .padding(.top, 8)
        }
    }

    // MARK: - Bottom Hint

    @ViewBuilder
    private var bottomHint: some View {
        if case .tapped = viewModel.gameState, !viewModel.isSessionComplete {
            Text("Round \(viewModel.currentRound) of 5")
                .font(.caption)
                .foregroundColor(Color.theme.textSecondary)
        }
    }

    // MARK: - Helpers

    private var backgroundColor: Color {
        switch viewModel.gameState {
        case .idle, .countdown: return Color.theme.background
        case .waiting: return Color.theme.accentRed
        case .ready: return Color.theme.accentGreen
        case .tapped: return Color.theme.background
        case .tooEarly: return Color.theme.accentAmber
        }
    }

    private var headerTextColor: Color {
        switch viewModel.gameState {
        case .waiting, .tooEarly: return .white
        case .ready: return .black
        default: return Color.theme.textPrimary
        }
    }

    private func handleTap() {
        if viewModel.isSessionComplete {
            return
        }
        viewModel.handleTap()
    }

    private func animateCountdown() {
        countdownScale = 1.5
        countdownOpacity = 0
        withAnimation(.easeOut(duration: 0.4)) {
            countdownScale = 1.0
            countdownOpacity = 1.0
        }
        withAnimation(.easeIn(duration: 0.3).delay(0.5)) {
            countdownOpacity = 0
        }
    }
}
