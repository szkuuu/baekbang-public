//
//  BBPlusButton.swift
//  BaekBang
//
//  Created by 차상호 on 2021/06/21.
//
//

import UIKit

class BBPlusButton: UIControl {

    // MARK: - Element
    private var circle: CAShapeLayer?

    private var plus: CAShapeLayer?

    // MARK: - Property
    private let lineWidth: CGFloat = 2.0

    public var color: UIColor = .bbAccent {
        didSet {
            setNeedsLayout()
        }
    }

    // MARK: - Method
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupUi()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUi()
    }

    private func setupUi() {
        circle = {
            let shapeLayer = CAShapeLayer()
            shapeLayer.fillColor = color.cgColor
            shapeLayer.strokeColor = UIColor.clear.cgColor
            return shapeLayer
        }()
        plus = {
            let shapeLayer = CAShapeLayer()
            shapeLayer.fillColor = UIColor.clear.cgColor
            shapeLayer.strokeColor = UIColor.white.cgColor
            shapeLayer.lineWidth = lineWidth
            shapeLayer.lineCap = .round
            return shapeLayer
        }()
        if let circle = circle {
            layer.addSublayer(circle)
        }
        if let plus = plus {
            layer.addSublayer(plus)
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        guard let circleLayer = circle,
              let plusLayer = plus else { return }
        let circlePath = UIBezierPath(arcCenter: .init(x: frame.width / 2, y: frame.height / 2), radius: frame.height / 2, startAngle: 0, endAngle: .pi * 2, clockwise: true)
        circleLayer.path = circlePath.cgPath
        let plusPath: UIBezierPath = {
            let path = UIBezierPath()
            path.lineCapStyle = .round
            path.move(to: .init(x: frame.width * 0.25, y: frame.height / 2))
            path.addLine(to: .init(x: frame.width * 0.75, y: frame.height / 2))
            path.move(to: .init(x: frame.width / 2, y: frame.height * 0.25))
            path.addLine(to: .init(x: frame.width / 2, y: frame.height * 0.75))
            return path
        }()
        plusLayer.path = plusPath.cgPath
    }
}
