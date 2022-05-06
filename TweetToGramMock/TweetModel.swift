//
//  TweetModel.swift
//  TweetToGramMock
//
//  Created by Val V on 14/04/22.
//

import Foundation


struct ReturnedTweet: Codable {
    let id: String
    let text: String
    let authorName: String
    let authorUsername: String
    let profileImageURL: String
    let userVerified: Bool
}

struct Response: Codable {
    let data: Tweet
    let includes: Includes
}

struct Tweet: Codable {
    let id: String
    let text: String
    let author_id: String
}
struct Includes: Codable {
    let users: [User]
}

struct User: Codable {
    let id: String
    let name: String
    let username: String
    let profileImageURL: String
    let verified: Bool
}

extension User {
    enum CodingKeys: String, CodingKey {
        case id, name, username, verified
        case profileImageURL = "profile_image_url"
    }
}

class TweetModel{
    
    enum HttpError: Error {
        case badResponse
        case badURL
    }
        func fetchTweet(url: String, completion: @escaping (Result<ReturnedTweet, Error>) -> Void) {
            do {
                var request = URLRequest(url: try createURL(url: url),
                                         timeoutInterval: Double.infinity)
                
                request.addValue("Bearer \(Secret.key)", forHTTPHeaderField: "Authorization")
                
                request.httpMethod = "GET"
                
                let task = URLSession.shared.dataTask(with: request) { data, response, error in
                    
                    guard error == nil else {
                        completion(.failure(error!))
                        return
                    }
                    
                    if let response = response as? HTTPURLResponse {
                        guard (200 ... 299) ~= response.statusCode else {
                            completion(.failure(HttpError.badResponse))
                            print("❌ Status code is \(response.statusCode)")
                            return
                        }
                        
                        guard let data = data else {
                            completion(.failure(error!))
                            return
                        }
                        
                        do {
                            let result = try JSONDecoder().decode(Response.self, from: data)
                            let r = ReturnedTweet(id: result.data.id, text: result.data.text, authorName: result.includes.users[0].name, authorUsername: result.includes.users[0].username, profileImageURL: self.getImageURL(str: result.includes.users[0].profileImageURL), userVerified: result.includes.users[0].verified)
                           completion(.success(r))
                        } catch {
                            completion(.failure(error))
                        }
                    }
                }
                task.resume()
            } catch {
                completion(.failure(HttpError.badURL))
            }
        }
        
         func createURL(url: String) throws -> URL {
            let apiURL = "https://api.twitter.com/2/tweets"
            let expansions = "author_id&user.fields=profile_image_url,verified"
            
            
            guard url.contains("twitter.com") else {
                throw HttpError.badURL
            }
            
             let id = url.components(separatedBy: "/").last!.components(separatedBy: "?")[0]
             print(id)
            
            guard let completeURL = URL(string: "\(apiURL)/\(id)?expansions=\(expansions)") else {
                throw HttpError.badURL
            }
            return completeURL
        }
    
    func getImageURL(str:String)->String{
        print(str)
        var url = str
        let wordToRemove = "_normal"
        if let range = url.range(of: wordToRemove) {
           url.removeSubrange(range)
        }

        return url
    }
    }


extension Data {
    var prettyPrintedJSONString: NSString? { /// NSString gives us a nice sanitized debugDescription
        guard let object = try? JSONSerialization.jsonObject(with: self, options: []),
              let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
              let prettyPrintedString = NSString(data: data, encoding: String.Encoding.utf8.rawValue) else { return nil }

        return prettyPrintedString
    }
}
