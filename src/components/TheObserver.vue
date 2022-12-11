<template>
  <li class="observer"></li>
</template>

<script>
export default {
  name: "TheObserver",
  props: {
    options: {
      type: Object,
    },
  },
  data: () => ({
    observer: null,
  }),
  mounted() {
    const options = this.options || {};
    this.observer = new IntersectionObserver(([entry]) => {
      if (entry && entry.isIntersecting) {
        this.$emit("intersect");
      }
    }, options);

    this.observer.observe(this.$el);
  },
  destroyed() {
    this.observer.disconnect();
  },
};
</script>
