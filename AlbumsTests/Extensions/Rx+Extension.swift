import Foundation
import XCTest
import RxSwift
import RxCocoa
import RxTest
@testable import Albums

extension ObservableType {
    func drive(withObserver observer: TestableObserver<Element>?) -> Disposable {
        if let observer = observer {
            return asDriverOnErrorJustComplete().drive(observer)
        } else {
            return asDriverOnErrorJustComplete().drive()
        }
    }
}


extension PrimitiveSequenceType where Self.Trait == RxSwift.SingleTrait {
    func verifySuccessfulRequest(expectation: XCTestExpectation) -> Disposable {
        self.subscribe(onSuccess: { _ in
            expectation.fulfill()
        }, onError: { error in
            XCTFail(error.localizedDescription)
        })
    }
}
