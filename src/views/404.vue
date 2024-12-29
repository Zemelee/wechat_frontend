<template>
  <h1> {{ countdown }}秒后跳转至首页,或者点击<a href="/">立即跳转</a> </h1>
  <p>已经查到考研成绩了,404分,很惊喜,也很意外。</p>
  <p>感谢自己这一年的努力。曾经的无数个日夜如今一一具象化。</p>
  <p>就是不知道后面那个not found是什么意思</p>
  <p>你真棒, 这么快就到404页面了....(大无语)</p>
</template>
<script setup>
import { onMounted, ref } from 'vue';
let countdown = ref(3)
onMounted(() => {
  setInterval(() => {
    countdown.value--
    if (countdown.value <= 0) {
      window.location.href = '/'
    }
  }, 1000)
})
</script>
<style></style>