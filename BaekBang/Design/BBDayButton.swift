//
//  BBDayButton.swift
//  BaekBang
//
//  Created by 차상호 on 2021/06/18.
//
//

import UIKit
import SnapKit

class BBDayButton: UIControl {

    // MARK: - Element
    private var label: UILabel?

    // MARK: - Property
    private var fillColor: UIColor = .bbGray2

    public var text: String? = nil {
        didSet {
            setNeedsLayout()
        }
    }

    public var isOn: Bool = false {
        didSet {
            fillColor = isOn ? .bbAccent : .bbGray2
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
        label = {
            let label = UILabel()
            label.textColor = .white
            label.text = text
            label.font = .systemFont(ofSize: 15.0, weight: .semibold)
            return label
        }()
        if let label = label {
            addSubview(label)
        }
        setNeedsUpdateConstraints()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        guard let labelView = label else {
            return
        }
        UIView.animate(withDuration: 0.05, delay: 0, options: .curveEaseInOut) { [weak self] in
            self?.layer.backgroundColor = self?.fillColor.cgColor
        }
        labelView.text = text
    }

    override func updateConstraints() {
        if let labelView = label {
            labelView.snp.makeConstraints {
                $0.center.equalToSuperview()
            }
//            NSLayoutConstraint.activate([
//                labelView.centerXAnchor.constraint(equalTo: centerXAnchor),
//                labelView.centerYAnchor.constraint(equalTo: centerYAnchor)
//            ])
        }
        super.updateConstraints()
    }
}
