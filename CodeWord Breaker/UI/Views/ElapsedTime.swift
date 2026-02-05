//
//  ElapsedTime.swift
//  CodeWord Breaker
//
//  Created by Denis Avdeev on 22.01.2026.
//

import SwiftUI

struct ElapsedTime: View {
    // MARK: Data In
    let startTime: Date?
    let isOver: Bool
    let elapsedTime: TimeInterval
    
    // MARK: - Body
    
    var body: some View {
        Group {
            if elapsedTime == .zero && startTime == nil {               // new game
                Text("-:--")
            } else if startTime == nil {                                // paused or over
                Text(.now, format: format)
            } else {                                                    // running
                Text(TimeDataSource<Date>.currentDate, format: format)
            }
        }
        .monospaced()
    }
    
    private var format: SystemFormatStyle.DateOffset {
        .offset(
            to: (startTime ?? .now) - elapsedTime,
            allowedFields: [.minute, .second]
        )
    }
}

#Preview {
    List {
        HStack {
            Text("New Game")
            Spacer()
            ElapsedTime(
                startTime: nil,
                isOver: false,
                elapsedTime: .zero
            )
        }
        HStack {
            Text("Running")
            Spacer()
            ElapsedTime(
                startTime: .now,
                isOver: false,
                elapsedTime: .minute
            )
        }
        HStack {
            Text("Paused")
            Spacer()
            ElapsedTime(
                startTime: nil,
                isOver: false,
                elapsedTime: .minute
            )
        }
        HStack {
            Text("Over")
            Spacer()
            ElapsedTime(
                startTime: nil,
                isOver: true,
                elapsedTime: .minute
            )
        }
    }
}
