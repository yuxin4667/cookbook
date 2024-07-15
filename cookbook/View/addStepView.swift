//
//  addContentView.swift
//  DishPicker
//
//  Created by dcs on 2024/4/10.
//

import SwiftUI

struct addStepView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var steps: [String]
    @State var inputText = ""
    private func saveStep() {
        steps.append(inputText)
    }
    private var isNotValid: Bool {
        inputText.isEmpty
    }
    var body: some View {
        VStack {
            ScrollView {
                Label("新增步驟", systemImage: "pencil")
                    .font(.system(.title, design: .rounded))
                    .fontWeight(.bold)
                    .foregroundColor(Color("barTitle"))
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding()
                
                TextField("輸入步驟...", text: $inputText, axis: .vertical )
                    .padding(.vertical, 10)
                    .padding(.leading, 10)
                    //.frame(minHeight: 0)
                    .font(.system(.title2, design: .rounded))
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color(.systemGray3), lineWidth: 1)
                    )
                    .lineLimit(1...10)
                
                    .background(.white)
                //Spacer()
                
            }

            
            Button {
                saveStep()
                dismiss()
            } label: {
                Text("加入")
                    .frame(maxWidth: .infinity)
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.vertical, 10)
                    .padding(.horizontal)
                    .background(isNotValid ? Color(.systemGray6) : .button)
                    .cornerRadius(15)
                    .foregroundColor(isNotValid ? Color(.systemGray4) : .white)
                    .padding(.vertical, 20)
            }
            .disabled(isNotValid)
        }
        .padding()
        .background(Color("mainBG"))
    }
}

