import SwiftUI

struct ContentView: View {
    @State private var path = NavigationPath()

    var body: some View {
        NavigationStack(path: $path) {
            HomeView(
                onStart: {
                    path.append(AppRoute.game)
                },
                onLeaderboard: {
                    path.append(AppRoute.leaderboard)
                }
            )
            .navigationBarHidden(true)
            .navigationDestination(for: AppRoute.self) { route in
                switch route {
                case .home:
                    EmptyView()

                case .game:
                    GameView(
                        onComplete: { resultData in
                            path.removeLast()
                            path.append(AppRoute.results(resultData))
                        },
                        onBack: {
                            path.removeLast()
                        }
                    )
                    .navigationBarHidden(true)

                case .results(let data):
                    ResultView(
                        resultData: data,
                        onTryAgain: {
                            path.removeLast()
                            path.append(AppRoute.game)
                        },
                        onHome: {
                            path = NavigationPath()
                        }
                    )

                case .leaderboard:
                    LeaderboardView(
                        onStartTest: {
                            path.removeLast()
                            path.append(AppRoute.game)
                        }
                    )
                }
            }
        }
        .preferredColorScheme(.dark)
    }
}
