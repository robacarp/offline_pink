module.exports = {
  content: [
    "src/pages/**/*.cr",
    "src/js/**/*.js",
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
        electric_green: '#13ff02',
        bright_pink: '#ef03ff',
        electric_blue: '#02ffee',
        light_brown: '#c7c76d',
        warm_yellow: '#face43',
        dark_red: '#cf593c'
      }
    }
  },
  variants: {},
  plugins: [
    require('@tailwindcss/typography')
  ],
}
