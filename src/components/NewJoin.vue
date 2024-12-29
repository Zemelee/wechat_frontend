<template>
    <div class="addGroup">
        <a-transfer :data-source="friendList" v-model:target-keys="selectedFriends" :show-search="true"
            :titles="['未选择', '已选择']" :render="item => item.nickname" @change="handleChange" />
        <a-button type="primary" style="margin: 20px 0 0 30px" @click="addUserSubmit">确认</a-button>
    </div>
</template>
<script setup>
import { ref, defineEmits } from 'vue';
import { useRouter } from 'vue-router'
import { message } from 'ant-design-vue';
import { joinGroup } from '@/request/api'
const router = useRouter()
let uid = localStorage.getItem('uid')
const props = defineProps({
    gid: {
        type: Number,
        required: true
    }
})
const friendList = JSON.parse(localStorage.getItem('friendList')) || []
friendList.forEach(item => {
    item.key = item.uid.toString()
})
const selectedFriends = ref([]); // 已转移的key
const handleChange = (nextTargetKeys) => {
    selectedFriends.value = nextTargetKeys;
};

const emit = defineEmits(['close'])
const addUserSubmit = () => {
    let uids = selectedFriends.value.map(item => Number(item))
    if(uids.length==0){
        message.error('请选择好友')
        return
    }
    joinGroup(props.gid, uids).then(res => {
        if (res.code == 200) {
            message.success('邀请成功')
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


</script>

<style scoped>
.addGroup {
    padding: 20px;
}
</style>