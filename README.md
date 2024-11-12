# OPeace
About DDD 앱 2팀 Opeace 앱


## Tuist Usage
1. Install tuist
 
```swift
curl -Ls https://install.tuist.io | bash 
```
2. Generate project

```swift
tuist clean // optional
make install // optional
make generate
```

## 기술 스택 
- iOS  
  <img src="https://img.shields.io/badge/fastlane-00F200?style=for-the-badge&logo=fastlane&logoColor=white">
  <img src="https://img.shields.io/badge/swift-F05138?style=for-the-badge&logo=swift&logoColor=white">
  <img src="https://img.shields.io/badge/xcode-147EFB?style=for-the-badge&logo=xcode&logoColor=white"> 
  
  - Server  
  <img src="https://img.shields.io/badge/amazonec2-FF9900?style=for-the-badge&logo=amazonec2&logoColor=white">
  <img src="https://img.shields.io/badge/amazonaws-232F3E?style=for-the-badge&logo=amazonaws&logoColor=white">
  <img src="https://img.shields.io/badge/swagger-85EA2D?style=for-the-badge&logo=swagger&logoColor=white">
   
  
  - Design  
  <img src="https://img.shields.io/badge/figma-F24E1E?style=for-the-badge&logo=figma&logoColor=white">
  
  - VCS  
  <img src="https://img.shields.io/badge/git-F05032?style=for-the-badge&logo=git&logoColor=white"> 
  <img src="https://img.shields.io/badge/github-181717?style=for-the-badge&logo=github&logoColor=white"> </br>
  
## App Store
<a href="https://apps.apple.com/kr/app/opeace/id6587550388" style="display: inline-block; overflow: hidden; border-radius: 13px; width: 250px; height: 83px;">
  <img src="https://github.com/user-attachments/assets/3c823098-3c44-4892-b454-43b33366e412" alt="Download on the App Store" style="border-radius: 13px; width: 250px; height: 83px;">
</a>
  
## 🐈‍⬛ Git

### 1️⃣ Git branching Strategy

- Origin(main branch)
- Origin(dev branch)
- Local(feature branch)

- Branch
- Main
- Dev
- Feature
- Fix

- 방법
- 1. Pull the **Dev** branch of the Origin
- 2. Make a **Feature** branch in the Local area
- 3. Developed by **Feature** branch
- 4. Push the **Feature** from Local to Origin
- 5. Send a pull request from the origin's **Feature** to the Origin's **Dev**
- 6. In Origin **Dev**, resolve conflict and merge
- 7. Fetch and rebase Origin **Dev** from Local **Dev**
