//: Playground - noun: a place where people can play

import UIKit
import RxSwift
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

//code executed when object subscribes to Observable
var counter = 0

let hello = Observable<String>.create({ observer -> Disposable in
    counter = counter + 1
    observer.on(.next("Hello world!!")) //observer.onNext("Hello World")
    observer.on(.completed)             //observer.onCompleted()
    return Disposables.create()
})

//subscribe object
let subscriber = hello.subscribe(onNext: { value in
    print(value)
})
//subscribe object
let subscriber2 = hello.subscribe(onNext: { value in
    print(value)
})

//Empty observable
let empty = Observable<Void>.empty().subscribe(onCompleted:{
    print("LOL")
})

print(counter)

//TYPE 2
let _ = Observable.just("Destroy humans")
    .subscribe(
        onNext: { value in
        print(value)
    },onCompleted: {
        print("You shall complete!!")
    })

//Error 
let error = Observable<Void>.error(NSError(domain: "test", code: 42, userInfo: nil))

let _ = error.subscribe(
    onNext: { _ in
        print("You shall not pass!! -- NEXT")
    },
    onError: { error in
        print("You shall pass!! -- ERROR")
        print(error)
    },
    onCompleted: {
        print("You shall not pass!! -- COMPLETED")
    },
    onDisposed: {
        print("You shall not pass!! -- DISPOSED")
    })




