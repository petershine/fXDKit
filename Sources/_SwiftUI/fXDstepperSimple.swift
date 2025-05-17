

import SwiftUI


public struct fXDviewStepper: View {
    var minValue: Double
    var maxValue: Double

    @Binding var stepping: Double


    public init(minValue: Double, maxValue: Double, stepping: Binding<Double>) {
        self.minValue = minValue
        self.maxValue = maxValue
        _stepping = stepping
    }

    public var body: some View {
        Stepper("", onIncrement: {
            stepping = min(maxValue, stepping+1.0)
        }, onDecrement: {
            stepping = max(minValue, stepping-1.0)
        })
        .background(.black)
        .tint(.white)
        .labelsHidden()
        .fixedSize()
    }
}
