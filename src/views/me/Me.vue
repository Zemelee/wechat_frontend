<template>
  <div class="me">

    <div class="top">
      <div class="avatar">
        <img :src="useUserStore.userInfo.value.avatar" style="width: 60px;border-radius: 6px;">
      </div>
      <div class="info">
        <div>{{ useUserStore.userInfo.value.nickname }}</div>
        <div style="color: #333;font-size: small;margin: 7px 0 7px 0;">微信号： {{ useUserStore.userInfo.value.email }}</div>
        <div style="color: #333;font-size: small;margin: 7px 0 7px 0;"> 地区：{{ useUserStore.userInfo.value.address }}</div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { storeToRefs } from 'pinia';
import { useUser } from '@/store/index'
const userStore = useUser()
const useUserStore = storeToRefs(userStore)
</script>

<style>
.me {
  padding:10px;
  height: 100px;
  /* border: 1px solid red; */
  background-color: #ffffff;
}

.top {
  display: flex;
  align-items: center;
  justify-content: space-around;
  width: 300px;
}

</style>