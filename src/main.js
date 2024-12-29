import { createApp } from 'vue'
import Antd from 'ant-design-vue';
import 'ant-design-vue/dist/reset.css';
import App from './App.vue'
import router from './router'
import { createPinia } from 'pinia'
const pinia = createPinia()


createApp(App).use(router).use(Antd).use(pinia).mount('#app')
