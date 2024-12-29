<template>
  <div class="friend-container">
    <div class="friend-list">
      <div v-for="(item, index) in useFriendStore.friends.value" :key="index" @click="() => { curFriend = item;curGroup = null }"
        class="friend-item">
        <img :src="item.avatar" alt="group_avator" class="group-avator">
        <span class="group-name">{{ item.nickname }}</span>
      </div>
      <a-divider></a-divider>
      <div v-for="(item, index) in groups" :key="index" class="friend-item" @click="() => { curGroup = item; curFriend = null }">
        <img :src="item.groupAvatar" alt="group_avator" class="group-avator">
        <span class="group-name">{{ item.groupName }}</span>
      </div>
    </div>
    <FriendInfo :curFriend="curFriend" v-show="curFriend" />
    <GroupInfo :curGroup="curGroup" v-show="curGroup"/>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { storeToRefs } from 'pinia';
import { myFriends } from '@/store/index'
import FriendInfo from './FriendInfo.vue';
import GroupInfo from './GroupInfo.vue';
const friendStore = myFriends()
const useFriendStore = storeToRefs(friendStore)
const curFriend = ref(null)
const uid = localStorage.getItem('uid')
let groups = JSON.parse(localStorage.getItem('groupList')) || []


const curGroup = ref(null)


</script>

<style scoped>
.friend-container {
  display: flex;
  width: 100%;
  height: 100%;
}

.friend-list {
  background-color: #f8f8f8;
  padding: 10px;
  width: 20vw;
  height: 100%;
  border: 1px solid #333;
}

.friend-item {
  cursor: pointer;
  display: flex;
  align-items: center;
  padding: 10px;
  border-bottom: 1px solid #c1c1c1;
}
.friend-item:hover {
  background-color: #e6e6e6;
}

.group-avator {
  width: 30px;
  height: 30px;
  border-radius: 4px;
  margin-right: 40px;
}


.group-name {
  font-size: 16px;
  color: #333;
  line-height: 1.8;
  width: 100px;
}
</style>
