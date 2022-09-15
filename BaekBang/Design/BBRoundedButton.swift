//
//  BBRoundedButton.swift
//  BaekBang
//
//  Created by 차상호 on 2021/06/17.
//
//

import UIKit
import SnapKit

enum BBRoundedButtonCondition {
    case activate
    case deactivate
    case loading
}

class BBRoundedButton: UIControl {

    // MARK: - Element
    private var label: UILabel?

    private var loadingIndicator: UIActivityIndicatorView?

    // MARK: - Property
    private var fillColor: UIColor = .bbOrange1

    private var labelOpacity: CGFloat = 1.0

    private var indicatorOpacity: CGFloat = 0.0

    private let indicatorSize: CGFloat = 30.0

    public var text: String? = nil {
        didSet {
            setNeedsLayout()
        }
    }

    public var condition: BBRoundedButtonCondition = .deactivate {
        didSet {
            switch condition {
            case .activate:
                fillColor = .bbAccent
                labelOpacity = 1
                indicatorOpacity = 0
            case .deactivate:
                fillColor = .bbOrange1
                labelOpacity = 1
                indicatorOpacity = 0
            case .loading:
                fillColor = .bbAccent
                labelOpacity = 0
                indicatorOpacity = 1
            }
            setNeedsLayout()
        }
    }

    public var radius: CGFloat = 5.0 {
        didSet {
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
        layer.cornerRadius = radius
        label = {
            let label = UILabel()
            label.textColor = .white
            label.text = text
            label.font = .systemFont(ofSize: 15.0, weight: .semibold)
            return label
        }()
        loadingIndicator = {
            let view = UIActivityIndicatorView()
            view.alpha = 0
            view.color = .white
            view.isUserInteractionEnabled = false
            return view
        }()
        if let label = label {
            addSubview(label)
        }
        if let loadingIndicator = loadingIndicator {
            addSubview(loadingIndicator)
        }
        setNeedsUpdateConstraints()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = radius
        guard let labelView = label,
              let indicatorView = loadingIndicator else {
            return
        }
        UIView.animate(withDuration: 0.05, delay: 0, options: .curveEaseInOut) { [weak self] in
            self?.layer.backgroundColor = self?.fillColor.cgColor
        }
        labelView.text = text
        UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseIn) { [weak self] in
            labelView.alpha = self?.condition == .loading ? 0 : 1
        }
        if condition == .loading {
            UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseIn) { [weak self] in
                indicatorView.startAnimating()
                indicatorView.alpha = self?.indicatorOpacity ?? 0
            }
        } else {
            indicatorView.stopAnimating()
            indicatorView.alpha = indicatorOpacity
        }
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
        if let indicatorView = loadingIndicator {
            indicatorView.snp.makeConstraints {
                $0.width.height.equalTo(indicatorSize)
                $0.center.equalToSuperview()
            }
//            NSLayoutConstraint.activate([
//                indicatorView.widthAnchor.constraint(equalToConstant: indicatorSize),
//                indicatorView.heightAnchor.constraint(equalToConstant: indicatorSize),
//                indicatorView.centerXAnchor.constraint(equalTo: centerXAnchor),
//                indicatorView.centerYAnchor.constraint(equalTo: centerYAnchor)
//            ])
        }
        super.updateConstraints()
    }
}
