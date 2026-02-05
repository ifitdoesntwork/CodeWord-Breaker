//
//  SwiftDataPreview.swift
//  CodeWord Breaker
//
//  Created by Denis Avdeev on 28.01.2026.
//

import SwiftData
import SwiftUI

extension PreviewTrait<Preview.ViewTraits> {
    @MainActor static var swiftData = Self.modifier(SwiftDataPreview())
}

private struct SwiftDataPreview: PreviewModifier {
    
    static func makeSharedContext() async throws -> Context {
        try ModelContainer(
            for: CodeBreaker.self,
            configurations: ModelConfiguration(isStoredInMemoryOnly: true)
        )
    }
    
    func body(content: Content, context: ModelContainer) -> some View {
        content.modelContainer(context)
    }
}
