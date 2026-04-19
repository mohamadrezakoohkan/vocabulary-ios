//
//  ScaffoldEmptyStateModifier.swift
//  ICoreUI
//

import SwiftUI

public struct EmptyStateConfig {
    public let icon: Icons
    public let title: String
    public let message: String?
    public let actionTitle: String?
    public let action: (() -> Void)?

    public init(
        icon: Icons,
        title: String,
        message: String? = nil,
        actionTitle: String? = nil,
        action: (() -> Void)? = nil
    ) {
        self.icon = icon
        self.title = title
        self.message = message
        self.actionTitle = actionTitle
        self.action = action
    }
}

struct ScaffoldEmptyStateModifier: ViewModifier {
    let isEmpty: Bool
    let config: EmptyStateConfig

    func body(content: Content) -> some View {
        ZStack {
            content.opacity(isEmpty ? 0 : 1)
            if isEmpty {
                EmptyStateView(config: config)
            }
        }
        .animation(.easeInOut(duration: 0.25), value: isEmpty)
    }
}

private struct EmptyStateView: View {
    let config: EmptyStateConfig

    var body: some View {
        VStack(spacing: medium) {
            Icon(config.icon, size: .custom(extraBig))
                .foregroundStyle(Color.foregroundMuted)

            VStack(spacing: small) {
                Text(config.title)
                    .font(.title2.weight(.black))
                    .textCase(.uppercase)
                    .tracking(-0.3)
                    .foregroundStyle(.foreground)
                    .multilineTextAlignment(.center)

                if let message = config.message {
                    Text(message)
                        .font(.subheadline)
                        .foregroundStyle(Color.foregroundMuted)
                        .multilineTextAlignment(.center)
                }
            }

            if let actionTitle = config.actionTitle, let action = config.action {
                Button(action: action) {
                    Text(actionTitle)
                }
                .buttonStyle(.app(variant: .primary, cornerStyle: .capsule))
                .padding(.top, small)
            }
        }
        .padding(big)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

public extension View {
    func scaffoldEmptyState(_ isEmpty: Bool, config: EmptyStateConfig) -> some View {
        modifier(ScaffoldEmptyStateModifier(isEmpty: isEmpty, config: config))
    }

    func scaffoldEmptyState(
        _ isEmpty: Bool,
        icon: Icons,
        title: String,
        message: String? = nil
    ) -> some View {
        modifier(ScaffoldEmptyStateModifier(
            isEmpty: isEmpty,
            config: EmptyStateConfig(icon: icon, title: title, message: message)
        ))
    }
}

#Preview("Empty State") {
    VStack {}
        .scaffoldBackground()
        .scaffoldEmptyState(
            true,
            config: EmptyStateConfig(
                icon: .leaf,
                title: "No memories yet",
                message: "Start capturing moments",
                actionTitle: "Capture",
                action: {}
            )
        )
}
