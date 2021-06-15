//
//  SideMenuViewController.swift
//  FinalYearProject
//
//  Created by Ibukunoluwa Soyebo on 11/06/2021.
//

import UIKit
import SwiftUI

struct SideMenuData {
    let cellName:String
    let cellImage:String
}

class SideMenuViewController: UIViewController {
    
    let array_sideMenu_data:[SideMenuData] = [.init(cellName: "Settings", cellImage: "sidemenu card"), .init(cellName: "Power Purchases", cellImage: "sidemenu deliveries")]
    
    @IBOutlet weak var tblSideMenu: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTable()
    }
    

    fileprivate func configureTable(){
        tblSideMenu.delegate = self
        tblSideMenu.dataSource = self
        //tblDeliveries.backgroundColor = .clear
        tblSideMenu.register(FYMenuTableViewCell.getNib(), forCellReuseIdentifier: FYMenuTableViewCell.identifier)
        tblSideMenu.separatorStyle = .singleLine
        tblSideMenu.tableFooterView = UIView()
        tblSideMenu.rowHeight = 75

    }

}

extension SideMenuViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array_sideMenu_data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let fyMTVC = tblSideMenu.dequeueReusableCell(withIdentifier: FYMenuTableViewCell.identifier, for: indexPath) as! FYMenuTableViewCell
        fyMTVC.textLabel?.text = array_sideMenu_data[indexPath.row].cellName
        fyMTVC.selectionStyle = .none
        return fyMTVC
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tblSideMenu.deselectRow(at: indexPath, animated: true)
        switch indexPath.row {
        case 0:
            //let thresholdVC = WarningThresholdViewController(nibName: "WarningThresholdViewController", bundle: nil)
            let m = UIHostingController(rootView: SettingsSwiftUI())
            navigationController?.pushViewController(m, animated: true)
        default:
            print(indexPath.row)
        }
    }
    
}
