
import SwiftUI

struct ResultItem: View {
    var nameType: String
    var score: Int
    var color: Color
    var body: some View {
        VStack{
            Text("\(score)")
                .font(.headline)
                .foregroundColor(color)
            
            Text(nameType)
                .font(.caption)
                .foregroundColor(.white)
                .opacity(0.5)
        }
        .frame(width: 89, height: 49, alignment: .center)

    }
}
