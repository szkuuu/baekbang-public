//
//  BBRequestCompleteViewController.swift
//  BaekBang
//
//  Created by 차상호 on 2021/06/22.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class BBRequestCompleteViewController: UIViewController {

    private var disposeBag = DisposeBag()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "수리요청 완료"
        label.font = .systemFont(ofSize: 25.0, weight: .bold)
        return label
    }()
    
    private lazy var subTitleLabel0: UILabel = {
        let label = UILabel()
        label.text = "수리요청이 완료되었습니다."
        return label
    }()
    
    private lazy var subTitleLabel1: UILabel = {
        let label = UILabel()
        label.text = "업체의 연락을 기다려주세요 :)"
        return label
    }()
    
    private lazy var section0: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 1.0
        return stackView
    }()
    
    private lazy var homeButton: BBRoundedButton = {
        let button = BBRoundedButton(withText: "홈으로")
        button.condition = .activate
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        arrange()
        layout()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        rxRegister()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        disposeBag = DisposeBag()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    private func arrange() {
        section0.insertArrangedSubview(subTitleLabel0, at: 0)
        section0.insertArrangedSubview(subTitleLabel1, at: 1)
        view.addSubview(titleLabel)
        view.addSubview(section0)
        view.addSubview(homeButton)
    }
    
    private func layout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.topMargin).offset(40)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leadingMargin).offset(40)
        }
        section0.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(12)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leadingMargin).offset(40)
        }
        homeButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottomMargin).offset(-70)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leadingMargin).offset(40)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailingMargin).offset(-40)
            $0.height.equalTo(42)
        }
    }
    
    private func rxRegister() {
        homeButton.rx
            .controlEvent(.touchUpInside)
            .bind(onNext: { _ in
                self.dismiss(animated: true)
            }).disposed(by: disposeBag)
    }
}
