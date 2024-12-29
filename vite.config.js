// vite.config.js
import { defineConfig } from 'vite';
import vue from '@vitejs/plugin-vue';
import { resolve } from 'path'
export default defineConfig({
  base: './',
  plugins: [vue()],
  build: {
    assetsInlineLimit: 1024 * 60,// 10kb以下.转Base64
    target: 'es2015',
    outDir: 'dist',
    rollupOptions: {
      output: {
        entryFileNames: '[name]-[hash].js', // 引入文件名的名称
        chunkFileNames: '[name]-[hash].js', // 包的入口文件名称
        assetFileNames: '[name]-[hash].[ext]'  // 资源文件像 字体，图片等
      }
    }
  },
  resolve: {
    alias: {
      "@": resolve(__dirname, 'src'),
    },
    extensions: ['.vue', '.js'] // 导入时想要省略的扩展名列表
  },
  server: {
    proxy: {
      '/api': {
        target: 'http://sugarblack.top:8084',
        changeOrigin: true,
        rewrite: (path) => path.replace(/^\/api/, "")
      }
    },

  },

});
