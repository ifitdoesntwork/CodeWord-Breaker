//
//  CodeView.swift
//  CodeWord Breaker
//
//  Created by Denis Avdeev on 25.12.2025.
//

import SwiftUI

struct CodeView<AncillaryView>: View where AncillaryView: View {
    // MARK: Data In
    let code: Code
    let masterCode: Code?
    
    // MARK: Data Shared with Me
    @Binding var selection: Int
    
    // MARK: Data (sort of) In Function
    @ViewBuilder let ancillaryView: () -> AncillaryView
    
    init(
        code: Code,
        masterCode: Code? = nil,
        selection: Binding<Int> = .constant(-1),
        @ViewBuilder ancillaryView: @escaping () -> AncillaryView = { EmptyView() }
    ) {
        self.code = code
        self._selection = selection
        self.ancillaryView = ancillaryView
        self.masterCode = masterCode
    }
    
    // MARK: - Body
    
    var body: some View {
        HStack {
            ForEach(code.pegs.indices, id: \.self) { index in
                PegView(
                    peg: code.pegs[index],
                    match: masterCode
                        .map { code.match(against: $0)[index] }
                )
                .contentShape(Rectangle())
                    .padding(Selection.border)
                    .background {
                        if selection == index, code.kind == .guess {
                            Selection.shape
                                .foregroundStyle(Selection.color)
                        }
                    }
                    .overlay {
                        Selection.shape
                            .foregroundStyle(code.isHidden ? Color.gray : .clear)
                    }
                    .onTapGesture {
                        if code.kind == .guess {
                            selection = index
                        }
                    }
            }
            Color.clear.aspectRatio(1, contentMode: .fit)
                .overlay {
                    ancillaryView()
                }
        }

    }
}

fileprivate struct Selection {
    static let border: CGFloat = 5
    static let cornerRadius: CGFloat = 10
    static let color: Color = Color.gray(0.85)
    static let shape = RoundedRectangle(cornerRadius: cornerRadius)
}

#Preview {
    CodeView(
        code: .init(kind: .guess, pegs: ["A", "B", "C", "D"]),
        masterCode: .init(kind: .master(isHidden: true), pegs: ["A", "A", "B"]),
        selection: .constant(1),
        ancillaryView: { Button("Guess") {}.flexibleSystemFont() }
    )
    .padding()
}
