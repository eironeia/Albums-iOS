# Albums-iOS

## Architecture

My decision for the architecture has been use MVVM. The reason behind that is that I am familiar with it and since the models from the API doesn't require high amount of modification in terms of getting presented, I didn't chose an approach as it could be VIPER or VIP. Also I use Repository for the Network layer (MVVM-CR).

Other patterns that I have used are Coordinator pattern for handling the navigation. Factory pattern in order to create dependencies in a way that can easily be tested.

## Frameworks used

* **RxSwift & RxCocoa:** Benefits from RxSwift and RxCocoa are multiples as simplified Asynchronous declative code and multithreading, therefore you endup having a cleaner and more readable code and architecture. Allows composability. It's multi platform, which means if you learn it in Swift you will be able to use it in any other of the other languages that supports it (http://reactivex.io/languages.html). It's open source which means that has a huge community behind it, which means that likelihood of not being up to date it's unlikely. The downsides of this framework, which it's possible that will easily integrate all over the place in your aapp, are learning process at the beginning it's going to seem rough, but worth it on my opinion. Since you will be working with asynchronous code it might lead to memory leaks if not handled properly. Last one is debugging, usually has a big stack trace which make it sometimes hard to find the issue.

* **PKHUD:** I have used it for the loader. I didn't want to necessarily spend so many time on creating a loader since UI was important but not critical. I have had experience with this framework and it has really nice and easy integration.

* **SwiftLint & Swiftformat:** I have used it for giving format to code and be consistent all over the places with the styling.

* **RxTest & RxBlocking:** I have used them to test the stream of events generated for the views.

* **Kingfisher:** I have used it to load the images from the URL, used mainly because of being handy, not because it's solves a big problem.

## Improvements

- [ ] Replace the UserDefaults persistance for a more convinient due to that probably we will be sotring a big amount of data and that will increase the memory usage. For example use Realm or CoreData.
