import SwiftUI

struct CardModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .cornerRadius(20)
    }
}

struct CardView: View {
    var statTitle: String
    var statGPL: String
    var statPetrol: String
    var statIcon: String
    
    var body: some View {
        HStack(alignment: .center) {
            ZStack() {
                Circle()
                    .fill(Color.accentColor)
                    .frame(width: 100)
                Image(systemName: statIcon)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 50)
                    .padding()
                    .foregroundColor(.white)
            }
            .padding()
            
            VStack(alignment: .leading) {
                Text(statTitle)
                    .font(.system(size: 25, weight: .bold, design: .default))
                Text(statGPL)
                    .font(.system(size: 15, weight: .bold, design: .default))
                Text(statPetrol)
                    .font(.system(size: 15, weight: .bold, design: .default))
            }.padding(.trailing, 20)
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: 130, alignment: .center)
        .background(Color(UIColor.systemGray5))
        .modifier(CardModifier())
        .padding(.all, 10)
    }
}
