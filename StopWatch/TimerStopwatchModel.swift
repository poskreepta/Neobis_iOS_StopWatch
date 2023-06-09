//
//  TimerStopwatchModel.swift
//  StopWatch
//
//  Created by poskreepta on 11.04.23.
//

import UIKit

struct TimerStopwatchModel {
    
    var hoursDigit: Array<Int> {
        return Array(0...12)
    }
    
    var minutesDigit: Array<Int> {
            return Array(0...60)
        }
    
    var secondsDigit: Array<Int> {
        return Array(0...60)
    }
    
    
    func secondsToHoursMinutesSecondsString(_ seconds: Int) -> (String) {
        let hours = seconds / 3600
        let minutes = (seconds % 3600) / 60
        let seconds = (seconds % 3600) % 60
    
        let timeString = makeTimeString(hours: hours, minutes: minutes, seconds: seconds)
        return timeString
    }

    func hoursMinutesSecondsToSeconds(hours: Int, minutes: Int, seconds: Int) -> Int {
        return hours * 3600 + minutes * 60 + seconds
    }
    
    func makeTimeString(hours: Int, minutes: Int, seconds: Int ) -> String {
        
        var timeString = String(format: "%02i:%02i:%02i", hours, minutes, seconds)
        return timeString
        
    }

    
}
