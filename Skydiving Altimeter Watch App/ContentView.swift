//
//  ContentView.swift
//  Skydiving Altimeter Watch App
//
//  Created by Brian Johnson on 3/31/24.
//

import SwiftUI
import CoreMotion

class Altitude: ObservableObject {
    @Published var value = 0 {
        didSet {
            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = .decimal
            textValue = numberFormatter.string(from: NSNumber(value:value))!
        }
    }
    @Published var textValue = "0"
    @Published var altimeter = CMAltimeter()
    @Published var motionManager = CMMotionActivityManager()
    init() {
        self.motionManager.queryActivityStarting(from: .now, to: .now, to: .main) { _, _
            in
            if CMAltimeter.isAbsoluteAltitudeAvailable() {
                self.value = 10
                self.altimeter.startAbsoluteAltitudeUpdates(to: OperationQueue.main) { (data, error) in
                    self.value = Int(data?.altitude ?? 0)
                }
            } else {
                self.value = 100
            }}
    }
    deinit {
        if CMAltimeter.isAbsoluteAltitudeAvailable() {
            self.altimeter.stopAbsoluteAltitudeUpdates()
        }
    }
}

struct ContentView: View {
    @StateObject var altitude = Altitude()
        
    var body: some View {
        VStack {
            Text("\(altitude.textValue) ft")
                        .font(.largeTitle)
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
