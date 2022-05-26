module.exports = {
  content: [
    "src/pages/**/*.cr",
    "public/js/**/*.js",
    "src/components/**/*.cr"
  ],
  theme: {
    screens: {
      sm: '640px',
      md: '768px',
      lg: '1024px',
      xl: '1280px'
    },
    extend: {
      colors: {
        brand: '#ed03ff',
        'electric-green': '#13ff02',
        'bright-pink': '#ef03ff',
        'electric-blue': '#02ffee',
        'light-brown': '#c7c76d',
        'warm-yellow': '#face43',
        'dark-red': '#cf593c'
      }
    }
  },
  variants: {},
  plugins: [
    require('@tailwindcss/typography')
  ],
}
