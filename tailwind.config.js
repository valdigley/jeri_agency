/** @type {import('tailwindcss').Config} */
export default {
  content: [
    "./index.html",
    "./src/**/*.{js,ts,jsx,tsx}",
  ],
  theme: {
    extend: {
      fontFamily: {
        sans: ['Inter', 'system-ui', 'sans-serif'],
      },
      colors: {
        yellow: {
          500: '#EAB308',
          600: '#CA8A04',
        }
      },
      animation: {
        'fade-in': 'fadeIn 1s ease-in-out',
        'fade-in-delay': 'fadeIn 1s ease-in-out 0.2s both',
        'fade-in-delay-2': 'fadeIn 1s ease-in-out 0.4s both',
        'fade-in-delay-3': 'fadeIn 1s ease-in-out 0.6s both',
        'fade-in-delay-4': 'fadeIn 1s ease-in-out 0.8s both',
      },
      keyframes: {
        fadeIn: {
          '0%': { opacity: '0', transform: 'translateY(20px)' },
          '100%': { opacity: '1', transform: 'translateY(0)' },
        }
      }
    },
  },
  plugins: [],
}