import SwiftUI

struct ResultView: View {
    @StateObject private var viewModel: ResultViewModel
    let onTryAgain: () -> Void
    let onHome: () -> Void

    @State private var cardsAppeared = false

    init(resultData: ResultData, onTryAgain: @escaping () -> Void, onHome: @escaping () -> Void) {
        _viewModel = StateObject(wrappedValue: ResultViewModel(resultData: resultData))
        self.onTryAgain = onTryAgain
        self.onHome = onHome
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                headerSection
                statsSection
                roundsSection
                actionsSection
            }
            .padding(.horizontal, 20)
            .padding(.top, 8)
            .padding(.bottom, 16)
        }
        .background(Color.theme.background)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    onHome()
                } label: {
                    Image(systemName: "xmark")
                        .font(.body.weight(.semibold))
                        .foregroundColor(Color.theme.textPrimary)
                }
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.5).delay(0.2)) {
                cardsAppeared = true
            }
        }
    }

    // MARK: - Sections

    private var headerSection: some View {
        VStack(spacing: 6) {
            Text("Your Results")
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(Color.theme.textSecondary)

            CountUpText(
                targetValue: viewModel.resultData.averageTimeMs,
                font: .system(size: 48, weight: .bold, design: .monospaced)
            )

            Text("average reaction time")
                .font(.caption)
                .foregroundColor(Color.theme.textSecondary)

            Text(ReactionRecord.ratingFor(ms: viewModel.resultData.averageTimeMs))
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(Color.theme.accentGreen)
                .padding(.top, 2)
        }
        .padding(.vertical, 8)
    }

    private var statsSection: some View {
        HStack(spacing: 12) {
            StatCard(title: "Best", value: viewModel.resultData.bestTimeMs)
            StatCard(title: "Worst", value: viewModel.resultData.worstTimeMs)
            StatCard(title: "Median", value: viewModel.resultData.medianTimeMs)
        }
        .offset(y: cardsAppeared ? 0 : 30)
        .opacity(cardsAppeared ? 1 : 0)
    }

    private var roundsSection: some View {
        VStack(spacing: 8) {
            Text("Round Breakdown")
                .font(.headline)
                .foregroundColor(Color.theme.textPrimary)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom, 4)

            ForEach(Array(viewModel.resultData.roundTimes.enumerated()), id: \.offset) { index, time in
                RoundResultRow(
                    roundNumber: index + 1,
                    timeMs: time,
                    isBest: time == viewModel.resultData.bestTimeMs,
                    isWorst: time == viewModel.resultData.worstTimeMs
                )
            }
        }
    }

    private var actionsSection: some View {
        HStack(spacing: 12) {
            PrimaryButton(title: "Try Again") {
                onTryAgain()
            }

            ShareLink(item: viewModel.shareText) {
                HStack(spacing: 6) {
                    Image(systemName: "square.and.arrow.up")
                        .font(.body.weight(.semibold))
                    Text("Share")
                        .font(.headline)
                        .fontWeight(.semibold)
                }
                .foregroundColor(Color.theme.textPrimary)
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .background(Color.theme.surface)
                .cornerRadius(16)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.theme.border, lineWidth: 1)
                )
            }
        }
        .padding(.top, 4)
    }
}
