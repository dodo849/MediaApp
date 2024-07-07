## 모듈 구조
![graph](https://github.com/dodo849/MediaApp/assets/71880682/46fa5645-6f67-450a-b7eb-c3c9ff873db8)

- **MainApp**
  > 전체 앱을 구성하는 단일 진입점
  - `MediaApp`
- **Feature**
  > 뷰를 통해 유저와 상호작용 및 비즈니스 로직 수행
  - `Scrap`: 스크랩한 이미지/비디오 표시
  - `Search`: 이미지/비디오 검색, 스크랩
- **Network**
  > 네트워크를 이용해 외부 API 접근
  - `Media`: 이미지/비디오 관련 서버 데이터 접근
- **Database**
  > 내부 데이터베이스에 접근
  - `Media`: 이미지/비디오 관련 데이터 내부 DB 저장
- **Core**
  > 앱 전반에 걸친 공통 기능을 수행
  - `Cache`: 서버 데이터 캐싱

## 라이브러리
이름 | 용도 | 버전 | Git
|--|--|--|--|
swift-composable-architecture |	상태관리 	| 1.11.0 이상| [swift-composable-architecture](https://github.com/pointfreeco/swift-composable-architecture.git)
swift-dependencies |의존성 주입| 1.0.0 이상| [swift-dependencies](https://github.com/pointfreeco/swift-dependencies)
Alamofire	| 네트워킹 라이브러리	| 5.9.0 이상	| [Alamofire](https://github.com/Alamofire/Alamofire.git)
realm-swift	| 내부 데이터베이스 |	10.50.0 이상 |	[realm-swift](https://github.com/realm/realm-swift.git)
Kingfisher | 이미지 다운로드 및 캐싱 | 7.10.0 이상 |	[Kingfisher ](https://github.com/onevcat/Kingfisher.git)
