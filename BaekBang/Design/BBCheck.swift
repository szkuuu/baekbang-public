//
//  BBCheck.swift
//  BaekBang
//
//  Created by 차상호 on 2021/06/17.
//
//

import UIKit

class BBCheck: UIControl {

    // MARK: - Element
    private var outer: CAShapeLayer?

    private var check: CAShapeLayer?

    // MARK: - Property
    private var strokeColor: UIColor = .bbGray1

    private var fillColor: UIColor = .clear

    private var checkOpacity: Float = 0.0

    public var isOn: Bool = false {
        didSet {
            strokeColor = isOn ? UIColor.clear : UIColor.bbGray1
            fillColor = isOn ? UIColor.bbAccent : UIColor.clear
            checkOpacity = isOn ? 1.0 : 0.0
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
        outer = CAShapeLayer()
        check = {
            let shapeLayer = CAShapeLayer()
            shapeLayer.strokeColor = UIColor.white.cgColor
            shapeLayer.fillColor = UIColor.clear.cgColor
            shapeLayer.lineWidth = 1.5
            return shapeLayer
        }()
        if let outer = outer {
            layer.insertSublayer(outer, at: 0)
        }
        if let check = check {
            layer.addSublayer(check)
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        guard let outerLayer = outer,
              let checkLayer = check else {
            return
        }
        let outerPath = UIBezierPath(
                arcCenter: .init(x: frame.width / 2, y: frame.height / 2),
                radius: frame.height / 2,
                startAngle: .zero,
                endAngle: .pi * 2,
                clockwise: true
        )
        let checkPath: UIBezierPath = {
            let path = UIBezierPath()
            path.move(to: .init(x: frame.width / 4.1298, y: frame.height / 2.9167))
            path.addLine(to: .init(x: frame.width / 2.0618, y: frame.height / 1.57894))
            path.addLine(to: .init(x: frame.width / 1.1553, y: frame.height / 5.9272))
            path.lineCapStyle = .round
            return path
        }()
        outerLayer.path = outerPath.cgPath
        checkLayer.path = checkPath.cgPath
        outerLayer.strokeColor = strokeColor.cgColor
        outerLayer.fillColor = fillColor.cgColor
        checkLayer.opacity = checkOpacity
    }
}
