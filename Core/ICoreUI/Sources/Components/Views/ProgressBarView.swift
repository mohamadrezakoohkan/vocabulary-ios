//
//  ProgressBarView.swift
//  ICoreUI
//
//  Session progress bar — animated fill, elapsed/total timer labels,
//  and a centered "X of Y" counter that auto-increments the total
//  every `interval` seconds.
//
//  AI Instructions:
//  - This component follows Apple Human Interface Guidelines.
//  - The bar uses a capsule shape with .muted background and .primaryBlue fill.
//  - Timer labels: elapsed on the left, total duration on the right,
//    centered counter in the middle. All use .caption.monospacedDigit().
//  - The component owns a Timer that ticks every second to update the
//    elapsed time. Every `interval` seconds the `total` increments by
//    `batchSize` and `onBatchAdded` fires so callers can load more data.
//  - `current` is caller-driven (e.g. how many cards have been reviewed).
//  - Demo: Core/ICoreUI/Example/Components/Views/ProgressBarViewDemo.swift
//    Update the Interactive controls and Combinations gallery there
//    whenever the public API changes.
//

import SwiftUI

public struct ProgressBarView: View {
    private let current: Int
    private let batchSize: Int
    private let interval: TimeInterval
    private let barHeight: CGFloat
    private let onBatchAdded: (() -> Void)?

    @State private var elapsedSeconds: Int = 0
    @State private var batchCount: Int = 1
    @State private var timer: Timer?

    private var total: Int { batchCount * batchSize }
    private var totalDurationSeconds: Int { batchCount * Int(interval) }

    private var progress: CGFloat {
        guard total > 0 else { return 0 }
        return min(CGFloat(current) / CGFloat(total), 1.0)
    }

    public init(
        current: Int,
        batchSize: Int = 20,
        interval: TimeInterval = 60,
        barHeight: CGFloat = 6,
        onBatchAdded: (() -> Void)? = nil
    ) {
        self.current = current
        self.batchSize = batchSize
        self.interval = interval
        self.barHeight = barHeight
        self.onBatchAdded = onBatchAdded
    }

    public var body: some View {
        VStack(spacing: small) {
            bar

            HStack {
                if interval > 0 {
                    Text(formatTime(elapsedSeconds))
                        .font(.caption.monospacedDigit())
                        .foregroundStyle(Color.foregroundMuted)

                    Spacer()
                }

                Text("\(current) of \(total)")
                    .font(.caption.weight(.semibold).monospacedDigit())
                    .foregroundStyle(Color.foregroundMuted)

                if interval > 0 {
                    Spacer()

                    Text(formatTime(totalDurationSeconds))
                        .font(.caption.monospacedDigit())
                        .foregroundStyle(Color.foregroundMuted)
                }
            }
        }
        .onAppear {
            if interval > 0 { startTimer() }
        }
        .onDisappear { stopTimer() }
    }

    // MARK: - Bar

    private var bar: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                Capsule()
                    .fill(Color.muted)

                Capsule()
                    .fill(Color.primaryBlue)
                    .frame(width: max(geo.size.width * progress, barHeight))
                    .animation(.easeInOut(duration: 0.3), value: progress)
            }
        }
        .frame(height: barHeight)
    }

    // MARK: - Timer

    private func startTimer() {
        stopTimer()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            elapsedSeconds += 1

            if elapsedSeconds > 0,
               elapsedSeconds.isMultiple(of: Int(interval)) {
                batchCount += 1
                onBatchAdded?()
            }
        }
    }

    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }

    // MARK: - Formatting

    private func formatTime(_ seconds: Int) -> String {
        let m = seconds / 60
        let s = seconds % 60
        return String(format: "%d:%02d", m, s)
    }
}

// MARK: - Preview

private struct ProgressBarPreview: View {
    var body: some View {
        VStack(spacing: mediumBig) {
            ProgressBarView(current: 0)

            ProgressBarView(current: 5, batchSize: 20)

            ProgressBarView(current: 12, batchSize: 20)

            ProgressBarView(current: 20, batchSize: 20)
        }
        .padding(medium)
        .background(.background)
    }
}

#Preview("Light Mode") {
    ProgressBarPreview().preferredColorScheme(.light)
}

#Preview("Dark Mode") {
    ProgressBarPreview().preferredColorScheme(.dark)
}
