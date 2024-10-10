//
//  PickSlotView.swift
//  Student App
//
//  Created by Arjun   on 13/07/24.
//

import SwiftUI

struct PickSlotView: View {
    @EnvironmentObject var vm : StudentViewModel
    @State var searchDate: String = ""
    @State var selectSlot: String = ""
    @State private var isBooked: Bool = false
    var body: some View {
        ZStack{
            Color.white252.ignoresSafeArea()
            VStack(alignment: .leading, spacing: 20){
                HStack(spacing: 20){
                    BackButtonView(fontSize: 22)
                    Text("Pick a slot")
                        .customLabelStyle(textColor: .black50, fontSize: 22, fontName: .generalSansMedium)
                }
                SearchBar(text: $searchDate)
                
                CustomCalendarView().environmentObject(vm)
                    .padding(.top)
                
                SelectSlotView(label: "Morning Slots", slots: vm.morningSlots, selectSlot: $selectSlot)
                Divider()
                SelectSlotView(label: "Evening Slots", slots: vm.eveningSlots, selectSlot: $selectSlot)
                
                Spacer(minLength: 0)
                
                Text("Continue")
                    .customButtonStyle(textColor: .anyWhite, fontSize: 18, fontName: .generalSansSemiBold, bgColor: .blue31, width: .screen24Width, height: 55, shape: RoundedRectangle(cornerRadius: 16), shadowRadius: 1.0)
                    .onTapGesture {
                        self.vm.bookSlot.appointmentDate = "\(vm.selectedDate.datetoymdformate())"
                        self.vm.bookSlot.appointmentSlot = selectSlot
                        self.isBooked = true
                    }.navigationDestination(isPresented: $isBooked, destination: {
                        AppointmentDetailsView().environmentObject(vm).navigationBarBackButtonHidden()
                    })
            }.padding(.horizontal)
                .onTapGesture {
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }
        }
    }
}

#Preview {
    PickSlotView().environmentObject(StudentViewModel())
}

struct SlotsDaysView: View {
    @EnvironmentObject var vm: StudentViewModel
    @State var width: CGFloat
    @State var height: CGFloat
    let date: Date
    let isSelected: Bool
    let onSelect: () -> Void
    var body: some View {
        VStack(alignment: .center, spacing: 5){
            Text(DateFormatter.dayNameFormatter.string(from: date))
                .customLabelStyle(textColor: .gray153, fontSize: 16, fontName: .generalSansMedium)
            Text(DateFormatter.dayNumberFormatter.string(from: date))
                .customLabelStyle(textColor: .anyBlack, fontSize: 18, fontName: .generalSansSemiBold)
        }.frame(width: width, height: height, alignment: .center)
            .background(isSelected ? .blue31.opacity(0.1) : .anyWhite)
            .overlay(RoundedRectangle(cornerRadius: 10).strokeBorder( isSelected ? .blue31 : .anyBlack, style: StrokeStyle(lineWidth: 1.0)))
            .onTapGesture {
                self.vm.selectedDate = date
                onSelect()
                self.vm.getSlots()
            }
    }
}

struct SelectSlotView: View {
    @State var label: String
    @State var slots : [String]
    @Binding var selectSlot: String
    var body: some View {
        VStack(alignment: .leading, spacing: 14){
            Text(label)
                .customLabelStyle(textColor: .gray64, fontSize: 22, fontName: .generalSansMedium)
            
            ScrollView(.horizontal, showsIndicators: false){
                HStack {
                    ForEach(slots, id: \.self) { slot in
                        SlotViewCell(slot: slot, isSelected: .constant(selectSlot == slot))
                            .onTapGesture {
                                self.selectSlot = slot
                            }
                    }
                }
            }
        }.padding(12)
    }
}

struct SlotViewCell: View {
    @State var slot: String
    @Binding var isSelected: Bool
    var body: some View {
        Text(slot).tracking(1)
            .customLabelStyle(textColor: isSelected ? .anyWhite : .black50, fontSize: 20, fontName: .generalSansMedium)
            .lineSpacing(1)
            .padding()
            .background(isSelected ? .blue31 : .anyWhite)
            .cornerRadius(16)
            .overlay(RoundedRectangle(cornerRadius: 16).strokeBorder( isSelected ? .blue31 : .black50, style: StrokeStyle(lineWidth: 1.0)))
            .id(UUID())
    }
}

struct CustomCalendarView: View {
    @EnvironmentObject var vm: StudentViewModel
    @State private var selectedDate = Date()
    @State private var visibleDate = Date()
    private var calendar = Calendar.current
    var body: some View {
        VStack(alignment: .leading){
            Text(DateFormatter.monthYearFormatter.string(from: visibleDate))
                .customLabelStyle(textColor: .anyBlack, fontSize: 14, fontName: .generalSansMedium)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(0..<30) { offset in
                        let date = calendar.date(byAdding: .day, value: offset, to: Date())!
                        SlotsDaysView(width: 56, height: 65, date: date, isSelected: DateFormatter.dayNumberFormatter.string(from: selectedDate) == DateFormatter.dayNumberFormatter.string(from: date),
                                      onSelect: {
                            selectedDate = date
                            if DateFormatter.monthYearFormatter.string(from: visibleDate) != DateFormatter.monthYearFormatter.string(from: selectedDate) {
                                visibleDate = date
                            }
                        }
                        ).environmentObject(vm)
                        .background(
                            GeometryReader { geo in
                                Color.clear
                                    .onAppear {
                                        updateVisibleDate(geo: geo, date: date)
                                    }
                                    .onChange(of: geo.frame(in: .global)) { newFrame in
                                        updateVisibleDate(geo: geo, date: date)
                                    }
                            }
                        )
                    }
                }
                .padding(.horizontal, 10)
            }
        }.padding().frame(width: .screen24Width, height: 129)
            .background(Color.anyWhite)
            .cornerRadius(20)
    }
    
    private func updateVisibleDate(geo: GeometryProxy, date: Date) {
        let midX = UIScreen.main.bounds.midX
        let datePosition = geo.frame(in: .global).midX
        if abs(midX - datePosition) < 30 {
            visibleDate = date
        }
    }
}
