@testable import Albums

final class MockLocalPhotosProvider: LocalPhotosProviderInterface {
    var getPhotosResponse: [Photo]?
    var getAlumsTimesCalled: UInt = 0

    func getPhotos(page: UInt, albumId: Int) -> [Photo]? {
        getAlumsTimesCalled += 1
        return getPhotosResponse
    }
}
