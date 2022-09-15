//
//  BBPolicyDetailViewController.swift
//  BaekBang
//
//  Created by 차상호 on 2021/06/22.
//
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import WebKit

class BBPolicyDetailViewController: UIViewController {

    private var url: URL?

    private var titleString: String?
    
    private var disposeBag = DisposeBag()
    
    private lazy var leftButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "완료", style: .plain, target: self, action: nil)
        return button
    }()

    private lazy var webView: WKWebView = WKWebView()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = titleString
        label.font = .systemFont(ofSize: 25.0, weight: .bold)
        return label
    }()

    public required init(withUrl url: URL?, andTitle titleString: String?) {
        self.url = url
        self.titleString = titleString
        super.init(nibName: nil, bundle: nil)
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not implemented!")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        arrange()
        layout()
        connect()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.view.backgroundColor = .clear
        navigationItem.leftBarButtonItem = leftButton
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
        view.addSubview(webView)
    }

    private func layout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.topMargin).offset(40)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leadingMargin).offset(40)
        }
        webView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(25)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leadingMargin).offset(40)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailingMargin).offset(-40)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottomMargin).offset(-40)
        }
    }

    private func connect() {
        guard let url = url else { return }
        webView.load(.init(url: url))
    }
    
    private func rxRegister() {
        leftButton.rx
            .tap
            .bind(onNext: { _ in
                self.dismiss(animated: true, completion: nil)
            }).disposed(by: disposeBag)
    }
}
