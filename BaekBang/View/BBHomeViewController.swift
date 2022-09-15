//
//  BBHomeViewController.swift
//  BaekBang
//
//  Created by 차상호 on 2021/06/22.
//

import UIKit
import SnapKit
import RealmSwift
import RxSwift
import RxCocoa

class BBHomeViewController: UIViewController {
    
    private var disposeBag = DisposeBag()
    
    open var bbUser: BBUser?
    
    private lazy var requestButton: BBRoundedButton = {
        let button = BBRoundedButton(withText: "수리 요청하기")
        button.condition = .activate
        return button
    }()
    
    private lazy var myPageButton: BBRoundedButton = {
        let button = BBRoundedButton(withText: "마이페이지")
        button.condition = .activate
        return button
    }()
    
    private lazy var logoImage: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "ImageLogo"))
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var homeImage: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "ImageHome"))
        return imageView
    }()
    
    private lazy var section0: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 20.0
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        arrange()
        layout()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        rxRegister()
        debugPrint(bbUser)
        guard let user = bbUser else { return }
        BBNetworking.User.get(with: user) { result in
            switch result {
            case .success(let json):
                let retPck = json.arrayValue[0]["login"]
                let realm = try! Realm()
                do {
                    try realm.write {
                        if realm.objects(BBUser.self).count == 0 {
                            realm.add(user)
                        }
                        user.name = retPck["name"].stringValue
                        user.mainAddr = retPck["address1"].stringValue
                        user.subAddr = retPck["address2"].string
                        user.phoneNumber = retPck["phone"].stringValue
                        user.gender = retPck["gender"].stringValue
                        user.buildingCode = retPck["building_code"].stringValue
                    }
                } catch let error as NSError {
                    print(error)
                }
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        disposeBag = DisposeBag()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    private func arrange() {
        view.addSubview(homeImage)
        view.addSubview(logoImage)
        section0.insertArrangedSubview(requestButton, at: 0)
        section0.insertArrangedSubview(myPageButton, at: 1)
        view.addSubview(section0)
    }
    
    private func layout() {
        homeImage.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
        }
        logoImage.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(172)
            $0.width.equalTo(logoImage.snp.height).multipliedBy(172.0 / 162.69)
        }
        section0.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottomMargin).offset(-70)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leadingMargin).offset(40)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailingMargin).offset(-40)
        }
        requestButton.snp.makeConstraints {
            $0.height.equalTo(42)
        }
        myPageButton.snp.makeConstraints {
            $0.height.equalTo(42)
        }
    }
    
    private func rxRegister() {
        _ = requestButton.rx
            .controlEvent(.touchUpInside)
            .bind(onNext: { _ in
                let viewController = BBRequestImagePickViewController()
                viewController.bbUser = self.bbUser
                let navigationController = UINavigationController(rootViewController: viewController)
                navigationController.modalPresentationStyle = .fullScreen
                self.present(navigationController, animated: true)
            }).disposed(by: disposeBag)
        _ = myPageButton.rx
            .controlEvent(.touchUpInside)
            .bind(onNext: { _ in
                let viewController = BBMyPageViewController()
                viewController.bbUser = self.bbUser
                self.navigationController?.pushViewController(viewController, animated: true)
            }).disposed(by: disposeBag)
    }
}

