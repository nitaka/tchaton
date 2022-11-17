import { createRouter, createWebHashHistory } from 'vue-router'
import Login from '../views/LoginView.vue'
import Setting from '../views/SettingView.vue'
import User from '../views/UserView.vue'
import Home from '../views/HomeView.vue'

const routes = [
  {
    path: '/',
    name: 'Login',
    component: Login
  },
  {
    path: '/home',
    name: 'Home',
    component: Home
  },
  {
    path: '/setting',
    name: 'Setting',
    component: Setting
  },
  {
    path: '/user/:userId',
    name: 'user',
    component: User,
  },
]

const router = createRouter({
  history: createWebHashHistory(),
  routes
})

export default router
