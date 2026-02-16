//
//  ViewModifiers.swift
//  Lumin
//
//  Created by James on 11/01/2026.
//

import Foundation
import SwiftUI

struct WhiteBodyText: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundStyle(.white)
            .font(.system(size: 15, weight: .regular))
    }
}

extension View {
    func whiteBodyText() -> some View {
        self.modifier(WhiteBodyText())
    }
}



struct WhiteTitleText: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundStyle(Color(red: 0.8, green: 0.8, blue: 0.8))
            .font(.system(size: 15, weight: .semibold))
    }
}

extension View {
    func whiteTitleText() -> some View {
        self.modifier(WhiteTitleText())
    }
}



struct WhiteLargeTitleText: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundStyle(Color(red: 1, green: 1, blue: 1))
            .font(.system(size: 28, weight: .bold))
    }
}

extension View {
    func whiteLargeTitleText() -> some View {
        self.modifier(WhiteLargeTitleText())
    }
}



struct GreenTitleText: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundStyle(.green)
            .font(.system(size: 20, weight: .regular))
    }
}

extension View {
    func greenTitleText() -> some View {
        self.modifier(GreenTitleText())
    }
}



struct RedTitleText: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundStyle(.red)
            .font(.system(size: 20, weight: .regular))
    }
}

extension View {
    func redTitleText() -> some View {
        self.modifier(RedTitleText())
    }
}



struct CustomContainer: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(.ultraThinMaterial.opacity(0.2))
    }
}

extension View {
    func customContainer() -> some View {
        self.modifier(CustomContainer())
    }
}



struct CustomBackground: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(red: 0.05, green: 0.05, blue: 0.05))
    }
}

extension View {
    func customBackground() -> some View {
        self.modifier(CustomBackground())
    }
}
