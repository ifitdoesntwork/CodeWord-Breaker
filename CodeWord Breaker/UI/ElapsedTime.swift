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
    let endTime: Date?
    let elapsedTime: TimeInterval
    
    var format: SystemFormatStyle.DateOffset {
        .offset(
            to: (startTime ?? endTime ?? .now) - elapsedTime,
            allowedFields: [.minute, .second]
        )
    }
    
    var body: some View {
        Group {
            if elapsedTime == .zero && startTime == nil {
                Text("-:--") // new game
            } else if let endTime {
                Text(endTime, format: format) // ended
            } else if startTime == nil {
                Text(.now, format: format) // paused
            } else {
                Text(TimeDataSource<Date>.currentDate, format: format) // running
            }
        }
        .monospaced()
    }
}

#Preview {
    List {
        HStack {
            Text("New Game")
            Spacer()
            ElapsedTime(
                startTime: nil,
                endTime: nil,
                elapsedTime: .zero
            )
        }
        HStack {
            Text("Running")
            Spacer()
            ElapsedTime(
                startTime: .now,
                endTime: nil,
                elapsedTime: .minute
            )
        }
        HStack {
            Text("Paused")
            Spacer()
            ElapsedTime(
                startTime: nil,
                endTime: nil,
                elapsedTime: .minute
            )
        }
        HStack {
            Text("Ended")
            Spacer()
            ElapsedTime(
                startTime: nil,
                endTime: .now,
                elapsedTime: .minute
            )
        }
    }
}
