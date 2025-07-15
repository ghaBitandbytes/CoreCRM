// tailwind.config.js
module.exports = {
  content: [
    './app/views/**/*.{html,erb}',
    './app/helpers/**/*.rb',
    './app/javascript/**/*.js'
  ],
  theme: {
    extend: {
      keyframes: {
        ring: {
          '0%': { transform: 'rotate(0deg)' },
          '15%': { transform: 'rotate(15deg)' },
          '30%': { transform: 'rotate(-10deg)' },
          '45%': { transform: 'rotate(5deg)' },
          '60%': { transform: 'rotate(-5deg)' },
          '75%': { transform: 'rotate(2deg)' },
          '100%': { transform: 'rotate(0deg)' }
        }
      },
      animation: {
        ring: 'ring 0.7s ease-in-out'
      }
    }
  },
  plugins: []
}
