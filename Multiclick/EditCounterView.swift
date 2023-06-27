//
//  EditCounterView.swift
//  Multiclick
//
//  Created by Dev-LU on 04.09.22.
//

import SwiftUI

struct EditCounterView: View {
    @Environment(\.managedObjectContext) var moc
    @Environment(\.dismiss) var dismiss
    
    @State var counter: Counter
    @Binding var name: String
    @Binding var count: Int32
    @State private var note = ""
    @State private var step: Int32 = 1
    @State private var goalActive: Bool = false
    @State private var goal: Int32? = nil
    
    func loadData() {
        goalActive = counter.counterGoalActive
        goal = counter.counterGoal
        
    }
    
    
    var body: some View {
        NavigationView {
            // Form for adding new counters
            Form {
                Section (header: Text("Name and note")) {
                    TextField("\(counter.counterName ?? "")", text: $name)
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
                            print("pressed")
                            if name != counter.counterName && name != "" {
                                name = name
                                counter.counterName = name
                            }
                            if note != counter.counterNote && note != "" {
                                counter.counterNote = note
                            }
                            if count != counter.counterCount && count != 0 {
                                counter.counterCount = count
                            }
                            if step != counter.counterStep && step != 1 {
                                counter.counterStep = step
                            }
                            if goalActive && goal != nil {
                                counter.counterGoalActive = goalActive
                                counter.counterGoal = goal ?? 0
                            } else {
                                counter.counterGoalActive = false
                                counter.counterGoal = 999
                            }
                            
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
            }.navigationTitle("Edit counter")

        }.onAppear(perform: loadData)
        
        }
        
    }
