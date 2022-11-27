<template>
  <div id="app">
    <vue-inline-calendar />

    <vue-inline-calendar :spec-min-date="new Date()" />

    <vue-inline-calendar :spec-max-date="new Date()" />

    <vue-inline-calendar disable-weekends />

    <vue-inline-calendar is-range />

    <vue-inline-calendar is-range disable-weekends />
  </div>
</template>

<script>
import VueInlineCalendar from "@/components/VueInlineCalendar";

export default {
  name: "App",
  components: {
    VueInlineCalendar,
  },
};
</script>

<style lang="scss">
#app {
  font-family: Avenir, Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-align: center;
  color: #2c3e50;
  margin-top: 60px;
}
</style>
