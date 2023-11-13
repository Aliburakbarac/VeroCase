import Foundation
import Alamofire

class ApiManager {
    static let shared = ApiManager()
    private let baseURL = "https://api.baubuddy.de/index.php"
    private var accessToken: String?

    private init() {
        accessToken = UserDefaults.standard.string(forKey: "accessToken")
    }

    func login() {
        let loginURL = baseURL + "/login"

        let headers: HTTPHeaders = [
            "Authorization": "Basic QVBJX0V4cGxvcmVyOjEyMzQ1NmlzQUxhbWVQYXNz",
            "Content-Type": "application/json"
        ]

        let parameters = [
            "username": "365",
            "password": "1"
        ]

        AF.request(loginURL, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    if let jsonObject = value as? [String: Any],
                       let oauth = jsonObject["oauth"] as? [String: Any],
                       let accessToken = oauth["access_token"] as? String {
                        self.accessToken = accessToken
                        UserDefaults.standard.set(accessToken, forKey: "accessToken")
                        print("yesss")
                    } else {
                        print("fail")
                    }
                case .failure:
                    print("feail")
                }
            }
    }

    func fetchData(completion: @escaping ([Task]?) -> Void) {
        guard let accessToken = accessToken else {
            completion(nil)
            return
        }

        let tasksURL = baseURL + "/tasks/select"

        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(accessToken)"
        ]

        AF.request(tasksURL, method: .get, headers: headers)
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    print("Success Response: \(value)")

                    do {
                        let data = try JSONSerialization.data(withJSONObject: value, options: [])
                        let tasks = try JSONDecoder().decode([Task].self, from: data)
                        completion(tasks)
                    } catch {
                        print("Error Decoding Data: \(error)")
                        completion(nil)
                    }
                case .failure(let error):
                    print("Error Fetching Data: \(error)")
                    completion(nil)
                }
            }
    }
}
