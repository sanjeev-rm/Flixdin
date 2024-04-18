//
//  BirthdayView.swift
//  Flixdin
//
//  Created by Sanjeev RM on 05/07/23.
//

import SwiftUI

struct BirthdayView: View {
    
    @EnvironmentObject var signUpViewModel: SignUpViewModel
    
    /// Date range of birthday.
    /// - Min - 100 years ago
    /// - Max - 13 years ago
    private let birthdayDateRange: ClosedRange<Date>? = {
        let calendar = Calendar.current
        guard let hundredYearsAgo = calendar.date(byAdding: .year, value: -100, to: Date.now),
              let thirteenYearsAgo = calendar.date(byAdding: .year, value: -13, to: Date.now) else {
            return nil
        }
        return hundredYearsAgo...thirteenYearsAgo
    }()
    
    var body: some View {
        baseView
            .navigationDestination(isPresented: $signUpViewModel.navigateToTermsAndConditionsView) {
                TermsAndConditionsView()
                    .environmentObject(signUpViewModel)
            }
    }
}



extension BirthdayView {
    
    private var baseView: some View {
        VStack(alignment: .leading, spacing: 32) {
            
            titleAndSubtitle
            
            datePicker
            
            nextButton
            
            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(flixColor: .backgroundPrimary))
    }
    
    private var titleAndSubtitle: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("When is your Birthday?")
                .font(.system(size: 24, weight: .bold, design: .default))
            
            Text("Please use your own date of birth even if this is for a business or some other purpose. No one will see this on your profile.")
                .font(.system(size: 15))
        }
    }
    
    private var datePicker: some View {
        HStack(alignment: .center) {
            Spacer()
            DatePicker("Birthday",
                       selection: $signUpViewModel.dob,
                       in: birthdayDateRange!,
                       displayedComponents: .date)
            .datePickerStyle(.compact)
            Spacer()
        }
    }
    
    private var nextButton: some View {
        Button {
            // MARK: Navigate to CreateUsernameView
            signUpViewModel.navigateToTermsAndConditionsView = true
        } label: {
            Text("Next")
                .font(.system(size: 22))
                .foregroundColor(.init(flixColor: .darkOlive))
                .frame(height: 40)
                .frame(maxWidth: .infinity)
        }
        .buttonStyle(.borderedProminent)
    }
}

struct BirthdayView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            BirthdayView()
                .environmentObject(SignUpViewModel())
        }
    }
}
