@testable import Albums

final class MockLocalAlbumsProvider: LocalAlbumsProviderInterface {
    var getAlbumsResponse: [Album]?
    var getAlumsTimesCalled: UInt = 0

    func getAlbums(page: UInt) -> [Album]? {
        getAlumsTimesCalled += 1
        return getAlbumsResponse
    }
}
