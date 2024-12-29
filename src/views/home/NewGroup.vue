<template>
    <div class="addGroup">
        <a-input size="small" v-model:value="groupName" placeholder="群聊名称"></a-input>
        <br>
        <br>
        <a-transfer :data-source="friendList" v-model:target-keys="selectedFriends" :show-search="true"
            :titles="['未选择', '已选择']" :render="item => item.nickname" @change="handleChange" />
        <a-button type="primary" style="margin: 20px 0 0 30px" @click="addGroupSubmit">新增群聊</a-button>
    </div>
</template>
<script setup>
import { ref, defineEmits } from 'vue';
import { useRouter } from 'vue-router'
import { message } from 'ant-design-vue';
import { useWsStore } from '@/store/wsStore'
import { addGroup, joinGroup, delGroup, delGroupUser } from '@/request/api'
const router = useRouter()
let uid = localStorage.getItem('uid')
let groupName = ref('')
const wsStore = useWsStore();
const friendList = JSON.parse(localStorage.getItem('friendList')) || []
friendList.forEach(item => {
    item.key = item.uid.toString()
})
const selectedFriends = ref([]); // 已转移的key
const handleChange = (nextTargetKeys) => {
    selectedFriends.value = nextTargetKeys;
    console.log(selectedFriends.value)
};

const emit = defineEmits(['close'])
let groupList = localStorage.getItem('groupList') ? JSON.parse(localStorage.getItem('groupList')) : []
const addGroupSubmit = () => {
    if (selectedFriends.value.length <= 1) {
        message.error('请选择至少2个好友')
        return
    }
    if (!groupName.value) {
        message.error('请输入群聊名称')
        return
    }
    selectedFriends.value.push(uid)
    let uids = selectedFriends.value.map(item => Number(item))
    addGroup({
        group_name: groupName.value,
        creator_id: uid,
        uids: [...new Set(uids)]
    }).then(async (res) => {
        if (res.code == 200) {
            message.success('创建群聊成功')
            console.log(res.data)
            await wsStore.wsSend(`create-${uids}`);
            //根据群id返回群信息
            // groupList.push({ groupId: "", creatorId:uid, })
            router.push({ name: 'message' })
        } else {
            message.error(res.msg)
        }
        emit('close')
    })
}


const removeSubmit = () => {
    delGroupUser(28, [1]).then(res => {
        console.log(res)
    })
}

const delgroupSubmit = () => {
    delGroup(28).then(res => {
        console.log(res)
    })
}

</script>

<style scoped>
.addGroup {
    padding: 20px;
}
</style>