//
//  Request.swift
//  BaekBang
//
//  Created by 차상호 on 2021/06/24.
//

import Foundation

/// 수리요청 데이터 객체
struct BBRequest: Hashable, Codable {
    /// 수리 요청자 정보
    var user: BBUser? = nil
    
    /// 수리 내용 사진
    var pictures: [Data?] = [nil,]
    
    /// 수리 내용
    var content: String = ""
    
    /// 방문 메인 주소
    var mainAddr: String = ""
    
    /// 방문 서브 주소
    var subAddr: String? = nil
    
    /// 방문 건물번호
    var buildingCode: String = ""
    
    /// 휴대전화 번호
    var phoneNumber: String = ""
    
    /// 안심번호 여부
    var isSecure: Bool = false
    
    /// 방문 요일
    var visitDay: String = ""
    
    /// 방문 시간대
    var visitTime: String = ""
}
