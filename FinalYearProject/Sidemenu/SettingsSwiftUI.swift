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
    
    var body: some View {
      
            Form{
                Section(header: Text("Power Purchased in kwH")){
                    TextField("How much power did you purchase", text: $purchasedPower)
                        .keyboardType(.numberPad)
                }
                
                Section(header:Text("Threshold Power in kwH")){
                    TextField("At what threshold  power do you want tot be notified to purchase power?", text: $thresholdPower)
                        .keyboardType(.numberPad)
                    
                }
            }        .navigationTitle("Settings")

        
        .onDisappear(perform: {
            UserDefUtils.userPurchasedPower = Double(purchasedPower) ?? 0
            UserDefUtils.userThresholdPower = Double(thresholdPower) ?? 0
        })
        
        
        
    }
    
    
}

struct Settings_Previews: PreviewProvider {
    static var previews: some View {
        SettingsSwiftUI()
    }
}
