@testable import Albums

final class MockLocalAlbumsProvider: AlbumsPageDatabaseInterface {

    var getAlbumsResponse: AlbumPageDB?
    var getAlbumsTimesCalled: UInt = 0
    func getAlbumsPage(page: UInt) -> AlbumPageDB? {
        getAlbumsTimesCalled += 1
        return getAlbumsResponse
    }

    var saveAlbumsTimesCalled: UInt = 0
    func saveAlbumsPage(_ albumPageDB: AlbumPageDB) {
        saveAlbumsTimesCalled += 1
    }
}
