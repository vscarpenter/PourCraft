import SwiftUI

/// Hand-drawn ink icon set translated from the Editorial Zine handoff prototypes.
/// Each icon is built from one or more `Path`s in a 24×24 unit space, scaled to
/// the requested size and stroked with the given color and weight.
enum InkIcon: String, CaseIterable {
    case v60
    case kettle
    case scale
    case bloom
    case drop
    case beans
    case thermo
    case spiral
    case timer
    case flame
    case check
    case chevron
    case plus
    case minus
    case stamp
}

struct InkIconView: View {
    let icon: InkIcon
    var size: CGFloat = 22
    var color: Color = .primary
    var strokeWidth: CGFloat = 1.4

    var body: some View {
        Canvas { ctx, canvasSize in
            let scale = canvasSize.width / 24
            let stroke = StrokeStyle(
                lineWidth: strokeWidth, lineCap: .round, lineJoin: .round
            )
            var transform = CGAffineTransform(scaleX: scale, y: scale)
            for layer in InkIconLibrary.layers(for: icon) {
                guard let scaled = layer.path.copy(using: &transform) else { continue }
                ctx.stroke(
                    Path(scaled),
                    with: .color(color.opacity(layer.opacity)),
                    style: stroke
                )
            }
        }
        .frame(width: size, height: size)
        .accessibilityHidden(true)
    }
}

private struct InkLayer {
    let path: CGPath
    let opacity: Double
}

private enum InkIconLibrary {
    static func layers(for icon: InkIcon) -> [InkLayer] {
        switch icon {
        case .v60: return v60()
        case .kettle: return kettle()
        case .scale: return scale()
        case .bloom: return bloom()
        case .drop: return drop()
        case .beans: return beans()
        case .thermo: return thermo()
        case .spiral: return spiral()
        case .timer: return timer()
        case .flame: return flame()
        case .check: return check()
        case .chevron: return chevron()
        case .plus: return plus()
        case .minus: return minus()
        case .stamp: return stamp()
        }
    }

    // MARK: - Path builders (24×24 unit space, mirrors shared.jsx SVG paths)

    private static func v60() -> [InkLayer] {
        let cone = CGMutablePath()
        cone.move(to: CGPoint(x: 5.2, y: 5.5))
        cone.addLine(to: CGPoint(x: 18.8, y: 5.5))
        cone.addLine(to: CGPoint(x: 13, y: 15))
        cone.addLine(to: CGPoint(x: 11, y: 15))
        cone.closeSubpath()

        let server = CGMutablePath()
        server.move(to: CGPoint(x: 11, y: 15))
        server.addLine(to: CGPoint(x: 11, y: 17.2))
        server.addLine(to: CGPoint(x: 13, y: 17.2))
        server.addLine(to: CGPoint(x: 13, y: 15))

        let base = CGMutablePath()
        base.move(to: CGPoint(x: 8, y: 19.5))
        base.addQuadCurve(to: CGPoint(x: 16, y: 19.5), control: CGPoint(x: 12, y: 21.5))

        let lid = CGMutablePath()
        lid.move(to: CGPoint(x: 7.5, y: 5.5))
        lid.addQuadCurve(to: CGPoint(x: 16.5, y: 5.5), control: CGPoint(x: 12, y: 3.8))

        let ridge1 = CGMutablePath()
        ridge1.move(to: CGPoint(x: 8, y: 8))
        ridge1.addLine(to: CGPoint(x: 16, y: 8))

        let ridge2 = CGMutablePath()
        ridge2.move(to: CGPoint(x: 9, y: 11))
        ridge2.addLine(to: CGPoint(x: 15, y: 11))

        return [
            InkLayer(path: cone, opacity: 1),
            InkLayer(path: server, opacity: 1),
            InkLayer(path: base, opacity: 1),
            InkLayer(path: lid, opacity: 1),
            InkLayer(path: ridge1, opacity: 0.5),
            InkLayer(path: ridge2, opacity: 0.5),
        ]
    }

    private static func kettle() -> [InkLayer] {
        let body = CGMutablePath()
        body.move(to: CGPoint(x: 5, y: 11))
        body.addLine(to: CGPoint(x: 5, y: 17))
        body.addQuadCurve(to: CGPoint(x: 7, y: 19), control: CGPoint(x: 5, y: 19))
        body.addLine(to: CGPoint(x: 15, y: 19))
        body.addQuadCurve(to: CGPoint(x: 17, y: 17), control: CGPoint(x: 17, y: 19))
        body.addLine(to: CGPoint(x: 17, y: 11))

        let lip = CGMutablePath()
        lip.move(to: CGPoint(x: 5, y: 11))
        lip.addLine(to: CGPoint(x: 17, y: 11))

        let spout = CGMutablePath()
        spout.move(to: CGPoint(x: 17, y: 12.5))
        spout.addQuadCurve(to: CGPoint(x: 21, y: 8), control: CGPoint(x: 21, y: 11))
        spout.addQuadCurve(to: CGPoint(x: 19.5, y: 6.5), control: CGPoint(x: 21, y: 6.5))

        let handle = CGMutablePath()
        handle.move(to: CGPoint(x: 9, y: 11))
        handle.addLine(to: CGPoint(x: 9, y: 8))
        handle.addQuadCurve(to: CGPoint(x: 11, y: 6), control: CGPoint(x: 9, y: 6))
        handle.addLine(to: CGPoint(x: 13, y: 6))
        handle.addQuadCurve(to: CGPoint(x: 15, y: 8), control: CGPoint(x: 15, y: 6))
        handle.addLine(to: CGPoint(x: 15, y: 11))

        let strap = CGMutablePath()
        strap.move(to: CGPoint(x: 10, y: 8))
        strap.addLine(to: CGPoint(x: 14, y: 8))

        return [
            InkLayer(path: body, opacity: 1),
            InkLayer(path: lip, opacity: 1),
            InkLayer(path: spout, opacity: 1),
            InkLayer(path: handle, opacity: 1),
            InkLayer(path: strap, opacity: 0.5),
        ]
    }

    private static func scale() -> [InkLayer] {
        let plate = CGMutablePath()
        plate.addRoundedRect(
            in: CGRect(x: 3.5, y: 6, width: 17, height: 13),
            cornerWidth: 1.6, cornerHeight: 1.6
        )

        let dial = CGMutablePath()
        dial.addEllipse(in: CGRect(x: 12 - 3.2, y: 13 - 3.2, width: 6.4, height: 6.4))

        let needle = CGMutablePath()
        needle.move(to: CGPoint(x: 12, y: 11.2))
        needle.addLine(to: CGPoint(x: 12, y: 13))

        let antenna = CGMutablePath()
        antenna.move(to: CGPoint(x: 9, y: 4))
        antenna.addLine(to: CGPoint(x: 15, y: 4))

        let posts = CGMutablePath()
        posts.move(to: CGPoint(x: 10, y: 4))
        posts.addLine(to: CGPoint(x: 10, y: 6))
        posts.move(to: CGPoint(x: 14, y: 4))
        posts.addLine(to: CGPoint(x: 14, y: 6))

        return [
            InkLayer(path: plate, opacity: 1),
            InkLayer(path: dial, opacity: 1),
            InkLayer(path: needle, opacity: 1),
            InkLayer(path: antenna, opacity: 1),
            InkLayer(path: posts, opacity: 1),
        ]
    }

    private static func bloom() -> [InkLayer] {
        func ellipse(cx: CGFloat, cy: CGFloat, rx: CGFloat, ry: CGFloat) -> CGMutablePath {
            let p = CGMutablePath()
            p.addEllipse(in: CGRect(x: cx - rx, y: cy - ry, width: rx * 2, height: ry * 2))
            return p
        }

        let outer = ellipse(cx: 12, cy: 14, rx: 8, ry: 3)
        let mid = ellipse(cx: 12, cy: 13, rx: 5.2, ry: 1.9)
        let inner = ellipse(cx: 12, cy: 12, rx: 2.8, ry: 1.1)

        let drop = CGMutablePath()
        drop.move(to: CGPoint(x: 12, y: 4))
        drop.addQuadCurve(to: CGPoint(x: 14, y: 8.5), control: CGPoint(x: 14, y: 7))
        drop.addQuadCurve(to: CGPoint(x: 12, y: 10), control: CGPoint(x: 14, y: 10))
        drop.addQuadCurve(to: CGPoint(x: 10, y: 8.5), control: CGPoint(x: 10, y: 10))
        drop.addQuadCurve(to: CGPoint(x: 12, y: 4), control: CGPoint(x: 10, y: 7))
        drop.closeSubpath()

        return [
            InkLayer(path: outer, opacity: 1),
            InkLayer(path: mid, opacity: 0.7),
            InkLayer(path: inner, opacity: 0.5),
            InkLayer(path: drop, opacity: 1),
        ]
    }

    private static func drop() -> [InkLayer] {
        let outer = CGMutablePath()
        outer.move(to: CGPoint(x: 12, y: 3))
        outer.addQuadCurve(to: CGPoint(x: 17, y: 14), control: CGPoint(x: 17, y: 9))
        outer.addQuadCurve(to: CGPoint(x: 12, y: 19), control: CGPoint(x: 17, y: 19))
        outer.addQuadCurve(to: CGPoint(x: 7, y: 14), control: CGPoint(x: 7, y: 19))
        outer.addQuadCurve(to: CGPoint(x: 12, y: 3), control: CGPoint(x: 7, y: 9))
        outer.closeSubpath()

        let highlight = CGMutablePath()
        highlight.move(to: CGPoint(x: 9.5, y: 14.5))
        highlight.addQuadCurve(to: CGPoint(x: 12, y: 17), control: CGPoint(x: 10, y: 16.5))

        return [
            InkLayer(path: outer, opacity: 1),
            InkLayer(path: highlight, opacity: 0.6),
        ]
    }

    private static func beans() -> [InkLayer] {
        func bean(cx: CGFloat, cy: CGFloat, rx: CGFloat, ry: CGFloat, rotation: CGFloat) -> [CGMutablePath] {
            let outer = CGMutablePath()
            let inner = CGMutablePath()

            let transform = CGAffineTransform(translationX: cx, y: cy)
                .rotated(by: rotation * .pi / 180)
                .translatedBy(x: -cx, y: -cy)

            outer.addEllipse(
                in: CGRect(x: cx - rx, y: cy - ry, width: rx * 2, height: ry * 2),
                transform: transform
            )

            // crease — a quad curve through the bean
            let creasePoints = (
                start: CGPoint(x: cx - rx * 0.35, y: cy - ry * 0.6),
                control: CGPoint(x: cx + rx * 0.4, y: cy),
                end: CGPoint(x: cx - rx * 0.45, y: cy + ry * 0.7)
            )
            inner.move(to: creasePoints.start, transform: transform)
            inner.addQuadCurve(
                to: creasePoints.end,
                control: creasePoints.control,
                transform: transform
            )

            return [outer, inner]
        }

        let leftPair = bean(cx: 9, cy: 12, rx: 4, ry: 6, rotation: -25)
        let rightPair = bean(cx: 16, cy: 13, rx: 3.2, ry: 5, rotation: 20)

        return [
            InkLayer(path: leftPair[0], opacity: 1),
            InkLayer(path: leftPair[1], opacity: 0.6),
            InkLayer(path: rightPair[0], opacity: 1),
            InkLayer(path: rightPair[1], opacity: 0.6),
        ]
    }

    private static func thermo() -> [InkLayer] {
        let body = CGMutablePath()
        body.move(to: CGPoint(x: 12, y: 4))
        body.addQuadCurve(to: CGPoint(x: 14, y: 6), control: CGPoint(x: 14, y: 4))
        body.addLine(to: CGPoint(x: 14, y: 13.5))
        body.addQuadCurve(to: CGPoint(x: 16, y: 16.5), control: CGPoint(x: 16, y: 14.5))
        body.addQuadCurve(to: CGPoint(x: 13, y: 19.5), control: CGPoint(x: 16, y: 19))
        body.addQuadCurve(to: CGPoint(x: 9, y: 16.5), control: CGPoint(x: 9, y: 19.5))
        body.addQuadCurve(to: CGPoint(x: 11, y: 13.5), control: CGPoint(x: 9, y: 14.5))
        body.addLine(to: CGPoint(x: 11, y: 6))
        body.addQuadCurve(to: CGPoint(x: 12, y: 4), control: CGPoint(x: 11, y: 4))
        body.closeSubpath()

        let bulb = CGMutablePath()
        bulb.addEllipse(in: CGRect(x: 12.5 - 1.4, y: 16.7 - 1.4, width: 2.8, height: 2.8))

        let ticks = CGMutablePath()
        ticks.move(to: CGPoint(x: 14, y: 8))
        ticks.addLine(to: CGPoint(x: 16, y: 8))
        ticks.move(to: CGPoint(x: 14, y: 10.5))
        ticks.addLine(to: CGPoint(x: 16, y: 10.5))

        return [
            InkLayer(path: body, opacity: 1),
            InkLayer(path: bulb, opacity: 1),
            InkLayer(path: ticks, opacity: 1),
        ]
    }

    private static func spiral() -> [InkLayer] {
        let p = CGMutablePath()
        p.move(to: CGPoint(x: 12, y: 12))
        p.addQuadCurve(to: CGPoint(x: 15, y: 8), control: CGPoint(x: 12, y: 8))
        p.addQuadCurve(to: CGPoint(x: 18, y: 12), control: CGPoint(x: 18, y: 8))
        p.addQuadCurve(to: CGPoint(x: 12, y: 17), control: CGPoint(x: 18, y: 17))
        p.addQuadCurve(to: CGPoint(x: 5.5, y: 11), control: CGPoint(x: 5.5, y: 17))
        p.addQuadCurve(to: CGPoint(x: 13, y: 4), control: CGPoint(x: 5.5, y: 4))
        return [InkLayer(path: p, opacity: 1)]
    }

    private static func timer() -> [InkLayer] {
        let face = CGMutablePath()
        face.addEllipse(in: CGRect(x: 12 - 6.5, y: 13.5 - 6.5, width: 13, height: 13))

        let hands = CGMutablePath()
        hands.move(to: CGPoint(x: 12, y: 13.5))
        hands.addLine(to: CGPoint(x: 12, y: 9.5))
        hands.move(to: CGPoint(x: 12, y: 13.5))
        hands.addLine(to: CGPoint(x: 15, y: 14.5))

        let crown = CGMutablePath()
        crown.move(to: CGPoint(x: 10, y: 4))
        crown.addLine(to: CGPoint(x: 14, y: 4))

        let knob = CGMutablePath()
        knob.move(to: CGPoint(x: 16, y: 5))
        knob.addLine(to: CGPoint(x: 18, y: 7))

        return [
            InkLayer(path: face, opacity: 1),
            InkLayer(path: hands, opacity: 1),
            InkLayer(path: crown, opacity: 1),
            InkLayer(path: knob, opacity: 1),
        ]
    }

    private static func flame() -> [InkLayer] {
        let p = CGMutablePath()
        p.move(to: CGPoint(x: 12, y: 4))
        p.addQuadCurve(to: CGPoint(x: 9, y: 11), control: CGPoint(x: 9, y: 8))
        p.addQuadCurve(to: CGPoint(x: 11, y: 13), control: CGPoint(x: 9, y: 13))
        p.addQuadCurve(to: CGPoint(x: 12, y: 10), control: CGPoint(x: 11, y: 11))
        p.addQuadCurve(to: CGPoint(x: 14, y: 14), control: CGPoint(x: 14, y: 12))
        p.addQuadCurve(to: CGPoint(x: 12, y: 19), control: CGPoint(x: 14, y: 17))
        p.addQuadCurve(to: CGPoint(x: 16.5, y: 16.5), control: CGPoint(x: 15, y: 19))
        p.addQuadCurve(to: CGPoint(x: 17, y: 11), control: CGPoint(x: 18, y: 14))
        p.addQuadCurve(to: CGPoint(x: 12, y: 4), control: CGPoint(x: 16, y: 8))
        p.closeSubpath()
        return [InkLayer(path: p, opacity: 1)]
    }

    private static func check() -> [InkLayer] {
        let p = CGMutablePath()
        p.move(to: CGPoint(x: 5, y: 12))
        p.addLine(to: CGPoint(x: 10, y: 17))
        p.addLine(to: CGPoint(x: 19, y: 7))
        return [InkLayer(path: p, opacity: 1)]
    }

    private static func chevron() -> [InkLayer] {
        let p = CGMutablePath()
        p.move(to: CGPoint(x: 9, y: 5))
        p.addLine(to: CGPoint(x: 16, y: 12))
        p.addLine(to: CGPoint(x: 9, y: 19))
        return [InkLayer(path: p, opacity: 1)]
    }

    private static func plus() -> [InkLayer] {
        let p = CGMutablePath()
        p.move(to: CGPoint(x: 12, y: 5))
        p.addLine(to: CGPoint(x: 12, y: 19))
        p.move(to: CGPoint(x: 5, y: 12))
        p.addLine(to: CGPoint(x: 19, y: 12))
        return [InkLayer(path: p, opacity: 1)]
    }

    private static func minus() -> [InkLayer] {
        let p = CGMutablePath()
        p.move(to: CGPoint(x: 5, y: 12))
        p.addLine(to: CGPoint(x: 19, y: 12))
        return [InkLayer(path: p, opacity: 1)]
    }

    private static func stamp() -> [InkLayer] {
        let outer = CGMutablePath()
        outer.addEllipse(in: CGRect(x: 12 - 9, y: 12 - 9, width: 18, height: 18))
        let inner = CGMutablePath()
        inner.addEllipse(in: CGRect(x: 12 - 6.5, y: 12 - 6.5, width: 13, height: 13))
        return [
            InkLayer(path: outer, opacity: 1),
            InkLayer(path: inner, opacity: 0.6),
        ]
    }
}
