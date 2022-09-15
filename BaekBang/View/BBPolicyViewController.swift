//
//  BBPolicyViewController.swift
//  BaekBang
//
//  Created by 차상호 on 2021/06/22.
//
//

import UIKit
import RxSwift
import RxCocoa

class BBPolicyViewController: UIViewController {
    
    open var bbUser: BBUser?
    
    private var disposeBag = DisposeBag()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "약관확인"
        label.font = .systemFont(ofSize: 25.0, weight: .bold)
        return label
    }()

    private lazy var allCheck: BBCheck = {
        let check = BBCheck()
        return check
    }()

    private lazy var allLabel: UILabel = {
        let label = UILabel()
        label.text = "전체 약관동의"
        label.font = .systemFont(ofSize: 15.0)
        return label
    }()

    private lazy var serviceCheck: BBCheck = {
        let check = BBCheck()
        return check
    }()

    private lazy var serviceLabel: UILabel = {
        let label = UILabel()
        label.text = "서비스 이용약관 동의"
        label.font = .systemFont(ofSize: 15.0)
        return label
    }()

    private lazy var serviceDetail: BBCapsule = {
        let capsule = BBCapsule(withText: "상세보기")
        capsule.isOn = true
        return capsule
    }()

    private lazy var personalCheck: BBCheck = {
        let check = BBCheck()
        return check
    }()

    private lazy var personalLabel: UILabel = {
        let label = UILabel()
        label.text = "개인정보 취급 정책 동의"
        label.font = .systemFont(ofSize: 15.0)
        return label
    }()

    private lazy var personalDetail: BBCapsule = {
        let capsule = BBCapsule(withText: "상세보기")
        capsule.isOn = true
        return capsule
    }()

    private lazy var marketingCheck: BBCheck = {
        let check = BBCheck()
        return check
    }()

    private lazy var marketingLabel: UILabel = {
        let label = UILabel()
        label.text = "마케팅 수신 동의(sms/push)"
        label.font = .systemFont(ofSize: 15.0)
        return label
    }()

    private lazy var nextButton: BBRoundedButton = {
        let button = BBRoundedButton(withText: "다음으로")
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        arrange()
        layout()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.view.backgroundColor = .clear
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        rxRegister()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        disposeBag = DisposeBag()
    }

    private func arrange() {
        view.addSubview(titleLabel)
        view.addSubview(allCheck)
        view.addSubview(allLabel)
        view.addSubview(serviceCheck)
        view.addSubview(serviceLabel)
        view.addSubview(serviceDetail)
        view.addSubview(personalCheck)
        view.addSubview(personalLabel)
        view.addSubview(personalDetail)
        view.addSubview(marketingCheck)
        view.addSubview(marketingLabel)
        view.addSubview(nextButton)
    }

    private func layout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.topMargin).offset(40)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leadingMargin).offset(40)
        }
        allCheck.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(47)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leadingMargin).offset(40)
            $0.width.height.equalTo(17.28)
        }
        allLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(47)
            $0.leading.equalTo(allCheck.snp.trailing).offset(9)
        }
        serviceCheck.snp.makeConstraints {
            $0.top.equalTo(allCheck.snp.bottom).offset(45)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leadingMargin).offset(40)
            $0.width.height.equalTo(17.28)
        }
        serviceLabel.snp.makeConstraints {
            $0.top.equalTo(allCheck.snp.bottom).offset(45)
            $0.leading.equalTo(serviceCheck.snp.trailing).offset(9)
        }
        serviceDetail.snp.makeConstraints {
            $0.top.equalTo(allCheck.snp.bottom).offset(45)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailingMargin).offset(-40)
        }
        personalCheck.snp.makeConstraints {
            $0.top.equalTo(serviceCheck.snp.bottom).offset(25)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leadingMargin).offset(40)
            $0.width.height.equalTo(17.28)
        }
        personalLabel.snp.makeConstraints {
            $0.top.equalTo(serviceCheck.snp.bottom).offset(25)
            $0.leading.equalTo(personalCheck.snp.trailing).offset(9)
        }
        personalDetail.snp.makeConstraints {
            $0.top.equalTo(serviceCheck.snp.bottom).offset(25)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailingMargin).offset(-40)
        }
        marketingCheck.snp.makeConstraints {
            $0.top.equalTo(personalCheck.snp.bottom).offset(25)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leadingMargin).offset(40)
            $0.width.height.equalTo(17.28)
        }
        marketingLabel.snp.makeConstraints {
            $0.top.equalTo(personalCheck.snp.bottom).offset(25)
            $0.leading.equalTo(marketingCheck.snp.trailing).offset(9)
        }
        nextButton.snp.makeConstraints {
            $0.top.equalTo(marketingCheck.snp.bottom).offset(45)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leadingMargin).offset(40)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailingMargin).offset(-40)
            $0.height.equalTo(42)
        }
    }

    private func rxRegister() {
        allCheck.rx
            .controlEvent(.touchUpInside)
            .bind(onNext: { _ in
                self.allCheck.isOn.toggle()
                let newValue = (self.serviceCheck.isOn && self.personalCheck.isOn && self.marketingCheck.isOn) ? false : true
                self.serviceCheck.isOn = newValue
                self.personalCheck.isOn = newValue
                self.marketingCheck.isOn = newValue
                self.nextButton.condition = self.isOk() ? .activate : .deactivate
            }).disposed(by: disposeBag)
        serviceCheck.rx
            .controlEvent(.touchUpInside)
            .bind(onNext: { _ in
                self.serviceCheck.isOn.toggle()
                self.allCheck.isOn = self.serviceCheck.isOn && self.personalCheck.isOn && self.marketingCheck.isOn
                self.nextButton.condition = self.isOk() ? .activate : .deactivate
            }).disposed(by: disposeBag)
        serviceDetail.rx
            .controlEvent(.touchUpInside)
            .bind(onNext: { _ in
                let navigationController = UINavigationController(rootViewController: BBPolicyDetailViewController(withUrl: URL(string: "http://baekbang.com/service.html"), andTitle: "서비스 이용약관 동의"))
                navigationController.modalPresentationStyle = .fullScreen
                self.present(navigationController, animated: true, completion: nil)
            }).disposed(by: disposeBag)
        personalCheck.rx
            .controlEvent(.touchUpInside)
            .bind(onNext: { _ in
                self.personalCheck.isOn.toggle()
                self.allCheck.isOn = self.serviceCheck.isOn && self.personalCheck.isOn && self.marketingCheck.isOn
                self.nextButton.condition = self.isOk() ? .activate : .deactivate
            }).disposed(by: disposeBag)
        personalDetail.rx
            .controlEvent(.touchUpInside)
            .bind(onNext: { _ in
                let navigationController = UINavigationController(rootViewController: BBPolicyDetailViewController(withUrl: URL(string: "http://baekbang.com/privacy.html"), andTitle: "개인정보 취급정책 동의"))
                navigationController.modalPresentationStyle = .fullScreen
                self.present(navigationController, animated: true, completion: nil)
            }).disposed(by: disposeBag)
        marketingCheck.rx
            .controlEvent(.touchUpInside)
            .bind(onNext: { _ in
                self.marketingCheck.isOn.toggle()
                self.allCheck.isOn = self.serviceCheck.isOn && self.personalCheck.isOn && self.marketingCheck.isOn
            }).disposed(by: disposeBag)
        nextButton.rx
            .controlEvent(.touchUpInside)
            .bind(onNext: { _ in
                guard self.nextButton.condition == .activate else { return }
                self.bbUser?.isAllowedMarketing = self.marketingCheck.isOn ? "1" : "0"
                let viewController = BBPersonalInputViewController()
                viewController.bbUser = self.bbUser
                self.navigationController?.pushViewController(viewController, animated: true)
            }).disposed(by: disposeBag)
    }
    
    private func isOk() -> Bool {
        serviceCheck.isOn && personalCheck.isOn
    }
}
