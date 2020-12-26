import XCTest
import RxSwift
import RxTest

@testable import Albums

final class AlbumsProviderTests: XCTestCase {
    var sut: AlbumsProvider!

    override func setUp() {
        super.setUp()
        sut = AlbumsProvider()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func test_getAlbumProvider() {
        let albums = sut.getAlbums()
        XCTAssertEqual(albums, [Album]())
    }
}
