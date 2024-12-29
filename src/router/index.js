import { createRouter, createWebHashHistory } from 'vue-router'

const Login = () => import('@/views/login/Login.vue')
const Home = () => import('@/views/home/Home.vue')
const Message = () => import('@/views/message/Message.vue')
const Group = () => import('@/views/message/Group.vue')
const FriendList = () => import('@/views/friends/FriendList.vue')
const Me = () => import('@/views/me/Me.vue')
const Setting = () => import('@/views/me/Setting.vue')
const AI = () => import('@/views/ai/AI.vue')

const routes = [
    { path: '/login', component: Login },
    {
        path: '/home',
        component: Home,
        redirect: '/home/message',
        children: [{
            path: 'message/:uid?',
            name: 'message',
            component: Message,
        }, {
            path: 'group/:gid?',
            name: 'group',
            component: Group,
        }, {
            path: 'list',
            name: 'list',
            component: FriendList,
        }, {
            path: 'me',
            name: 'me',
            component: Me,
        }, {
            path: 'setting',
            name: 'Setting',
            component: Setting,
        }, {
            path: 'ai',
            name: 'ai',
            component: AI,
        }]
    },
    { path: '/', redirect: '/home' },

    { path: '/404', component: () => import('@/views/404.vue') },
    { path: '/:pathMatch(.*)*', redirect: '/404' },
];

const router = createRouter({
    history: createWebHashHistory(),
    routes: routes
})

// router.beforeEach((to, from, next) => {
//     if (to.path === '/login') {
//         next()
//     } else {
//         if (!token) {
//             next('/login')
//         } else {
//             next() // 如果有token,放行
//         }

//     }

// })


export default router