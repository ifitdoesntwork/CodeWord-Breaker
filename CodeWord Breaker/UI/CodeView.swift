//
//  CodeView.swift
//  CodeWord Breaker
//
//  Created by Denis Avdeev on 25.12.2025.
//

import SwiftUI

struct CodeView: View {
    // MARK: Data In
    let code: Code
    let masterCode: Code?
    
    // MARK: Data Shared with Me
    @Binding var selection: Int
    @Binding var hidesMasterCode: Bool
    
    // MARK: Data Owned by Me
    @Namespace private var selectionNamespace
    
    init(
        code: Code,
        masterCode: Code? = nil,
        selection: Binding<Int> = .constant(-1),
        hidesMasterCode: Binding<Bool> = .constant(false)
    ) {
        self.code = code
        self._selection = selection
        self._hidesMasterCode = hidesMasterCode
        self.masterCode = masterCode
    }
    
    // MARK: - Body
    
    var body: some View {
        HStack {
            ForEach(code.pegs.indices, id: \.self) { index in
                viewForPeg(at: index)
                    .onTapGesture {
                        if code.kind == .guess {
                            selection = index
                        }
                    }
            }
        }
    }
    
    func viewForPeg(at index: Int) -> some View {
        let hidesCode = code.isHidden
        || (code.kind == .master(isHidden: false) && hidesMasterCode)
        
        return PegView(
            peg: hidesCode ? .missing : code.pegs[index],
            match: masterCode
                .map { code.match(against: $0)[index] }
        )
        .contentShape(Rectangle())
        .padding(Selection.border)
        .background { viewForSelection(at: index) }
        .overlay {
            Selection.shape
                .foregroundStyle(code.isHidden ? Color.gray : .clear)
        }
    }
    
    func viewForSelection(at index: Int) -> some View {
        Group {
            if selection == index, code.kind == .guess {
                Selection.shape
                    .foregroundStyle(Selection.color)
                    .matchedGeometryEffect(
                        id: "selection",
                        in: selectionNamespace
                    )
            }
        }
        .animation(.selection, value: selection)
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
        selection: .constant(1)
    )
    .padding()
}
