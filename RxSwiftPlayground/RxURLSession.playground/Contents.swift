//: Playground - noun: a place where people can play

import UIKit
import RxSwift
import PlaygroundSupport

//Make the playground work with RxSwift
PlaygroundPage.current.needsIndefiniteExecution = true

//Make URLSession correctly working DISABLE CACHE
URLCache.shared = URLCache(memoryCapacity: 0, diskCapacity: 0, diskPath: nil)

typealias JSONDictionary = [String: Any]

enum Errors: Error {
    
    case wrongUrl(String)
    case httpError(String)
    case invalidData(Any,String)
    case keyInJsonNotFound(String)
    
}

extension URLSession {
    
    func data(urlString: String) -> Observable<Data> {
        return Observable.create({ (observer: AnyObserver) -> Disposable in
            
            guard let url = URL.init(string: urlString) else {
                fatalError("Not a URL")
            }
            
            let request = URLRequest(url: url)
            
            let task = self.dataTask(with: request, completionHandler: { (data, response, error) in
                
                if let error = error {
                    observer.onError(error)
                }
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    fatalError("Unsupported protocol!!")
                }
                
                if !(200..<300 ~= httpResponse.statusCode) {
                    observer.onError(Errors.httpError("Status code: " + httpResponse.description))
                }
                
                observer.onNext(data ?? Data())
                observer.onCompleted()
                
            })
            
            task.resume()
            
            return Disposables.create {
                task.cancel()
            }
        })
    }
    
}

let webpage = URLSession.shared.data(urlString: "http://www.ericrisco.com")

let disposable = webpage.subscribe(onNext: { (data: Data) in
    let value = String(data: data, encoding: .ascii)
})

let webPageAsText = webpage.map { data in
    return String(data: data, encoding: .ascii)
}

let _ = webPageAsText.subscribe(onNext: {
    print($0!)
})


