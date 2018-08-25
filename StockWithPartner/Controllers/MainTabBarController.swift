//
//  MainTabBarController.swift
//  StockWithPartner
//
//  Created by TaikiFnit on 2017/11/11.
//  Copyright © 2017 FlyingAroundBottle. All rights reserved.
//

import UIKit
import Firebase
import FontAwesome_swift
import CoreLocation

class MainTabBarController: UITabBarController {
	
	var locationManager: CLLocationManager!
	
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewControllers?[0].tabBarItem.image = UIImage.fontAwesomeIcon(name: .home, textColor: UIColor.white, size: CGSize(width: 30, height: 30))
        self.viewControllers?[1].tabBarItem.image = UIImage.fontAwesomeIcon(name: .shareAlt, textColor: UIColor.white, size: CGSize(width: 30, height: 30))
        self.viewControllers?[2].tabBarItem.image = UIImage.fontAwesomeIcon(name: .gear, textColor: UIColor.white, size: CGSize(width: 30, height: 30))
        
        guard let _ = Auth.auth().currentUser else { return }
        
        Login.hasPartner { (result) in
            if result == false {
                self.performSegue(withIdentifier: "toPair", sender: nil)
            }
        }
		
		// gps
		locationManager = CLLocationManager() // インスタンスの生成
		locationManager.delegate = self // CLLocationManagerDelegateプロトコルを実装するクラスを指定する
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension MainTabBarController: CLLocationManagerDelegate {
	func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
		switch status {
		case .notDetermined:
			print("ユーザーはこのアプリケーションに関してまだ選択を行っていません")
			// 許可を求めるコード
			locationManager.requestAlwaysAuthorization()
			break
		case .denied:
			print("ローケーションサービスの設定が「無効」になっています (ユーザーによって、明示的に拒否されています）")
			// 「設定 > プライバシー > 位置情報サービス で、位置情報サービスの利用を許可して下さい」を表示する
			break
		case .restricted:
			print("このアプリケーションは位置情報サービスを使用できません(ユーザによって拒否されたわけではありません)")
			// 「このアプリは、位置情報を取得できないために、正常に動作できません」を表示する
			break
		case .authorizedAlways:
			print("常時、位置情報の取得が許可されています。")
			// 位置情報取得の開始処理
			locationManager.startUpdatingLocation()
			break
		case .authorizedWhenInUse:
			print("起動時のみ、位置情報の取得が許可されています。")
			// 位置情報取得の開始処理
			break
		}
	}
	
	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		
		for location in locations {
			print("緯度:\(location.coordinate.latitude) 経度:\(location.coordinate.longitude) 取得時刻:\(location.timestamp.description)")
		}
	}
}
