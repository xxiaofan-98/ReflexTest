import SwiftUI

struct LeaderboardView: View {
    @StateObject private var viewModel = LeaderboardViewModel()
    let onStartTest: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            if viewModel.isEmpty {
                emptyState
            } else {
                listContent
            }
        }
        .background(Color.theme.background)
        .navigationTitle("Leaderboard")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            if !viewModel.isEmpty {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Button(role: .destructive) {
                            viewModel.showClearConfirmation = true
                        } label: {
                            Label("Clear All Records", systemImage: "trash")
                        }
                    } label: {
                        Image(systemName: "ellipsis.circle")
                            .font(.body.weight(.medium))
                            .foregroundColor(Color.theme.textSecondary)
                    }
                }
            }
        }
        .alert("Clear All Records?", isPresented: $viewModel.showClearConfirmation) {
            Button("Cancel", role: .cancel) {}
            Button("Clear All", role: .destructive) {
                viewModel.clearAll()
            }
        } message: {
            Text("This will permanently delete all your reaction time records.")
        }
        .onAppear {
            viewModel.loadRecords()
        }
    }

    // MARK: - Empty State

    private var emptyState: some View {
        VStack(spacing: 20) {
            Spacer()

            Image(systemName: "trophy")
                .font(.system(size: 64))
                .foregroundColor(Color.theme.textSecondary.opacity(0.5))

            Text("No Records Yet")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(Color.theme.textPrimary)

            Text("Complete a reaction test to see\nyour results here")
                .font(.body)
                .foregroundColor(Color.theme.textSecondary)
                .multilineTextAlignment(.center)

            PrimaryButton(title: "Start a Test") {
                onStartTest()
            }
            .padding(.horizontal, 48)
            .padding(.top, 8)

            Spacer()
        }
    }

    // MARK: - List Content

    private var listContent: some View {
        VStack(spacing: 0) {
            Picker("Sort", selection: $viewModel.sortMode) {
                ForEach(LeaderboardSortMode.allCases, id: \.self) { mode in
                    Text(mode.rawValue)
                }
            }
            .pickerStyle(.segmented)
            .padding(.horizontal, 20)
            .padding(.vertical, 12)

            if let best = viewModel.personalBest {
                personalBestBanner(best)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 12)
            }

            List {
                ForEach(Array(viewModel.sortedRecords.enumerated()), id: \.element.id) { index, record in
                    LeaderboardRow(
                        rank: index + 1,
                        record: record,
                        displayMode: viewModel.sortMode
                    )
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)
                    .listRowInsets(EdgeInsets(top: 4, leading: 20, bottom: 4, trailing: 20))
                    .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                        Button(role: .destructive) {
                            viewModel.deleteRecord(record)
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                    }
                }
            }
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
        }
    }

    // MARK: - Personal Best Banner

    private func personalBestBanner(_ record: ReactionRecord) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Personal Best")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.black.opacity(0.7))

                Text("\(record.averageTimeMs) ms")
                    .font(.system(size: 24, weight: .bold, design: .monospaced))
                    .foregroundColor(.black)
                    .monospacedDigit()
            }

            Spacer()

            Image(systemName: "star.fill")
                .font(.title2)
                .foregroundColor(.black.opacity(0.3))
        }
        .padding(16)
        .background(
            LinearGradient(
                colors: [Color.theme.accentGreen, Color.theme.accentGreen.opacity(0.8)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(12)
    }
}
