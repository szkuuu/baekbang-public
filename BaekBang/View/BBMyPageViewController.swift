//
//  BBMyPageViewController.swift
//  BaekBang
//
//  Created by 차상호 on 2021/06/22.
//

import UIKit
import SnapKit
import RealmSwift
import RxSwift
import RxCocoa

class BBMyPageViewController: UIViewController {
    
    open weak var bbUser: BBUser?
    
    private var disposeBag = DisposeBag()
    
    private lazy var titleNameLabel: UILabel = {
        let label = UILabel()
        label.text = "..."
        label.font = .systemFont(ofSize: 25.0, weight: .bold)
        return label
    }()
    
    private lazy var titleSubLabel: UILabel = {
        let label = UILabel()
        label.text = "님의 정보"
        label.font = .systemFont(ofSize: 15.0, weight: .bold)
        return label
    }()
    
    private lazy var section0: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .bottom
        stackView.spacing = 2.0
        return stackView
    }()
    
    private lazy var dividerView: UIView = {
        let view = UIView()
        view.backgroundColor = .bbGray3
        return view
    }()
    
    private lazy var nameLabel0: UILabel = {
        let label = UILabel()
        label.text = "고객명"
        label.font = .boldSystemFont(ofSize: UIFont.systemFontSize)
        return label
    }()
    
    private lazy var nameLabel1: UILabel = {
        let label = UILabel()
        label.text = "..."
        return label
    }()
    
    private lazy var section1: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 10.0
        return stackView
    }()
    
    private lazy var editUserButton: BBCapsule = {
        let capsule = BBCapsule(withText: "회원정보 수정")
        capsule.isOn = true
        return capsule
    }()
    
    private lazy var contactLabel0: UILabel = {
        let label = UILabel()
        label.text = "연락처"
        label.font = .boldSystemFont(ofSize: UIFont.systemFontSize)
        return label
    }()
    
    private lazy var contactLabel1: UILabel = {
        let label = UILabel()
        label.text = "phone"
        return label
    }()
    
    private lazy var section2: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 10.0
        return stackView
    }()
    
    private lazy var addressLabel0: UILabel = {
        let label = UILabel()
        label.text = "주소지"
        label.font = .boldSystemFont(ofSize: UIFont.systemFontSize)
        return label
    }()
    
    private lazy var addressLabel1: UILabel = {
        let label = UILabel()
        label.text = "메인"
        label.font = .systemFont(ofSize: 13.0)
        return label
    }()
    
    private lazy var addressLabel2: UILabel = {
        let label = UILabel()
        label.text = "보조"
        label.font = .systemFont(ofSize: 13.0)
        return label
    }()
    
    private lazy var section30: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 1.0
        return stackView
    }()
    
    private lazy var section3: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .top
        stackView.spacing = 10.0
        return stackView
    }()
    
    private lazy var logoutButton: BBRoundedButton = {
        let button = BBRoundedButton(withText: "로그아웃")
        button.condition = .activate
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
        navigationItem.title = "마이페이지"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let user = bbUser else { return }
        BBNetworking.User.get(with: user) { result in
            switch result {
            case .success(let json):
                let retPck = json.arrayValue[0]["login"]
                let realm = try! Realm()
                try! realm.write {
                    user.name = retPck["name"].stringValue
                    user.mainAddr = retPck["address1"].stringValue
                    user.subAddr = retPck["address2"].string
                    user.phoneNumber = retPck["phone"].stringValue
                    user.gender = retPck["gender"].stringValue
                    user.buildingCode = retPck["building_code"].stringValue
                }
                self.titleNameLabel.text = user.name
                self.nameLabel1.text = user.name
                self.contactLabel1.text = user.phoneNumber
                self.addressLabel1.text = user.mainAddr
                self.addressLabel2.text = user.subAddr
            case .failure(let err):
                let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
                alert.title = "유저 불러오기 실패"
                alert.message = "에러: \(err.errorDescription)"
                alert.addAction(.init(title: "확인", style: .cancel, handler: { [weak self] _ in
                    let realm = try! Realm()
                    if let user = self?.bbUser {
                        try! realm.write {
                            realm.delete(user)
                        }
                    }
                    let viewController = BBSignUpViewController()
                    viewController.bbUser = BBUser()
                    let navigationController = UINavigationController(rootViewController: viewController)
                    navigationController.modalPresentationStyle = .fullScreen
                    self?.present(navigationController, animated: true, completion: nil)
                }))
                self.present(alert, animated: true, completion: nil)
            }
        }
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
        section0.insertArrangedSubview(titleNameLabel, at: 0)
        section0.insertArrangedSubview(titleSubLabel, at: 1)
        section1.insertArrangedSubview(nameLabel0, at: 0)
        section1.insertArrangedSubview(nameLabel1, at: 1)
        section2.insertArrangedSubview(contactLabel0, at: 0)
        section2.insertArrangedSubview(contactLabel1, at: 1)
        section30.insertArrangedSubview(addressLabel1, at: 0)
        section30.insertArrangedSubview(addressLabel2, at: 1)
        section3.insertArrangedSubview(addressLabel0, at: 0)
        section3.insertArrangedSubview(section30, at: 1)
        view.addSubview(section0)
        view.addSubview(dividerView)
        view.addSubview(section1)
        view.addSubview(editUserButton)
        view.addSubview(section2)
        view.addSubview(section3)
        view.addSubview(logoutButton)
    }
    
    private func layout() {
        section0.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.topMargin).offset(40)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leadingMargin).offset(40)
        }
        dividerView.snp.makeConstraints {
            $0.top.equalTo(section0.snp.bottom).offset(30)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(9)
        }
        section1.snp.makeConstraints {
            $0.top.equalTo(dividerView.snp.bottom).offset(38)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leadingMargin).offset(40)
        }
        editUserButton.snp.makeConstraints {
            $0.top.equalTo(dividerView.snp.bottom).offset(38)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailingMargin).offset(-40)
        }
        section2.snp.makeConstraints {
            $0.top.equalTo(section1.snp.bottom).offset(20)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leadingMargin).offset(40)
        }
        section3.snp.makeConstraints {
            $0.top.equalTo(section2.snp.bottom).offset(20)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leadingMargin).offset(40)
        }
        logoutButton.snp.makeConstraints {
            $0.top.equalTo(section3.snp.bottom).offset(50)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leadingMargin).offset(40)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailingMargin).offset(-40)
            $0.height.equalTo(42)
        }
    }
    
    private func rxRegister() {
        _ = editUserButton.rx
            .controlEvent(.touchUpInside)
            .bind(onNext: { _ in
                let viewController = BBMyPageEditViewController()
                viewController.bbUser = self.bbUser
                self.navigationController?.pushViewController(viewController, animated: true)
            }).disposed(by: disposeBag)
        _ = logoutButton.rx
            .controlEvent(.touchUpInside)
            .bind(onNext: { _ in
                let alert = UIAlertController(title: "로그아웃", message: "로그아웃 하시겠습니까?", preferredStyle: .alert)
                alert.addAction(.init(title: "확인", style: .default, handler: { _ in
                    let realm = try! Realm()
                    guard let user = self.bbUser else { return }
                    try! realm.write {
                        realm.delete(user)
                    }
                    let viewController = BBSignUpViewController()
                    viewController.bbUser = BBUser()
                    let navigationController = UINavigationController(rootViewController: viewController)
                    navigationController.modalPresentationStyle = .fullScreen
                    self.present(navigationController, animated: true, completion: nil)
                }))
                alert.addAction(.init(title: "취소", style: .cancel))
                self.present(alert, animated: true)
            }).disposed(by: disposeBag)
    }
}
