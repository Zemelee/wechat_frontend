<template>
    <a-form :model="userInfo" v-bind="layout" name="nest-messages">
        <a-form-item label="uid">
            <a-input v-model:value="userInfo.uid" :disabled="true" />
        </a-form-item>
        <a-form-item label="email">
            <a-input v-model:value="userInfo.email" :disabled="true" />
        </a-form-item>
        <a-form-item label="nickname" :rules="[{ required: true }]">
            <a-input v-model:value="userInfo.nickname" />
        </a-form-item>
        <a-form-item label="sign">
            <a-input v-model:value="userInfo.sign" />
        </a-form-item>
        <a-form-item label="avatar">
            <a-input v-model:value="userInfo.avatar" />
        </a-form-item>
        <a-form-item label="address">
            <a-input v-model:value="userInfo.address" />
        </a-form-item>
        <a-form-item label="createAt">
            <a-input v-model:value="userInfo.createAt" :disabled="true" />
        </a-form-item>
        <a-form-item :wrapper-col="{ ...layout.wrapperCol, offset: 2 }">
            <a-button type="primary" @click="updateMyInfo">Submit</a-button>
        </a-form-item>

    </a-form>
</template>


<script setup>
import { onMounted, reactive, toRaw } from 'vue'
import { updateInfo } from '@/request/api'
import { useUser } from '@/store/index'
import { storeToRefs } from 'pinia';
import { message } from "ant-design-vue"
// 用户相关store
const userStore = useUser()
const useUserStore = storeToRefs(userStore)
const userInfo = reactive({
    ...useUserStore.userInfo.value
});
onMounted(() => {
    userInfo.createAt = formatDateTime(userInfo.createAt)
})
const layout = {
    labelCol: { span: 5 },
    wrapperCol: { span: 13 },
};
const updateMyInfo = () => {
    updateInfo(userInfo).then(res => {
        if (res.code == 200) {
            userStore.setUserInfo(toRaw(userInfo))
            message.success('修改成功')
        } else {
            message.error(res.msg)
        }
    })
}

const formatDateTime = (dateTimeString) => {
    if (!dateTimeString) return '';
    const date = new Date(dateTimeString);
    const year = date.getFullYear();
    const month = String(date.getMonth() + 1).padStart(2, '0');
    const day = String(date.getDate()).padStart(2, '0');
    const hours = String(date.getHours()).padStart(2, '0');
    const minutes = String(date.getMinutes()).padStart(2, '0');
    const seconds = String(date.getSeconds()).padStart(2, '0');
    return `${year}-${month}-${day} ${hours}:${minutes}:${seconds}`;
}


</script>
