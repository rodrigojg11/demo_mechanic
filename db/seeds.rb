services = [
  { slug: "oil", name: "Oil Change", description: "Synthetic, semi-synthetic, or conventional oil. Filter included, no hidden fees.", duration_minutes: 30, buffer_minutes: 15, price_cents: 4_500, position: 1 },
  { slug: "brakes", name: "Brakes", description: "Pads, rotors, and full inspection. We show you the parts before replacing them.", duration_minutes: 90, buffer_minutes: 15, price_cents: 12_000, popular: true, position: 2 },
  { slug: "diagnostic", name: "Electronic Diagnostics", description: "OBD2 scan, all-module readout, and a clear findings report.", duration_minutes: 45, buffer_minutes: 15, price_cents: 6_500, position: 3 },
  { slug: "alignment", name: "Alignment & Balancing", description: "Computerized Hunter equipment to help your tires last longer.", duration_minutes: 60, buffer_minutes: 15, price_cents: 8_500, popular: true, position: 4 },
  { slug: "suspension", name: "Suspension", description: "Shocks, ball joints, and control arms for the ride your car should have.", duration_minutes: 120, buffer_minutes: 15, price_cents: 18_000, position: 5 },
  { slug: "premium", name: "Complete Service", description: "Oil + brakes + diagnostics + 35-point inspection in one visit.", duration_minutes: 180, buffer_minutes: 15, price_cents: 22_000, position: 6 }
]

services.each do |attributes|
  Service.find_or_initialize_by(slug: attributes[:slug]).update!(attributes)
end
