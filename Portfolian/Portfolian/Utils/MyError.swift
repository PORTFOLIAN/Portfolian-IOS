//
//  MyError.swift
//  Portfolian
//
//  Created by 이상현 on 2021/11/30.
//

import Foundation

enum MyError : String, Error {
    case testError = "모든 항목을 입력해주세요"
    case retryError = "retry"
    case getProjectListError = "프로젝트를 가져오지 못했습니다."
    case adminError = "관리자에게 문의하세요"
}
