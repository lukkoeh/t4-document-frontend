<script setup>
import {ref, defineExpose} from "vue";
import axios from "axios";

const documents = ref({});
defineExpose({load});
// eslint-disable-next-line no-unused-vars
function load() {
  // request the documents from the server
  // if the user is logged in
  if (localStorage.getItem("token")) {
    // request the documents
    let tempurl = "http://localhost:10001/documents/" + localStorage.getItem("user_id");
    axios({
      method: "get",
      url: tempurl,
      headers: {
        "X-Auth-Token": localStorage.getItem("token")
      }
    }).then((res) => {
      console.log(res.data);
      documents.value = res.data;
    }).catch((err) => {
      console.log(err);
    });
  }
}
</script>

<template>
  <div class="w-1/5 bg-slate-800 text-center text-white py-10 flex flex-col gap-5 items-center">
    <h1 class="text-2xl">Your Documents</h1>
    <div v-for="document in documents" :key="document.document_id" class="w-4/5 bg-slate-900 rounded-2xl p-5">
      <p>{{document.document_title}}</p>
      <p>{{document.document_created}}</p>
    </div>
  </div>
</template>

<style scoped>

</style>