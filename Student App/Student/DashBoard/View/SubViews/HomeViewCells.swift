//
//  HomeViewCells.swift
//  Student App
//
//  Created by Arjun   on 13/07/24.
//

import SwiftUI

struct UniversityAppointmentCell: View {
    @EnvironmentObject var vm: StudentViewModel
    @State var data: AllAppointmentModel
    @State var images: [String] = ["one", "two", "three"]
    var body: some View {
        VStack(spacing: 0){
            AsyncImage(url: URL(string: APIUrls.urlImages.randomElement() ?? "")) { image in
                image.resizable()
            } placeholder: {
                Image(images.randomElement() ?? "").resizable()
            }
            .aspectRatio(contentMode: .fill)
            .frame(width: .screen24Width, height: 120)
            .clipShape(.rect(cornerRadius: 20))
            HStack(alignment: .top){
                VStack(alignment: .leading, spacing: 5){
                    Text(data.universityname ?? "--")
                        .customLabelStyle(textColor: .black50, fontSize: 14, fontName: .generalSansSemiBold)
                    Text(data.location ?? "--")
                        .customLabelStyle(textColor: .gray111, fontSize: 14, fontName: .generalSansMedium)
                }
                Spacer(minLength: 0)
                VStack(alignment: .leading, spacing: 5){
                    Text("Representativies")
                        .customLabelStyle(textColor: .black50, fontSize: 12, fontName: .generalSansMedium)
                    HStack{
                        ForEach(0..<2, id: \.self) { id in
                            RepresentavtivesTitleCell(fontSize: 9, size: 25, isHideName: true, isHideCheckMark: .constant(false), model: Representatives(image: "", repname: data.repname ?? ""))
                                .offset(x:  CGFloat(id != 0 ? (-14*id) : 0))
                        }
                    }
                }
            }.padding(12).background(Color.anyWhite)
        }.clipShape(RoundedRectangle(cornerRadius: 20))
            .shadow(radius: 3)
            .overlay(alignment: .topLeading, content: {
                Text("\(data.appointmentdate?.formattedDate() ?? "Aug 24th 2024") | \(data.appointmentslot ?? "01:00-02:00")").tracking(1)
                    .customLabelStyle(textColor: .anyWhite, fontSize: 12, fontName: .generalSansMedium)
                    .padding(EdgeInsets(top: 5, leading: 8, bottom: 5, trailing: 8))
                    .background(Color.green79)
                    .clipShape(Capsule())
                    .padding()
            })
    }
}

struct RecommendedUniversityCell: View {
    @EnvironmentObject var vm: StudentViewModel
    @State var data: University
    @State var images: [String] = ["one", "two", "three"]
    var body: some View {
        VStack(spacing: 0){
            AsyncImage(url: URL(string: data.images ?? "")) { image in
                image.resizable()
            } placeholder: {
                Image(images.randomElement() ?? "").resizable()
            }
            .aspectRatio(contentMode: .fill)
            .frame(width: .screen48Width/2, height: 120)
            .clipShape(.rect(cornerRadius: 20))
            HStack(alignment: .top){
                VStack(alignment: .leading, spacing: 5){
                    Text(data.universityname)
                        .customLabelStyle(textColor: .black50, fontSize: 14, fontName: .generalSansSemiBold)
                    Text(data.location)
                        .customLabelStyle(textColor: .gray111, fontSize: 14, fontName: .generalSansMedium)
                }
                Spacer(minLength: 0)
            
            }.padding(12).background(Color.anyWhite)
        }.clipShape(RoundedRectangle(cornerRadius: 20))
    }
}
