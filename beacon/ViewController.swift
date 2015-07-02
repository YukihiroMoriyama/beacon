//
//  ViewController.swift
//  CoreLocation004
//

import UIKit
import CoreLocation

class ViewController: UIViewController,UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate{
    
    
    var myLocationManager:CLLocationManager!

    var myBeaconRegion1:CLBeaconRegion!
    var myBeaconRegion2:CLBeaconRegion!
    var myBeaconRegion3:CLBeaconRegion!
    
    var myTableView: UITableView!
    var myIds: NSMutableArray!
    var myUuids: NSMutableArray!
    
    required init(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // ロケーションマネージャの作成.
        myLocationManager = CLLocationManager()
        
        // デリゲートを自身に設定.
        myLocationManager.delegate = self
        
        // セキュリティ認証のステータスを取得
        let status = CLLocationManager.authorizationStatus()
        
        // まだ認証が得られていない場合は、認証ダイアログを表示
        if(status == CLAuthorizationStatus.NotDetermined) {
            
            // まだ承認が得られていない場合は、認証ダイアログを表示
            self.myLocationManager.requestAlwaysAuthorization();
        }
        
        // BeaconのUUIDを設定.
//        let uuid1:NSUUID? = NSUUID(UUIDString: "EDE806E7-2646-47E5-86A5-2FE2378B62A6")
//        let uuid2:NSUUID? = NSUUID(UUIDString: "FA2BB26E-64A9-482B-822D-41932992F5CC")
        let uuid3:NSUUID? = NSUUID(UUIDString: "00000000-7DE6-1001-B000-001C4DF13E76")
//        let uuid:NSUUID? = NSUUID(UUIDString: "EDE806E7264647E586A52FE2378B62A6")

        
        // BeaconのIfentifierを設定.
        let identifierStr1:NSString = "たまご"
        let identifierStr2:NSString = "とうふ１号"
        let identifierStr3:NSString = "とうふ２号"
        
        // リージョンを作成.
//        myBeaconRegion1 = CLBeaconRegion(proximityUUID:uuid1, identifier:identifierStr1)
//        myBeaconRegion2 = CLBeaconRegion(proximityUUID:uuid2, identifier:identifierStr2)
        myBeaconRegion3 = CLBeaconRegion(proximityUUID:uuid3, identifier:identifierStr3)
        
        // ディスプレイがOffでもイベントが通知されるように設定(trueにするとディスプレイがOnの時だけ反応).
//        myBeaconRegion1.notifyEntryStateOnDisplay = false
//        myBeaconRegion2.notifyEntryStateOnDisplay = false
        myBeaconRegion3.notifyEntryStateOnDisplay = false
        
        // 入域通知の設定.
//        myBeaconRegion1.notifyOnEntry = true
//        myBeaconRegion2.notifyOnEntry = true
        myBeaconRegion3.notifyOnEntry = true
        
        // 退域通知の設定.
//        myBeaconRegion1.notifyOnExit = true
//        myBeaconRegion2.notifyOnExit = true
        myBeaconRegion3.notifyOnExit = true

        
        // 配列をリセット
        myIds = NSMutableArray()
        myUuids = NSMutableArray()
        
        // Status Barの高さを取得.
        let barHeight: CGFloat = UIApplication.sharedApplication().statusBarFrame.size.height
        let displayWidth: CGFloat = self.view.frame.width
        let displayHeight: CGFloat = self.view.frame.height
        myTableView = UITableView(frame: CGRect(x: 0, y: barHeight, width: displayWidth, height: displayHeight - barHeight))
        myTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "MyCell")
        myTableView.dataSource = self
        myTableView.delegate = self
        self.view.addSubview(myTableView)
        
    }
    
    /*
    (Delegate) 認証のステータスがかわったら呼び出される.
    */
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        
        println("didChangeAuthorizationStatus");
        
        // 認証のステータスをログで表示
        var statusStr = "";
        switch (status) {
        case .NotDetermined:
            statusStr = "NotDetermined"
        case .Restricted:
            statusStr = "Restricted"
        case .Denied:
            statusStr = "Denied"
        case .AuthorizedAlways:
            statusStr = "Authorized"
        case .AuthorizedWhenInUse:
            statusStr = "AuthorizedWhenInUse"
        }
        println(" CLAuthorizationStatus: \(statusStr)")
        
//        manager.startMonitoringForRegion(myBeaconRegion1);
//        manager.startMonitoringForRegion(myBeaconRegion2);
        manager.startMonitoringForRegion(myBeaconRegion3);
    }
    
    /*
    STEP2(Delegate): LocationManagerがモニタリングを開始したというイベントを受け取る.
    */
    func locationManager(manager: CLLocationManager!, didStartMonitoringForRegion region: CLRegion) {
        
        println("didStartMonitoringForRegion");
        
        // STEP3: この時点でビーコンがすでにRegion内に入っている可能性があるので、その問い合わせを行う
        // (Delegate didDetermineStateが呼ばれる: STEP4)
//        manager.requestStateForRegion(myBeaconRegion1);
//        manager.requestStateForRegion(myBeaconRegion2);
        manager.requestStateForRegion(myBeaconRegion3);
    }
    
    /*
    STEP4(Delegate): 現在リージョン内にいるかどうかの通知を受け取る.
    */
    func locationManager(manager: CLLocationManager!, didDetermineState state: CLRegionState, forRegion inRegion: CLRegion!) {
        
        println("locationManager: didDetermineState \(state)")
        
        switch (state) {
            
        case .Inside: // リージョン内にいる
            println("CLRegionStateInside:");
            
            // STEP5: すでに入っている場合は、そのままRangingをスタートさせる
            // (Delegate didRangeBeacons: STEP6)
//            manager.startRangingBeaconsInRegion(myBeaconRegion1);
//            manager.startRangingBeaconsInRegion(myBeaconRegion2);
            manager.startRangingBeaconsInRegion(myBeaconRegion3);
            break;
            
        case .Outside:
            println("CLRegionStateOutside:");
            // 外にいる、またはUknownの場合はdidEnterRegionが適切な範囲内に入った時に呼ばれるため処理なし。
            break;
            
        case .Unknown:
            println("CLRegionStateUnknown:");
            // 外にいる、またはUknownの場合はdidEnterRegionが適切な範囲内に入った時に呼ばれるため処理なし。
        default:
            
            break;
            
        }
    }
    
    /*
    STEP6(Delegate): ビーコンがリージョン内に入り、その中のビーコンをNSArrayで渡される.
    */
    func locationManager(manager: CLLocationManager!, didRangeBeacons beacons: NSArray!, inRegion region: CLBeaconRegion!) {
        
        // 配列をリセット
        myIds = NSMutableArray()
        myUuids = NSMutableArray()
        
        println(beacons.count)
        
        // 範囲内で検知されたビーコンはこのbeaconsにCLBeaconオブジェクトとして格納される
        // rangingが開始されると１秒毎に呼ばれるため、beaconがある場合のみ処理をするようにすること.
        if(beacons.count > 0){
            
            // STEP7: 発見したBeaconの数だけLoopをまわす
            for var i = 0; i < beacons.count; i++ {
                
                var beacon = beacons[i] as CLBeacon
                
                let beaconUUID = beacon.proximityUUID;
                let minorID = beacon.minor;
                let majorID = beacon.major;
                let rssi = beacon.rssi;
                
                println("UUID: \(beaconUUID.UUIDString)");
                println("minorID: \(minorID)");
                println("majorID: \(majorID)");
                println("RSSI: \(rssi)");
                
                var proximity = ""
                
                switch (beacon.proximity) {
                case CLProximity.Unknown:
                    println("Proximity: Unknown");
                    proximity = "Unknown"
                    break;
                
                case CLProximity.Immediate:
                    println("Proximity: Immediate");
                    proximity = "Immediate"
                    break;
                
                case CLProximity.Far:
                    println("Proximity: Far");
                    proximity = "Far"
                    break;
                
                case CLProximity.Near:
                    println("Proximity: Near");
                    proximity = "Near"
                    break;
                }
                
                
                let myBeaconId = "MajorId: \(majorID) MinorId: \(minorID)  RSSI:\(rssi) Proximity:\(proximity)"
                myIds.addObject(myBeaconId)
                myUuids.addObject(beaconUUID.UUIDString)
                myTableView.reloadData()
                
            }
        }
    }
    
    /*
    (Delegate) リージョン内に入ったというイベントを受け取る.
    */
    func locationManager(manager: CLLocationManager!, didEnterRegion region: CLRegion!) {
        println("didEnterRegion");
        
        // Rangingを始める
//        manager.startRangingBeaconsInRegion(myBeaconRegion1);
//        manager.startRangingBeaconsInRegion(myBeaconRegion2);
        manager.startRangingBeaconsInRegion(myBeaconRegion3);
    }
    
    /*
    (Delegate) リージョンから出たというイベントを受け取る.
    */
    func locationManager(manager: CLLocationManager!, didExitRegion region: CLRegion!) {
        NSLog("didExitRegion");
        
        // Rangingを停止する
//        manager.stopRangingBeaconsInRegion(myBeaconRegion1);
//        manager.stopRangingBeaconsInRegion(myBeaconRegion2);
        manager.stopRangingBeaconsInRegion(myBeaconRegion3);
    }
    
    /*
    Cellが選択された際に呼び出される
    */
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        println("Num: \(indexPath.row)")
        println("myIds: \(myIds[indexPath.row])")
        println("myUuids: \(myUuids[indexPath.row])")
        
    }
    /*
    Cellの総数を返す
    */
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myIds.count
    }
    
    /*
    Cellに値を設定する
    */
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:UITableViewCell? = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier:"MyCell" )
        
        // Cellに値を設定
        cell?.textLabel?.sizeToFit()
        cell?.textLabel?.textColor = UIColor.blueColor()
        cell?.textLabel?.text = "\(myIds[indexPath.row])"
        cell?.textLabel?.font = UIFont.systemFontOfSize(15)
        
        // Cellに値を設定(下)
        cell?.detailTextLabel?.text = "\(myUuids[indexPath.row])"
        cell?.detailTextLabel?.font = UIFont.systemFontOfSize(12)
        
        return cell!
    }
}
