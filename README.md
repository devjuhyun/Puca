<img width="875" alt="appscreenshot" src="https://github.com/jujubeyun/RickAndMorty/assets/117050638/9ac34ee7-2323-43c6-8843-92a129cdaef8">

# 사용한 기술
* UIKit
* MVVM
* Singleton
* Realm
* UserDefaults
* SPM

# 주요 기능
* 로컬 데이터 저장
* 카테고리별 키보드 언어 설정
* 카테고리별 단어 관리 및 단어 이동
* 단어 정렬 및 필터링
* 단어 검색
* 외운 단어 체크
* 카테고리/단어 편집
* 플래시 카드
* Floating Button
* Localization(한국어, 영어)

# 구현 내용
## 1. Realm 사용
* 싱글톤 DBManager 클래스를 만들어서 하나의 Realm 객체를 앱 전체에서 사용
```swift
import RealmSwift

final class DBManager {
    static let shared = DBManager()
    private let realm = try! Realm()
    
    private init() {}
    
    /* ... */
}
```
* NotificationToken을 사용하여 Realm 객체가 업데이트 될때마다 뷰 모델의 데이터를 업데이트
```swift
private(set) var token: NotificationToken?

token = relamObject.observe { [weak self] changes in
		self?.fetch()
		/* ... */
        }
```

## 2. 카테고리 편집

| <img width="200" src="https://github.com/jujubeyun/Puca/assets/117050638/605a171b-39e9-4fcb-ad6d-769543805b5a"> | <img width="200" src="https://github.com/jujubeyun/Puca/assets/117050638/92cc340d-f6a8-40d6-ac56-90e9229dadc6"> |
| :-------------------------------------------------------------------------------------------------------------: | :-------------------------------------------------------------------------------------------------------------: |
|                                                     카테고리 이동                                                     |                                                   카테고리 수정/삭제                                                    |

* CategoryListViewController에 UITableViewDragDelegate, UITableViewDropDelegate를 채택하여 카테고리의 순서를 변경하는 기능 구현
	* 모든 단어를 볼 수 있는 카테고리의 경우 순서를 변경하지 못하도록 설정
* UITableView의 trailingSwipeActionsConfigurationForRowAt 메서드를 활용하여 카테고리 수정/삭제 스와이프 버튼 구현

## 3. 카테고리별 키보드 언어 설정
| <img width="200" src="https://github.com/jujubeyun/Puca/assets/117050638/801db1c5-76bd-4baf-8a77-55c5713dde44"> | <img width="200" src="https://github.com/jujubeyun/Puca/assets/117050638/b8cf8fcf-9191-4c5d-a26e-9a2204854f91"> | <img width="200" src="https://github.com/jujubeyun/Puca/assets/117050638/926f4a6d-acf1-4f4d-b7a7-412cbc2ff676"> |
| :-------------------------------------------------------------------------------------------------------------: | :-------------------------------------------------------------------------------------------------------------: | :-------------------------------------------------------------------------------------------------------------: |
|                                                  키보드 언어 자동 변경                                                   |                                                   카테고리 언어 설정                                                    |                                                   키보드 언어 리스트                                                    |

* UITextInputMode의 activeInputModes 속성을 사용하여 현재 디바이스에서 사용하는 키보드 리스트를 불러 오고 사용자가 각 카테고리마다 단어와 뜻을 입력하는 키보드의 언어를 설정

## 4. 단어 정렬 및 필터링
| <img width="200" src="https://github.com/jujubeyun/Puca/assets/117050638/129e875a-3ae4-4e48-b165-713fc6468946"> | <img width="200" src="https://github.com/jujubeyun/Puca/assets/117050638/a2fc9ba0-37cb-45ce-9cfb-a8a3fd64d108"> |
| :-------------------------------------------------------------------------------------------------------------: | :-------------------------------------------------------------------------------------------------------------: |
|                                                      단어 정렬                                                      |                                                     단어 필터링                                                      |

* UIMenu를 사용하여 단어를 최신 순 혹은 오래된 순으로 정렬하거나 외운단어 혹은 외우지 못한 단어만 필터링할 수 있도록 구현

## 5. 플래시 카드
<img width="200" src="https://github.com/jujubeyun/Puca/assets/117050638/378dea7a-9dd2-46a3-8e44-003b6fa2796a">

* UICollectionView의 isPagingEnabled 속성과 UICollectionViewFlowLayout을 이용하여 페이징 구현
* UITapGestureRecognizer와 UIView의 transition 메서드를 사용하여 카드를 뒤집는 애니메이션 구현
* 현재 단어 위치를 Navigation Title에 동적으로 업데이트
* 스크롤을 하거나 단어가 삭제될때마다 화면 중앙에 있는 셀의 IndexPath를 확인하여 뷰를 업데이트

## 6. Binding
* 커스텀 Observable 클래스를 만들어 View와 ViewModel간의 바인딩을 구현
```swift
final class Observable<T> {
    typealias Listener = (T) -> Void
    private var listener: Listener?

    var value: T {
        didSet {
            listener?(value)
        }
    }
    
    init(_ value: T) {
        self.value = value
    }
    
    func bind(listener: Listener?) {
        self.listener = listener
        listener?(value)
    }
}
```

## 7. Toast Message
| <img width = "200" src = "https://github.com/jujubeyun/Puca/assets/117050638/1ea34d02-2ef5-4762-9a14-08838c130cc3"> | <img width = "200" src = "https://github.com/jujubeyun/Puca/assets/117050638/354f6426-f4fa-46dc-b9d6-f37b1c4f50e2"> | <img width = "200" src = "https://github.com/jujubeyun/Puca/assets/117050638/7868d095-3cda-4f82-b91a-464cf940ebb3"> | <img width = "200" src = "https://github.com/jujubeyun/Puca/assets/117050638/e878142c-44f1-48b3-9f98-2d5c71f19d36"> |
| :-----------------------------------------------------------------------------------------------------------------: | :-----------------------------------------------------------------------------------------------------------------: | :-----------------------------------------------------------------------------------------------------------------: | :-----------------------------------------------------------------------------------------------------------------: |
|                                                      카테고리 미선택                                                       |                                                       단어 미입력                                                        |                                                       의미 미입력                                                        |                                                        저장 성공                                                        |


* 새로운 단어를 추가하거나 수정할 때 단어나 의미의 텍스트 필드가 빈 칸이라면 유저에게 알리거나 단어가 성공적으로 저장되었다는 걸 유저가 알 수 있게 화면 상단에 메세지를 화면에 잠깐 표시하고 사라지는 Toast Message 구현
* 최상위의 빈 칸인 텍스트 필드를 first responder로 설정

## 8. Floating Button
<img width = "100" src = "https://github.com/jujubeyun/Puca/assets/117050638/073e450d-7e2f-4099-b4d0-fbda1f534d5c">

* 단어 리스트 화면 하단 우측에 새로운 단어를 추가하는 버튼
* UIButton의 isHighlighted 속성을 이용하여 버튼을 클릭했을때 크기가 줄어들면서 투명해지는 애니메이션 구현
```swift
override var isHighlighted: Bool {
    get {
        return super.isHighlighted
    }
    set {
        if newValue {
            UIView.animate(withDuration: 0.1, delay: 0, options:.curveEaseIn , animations: {
                self.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
                self.alpha = 0.5
            }, completion: nil)
        }
        else {
            UIView.animate(withDuration: 0.1, delay: 0, options:.curveEaseIn , animations: {
                self.transform = CGAffineTransform.identity
                self.alpha = 1
            }, completion: nil)
        }
        super.isHighlighted = newValue
    }
}
```

## 9. Empty View
<img width = "200" src = "https://github.com/jujubeyun/Puca/assets/117050638/112ded62-9a8d-4401-9099-03f64c82f8c6">

* 단어 리스트에 현재 표시할 수 있는 단어가 없을 경우 사용자에게 알리기 위해 메세지가 포함된 UIView 구현

## 10. UserDefaults
* 최근 카테고리와 정렬 및 보기 옵션을 저장하기 위해 UserDefaults를 사용
```swift
func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
	/* ... */
	UserDefaults.standard.set(indexPath.row, forKey: "recentCategoryIndex")
	/* ... */
}

func updateSortOption(_ sortOption: SortOption) {
    UserDefaults.standard.set(sortOption.rawValue, forKey: "sortOption")
    /* ... */
}

func updateDisplayOption(_ displayOption: DisplayOption) {
    UserDefaults.standard.set(displayOption.rawValue, forKey: "displayOption")
	/* ... */
}
```

# 문제점 해결
## 1. 플래시 카드 애니메이션 중첩 이슈
* 카드가 뒤집히는 도중에 다시 클릭 시 애니메이션이 중간에 멈추고 다시 시작
* 애니메이션이 시작될 때 셀의 isUserInteractionEnabled 속성을 false로 하고 애니메이션이 완료되면 다시 true로 설정하여 해결
```swift
@objc func flip() {
        UIView.transition(with: card, duration: 0.5, options: .transitionFlipFromBottom) {
        // can't flip again while fliping
        self.isUserInteractionEnabled = false
    } completion: { _ in
        self.isUserInteractionEnabled = true
    }
    /* ... */
}
```

## 2. Search Controller 이슈
* 평소에는 Seachbar가 안보이게 하다가 검색 버튼을 눌렀을때만 나타나도록 구현 시도
* Navigation Item에 Search Controller를 할당하고 Search TextField의 becomeFirstResponder 메서드를 실행했으나 아무일도 일어나지 않음
* Navigation Item에 Search Controller가 완전히 레이아웃이 되기 전이기 때문에 생기는 문제라고 생각하여 메인 스레드에 아주 약간의 시간차를 두어 메서드를 실행시켜 해결
```swift
@objc func searchButtonClicked() {
    navigationItem.searchController = searchController
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.001) { [weak self] in
        self?.searchController.searchBar.searchTextField.becomeFirstResponder()
    }
}
```

## 3. 단어의 예문이 가려지는 이슈
* 단어를 추가하거나 수정하는 화면에서 예문을 입력하는 TextView의 길이가 길어지면 키보드에 텍스트가 가려져 보이지 않음
* 스크롤이 가능하도록 UIScrollView를 추가
* Notification Center를 사용해 키보드의 활성/비활성 상태를 관찰
```swift
private func addKeyboardObservers() {
    NotificationCenter.default.addObserver(
        self,
        selector: #selector(keyboardWillShow),
        name: UIResponder.keyboardWillShowNotification,
        object: nil)
    NotificationCenter.default.addObserver(
        self,
        selector: #selector(keyboardWillHide),
        name: UIResponder.keyboardWillHideNotification,
        object: nil)
}
```
* 키보드가 활성화 되었을 때는 Notification의 userInfo 속성을 통해 키보드의 프레임 정보를 받아와서 스크롤 뷰와 우측 스크롤 뷰 인디케이터에 키보드의 높이만큼 inset을 주어 텍스트가 키보드에 가려질 경우 스크롤이 가능하게 구현
```swift
@objc func keyboardWillShow(_ notification: Notification) {
    guard let userInfo = notification.userInfo,
          let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }

    scrollView.contentInset.bottom = keyboardFrame.size.height
    scrollView.verticalScrollIndicatorInsets.bottom = keyboardFrame.size.height
}
```
* 키보드가 비활성화 되었을 때는 inset을 초기화하여 다시 원상복구
```swift
@objc func keyboardWillHide() {
    scrollView.contentInset = .zero
    scrollView.verticalScrollIndicatorInsets = .zero
}
```

## 4. Index Out Of Range 이슈
* VocabCollectionViewController(플래시 카드화면)에서 단어를 수정하고 VocabListViewController에 다시 돌아왔을때 UITableView의 cellForRowAt 메서드에서 ViewModel의 단어 배열에 접근하는 과정에서 가끔 index out of range 에러가 발생
* 배열에 변경사항을 업데이트 하는 과정에서 접근했기 때문에 생긴 에러라고 생각하여 Collection에 안전하게 배열의 index에 접근할수 있는 subscript를 추가하여 해결
```swift
extension Collection {
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
```

# App Support
* [한국어](https://trapezoidal-olivine-8ab.notion.site/3b799634cfb94a51bca906a11730cc80)
* [영어](https://trapezoidal-olivine-8ab.notion.site/Puca-cfffc29c413043f693f4602e5f3cbcf4)

# 업데이트 예정
* 사용자가 앱을 삭제하거나 기기를 변경해도 저장해놓은 데이터가 유지될 수 있게 MongoDB Atlas를 사용하여 로그인 시스템 구현 예정
