//
//  ScaffoldHeaderModifier.swift
//  ICoreUI
//
//  Bauhaus scaffold header — surface bg with a 2pt bottom border.
//  No blur, no gradient fade — direct and honest.
//

import SwiftUI

struct ScaffoldHeaderModifier<Header: View>: ViewModifier {
    let header: Header
    let headerHeight: CGFloat

    init(
        @ViewBuilder header: () -> Header,
        headerHeight: CGFloat = 60
    ) {
        self.header = header()
        self.headerHeight = headerHeight
    }

    func body(content: Content) -> some View {
        ZStack(alignment: .top) {
            ScrollView {
                content
                    .padding(.horizontal, medium)
            }
            .safeAreaInset(edge: .top) {
                Color.clear.frame(height: headerHeight)
            }

            VStack(spacing: 0) {
                header
                    .frame(height: headerHeight)
                    .frame(maxWidth: .infinity)
                    .background(Color.surface)

                Rectangle()
                    .fill(Color.border)
                    .frame(height: borderThin)
            }
        }
    }
}

public extension View {
    /// Adds a fixed Bauhaus header (surface bg + bottom border) above scrollable content.
    func scaffoldHeader<Header: View>(
        headerHeight: CGFloat = 60,
        @ViewBuilder header: () -> Header
    ) -> some View {
        modifier(ScaffoldHeaderModifier(header: header, headerHeight: headerHeight))
    }

    func scaffoldHeader(
        _ title: String,
        accessory: HeaderAccessory? = nil,
        headerHeight: CGFloat = 60,
        horizontalPadding: CGFloat = medium
    ) -> some View {
        modifier(ScaffoldHeaderModifier(
            header: {
                Group {
                    if let accessory {
                        HeaderView(title, accessory: accessory)
                    } else {
                        HeaderView(title)
                    }
                }
                .padding(.horizontal, horizontalPadding)
            },
            headerHeight: headerHeight
        ))
    }
}

// MARK: - Preview

private struct ScrollingContentPreview: View {
    var body: some View {
        VStack(spacing: mediumBig) {
            ForEach(0..<20) { index in
                Rectangle()
                    .fill(Color.surface)
                    .frame(height: 80)
                    .overlay(Rectangle().stroke(Color.border, lineWidth: borderThin))
                    .overlay(
                        Text("ITEM \(index + 1)")
                            .font(.caption.bold())
                            .tracking(2)
                            .foregroundStyle(.foreground)
                    )
            }
        }
        .scaffoldHeader {
            HeaderView("My Words", chipLabel: "🔥 12", chipStyle: .warning)
                .padding(.horizontal, medium)
        }
        .scaffoldBackground()
    }
}

#Preview("Light") {
    ScrollingContentPreview()
}

#Preview("Dark") {
    ScrollingContentPreview().preferredColorScheme(.dark)
}
