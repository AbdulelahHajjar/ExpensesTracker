import SwiftUI
import Combine

public struct ChartView: View {
    @ObservedObject var viewModel: ChartViewModel
    
    var isCurvedLine : Bool
    var firstColor: Color
    var secondColor: Color
        
	@State private var indicatorPosition = CGPoint.zero
	@State private var frame             = CGRect.zero
	@State private var showIndicator     = false
	@State private var showFull          = true
    
    @State private var currentPointIndex: Int?
    
    var currentKey: String? {
        guard let index = currentPointIndex else { return nil }
        return viewModel.sortedRepresentableKeys[index]
    }
    
    var currentValue: Double? {
        guard let index = currentPointIndex else { return nil }
        return viewModel.valuesSortedByKeys[index]
    }
    
    var indicatorBoxHorizontalOffset: CGFloat {
        if currentPointIndex == 1 { return 12 }
        else if currentPointIndex == 0 { return 24 }
        else if currentPointIndex == viewModel.sortedRepresentableKeys.count - 1 { return -24 }
        else if currentPointIndex == viewModel.sortedRepresentableKeys.count - 2 { return -12 }
        return 0
    }
    
	public var body: some View {
		GeometryReader { geometry in
			ZStack {
				if showFull { backgroundPathView }
				
				linePathView
					.overlay(
						HStack {
                            ForEach(viewModel.sortedRepresentableKeys.indices, id: \.self) { index in
								Color.black.opacity(0.1)
									.frame(width: 1)
                                
                                if index != viewModel.sortedRepresentableKeys.count - 1 { Spacer() }
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
							.frame(width: 9, height: 9)
					)
					.shadow(color: Color.black.opacity(0.15), radius: 6, x: 0, y: 6)
					.shadow(color: Color.black.opacity(0.1), radius: 1, x: 0, y: 1)
					.frame(width: 12, height: 12)
					.foregroundColor(.red)
					.frame(width: 100, height: 300)
					.overlay(
						VStack {
                            if let key = currentKey, let value = currentValue {
                                Text(key)
                                    .foregroundColor(.gray)
                                    .font(.footnote)
                                
                                Text(String(format: "%.2f", value))
                            }
						}
						.padding(.horizontal, 8)
						.padding(.vertical, 6)
						.background(Color.white)
						.clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                        .animation(Animation.default.speed(1.20))
						.shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 8)
						.shadow(color: Color.black.opacity(0.15), radius: 1, x: 0, y: 1)
                        .offset(y: -36)
                        .offset(x: indicatorBoxHorizontalOffset)
					)
					.rotationEffect(.degrees(180), anchor: .center)
                    .animation(.none)
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
						guard let nearestValueIndex = nearestValueIndex(to: nearestPointOnGraph(to: value.location)) else { return }
                        let currentValue = viewModel.valuesSortedByKeys[nearestValueIndex]
                        let indicatorPosition = nearestStep(touchLocation: value.location, value: currentValue)
						
                        if indicatorPosition != self.indicatorPosition {
                            UIImpactFeedbackGenerator(style: .light).impactOccurred()
                        }
                        self.currentPointIndex = nearestValueIndex
                        self.indicatorPosition = indicatorPosition
						showIndicator = true
				}
				.onEnded { value in
					showIndicator = false
                    self.currentPointIndex = nil
				}
			)
		}
		.frame(height: 200)
	}
}

// MARK: - Private functions
extension ChartView {
    var step: CGPoint { return getStep(frame: frame, data: viewModel.valuesSortedByKeys) }
	
	var path: Path {
		if isCurvedLine {
            return Path.quadCurvedPathWithPoints(points: viewModel.valuesSortedByKeys, step: step, globalOffset: nil)
		}
        return Path.linePathWithPoints(points: viewModel.valuesSortedByKeys, step: step)
	}
	
	var closedPath: Path {
		if isCurvedLine {
            return Path.quadClosedCurvedPathWithPoints(points: viewModel.valuesSortedByKeys, step: step, globalOffset: nil)
		}
        return Path.closedLinePathWithPoints(points: viewModel.valuesSortedByKeys, step: step)
	}
	
	private func nearestPointOnGraph(to point: CGPoint) -> CGPoint {
		return path.point(to: point.x)
	}
	
	private func nearestValue(to point: CGPoint) -> Double? {
        guard let index = nearestValueIndex(to: point), index < viewModel.valuesSortedByKeys.count, index >= 0 else { return nil }
        return viewModel.valuesSortedByKeys[index]
	}
    
    private func nearestValueIndex(to point: CGPoint) -> Int? {
        if step.x == 0 { return nil }
        let index = Int(round((point.x) / step.x))
        if (index >= 0 && index < viewModel.valuesSortedByKeys.count) {
            return index
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

struct Chart_Previews: PreviewProvider {
	static var previews: some View {
        ChartView(viewModel: .init(rawData: [Date() : 1.0, Date().byAddingDays(1) : 2.0]), isCurvedLine: true, firstColor: .blue, secondColor: .purple)
	}
}

extension Dictionary where Value: Equatable {
    func someKey(forValue val: Value) -> Key? {
        return first(where: { $1 == val })?.key
    }
}
