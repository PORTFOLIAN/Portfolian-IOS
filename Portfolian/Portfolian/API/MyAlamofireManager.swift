//
//  AlamofireManager.swift
//  Portfolian
//
//  Created by 이상현 on 2021/11/22.
//

import Foundation
import Alamofire
import SwiftyJSON
final class MyAlamofireManager {
    // 싱글턴 사용
    static let shared = MyAlamofireManager()
    
    // 인터셉터
    let interceptors = Interceptor(interceptors:
                                    [
                                        BaseInterceptor()
                                    ])
    
    // 로거 설정
    let monitors = [MyLogger()] as [EventMonitor]
    
    // 세션 설정
    var session : Session
    private init() {
        session = Session(
            interceptor: interceptors,
            eventMonitors: monitors
        )
    }
    
    func getProjectID(projectTerm projectArticle: ProjectArticle, completion: @escaping (Result<RecruitWriting, MyError>) -> Void) {
        self.session
            .request(MyProjectRouter.createProject(term: projectArticle))
            .validate(statusCode: 200..<401) // Au th 검증
            .responseJSON  { response in
//                guard let self = self else { return }
                
                guard let responseValue = response.value else { return }
                
                let responseJson = JSON(responseValue)

                // 데이터 파싱
                guard let code = responseJson["code"].int,
                      let message = responseJson["message"].string else { return }
                
                if code == 1 {
                    guard let projectID = responseJson["newProjectID"].string else { return }
                    recruitWriting.code = code
                    recruitWriting.newProjectID = projectID
                    recruitWriting.message = message
                    completion(.success(recruitWriting))
                    
                } else {
                    completion(.failure(.testError))
                }
            }
    }
    
    func getProject(projectID: String, completion: @escaping (Result<ProjectInfo, MyError>) -> Void) {
        self.session
            .request(MyProjectRouter.enterProject(projectID: projectID))
            .validate(statusCode: 200..<401) // Auth 검증
            .responseData { response in
                guard let responseData = response.data else { return }
                guard let projectInfo = try? JSONDecoder().decode(ProjectInfo.self, from: responseData) else { return }

                completion(.success(projectInfo))
            }
    }
    
    func getProjectList(searchOption: ProjectSearch, completion: @escaping (Result<ProjectListInfo, MyError>) -> Void) {
        self.session
            .request(MyProjectRouter.arrangeProject(searchOption: searchOption))
            .validate(statusCode: 200..<401) // Auth 검증
            .responseData { response in
                
                guard let responseData = response.data else { return }
                projectListInfo = try! JSONDecoder().decode(ProjectListInfo.self, from: responseData)
                let code = projectListInfo.code
                if code == 1 {
                    completion(.success(projectListInfo))
                } else {
                    completion(.failure(.getProjectListError))
                }
            }
    }
    func postKaKaoToken(token: String, completion: @escaping (Result<Jwt, MyError>) -> Void) {
        self.session
            .request(MyOauthRouter.postKaKaoToken(token: token))
            .validate(statusCode: 200..<401) // Auth 검증
            .responseData { response in
                guard let responseData = response.data else { return }
                guard let jwt = try? JSONDecoder().decode(Jwt.self, from: responseData) else { return }
                let code = jwt.code
                if code == 1 {
                    completion(.success(jwt))
                } else {
                    completion(.failure(.getProjectListError))
                }
            }
    }
    func patchNickName(nickName: String, completion: @escaping (Result<Int, MyError>) -> Void) {
        self.session
            .request(MyUserRouter.patchNickName(nickName: nickName))
            .validate(statusCode: 200..<401) // Auth 검증
            .responseJSON { response in
                guard let responseValue = response.value else { return }
                
                let responseJson = JSON(responseValue)
                guard let code = responseJson["code"].int,
                      let message = responseJson["message"].string else { return }
                if code == 1 {
                    
                    completion(.success(code))
                    
                } else {
                    completion(.failure(.testError))
                }
            }
    }
    func getMyProfile(completion: @escaping (Result<User, MyError>) -> Void) {
        self.session
            .request(MyUserRouter.getMyProfile)
            .validate(statusCode: 200..<401) // Auth 검증
            .responseData { response in
                
                guard let responseData = response.data else { return }
                guard let user = try? JSONDecoder().decode(User.self, from: responseData) else { return }
                
//                let code = user.code
//                if code == 1 {
                    completion(.success(user))
//                } else {
//                    completion(.failure(.getProjectListError))
//                }
            }
    }
}
