class HomepageContent
  BUSINESS = {
    name: "Cruz Auto",
    full_name: "Cruz Auto · Auto Repair Shop",
    tagline: "Your car, in good hands.",
    est: "EST. 2011",
    city: "Oak Cliff",
    region: "Dallas, Texas",
    address: "632 W Davis St, Dallas, TX 75208",
    phone: "+1 (214) 555-0199",
    phone_raw: "12145550199",
    whatsapp: "12145550199",
    email: "hello@cruzauto.shop",
    instagram: "@cruzauto.dallas",
    instagram_url: "https://instagram.com/"
  }.freeze

  MECHANIC = {
    name: "Carlos",
    full_name: "Carlos Cruz",
    alias: "\"Doc Cruz\"",
    years: 15,
    origin: "Oak Cliff, Dallas",
    specialties: ["Electronic Diagnostics", "Engine & Transmission", "Brakes & Suspension", "A/C & Electrical", "Alignment & Balancing"],
    bio: [
      "I started fixing my dad's Cutlass in the garage at 16 with no manual. Fifteen years later, I have modern diagnostic equipment and the same love for making a car run right.",
      "Cruz Auto was born in Oak Cliff because this is home: neighborhood roots, honest repairs, and prices that respect people. I will tell you exactly what is failing, what it costs, and what can wait."
    ],
    certs: ["ASE Master Technician", "Texas Licensed Inspector #TX-A7742", "Bosch Certified Diagnostics"],
    photo: "https://images.unsplash.com/photo-1619642751034-765dfdf7c58e?w=900&q=80&auto=format&fit=crop"
  }.freeze

  GALLERY = [
    { src: "https://images.unsplash.com/photo-1486262715619-67b85e0b08d3?w=900&q=80&auto=format&fit=crop", tag: "Engine", caption: "Injector cleaning · Ford F-150" },
    { src: "https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=900&q=80&auto=format&fit=crop", tag: "Tires", caption: "Rotation and balancing · Camry 2020" },
    { src: "https://images.unsplash.com/photo-1525609004556-c46c7d6cf023?w=900&q=80&auto=format&fit=crop", tag: "Brakes", caption: "New rotors · Silverado 2018" },
    { src: "https://images.unsplash.com/photo-1580273916550-e323be2ae537?w=900&q=80&auto=format&fit=crop", tag: "Shop", caption: "Cruz Auto - W Davis St" },
    { src: "https://images.unsplash.com/photo-1625047509248-ec889cbff17f?w=900&q=80&auto=format&fit=crop", tag: "Diagnostics", caption: "OBD2 scan · Durango 2019" },
    { src: "https://images.unsplash.com/photo-1614026480418-bd11fdb9fa26?w=900&q=80&auto=format&fit=crop", tag: "Engine", caption: "Synthetic oil change" },
    { src: "https://images.unsplash.com/photo-1617788138017-80ad40651399?w=900&q=80&auto=format&fit=crop", tag: "Electrical", caption: "Electrical diagnostics · Equinox" },
    { src: "https://images.unsplash.com/photo-1568772585407-9361f9bf3a87?w=900&q=80&auto=format&fit=crop", tag: "Suspension", caption: "New shocks · Sentra 2017" }
  ].freeze

  REVIEWS = [
    { name: "Miguel Torres", handle: "@migueltor", initials: "MT", when: "1 week ago", stars: 5, text: "Carlos found the issue in 20 minutes after three other shops missed it. He charged exactly what he quoted, and the car left perfect." },
    { name: "Sandra Flores", handle: "@sflorestx", initials: "SF", when: "2 weeks ago", stars: 5, text: "He explained everything with photos and clear pricing. I never felt pushed. The brakes feel new and the price was fair." },
    { name: "Jerome Williams", handle: "@jwilliams.oak", initials: "JW", when: "3 weeks ago", stars: 5, text: "I have taken my Silverado to Carlos for 4 years. He always tells me what is urgent and what can wait. That honesty matters." },
    { name: "Andres Guzman", handle: "@andguztx", initials: "AG", when: "5 days ago", stars: 5, text: "I brought my car in with the check engine light on. It was a cheap sensor, and he did not try to sell me work I did not need." },
    { name: "Patricia Mendez", handle: "@pmendez.dallas", initials: "PM", when: "1 month ago", stars: 5, text: "The best shop on the west side of Dallas. Clean, honest, and fast. They checked the whole car during my alignment at no extra charge." }
  ].freeze

  HOURS = [
    { day: "Monday", range: "8:00 AM - 6:00 PM", open: true },
    { day: "Tuesday", range: "8:00 AM - 6:00 PM", open: true },
    { day: "Wednesday", range: "8:00 AM - 6:00 PM", open: true },
    { day: "Thursday", range: "8:00 AM - 6:00 PM", open: true },
    { day: "Friday", range: "8:00 AM - 6:00 PM", open: true },
    { day: "Saturday", range: "8:00 AM - 2:00 PM", open: true },
    { day: "Sunday", range: "Closed", open: false }
  ].freeze

  def business
    BUSINESS
  end

  def mechanic
    MECHANIC
  end

  def gallery
    GALLERY
  end

  def reviews
    REVIEWS
  end

  def hours
    HOURS
  end
end
