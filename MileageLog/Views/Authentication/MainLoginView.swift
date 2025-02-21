import SwiftUI

struct MainLoginView: View {
    @EnvironmentObject private var mileageLogVM: MileageLogViewModel
    
    var body: some View {
        VStack {
            Image("Start")
                .renderingMode(.original)
                .resizable()
                .aspectRatio(contentMode: .fill)
                // Use of UIScreen object to get the height of the screen
                .frame(width: 356, height: UIScreen.main.bounds.size.height - 300)
                .clipped()
                .overlay(alignment: .topLeading) {
                    VStack(alignment: .leading, spacing: 11) {
                        Image("Icon")
                            .renderingMode(.original)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 110, height: 110, alignment: .center)
                            .clipped()
                            .mask {
                                RoundedRectangle(cornerRadius: 24, style: .continuous)
                            }
                        VStack(alignment: .leading, spacing: 1) {
                            Text("Mileage Log")
                                .font(.largeTitle.weight(.medium))
                                .foregroundColor(.white)
                        }
                    }
                    .padding()
                    .padding(.top, 42)
                }
                .mask {
                    RoundedRectangle(cornerRadius: 24, style: .continuous)
                }
                .padding()
                .padding(.top, 50)
                .shadow(color: Color(.sRGBLinear, red: 0/255, green: 0/255, blue: 0/255).opacity(0.15), radius: 18, x: 0, y: 14)
            VStack(spacing: 10) {
                // NavigationLink to move to signIn 
                NavigationLink(value: "signIn") {
                    HStack(alignment: .firstTextBaseline) {
                        Image(systemName: "face.smiling.fill")
                            .imageScale(.medium)
                        Text("Sign In")
                    }
                    .font(.system(.body, weight: .medium))
                    .padding(.vertical, 16)
                    .frame(maxWidth: .infinity)
                    .clipped()
                    .foregroundColor(.orange)
                    .background {
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .stroke(.clear.opacity(0.25), lineWidth: 0)
                            .background(RoundedRectangle(cornerRadius: 10, style: .continuous).fill(.yellow.opacity(0.15)))
                    }
                }
                
                NavigationLink(value: "signUp") {
                    HStack(alignment: .firstTextBaseline) {
                        Image(systemName: "person.crop.circle.badge.plus.fill")
                            .imageScale(.medium)
                        Text("Sign Up")
                    }
                    .font(.system(.body, weight: .medium))
                    .padding(.vertical, 16)
                    .frame(maxWidth: .infinity)
                    .clipped()
                    .foregroundColor(.orange)
                    .background {
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .stroke(.clear.opacity(0.25), lineWidth: 0)
                            .background(RoundedRectangle(cornerRadius: 10, style: .continuous).fill(.yellow.opacity(0.15)))
                    }
                }

            }
            .padding(.horizontal)
            Spacer()
        }
    }
}

struct MainLoginView_Previews: PreviewProvider {
    static var previews: some View {
        MainLoginView()
    }
}
