import SwiftUI

public struct ChartView: View {
	
    var data  : [String : Double]
    
    var dataValues: [Double] { Array(data.values) }
    
	var isCurvedLine : Bool
	var firstColor: Color
	var secondColor: Color
	
	@State private var indicatorPosition = CGPoint.zero
	@State private var frame             = CGRect.zero
	@State private var showIndicator     = false
	@State private var showFull          = true
	@State private var chartValue        = 0.0
	
	public var body: some View {
		GeometryReader { geometry in
			ZStack {
				if showFull { backgroundPathView }
				
				linePathView
					.overlay(
						HStack {
                            ForEach(dataValues.indices, id: \.self) { index in
								Color.black.opacity(0.1)
									.frame(width: 1)
								if index != dataValues.count - 1 { Spacer() }
							}
						}
						.frame(maxWidth: .infinity, alignment: .leading)
					)
				
				Circle()
					.frame(width: 14, height: 14)
					.foregroundColor(.white)
					.overlay(
						Circle()
							.fill(LinearGradient(gradient: .init(colors: [firstColor, secondColor]),
												 startPoint: .topLeading,
												 endPoint: .bottomTrailing))
							.frame(width: 7, height: 7)
					)
					.shadow(color: Color.black.opacity(0.15), radius: 6, x: 0, y: 6)
					.shadow(color: Color.black.opacity(0.1), radius: 1, x: 0, y: 1)
					.frame(width: 12, height: 12)
					.foregroundColor(.red)
					.frame(width: 100, height: 300)
					.overlay(
						VStack {
							Text(String(format: "%.2f", chartValue))
						}
						.padding(.horizontal, 8)
						.padding(.vertical, 6)
						.background(Color.white)
						.clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
						.shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 8)
						.shadow(color: Color.black.opacity(0.15), radius: 1, x: 0, y: 1)
						.offset(y: -36)
						.zIndex(1)
					)
					.animation(.none)
					.rotationEffect(.degrees(180), anchor: .center)
					.rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
					.position(indicatorPosition)
					.opacity(showIndicator ? 1 : 0)
					.animation(.easeInOut(duration: 0.18))
					.rotationEffect(.degrees(180), anchor: .center)
					.rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
			}
			.onAppear { frame = geometry.frame(in: .local) }
			.background(Color.white.opacity(0.000000000001))
			.gesture(
				DragGesture()
					.onChanged { value in
						guard let nearestValue = nearestValue(to: nearestPointOnGraph(to: value.location)) else { return }
						let indicatorPosition = nearestStep(touchLocation: value.location, value: nearestValue)
						
                        if indicatorPosition != self.indicatorPosition {
                            UIImpactFeedbackGenerator(style: .light).impactOccurred()
                        }
                        
						chartValue = nearestValue
                        self.indicatorPosition = indicatorPosition
						showIndicator = true
				}
				.onEnded { value in
					showIndicator = false
				}
			)
		}
		.frame(height: 200)
	}
}

// MARK: - Private functions
extension ChartView {
	var step: CGPoint { return getStep(frame: frame, data: dataValues) }
	
	var path: Path {
		if isCurvedLine {
			return Path.quadCurvedPathWithPoints(points: dataValues, step: step, globalOffset: nil)
		}
		return Path.linePathWithPoints(points: dataValues, step: step)
	}
	
	var closedPath: Path {
		if isCurvedLine {
			return Path.quadClosedCurvedPathWithPoints(points: dataValues, step: step, globalOffset: nil)
		}
		return Path.closedLinePathWithPoints(points: dataValues, step: step)
	}
	
	private func nearestPointOnGraph(to point: CGPoint) -> CGPoint {
		return path.point(to: point.x)
	}
	
	private func nearestValue(to point: CGPoint) -> Double? {
        if step.x == 0 { return nil }
		let index = Int(round((point.x) / step.x))
		if (index >= 0 && index < data.count) {
			return dataValues[index]
		}
		return nil
	}
	
	private func nearestStep(touchLocation: CGPoint, value: Double) -> CGPoint {
		let xStepMultiplier = Int(round((touchLocation.x) / step.x))
		let newPoint = CGPoint(x: step.x * CGFloat(xStepMultiplier), y: touchLocation.y)
		return nearestPointOnGraph(to: newPoint)
	}
	
	var backgroundPathView: some View {
		closedPath
			.fill(LinearGradient(gradient: .init(stops: [.init(color: firstColor, location: 0.5), .init(color: secondColor.opacity(0.00000001), location: 1)]), startPoint: .bottom, endPoint: .top))
			.rotationEffect(.degrees(180), anchor: .center)
			.rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
			.opacity(0.2)
			.transition(.opacity)
	}
	
	var linePathView: some View {
		path
			.trim(from: 0, to: showFull ? 1 : 0)
			.stroke(LinearGradient(gradient: .init(colors: [firstColor, secondColor]),
								   startPoint: .leading,
								   endPoint: .trailing),
					style: StrokeStyle(lineWidth: 3, lineJoin: .round))
			.rotationEffect(.degrees(180), anchor: .center)
			.rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
            .animation(Animation.easeOut(duration: 1.2))
			.onAppear { showFull = true }
            .onDisappear { showFull = false }
            .drawingGroup()
	}
	
	func getStep(frame: CGRect, data: [Double]) -> CGPoint {
		let padding: CGFloat = 30.0
		
		// stepWidth
		var stepWidth: CGFloat = 0.0
		if data.count < 2 {
			stepWidth = 0.0
		}
		stepWidth = frame.size.width / CGFloat(data.count - 1)
		
		// stepHeight
		var stepHeight: CGFloat = 0.0
		
		var min: Double?
		var max: Double?
		if let minPoint = data.min(), let maxPoint = data.max(), minPoint != maxPoint {
			min = minPoint
			max = maxPoint
		} else {
			return .zero
		}
		if let min = min, let max = max, min != max {
			if min <= 0 {
				stepHeight = (frame.size.height - padding) / CGFloat(max - min)
			} else {
				stepHeight = (frame.size.height - padding) / CGFloat(max - min)
			}
		}
		
		return CGPoint(x: stepWidth, y: stepHeight)
	}
}

struct Line_Previews: PreviewProvider {
	static var previews: some View {
        ChartView(data: [:], isCurvedLine: true, firstColor: .blue, secondColor: .purple)
	}
}
