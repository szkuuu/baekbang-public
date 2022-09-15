//
//  User.swift
//  BaekBang
//
//  Created by 차상호 on 2021/06/24.
//

import RealmSwift

/// 유저 정보 Realm 객체
class BBUser: Object, Codable {
    /// ID
    @objc dynamic var id: UUID = UUID()
    
    /// 토큰
    @objc dynamic var token: String = ""
    
    /// 이름
    @objc dynamic var name: String = ""
    
    /// 성별
    @objc dynamic var gender: String = ""
    
    /// 메인 주소
    @objc dynamic var mainAddr: String = ""
    
    /// 서브 주소
    @objc dynamic var subAddr: String? = nil
    
    /// 건물 번호
    @objc dynamic var buildingCode: String = ""
    
    /// 휴대폰 번호('-' 제외)
    @objc dynamic var phoneNumber: String = ""
    
    /// 마케팅 수신 여부
    @objc dynamic var isAllowedMarketing: String = ""
}
