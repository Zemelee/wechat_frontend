<template>
  <div class="root" @click="() => { showMe = false }">
    <div class="root-left">
      <!-- 消息列表 -->
      <div>
        <div>
          <img @click.stop="openMe($event)" :src="userInfo ? userInfo.avatar : null"
            style="width: 30px;cursor: pointer;" alt="">
          <Me :style="meStyle" ref="meRef" v-if="showMe"></Me>
        </div>
        <div style="padding-left: 5px;">

          <router-link to="/home/message" class="nav-link">
            <WechatOutlined :style="{ fontSize: '20px' }" />
          </router-link>
          <router-link to="/home/list" class="nav-link">
            <UserOutlined :style="{ fontSize: '20px' }" />
          </router-link>
          <router-link to="/home/group" class="nav-link">
            <UsergroupAddOutlined :style="{ fontSize: '20px' }" />
          </router-link>
          <!-- <div style="color: #aaa;margin: 25px 0 25px 0;display: block;">
            <FolderOutlined :style="{ fontSize: '20px' }" />
          </div> -->
          <router-link to="/home/ai" class="nav-link">
            <RedditOutlined :style="{ fontSize: '20px' }" />
          </router-link>
          <router-link to="/home/setting" class="nav-link">
            <SettingOutlined :style="{ fontSize: '20px' }" />
          </router-link>
          <a-popconfirm placement="bottomRight" title="确认退出?" ok-text="退出" cancel-text="取消"
            @confirm="()=>{router.push('/login')}">
            <router-link to="#" style="color: #aaa; margin: 25px 0 25px 0;display: block;">
              <LogoutOutlined :style="{ fontSize: '20px' }" />
            </router-link>
          </a-popconfirm>
        </div>
      </div>
      <!-- 搜索框 -->
      <div>
        <div class="root-search">
          <a-input v-model:value="useUserStore.searchWord.value" size="small"
            @keyup.enter="onSearch(useUserStore.searchWord.value)" style="width: 70%"
            @change="onSearchLocal(useUserStore.searchWord.value)" placeholder="搜索">
            <template #prefix>
              <SearchOutlined />
            </template>
          </a-input>
          <PlusSquareOutlined :style="{ fontSize: '20px', cursor: 'pointer' }"
            @click="() => { newGroupModal = !newGroupModal }" />
        </div>
        <SearchResult
          @closeDialog="() => { searchList.friendSearchResult = [], searchList.groupSearchResult = [], searchList.historySearchResult = [], userStore.setSearchWord('') }"
          :friendSearchResult="searchList.friendSearchResult" :groupSearchResult="searchList.groupSearchResult"
          :historySearchResult="searchList.historySearchResult"
          v-if="searchList.friendSearchResult.length > 0 || searchList.groupSearchResult.length > 0 || searchList.historySearchResult.length > 0"
          class="search-friends" />
        <!-- 昵称 -->
        <div class="root-nick">
          <Box v-show="useUserStore.curNickname.value">{{ useUserStore.curNickname.value }}</Box>
        </div>
      </div>
    </div>
    <div class="root-right">
      <router-view></router-view>
    </div>
  </div>
  <div class="new-group" v-show="newGroupModal">
    <NewGroup @close="() => { newGroupModal = !newGroupModal }"></NewGroup>
  </div>


</template>

<script setup>
import { computed, onMounted, reactive, ref } from 'vue'
import { getFriendList, searchFriend, getGroupList } from "@/request/api"
import { useRouter } from 'vue-router'
import { storeToRefs } from 'pinia';
import { useUser, myFriends } from '@/store/index'
import { useWsStore } from '@/store/wsStore'
import Box from '@/components/Box'
import NewGroup from "./NewGroup"
import Me from "../me/Me"
import SearchResult from "./SearchResult"
import { message } from 'ant-design-vue'
import {
  PlusCircleTwoTone, WechatOutlined, UserOutlined, UnorderedListOutlined, UserAddOutlined,
  SearchOutlined, PlusSquareOutlined, UsergroupAddOutlined, CodeSandboxOutlined, FolderOutlined,
  RedditOutlined, LogoutOutlined, SettingOutlined
} from '@ant-design/icons-vue'
const router = useRouter()
let wsStore = useWsStore()
const meRef = ref(null); // 用于引用 Me 组件实例
let showMe = ref(false)
const mePosition = ref({ x: 0, y: 0 });
const meStyle = computed(() => ({
  position: 'fixed',
  left: `${mePosition.value.x}px`,
  top: `${mePosition.value.y}px`
}));
let userInfo = localStorage.getItem('userinfo') ? JSON.parse(localStorage.getItem('userinfo')) : null
const openMe = (event) => {
  mePosition.value.x = event.clientX;
  mePosition.value.y = event.clientY;
  showMe.value = true;
};

const newGroupModal = ref(false);
// 用户相关store
const userStore = useUser()
const useUserStore = storeToRefs(userStore)
// 好友列表相关store
const friendStore = myFriends()
const useFriendStore = storeToRefs(friendStore)
let uid = localStorage.getItem('uid')
let groups = ref([])
onMounted(async () => {
  if (userInfo) {
    userStore.setUserInfo(userInfo)
  }
  const friendRes = await getFriendList(uid)
  if (friendRes.code == 200) {
    friendStore.setFriends(friendRes.data)
  } else {
    message.error(friendRes.msg)
  }

  const groupRes = await getGroupList(uid)
  if (groupRes.code == 200) {
    groups.value = groupRes.data
    localStorage.setItem('groupList', JSON.stringify(groupRes.data))
  } else {
    message.error(groupRes.msg)
  }
  if (!wsStore.ws) {
    wsStore.wsConnect(userInfo.uid)
  }

  // const msgs = await getMsgs(uid)
  // console.log(msgs)

  window.addEventListener('click', function (event) {
    showMe.value = false; // 关闭 Me 组件
  });

})
// [012-->好友列表、群聊列表、消息列表]
let searchList = reactive({
  "friendSearchResult": [],
  "groupSearchResult": [],
  "historySearchResult": []
})

const onSearchLocal = (keyword) => {
  if (!keyword) {
    searchList.friendSearchResult = []
    searchList.groupSearchResult = []
    searchList.historySearchResult = []
    return
  }
  //搜索本地好友
  useFriendStore.friends.value.forEach(item => item.isFriend = true) //设置isFriend方便搜索时展示 发消息|加好友
  let friendSearchResult = useFriendStore.friends.value.filter(item => item.nickname.includes(keyword))
  searchList.friendSearchResult = friendSearchResult

  //搜索本地群聊
  let myGroupList = localStorage.getItem("groupList") ? JSON.parse(localStorage.getItem("groupList")) : []
  let groupSearchResult = myGroupList.filter(item => item.groupName.includes(keyword))
  searchList.groupSearchResult = groupSearchResult

  // 搜索聊天记录
  let histories = JSON.parse(localStorage.getItem("histories")) || {}
  // 过滤出包含关键词的聊天记录
  let historySearchResult = Object.keys(histories).reduce((result, listIndex) => {
    const contentIndex = histories[listIndex].findIndex(history => history.content.includes(keyword));
    if (contentIndex !== -1) {
      result.push({ listIndex, contentIndex });
    }
    return result;
  }, []);
  searchList.historySearchResult = historySearchResult
}


let friendList = JSON.parse(localStorage.getItem("friendList")) || []
let friendIds = friendList.map(item => item.uid)
const onSearch = async (keyword) => {
  if (!keyword) {
    return;
  }
  const res = await searchFriend(keyword)
  if (res.code === 200) {
    searchList.friendSearchResult = res.data
    searchList.friendSearchResult.forEach(item => {
      item.isFriend = friendIds.includes(item.uid) ? true : false
    })
  } else {
    message.error(res.msg)
  }
}

</script>

<style scoped>
[aria-hidden="true"] {
  display: none !important;
}

/* 将导航栏设置为灰色，并且固定在屏幕最左边 */
.root {
  display: flex;
}

.nav-link {
  display: block;
  margin: 25px 0 25px 0;
}

.nav-link .anticon {
  margin-bottom: 5px;
  /* 图标与文字之间的间距 */
  color: #aaa;
  /* 默认颜色 */
}

.nav-link.router-link-exact-active,
.nav-link.router-link-active {
  background-color: #333;
  color: #07c160;
}

.nav-link.router-link-exact-active .anticon,
.nav-link.router-link-active .anticon {
  color: #07c160;
}


.root-left {
  width: 5vw;
  height: 100vh;
  background-color: #2e2e2e;
  display: flex;
  flex-direction: column;
  justify-content: space-between;
  align-items: center;
  padding: 20px;
  z-index: 1000;
  position: relative;
}

.root-left .root-search {
  padding-left: 5px;
  padding-right: 5px;
  padding-top: 5px;
  position: absolute;
  left: 5vw;
  top: 0px;
  width: 20vw;
  display: flex;
  justify-content: space-around;
  align-items: center;
}

.root-left .root-nick {
  position: absolute;
  top: 5px;
  left: 27vw;
}


.root-right {
  position: relative;
  top: 6vh;
  width: 90%;
  height: 94vh;
  background-color: #fff;
  /* overflow: scroll; */
}

/* 新建群组弹窗 */
.new-group {
  position: absolute;
  top: 40%;
  left: 50%;
  transform: translate(-50%, -50%);
  width: 38vw;
  /* height: 60vh; */
  background-color: #efecec;
  border-radius: 20px;
  box-shadow: 0 0 10px rgba(0, 0, 0, 0.5);
}
</style>