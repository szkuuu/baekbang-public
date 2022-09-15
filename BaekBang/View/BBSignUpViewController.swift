//
//  BBSignUpViewController.swift
//  BaekBang
//
//  Created by 차상호 on 2021/06/21.
//
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import SwiftyJSON

class BBSignUpViewController: UIViewController {

    private var isSend: BehaviorRelay<Bool> = .init(value: false)
    
    private var isVerified: BehaviorRelay<Bool> = .init(value: false)
    
    public var bbUser: BBUser = BBUser()
    
    private var verifyCode: String? = nil
    
    private var disposeBag = DisposeBag()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "회원가입"
        label.font = .systemFont(ofSize: 25.0, weight: .bold)
        return label
    }()

    private lazy var phoneNumberTextField: BBUnderlineTextField = {
        let textField = BBUnderlineTextField(with: "휴대폰번호")
        textField.rightViewMode = .always
        textField.keyboardType = .numberPad
        return textField
    }()

    private lazy var sendVerifyCodeButton: BBCapsule = {
        let capsule = BBCapsule(withText: "인증하기")
        return capsule
    }()

    private lazy var verifyNumberTextField: BBUnderlineTextField = {
        let textField = BBUnderlineTextField(with: "인증번호")
        textField.rightViewMode = .always
        textField.keyboardType = .numberPad
        return textField
    }()

    private lazy var verifyButton: BBCapsule = {
        let capsule = BBCapsule(withText: "확인")
        return capsule
    }()

    private lazy var stackSection1: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 30
        return stackView
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
        verifyNumberTextField.text = ""
        isSend.accept(false)
        isVerified.accept(false)
    }

    override func viewDidLayoutSubviews() {
        phoneNumberTextField.rightView = sendVerifyCodeButton
        verifyNumberTextField.rightView = verifyButton
        super.viewDidLayoutSubviews()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

    private func arrange() {
        view.addSubview(titleLabel)
        stackSection1.insertArrangedSubview(phoneNumberTextField, at: 0)
        stackSection1.insertArrangedSubview(verifyNumberTextField, at: 1)
        view.addSubview(stackSection1)
        view.addSubview(nextButton)
    }

    private func layout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.topMargin).offset(40)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leadingMargin).offset(40)
        }
        stackSection1.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(45)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leadingMargin).offset(40)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailingMargin).offset(-40)
        }
        phoneNumberTextField.snp.makeConstraints {
            $0.height.equalTo(32)
        }
        verifyNumberTextField.snp.makeConstraints {
            $0.height.equalTo(32)
        }
        nextButton.snp.makeConstraints {
            $0.top.equalTo(stackSection1.snp.bottom).offset(45)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leadingMargin).offset(40)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailingMargin).offset(-40)
            $0.height.equalTo(42)
        }
    }

    private func rxRegister() {
        _ = phoneNumberTextField.rx
            .text
            .orEmpty
            .map { $0.count == 11 }
            .bind(onNext: {
                self.sendVerifyCodeButton.isOn = $0
            }).disposed(by: disposeBag)
        _ = verifyNumberTextField.rx
            .text
            .orEmpty
            .map { !$0.isEmpty }
            .bind(onNext: {
                self.verifyButton.isOn = $0
            }).disposed(by: disposeBag)
        sendVerifyCodeButton.rx
            .controlEvent(.touchUpInside)
            .subscribe(onNext: { _ in
                BBNetworking.User.verify(withPhone: self.phoneNumberTextField.text!) {
                    let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
                    switch $0 {
                    case .success(let json):
                        self.verifyCode = json.arrayValue[0]["login"]["certi"].stringValue
                        self.isSend.accept(true)
                        alert.title = "전송 완료"
                        alert.message = "인증번호를 전송하였습니다."
                        alert.addAction(.init(title: "확인", style: .default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    case .failure(let err):
                        self.isSend.accept(false)
                        alert.title = "전송 실패"
                        alert.message = "\(err.errorDescription ?? "에러")"
                        alert.addAction(.init(title: "확인", style: .default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            }).disposed(by: disposeBag)
        verifyButton.rx
            .controlEvent(.touchUpInside)
            .subscribe(onNext: { _ in
                let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
                if self.verifyCode == self.verifyNumberTextField.text {
                    alert.title = "인증 완료"
                    alert.message = "인증되었습니다."
                    alert.addAction(.init(title: "확인", style: .default) { _ in
                        self.isVerified.accept(true)
                    })
                    self.present(alert, animated: true, completion: nil)
                } else {
                    alert.title = "인증 실패"
                    alert.message = "인증되지 않았습니다. 인증 번호를 다시 확인해주십시오."
                    alert.addAction(.init(title: "확인", style: .default, handler: nil))
                    self.present(alert, animated: true) {
                        self.isVerified.accept(false)
                    }
                }
            }).disposed(by: disposeBag)
        nextButton.rx
            .controlEvent(.touchUpInside)
            .bind(onNext: { _ in
                guard self.nextButton.condition == .activate else { return }
                self.nextButton.condition = .loading
                self.bbUser.phoneNumber = self.phoneNumberTextField.text!
                BBNetworking.User.newToken(at: self.bbUser) { result in
                    let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
                    switch result {
                    case .success(let json):
                        if let fetchedToken = json.arrayValue[0]["login"]["token"].string {
                            // 서버에 데이터가 존재할 경우
                            self.bbUser.token = fetchedToken
                            alert.title = "로그인"
                            alert.message = "로그인 되었습니다."
                            alert.addAction(.init(title: "확인", style: .cancel, handler: { _ in
                                let rootViewController = BBHomeViewController()
                                rootViewController.bbUser = self.bbUser
                                let navigationController = UINavigationController(rootViewController: rootViewController)
                                navigationController.modalPresentationStyle = .fullScreen
                                self.present(navigationController, animated: true, completion: nil)
                            }))
                            self.present(alert, animated: true, completion: {
                                self.nextButton.condition = .activate
                            })
                        } else {
                            let viewController = BBPolicyViewController()
                            viewController.bbUser = self.bbUser
                            self.navigationController?.pushViewController(viewController, animated: true)
                        }
                    case .failure(let err):
                        alert.title = "토큰 불러오기 실패"
                        alert.message = "에러: \(err.localizedDescription)"
                        alert.addAction(.init(title: "확인", style: .cancel, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            }).disposed(by: disposeBag)
        isVerified
            .asDriver()
            .drive(onNext: {
                self.nextButton.condition = $0 ? .activate : .deactivate
            }).disposed(by: disposeBag)
    }
}
