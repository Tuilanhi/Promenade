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
            
            self.activities = documents.compactMap { doc -> Activity? in
                return Activity(documentId: doc.documentID, data: doc.data())
            }
        }
    }
}


#Preview {
    ActivityPageView()
}
