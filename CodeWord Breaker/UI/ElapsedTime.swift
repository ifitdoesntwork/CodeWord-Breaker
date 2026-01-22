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
        if let endTime {
            Text(endTime, format: format)
        } else {
            if startTime != nil {
                Text(TimeDataSource<Date>.currentDate, format: format)
            } else {
                Image(systemName: "pause")
            }
        }
    }
}

#Preview {
    VStack(spacing: 12) {
        ElapsedTime(
            startTime: .now,
            endTime: nil,
            elapsedTime: 60
        )
        ElapsedTime(
            startTime: nil,
            endTime: nil,
            elapsedTime: 60
        )
        ElapsedTime(
            startTime: nil,
            endTime: .now,
            elapsedTime: 60
        )
    }
}
