## 모듈 구조
![graph](https://github.com/dodo849/MediaApp/assets/71880682/46fa5645-6f67-450a-b7eb-c3c9ff873db8)

- **MainApp**
  > 전체 앱을 구성하는 단일 진입점
  - `MediaApp`
- **Feature**
  > 뷰를 통해 유저와 상호작용 및 비즈니스 로직 수행
  
  |구성|역할|
  |--|--|
  | View | 화면 스타일링 및 유저 액션 바인딩 |
  | Feature(TCA) | 상태관리 및 비즈니스 로직 수행 |
  | Converter | 외부 모듈 데이터 타입을 Feature 데이터 타입(Model)으로 변환 |
  | Model | View와 Feature에서 사용하는 데이터 타입 |
  - **세부모듈**
    - `Scrap`: 스크랩한 이미지/비디오 표시
    - `Search`: 이미지/비디오 검색, 스크랩
- **Network**
  > 네트워크를 이용해 외부 API 접근
  
  |구성|역할|
  |--|--|
  | Repository | 외부 API 접근 |
  | Response(DTO) | 외부 API 데이터 스키마 |
  -  **세부모듈**
      - `Media`: 이미지/비디오 관련 서버 데이터 접근
- **Database**
  > 내부 데이터베이스에 접근
  
  |구성|역할|
  |--|--|
  | Repository | 내부 데이터베이스 접근 |
  | PersistenceModel | 데이터베이스 스키마 | 
  - **세부모듈**
    - `Media`: 이미지/비디오 관련 내부 DB 데이터 접근
- **Core**
  > 앱 전반에 걸친 공통 기능을 수행
  - **세부모듈**
    - `Cache`: 서버 데이터 캐싱

<br/>

## 유즈케이스
### SearchView
시나리오 | 스크랩된 미디어가 없음 | 스크랩된 미디어가 있음 | 로딩 플레이스홀더 |
|--|--|--|--|
| 화면 |![simulator_screenshot_905CD9B1-7B81-48D6-996D-EB51B865754E](https://github.com/dodo849/MediaApp/assets/71880682/18773d35-9f4f-4c09-973e-5a92899b4914) | ![simulator_screenshot_AFDA065F-67F5-4067-A10E-878BBB45A7BC](https://github.com/dodo849/MediaApp/assets/71880682/225f054b-8dea-40a7-bbc1-01a8e1a91a90) | ![Simulator Screen Recording - iPhone 15 - 2024-07-08 at 17 42 09](https://github.com/dodo849/MediaApp/assets/71880682/6a772f8c-9a54-41b2-9b15-773cec82a575)
|


### SearchView
시나리오 | 검색어가 비었거나 결과가 없음 | 검색어 입력 | 미디어 스크랩 | 네트워크 연결 없음 |
|--|--|--|--|--|
| 화면 | ![simulator_screenshot_722DA42F-4DA5-4B62-A557-D20A26F4E86A](https://github.com/dodo849/MediaApp/assets/71880682/d77b21a4-9472-49d7-9789-ea0cb2fcb736) | ![simulator_screenshot_E5E8D9A0-2CE9-425D-AF3C-5F54EED410ED](https://github.com/dodo849/MediaApp/assets/71880682/11042ab9-f4f7-4ae4-8b5d-933e72189b27) | ![simulator_screenshot_4552009E-0290-40FB-AD2A-A21B0D4F4F93](https://github.com/dodo849/MediaApp/assets/71880682/5f9930e1-0447-4b20-ac87-feca5773333a) | ![simulator_screenshot_036019A5-BA7B-4449-8A40-649DFF668C72](https://github.com/dodo849/MediaApp/assets/71880682/91116b3b-a89b-40f3-bc80-50c2778119e9) | 

### 시연 영상


https://github.com/dodo849/MediaApp/assets/71880682/011307be-e832-43b4-80ce-56ff6b5e4be4




<br/>

## 캐싱
* 이미지 캐싱: `Kingfisher` 라이브러리 이용
* 서버데이터 캐싱: `NSCache` 이용
### 서버데이터 캐싱
> 서버에서 전달받은 JSON(Codable) 데이터를 메모리 캐시합니다.

캐시키에 대한 protocol을 Enum으로 구현해 CacheQuery 객체에 제네릭으로 전달함으로써 각 요청에 대해 고유한 키값 보장합니다.
```swift
public protocol CacheQueryKey {
    var key: String { get }
}

public extension CacheQueryKey {
    var key: String {
        return "\(type(of: self))_\(self)"
            .replacingOccurrences(of: " ", with: "_")
    }
}

// 구현
enum FetchQueryKey: CacheQueryKey {
    case image(keyword: String)
    case video(keyword: String)
}
```

캐시 로직을 추가한 프록시 클로저를 이용해 데이터를 요청할 수 있습니다.
```swift
public class CacheQuery<Key: CacheQueryKey> {
  public func makeQuery<Value: Codable>(
          key: Key,
          expiry: TimeInterval = 60 * 5, // expiry in seconds
          query: @escaping () async throws -> Value
      ) -> () async throws -> Value { ... }
}

// 사용
let cacheQuery = CacheQuery<FetchQueryKey>() // 구조체 or 클래스 멤버로 선언

let fetchQuery = cacheQuery.makeQuery(
  key: .image(keyword: "apple")
) {
  // URLSession.shared.dataTask ...
}
```
만료된 서버 데이터는 Timer를 이용해 자동으로 삭제합니다.
```swift
/// 만료된 캐시 데이터를 삭제하는 타이머 실행합니다.
private func startCleanUpTimer() {
    timer = Timer.scheduledTimer(
        withTimeInterval: cleanUpInterval,
        repeats: true
    ) { [weak self] _ in
        self?.logger.debug("Cleanup the cache")
        self?.cleanUpExpiredCache()
    }
}

/// 만료된 캐시를 삭제합니다.
private func cleanUpExpiredCache() {
    let now = Date()
    for (key, expiryDate) in expiryDates where expiryDate <= now {
        cache.removeObject(forKey: key)
        expiryDates.removeValue(forKey: key)
        logger.debug("Removed expired cache for key: \(key)")
    }
}
```

## TCA

TCA Action의 가독성 및 접근제어를 위해 Action을 하위 Enum으로 분리했습니다. ref: https://channel.io/ko/blog/swift_composable_architecture
```swfit
/// Feature Action 분리를 위한 프로토콜
public protocol FeatureAction {
    associatedtype ViewAction
    associatedtype InnerAction
    associatedtype AsyncAction
    associatedtype ScopeAction
    associatedtype DelegateAction
    
    /// View에서 접근하는 Action
    static func view(_: ViewAction) -> Self
    
    /// Reducer 내부적으로 사용되는 Action
    static func inner(_: InnerAction) -> Self
    
    /// 비동기 처리를 수행하는 Action
    static func async(_: AsyncAction) -> Self
    
    /// 자식에게 전달하는 Action
    static func scope(_: ScopeAction) -> Self
    
    /// 부모에서 주입받는 Action
    static func delegate(_: DelegateAction) -> Self
}
```
Feature(Reducer)내부에서 Action에서 FeatureAction을 채택해 사용합니다.
```swift
  public enum Action: FeatureAction, Equatable {
      case view(ViewAction)
      case inner(InnerAction)
      case async(AsyncAction)
      case scope(ScopeAction)
      case delegate(DelegateAction)
  }
  
  public enum ViewAction: Equatable { // ... }
  public enum InnerAction: Equatable { // ... }
  public enum AsyncAction: Equatable { // ... }
  public enum ScopeAction: Equatable { // ... }
  public enum DelegateAction: Equatable { // ... }
```

View에서는 typealias와 scope 기능을 이용해 ViewAction만 사용할 수 있도록 접근을 제한합니다.
```swift
public struct SearchView: View {
    public typealias ViewAction = SearchFeature.ViewAction
    public typealias ViewState = SearchFeature.State
    
    @Perception.Bindable private var store: Store<ViewState, ViewAction>
    
    public init(store: StoreOf<SearchFeature>) {
        self.store = store.scope(
            state: \.self,
            action: \.view
        )
    }
// ...
```
<br/>

## 라이브러리
라이브러리명 | 용도 | 버전 | Git
|--|--|--|--|
swift-composable-architecture |	상태관리 	| 1.11.0 이상| [swift-composable-architecture](https://github.com/pointfreeco/swift-composable-architecture.git)
swift-dependencies |의존성 주입| 1.0.0 이상| [swift-dependencies](https://github.com/pointfreeco/swift-dependencies)
Alamofire	| 네트워킹 라이브러리	| 5.9.0 이상	| [Alamofire](https://github.com/Alamofire/Alamofire.git)
realm-swift	| 내부 데이터베이스 |	10.50.0 이상 |	[realm-swift](https://github.com/realm/realm-swift.git)
Kingfisher | 이미지 다운로드 및 캐싱 | 7.10.0 이상 |	[Kingfisher ](https://github.com/onevcat/Kingfisher.git)

<br/>

## API
카카오 검색 API 이용

| 구분 |	문서 |
|--|--|
|동영상 검색| https://developers.kakao.com/docs/latest/ko/daum-search/dev-guide#search-video |
|이미지 검색	| https://developers.kakao.com/docs/latest/ko/daum-search/dev-guide#search-image |
