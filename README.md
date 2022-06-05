## 👨🏻‍🔧 Flutter player

### 🤷🏻 When
Flutter를 곁들인 멀티 플렛폼 Video 플레이어

### 🚀 How
이미지를 클릭해 선택한 비디오를 감상할 수 있습니다.

### 💡Tips
선택한 비디오 자동 재생이 됩니다.

앞으로가기와 뒤로가기는 3초로 설정되어 있습니다.

### iOS 15.2
![video_player_iOS15 2](https://user-images.githubusercontent.com/85836879/172043619-d10183c6-53fd-499c-b83f-52146e749c78.gif)

### Android API 31
![video_player_API_31](https://user-images.githubusercontent.com/85836879/172043748-c44063ab-a41e-4ecd-9501-98bb8f754d0c.gif)

### 📖 Review
비디오를 재생 중일 때 다른 비디오를 선택하는 경우 didUpdateWidget 생명주기를 사용하였다.

현재 코드는 비디오만 선택하게 되어있지만 Image로 변경하면 이미지로 선택할 수 있다.