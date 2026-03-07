//
//  View+ConditionalModifier.swift
//  DrovaCoreUI
//
//  Created by Mohammad reza on 7/3/26.
//

import SwiftUI

// MARK: - Conditional View Modifier

public extension View {
    @ViewBuilder
    func `if`<Transform: View>(
        _ condition: Bool,
        transform: (Self) -> Transform
    ) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }

    @ViewBuilder
    func `if`<TrueContent: View, FalseContent: View>(
        _ condition: Bool,
        then trueTransform: (Self) -> TrueContent,
        else falseTransform: (Self) -> FalseContent
    ) -> some View {
        if condition {
            trueTransform(self)
        } else {
            falseTransform(self)
        }
    }
    
    @ViewBuilder
    func ifLet<Value, Transform: View>(
        _ value: Value?,
        transform: (Self, Value) -> Transform
    ) -> some View {
        if let value {
            transform(self, value)
        } else {
            self
        }
    }
    
    @ViewBuilder
    func ifLet<Value, TrueContent: View, FalseContent: View>(
        _ value: Value?,
        then transform: (Self, Value) -> TrueContent,
        else falseTransform: (Self) -> FalseContent
    ) -> some View {
        if let value {
            transform(self, value)
        } else {
            falseTransform(self)
        }
    }
}
