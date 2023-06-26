//
//  Model.swift
//  ParameterPack
//
//  Created by 김호세 on 2023/06/25.
//

//struct Request<Payload> {
//    func evaluate() -> Payload
//}
//
//struct Evaluator<each Payload> {
//
//  // 저장할 수 있는 프로퍼티가 있어야 하니까 (1번 달성하기 위해)
//  var item: (repeat Request<each Payload>)
//  func query() -> (repeat each Payload) {
//    return (repeat (each item).evaluate())
//  }
//}

//protocol RequestProtocol {
//  associatedtype Input
//  associatedtype Output
//  func evaluate(_ input: Input) throws -> Output
//}
//
//struct Evaluator<each Request: RequestProtocol> {
//  var item: (repeat each Request) // tuple
//
//  func query(_ input: repeat each Request.Input) -> (repeat each Request.Output)? {
//
//    let tup = repeat (each item).evaluate(each input)
//
//    do {
//      return (repeat try (each item).evaluate(each input))
//    } catch {
//      return nil
//    }
//}



//struct Request<Payload> {
//  var payload: Payload
//  func evaluate() -> Payload {
//    return payload
//  }
//}
//
//func query<each Payload>(_ item: repeat Request<each Payload>) -> (repeat each Payload) {
//    return (repeat (each item).evaluate())
//}


