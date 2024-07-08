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

## 유즈케이스
### SearchView
| 검색어가 비었거나 결과가 없을 시 화면 | 검색시 화면 | 사진 스크랩 시 화면 | 네트워크 연결 없을 시 화면 |
|--|--|--|--|
| ![simulator_screenshot_722DA42F-4DA5-4B62-A557-D20A26F4E86A](https://github.com/dodo849/MediaApp/assets/71880682/d77b21a4-9472-49d7-9789-ea0cb2fcb736) | ![simulator_screenshot_E5E8D9A0-2CE9-425D-AF3C-5F54EED410ED](https://github.com/dodo849/MediaApp/assets/71880682/11042ab9-f4f7-4ae4-8b5d-933e72189b27) | ![simulator_screenshot_4552009E-0290-40FB-AD2A-A21B0D4F4F93](https://github.com/dodo849/MediaApp/assets/71880682/5f9930e1-0447-4b20-ac87-feca5773333a) | ![simulator_screenshot_036019A5-BA7B-4449-8A40-649DFF668C72](https://github.com/dodo849/MediaApp/assets/71880682/91116b3b-a89b-40f3-bc80-50c2778119e9) | 


## 라이브러리
라이브러리명 | 용도 | 버전 | Git
|--|--|--|--|
swift-composable-architecture |	상태관리 	| 1.11.0 이상| [swift-composable-architecture](https://github.com/pointfreeco/swift-composable-architecture.git)
swift-dependencies |의존성 주입| 1.0.0 이상| [swift-dependencies](https://github.com/pointfreeco/swift-dependencies)
Alamofire	| 네트워킹 라이브러리	| 5.9.0 이상	| [Alamofire](https://github.com/Alamofire/Alamofire.git)
realm-swift	| 내부 데이터베이스 |	10.50.0 이상 |	[realm-swift](https://github.com/realm/realm-swift.git)
Kingfisher | 이미지 다운로드 및 캐싱 | 7.10.0 이상 |	[Kingfisher ](https://github.com/onevcat/Kingfisher.git)
