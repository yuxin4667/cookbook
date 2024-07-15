import SwiftUI
import Foundation

struct LoginView: View {

    var body: some View {
        
        NavigationView{
            
            ZStack {
                Color.mainBG
                    .ignoresSafeArea()
                Circle()
                    .scale(1.7)
                    .foregroundColor(.white.opacity(0.2))
                Circle()
                    .scale(1.25)
                    .foregroundColor(.white)
                
                
                VStack(alignment: .center) {
                    
                    Spacer()
                    
                    Image("mainIcon")
                        .resizable()
                        .frame(maxWidth: 150, maxHeight:150)
                    
                        .padding(.top)
                    Text("CookBook")
                        .foregroundStyle(.barTitle)
                        .fontWeight(.heavy)
                        .font(.system(.largeTitle, design: .rounded))
                    
                    Spacer()
                }
                
                VStack(alignment: .center) {
                    
                    Spacer()
                    NavigationLink {
                        RecipeListView()
                    } label:{
                        Text("Welcome")
                            .frame(maxWidth: .infinity)
                            .font(.title2)
                            .fontWeight(.bold)
                            .padding(.vertical, 13)
                            .padding(.horizontal)
                            .background(.button)
                            .cornerRadius(30)
                            .foregroundColor(.white)
                            .padding(.horizontal, 50)
                    }
                }
            }
        }
    }
}

#Preview {
    LoginView()
}
