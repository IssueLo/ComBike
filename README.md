# ComBike

ComBike 是一個為單車初學者而設計的一款 App，結合了 `Combine` 與 `Bike` 這兩個字，希望讓單車騎士可以透過單車之間的連結，增加對於騎單車這項運動的熱忱。

* 全台各地區單車路線推薦，推薦內容包含路線、總距離、平均坡度
* 可創建騎乘群組，騎乘過程中可在地圖上追蹤其他成員的位置
* 騎乘過程即時顯示騎乘資訊，如時速、花費時間、距離及騎乘路線
* 活動結束後會依照完成時間進行群組內的排名，並紀錄個人騎乘路徑與坡度表

<a href="https://apps.apple.com/tw/app/id1481185096"><img src="https://i.imgur.com/Pc1KdHw.png" width="100"></a>

## Feature

#### 路線推薦

* 發 `URLRequest` 從 `Strava API` 取得 token 後，再使用 token 與路徑 id 取得路線資訊

    ``` swift
    class StravaAuthManager {
    
        static func getToken(completion: @escaping (Result<Token>) -> Void) {
            
            let urlRequest = StravaRequest.getToken.makeRequest()
            
            HTTPClient.shared.tokenRequest(urlRequest) { (result) in
                
                switch result {
                    
                case .success(let data):
                    
                    do {
                        
                        let decoder = JSONDecoder()
                        
                        let accessToken = try decoder.decode(Token.self, from: data)
                                            
                        completion(Result.success(accessToken))
                    
                    } catch {
                        
                        completion(Result.failure(error))
                    }
                    
                case .failure(let error):
                    
                    completion(Result.failure(error))
                }
            }
        }
    }
    ```

* 使用 `UICollectionViewLayout` 實現瀑布流的排版，並顯示將資訊在 `CollectionView` 上
      
    <img src="https://github.com/IssueLo/ComBike/blob/develop/ScreenShot/1-1.png" width="200">
    <img src="https://github.com/IssueLo/ComBike/blob/develop/ScreenShot/1-2.png" width="200">
    
    

#### 路線詳情

* 使用第三方套件 `Polyline` 將從 `Strava API` 取得的 `polyline String` encode 為 Polyline
* 利用 `MKMapView.setRegion` 以路線中心點為地圖中心，將路線顯示在地圖上
        
    <img src="https://github.com/IssueLo/ComBike/blob/develop/ScreenShot/2.png" width="200">
        
    ``` swift            
    func showPolyline(polylineCode: String) {
        
        let polyline = Polyline(encodedPolyline: polylineCode)

        guard let coordinates: [CLLocationCoordinate2D] = polyline.coordinates else { 

            return 
        }

        let geodesic = MKGeodesicPolyline(coordinates: coordinates, 
                                            count: coordinates.count)

        self.mapView?.addOverlay(geodesic)

        UIView.animate(withDuration: 1.5, animations: { () -> Void in
            
            guard let mkPolyline = polyline.mkPolyline else { return }
            
            var regionRect = mkPolyline.boundingMapRect
            let wPadding = regionRect.size.width * 0.3
            let hPadding = regionRect.size.height * 0.3
            
            regionRect.size.width += wPadding
            regionRect.size.height += hPadding
            
            regionRect.origin.x -= wPadding / 2
            regionRect.origin.y -= hPadding / 2
            
            self.mapView?.setRegion(MKCoordinateRegion(regionRect), animated: true)
        })
    }
    ```
#### 自行創建群組 or 掃 QR code 加入群組

* 使用者登入後，除了可以自行創建新群組，還可使用既有群組產生的 QR code，進行掃描後加入該群組
        
    <img src="https://github.com/IssueLo/ComBike/blob/develop/ScreenShot/3-1.png" width="200">
    <img src="https://github.com/IssueLo/ComBike/blob/develop/ScreenShot/3-2.gif" width="200">

#### 即時更新騎乘資訊

* 在騎乘過程中可使用 `Core Location` 的 `CLLocationManager` 取得手機的定位，隨時更新當前騎乘速度，並計算騎乘距離
* 使用 `Timer` 完成計時器功能
* 存取 `Core Location` 中的 `CLLocationCoordinate2D`，使用 `Polyline` 將騎乘路徑顯示在 `MKMapView`
* 利用 `Firebase` 的 `addSnapshotListener` 監聽群組成員位置，並將同伴當前位置製作成 `MKPointAnnotation` 顯示在地圖上
        
    <img src="https://github.com/IssueLo/ComBike/blob/develop/ScreenShot/4.gif" width="200">

    ``` swift
    FirebaseDataManager
            .shared
            .observerOfMemberLocation(groupData.groupID) { [weak self] locationOfMember in
            
                guard let countOfMember = self?.locationOfMember.count else { return }
                
                if countOfMember == 0 {
                
                    self?.locationOfMember.append(locationOfMember)
                
                } else {
                
                    for number in 0..<countOfMember {
                    
                        if locationOfMember.name == self?.locationOfMember[number].name {
                        
                            self?.locationOfMember.remove(at: number)
                        
                            break
                        }
                    
                        continue
                    }
                
                    self?.locationOfMember.append(locationOfMember)
                }
    }
    ```

#### 成績排行

* 利用 `addSnapshotListener` 監聽群組裡完成路線的成員，依照完成時間排序名次
        
    <img src="https://github.com/IssueLo/ComBike/blob/develop/ScreenShot/5-1.PNG" width="200">
    <img src="https://github.com/IssueLo/ComBike/blob/develop/ScreenShot/5-2.JPG" width="170">
        
#### 路線、坡度紀錄

* 從 `Firebase` fetch 個人騎乘資料
* 將資料中 `CLLocationCoordinate2D` 的 array 使用 `Polyline` 轉換成騎乘路徑顯示在 Map
* 將騎乘資料中儲存 `CoreLocation` 的 `CLLocationDistance`，使用 `Charts` 顯示坡度紀錄
        
    <img src="https://github.com/IssueLo/ComBike/blob/develop/ScreenShot/6-1.PNG" width="200">

## Version History

* 1.2 - 2019/10/06

    - 優化騎乘紀錄介面
    - 增加群組日期分類

* 1.1 - 2019/09/30

    - 新增首次登入導覽介面
    - 新增路線
    - 修改部分切換頁面效果
* 1.0 - 2019/09/26

    - 第一次上架

## Requirement

* iOS 13.0+
* Xcode 11

## Contacts

Yi-Hsiu Lo  
wind19891002@gmail.om

## Others

### 資料來源

* Strava - http://developers.strava.com/
* 單車百岳 - https://bike100.tw