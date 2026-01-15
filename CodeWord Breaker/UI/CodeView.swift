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
    
    // MARK: Data Owned by Me
    @State var celebration: Int?
    @Namespace private var namespace
    
    init(
        code: Code,
        masterCode: Code? = nil,
        selection: Binding<Int> = .constant(-1)
    ) {
        self.code = code
        self._selection = selection
        self.masterCode = masterCode
    }
    
    // MARK: - Body
    
    var body: some View {
        HStack {
            ForEach(code.pegs.indices, id: \.self) { index in
                peg(at: index)
                    .onTapGesture {
                        if code.kind == .guess {
                            selection = index
                        }
                    }
            }
        }
        .onChange(of: code.isHidden) { configureCelebration(isHidden: $1) }
        .onAppear {
            if code.kind == .master(isHidden: false) {
                configureCelebration(isHidden: false)
            }
        }
        .onDisappear {
            celebration = nil
        }
    }
    
    func peg(at index: Int) -> some View {
        PegView(
            peg: code.isHidden ? .missing : code.pegs[index],
            match: masterCode
                .map { code.match(against: $0)[index] }
        )
        .celebration(isOn: celebration == index)
        .contentShape(Rectangle())
        .padding(Selection.border)
        .background { selection(at: index) }
        .overlay {
            Selection.shape
                .foregroundStyle(code.isHidden ? Color.gray : .clear)
        }
    }
    
    func selection(at index: Int) -> some View {
        Group {
            if selection == index, code.kind == .guess {
                Selection.shape
                    .foregroundStyle(Selection.color)
                    .matchedGeometryEffect(id: "selection", in: namespace)
            }
        }
        .animation(.selection, value: selection)
    }
    
    func configureCelebration(isHidden: Bool) {
        guard !isHidden else {
            celebration = nil
            return
        }
        
        withAnimation {
            celebration = ((celebration ?? -1) + 1) % code.pegs.count
        } completion: {
            if celebration != nil {
                configureCelebration(isHidden: false)
            }
        }
    }
}

fileprivate struct Selection {
    static let border: CGFloat = 5
    static let cornerRadius: CGFloat = 10
    static let color: Color = .init(light: .gray(0.85), dark: .gray(0.35))
    static let shape = RoundedRectangle(cornerRadius: cornerRadius)
}

#Preview {
    @Previewable @State var selection = 1
    @Previewable @State var isHidden = true
    let pegs = ["A", "B", "C", "D"]
    
    VStack {
        Button("Toggle Celebration") {
            withAnimation(.easeInOut(duration: 1)) {
                isHidden.toggle()
            }
        }
        CodeView(
            code: .init(
                kind: .master(isHidden: isHidden),
                pegs: pegs
            )
        )
        CodeView(
            code: .init(kind: .guess, pegs: pegs),
            selection: $selection
        )
        CodeView(
            code: .init(kind: .guess, pegs: pegs),
            masterCode: .init(
                kind: .master(isHidden: true),
                pegs: ["A", "C", "E", "D"]
            )
        )
    }
    .padding()
}
