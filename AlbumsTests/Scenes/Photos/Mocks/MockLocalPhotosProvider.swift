@testable import Albums

final class MockLocalPhotosProvider: PhotosPageDatabaseInterface {
    var getPhotosPageResponse: PhotoPageDB?
    var getPhotosPageTimesCalled: UInt = 0
    func getPhotosPage(page: UInt, albumId: Int) -> PhotoPageDB? {
        getPhotosPageTimesCalled += 1
        return getPhotosPageResponse
    }
    var savePhotosPageTimesCalled: UInt = 0
    func savePhotosPage(_ photoPageDB: PhotoPageDB, albumId: Int) {
        savePhotosPageTimesCalled += 1
    }
}
