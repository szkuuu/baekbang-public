//
//  BBTImeButton.swift
//  BaekBang
//
//  Created by 차상호 on 2021/06/18.
//
//

import UIKit

class BBTImeButton: UIControl {

    // MARK: - Element
    private var label: UILabel?

    // MARK: - Property
    private var color: UIColor = .bbGray2

    public var text: String? = nil {
        didSet {
            setNeedsLayout()
        }
    }

    public var isOn: Bool = false {
        didSet {
            color = isOn ? .bbAccent : .bbGray2
            setNeedsLayout()
        }
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

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUi()
    }

    private func setupUi() {
        layer.cornerRadius = 4.0
        layer.borderWidth = 2.0
        layer.borderColor = color.cgColor
        label = {
            let label = UILabel()
            label.text = text
            label.textColor = color
            label.font = .systemFont(ofSize: 12.0, weight: .semibold)
            return label
        }()
        if let label = label {
            addSubview(label)
        }
        setNeedsUpdateConstraints()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        guard let labelView = label else { return }
        layer.borderColor = color.cgColor
        labelView.text = text
        labelView.textColor = color
    }

    override func updateConstraints() {
        super.updateConstraints()
        guard let labelView = label else { return }
        labelView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
//        NSLayoutConstraint.activate([
//            labelView.centerXAnchor.constraint(equalTo: centerXAnchor),
//            labelView.centerYAnchor.constraint(equalTo: centerYAnchor)
//        ])
    }
}
