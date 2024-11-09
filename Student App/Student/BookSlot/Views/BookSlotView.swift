//
//  BookSlotView.swift
//  Student App
//
//  Created by Arjun   on 13/07/24.
//

import SwiftUI

struct BookSlotView: View {
    @EnvironmentObject var vm : StudentViewModel
    @State var data: University
    public let timer = Timer.publish(every: 3, on: .main, in: .common).autoconnect()
    @State private var selection = 0
    @State var images: [String] = ["one", "two", "three"]
    @State var selectedRep: Representatives?
    @State private var isBooked: Bool = false
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        VStack(spacing: 0){
            AsyncImage(url: URL(string: data.images ?? "")) { image in
                image.resizable()
                    .edgesIgnoringSafeArea(.top)
            } placeholder: {
                Image("one").resizable()
                    .edgesIgnoringSafeArea(.top)
                
            }.edgesIgnoringSafeArea(.top).frame(width: .screenWidth, height: 200)
            
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: 20){
                    Text(data.universityname)
                        .customLabelStyle(textColor: .black50, fontSize: 18, fontName: .generalSansSemiBold)
                    
                    Text("56th Rank")
                        .customLabelStyle(textColor: .blue31, fontSize: 12, fontName: .generalSansSemiBold)
                        .padding(EdgeInsets(top: 8, leading: 12, bottom: 8, trailing: 12))
                        .background(Color.white248)
                        .clipShape(Capsule())
                        .offset(y: -10)
                    
                    Text("In modern usage, the word has come to mean 'an institution of higher education offering tuition in mainly non-vocational subjects and typically having the power to confer degrees.'").lineSpacing(3)
                        .customLabelStyle(textColor: .gray64, fontSize: 16, fontName: .generalSansRegular)
                    
                    VStack(alignment: .leading, spacing: 8){
                        Text("Location")
                            .customLabelStyle(textColor: .black50, fontSize: 16, fontName: .generalSansSemiBold)
                        Text(data.location)
                            .customLabelStyle(textColor: .gray64, fontSize: 16, fontName: .generalSansRegular)
                    }
                    
                    VStack(alignment: .leading, spacing: 5){
                        Text("Admission Intakes")
                            .customLabelStyle(textColor: .black50, fontSize: 16, fontName: .generalSansSemiBold)
                        HStack(spacing: 20){
                            let items = data.admissionintake.components(separatedBy: ",")
                            ForEach(items, id: \.self) { item in
                                HStack(alignment: .center, spacing: 5) {
                                    Text("•")
                                        .font(.title)
                                    Text(item)
                                }.customLabelStyle(textColor: .gray64, fontSize: 16, fontName: .generalSansRegular)
                            }
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 10){
                        Text("Representative Names")
                            .customLabelStyle(textColor: .black50, fontSize: 16, fontName: .generalSansSemiBold)
                        HStack(alignment: .top, spacing: 20){
                            ForEach(vm.repData, id: \.self) { item in
                                RepresentavtivesTitleCell(fontSize: 16, size: 50, isHideName: false, isHideCheckMark: .constant(selectedRep == item), model: item)
                                    .onTapGesture {
                                        self.selectedRep = item
                                    }
                            }
                        }
                    }
                }.frame(width: .screen24Width).padding(.vertical)
            }
            Spacer(minLength: 0)
            
            Text("Book Slot")
                .customButtonStyle(textColor: .anyWhite, fontSize: 18, fontName: .generalSansSemiBold, bgColor: .blue31, width: .screen24Width, height: 55, shape: RoundedRectangle(cornerRadius: 16), shadowRadius: 1.0)
                .onTapGesture {
                    self.vm.bookSlot.location = data.location
                    self.vm.bookSlot.repData = self.selectedRep ?? .init(image: "", repname: "")
                    self.vm.bookSlot.universityName = data.universityname
                    self.vm.bookSlot.rankName = "56th Rank"
                    self.isBooked = true
                }.navigationDestination(isPresented: $isBooked, destination: {
                    PickSlotView().environmentObject(vm).navigationBarBackButtonHidden()
                })
        }.background(Color.white252)
            .overlay(alignment: .topLeading, content: {
                Button(action: {
                    dismiss.callAsFunction()
                }) {
                    Image(systemName: "xmark")
                        .customLabelStyle(textColor: .anyWhite, fontSize: 18, fontName: .generalSansSemiBold)
                        .padding(14)
                        .background(Color.anyBlack.opacity(0.6))
                        .clipShape(Circle())
                }.padding(.leading)
            })
    }
}

#Preview {
    BookSlotView(data: University(id: 1, universityname: "", description: "", location: "", repname: "", position: "", admissionintake: "", username: "", password: "", images: "")).environmentObject(StudentViewModel())
}

struct RepresentavtivesTitleCell: View {
    @State var fontSize: CGFloat
    @State var size: CGFloat
    @State var color : [Color] = [.blue31, .anyBlack, .gray64]
    @State var isHideName: Bool
    @Binding var isHideCheckMark: Bool
    @State var model: Representatives
    @State private var image: Image? = nil
    var body: some View {
        VStack(alignment: .center){
            VStack{
                if image == nil {
                    Circle()
                        .fill(color.randomElement() ?? .anyWhite)
                        .frame(width: size, height: size)
                        .overlay(
                            Text(APIUrls.abbreviate(model.repname))
                                .customLabelStyle(textColor: .anyWhite, fontSize: fontSize, fontName: .generalSansSemiBold)
                        )
                } else {
                    // Image with circular mask
                    image?
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: size, height: size)
                        .clipShape(Circle())
                }
            }.overlay(alignment: .topTrailing, content: {
                if isHideCheckMark {
                    Image(systemName: "checkmark.circle.fill")
                        .customLabelStyle(textColor: .blue31, fontSize: 20, fontName: .generalSansMedium)
                        .background(Color.anyWhite)
                        .clipShape(Circle())
                        .offset(x: 8, y: -5)
                }
            })
            if !isHideName {
                Text(model.repname)
                    .customLabelStyle(textColor: .gray64, fontSize: 12, fontName: .generalSansMedium)
                    .frame(width: size)
                    .lineLimit(3)
                    .onAppear {
                        loadImage()
                    }
            }
        }
    }
    private func loadImage() {
        URLSession.shared.dataTask(with: URL(string: model.image) ?? URL(fileURLWithPath: "")) { data, response, error in
                guard let data = data, let uiImage = UIImage(data: data) else { return }
                DispatchQueue.main.async {
                    self.image = Image(uiImage: uiImage)
                }
            }.resume()
        }
}

struct AsynImageView: View {
    @State var image: String
    var body: some View {
        AsyncImage(url: URL(string: image)) { phase in
            switch phase {
            case .failure:
                Image(systemName: "photo")
                    .font(.largeTitle)
            case .success(let image):
                image
                    .resizable()
            default:
                ProgressView()
            }
        }
    }
}

//struct BookSlotView: View {
//    @EnvironmentObject var vm : StudentViewModel
//    @State var data: University
//    public let timer = Timer.publish(every: 3, on: .main, in: .common).autoconnect()
//    @State private var selection = 0
//    @State var images: [String] = ["one", "two", "three"]
//    @State var selectedRep: Representatives?
//    @State private var isBooked: Bool = false
//    @Environment(\.dismiss) private var dismiss
//    var body: some View {
//        GeometryReader { geometry in
//            VStack(spacing: 0){
//                ZStack(alignment: .topLeading){
//                    TabView(selection: $selection){
//                        ForEach(0..<images.count, id: \.self) { index in
//                            Image(images[index])
//                                .tag(index)
//                        }
//                    }.tabViewStyle(.page(indexDisplayMode: .always))
//                        .frame(width: geometry.size.width, height: 300)
//                        .onReceive(timer, perform: { _ in
//                            withAnimation{
//                                selection = selection < images.count - 1 ? selection + 1 : 0
//                            }
//                        })
//
//
//                    Button(action: {
//                        dismiss.callAsFunction()
//                    }) {
//                        Image(systemName: "xmark")
//                            .customLabelStyle(textColor: .anyWhite, fontSize: 18, fontName: .generalSansSemiBold)
//                            .padding(14)
//                            .background(Color.anyBlack.opacity(0.6))
//                            .clipShape(Circle())
//                    }.padding(.top, geometry.safeAreaInsets.top)
//                        .padding(.leading, 8)
//
//                }
//                ScrollView(.vertical, showsIndicators: false) {
//                    VStack(alignment: .leading, spacing: 20){
//                        Text(data.universityname)
//                            .customLabelStyle(textColor: .black50, fontSize: 18, fontName: .generalSansSemiBold)
//
//                        Text("56th Rank")
//                            .customLabelStyle(textColor: .blue31, fontSize: 12, fontName: .generalSansSemiBold)
//                            .padding(EdgeInsets(top: 8, leading: 12, bottom: 8, trailing: 12))
//                            .background(Color.white248)
//                            .clipShape(Capsule())
//                            .offset(y: -10)
//
//                        Text("In modern usage, the word has come to mean 'an institution of higher education offering tuition in mainly non-vocational subjects and typically having the power to confer degrees.'").lineSpacing(3)
//                            .customLabelStyle(textColor: .gray64, fontSize: 16, fontName: .generalSansRegular)
//
//                        VStack(alignment: .leading, spacing: 8){
//                            Text("Location")
//                                .customLabelStyle(textColor: .black50, fontSize: 16, fontName: .generalSansSemiBold)
//                            Text(data.location)
//                                .customLabelStyle(textColor: .gray64, fontSize: 16, fontName: .generalSansRegular)
//                        }
//
//                        VStack(alignment: .leading, spacing: 5){
//                            Text("Admission Intakes")
//                                .customLabelStyle(textColor: .black50, fontSize: 16, fontName: .generalSansSemiBold)
//                            HStack(spacing: 20){
//                                let items = data.admissionintake.components(separatedBy: ",")
//                                ForEach(items, id: \.self) { item in
//                                    HStack(alignment: .center, spacing: 5) {
//                                        Text("•")
//                                            .font(.title)
//                                        Text(item)
//                                    }.customLabelStyle(textColor: .gray64, fontSize: 16, fontName: .generalSansRegular)
//                                }
//                            }
//                        }
//
//                        VStack(alignment: .leading, spacing: 10){
//                            Text("Representative Names")
//                                .customLabelStyle(textColor: .black50, fontSize: 16, fontName: .generalSansSemiBold)
//                            HStack(alignment: .top, spacing: 20){
//                                ForEach(vm.repData, id: \.self) { item in
//                                    RepresentavtivesTitleCell(fontSize: 16, size: 50, isHideName: false, isHideCheckMark: .constant(selectedRep == item), model: item)
//                                        .onTapGesture {
//                                            self.selectedRep = item
//                                        }
//                                }
//                            }
//                        }
//                    }.frame(width: .screen24Width).padding(.vertical)
//
//
//                }
//                Spacer(minLength: 0)
//
//                    Text("Book Slot")
//                        .customButtonStyle(textColor: .anyWhite, fontSize: 18, fontName: .generalSansSemiBold, bgColor: .blue31, width: .screen24Width, height: 55, shape: RoundedRectangle(cornerRadius: 16), shadowRadius: 1.0)
//                        .onTapGesture {
//                            self.isBooked = true
//                            self.vm.bookSlot = BookAppoDetailsModel(appointmentDate: "", appointmentSlot: "", location: data.location, repData: self.selectedRep ?? .init(image: "", repname: ""), studentName: "Anudeep", universityName: data.universityname, rankName: "56th Rank", phoneNumber: "")
//                        }.navigationDestination(isPresented: $isBooked, destination: {
//                            PickSlotView().environmentObject(vm).navigationBarBackButtonHidden()
//                })
//            }.background(Color.white252).edgesIgnoringSafeArea(.top)
//        }
//    }
//}
