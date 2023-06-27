//
//  ContentView.swift
//  Multiclick
//
//  Created by Dev-LU on 01.09.22.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        entity: Counter.entity(),
        sortDescriptors: [
            NSSortDescriptor(keyPath: \Counter.counterCreationDate, ascending: false),
            NSSortDescriptor(keyPath: \Counter.counterName, ascending: true)
        ],
        animation: .default
    ) private var counters: FetchedResults<Counter>
    
    @State private var isPresentingAddCounterView = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(counters) { counter in
                    CounterItemView(
                        count: counter.counterCount,
                        title: counter.counterName ?? "No counter",
                        counter: counter
                    )
                }
                .onDelete(perform: deleteCounters)
            }
            .navigationBarTitle("All counters")
            .navigationBarItems(trailing: addButton)
            .sheet(isPresented: $isPresentingAddCounterView) {
                AddCounterView()
            }
        }
    }
    
    private var addButton: some View {
        Button(action: { isPresentingAddCounterView.toggle() }) {
            Image(systemName: "plus.circle.fill")
                .imageScale(.large)
        }
    }
    
    private func deleteCounters(offsets: IndexSet) {
        withAnimation {
            offsets.map { counters[$0] }.forEach(viewContext.delete)
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

    
    


struct CounterItemView: View {
    @Environment(\.managedObjectContext) var moc
    @State var count: Int32 = 0
    @State var title: String = ""
    @State var counter: Counter
    let impact = UIImpactFeedbackGenerator(style: .light)

    var body: some View {
        VStack {
            NavigationLink(destination: CounterDetailView(counter: counter, count: $count, name: $title)) {
                Text(title)
                    .font(Font.system(size: 20))
                    .lineLimit(1)
                    .frame(maxWidth: .infinity, alignment: .center)
            }
            HStack(alignment: .center, spacing: 0) {
                //Minus button
                Button(action: {
                    if (counter.counterCount > 0){
                        counter.counterCount -= counter.counterStep
                        count = counter.counterCount
                        impact.impactOccurred()
                        do {
                            try moc.save()
                        } catch {
                            print("Data not saved")
                        }
                    } else {
                        counter.counterCount = 0
                        count = counter.counterCount
                        impact.impactOccurred()
                        do {
                            try moc.save()
                        } catch {
                            print("Data not saved")
                        }
                    }
                }) {
                    Text("-")
                        .frame(width: 40, height: 40)
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                .tint(.red)
                .font(Font.system(size: 35))
                .padding(.leading, 0)

                // Display count
                if counter.counterGoalActive && counter.counterCount >= counter.counterGoal {
                    Text("\(count)")
                        .font(Font.system(size: 35, weight: .bold)).lineLimit(1)
                        .foregroundColor(.green)
                        .frame(maxWidth: .infinity)
                        .transition(.opacity)
                        .id("Count-\(count)")
                } else {
                    Text("\(count)")
                        .transition(.opacity)
                        .font(Font.system(size: 35)).lineLimit(1)
                        .frame(maxWidth: .infinity)
                        .transition(.slide)
                        .id("Count-\(count)")
                }

                // Plus button
                Button(action: {
                    counter.counterCount += counter.counterStep
                    count = counter.counterCount
                    impact.impactOccurred()
                    do {
                        try moc.save()
                    } catch {
                        print("Data not saved")
                    }
                }) {
                    Text("+")
                        .frame(width: 40, height: 40)
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                .tint(.blue)
                .font(Font.system(size: 35))
            }
        }
        .swipeActions(edge: .leading, allowsFullSwipe: true) {
            Button {
                count = 0
                counter.counterCount = count
                try? moc.save()
            } label: {
                Label("Reset", systemImage: "00.square.fill")
            }
            .tint(.blue)
          }
        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                          Button (role: .destructive) {
                              moc.delete(counter)
                              try? moc.save()
                          } label: {
                              Label("Delete", systemImage: "trash")
                          }
                          .tint(.red)
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
        }
    }
}
