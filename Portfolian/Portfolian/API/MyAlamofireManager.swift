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
            .responseJSON  { [weak self] response in
                guard let self = self else { return }
                
                guard let responseValue = response.value else { return }
                
                let responseJson = JSON(responseValue)
                
                // 데이터 파싱
                let code = responseJson["code"].intValue
                guard let projectID = responseJson["newProjectID"].string,
                      let message = responseJson["message"].string else { return }
                recruitWriting.code = code
                recruitWriting.newProjectID = projectID
                recruitWriting.message = message

                if code == 1 {
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
            .responseJSON  { response in
                guard let responseValue = response.value else { return }
                let responseJson = JSON(responseValue)
                // 데이터 파싱
                let contents = responseJson["contents"]
                let leader = responseJson["leader"]
                let capacity = contents["capacity"].intValue
                let view = contents["view"].intValue
                let status = contents["status"].intValue
                let code = responseJson["code"].intValue
                var stackList:[String] = []
                for stringInArray in responseJson["stackList"] {
                    stackList.append(stringInArray.1.stringValue)
                }
                guard let projectId = responseJson["projectID"].string,
                      let title = responseJson["title"].string,
                      let subjectDescription = contents["subjectDescription"].string,
                      let projectTime = contents["projectTime"].string,
                      let recruitmentCondition = contents["recruitmentConditon"].string,
                      let progress = contents["progress"].string,
                      let description = contents["description"].string,
                      let detail = contents["detail"].string,
                      let bookMark = contents["bookMarks"].bool,
                      

                      let userId = leader["userId"].string,
                      let nickName = leader["nickName"].string,
                      let leaderDescription = leader["description"].string,
                      let photo = leader["photo"].string else { return }
                let projectInfo = ProjectInfo(code: code, projectId: projectId, title: title, stackList: stackList, subjectDescription: subjectDescription, projectTime: projectTime, recruitmentCondition: recruitmentCondition, progress: progress, description: description, detail: detail, capacity: capacity, view: view, bookMark: bookMark, status: status, NickName: nickName, leaderDescription: leaderDescription, userId: userId, photo: photo)
                print(projectInfo.stackList)
                completion(.success(projectInfo))
            }
    }
    
}
