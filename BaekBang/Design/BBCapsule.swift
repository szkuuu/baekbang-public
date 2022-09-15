//
//  BBCapsule.swift
//  BaekBang
//
//  Created by 차상호 on 2021/06/17.
//
//

import UIKit
import SnapKit

class BBCapsule: UIControl {

    // MARK: - Element
    private var capsule: CAShapeLayer?

    private var label: UILabel?

    // MARK: - Property
    private let padding: UIEdgeInsets = .init(top: 3, left: 10, bottom: 3, right: 10)

    private var color: UIColor = .bbGray1

    public var text: String? = nil {
        didSet {
            setNeedsLayout()
        }
    }

    public var isOn: Bool = false {
        didSet {
            guard isOn != oldValue else {
                return
            }
            color = isOn ? .bbAccent : .bbGray1
            setNeedsLayout()
        }
    }
    override var intrinsicContentSize: CGSize {
        guard let label = label else {
            return CGSize(width: 0, height: 0)
        }
        let width: CGFloat = label.intrinsicContentSize.width + padding.left + padding.right
        let height: CGFloat = label.intrinsicContentSize.height + padding.top + padding.bottom
        return .init(width: width, height: height)
    }

    // MARK: - Method
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupUi()
    }

    public convenience init(withText text: String) {
        self.init()
        self.text = text
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUi()
    }

    private func setupUi() {
        capsule = {
            let capsule = CAShapeLayer()
            capsule.fillColor = UIColor.clear.cgColor
            return capsule
        }()
        label = {
            let label = UILabel()
            label.font = .systemFont(ofSize: 10.0)
            label.textAlignment = .center
            label.isUserInteractionEnabled = false
            return label
        }()
        if let capsule = capsule {
            layer.addSublayer(capsule)
        }
        if let label = label {
            addSubview(label)
        }
        setNeedsUpdateConstraints()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        guard let capsuleLayer = capsule,
              let labelView = label else {
            return
        }
        invalidateIntrinsicContentSize()
        let (width, height): (CGFloat, CGFloat) = (intrinsicContentSize.width, intrinsicContentSize.height)
        let path = UIBezierPath(roundedRect: .init(x: 0, y: 0, width: width, height: height), cornerRadius: height / 2)
        capsuleLayer.path = path.cgPath
        capsuleLayer.strokeColor = color.cgColor
        labelView.text = text
        labelView.textColor = color
    }

    override func updateConstraints() {
        if let labelView = label {
            labelView.snp.makeConstraints {
                $0.top.leading.trailing.bottom.equalToSuperview()
            }
//            NSLayoutConstraint.activate([
//                labelView.topAnchor.constraint(equalTo: topAnchor),
//                labelView.leadingAnchor.constraint(equalTo: leadingAnchor),
//                labelView.trailingAnchor.constraint(equalTo: trailingAnchor),
//                labelView.bottomAnchor.constraint(equalTo: bottomAnchor)
//            ])
        }
        super.updateConstraints()
    }
}
