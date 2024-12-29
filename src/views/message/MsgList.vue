<template>
  <div>
    <div v-for="item in curChatList" :key="item.uid" @click="HandleClick(item.uid)" class="chat-item">
      <img :src="item.avatar" :alt="item.nickname" style="height:40px">
      <!-- {{ item }} -->
      <div>
        <span class="chat-name"> {{ item.nickname }}</span>
        <span class="chat-time">{{ formatTime(item.lastTime) }}</span>
        <div class="chat-lastMsg">{{ item.lastMsg }}</div>
        
      </div>
    </div>
  </div>
</template>

<script setup>
import { onMounted, watch, onUnmounted, computed } from 'vue'
import { formatTime } from '@/utils/index'
import { useUser } from '@/store/index'
import { useWsStore } from '@/store/wsStore'
import { useChatListStore } from '../../store/chatListStore'
const useUserStore = useUser()
const wsStore = useWsStore()

const chatListStore = useChatListStore();
 
const uid = localStorage.getItem('uid')
// [(用户信息+最新消息+时间)]
const curChatList = computed(() => {
  return chatListStore.getChatList;
});
const histories = computed(() => wsStore.getHistory);
let friendList = JSON.parse(localStorage.getItem('friendList')) || [] //好友列表，包含账户信息
onMounted(() => {
  wsStore.watchHistory()
  chatListStore.updateChatList(friendList, histories.value);
  chatListStore.persistChatList();
})
watch(() => wsStore.histories, (newVal, oldVal) => {
  chatListStore.updateChatList(friendList, histories.value);
  chatListStore.persistChatList(); //chatList存到缓存里
}, { deep: true })

// const emit = defineEmits(['sendUid'])
//将uid传给父组件
const HandleClick = (uid) => {
  wsStore.setCurGid(uid); //设置当前聊天对象
  let nickname = curChatList.value.find(item => item.uid == uid).nickname
  useUserStore.setCurNickname(nickname)
}
onUnmounted(()=>{
  useUserStore.setCurNickname("")
  wsStore.setCurGid(null)
})

</script>

<style scoped>
.chat-item {
  width: 100%;
  height: 60px;
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 10px;
  cursor: pointer;
  transition: all .3s;
  box-sizing: border-box;
  border: 1px solid #ccc;
  position: relative;
}

.chat-item:hover {
  background-color: #f5f5f5;
}

.chat-name {
  position: absolute;
  left: 55px;
  top: 10px;
}

.chat-time {
  position: absolute;
  right: 15px;
  top: 10px;
  color: #999;
  font-size: 12px;
}

.chat-lastMsg {
  position: absolute;
  left: 55px;
  top: 35px;
  color: #999;
  font-size: 12px;
  width: 60%;
  /* 最多显示一行，显示省略号 */
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
  height: 20px;
  line-height: 20px;
  display: inline-block;
  vertical-align: middle;
}
</style>