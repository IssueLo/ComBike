# ComBike

ComBike 是一個為單車初學者而設計的一款 App，結合了 `Combine` 與 `Bike` 這兩個字，希望讓單車騎士可以透過單車之間的連結，增加對於騎單車這項運動的熱忱。

* 全台各地區單車路線推薦，推薦內容包含路線、總距離、平均坡度
* 可創建騎乘群組，騎乘過程中可在地圖上追蹤其他成員的位置
* 騎乘過程即時顯示騎乘資訊，如時速、花費時間、距離及騎乘路線
* 活動結束後會依照完成時間進行群組內的排名，並紀錄個人騎乘路徑與坡度表

<a href="https://apps.apple.com/tw/app/id1481185096"><img src="https://i.imgur.com/Pc1KdHw.png" width="100"></a>

## Feature

* 路線推薦

    * 從 Strava API 取得路線資訊，使用 UICollectionViewLayout 實現瀑布流的排版顯示在 CollectionView 上
      
      <img src="https://github.com/IssueLo/ComBike/blob/develop/ScreenShot/1-1.png" width="200">
      <img src="https://github.com/IssueLo/ComBike/blob/develop/ScreenShot/1-2.png" width="200">

* 路線詳情
    * 使用第三方套件 Polyline 將路線顯示在地圖上
        
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
        }
        ```
* 自行創建群組 or 掃 QR code 加入群組

    * 使用者登入後，除了可以自行創建新群組，還可使用既有群組產生的 QR code，進行掃描後加入該群組
        >
        <img src="https://github.com/IssueLo/ComBike/blob/develop/ScreenShot/3-1.png" width="200">
        <img src="https://github.com/IssueLo/ComBike/blob/develop/ScreenShot/3-2.gif" width="200">

* 即時更新騎乘資訊
    * 在騎乘過程中可隨時更新當前騎乘速度、總時間以及騎乘距離
    * 顯示騎乘路徑
    * 同步更新同伴位置
        
        <img src="https://github.com/IssueLo/ComBike/blob/develop/ScreenShot/4.gif" width="200">

* 成績排行
    * 依照完成時間排序名次
        
        <img src="https://github.com/IssueLo/ComBike/blob/develop/ScreenShot/5-1.PNG" width="200">
        <img src="https://github.com/IssueLo/ComBike/blob/develop/ScreenShot/5-2.JPG" width="200">
        
* 路線、坡度紀錄
    * 紀錄騎乘路徑在 Map 上，以及使用 Charts 顯示坡度紀錄
        
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