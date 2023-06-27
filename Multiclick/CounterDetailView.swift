//
//  CounterDetailView.swift
//  Multiclick
//
//  Created by Dev-LU on 03.09.22.
//

import SwiftUI

struct CounterDetailView: View {
    let counter: Counter
    
    @Environment(\.managedObjectContext) var moc
    @Environment(\.dismiss) var dismiss
    
    @State private var showDeleteAlert = false
    @State var showEditCounterView: Bool = false
    @Binding var count: Int32
    @Binding var name: String

    
    var body: some View {
        ScrollView {
            // Show details about a counter
            VStack {
                GroupBox(label:
                        Label("Counter", systemImage: "number.circle.fill")
                ){
                    Text("COUNT")
                        .font(.caption)
                        .font(Font.system(size: 40))
                    Text("\(counter.counterCount)")
                        .font(Font.system(size: 70))
                    Text("")
                    Text("STEP")
                        .font(.caption)
                        .font(Font.system(size: 40))
                    Text("\(counter.counterStep)")
                        .font(Font.system(size: 40))
                    if counter.counterGoalActive {
                        Text("")
                        Text("GOAL")
                            .font(.caption)
                            .font(Font.system(size: 40))
                        Text("\(counter.counterGoal)")
                            .font(Font.system(size: 40))
                    }
                }
                if counter.counterNote != "" {
                    GroupBox(label:
                            Label("Note", systemImage: "note.text")
                    ){
                        Text("\(counter.counterNote ?? "No note")")
                    }
                }

                
                GroupBox(label:
                        Label("CREATION TIME", systemImage: "calendar.badge.clock")
                ){
                    Text("\(counter.counterCreationDate ?? Date())")
                }
                
            }
            .navigationTitle(counter.counterName?.uppercased() ?? "Unnamed")
            .padding(20)
            // configure alert for deleting a counter
            .alert("Delete counter?", isPresented: $showDeleteAlert) {
                Button("Delete", role: .destructive, action: deleteCounter)
                Button("Cancel", role: .cancel){}
            } message: {
                Text("Are you sure to delete this counter?")
            }
            // Show toolbar icons for deleting and editing
            .toolbar {
                HStack {
                    Button {
                        showEditCounterView.toggle()
                    } label: {
                        Label("Delete this counter", systemImage: "square.and.pencil")
                    }
                    
                    Button {
                        showDeleteAlert = true
                    } label: {
                        Label("Delete this counter", systemImage: "trash")
                    }
                }
            }
        }
        // Show overlay form for editing a counter
        .sheet(isPresented: $showEditCounterView, content: {
            EditCounterView(counter: counter, name: $name, count: $count)
        })
    }
    
    // Function to delete a counter
    func deleteCounter() {
        moc.delete(counter)
        try? moc.save()
        dismiss()
    }
    
}



/*
struct CounterDetailView_Previews: PreviewProvider {
    static var previews: some View {
        CounterDetailView()
    }
}
*/
