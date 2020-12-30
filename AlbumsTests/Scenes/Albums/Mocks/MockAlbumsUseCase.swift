import RxSwift
@testable import Albums

struct MockAlbumsUseCase: AlbumsUseCaseInterface {
    func getAlbums(page: UInt) -> Single<[Album]> {
        .just([Album]())
    }
}
