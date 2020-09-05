//
//  MapView.swift
//  LNPopupUIExample
//
//  Created by Leo Natan on 9/3/20.
//

import SwiftUI
import MapKit

struct EnlargingButton: View {
	let label: String
	let action: (Bool) -> Void
	@State var pressed: Bool = false
	
	init(label: String, perform action: @escaping (Bool) -> Void) {
		self.label = label
		self.action = action
	}
	
	var body: some View {
		return Text(label)
			.font(.title)
			.foregroundColor(.white)
			.padding(10)
			.background(RoundedRectangle(cornerRadius: 10).foregroundColor(.blue))
			.scaleEffect(self.pressed ? 1.2 : 1.0)
			.onLongPressGesture(minimumDuration: .infinity, maximumDistance: .infinity, pressing: { pressing in
				withAnimation(.easeInOut) {
					self.pressed = pressing
					self.action(pressing)
				}
			}, perform: { })
	}
}

struct CustomBarMapView: View {
	static private let center = CLLocationCoordinate2D(latitude: 40.6892, longitude: -74.0445)
	static private let defaultRegion = MKCoordinateRegion(center: CustomBarMapView.center, span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
	
	static private let zoomedRegion = MKCoordinateRegion(center: CustomBarMapView.center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
	
	@State private var region = CustomBarMapView.defaultRegion
	
	private let onDismiss: () -> Void
	
	init(onDismiss: @escaping () -> Void) {
		self.onDismiss = onDismiss
	}
	
	@State var input: String = ""
	@State var isPopupOpen: Bool = false
	
	var body: some View {
		ZStack(alignment: Alignment(horizontal: .leading, vertical: .top)) {
			Map(coordinateRegion: $region)
				.ignoresSafeArea()
				.animation(.easeInOut)
			Button(action: {
				onDismiss()
			}, label: {
				Image(systemName: "chevron.left.circle.fill")
					.resizable()
					.renderingMode(.template)
					.frame(width: 30, height: 30, alignment: .center)
			})
			.background(Color(.systemBackground).cornerRadius(15))
			.padding(10)
		}
		.popup(isBarPresented: Binding.constant(true), isPopupOpen: $isPopupOpen) {
			Color.red
				.ignoresSafeArea()
		}
		.popupBarCustomView(wantsDefaultTapGesture: false, wantsDefaultPanGesture: false, wantsDefaultHighlightGesture: false) {
			ZStack(alignment: .trailing) {
				HStack {
					Spacer()
					EnlargingButton(label: "Zoom") { pressing in
						self.region = pressing ? CustomBarMapView.zoomedRegion : CustomBarMapView.defaultRegion
					}.padding()
					Spacer()
					
				}
				Button(action: {
					isPopupOpen.toggle()
				}, label: {
					Image(systemName: "chevron.up.square.fill")
						.resizable()
						.renderingMode(.template)
						.frame(width: 30, height: 30, alignment: .center)
				})
				.background(Color(.systemBackground).cornerRadius(15))
				.padding(10)
			}
		}
	}
}

struct MapView_Previews: PreviewProvider {
	static var previews: some View {
		CustomBarMapView(onDismiss: {})
	}
}