# 🍎 iTunesApp

iTunes의 음악, 영화, 팟캐스트 정보를 제공하는 iOS 앱입니다.

## 🛠️ Stack

Xcode, Swift, iOS / SnapKit, RxSwift

## 🔍 Usage

```bash
git clone https://github.com/nbcamp-letswork/itunes-app-seokhwan.git
cd itunes-app-seokhwan/iTunesAppSeokhwan
open iTunesAppSeokhwan.xcodeproj
# 실행: ⌘ + R
```

## 📌 Features

### 홈 화면

- [x] 사계절 키워드(봄, 여름, 가을, 겨울)에 대한 음악 컨텐츠 제공
- [x] 상단 검색바 구현

### 검색 결과 화면

- [x] 검색바를 통한 영화, 팟캐스트 검색 기능
- [x] 검색 키워드 터치 시 홈 화면으로 복귀

### 상세 화면

- [x] 셀 선택 시 상세 화면으로 이동
- [x] 제목, 아티스트, 장르, 출시일, 러닝타임 등 상세 정보 제공  

## 🚀 Result

<image src="Resource/result.gif" width="250px"></image>

## 🏡 Architecture

```bash
.
├── iTunesAppSeokhwan
│   ├── Application
│   │   └── DIContainer.swift
│   ├── Data
│   │   ├── Network
│   │   └── Repository
│   ├── Domain
│   │   ├── Entity
│   │   ├── Repository
│   │   └── UseCase
│   ├── Presentation
│   │   ├── Coordinator
│   │   ├── Main
│   │   ├── Home
│   │   ├── SearchResult
│   │   ├── Detail
│   │   ├── Protocol
│   │   ├── Extension
│   │   └── Utility
│   │       └── ImageLoader.swift
│   └── Resource
└── iTunesAppSeokhwan.xcodeproj
```

- MVVM-C 및 Clean Architecture 적용
- ImageLoader는 예외로 유연하게 적용

## 🔦 Design Principles

### 재사용성(Reusability)

- DetailContentView UI 컴포넌트 재사용
- ErrorAlert를 extension으로 분리하여 각 화면에서 재사용

### 모듈화(Modularity)

- Clean Architecture 원칙에 따라 관심사 별로 레이어 분리(Application, Data, Domain, Presentaion 등)
- Presentation Layer에서는 화면 별로 디렉터리 분류(Home, SearchResult, Detail 등)
- ImageLoader는 별도의 Utility로 모듈화

### 의존성 주입(Dependency Injection)

- Application Layer에 DIContainer 구현
- 각 모듈이 필요한 의존 객체를 외부에서 주입받도록 구현

### 추상화(Abstraction)

- Music, Movie, Podcast를 MediaItem 타입으로 추상화하여 Repository, Network의 중복 로직 최소화

### 사용성 UX(User Experience)

- 에러 발생 시, Alert로 메시지 표시
- 키보드 UX 개선(스크롤 시, SearchBar Resign 등)
- 화면 전환 시, fade in-out 적용하여 부드러운 전환(transition)
- URLCache 적용하여 반응성 개선

## 🔥 Troubleshooting

- [DiffableDataSource의 identifier 중복 문제](https://velog.io/@youseokhwan/DiffableDataSource의-identifier-중복-문제)
- [NavigationBar의 SearchController active/inactive시 부자연스러운 애니메이션](https://velog.io/@youseokhwan/NavigationBar의-SearchController-activeinactive시-부자연스러운-애니메이션)

## 🚨 Memory Leak Check

<image src="Resource/leak1.png"></image>

- ContentRepository에서 정규식을 사용할 때, 많은 양의 NSRegularExpression 인스턴스가 중복해서 생성되어 경고 발생
- 시간이 충분히 지나면 해제되긴 하지만, 많은 양의 인스턴스를 중복해서 만들 필요는 없기 때문에 Repository의 프로퍼티로 분류하고 재사용하여 경고 제거

```swift
// Before
private func toDomainArtworkBasePath(from path: String) -> String {
    let pattern = "\\d+x\\d+bb\\.jpg$"
    guard let regex = try? NSRegularExpression(pattern: pattern) else { return "" }

    return regex.stringByReplacingMatches(
        in: path,
        range: NSRange(path.startIndex..<path.endIndex, in: path),
        withTemplate: "",
    )
}

// After
private let artworkRegex: NSRegularExpression? = {
    try? NSRegularExpression(pattern: "\\d+x\\d+bb\\.jpg$")
}()

private func toDomainArtworkBasePath(from path: String) -> String {
    guard let regex = artworkRegex else { return "" }

    return regex.stringByReplacingMatches(
        in: path,
        range: NSRange(path.startIndex..<path.endIndex, in: path),
        withTemplate: "",
    )
}
```

<image src="Resource/leak2.png"></image>
