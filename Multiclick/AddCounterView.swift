//
//  AddCounterView.swift
//  Multiclick
//
//  Created by Dev-LU on 03.09.22.
//

import SwiftUI

struct AddCounterView: View {
    @Environment(\.managedObjectContext) var moc
    @Environment(\.dismiss) var dismiss
    
    @State private var name = ""
    @State private var count: Int32? = nil
    @State private var note = ""
    @State private var step: Int32 = 1
    @State private var goalActive = false
    @State private var goal: Int32? = nil
    
    var body: some View {
        NavigationView {
            // Form for adding new counters
            Form {
                Section (header: Text("Name and note")) {
                    TextField("Counter name", text: $name)
                    TextEditor(text: $note)
                        .frame(minWidth: 0, minHeight: 100, maxHeight: 200)
                }
                
                Section (header: Text("Counter Settings")) {
                    TextField("Initial value", value: $count, format: .number)
                        .keyboardType(.decimalPad)
                    Toggle(isOn: $goalActive) {
                            Text("Set goal?")
                        }
                    if goalActive {
                        TextField("Goal", value: $goal, format: .number)
                            .keyboardType(.decimalPad)
                    }
                    Stepper {
                        Text("Step: \(step)")
                            } onIncrement: {
                                step += 1
                            } onDecrement: {
                                if (step > 1){
                                    step -= 1
                                } else {
                                    step = 1
                                }
                            }
                }
                
                Section {
                    // Save counter
                    HStack {
                        Button(action: {
                            let newCounter = Counter(context: moc)
                            newCounter.counterID = UUID()
                            newCounter.counterCreationDate = Date()
                            newCounter.counterName = name
                            newCounter.counterNote = note
                            newCounter.counterCount = count ?? 0
                            newCounter.counterStep = step
                            newCounter.counterGoalActive = goalActive
                            newCounter.counterGoal = goal ?? 0
                            try? moc.save()
                            dismiss()
                        }) {
                            Image(systemName: "checkmark.circle.fill").imageScale(.large)
                            Text("Save")
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.borderedProminent)
                        .controlSize(.large)
                        .tint(.green)
                        
                        
                        Button(action: {
                            dismiss()
                        }) {
                            Image(systemName: "x.circle.fill").imageScale(.large)
                            Text("Cancel")
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.borderedProminent)
                        .controlSize(.large)
                        .tint(.red)
                        
                    }
                }
                .navigationTitle("Add new counter")
            }
        }
        }
    }


struct AddCounterView_Previews: PreviewProvider {
    static var previews: some View {
        AddCounterView()
    }
}
