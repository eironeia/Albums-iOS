import RxSwift
@testable import Albums

struct MockAlbumsUseCase: AlbumsUseCaseInterface {
    var getAlbumsResponse: [Album]!
    func getAlbums(page: UInt) -> Single<[Album]> {
        .just(getAlbumsResponse)
    }
}
