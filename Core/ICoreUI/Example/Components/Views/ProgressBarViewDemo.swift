//
//  ProgressBarViewDemo.swift
//  ICoreUIExample
//

import SwiftUI
import ICoreUI

struct ProgressBarViewDemo: View {
    var body: some View {
        DemoScreen(
            title: "ProgressBarView",
            interactive: { Interactive() },
            combinations: { Combinations() }
        )
    }
}

// MARK: - Interactive

private struct Interactive: View {
    @State private var current: Int = 5
    @State private var batchSize: Int = 20
    @State private var interval: CGFloat = 60
    @State private var barHeight: CGFloat = 6
    @State private var hasOnBatchAdded: Bool = true

    var body: some View {
        InteractiveScroll {
            PreviewSurface {
                ProgressBarView(
                    current: current,
                    batchSize: batchSize,
                    interval: TimeInterval(interval),
                    barHeight: barHeight,
                    onBatchAdded: hasOnBatchAdded ? {} : nil
                )
            }

            CodeBlock(code: codeSnippet)

            ControlsSection(title: "Content") {
                StepperRow(label: "Current", value: $current, range: 0...100)
                StepperRow(label: "Batch size", value: $batchSize, range: 1...50)
                SliderRow(label: "Interval (s)", value: $interval, range: 10...120, step: 10)
                SliderRow(label: "Bar height", value: $barHeight, range: 4...12, step: 1)
                Toggle("Has onBatchAdded", isOn: $hasOnBatchAdded).font(.subheadline)
            }
        }
    }

    private var codeSnippet: String {
        swiftCall(
            "ProgressBarView",
            positional: [],
            arguments: [
                ("current",       "\(current)"),
                ("batchSize",     "\(batchSize)"),
                ("interval",      "\(Int(interval))"),
                ("barHeight",     "\(Int(barHeight))"),
                ("onBatchAdded",  hasOnBatchAdded ? "{ /* loaded */ }" : nil),
            ]
        )
    }
}

// MARK: - Combinations

private struct Combinations: View {
    var body: some View {
        CombinationsScroll {
            CombinationGroup(title: "Empty (0 of 20)") {
                ProgressBarView(current: 0, batchSize: 20)
            }

            CombinationGroup(title: "Partial (5 of 20)") {
                ProgressBarView(current: 5, batchSize: 20)
            }

            CombinationGroup(title: "Half (10 of 20)") {
                ProgressBarView(current: 10, batchSize: 20)
            }

            CombinationGroup(title: "Full (20 of 20)") {
                ProgressBarView(current: 20, batchSize: 20)
            }

            CombinationGroup(title: "Small batch (batch 5, interval 30s)") {
                ProgressBarView(current: 2, batchSize: 5, interval: 30)
            }

            CombinationGroup(title: "Thick bar (height 12)") {
                ProgressBarView(current: 8, batchSize: 20, barHeight: 12)
            }
        }
    }
}

#Preview {
    NavigationStack { ProgressBarViewDemo() }
}
