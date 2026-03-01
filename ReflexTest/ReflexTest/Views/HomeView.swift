import SwiftUI

struct HomeView: View {
    let onStart: () -> Void
    let onLeaderboard: () -> Void

    @State private var pulseScale: CGFloat = 1.0

    var body: some View {
        VStack(spacing: 0) {
            Spacer()

            VStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(Color.theme.accentGreen.opacity(0.15))
                        .frame(width: 120, height: 120)
                        .scaleEffect(pulseScale)

                    Circle()
                        .fill(Color.theme.accentGreen.opacity(0.3))
                        .frame(width: 80, height: 80)

                    Image(systemName: "bolt.fill")
                        .font(.system(size: 36))
                        .foregroundColor(.black)
                }
                .onAppear {
                    withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                        pulseScale = 1.15
                    }
                }

                Text("ReflexTest")
                    .font(.system(size: 40, weight: .bold, design: .rounded))
                    .foregroundColor(Color.theme.textPrimary)

                Text("Test your reaction speed")
                    .font(.body)
                    .foregroundColor(Color.theme.textSecondary)
            }

            Spacer()

            VStack(spacing: 12) {
                PrimaryButton(title: "Start") {
                    onStart()
                }

                SecondaryButton(title: "Leaderboard", icon: "trophy.fill") {
                    onLeaderboard()
                }
            }
            .padding(.horizontal, 32)
            .padding(.bottom, 48)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.theme.background)
    }
}
