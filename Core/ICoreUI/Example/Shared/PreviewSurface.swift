//
//  PreviewSurface.swift
//  ICoreUIExample
//
//  Soft, padded canvas used to render a component preview.
//

import SwiftUI
import ICoreUI

struct PreviewSurface<Content: View>: View {
    let title: String
    let alignment: HorizontalAlignment
    @ViewBuilder var content: () -> Content

    init(
        title: String = "Preview",
        alignment: HorizontalAlignment = .center,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.title = title
        self.alignment = alignment
        self.content = content
    }

    var body: some View {
        VStack(alignment: .leading, spacing: small) {
            Text(title.uppercased())
                .font(.caption.weight(.semibold))
                .tracking(0.6)
                .foregroundStyle(Color.foregroundMuted)

            VStack(alignment: alignment) {
                content()
                    .frame(
                        maxWidth: .infinity,
                        alignment: Alignment(horizontal: alignment, vertical: .center)
                    )
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal, medium)
            .padding(.vertical, mediumBig)
            .background(Color.background)
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .stroke(Color.foregroundMuted.opacity(0.15), lineWidth: 1)
            )
        }
    }
}

/// Standard scroll wrapper for the Interactive tab.
struct InteractiveScroll<Content: View>: View {
    @ViewBuilder var content: () -> Content
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: medium) {
                content()
            }
            .padding(medium)
        }
    }
}

/// Standard scroll wrapper for the Combinations tab.
struct CombinationsScroll<Content: View>: View {
    @ViewBuilder var content: () -> Content
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: mediumBig) {
                content()
            }
            .padding(medium)
        }
    }
}

/// Section header used inside the Combinations tab.
struct CombinationGroup<Content: View>: View {
    let title: String
    @ViewBuilder var content: () -> Content

    var body: some View {
        VStack(alignment: .leading, spacing: small) {
            Text(title.uppercased())
                .font(.caption.weight(.bold))
                .tracking(0.8)
                .foregroundStyle(Color.foregroundMuted)
            content()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
