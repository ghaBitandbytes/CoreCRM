pin "application", preload: true
pin "@hotwired/turbo-rails", to: "turbo.min.js", preload: true

# Correct Chartkick & Chart.js pins
pin "chartkick", to: "chartkick.js", preload: true
pin "Chart.bundle", to: "Chart.bundle.js", preload: true # ✅ required by Chartkick
pin "@kurkle/color", to: "@kurkle--color.js" # @0.3.4
