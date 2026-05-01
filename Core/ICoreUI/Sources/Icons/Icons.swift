//
//  Icons.swift
//  Drova
//
//  Created by Mohammad reza on 7/3/26.
//
//  AI Instructions:
//  - Demo: Core/ICoreUI/Example/Components/Foundations/IconsDemo.swift
//    Whenever an `Icons` case is added/removed/renamed, also update
//    the `iconCaseName` mapping in Example/Shared/DemoEnums.swift —
//    the demo uses it to render the case name and generate code.
//

import SwiftUI
import Foundation

public enum Icons: String, CaseIterable, Identifiable, Hashable {
    case chevronUp = "chevron.up"
    case chevronDown = "chevron.down"
    case chevronRight = "chevron.right"
    case chevronUpAndDown = "chevron.up.chevron.down"
    case branch = "arrow.trianglehead.branch"
    case leaf = "leaf"
    case leafFill = "leaf.fill"
    case flame = "flame.fill"
    case zzz = "zzz"
    case tornado = "tornado"

    // MARK: - Tab Bar Icons

    case deckTab = "list.star"
    case studyTab = "square.stack.3d.up.fill"
    case statsTab = "chart.bar.xaxis"

    case arrowRight = "arrow.right"
    case checkmark = "checkmark"
    case checkmarkCircleFill = "checkmark.circle.fill"
    case xmarkCircleFill = "xmark.circle.fill"
    case clockFill = "clock.fill"
    case warning = "exclamationmark.triangle.fill"
    case infoCircleFill = "info.circle.fill"
    case heart = "heart.fill"
    case star = "star.fill"
    case bell = "bell.fill"
    case bookmark = "bookmark.fill"
    case camera = "camera.fill"
    case cloud = "cloud.fill"
    case folder = "folder.fill"
    case gear = "gearshape.fill"
    case house = "house.fill"
    case lock = "lock.fill"
    case magnifyingGlass = "magnifyingglass"
    case mapPin = "mappin.circle.fill"
    case message = "message.fill"
    case moon = "moon.fill"
    case paperplane = "paperplane.fill"
    case person = "person.fill"
    case phone = "phone.fill"
    case photo = "photo.fill"
    case trash = "trash.fill"
    case speaker = "speaker.wave.2.fill"
    case wifi = "wifi"

    public var id: String {
        rawValue
    }
}

public struct Icon: View {
    public enum Size {
        case small
        case normal
        case large
        case custom(CGFloat)

        public var font: CGFloat {
            switch self {
            case .small:
                10
            case .normal:
                medium
            case .large:
                big
            case .custom(let value):
                value
            }
        }

        public var frame: CGFloat {
            switch self {
            case .small:
                14
            case .normal:
                mediumBig
            case .large:
                extraBig
            case .custom(let value):
                value + 6
            }
        }
    }
    private let iconName: String
    private let size: Icon.Size
    private let color: Color?
    private let animated: Bool

    public init(_ icon: Icons, size: Icon.Size = Icon.Size.normal, color: Color? = nil, animated: Bool = true) {
        self.iconName = icon.rawValue
        self.size = size
        self.color = color
        self.animated = animated
    }
    
    public init(iconName: String, size: Icon.Size = Icon.Size.normal, color: Color? = nil, animated: Bool = true) {
        self.iconName = iconName
        self.size = size
        self.color = color
        self.animated = animated
    }

    public var body: some View {
        Image(systemName: iconName)
            .font(.system(size: size.font))
            .frame(width: size.frame, height: size.frame)
            .ifLet(color) { view, value in view.foregroundStyle(value) }
            .contentTransition(animated ? .symbolEffect(.automatic, options: .nonRepeating) : .interpolate)
    }
}

private struct IconsPreview: View {
    @State private var iconSize: CGFloat = 50

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("Size: \(Int(iconSize))")
                    .font(.caption)
                Slider(value: $iconSize, in: 16...80)
            }
            .padding(.horizontal)
            .padding(.vertical, 8)

            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: iconSize + 30), spacing: 4)], spacing: 4) {
                    ForEach(Icons.allCases) { icon in
                        VStack(spacing: 4) {
                            Icon(icon, size: iconSize == medium ? Icon.Size.normal : (iconSize == Icon.Size.large.font ? Icon.Size.large : Icon.Size.custom(iconSize)))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .strokeBorder(style: StrokeStyle(lineWidth: 1, dash: [5]))
                                        .foregroundStyle(.red)
                                )

                            Text(icon.rawValue)
                                .font(.caption2)
                                .lineLimit(1)
                                .minimumScaleFactor(0.5)
                                .multilineTextAlignment(.center)
                        }
                        .frame(minHeight: iconSize + 50)
                    }
                }
                .padding(4)
            }
        }
    }
}
#Preview {
    IconsPreview()
}

