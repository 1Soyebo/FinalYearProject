//
//  Settings.swift
//  FinalYearProject
//
//  Created by Ibukunoluwa Soyebo on 15/06/2021.
//

import SwiftUI

struct SettingsSwiftUI: View {
    
    @State var purchasedPower = "\(UserDefUtils.userPurchasedPower)"
    @State private var thresholdPower = "\(UserDefUtils.userThresholdPower)"

    @State private var isAutomaticRefresh = UserDefUtils.isAutomaticRefresh
    
    @State private var dailyTimeNotification = UserDefUtils.dailyNotificationTime
    @State private var userChartTintColor = Color(UserDefUtils.userChartTintColor)
    
    var body: some View {
      
            Form{
                Section(header: Text("Power Purchased in kwH")){
                    TextField("How much power did you purchase", text: $purchasedPower)
                        .keyboardType(.decimalPad)
                }
                
                Section(header:Text("Threshold Power in kwH")){
                    TextField("At what threshold  power do you want tot be notified to purchase power?", text: $thresholdPower)
                        .keyboardType(.decimalPad)
                    
                }
                
                Section(header: Text("Do you want turn on automatic refresh?")){
                    Toggle("Automatic Refresh", isOn: $isAutomaticRefresh)
                }
                
                Section(header: Text("Daily Notifications")){
                    DatePicker("Select Preferred Time", selection: $dailyTimeNotification, displayedComponents: .hourAndMinute)
                }
                
                Section(header: Text("Chart Tint Color")){
                    ColorPicker("Select Chart Tint Color", selection: $userChartTintColor, supportsOpacity: false)
                }
                
                
            }        .navigationTitle("Settings")

        
        .onDisappear(perform: {
            UserDefUtils.userPurchasedPower = Double(purchasedPower) ?? 0
            UserDefUtils.userThresholdPower = Double(thresholdPower) ?? 0
            UserDefUtils.isAutomaticRefresh = isAutomaticRefresh
            UserDefUtils.dailyNotificationTime = dailyTimeNotification
            UserDefUtils.userChartTintColor = UIColor(userChartTintColor)
        })
        
        
        
    }
    
    
}

struct Settings_Previews: PreviewProvider {
    static var previews: some View {
        SettingsSwiftUI()
    }
}
