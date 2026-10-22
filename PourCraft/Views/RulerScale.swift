import CoreGraphics

/// Maps a stepped range of grams onto a ruler. Tick `i` and the marker for
/// the value it represents share one x position, so tapping a tick selects
/// exactly that value.
struct RulerScale {
    let range: ClosedRange<Double>
    let step: Double

    /// One tick per step, including both ends.
    var tickCount: Int {
        Int(((range.upperBound - range.lowerBound) / step).rounded()) + 1
    }

    /// Center of tick `index`. Ticks are 1 pt wide, so centers run from
    /// 0.5 to `width - 0.5`.
    func x(forTick index: Int, width: CGFloat) -> CGFloat {
        guard tickCount > 1 else { return width / 2 }
        return 0.5 + (width - 1) * CGFloat(index) / CGFloat(tickCount - 1)
    }

    /// Center of the marker for `value`; on-grid values land on their tick.
    func x(for value: Double, width: CGFloat) -> CGFloat {
        let span = range.upperBound - range.lowerBound
        guard span > 0 else { return width / 2 }
        let fraction = (BrewModel.clamped(value, to: range) - range.lowerBound) / span
        return 0.5 + (width - 1) * CGFloat(fraction)
    }

    /// The on-grid value under a touch at `x`, clamped to the range.
    func value(at x: CGFloat, width: CGFloat) -> Double {
        guard width > 1 else { return range.lowerBound }
        let fraction = Double(min(max((x - 0.5) / (width - 1), 0), 1))
        let raw = range.lowerBound + fraction * (range.upperBound - range.lowerBound)
        return BrewModel.snapped(raw, step: step, in: range)
    }
}
