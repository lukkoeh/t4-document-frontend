<script setup>
import RTE from "./components/RTE.vue";
import LoginComponent from "./components/LoginComponent.vue";
import ProfileView from "./components/ProfileView.vue";
import DocumentSidebar from "./components/DocumentSidebar.vue";
import {onMounted, ref} from "vue";
import {useToast} from "vue-toast-notification";
const show_rte = ref(true);
const show_login = ref(true);
const show_profile_view = ref(false);
const show_document_sidebar = ref(true);
const $toast = useToast();
onMounted(() => {
  if (localStorage.getItem("token")) {
    show_login.value = false;
    $toast.success("You are logged in as " + localStorage.getItem("user_id"));
  }
});
</script>

<template>
  <div class="w-full h-screen bg-slate-900">
    <div class="w-full bg-slate-800 flex justify-between items-center h-1/6">
      <h1 class="text-3xl p-5 text-white">T4-Documents</h1>
      <div class="text-xl text-white flex justify-center items-center gap-5 mr-5">
        <button @click="show_profile_view = !show_profile_view" class="bg-blue-600 rounded p-5">Profile</button>
        <button @click="show_login = !show_login" class="bg-blue-600 rounded p-5">Login/Register</button>
      </div>
    </div>
    <div class="flex w-full h-5/6" v-if="show_document_sidebar">
      <DocumentSidebar @select-document="(document) => {
        $toast.info('Loading document: ' + document.document_title);
        this.$refs.rte.loadDocument(document)
      }" ref="docside"></DocumentSidebar>
      <div class="h-full w-full flex justify-center items-center">
        <RTE ref="rte" v-if="show_rte"/>
      </div>
    </div>
  </div>
  <LoginComponent v-if="show_login" @close-login-widget="show_login = false" @user-logged-in="this.$refs.docside.load()"/>
  <ProfileView v-if="show_profile_view" @close-profile-view="show_profile_view = false" @click="show_profile_view"/>
</template>

<style scoped>

</style>