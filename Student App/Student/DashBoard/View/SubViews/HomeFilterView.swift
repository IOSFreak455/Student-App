//
//  HomeFilterView.swift
//  Student App
//
//  Created by Arjun   on 13/07/24.
//

import SwiftUI

struct HomeFilterView: View {
    @EnvironmentObject var vm : StudentViewModel
    var body: some View {
        GeometryReader { geometry in
            ZStack{
                Color.white252.ignoresSafeArea()
                VStack(alignment: .center, spacing: 20){
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(alignment: .leading, spacing: 20){
                            HStack(spacing: 20){
                                BackButtonView(fontSize: 22)
                                Text("Filter")
                                    .customLabelStyle(textColor: .black50, fontSize: 22, fontName: .generalSansMedium)
                                
                                Spacer()
                                
                                Text("Clear All")
                                    .customLabelStyle(textColor: .gray64, fontSize: 18, fontName: .generalSansMedium)
                                    .onTapGesture {
                                        self.vm.selectedCountry.removeAll()
                                        self.vm.selectedState.removeAll()
                                        self.vm.selectedCourse.removeAll()
                                        self.vm.selectedAppointments.removeAll()
                                    }
                                    .padding(.trailing, 8)
                            }
                            
                            VStack(alignment: .leading, spacing: 20) {
                                Text("Country")
                                    .customLabelStyle(textColor: .black50, fontSize: 20, fontName: .generalSansMedium)
                                
                                FlowLayout(arrayofString: self.vm.countries, selectedArray: $vm.selectedCountry, geometry: geometry)
                            } .padding(.top)
                            
                            Divider()
                            
                            
                            VStack(alignment: .leading, spacing: 20) {
                                Text("State")
                                    .customLabelStyle(textColor: .black50, fontSize: 20, fontName: .generalSansMedium)
                                
                                FlowLayout(arrayofString: self.vm.states, selectedArray: $vm.selectedState, geometry: geometry)
                            }
                            
                            Divider()
                            
                            VStack(alignment: .leading, spacing: 20) {
                                Text("Course Type")
                                    .customLabelStyle(textColor: .black50, fontSize: 20, fontName: .generalSansMedium)
                                
                                FlowLayout(arrayofString: self.vm.courseType, selectedArray: $vm.selectedCourse, geometry: geometry)
                            }
                            
                            Divider()
                            
                            VStack(alignment: .leading, spacing: 20) {
                                Text("College Appointments")
                                    .customLabelStyle(textColor: .black50, fontSize: 20, fontName: .generalSansMedium)
                                
                                FlowLayout(arrayofString: self.vm.appointments, selectedArray: $vm.selectedAppointments, geometry: geometry)
                            }
                        }.padding(.horizontal)
                    }
                    Spacer(minLength: 0)
                    
                    NavigationLink(destination: EnterDetailsView().navigationBarBackButtonHidden(), label: {
                        Text("Confirm")
                            .customButtonStyle(textColor: .anyWhite, fontSize: 18, fontName: .generalSansSemiBold, bgColor: .blue31, width: .screen24Width, height: 55, shape: RoundedRectangle(cornerRadius: 16), shadowRadius: 1.0)
                            .onTapGesture {
                                let params = ["country" : self.vm.selectedCountry.joined(separator: ", "),
                                              "location": "",
                                              "state": self.vm.selectedState.joined(separator: ", "),
                                              "universityName":""]
                                self.vm.postRequest(endPoint: .searchUniversity, params: params)
                            }
                    })
                }
            }
        }
    }
}

#Preview {
    HomeFilterView().environmentObject(StudentViewModel())
}

struct FlowLayout: View {
    let arrayofString: [String]
    @Binding var selectedArray: [String]
    var geometry: GeometryProxy
    var body: some View {
        let buttonWidth = calculateButtonWidth(geometry: geometry)
        let chunkSize = max(Int(geometry.size.width / buttonWidth), 1)
        VStack(alignment: .leading, spacing: 10) {
            ForEach(arrayofString.chunked(into: chunkSize), id: \.self) { row in
                HStack(spacing: 10) {
                    ForEach(row, id: \.self) { item in
                        Button(action: {
                            toggleSelection(for: item)
                        }) {
                            Text(item)
                                .customLabelStyle(textColor: selectedArray.contains(item) ? .anyWhite : .blue31, fontSize: 18, fontName: .generalSansMedium)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .background(selectedArray.contains(item) ? Color.blue31 : Color.blue.opacity(0.1))
                                .cornerRadius(15)
                        }
                    }
                }
            }
        }
    }
    private func toggleSelection(for country: String) {
           if let index = selectedArray.firstIndex(of: country) {
               selectedArray.remove(at: index) // Deselect if already selected
           } else {
               selectedArray.append(country) // Select if not already selected
           }
       }
    
    private func calculateButtonWidth(geometry: GeometryProxy) -> CGFloat {
        let minButtonWidth: CGFloat = 40
        let maxColumns = Int(geometry.size.width / (minButtonWidth + 70))
        let adjustedWidth = (geometry.size.width / CGFloat(maxColumns)) - 10
        return max(minButtonWidth, adjustedWidth)
    }
}

extension Array {
    func chunked(into size: Int) -> [[Element]] {
        var chunks = [[Element]]()
        for index in stride(from: 0, to: count, by: size) {
            let chunk = Array(self[index..<Swift.min(index + size, count)])
            chunks.append(chunk)
        }
        return chunks
    }
}
