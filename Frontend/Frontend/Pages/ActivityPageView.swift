//
//  ActivityPageView.swift
//  Frontend
//
//  Created by nhi vu on 2/21/24.
//

import SwiftUI
import Firebase

struct ActivityPageView: View {
    @State private var activities: [Activity] = []
    @State private var selectedActivity: Activity?
    @State private var showDetail: Bool = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Past")
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding(.leading)
                        .padding(.top)

                    ForEach(activities) { activity in
                        ActivityCard(activity: activity)
                        .onTapGesture {
                            self.selectedActivity = activity
                            showDetail = true
                        }
                        .padding(.horizontal)
                    }
                }
            }
            .navigationTitle("Activity")
            .onAppear {
                fetchPastRoutes()
            }
            .navigationDestination(isPresented: $showDetail) {
                if let activity = selectedActivity {
                    DetailView(activity: activity)
                }
            }
        }
    }

    func fetchPastRoutes() {
        let db = Firestore.firestore()
        db.collection("past-routes").getDocuments { snapshot, error in
            guard let documents = snapshot?.documents else {
                print("Error fetching documents: \(String(describing: error))")
                return
            }

            let dateFormatter = DateFormatter()
            // Assuming English locale for month abbreviation
            dateFormatter.locale = Locale(identifier: "en_US")
            dateFormatter.dateFormat = "MMM dd yyyy h:mm a"

            let currentYear = Calendar.current.component(.year, from: Date())

            self.activities = documents.compactMap { doc -> Activity? in
                return Activity(documentId: doc.documentID, data: doc.data())
            }.sorted(by: { firstActivity, secondActivity in
                let firstDateString = "\(firstActivity.currentDate) \(currentYear) \(firstActivity.currentTime)"
                let secondDateString = "\(secondActivity.currentDate) \(currentYear) \(secondActivity.currentTime)"
                
                guard let firstDate = dateFormatter.date(from: firstDateString),
                      let secondDate = dateFormatter.date(from: secondDateString) else {
                    return false
                }

                return firstDate > secondDate
            })
        }
    }
}


#Preview {
    ActivityPageView()
}
