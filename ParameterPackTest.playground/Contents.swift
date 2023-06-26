import Foundation



// MARK: - Variadic Func Example

func sum(_ operands: Int...) -> Int {
  var sum = 0
  for op in operands {
    sum += op
  }

  return sum
}


print(sum(1,2,3,4,5,6,7,8))

// MARK: - Variadci Limitations

// 1. 만약 여러개의 인수를 받고 이걸 tuple로 만들어서 return 하고 싶음. -> 어떤 타입을 리턴해야?
// 2. variadic parameter는 다양한 타입을 사용할 수 없음.
// type erasure가 없으면 type erasure를 사용한다는 것. 이것은 전달인자의 specific한 static type의 information을 사용할 수 없다는 것을 의미함 -> 컴파일러가 알 수가 없게 되어버린다는 뜻


// 즉 지금까지 Swift의 한계점은
// 제니릭과 variadic parameter으로는 type information을 preserve 할 수 없었다는 것과 여러개의 전달인자를 사용할 수 없었다는 것을 의미하지

// 이것을 하는 방법은 overloading 밖에 없음

//func query<Payload>(
//    _ item: Request<Payload>
//) -> Payload
//
//func query<Payload1, Payload2>(
//    _ item1: Request<Payload1>,
//    _ item2: Request<Payload2>
//) -> (Payload1, Payload2)
//
//func query<Payload1, Payload2, Payload3>(
//    _ item1: Request<Payload1>,
//    _ item2: Request<Payload2>,
//    _ item3: Request<Payload3>
//) -> (Payload1, Payload2, Payload3)
//
//func query<Payload1, Payload2, Payload3, Payload4>(
//    _ item1: Request<Payload1>,
//    _ item2: Request<Payload2>,
//    _ item3: Request<Payload3>,
//    _ item4: Request<Payload4>
//) -> (Payload1, Payload2, Payload3, Payload4)

//let _ = query(r1, r2, r3, r4, r5) // 전달인자 개수 초과 컴파일 에러


// overloading 패턴의 문제점은 upper limit가 정해져있다는 것
// 이러한 문제들을 parameter pack이 해결해줄 수 있음
// swift 5.9에서 제네릭은 전달인자 길이에 대한 추상화가 가능하다. 파라미터 팩을 이용해서


// 그래 파라미터 팩이 뭐야?

// 타입 또는 값의 어떠한 양을 hold할 수 있고 그것을 pack 해서 전달인자로 넘겨줄 수 있음
// individual type들을 보관하는 type pack이라고 함
// Example. type pack - Bool, Int, String (3개의 인디뷰뎔 타입)
// 인디뷰얼 밸류들을 보관하는 것은 밸류 팩임
// Example.: true, 10, "" (3개의 밸류타입)

// 파라미터 팩이 컬렉션과 다른 것은 파라미터 팩에서 각각의 엘레먼트가 differnt static type이라는 것
// 그래서 파라미터 팩을 이용하면 type - level에서 작동할 수 있다. (각각 유형 처리 가능)

// each 키워드를 사용함
// <each parameter> -> type parameter pack

// 파라미터 팩을 사용하는 제네릭 코드는 repetition 패턴을 이용해 각 each Payload가 각각 작동할 수 있게함
// repeat 라는 것은 주어진 전달인자 팩에 모든 엘레멘트가 반복 될 것이라는 것을 의미해

struct Request<Payload> {
  var payload: Payload

  init(payload: Payload) {
    self.payload = payload
  }
}

// MARK: - Overloading 패턴 코드 구현

//func query<Payload1, Payload2, Payload3>(
//    _ item1: Request<Payload1>,
//    _ item2: Request<Payload2>,
//    _ item3: Request<Payload3>
//) -> (Payload1, Payload2, Payload3) {
//  return (item1.payload, item2.payload, item3.payload)
//}

//print(query(Request(payload: true), Request(payload: 10), Request(payload: "")))


// each Payload = Bool, Int, String 라고 가정하자
// 그러면 패턴은 세번 반복되고 each Payload 자리가 각 반복동안 concrete 타입으로 대체됨
// (Request<Bool>, Request<Int>, Request<String>) == (repeat Reqeust<each Payload>)
// 반복 패턴을 함수 매개변수 유형으로 사용하면 해당 함수 매개변수가 값 매개변수 팩으로 바뀝니다.

//(_ item: repeat Request<each Payload>)
// Request Instance 여러개를 인자로 넣으면 pack이 되고 함수를 통과할 것임


 // MARK: - 리팩토링 1.
//func query<each Payload>(
//  _ item: repeat (Request<each Payload>)
//) -> (repeat (each Payload)) {
//  return (repeat (each item).payload)
//}
//
//
//let result = query(
//  Request(payload: true),
//  Request(payload: 10),
//  Request(payload: "")
//)
//
//print(result)


// MARK: - 제네릭에 제약 조건 추가

// 1. 제네릭 선언부에 제약조건

//func query<each Payload: Equatable>(
//  _ item: repeat (Request<each Payload>)
//) -> (repeat (each Payload)) {
//  return (repeat (each item).payload)
//}


// 2. where Clause 제약조건

//func query<each Payload>(
//  _ item: repeat (Request<each Payload>)
//) -> (repeat (each Payload)) where repeat (each Payload): Equatable {
//  return (repeat (each item).payload)
//}


//class TestClass{

//  static func == (lhs: TestClass, rhs: TestClass) -> Bool {
//    return lhs.uuid == rhs.uuid
//  }
//  var uuid = UUID()
//}

//let result = query(
//  Request(payload: true),
//  Request(payload: 10),
//  Request(payload: "")
//)
//
//print(result)

//let result2 = query(
//  Request(payload: true),
//  Request(payload: 10),
//  Request(payload: ""),
//  Request(payload: TestClass())
//)

//print(result2)






//func query<each Payload: Equatable>(_ item: repeat Request<each Payload>) -> (repeat each Payload)
//func query<each Payload>(_ item: repeat Request<each Payload>) -> (repeat each Payload) where repeat each Payload: Equatable

// 최소한의 한개 전달인자는 넘기게 만드는 방법 (최소한의 전달인자 길이 보장)

//func query<FirstPayload, each Payload>(
//  _ first: Request<FirstPayload>, _ item: repeat Request<each Payload>
//) -> (FirstPayload, repeat each Payload) where FirstPayload: Equatable, repeat each Payload: Equatable {
//  return (first.payload, repeat (each item).payload)
//}
//
//let result = query(
//  Request(payload: true),
//  Request(payload: 10),
//  Request(payload: "")
//)
//
//print(result)


// MARK: - 여기에서 파라미터 팩 VariadicGenerics는 experimental이라서 안됨


// 이걸 할거임
// 1. Add stored state for the query
// 2. input, output types을 다르게 할것 (differ the input, and output type)
// 3. manage control flow during parameter pack iteration


//
//let result = query(
//  Request(payload: true),
//  Request(payload: 10),
//  Request(payload: "")
//)

//print(result)





//struct Request<Payload> {
//    func evaluate() -> Payload
//}
//
//struct Evaluator {
//  func query<each Payload>(_ item: repeat Request<each Payload>) -> (repeat each Payload) {
//    return (repeat (each item).evaluate())
//  }
//}


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


// 2번을 달성해보자

/// ------
//protocol Request {
//  associatedtype Input
//  associatedtype Output
//  func evaluate(_ input: Input) -> Output
//}

// 이게 안되는 이유는
// 페이로드는 더 이상 Request 내에 포함된 것이 아니라 Request 전체를 준수하기 때문임
//그래서 아래와 같이 변경하자 (Evaluator 아래)
//struct Evaluator<each Payload: Request> {
//
//  var item: (repeat each Payload)
//  func query() -> (repeat each Payload) {
//    return (repeat (each item).evaluate())
//  }
//}

// ---------

//protocol RequestProtocol {
//  associatedtype Input
//  associatedtype Output
//  func evaluate(_ input: Input) -> Output
//}

//struct Evaluator<each Request: RequestProtocol> {
//
//  var item: (repeat each Request)
//  func query(_ input: repeat (each Request).Input) -> (repeat (each Request).Output) {
//    return (repeat (each item).evaluate(each input))
//  }
//}



// Given that using parameter packs is a form of iteration, you might wonder about control flow if you were to want to exit early from the iteration. Perhaps it is the case that the consequences of a collection of queries should only take effect if every query is successful.

// 매개 변수 팩을 사용하는 것이 반복의 한 형태이기 때문에 반복을 조기에 종료하려면 제어 흐름에 대해 의문을 가질 수 있습니다. 모든 쿼리가 성공한 경우에만 쿼리 모음의 결과가 적용됩니다.

// Throwing errors can be used for this. In our example, you could update RequestProtocol's evaluate method to be a throwing function and modify the return type of Evaluator's query method to be optional.

// 던지기 오류를 사용할 수 있습니다. 이 예에서는 RequestProtocol의 evaluate 메서드를 스로우 기능

// 3번 아래 코드를 아래아래 코드처럼 바꾸자

//protocol RequestProtocol {
//  associatedtype Input
//  associatedtype Output
//  func evaluate(_ input: Input) -> Output
//}
//struct Evaluator<each Request: RequestProtocol> {
//
//  var item: (repeat each Request)
//  func query(_ input: repeat (each Request).Input) -> (repeat (each Request).Output) {
//    return (repeat (each item).evaluate(each input))
//  }
//}

// 완성코드

protocol RequestProtocol {
  associatedtype Input
  associatedtype Output
  func evaluate(_ input: Input) -> throws Output
}

struct Evaluator<each Request: RequestProtocol> {
  var item: (repeat each Request)

  func query(_ input: repeat (each Request).Input) -> (repeat (each Request).Output)? {
    do {
      return (repeat try (each item).evaluate(each input))
    } catch {
      return nil
    }
  }
}

//
//
//struct Evaluator<each Request: RequestProtocol> {
//
//  func query(_ input: repeat (each Request).Input) -> Bool {
//    return false
//  }
//
//}
//
//print("sdfdssdf")
//
//struct A: RequestProtocol {
//
//  func evaluate(_ input: String) -> String {
//    return input
//  }
//  
//  typealias Input = String
//  typealias Output = String
//
//}
//let request = A()

//let tt = Evaluator().query(<#T##input: repeat (_).Input##repeat (_).Input#>)
//func query<each Payload>(_ item: repeat Request<each Payload>) -> (repeat each Payload) {
//}

//query(Request(payload: Int(3)), Request(payload: true))
